using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using JetBrains.Annotations;
using Unity.Mathematics;
using UnityEngine;
using GeometryUtility = UnityEngine.GeometryUtility;
using Random = UnityEngine.Random;
#if UNITY_EDITOR
using UnityEditor;
#endif


public class GameUnitObject : GameBoardObject
{
    [NonSerialized] public UnitSkin unitSkin;
    public ResourceUnit ResUnit => resource as ResourceUnit;
    protected GameUnit _cachedGameUnit;
    [CanBeNull] public GameUnit gameUnit => GameBoardManager.Get().gameBoard.GetUnitById(syncId);
    
    public UnitCanvasCell unitCanvasCell { get; set; }

    public bool isLocalPlayer;

    private Transform _UnitBackgroundTransform;

    private void Awake()
    {
        _UnitBackgroundTransform = transform.GetChild(0);
    }

    public virtual void Start()
    {
    }

    public override void HandleCreate(long poolId, long syncId, ResourceEntity resource)
    {
        base.HandleCreate(poolId, syncId, resource);

        var gameUnit = GameBoardManager.Get().gameBoard.GetUnitById(syncId)!;
        _cachedGameUnit = gameUnit!.Clone(); // TODO: check performance impact

        transform.localScale = Vector3.one * (float)gameUnit.Scale;

        SyncStats(gameUnit, true);
        SyncClothes(gameUnit, true);
        SyncVariables(gameUnit, true);

        GameManager.Get().DispatchEvent(GameEventType.UnitCreated, this);
    }

    public override void HandleUpdate(GameEntity gameEntity, float dt)
    {
        base.HandleUpdate(gameEntity, dt);
        
        if (gameEntity is not GameUnit updatedUnit)
            return;
        
        SyncStats(updatedUnit);
        SyncBuffs(updatedUnit);
        
        SyncClothes(updatedUnit);
        
        SyncVariables(updatedUnit);
        
        // cached values should be updated only when it's used and by methods that use it
        // _cachedGameUnit = gameUnit.Clone();

        unitSkin.HandleState(updatedUnit.State);
    }

    protected override void UpdateTransform(Vector3 pos, Vector3 dir, Vector3 velocity, float timeDelta)
    {
        base.UpdateTransform(pos, dir, velocity, timeDelta);

        unitSkin.UpdateDirection(dir);
        
        var scale = transform.localScale;
        var _gameUnit = gameUnit;
        if (_gameUnit != null)
            scale = Vector3.one * (float)_gameUnit.Scale;

        transform.localScale = scale;
    }

    protected virtual void SyncClothes(GameUnit updatedUnit, bool init = false)
    {
        // other skin related settings go here
        
        var isPlayerUnit = ResUnit.Type == ResourceUnit.Types.Type.Player;
        if (!isPlayerUnit)
            return;

        if (updatedUnit?.PlayerAvatar?.Character == null)
        {
            Debug.LogWarning($"{_cachedGameUnit.ResUnit} has no PlayerAvatar.Character.");
            return;
        }
        
    }
    
    public struct BuffData
    {
        public long poolId;
        public GameObject instance;
    }

    protected readonly Dictionary<long, BuffData> _buffDatas = new(20);

