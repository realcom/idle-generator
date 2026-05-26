using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using UnityEngine;
using Random = UnityEngine.Random;

public enum GameEventType {
	SOCKET_CONNECTED,
	SOCKET_DISCONNECTED,
	SOCKET_CONNECT_FAILED,
	SOCKET_GOT_PACKET,

	//
	EDGE_SERVER_LOGINED,
	EDGE_SOCKET_CONNECTED,
	EDGE_SOCKET_DISCONNECTED,
	EDGE_SOCKET_CONNECT_FAILED,
	
	//
	GAMEBOARD_HASH_UPDATED,
	GAMEBOARD_UPDATED,
	GAMEBOARD_REPLACED,
	
	// Board
	BoardEventDispatched,
	
	BoardItemDragStarted,
	BoardItemDragEnded,
	BoardInventoryMerged,
	BoardInventorySpawned,
	BoardInventoryMoved,
	BoardInventoryExpanded,
	BoardInventoryResetHold,
	BoardInventoryCommandUpdated,
	// BoardLevelUpChoiceUpdated,
	BoardSelectTrait,
	// BoardChooseTrait,
	// GameBoard
	BoardPlayerUpdated,
	BoardPlayerJoined,
	BoardPlayerLeft,
	BoardPlayerMoved,
	
	BoardIncreaseAchievement,
	BoardIncreaseMission,
	BoardCompleteMission,
	BoardMissionUpdated,
	
	BoardUnitGotDropItem,
	
	BoardWaveQueued,
	BoardWaveStarted,

	BoardResetMapScroll,

	//
	MyPlayerUpdated,
	MyPlayerItemUpdated,
	MY_PLAYER_AVATAR_UPDATED,
	MyPlayerItemLevelUp,
	MyPlayerItemAdded,
	MyPlayerPowerUpdated,
	MY_PLAYER_LEVEL_UP,
	MY_PLAYER_STAGE_LEVEL_UP,
	MY_PLAYER_POWER_UPDATED,
	MY_STATS_UPDATED,
    MyPlayerAchievementUpdated,
    MY_UNIT_UPDATED,
    MY_UNIT_REVIVED,
    MY_UNIT_PICKUPED,
    MY_PLAYER_TRIGGERED,
    UNIT_DEAD,
    
    DayReset,

    MyBoardPlayerGoldUpdated,
    
	UPDATE_MY_CLAN,
	MY_CLAN_UPDATED,
    MY_ROOM_UPDATED,
    MY_MODE_VARIABLES_UPDATED,

    ROOM_STATE_UPDATED,
	ROOM_PLAYER_UPDATED,
	PopupShown,
	PopupHidden,
	BOSS_POPUP_SHOWED,
	DIALOG_ENDED,

	//
	TAB_ITEMS_NEW_CARD_UPDATED,
	TAB_ITEMS_EQUIP_CARD,
	BUY_ITEM_SUCCESS,

	// Chats
	CHAT_UPDATED,
	CHAT_MESSAGES_READ,
    CHAT_MESSAGES_UPDATED,
    CHAT_LIST_UPDATED,
    MY_BADGES_UPDATED,

    //
    SHOW_CENTER_LABEL,

    PICKED_IMAGE,
	POSTED_KAKAO_STORY,
	BAD_APP_FOUND,

	PURCHASE_COMPLETED,
	PURCHASE_CANCELLED,

	EDGE_LATENCY_UPDATED,
	KEY_SETTINGS_CHANGED,

	LOBBY_SHOW_TAB,
	LOBBY_SHOW_TAB_SHOP,
	CHANNEL_JOINED,

    //	AD,
    BANNER_CLICKED,

    // Creator
    TOUCHED_ITEM,
    WORLD_TILE_SELECTED,
    MAP_LOADED,
    MAP_RELEASED,

    // Friends,
    FRIEND_LIST_CHANGED,

	SOCIAL_RE_LOGIN,
	
	TUTORIAL_UPDATED,
	GUIDE_OBJECT_AWAKE,
	GUIDE_OBJECT_ENABLE,
	GUIDE_OBJECT_DISABLE,
	GUIDE_OBJECT_DESTROY,
	GUIDE_OBJECT_CLICK,
	
	LOCKED_EQUIPEMNT_UPDATED,
	NEW_ITEM_LIST_UPDATED,
	
	GameEnded,
	
	UnitCreated,
	UnitUpdated,
	UnitAttacked,
	UnitHealed,
	UnitRevived,
	UnitDied,
	UnitDestroyed,
	
	UnitCanvasCreated,
	
	LobbyHUDPageUpdated,
	
	UnitHpUpdated,
	
	MyUnitExpUpdated,
	MyUnitBuffUpdated,
	MyUnitAttackUpdated,
	MyUnitDefenseUpdated,
	MyUnitFreeRollCountUpdated,
	
	TimerStarted,
	TimerStopped,
	TimerPaused,
	TimerResumed,
	TimerTimeAppended,
	TimerUpdated,
	
