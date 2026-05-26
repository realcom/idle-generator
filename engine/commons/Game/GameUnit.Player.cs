using System;
using Commons.Resources;
using Commons.Types.Players;

namespace Commons.Game
{
    public partial class GameUnit
    {
        public BoardPlayerMessage? Player => Board.GetPlayerById(playerId_);
        
        internal void ChangePlayerAvatarWeaponSlot(int slot)
        {
            if (slot < 0 || slot >= Types.Players.PlayerAvatar.WeaponSlot.Size)
                return;
            playerAvatarWeaponSlot_ = slot;
        }

        private void UpdatePlayer()
        {
            if (playerId_ == 0L)
                return;
            var player = Player;
            if (player == null)
                return;

            foreach (var inventory in player.Inventories)
            {
                foreach (var row in inventory.Rows)
                {
                    foreach (var item in row.Items)
                    {
                        if (item.ItemDataId == 0)
                            continue;
                        var resItem = item.GetData()!;
                        if (resItem.Type != ResourceItem.Types.Type.InventorySkill)
                            continue;
                        if (resItem.ContainsTag(Tag.UseSkillWhenHasTarget) && targetUnitId_ == 0L)
                            continue;
                        UseSkill(resItem.SkillDataId, level: resItem.Grade, itemId: item.Id, itemDataId: item.ItemDataId);
                    }
                }
            }
            
            var hpRatio = (int)(hp_ * 100 / MaxHp);
            
            player.IncreaseMission(
                new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionUnitHpBelow,
                    ResourceAchievement.ConditionQuery.Comparer.LessOrEqual, hpRatio),
                1);
            
            player.IncreaseMission(
                new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionUnitNoDamageDuration,
                    ResourceAchievement.ConditionQuery.Comparer.GreaterOrEqual, (int) GameBoard.TicksToTime(noDamageTick_)),
                1);
        }
    }
}