    private long _buffContainerHash;
    private long _buffInfoHash;
    protected virtual bool SyncBuffs(GameUnit gameUnit)
    {
        var buffContainerHash = 1L;
        var buffInfoHash = 1L;
        
        foreach (var buff in gameUnit.Buffs.Values)
        {
            buffContainerHash = buffContainerHash * 31 + buff.Id;
            buffInfoHash = buffInfoHash * 31 + (buff.Id * 1000000 + buff.Level * 1000 + buff.Stack);
            //
            if (!_buffDatas.ContainsKey(buff.Id))
            {
                var resBuff = ResourceBuff.Get(buff.DataId);
                if (resBuff == null || resBuff.Id == default)
                {
                    Debug.LogError($"Buff not found: {buff.DataId}");
                    continue;
                }

                if (resBuff.ClientPrefab.Get() is { } buffPrefab)
                {
                    var parent = unitSkin.transform;

                    switch (resBuff.PrefabAttachmentTarget)
                    {
                        case ResourceBuff.Types.PrefabAttachmentTarget.SkinRoot:
                            break;
                        case ResourceBuff.Types.PrefabAttachmentTarget.UnitBackground:
                        {
                            parent = _UnitBackgroundTransform;
                            break;
                        }
                        default:
                        {
                            parent = unitSkin.buffAttachmentTargets.FirstOrDefault(x => x.AttachmentTarget == resBuff.PrefabAttachmentTarget)?.transform ?? parent;
                            break;
                        }
                    }

                    var poolId = GameBoardManager.Get().RentFromPool(buffPrefab, Vector3.zero, Quaternion.identity, parent, out var goBuff);
                    _buffDatas[buff.Id] = new BuffData()
                    {
                        poolId = poolId,
                        instance = goBuff
                    };
                }
            }
        }
        
        var isBuffContainerUpdated = _buffContainerHash != buffContainerHash;
        var isBuffInfoUpdated = _buffInfoHash != buffInfoHash;
        
        if (isBuffContainerUpdated)
            _buffContainerHash = buffContainerHash;
        if (isBuffInfoUpdated)
            _buffInfoHash = buffInfoHash;

        ClearInvalidBuffObjects();
        
        if (isBuffContainerUpdated)
        {
            unitSkin.SetRendererActive(!gameUnit.HasBuffByTag(Tag.HideUnit));
            
            if (gameUnit.HasBuffByTag(Tag.PauseAnimation))
            {
                unitSkin.PauseAnimation();
            }
            else
            {
                unitSkin.ResumeAnimation();
            }
        }

        if (isBuffInfoUpdated)
        {
            if (unitCanvasCell)
                unitCanvasCell.RefreshBuffCells(this);
        }

        return isBuffContainerUpdated;
    }
    
    private void ClearAllBuffObjects()
    {
        using var buffIdsToRemove = PooledList<long>.Get();
        foreach (var buffObjectId in _buffDatas.Keys)
        {
            buffIdsToRemove.Add(buffObjectId);
        }
        
        ClearBuffObjects(buffIdsToRemove);
    }
    
    private void ClearInvalidBuffObjects()
    {
        using var buffIdsToRemove = PooledList<long>.Get();
        foreach (var buffObjectId in _buffDatas.Keys)
        {
            if (gameUnit?.GetBuffById(buffObjectId) is not { Id: > 0 })
            {
                buffIdsToRemove.Add(buffObjectId);
            }
        }
        
        ClearBuffObjects(buffIdsToRemove);
    }

    private void ClearBuffObjects(IEnumerable<long> buffIdsToRemove)
    {
        foreach (var id in buffIdsToRemove)
        {
            var data = _buffDatas[id];
            GameBoardManager.Get().ReturnToPool(data.poolId, data.instance);
            _buffDatas.Remove(id);
        }        
    }
    
    protected virtual void SyncVariables(GameUnit updatedUnit, bool init = false)
    {
        
    }

    protected virtual void SyncStats(GameUnit gameUnit, bool init = false)
    {
        if (init || _cachedGameUnit.Hp != gameUnit.Hp)
        {
            if (unitCanvasCell)
                unitCanvasCell.UpdateHP(gameUnit.Hp, gameUnit.MaxHp, !init);

            _cachedGameUnit.Hp = gameUnit.Hp;
            GameManager.Get().DispatchEvent(GameEventType.UnitHpUpdated, this);
        }
        
        if (init || _cachedGameUnit.Mp != gameUnit.Mp)
        {
            if (unitCanvasCell)
                unitCanvasCell.UpdateMP(gameUnit.Mp, gameUnit.MaxMp, gameUnit.Mp > _cachedGameUnit.Mp, true);
            _cachedGameUnit.Mp = gameUnit.Mp;
            
            _cachedGameUnit.Mp = gameUnit.Mp;
        }
        
        if (init || _cachedGameUnit.Shield != gameUnit.Shield)
        {
            if (unitCanvasCell)
                unitCanvasCell.UpdateShield(gameUnit.Shield, gameUnit.MaxHp, !init);
            
            _cachedGameUnit.Shield = gameUnit.Shield;
        }
        
        if (init || _cachedGameUnit.Sp != gameUnit.Sp)
        {
            //_cachedGameUnit.Sp = gameUnit.Sp;
            //var increase = _cachedGameUnit.Sp < gameUnit.Sp;
            //if (unitCanvasCell)
            //     unitCanvasCell.UpdateSP(gameUnit.Sp, _cachedGameUnit.MaxSp, increase, true);
            //// GameScene.Get().UpdateUnitInspectorSP(gameUnit, increase, true);
            //// GameContainer.Get().modeManagerBase.HandleChangeUnitSP(gameUnit);
            //// if (isLocalPlayer)
            ////     GameScene.Get().RefreshMyPlayerUnitStatus();
            //
            //_cachedGameUnit.Sp = gameUnit.Sp;
        }

        if (init || _cachedGameUnit.DataId != gameUnit.DataId)
        {
            _cachedGameUnit.DataId = gameUnit.DataId;
        }
        
    }
    