	TransientBubbleReleased,
	
	AcquiredItemsUpdated,
	ClientAcquiredItemsUpdated,
	
	FxEventDispatchOnHeal,
	FxEventDispatchOnShieldHeal,
	FxEventDispatchOnAddExp,
	FxEventDispatchOnAddGold,
	
}

public class GameEvent {
	public GameEventType type;
	public object[] args = new object[2];
	public bool used = false;
	private static readonly Queue<GameEvent> pool = new ();
	
	//
	public static GameEvent Get(GameEventType type, object arg0 = null, object arg1 = null)
	{
		GameEvent e;
		e = pool.Count == 0 ? new GameEvent () : pool.Dequeue();
		
		//
		e.type = type;
		e.args [0] = arg0;
		e.args [1] = arg1;
		e.used = false;
		
		return e;
	}
	
	public void Recycle() {
		pool.Enqueue(this);
	}
	
	//
	private GameEvent() {
	}
	
	public void Use() {
		used = true;
	}
}

public class EventPublisher
{
	private readonly HashSet<EventListener> _generalListeners = new();
	private readonly Dictionary<GameEventType, HashSet<EventListener>> _gameEventListeners = new();
	
	public void AddListener(EventListener l)
	{
		_generalListeners.Add(l);
	}
	
	public void AddGameEventListener(GameEventType type, EventListener l)
	{
		_generalListeners.Remove(l);
		if (!_gameEventListeners.TryGetValue(type, out var listeners))
			_gameEventListeners[type] = listeners = new HashSet<EventListener>();
		listeners.Add(l);
	}

	public void AddGameEventListener(EventListener l, IEnumerable<GameEventType> types)
	{
		_generalListeners.Remove(l);
		foreach (var type in types)
		{
			if (!_gameEventListeners.TryGetValue(type, out var listeners))
				_gameEventListeners[type] = listeners = new ();
			listeners.Add(l);
		}
	}
	
	public void RemoveListener(EventListener l)
	{
		_generalListeners.Remove(l);
		foreach (var listeners in _gameEventListeners.Values)
			listeners.Remove(l);
	}

	public void DispatchEvent(GameEvent e, string message = null)
	{
		DispatchEventAsync(e, message).Forget();
	}

    public void DispatchEvent(GameEventType type, object arg0 = null, object arg1 = null)
    {
	    DispatchEvent(GameEvent.Get(type, arg0, arg1));
    }

    private async UniTask DispatchEventAsync(GameEvent e, string message = null)
    {
#if UNITY_EDITOR
	    Debug.Log($"Event Dispatched: {e.type} {message}");
#endif

	    // ITransaction transaction = null;
	    // if (e.type != GameEventType.SOCKET_GOT_PACKET && Random.value < 0.00001f)
	    // {
	    // 	var transactionContext = new TransactionContext(e.type.ToString(), "DispatchEvent");
	    // 	transaction = SentrySdk.StartTransaction(transactionContext);
	    // }
	    try
	    {
		    using var toRemoveListeners = PooledList<EventListener>.Get();
		    foreach (var listener in _generalListeners)
		    {
			    if (listener is MonoBehaviour obj && !obj)
			    {
				    toRemoveListeners.Add(listener);
			    }
		    }
			
		    foreach (var eventListeners in _gameEventListeners.Values)
		    {
			    foreach (var listener in eventListeners)
			    {
				    if (listener is MonoBehaviour obj && !obj)
				    {
					    toRemoveListeners.Add(listener);
				    }
			    }
		    }

		    foreach (var listener in toRemoveListeners)
			    RemoveListener(listener);
			
		    using var toHandleListeners = PooledList<EventListener>.Get();
		    var specificListeners = _gameEventListeners.GetValueOrDefault(e.type);
		    toHandleListeners.AddRange(_generalListeners);
		    if (specificListeners != null)
			    toHandleListeners.AddRange(specificListeners);
			
		    foreach (var l in toHandleListeners)
		    {
			    try
			    {
				    await l.HandleEvent(e);
			    } catch(Exception ex) {
				    Debug.LogException(ex);
			    }
		    }
	    }
	    finally
	    {
		    // if (transaction != null && !transaction.IsFinished)
		    // 	transaction.Finish();
	    }

	    e.Recycle();
    }
}

public interface EventListener
{
	UniTask HandleEvent(GameEvent e);
}

public static class GameEventExtensions
{
	public static bool PickItemFromArguments(this GameEvent e, Func<PlayerItemMessage, bool> predicate)
	{
		return e.PickItemFromArguments(predicate, out _);
	}
	
	public static bool PickItemFromArguments(this GameEvent e, Func<PlayerItemMessage, bool> predicate, out PlayerItemMessage foundItem)
	{
		foundItem = null;
		if (e.args.GetSafe(0) is List<PlayerItemMessage> items)
		{
			foreach (var itemMessage in items)
			{
				if (predicate(itemMessage))
				{
					foundItem = itemMessage;
					return true;
				}
			}
		}

		return false;
	}
}