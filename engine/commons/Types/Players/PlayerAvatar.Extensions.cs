
using Commons.Resources;
using Commons.Types.Units;

namespace Commons.Types.Players
{
    public partial class PlayerAvatar
    {
        public void ApplyAvatarStats(UnitStat stat, int unitLevel = 1)
        {
            if (character_ != null)
            {
                var resItem = character_.GetData();
                if (resItem != null)
                    ResourceUnit.Get(resItem.UnitDataId)?.AddStats.Apply(stat, unitLevel);
                character_.ApplyEquipAddStats(stat, resItem);
            }
            
            foreach (var weapon in weapons_)
                weapon?.ApplyEquipAddStats(stat);
            foreach (var equipment in equipments_)
                equipment?.ApplyEquipAddStats(stat);
            foreach (var pet in pets_)
                pet?.ApplyEquipAddStats(stat);
        }

        public void ApplyAvatarEquipBuffStats(UnitStat stat)
        {
            character_?.ApplyEquipAddBuffAddStats(stat);
            foreach (var weapon in weapons_)
                weapon?.ApplyEquipAddBuffAddStats(stat);
            foreach (var equipment in equipments_)
                equipment?.ApplyEquipAddBuffAddStats(stat);
            foreach (var pet in pets_)
                pet?.ApplyEquipAddBuffAddStats(stat);
        }
    }
}