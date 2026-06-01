using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Random = System.Random;
using Resources = UnityEngine.Resources;

#if  UNITY_EDITOR
using UnityEditor.SceneManagement;
#endif

public interface IBoardTickUpdateListener
{
    void OnBoardTickUpdated(uint boardTick);
    void OnPaused();
    void OnResumed();
}

public partial class GameBoardManager : WrappedEventBehaviour
{
    private static GameBoardManager _instance;

    public static GameBoardManager Get()
    {
        return _instance ? _instance : null;
    }

    public GameBoard gameBoard => _gameBoard;
    private GameBoard _gameBoard;

    public MapRoot_Old mapRootOld { get; private set; }

    [SerializeField] private GameObject m_GameUnitObjectPrefab;

    public MapScreen mapScreen;
    public MapRoot mapRoot { get; private set; }

    public Transform trModeManagerParent;
    public ZModeManagerBase modeManager { get; private set; }

    public ModeManager GetModeManager<ModeManager>() where ModeManager : ZModeManagerBase
    {
        var manager = modeManager as ModeManager;
        return manager != null ? manager : null;
    }

    public readonly Dictionary<long, GameUnitObject> UnitObjectById = new(100);
    public readonly Dictionary<long, GameSkillObject> SkillObjectById = new(100);
    public readonly Dictionary<long, GameDropItemObject> DropItemObjectById = new(100);

    private bool _clearLog = false;
    private bool _blockShowGameResult = false;
    private bool _forceUpdateGameBoard = false;
    public override void Awake()
    {
        base.Awake();
        if (_gameBoard == null)
        {
            SyncBoard(MyPlayer.GameBoard);
        }

        Debug.Log("New GameBoardManager created");

    }

    public GameUnitObject GetUnitByID(long id)
    {
        return UnitObjectById.GetValueOrDefault(id);
    }

    public GameSkillObject GetSkillByID(long id)
    {
        return SkillObjectById.GetValueOrDefault(id);
    }

    public GameDropItemObject GetDropItemByID(long id)
    {
        return DropItemObjectById.GetValueOrDefault(id);
    }

    public void RemoveUnitByID(long id)
    {
        UnitObjectById.Remove(id);
    }

    public void RemoveSkillByID(long id)
    {
        SkillObjectById.Remove(id);
    }

    public void RemoveDropItemByID(long id)
    {
        DropItemObjectById.Remove(id);
    }

    private readonly Dictionary<long, Queue<GameObject>> _pools = new(200);

    private void ClearAllPool()
    {
        foreach (var gameObjects in _pools.Values)
        {
            while (gameObjects.Count > 0)
            {
                var go = gameObjects.Dequeue();
                if (go)
                {
                    Destroy(go);
                }
            }
        }
    }

    // TODO: upgrade pooling system to be more efficient; maybe pool by types?
    public long RentFromPool(GameObject prefab, Vector3 pos, Quaternion rotation, Transform parent, out GameObject go,
        long poolID = -1)
    {
        var id = poolID == -1 ? prefab.GetInstanceID() : poolID;
        if (_pools.TryGetValue(id, out var pool) && pool.Count > 0)
        {
            go = pool.Dequeue();
            if (go)
            {
                var goTransform = go.transform;
                goTransform.SetParent(parent ?? transform, false);
                goTransform.localPosition = pos;
                goTransform.localRotation = rotation;
                goTransform.localScale = prefab.transform.localScale;
                go.SetActive(true);
                return id;
            }
        }

        go = Instantiate(prefab, parent);
        var tr = go.transform;
        tr.localPosition = pos;
        tr.localRotation = rotation;
        return id;
    }

    public void ReturnToPool(long poolID, GameObject go, int capacity = 100)
    {
        go.SetActive(false);
        go.transform.SetParent(transform, false);
        if (!_pools.TryGetValue(poolID, out var pool))
            _pools[poolID] = pool = new Queue<GameObject>(capacity);
        pool.Enqueue(go);
    }

    public const float BoardServerSyncInterval = 5f;

    private float _syncTimer = 0f;
    private double _serverSyncTimer;

    private float _boardUpdateScale = 1f;
    private float _gameSpeedScale = 1f;
    private double _nextGameSpeedScaleRefreshTime;

    public float BoardUpdateScale
    {
        get => _boardUpdateScale * _gameSpeedScale;
        set
        {
            _boardUpdateScale = value == 0 ? 1f : value;
            _syncTimer = BoardUpdateTick; // reset tick according to new scale
        }
    }

    public float GameSpeedScale
    {
        get => _gameSpeedScale;
        set
        {
            _gameSpeedScale = ResourceItem.NormalizeGameSpeedMultiplier(value);
            _syncTimer = BoardUpdateTick;
        }
    }

    public float BoardUpdateTick => GameBoard.TickDuration / BoardUpdateScale;

    private double _boardLastUpdatedTime = 0f;
    private bool _gameBoardInitialized;
    private bool _gameBoardLoading;

    private readonly HashSet<string> _boardPauseRequests = new();
    public bool BoardPaused => _boardPauseRequests.Count > 0 || _gameBoard?.State >= GameBoard.Types.State.Ended;

    private bool _blockBoardPacketSending;

#if UNITY_EDITOR
    private double _mushroomDebugNextLogTime;
    private uint _mushroomDebugLastTick;
#endif