    public virtual void HandleAttacked(UnitAttackedEvent attackedEvent, EffectType effectType = EffectType.Default)
    {
        var type = attackedEvent.IsCritical ? IconType.Critical : (attackedEvent.Damage > 0 ? IconType.Damage : IconType.Miss);
        var textColor = CRC.Get().GetEffectTypeColor(effectType);

        if (attackedEvent.SkillDataId != 0 && ResourceSkill.Get(attackedEvent.SkillDataId) is { } resSkill)
        {
            textColor = CRC.Get().damageTextColorsBySkillGroup.GetValueOrDefault(resSkill.Group, textColor);
        }

        if (attackedEvent.BuffDataId != 0 && ResourceBuff.Get(attackedEvent.BuffDataId) is { } resBuff)
        {
            textColor = CRC.Get().damageTextColorsByBuffGroup.GetValueOrDefault(resBuff.Group, textColor);
        }

        DamageTextFloatingManager.ShowDamage(clientPosition + unitSkin.trPanelStatus?.localPosition * 0.6f ?? Vector3.zero, type, (ulong)attackedEvent.Damage, textColor: textColor);
        unitSkin.FlushHitEffect(ResUnit.Type == ResourceUnit.Types.Type.Player ? CRC.Get().globalParameters.playerHitEffectColor : CRC.Get().globalParameters.enemyHitEffectColor);
    }

    public virtual void HandleHealed(long heal)
    {
        DamageTextFloatingManager.ShowDamage(clientPosition + unitSkin.trPanelStatus?.localPosition * 0.6f ?? Vector3.zero, IconType.Heal, (ulong)heal);

        if (ResUnit.Type == ResourceUnit.Types.Type.Player)
        {
            unitSkin.FlushHitEffect(CRC.Get().globalParameters.playerHealEffectColor);
        }
    }

    public override void HandleDestroy(bool pool = true)
    {
        GameManager.Get().DispatchEvent(GameEventType.UnitDestroyed, this);
        
        if (pool)
        {
            ClearAllBuffObjects();
            unitSkin.ClearAnimation();
            
            GameBoardManager.Get().ReturnToPool(_poolId, unitSkin.gameObject, 100);
        }
        else
            Destroy(unitSkin.gameObject);
    }
    
    public ClientBubbleTextDefine.BehaviourBubbleSequence BehaviourBubbleSequence { get; set; }

    private Coroutine bubbleSequenceCoroutine;
    public void SetBubbleSequence(ClientBubbleTextDefine.BehaviourBubbleSequence sequence)
    {
        return;
        
        if (transientBubbleSequenceCoroutine != null)
            return;
        
        if (BehaviourBubbleSequence == sequence)
            return;
        
        BehaviourBubbleSequence = sequence;
        
        if (bubbleSequenceCoroutine != null)
            StopCoroutine(bubbleSequenceCoroutine);
        
        if (BehaviourBubbleSequence == null)
            return;

        bubbleSequenceCoroutine = StartCoroutine(IBehaviourBubbleSequence(BehaviourBubbleSequence));
    }
    
    private IEnumerator IBehaviourBubbleSequence(ClientBubbleTextDefine.BehaviourBubbleSequence sequence)
    {
        yield return Utility.GetWaitForSeconds(sequence.InitialDelay);

        while (BehaviourBubbleSequence == sequence)
        {
            var period = sequence.Period;

            if (sequence.CheckProb())
            {
                StartCoroutine(ShowBubble(sequence));
            }

            yield return Utility.GetWaitForSeconds(period);
        }
    }
    
