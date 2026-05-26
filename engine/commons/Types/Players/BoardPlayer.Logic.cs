using System;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;

namespace Commons.Types.Players
{
    public partial class BoardPlayerMessage
    {
        public GameBoard Board { set; get; }

        public bool AddAcquireItem(GameUnit unit, ResourceItem resItem, long count, int level,
            bool enableUnitExp = false)
        {
            switch (resItem.Category)
            {
                case ResourceItem.Types.Category.InventoryBundle:
                {
                    rootedInventories_.Add(Board.MakeInventory(this, resItem));
                    if (holdItems_.Count == 0)
                        Board.MoveRootedInventoryToHold(this);
                    return true;
                }
            }
            if (resItem.Id == ResourceItem.Global.DataId.Gold)
            {
                Gold += count;
                HandleGoldChange(count);
            }
            else if (resItem.Id == ResourceItem.Global.DataId.Exp)
            {
                if (enableUnitExp)
                {
                    unit.AddExp(count);
                }
            }
            
            var itemAdded = false;
            foreach (var acquiredItem in AcquiredItems)
            {
                if (acquiredItem.ItemDataId == resItem.Id && acquiredItem.Level == level)
                {
                    acquiredItem.Count += count;
                    itemAdded = true;
                    break;
                }
            }

            if (!itemAdded)
            {
                AcquiredItems.Add(new PlayerItemMessage
                {
                    ItemDataId = resItem.Id,
                    Count = count,
                    Level = level,
                    Grade = resItem.Grade,
                });
            }

            return true;
        }

        public void HandleGoldChange(long goldChange)
        {
            if (goldChange == 0)
                return;

            IncreaseMission(
                new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionGoldBalance,
                    ResourceAchievement.ConditionQuery.Comparer.GreaterOrEqual, (int)Gold),
                1);
        }
    }
}