    private readonly HashSet<IBoardTickUpdateListener> _boardTickUpdateListeners = new();

    public void AddBoardTickUpdateListener(IBoardTickUpdateListener listener)
    {
        _boardTickUpdateListeners.Add(listener);
    }

    public void RemoveBoardTickUpdateListener(IBoardTickUpdateListener listener)
    {
        _boardTickUpdateListeners.Remove(listener);
    }

    private void UpdateGameBoardSyncTimer()
    {
        _syncTimer -= Time.unscaledDeltaTime;
        if (_syncTimer <= 0f)
        {
            _syncTimer = Mathf.Max(0f, BoardUpdateTick + _syncTimer);
            PreUpdateGameBoard();
            UpdateGameBoardInternal();
            PostUpdateGameBoard();
        }
    }

    //실제 보드 Update와 직접적으로 연관된 로직만 BoardPaused에 영향 받도록 해당 함수 내에 정의
    private void UpdateGameBoardInternal()
    {
        if (BoardPaused)
        {
            FXSystem.Pause();
            return;
        }

        if (_forceUpdateGameBoard || _gameBoard.State < GameBoard.Types.State.Ended)
        {
            _forceUpdateGameBoard = false;
            _gameBoard.EarlyUpdate();
            _gameBoard.HandleInput();
            _gameBoard.PostprocessUpdatesAndActions();
            _gameBoard.Update();
            _gameBoard.PostUpdate();

            _boardTickUpdateListeners.RemoveNullReferences();
            foreach (var listener in _boardTickUpdateListeners)
            {
                listener.OnBoardTickUpdated(_gameBoard.Tick);
            }
        }
        else
        {
            ClearQueuedPackets();
            return;
        }

        if (NetworkSystem.enableSocketConnection)
            RecordTick();

        _boardLastUpdatedTime = TimeSystem.time;
    }

    private void PostUpdateGameBoard()
    {
        while (_boardPauseRequestsQueue.TryPeek(out var key, out var tick))
        {
            if (tick > _gameBoard.Tick)
                break; // wait until the tick is reached

            _boardPauseRequestsQueue.Dequeue();
            _boardPauseRequests.Add(key);
        }
    }

