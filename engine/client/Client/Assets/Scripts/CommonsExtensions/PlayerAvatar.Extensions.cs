

using Commons.Resources;

namespace Commons.Types.Players {

    public partial class PlayerAvatar
    {
        public int GetEmptyPetSlot()
        {
            for (var i = 0; i < PetSlot.Size; i++)
            {
                var achievementDataId = ResourceAchievement.Global.DataId.PetSlotUnlocks.GetSafe(i);
                if (achievementDataId != 0 && !MyPlayer.IsAchievementCompletedOrRewarded(achievementDataId))
                    continue;

                if (Pets.GetSafe(i) is { Id: 0 })
                    return i;
            }

            return -1;
        }
        
        public int GetDeployedPetSlot(long petId)
        {
            for (var i = 0; i < PetSlot.Size; i++)
            {
                if (Pets.GetSafe(i) is { Id: var id } && id == petId)
                    return i;
            }

            return -1;
        }
        
    }
}