    private Coroutine transientBubbleSequenceCoroutine;
    public void SetBubbleSequenceTransient(ClientBubbleTextDefine.TransientBubbleSequence sequence)
    {
        if (transientBubbleSequenceCoroutine != null)
            StopCoroutine(transientBubbleSequenceCoroutine);

        BehaviourBubbleSequence = null;

        if (sequence == null)
            return;
        
        transientBubbleSequenceCoroutine = StartCoroutine(ITransientBubbleSequence(sequence));
    }
    
    private IEnumerator ITransientBubbleSequence(ClientBubbleTextDefine.TransientBubbleSequence sequence)
    {
        yield return StartCoroutine(ShowBubble(sequence));

        ReleaseTransientBubbleSequence();
    }
    
    private void ReleaseTransientBubbleSequence()
    {
        if (transientBubbleSequenceCoroutine != null)
            StopCoroutine(transientBubbleSequenceCoroutine);
        transientBubbleSequenceCoroutine = null;

        GameManager.Get().DispatchEvent(GameEventType.TransientBubbleReleased, this);
    }

    private IEnumerator ShowBubble(ClientBubbleTextDefine.IBubbleSequence sequence)
    {
        var key = sequence.RandomStringKey;
        if (string.IsNullOrEmpty(key))
            yield break;
        
        var text = key.GetLocalizationList().PickOne();
        
        yield return BubbleCanvas.Get().ShowBubble(this, text, sequence.Duration);
    }

#if UNITY_EDITOR
    public void OnDrawGizmos()
    {
        if (!Application.isPlaying)
            return;
        
        if (gameUnit?.ResUnit == null)
            return;
        
        var objectPosition = transform.position;
        var objectRotation = gameUnit.Direction.X0Z().GetRotationAs2D();

        if (GizmoSystem.seeUnitHitSize)
        {
            gameUnit.HitGeometry.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(Vector2.zero,
                Quaternion.identity, Vector3.one, GizmoSystem.unitHitSizeColor);
        }

        if (GizmoSystem.seeUnitTargetAwareDistance)
        {
            var awareDistance = gameUnit.ResUnit.TargetAwareDistance;
            var awareCircle = new Circle(new Vector2(0, 0), awareDistance);
            awareCircle.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition, objectRotation,
                Vector3.one, GizmoSystem.unitTargetAwareDistanceColor);
        }

        if (GizmoSystem.seeUnitCollideSize)
        {
            var collideSize = gameUnit.CollideSize;
            var collideOffset = (Vector2)gameUnit.CollideOffset;
            var colliderCircle = new Circle(new Vector2(0, 0), collideSize);
            colliderCircle.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition + (Vector3)collideOffset,
                objectRotation, Vector3.one, GizmoSystem.unitCollideSizeColor);
        }

        if (GizmoSystem.seeUnitDropItemPickUpSize)
        {
            var dropItemCollideSize = (float)gameUnit.CollideSize;
            var dropItemColliderRect = new Rectangle(new Vector2(-dropItemCollideSize / 2, 0), 0f,
                dropItemCollideSize / 2, dropItemCollideSize);
            dropItemColliderRect.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition,
                objectRotation, Vector3.one, GizmoSystem.unitDropItemPickUpSizeColor);
        }

        if (GizmoSystem.seeUnitOffsets)
        {
            {
                var offset = (Vector2)gameUnit.CollideOffset;
                var offsetCircle = new Circle(new Vector2(0, 0), 0.1f);
                offsetCircle.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition + (Vector3)offset, objectRotation, Vector3.one, Color.red, 3f);
            }
            {
                var offset = (Vector2)gameUnit.HitOffset;
                var offsetCircle = new Circle(new Vector2(0, 0), 0.1f);
                offsetCircle.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition + (Vector3)offset, objectRotation, Vector3.one, Color.magenta, 3f);   
            }
            {
                var offset = (Vector2)gameUnit.ShotOffset;
                var offsetCircle = new Circle(new Vector2(0, 0), 0.1f);
                offsetCircle.GetConvertedGeometry(Mathf.Rad2Deg).DrawGizmo(objectPosition + (Vector3)offset, objectRotation, Vector3.one, Color.yellow, 3f);
            }
        }

        var prevPosition = (Vector2)objectPosition;
        foreach (var path in gameUnit.Path)
        {
            (new Line(prevPosition, path)).DrawGizmo(Vector3.zero, quaternion.identity, Vector3.one, Color.magenta);
            prevPosition = path;
        }
        
    }
#endif
}
