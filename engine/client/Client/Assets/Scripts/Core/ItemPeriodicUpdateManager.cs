using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using UnityEngine;
using UnityEngine.Pool;
using Object = UnityEngine.Object;


public class ItemPeriodicUpdateManager : ItemUpdatePublisher
{
	private static readonly ItemPeriodicUpdateManager singleton = new();

	public static ItemPeriodicUpdateManager Get() => singleton;
	
	private long _lastUpdateTime;

	// [RuntimeInitializeOnLoadMethod]
	private static void Initialize()
	{
		// ZPlayerLoopSystemHelper.InsertSystemBefore(typeof(TimeSystem), singleton.Update, typeof(UnityEngine.PlayerLoop.Update.ScriptRunBehaviourUpdate));
	}
	
	private void Update()
	{
		return;
		var nowOffset = TimeSystem.offsetTime;
		if (nowOffset - _lastUpdateTime < 1)
			return;
		
		_lastUpdateTime = nowOffset;

		ClientUpdateAllMine();
		ClientUpdateUnitStamina();
		
		MyPlayer.RefreshTotalMaxStaminaBoost();
		MyPlayer.RefreshTotalMineEfficiencyBoost();
		MyPlayer.RefreshTotalStaminaRegenBoost();

		// SendAutoUpdateRelatedPackets();
	}

	private void ClientUpdateUnitStamina()
	{
		var resMap = GameBoardManager.Get()?.gameBoard?.ResMap;
		if (resMap is not { Type: ResourceMap.Types.Type.Lobby })
			return;
		
		using var _ = ListPool<PlayerItemMessage>.Get(out var unitItemList);
		
		unitItemList.AddRange(MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Unit));
		
		foreach (var unitItem in unitItemList)
		{
			var mineOfUnit = unitItem.GetWorkingMine();
			if (mineOfUnit == null)
			{
				var resUnitItem = unitItem.GetData()!;

				var boostAppliedMaxStamina = resUnitItem.GetMaxStamina();
				var boostAppliedStaminaRegenPerSecond = resUnitItem.GetStaminaRegenPerSecond();
				var stamina = PlayerItemModelExtensions.CalculateRegenValue(unitItem.Param1, (int)boostAppliedMaxStamina,
					(int)boostAppliedStaminaRegenPerSecond, unitItem.Param2, out var offsetTime);
				unitItem.Param1 = stamina;
				unitItem.Param2 = offsetTime;
				
				MyPlayer.UpdateItemsArgs(unitItem);
			}
		}
	}

	private void ClientUpdateAllMine()
	{
		var offsetTime = DateTime.UtcNow.ToOffsetTime();
		
		foreach (var mineItem in MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Mine))
		{
			var resMine = mineItem.GetData()!;
        
			// var totalProductionDeltaPerSec = 0f;
			if (mineItem.Option != null)
			{
				foreach (var slotUnitItem in mineItem.Option.Slots)
				{
					if (slotUnitItem == null || slotUnitItem.Id == default)
						continue;
					
					var unitItem = MyPlayer.GetItem(slotUnitItem.Id);

					// totalProductionDeltaPerSec += mineItem.GetWorkerAppliedEfficiency(unitItem);
					var usedStamina = Math.Min(unitItem.Param1, resMine.StaminaCostPerSecond * (offsetTime - unitItem.Param2));
					var score = (int)(mineItem.GetWorkerAppliedEfficiencyPerUnit(unitItem) * usedStamina);
					if (score == 0)
						continue;
					
					var myUnitItem = MyPlayer.GetItem(unitItem.Id);
					if (myUnitItem == null)
						continue;
					myUnitItem.Param1 -= usedStamina;
					myUnitItem.Param2 = offsetTime;
					if (myUnitItem.Param1 <= 0)
						SendAutoUpdateRelatedPackets();
					MyPlayer.UpdateItemsArgs(myUnitItem);
					
					foreach (var addItemGroup in mineItem.GetData()!.AddItemGroups)
					{
						foreach (var addItem in addItemGroup.AddItems)
						{
							var itemDataId = addItem.ItemDataId;
							var count = addItem.Count * score;
							if (count <= 0)
								continue;
					
							var item = MyPlayer.GetItemByDataID(itemDataId);
							item.Count += count;
							MyPlayer.UpdateItemsArgs(item);
						}
					}
				}
			}
		}
	}
	
	public void SendAutoUpdateRelatedPackets()
	{
		//var resMap = GameBoardManager.Get()?.gameBoard?.ResMap;
		//if (resMap is not { Type: ResourceMap.Types.Type.Lobby })
		//	return;
		//
		//var allMineItem = MyPlayer.GetItemByDataID(ResourceItem.Global.DataId.AllMines);
		//if (allMineItem != null)
		//{
		//	var allMineUpdateReq = new UseCashItemRequest
		//	{
		//		ItemId = allMineItem.Id
		//	};
		//	var allMinePacket = Packet.Pop(0, allMineUpdateReq);
		//	ZWorldClient.Get().SendPacket(allMinePacket);
		//}
	}
}

public class ItemUpdatePublisher
{
	private readonly HashSet<ItemUpdateListener> _everyItemListeners = new();
	private readonly Dictionary<int, HashSet<ItemUpdateListener>> _specificItemListeners = new();
	
	public void AddListener(ItemUpdateListener l)
	{
		_everyItemListeners.Add(l);
	}
	
	public bool TryAddSpecificItemListener(int itemDataId, ItemUpdateListener l)
	{
		if (!MyPlayer.PeriodicUpdateItemDataIds.Contains(itemDataId))
			return false;
		
		_everyItemListeners.Remove(l);
		if (!_specificItemListeners.TryGetValue(itemDataId, out var listeners))
			_specificItemListeners[itemDataId] = listeners = new HashSet<ItemUpdateListener>();
		listeners.Add(l);
		return true;
	}
	
	public void RemoveListener(ItemUpdateListener l)
	{
		_everyItemListeners.Remove(l);
		foreach (var listeners in _specificItemListeners.Values)
			listeners.Remove(l);
	}

	public void DispatchItemUpdate(int itemDataId)
	{
		foreach (var l in _everyItemListeners.ToArray())
		{
			if (l is Object obj && !obj)
			{
				RemoveListener(l);
				continue;
			}
		
			try
			{
				l.HandleItemUpdate(itemDataId);
			} catch(Exception ex) {
				Debug.LogException(ex);
			}
		}

		if (_specificItemListeners.TryGetValue(itemDataId, out var listeners))
		{
			foreach (var l in listeners.ToArray())
			{
				if (l is Object obj && !obj)
				{
					RemoveListener(l);
					continue;
				}
		
				try
				{
					l.HandleItemUpdate(itemDataId);
				} catch(Exception ex) {
					Debug.LogException(ex);
				}
			}
		}
    }
}

public interface ItemUpdateListener
{
	void HandleItemUpdate(int itemDataId);
}
