using Server.Models;

namespace Commons.Utility;

public static class PlayerItemStaminaExtensions
{
    public static int GetBoostedMaxStamina(this PlayerItemModel item, float maxStaminaBoostRatio)
    {
        return (int)(item.Data.MaxStamina * maxStaminaBoostRatio + 1e-3);
    }

    public static int GetBoostedStaminaRegenPerSecond(this PlayerItemModel item, float staminaRegenBoostRatio)
    {
        return (int)(item.Data.StaminaRegenPerSecond * staminaRegenBoostRatio + 1e-3);
    }

    public static bool HasMineBinding(this PlayerItemModel item)
    {
        return item.param3 != 0 || item.param4 != 0;
    }

    public static long GetMineItemId(this PlayerItemModel item)
    {
        if (!item.HasMineBinding())
            return 0L;

        return (long)int.MaxValue * item.param3 + item.param4;
    }

    public static void SetMineItemId(this PlayerItemModel item, long mineItemId)
    {
        if (mineItemId <= 0L)
        {
            item.ClearMineItemId();
            return;
        }

        item.param3 = (int)(mineItemId / int.MaxValue);
        item.param4 = (int)(mineItemId % int.MaxValue);
    }

    public static void ClearMineItemId(this PlayerItemModel item)
    {
        item.param3 = 0;
        item.param4 = 0;
    }

    public static int GetCurrentUnitStamina(this PlayerItemModel item, float maxStaminaBoostRatio,
        float staminaRegenBoostRatio, out int offsetTime)
    {
        if (item.HasMineBinding())
        {
            offsetTime = item.param2;
            return item.param1;
        }

        return PlayerItemModelExtensions.CalculateRegenValue(item.param1, item.GetBoostedMaxStamina(maxStaminaBoostRatio),
            item.GetBoostedStaminaRegenPerSecond(staminaRegenBoostRatio), item.param2, out offsetTime);
    }

    public static void RefreshUnitStamina(this PlayerItemModel item, float maxStaminaBoostRatio,
        float staminaRegenBoostRatio)
    {
        item.param1 = item.GetCurrentUnitStamina(maxStaminaBoostRatio, staminaRegenBoostRatio, out var offsetTime);
        item.param2 = offsetTime;
    }
}
