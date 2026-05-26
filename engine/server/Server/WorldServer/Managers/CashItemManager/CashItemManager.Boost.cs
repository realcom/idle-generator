using Commons.Resources;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private sealed class BoostState
    {
        public float MineBoostEfficiency { get; set; } = 1f;
        public float MaxStaminaBoostRatio { get; set; } = 1f;
        public float StaminaRegenBoostRatio { get; set; } = 1f;
        public DateTime? RefreshAt { get; set; }

        public Dictionary<int, int> RegenMaxCountBonusByItemDataId { get; } = new();
        public Dictionary<int, int> RegenCountBonusByItemDataId { get; } = new();
        public Dictionary<int, float> ScoutRewardPercentByMapGroup { get; } = new();
        public Dictionary<int, int> ScoutMaxMinutesBonusByMapGroup { get; } = new();

        public int GetRegenMaxCountBonus(int itemDataId)
        {
            return RegenMaxCountBonusByItemDataId.GetValueOrDefault(itemDataId);
        }

        public int GetRegenCountBonus(int itemDataId)
        {
            return RegenCountBonusByItemDataId.GetValueOrDefault(itemDataId);
        }

        public float GetScoutRewardMultiplier(int mapGroup)
        {
            return 1f + ScoutRewardPercentByMapGroup.GetValueOrDefault(mapGroup) / 100f;
        }

        public int GetScoutMaxMinutesBonus(int mapGroup)
        {
            return ScoutMaxMinutesBonusByMapGroup.GetValueOrDefault(mapGroup);
        }
    }

    public float MineBoostEfficiency { get; private set; } = 1f;
    public float MaxStaminaBoostRatio { get; private set; } = 1f;
    public float StaminaRegenBoostRatio { get; private set; } = 1f;
    
    public DateTime? RefreshBoostsAt { get; private set; }

    private BoostState BuildBoostState()
    {
        var boostState = new BoostState();
        var mineBoostEfficiencyPercent = 0f;
        var maxStaminaBoostPercent = 0f;
        var staminaRegenBoostPercent = 0f;
        DateTime? refreshAt = null;

        foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Boost))
        {
            var item = GetItemByDataId(resItem.Id, checkUntilAt: true);
            if (item == null)
                continue;

            if (resItem.Type == ResourceItem.Types.Type.MineBoost)
                mineBoostEfficiencyPercent += resItem.EfficiencyPercent;
            else if (resItem.Type == ResourceItem.Types.Type.MaxStaminaBoost)
                maxStaminaBoostPercent += resItem.BoostPercent;
            else if (resItem.Type == ResourceItem.Types.Type.StaminaRegenBoost)
                staminaRegenBoostPercent += resItem.BoostPercent;

            if (item.until_at != null && (refreshAt == null || item.until_at < refreshAt))
                refreshAt = item.until_at;
        }

        foreach (var item in GetItemsByTag(Tag.BoostMaxCount))
            AddBoostValue(boostState.RegenMaxCountBonusByItemDataId, item.Data.BoostMaxCountItemDataId, item.Data.BoostMaxCount);

        foreach (var item in GetItemsByTag(Tag.BoostRegenCount))
            AddBoostValue(boostState.RegenCountBonusByItemDataId, item.Data.BoostRegenCountItemDataId, item.Data.BoostRegenCount);

        foreach (var item in GetItemsByTag(Tag.BoostScoutReward, checkCount: true, checkUntilAt: true, checkDeprecated: true))
            AddBoostValue(boostState.ScoutRewardPercentByMapGroup, item.Data.MapGroup, item.Data.BoostScoutRewardPercent);

        foreach (var item in GetItemsByTag(Tag.BoostScoutMaxMinutes, checkCount: true, checkUntilAt: true, checkDeprecated: true))
            AddBoostValue(boostState.ScoutMaxMinutesBonusByMapGroup, item.Data.MapGroup, item.Data.BoostScoutMaxMinutes);

        boostState.MineBoostEfficiency = 1f + mineBoostEfficiencyPercent / 100f;
        boostState.MaxStaminaBoostRatio = 1f + maxStaminaBoostPercent / 100f;
        boostState.StaminaRegenBoostRatio = 1f + staminaRegenBoostPercent / 100f;
        boostState.RefreshAt = refreshAt;
        return boostState;
    }

    private static void AddBoostValue(Dictionary<int, int> bonuses, int key, int value)
    {
        if (value == 0)
            return;

        bonuses[key] = bonuses.GetValueOrDefault(key) + value;
    }

    private static void AddBoostValue(Dictionary<int, float> bonuses, int key, float value)
    {
        if (Math.Abs(value) < 1e-6f)
            return;

        bonuses[key] = bonuses.GetValueOrDefault(key) + value;
    }

    private void RefreshBoosts()
    {
        var boostState = BuildBoostState();
        MineBoostEfficiency = boostState.MineBoostEfficiency;
        MaxStaminaBoostRatio = boostState.MaxStaminaBoostRatio;
        StaminaRegenBoostRatio = boostState.StaminaRegenBoostRatio;
        RefreshBoostsAt = boostState.RefreshAt;
    }
}