    private void PreUpdateGameBoard()
    {
        var boardReplaced = _shouldReplaceBoard;
        if (_shouldReplaceBoard)
        {
#if UNITY_EDITOR
            Debug.LogWarning($"[디버깅] 보드 리셋 | 클라: {_gameBoard.Tick} 서버: {MyPlayer.GameBoard.Tick}, 마지막으로 보낸 틱 : {lastBoardPacketSentTick}");
#endif
            // todo: 플래그 사용을 좀 더 예쁘게 하자
            if (_shouldInitBoardWhenReplacing)
            {
                SetBoard(MyPlayer.GameBoard);
                _shouldInitBoardWhenReplacing = false;
            }
            else
            {
                _gameBoard = MyPlayer.GameBoard;
                RecordTick();
                BlockBoardPacketSending(false);
                ClearQueuedPackets();
            }
            _shouldReplaceBoard = false;
            GameManager.Get().DispatchEvent(GameEventType.GAMEBOARD_REPLACED);
        }

        if (!_gameBoardInitialized)
            return;

        // MyPlayer에 의한 관리 구조 유지하는 게 멀티 플레이어 대비용으로 좋음
        if (MyPlayer.ShouldUpdateMyPlayerGameUnit)
        {
            if (MyPlayer.Player != null && MyPlayer.PlayerAvatar != null &&
                gameBoard.Players.TryGetValue(MyPlayer.Player.Id, out var myBoardPlayer))
            {
                var newBoardPlayer = myBoardPlayer.Clone();
                newBoardPlayer.Level = MyPlayer.PlayerLevel;
                newBoardPlayer.Board = Get().gameBoard;
                MyPlayer.PlayerItemStat.CopyTo(newBoardPlayer.ItemStat);

                UpdateBoardMyPlayer(MyPlayer.PlayerAvatar, false, newBoardPlayer);

                GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_STATS_UPDATED)); // todo: 중복으로 보내는데, 뺄지 정하기

                MyPlayer.ShouldUpdateMyPlayerGameUnit = false;
            }
            else if (MyPlayer.Player != null && MyPlayer.PlayerAvatar != null && IsLocalMushroomerBoard())
            {
                var newBoardPlayer = new BoardPlayerMessage
                {
                    Id = MyPlayer.Player.Id,
                    Level = MyPlayer.PlayerLevel,
                    Board = Get().gameBoard,
                };
                MyPlayer.PlayerItemStat.CopyTo(newBoardPlayer.ItemStat);

                UpdateBoardMyPlayer(MyPlayer.PlayerAvatar, false, newBoardPlayer);
            }
        }

        if (MyPlayer.ShouldUpdateGameboardAchievements || (_gameBoard.ResMap != null && _gameBoard.ResMap.ReferenceAchievementDataIds.Count != _gameBoard.Achievements.Count))
        {
            if (_gameBoard.Achievements.Count > 0)
            {
                foreach (var ach in _gameBoard.Achievements.Values)
                {
                    var myAchievement = MyPlayer.GetAchievementByDataID(ach.AchievementDataId);
                    if (ach.State < myAchievement.State || ach.Progress < myAchievement.Progress)
                    {
                        ach.State = myAchievement.State;
                        ach.Progress = myAchievement.Progress;
                    }
                }
            }
            else
            {
                _gameBoard.Achievements.Clear();
                foreach (var achievementDataId in _gameBoard.ResMap.ReferenceAchievementDataIds)
                {
                    var achievement = MyPlayer.GetAchievementByDataID(achievementDataId);
                    if (achievement != null)
                        _gameBoard.Achievements.Add(achievementDataId, achievement);
                    else
                        _gameBoard.Achievements.Add(achievementDataId, new PlayerAchievementMessage
                        {
                            AchievementDataId = achievementDataId,
                            State = PlayerAchievementMessage.Types.State.Disabled,
                        });
                }
            }
            UpdateBoardAchievement(_gameBoard.Achievements.Values);
            MyPlayer.ShouldUpdateGameboardAchievements = false;
        }

        // Client logics
        if (MyPlayer.ShouldUpdateMyPlayerHUD)
        {
            if (modeManager is ZModeManagerLobby lobbyModeManager)
                lobbyModeManager.RefreshPlayerInfo();
            MyPlayer.ShouldUpdateMyPlayerHUD = false;
        }

        if (boardReplaced && gameBoard.State == GameBoard.Types.State.Ended)
            ShowGameResult().Forget();
    }

    private Vector2 _lastDpadDirection = Vector2.zero;

    private bool IsLocalMushroomerBoard()
    {
        return _gameBoard?.isLocalBoard == true
            && _gameBoard.ResMap?.PopupArgs.TryGetValue("ClientModeManager", out var modeManager) == true
            && modeManager == nameof(ModeManagerMushroom);
    }

    private void UpdateDpad()
    {
        var dpadDirection = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        dpadDirection.Normalize();
        if (_lastDpadDirection == dpadDirection)
            return;

        UpdateDirectionMove(dpadDirection);
        _lastDpadDirection = dpadDirection;
    }

    private float timer = 0f;
    private void Update()
    {
        // Can be null LoginScene to directly go to InGame
        if (_gameBoard == null)
            return;

        if (TimeSystem.time >= _nextGameSpeedScaleRefreshTime)
        {
            _nextGameSpeedScaleRefreshTime = TimeSystem.time + 1d;
            MyPlayer.RefreshGameSpeedMultiplier();
        }

        //UpdateDpad();
//
//        timer += Time.deltaTime;
//        while (timer > 0f)
//        {
//            timer -= UnityEngine.Random.Range(1f, 2.2f);
//            var randomXY = Utility.RandomInsideUnitCircle(5f, 2f);
//
//            ResourceUnit resUnit = null;
//            while (resUnit == null)
//                resUnit = ResourceUnit.Get(UnityEngine.Random.Range(10010011, 10010113));
//            
//            CheatManager.HandleInputCheat($"/spawn {resUnit.Id} {randomXY.x} {randomXY.y}");
//        }

        if (_gameBoardInitialized)
        {
            UpdateGameBoardSyncTimer();
        }

#if UNITY_EDITOR
        //DebugDumpGameBoard();
#endif

        if (!_gameBoardInitialized)
        {
            if (_gameBoardLoading)
            {
#if UNITY_EDITOR
                DebugLogMushroomBoardState();
#endif
                return;
            }

            // Debug.LogWarning($"[Hormon] Init GameBoard: {_gameBoard.Id} {_gameBoard.DataId}");

            if (UsesBoardReplaySync())
            {
                SendSkipBoard();
            }
            GameManager.Get().DispatchEvent(GameEventType.MAP_RELEASED);
            ClearUnits(true);
            ClearSkills(true);
            ClearDropItems(true);
            ClearAllPool();
            _gameBoardLoading = true;
            StartCoroutine(LoadMap(gameBoard.ResMap, () =>
            {
                // if (!NetworkSystem.enableSocketConnection)
                // {
                //     AddMyUnitOffline(Vector2.zero, new Vector2(-3f, 10f));
                // }

                _gameBoardInitialized = true;
                _gameBoardLoading = false;
                _syncTimer = 0f;
                _blockShowGameResult = false;
                _serverSyncTimer = TimeSystem.time + (UsesBoardNoReplaySync()
                    ? gameBoard.ResMap.GetBoardValidationSamplingIntervalSeconds()
                    : BoardServerSyncInterval);
                lastBoardPacketSentTick = _gameBoard.Tick;
            }));

            BlockBoardPacketSending(false);
#if UNITY_EDITOR
            DebugLogMushroomBoardState();
#endif
            return;
        }
        else
        {
            if (_gameBoard.ResMap != null && !BoardPaused)
            {
                SyncBoardUnits();
                SyncBoardSKills();
                SyncBoardDropItems();

                MyPlayer.HandleBoardPlayer(_gameBoard.GetPlayerById(MyPlayer.Player.Id));
            }

            FlushEvents();
        }

        if (NetworkSystem.enableSocketConnection && gameBoard?.ResMap?.Type != ResourceMap.Types.Type.Lobby)
        {
            if (!BoardPaused && _serverSyncTimer < TimeSystem.time)
            {
                if (UsesBoardReplaySync())
                {
                    SendGetBoardHash();
                    _serverSyncTimer = TimeSystem.time + BoardServerSyncInterval;
                }
                else if (UsesBoardNoReplaySync())
                {
                    MaybeSendNoReplayValidationProbe();
                    _serverSyncTimer = TimeSystem.time + gameBoard.ResMap.GetBoardValidationSamplingIntervalSeconds();
                }
            }

            if (UsesBoardReplaySync() && !BoardPaused && lastBoardPacketSentTick + 30 < _gameBoard.Tick)
            {
                SendSkipBoard();
            }
        }

#if UNITY_EDITOR
        DebugLogMushroomBoardState();
#endif
    }

