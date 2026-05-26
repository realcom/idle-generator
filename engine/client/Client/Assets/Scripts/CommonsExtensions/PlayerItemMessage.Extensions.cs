
using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility;
using Interfaces;

namespace Commons.Types.Players
{
    public partial class PlayerItemMessage : IItemModelViewFormatter<PlayerItemMessage>
    {
        
        public int GetBonusLevel()
        {
            var bonusLevel = 0;
            var resItem = this.GetData();
            if (resItem == null)
                return bonusLevel;
            
            foreach (var resourceItem in ResourceItem.GetAllByTag(Tag.BonusItemLevel))
            {
                if (!resourceItem.TargetItemDataIds.Contains(itemDataId_))
                    continue;
                
                var item = MyPlayer.GetItemByDataID(resourceItem.Id, checkCount: true);
                if (item == null)
                    continue;
                
                bonusLevel += item.GetData()!.BonusItemLevel;
            }

            return bonusLevel;
        }

        public bool CheckUntilAt()
        {
            var now = TimeSystem.time;
            if (UntilAt != null && UntilAt.Seconds < now)
                return false;

            return true;
        }
        
        public bool IsEquipped()
        {
            return MyPlayer.PlayerAvatar?.Equipments?.Any(x => x.Id == Id) == true;
        }

        public bool IsDeployed()
        {
            return MyPlayer.PlayerAvatar?.Pets?.Any(x => x.Id == Id) == true;
        }
    
        public bool IsValid(bool checkCount = true, bool checkTimeValid = true, bool checkDeprecated = true, bool checkRequiredAndExclusive = false)
        {
            if (ItemDataId == 0)
                return false;

            if (checkCount && GetCount() <= 0)
                return false;

            var resItem = GetData()!;
            if (checkDeprecated && resItem.ContainsTag(Tag.Deprecated))
                return false;
        
            if (checkTimeValid && (!CheckUntilAt() || resItem.IsValidNow() == false))
                return false;

            if (checkRequiredAndExclusive && !resItem.IsValidByRequiredAndExclusive())
                return false;
        
            return true;
        }

        public bool IsValidAsMaterial()
        {
            if (!IsValid())
                return false;

            if (!IsConsumable)
                return false;

            return true;
        }
    
        public long GetCount()
        {
            if (!IsValid(checkCount: false))
                return 0;

            var itemCount = Count;
            if (GetData()?.ContainsTag(Tag.AddParam1ToCount) == true)
                itemCount += Param1;

            return itemCount;
        }

        public int GetLevel()
        {
            return level_;
        }

        public string GetCountString(bool toShortString = false)
        {
            return ResourceItemExtensions.GetCountString(ItemDataId, GetCount(), toShortString);
        }
        
        public float GetWorkerAppliedEfficiencyPerSecond(PlayerItemMessage unitItem)
        {
            var resMine = this.GetData()!;
            if (resMine.Category != ResourceItem.Types.Category.Mine)
                return 0f;
        
            var mineEfficiency = resMine.EfficiencyPercents.GetClamped(level_ - 1) / 100f;
        
            var resUnitItem = unitItem.GetData()!;
            var boostedEfficiency = resUnitItem.EfficiencyPercent * mineEfficiency / 100f;
        
            var staminaCostPerSecond = resMine.StaminaCostPerSecond;
        
            return boostedEfficiency * MyPlayer.MineBoostEfficiency * staminaCostPerSecond;
        }
    
        public float GetWorkerAppliedEfficiencyPerUnit(PlayerItemMessage unitItem)
        {
            var resMine = this.GetData()!;
            if (resMine.Category != ResourceItem.Types.Category.Mine)
                return 0f;
        
            var mineEfficiency = resMine.EfficiencyPercents.GetClamped(level_ - 1) / 100f;
        
            var resUnitItem = unitItem.GetData()!;
            var boostedEfficiency = resUnitItem.EfficiencyPercent * mineEfficiency / 100f;

            return boostedEfficiency * MyPlayer.MineBoostEfficiency;
        }

        
        public float GetMineEfficiency()
        {
            var resMine = this.GetData()!;
            if (resMine.Category != ResourceItem.Types.Category.Mine)
                return 0f;
        
            var totalProductionDeltaPerSec = 0f;
            if (Option != null)
            {
                foreach (var unitItem in Option.Slots)
                {
                    if (unitItem == null || unitItem.Id == 0)
                        continue;

                    totalProductionDeltaPerSec += GetWorkerAppliedEfficiencyPerSecond(unitItem);
                }
            }
        
            return totalProductionDeltaPerSec;
        }
            
        public PlayerItemMessage GetWorkingMine()
        {
            long mineId = Param3 * int.MaxValue + Param4;
            if (mineId == 0)
                return null;
            return MyPlayer.GetItem(mineId);
        }

        public bool IsWorkerUnit()
        {
            var resUnit = this.GetData()!;
            if (resUnit.Category != ResourceItem.Types.Category.Unit)
                return false;

            return GetWorkingMine() != null;
        }

        public bool CanClaimDailyReward()
        {
            var resItem = GetData()!;
            if (resItem.DailyRewardAddItemGroups.Count <= 0)
                return false;

            if (GetCount() <= 0)
                return false;

            var nowDateSec = DateTime.UtcNow.Date.ToSeconds();
            if (untilAt_?.Seconds <= nowDateSec)
                return false;

            var claimedAt = option_?.DailyRewardOption?.ClaimedAt;
            return claimedAt == null || claimedAt.Seconds < nowDateSec;
        }

    }
    
    public static class PlayerItemMessageExtensions
    {
        public static IEnumerable<PlayerItemMessage> ToValidEnumerable(this IEnumerable<PlayerItemMessage> items)
        {
            foreach (var playerItemMessage in items)
            {
                var resItem = playerItemMessage?.GetData();
                if (resItem == null)
                    continue;

                if (!resItem.CanDisplay)
                    continue;
                
                yield return playerItemMessage;
            }
        }
        
        public static IEnumerable<PlayerItemMessage> ToRewardEnumerable(this IEnumerable<PlayerItemMessage> items)
        {
            foreach (var playerItemMessage in items.ToValidEnumerable())
            {
                if (playerItemMessage.ItemDataId == ResourceItem.Global.DataId.Gold ||
                    playerItemMessage.ItemDataId == ResourceItem.Global.DataId.Exp ||
                    playerItemMessage.ItemDataId == ResourceItem.Global.DataId.Stage ||
                    playerItemMessage.ItemDataId == ResourceItem.Global.DataId.PlayerLevel
                   )
                {
                    continue;
                }
                
                yield return playerItemMessage;
            }
        }
    }
    
}