#if UNITY_EDITOR
    private void DebugLogMushroomBoardState()
    {
        if (!IsLocalMushroomerBoard())
            return;
        if (Time.realtimeSinceStartupAsDouble < _mushroomDebugNextLogTime)
            return;

        _mushroomDebugNextLogTime = Time.realtimeSinceStartupAsDouble + 1d;
        var tick = _gameBoard.Tick;
        var tickDelta = tick - _mushroomDebugLastTick;
        _mushroomDebugLastTick = tick;

        Debug.Log(
            "[MushroomTick] " +
            $"tick={tick} delta={tickDelta} " +
            $"initialized={_gameBoardInitialized} loading={_gameBoardLoading} paused={BoardPaused} state={_gameBoard.State} " +
            $"pauseRequests={_boardPauseRequests.Count} queuedPauseRequests={_boardPauseRequestsQueue.Count} " +
            $"units={_gameBoard.Units.Count} enemies={_gameBoard.GetUnitCountByTeam(GameBoard.Team.Enemy)} " +
            $"skills={_gameBoard.Skills.Count} modeManager={(modeManager ? modeManager.GetType().Name : "null")}");
    }
#endif

    private readonly PriorityQueue<string, uint> _boardPauseRequestsQueue = new();
    private const string DefaultPauseRequestKey = "Default";

    [Button]
    public void PauseBoard(string requestKey = DefaultPauseRequestKey, uint pauseDelay = 1)
    {
        if (_boardPauseRequests.Contains(requestKey))
            return;
        
        Debug.Log($"Pausing board: {requestKey}");
        _boardPauseRequestsQueue.Enqueue(requestKey, _gameBoard.Tick + Math.Max(1, pauseDelay));
    }

    public void ResumeBoard(string requestKey = DefaultPauseRequestKey)
    {
        _boardPauseRequests.Remove(requestKey);
        Debug.Log($"Resume board: {requestKey}");
    
        using var lazyRequests = PooledList<(string, uint)>.Get();
        while (_boardPauseRequestsQueue.TryDequeue(out var key, out var tick))
        {
            if (key == requestKey)
                continue;

            lazyRequests.Add((key, tick));
        }

        _boardPauseRequestsQueue.EnqueueRange(lazyRequests);

        if (!BoardPaused)
        {
            FXSystem.Resume();
        }
    }

    public void ClearBoardPauseRequests()
    {
        _boardPauseRequests.Clear();
        _boardPauseRequestsQueue.Clear();

        if (!BoardPaused)
        {
            FXSystem.Resume();
        }
    }

    public void ClearQueuedPackets()
    {
        _gameBoard?.ClearActions();
        _gameBoard?.ClearUpdates();
        _gameBoard?.ClearEvents();
    }

    public void BlockBoardPacketSending(bool block)
    {
        _blockBoardPacketSending = block;
    }

    public double GetBoardLastUpdatedTime()
    {
        return _boardLastUpdatedTime;
    }

    public void SendGetBoardHash()
    {
        if (!CanSendBoardPacket())
            return;

        var getBoardReq = new GetBoardRequest
        {
            GetHash = true,
        };
        var getBoardPacket = Packet.Pop(0, getBoardReq);
        ZWorldClient.Get().SendPacket(getBoardPacket).Forget();
    }

    private bool UsesBoardReplaySync()
    {
        return gameBoard?.ResMap?.UsesBoardReplaySync() == true;
    }

    private bool UsesBoardNoReplaySync()
    {
        return gameBoard?.ResMap?.UsesBoardNoReplaySync() == true;
    }

    private void MaybeSendNoReplayValidationProbe()
    {
        if (!UsesBoardNoReplaySync())
            return;

        var samplingRate = gameBoard.ResMap.GetBoardValidationSamplingRate();
        if (samplingRate <= 0f)
            return;

        if (UnityEngine.Random.value > samplingRate)
            return;

        SendNoReplayValidationProbe();
    }

    public void SendNoReplayValidationProbe()
    {
        if (!CanSendBoardPacket())
            return;

        var probePayload = BoardValidationProbe.Encode(_gameBoard.Tick, _gameBoard.GetHashCode());
        var probePacket = Packet.Pop(0, new SkipBoardRequest
        {
            Tick = probePayload,
        });
        ZWorldClient.Get().SendPacket(probePacket).Forget();
    }

    public void SendSkipBoard()
    {
        if (!CanSendBoardPacket())
            return;

        if (UsesBoardNoReplaySync())
        {
            SendNoReplayValidationProbe();
            return;
        }

        var getBoardPacket = Packet.Pop(0, new SkipBoardRequest()
        {
            Tick = _gameBoard.Tick,
        });
        ZWorldClient.Get().SendPacket(getBoardPacket).Forget();

        lastBoardPacketSentTick = _gameBoard.Tick;
    }

    public bool CanSendBoardPacket()
    {
        return NetworkSystem.enableSocketConnection && !NetworkSystem.doNotSendBoardToServer && !_blockBoardPacketSending && _gameBoard is { isLocalBoard: false };
    }

    private void SyncBoardUnits()
    {
        foreach (var gameUnit in _gameBoard.Units.Values)
        {
            if (UnitObjectById.TryGetValue(gameUnit.Id, out var gameUnitObject))
            {
                gameUnitObject.HandleUpdate(gameUnit, Time.deltaTime);
            }
            else
            {
                RentFromPool(m_GameUnitObjectPrefab, gameUnit.Position.X0Z(), Quaternion.identity, transform, out var goGameUnitObject);
                gameUnitObject = GetGameUnitObject(gameUnit, goGameUnitObject);
                goGameUnitObject.name = $"{gameUnit.GetId()}@{gameUnit.ResUnit.Id}";

                var unitPrefab = gameUnit.ResUnit.ClientPrefab.Get();
                if (unitPrefab == null)
                {
                    Debug.LogError($"프리팹 파일명에 해당하는 프리팹이 존재하지 않습니다! 이름: {gameUnit.ResUnit.Name} {gameUnit.ResUnit.Prefab}");
                }

                var poolId = RentFromPool(unitPrefab, Vector3.zero, Quaternion.identity, goGameUnitObject.transform, out var goUnitViewModel);

                //Connect UnitSkin reference
                var unitSkin = goUnitViewModel.GetOrAdd<UnitSkin>();
                gameUnitObject.unitSkin = unitSkin;
                unitSkin.unit = gameUnitObject;

                UnitObjectById[gameUnit.Id] = gameUnitObject;

                gameUnitObject.HandleCreate(poolId, gameUnit.Id, gameUnit.ResUnit);

                if (gameUnitObject.isLocalPlayer)
                {
                    var followCamera = GameScene.Get().followTargetCamera;
                    followCamera.Follow(gameUnitObject.transform);
                }
            }
        }

        ClearUnits();
    }

    private GameUnitObject GetGameUnitObject(GameUnit unit, GameObject go)
    {
        var isMyPlayerUnit = unit.ResUnit.Type == ResourceUnit.Types.Type.Player && unit.PlayerId == MyPlayer.Player.Id;

        if (isMyPlayerUnit)
            return go.GetOrAdd<MyGameUnitObject>();

        return go.GetOrAdd<GameUnitObject>();
    }

    private readonly List<long> _unitIdsToRemove = new();
    private void ClearUnits(bool clearAll = false)
    {
        foreach (var gameUnitObject in UnitObjectById.Values)
        {
            if (clearAll || gameUnitObject.gameUnit == null)
            {
                var doPool = !clearAll;
                gameUnitObject.HandleDestroy(doPool);
                _unitIdsToRemove.Add(gameUnitObject.syncId);

                if (doPool)
                {
                    ReturnToPool(m_GameUnitObjectPrefab.GetInstanceID(), gameUnitObject.gameObject);
                    Destroy(gameUnitObject); //컴포넌트만 제거
                }
                else
                {
                    Destroy(gameUnitObject.gameObject);
                }
            }
        }

        foreach (var id in _unitIdsToRemove)
            RemoveUnitByID(id);

        _unitIdsToRemove.Clear();
    }

    private readonly List<long> _skillIdsToRemove = new();
    private void SyncBoardSKills()
    {
        foreach (var gameSkill in _gameBoard.Skills.Values)
        {
            if (SkillObjectById.TryGetValue(gameSkill.Id, out var gameSkillObject))
            {
                gameSkillObject.HandleUpdate(gameSkill, Time.deltaTime);
            }
            else
            {
                if (gameSkill.ResSkill?.ClientPrefab.Get() is { } skillPrefab)
                {
                    var rot = gameSkill.Direction.X0Z().GetRotationAs2D();

                    var poolId = RentFromPool(skillPrefab, gameSkill.Position.X0Z(),
                        rot, transform, out var go);
                    go.transform.localScale = Vector3.one * (float)gameSkill.Scale;

                    gameSkillObject = go.GetOrAdd<GameSkillObject>();

                    gameSkillObject.HandleCreate(poolId, gameSkill.Id, gameSkill.ResSkill);
                    gameSkillObject.HandleUpdate(gameSkill, Time.deltaTime);

                    SkillObjectById[gameSkill.Id] = gameSkillObject;
                }
            }
        }

        ClearSkills();
    }

    private void ClearSkills(bool clearAll = false)
    {
        foreach (var gameSkillObject in SkillObjectById.Values)
        {
            var gameSkill = _gameBoard.GetSkillById(gameSkillObject.syncId);
            if (clearAll || gameSkill == null || gameSkill.Id != gameSkillObject.syncId)
            {
                var doPool = !clearAll;
                gameSkillObject.HandleDestroy(doPool);
                _skillIdsToRemove.Add(gameSkillObject.syncId);
            }
        }

        foreach (var id in _skillIdsToRemove)
            RemoveSkillByID(id);

        _skillIdsToRemove.Clear();
    }

    private void SyncBoardDropItems()
    {
        foreach (var dropItem in _gameBoard.DropItems.Values)
        {
            if (DropItemObjectById.TryGetValue(dropItem.Id, out var dropItemObject))
            {
                dropItemObject.HandleUpdate(dropItem, Time.deltaTime);
            }
            else
            {
                // TODO: prefab check
                var prefabPath = dropItem.ResItem.PrefabGroups.GetValueOrDefault(dropItem.PrefabId);
                if (!string.IsNullOrEmpty(prefabPath))
                {
                    var dropItemPrefab = Utility.LoadResource<GameObject>(prefabPath);
                    if (!dropItemPrefab)
                        continue;

                    var poolId = RentFromPool(dropItemPrefab, dropItem.Position.X0Z(), Quaternion.identity,
                        transform, out var go);

                    dropItemObject = go.GetOrAdd<GameDropItemObject>();

                    dropItemObject.HandleCreate(poolId, dropItem.Id, dropItem.ResItem);
                    dropItemObject.Initialize(dropItem.Position.X0Z());

                    DropItemObjectById[dropItem.Id] = dropItemObject;
                }
            }
        }

        ClearDropItems();
    }

    private readonly List<long> _dropItemIdsToRemove = new();
    private void ClearDropItems(bool clearAll = false)
    {
        foreach (var dropItemObject in DropItemObjectById.Values)
        {
            if (clearAll || dropItemObject.gameDropItem == null)
            {
                var doPool = !clearAll;
                dropItemObject.HandleDestroy(doPool);
                _dropItemIdsToRemove.Add(dropItemObject.syncId);
            }
        }

        foreach (var id in _dropItemIdsToRemove)
            RemoveDropItemByID(id);

        _dropItemIdsToRemove.Clear();
    }

    private void FlushEvents()
    {
        foreach (var boardEvent in _gameBoard.Events)
            boardEvent.Run();
        _gameBoard.ClearEvents();
    }

    public async UniTask GoToMapLocalToNet(int mapId, bool join = false)
    {
        // HUDManager.Get().gamePad.DisableGamePad();
        SceneLoader.Get().SetActive(true);

        if (NetworkSystem.enableSocketConnection)
        {
            if (gameBoard?.Id != 0L)
            {
                await ZWorldClient.Get().SendPacket(Packet.Pop(0, new LeaveBoardRequest()));
            }
            
            // send create board
            // get create board
            ClearTickRecords();
            lastBoardPacketSentTick = 0;
            BlockBoardPacketSending(true);
            PlatformManager.Get().LogEvent("gamePlay", value: mapId);

            IPacketResponse response = null;
            if (join)
            {
                var joinBoardPacket = Packet.Pop(0, new JoinBoardRequest() { MapDataId = mapId });
                response = await ZWorldClient.Get().SendPacket(joinBoardPacket);
            }
            else
            {
                var createBoardPacket = Packet.Pop(0, new CreateBoardRequest { MapDataId = mapId });
                response = await ZWorldClient.Get().SendPacket(createBoardPacket);
            }
            
            if (!response.Status.IsSuccess())
            {
                SceneLoader.Get().SetActive(false);

                if (modeManager == null)
                {
                    SceneLoader.Get().LoadScene(Constants.LOGIN_SCENE, forced: true);
                }

                PlatformManager.Get().LogEvent("gotoMap_failed", ("mapDataId", mapId.ToString()), ("status", response.Status.ToString()));
            }
        }
        else
        {
            MyPlayer.SetGameBoardLocal(mapId);
        }
    }
    
    public void GoToLobby(int mapId = -1)
    {
        if (mapId == -1)
        {
            var homeMap = MyPlayer.GetCurrentHomeMap();
            if (homeMap == null)
            {
                Debug.LogError("Failed to resolve a home map for the current player flow.");
                return;
            }

            mapId = homeMap.Id;
        }
        
        SceneLoader.Get().SetActive(true, true);
        SceneLoader.Get().Refresh();

        if (NetworkSystem.enableSocketConnection)
        {
            if (MyPlayer.Player.BoardId != 0)
            {
                Toast.Show<Popup_Toast>($"Must_LeaveBoard_First".L());
                return;
            }
        }
        MyPlayer.SetGameBoardLocal(mapId);
    }

    public bool CheckBoardResponse(Commons.Packets.Requests.GetBoardRequest.Types.Response gameBoardResponse)
    {
        CleanTickRecordsOlderThan(gameBoardResponse.Tick);
        if (boardHashRecord.TryGetValue(gameBoardResponse.Tick, out var hash))
        {
            if (hash != gameBoardResponse.BoardHash)
            {
                Debug.LogError($"보드 해시 다름! 해시 틱: {gameBoardResponse.Tick}, 클라: {hash}, 서버: {gameBoardResponse.BoardHash}");
                return false;
            }
        }

        //If don't have tick, pass check
        return true;
    }

    public void DebugDumpGameBoard()
    {
        if (_gameBoard == null)
            return;
        _gameBoard.SaveDebugDump("Assets/HashDump-Client_log.txt", ref _clearLog);
    }

    private void SetBoard(GameBoard newBoard)
    {
        _gameBoard = newBoard;

        _gameBoardInitialized = false;
        _gameBoardLoading = false;
        _syncTimer = 0;
#if UNITY_EDITOR
        _mushroomDebugNextLogTime = 0d;
        _mushroomDebugLastTick = 0;
#endif
    }

    private bool _shouldReplaceBoard;
    private bool _shouldHandleGameResult;
    private bool _shouldInitBoardWhenReplacing;
    private void SetBoardLazy(bool init)
    {
        _shouldReplaceBoard = true;

        _shouldInitBoardWhenReplacing = init;
    }

    public void SyncBoard(GameBoard newBoard)
    {
        Debug.Log("SyncBoard!!");
        ClearBoardPauseRequests();
        if (_gameBoard == null || _gameBoard.Id != newBoard.Id)
        {
            SetBoard(newBoard);
        }
        else
        {
            SetBoardLazy(false);
        }

        _instance = this;
    }

    public void AddMyUnitOffline(Vector2 position = default, Vector2 direction = default)
    {
        if (!NetworkSystem.enableSocketConnection)
        {
            var characterItemDataId = MyPlayer.PlayerAvatar?.Character?.ItemDataId;
            if (characterItemDataId is null or 0)
                characterItemDataId = ResourceItem.Global.DataId.DefaultCharacter;

            var characterItem = ResourceItem.Get(characterItemDataId.Value);
            var unitDataId = characterItem?.UnitDataId ?? characterItemDataId.Value;

            var myUnit = new GameUnit
            {
                Position = new Vector2Message(),
                Direction = new Vector2Message(),
            };

            // MyPlayer.SetGameUnit(myUnit);

            myUnit.PlayerId = MyPlayer.Player.Id;
            myUnit.Team = GameBoard.Team.Player;
            myUnit.PlayerAvatar = new PlayerAvatar
            {
                Character = new PlayerItemMessage { Id = 3, ItemDataId = characterItemDataId.Value }
            };

            myUnit.DataId = unitDataId;
            myUnit.Team = GameBoard.Team.Player;

            if (position == default)
            {
                var location = _gameBoard.ResMap.GetLocationById(ResourceMap.LocationId.Player, _gameBoard);
                if (location != null)
                    position = location.Position;
                else
                    position = Vector2.zero;
            }

            myUnit.Position.Set(position);
            myUnit.Direction.Set(direction);
            myUnit.Velocity = new Vector2Message();
            myUnit.Variables = new ResourceTrigger.Types.Variables();

            _gameBoard.AddUnit(myUnit);

            //HUDManager.Get().RefreshMyPlayerUnitStatus(myUnit);
        }
    }

    public GameUnit AddPlayerUnitLocal(long id, ResourceItem resItem, Vector2 position = default, Vector2 direction = default)
    {
        if (!_gameBoard.isLocalBoard)
            return null;

        position = GetSafePosition(position);

        var unit = new GameUnit
        {
            PlayerId = MyPlayer.Player.Id,
            Position = new Vector2Message(),
            Direction = new Vector2Message(),
            PlayerAvatar = new()
            {
                Character = new PlayerItemMessage
                {
                    Id = id,
                    ItemDataId = resItem.Id
                },
            },
            DataId = resItem.UnitDataId,
            Team = GameBoard.Team.Player
        };

        unit.Position.Set(position);
        unit.Direction.Set(direction);
        unit.Velocity = new Vector2Message();
        unit.Variables = new ResourceTrigger.Types.Variables();

        _gameBoard.Players[MyPlayer.Player.Id] = new BoardPlayerMessage()
        {
            Id = MyPlayer.Player.Id,
            Board = _gameBoard
        };
        _gameBoard.AddUnit(unit);

        return unit;
    }

    public Vector2 GetSafePosition(Vector2 position)
    {
        return gameBoard.ToSafePosition(position);
    }

    #region LoadMap Helper Methods

    private AsyncOperation _loadSceneOp;
    private Scene _currentScene;

    private IEnumerator LoadScene(string sceneRoute, Vector3? offset = null)
    {
#if UNITY_EDITOR
        var scenePath = Path.Combine(Application.dataPath, "PatchResources/Maps/" + sceneRoute + ".unity");
        if (!File.Exists(scenePath))
        {
            Debug.LogWarning($"Map scene not found, skipping additive load: {scenePath}");
            _loadSceneOp = null;
            yield break;
        }

        _loadSceneOp = EditorSceneManager.LoadSceneAsyncInPlayMode(
            scenePath,
            new LoadSceneParameters(LoadSceneMode.Additive));
#else
        _loadSceneOp = SceneManager.LoadSceneAsync(Path.GetFileNameWithoutExtension(sceneRoute), LoadSceneMode.Additive);
#endif
        yield return _loadSceneOp;


        var scene = SceneManager.GetSceneByName(Path.GetFileNameWithoutExtension(sceneRoute));
        if (scene.IsValid())
        {
            SceneManager.SetActiveScene(scene);
            if (offset is not null)
            {
                foreach (var objectInScene in scene.GetRootGameObjects())
                    objectInScene.transform.localPosition += offset.Value;
            }
        }
        else
        {
            Debug.LogError("Failed to load map: " + sceneRoute);
        }
    }

    private IEnumerator LoadResourceMap(ResourceMap resMap)
    {
        yield return new WaitUntil(() => _loadSceneOp == null || _loadSceneOp.isDone);

        yield return new WaitForEndOfFrame();

        yield return StartCoroutine(UnloadScene(_currentScene));

        if (resMap != null)
            yield return LoadScene(resMap.Scene);
        else
        {
            Debug.LogWarning("ResourceMap is null.");
            Debug.LogWarning(_gameBoard.ToDebugString());
        }

        var sceneRoute = _gameBoard.ResMap.Scene;
        _currentScene = GetScene(Path.GetFileNameWithoutExtension(sceneRoute));
    }

    private IEnumerator UnloadScene(Scene scene)
    {
        if (!scene.IsValid())
            yield break;

        yield return new WaitForEndOfFrame();
        foreach (var objectInScene in scene.GetRootGameObjects())
            objectInScene.SetActive(false);
        yield return SceneManager.UnloadSceneAsync(scene);
    }

    private Scene GetScene(string sceneName)
    {
        Scene latestLoadedScene = default;

        for (var i = 0; i < SceneManager.sceneCount; i++)
        {
            var scene = SceneManager.GetSceneAt(i);
            if (scene.name == sceneName)
                latestLoadedScene = scene;
        }

        return latestLoadedScene;
    }

    #endregion

    public IEnumerator LoadMap(ResourceMap resMap, Action callback = null)
    {
        // TODO: map screen loader

        if (modeManager != null)
        {
            yield return modeManager.Release();
            Destroy(modeManager.gameObject);
            modeManager = null;
        }

        // var path = $"Maps/MapData/{Path.GetFileNameWithoutExtension(resMap.Scene)}.asset";
        if (this.mapRoot)
        {
            Destroy(this.mapRoot.gameObject);
            this.mapRoot = null;
        }

        var path = $"Maps/Prefabs/{Path.GetFileNameWithoutExtension(resMap.Scene)}.prefab";

        var mapRootPrefab = Utility.LoadResource<GameObject>(path);
        var operation = InstantiateAsync(mapRootPrefab, mapScreen.transform);
        yield return operation;
        var go = operation.Result[0];
        if (go == null)
        {
            Debug.LogError($"result is empty: {path}");
            yield break;
        }
        var mapRoot = go.GetComponent<MapRoot>();
        if (!mapRoot)
        {
            Debug.LogError($"MapRoot is null: {path}");
            yield break;
        }

        var newLocalPosition = new Vector3(0, 0, mapRoot.transform.localPosition.z);
        mapRoot.transform.localPosition = newLocalPosition;

        this.mapRoot = mapRoot;
        mapScreen.Initialize();

        ZWorldClient.Get().ProcessGatheredPackets();

        try
        {
            GameManager.Get().ClearAllPopups();
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }

        yield return LoadModeManager(resMap);

        callback?.Invoke();
        if (_gameBoard.ResMap != null)
            GameManager.Get().DispatchEvent(GameEventType.MAP_LOADED);

        SceneLoader.Get().SetActive(false);
    }

    private IEnumerator LoadModeManager(ResourceMap resMap)
    {
        var modeManagerKey = ClientMapFlowResolver.ResolveModeManagerAddressableKey(resMap);
        AsyncOperationHandle<GameObject> handle = Addressables.InstantiateAsync(modeManagerKey, trModeManagerParent);

        yield return handle;
        modeManager = handle.Result.GetComponent<ZModeManagerBase>();
        modeManager.transform.localPosition = Vector3.zero;
        ((RectTransform)modeManager.transform).anchoredPosition = Vector2.zero;
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)trModeManagerParent);
        yield return modeManager.Initialize(resMap);
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (Application.isPlaying && _gameBoard != null)
        {
            foreach (var gameSkill in _gameBoard.Skills.Values)
            {
                foreach (var hitData in gameSkill.Hits)
                {
                    foreach (var hitGeometry in hitData.IGeometries)
                    {
                        // var gameUnitObject = GetUnitByID(gameSkill.SenderUnitId);
                        // var gameSkillObject = GetSkillByID(gameSkill.Id);
                        var pos = gameSkill.Position.X0Z();
                        hitGeometry.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(pos, gameSkill.Direction.X0Z().GetRotationAs2D(), Vector3.one);
                    }
                }
            }
        }
    }
#endif
    public void BlockShowGameResult(bool blocked)
    {
        _blockShowGameResult = blocked;
    }

    public async UniTask<bool> ShowGameResult(PlayerRankingMessage prevRanking = null, PlayerRankingMessage currentRanking = null)
    {
        if (_blockShowGameResult)
            return false;

        var popupName = nameof(Popup_GameResults) + "Failure";
        var displayWinningTeam = (int)gameBoard.Variables.Get(BoardVariableId.Map.displayWinningTeam);
        var winningTeam = displayWinningTeam > 0 ? displayWinningTeam : gameBoard.WinningTeam;
        
        if (winningTeam == GameBoard.Team.Player)
            popupName = nameof(Popup_GameResults) + "Victory";

        var popupGameResults = await GameManager.Get().GetOrShowPopupAsync(popupName) as Popup_GameResults;
        popupGameResults!.Initialize(prevRanking, currentRanking, displayWinningTeam > 0, midGameRewards: MyPlayer.BoardPlayer?.AcquiredItems, resultRewards: MyPlayer.ResultRewardItems);    

        return true;
    }

    internal void SetShouldForceUpdateGameBoard(bool forceUpdate)
    {
        _forceUpdateGameBoard = forceUpdate;
    }

    public void FlushUpdates()
    {
        if (_gameBoard == null)
            return;

        _gameBoard.FlushUpdates();
    }
}

namespace Commons.Game
{
    public partial class GameBoard
    {
        public GameBoard (bool isLocalBoard)
        {
            OnConstruction();
            this.isLocalBoard = isLocalBoard;
        }
        public readonly bool isLocalBoard;
    }
}
