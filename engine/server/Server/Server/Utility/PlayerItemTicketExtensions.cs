using Commons.Resources;
using Server.Models;

namespace Commons.Utility;

public readonly record struct PlayerItemTicketState(
    long Count,
    int RegenReserveCount,
    int RefreshOffsetTime)
{
    public long TotalCount => Count + RegenReserveCount;

    public int GetEffectiveMaxCount(ResourceItem data, int maxCountBonus = 0)
    {
        return data.MaxCount + maxCountBonus;
    }

    public int GetEffectiveRegenPeriod(ResourceItem data, int regenPeriodBonus = 0)
    {
        return data.RegenPeriod + regenPeriodBonus;
    }
}

public static class PlayerItemTicketExtensions
{
    public static PlayerItemTicketState GetTicketState(this PlayerItemModel item)
    {
        return new PlayerItemTicketState(item.count, item.param1, item.param2);
    }

    public static void SetTicketState(this PlayerItemModel item, PlayerItemTicketState state)
    {
        item.count = state.Count;
        item.param1 = state.RegenReserveCount;
        item.param2 = state.RefreshOffsetTime;
        item.param3 = 0;
        item.param4 = 0;
    }

    public static long GetTicketTotalCount(this PlayerItemModel item)
    {
        return item.GetTicketState().TotalCount;
    }

    public static int GetTicketEffectiveMaxCount(this PlayerItemModel item, int maxCountBonus = 0)
    {
        return item.GetTicketState().GetEffectiveMaxCount(item.Data, maxCountBonus);
    }

    public static int GetTicketEffectiveRegenPeriod(this PlayerItemModel item, int regenPeriodBonus = 0)
    {
        return ResolveTicketRegenPeriod(item, regenPeriodBonus);
    }

    public static DateTime EnsureTicketRefreshScheduled(this PlayerItemModel item, DateTime now)
    {
        return item.EnsureTicketRefreshScheduled(now, 0, 0);
    }

    public static DateTime EnsureTicketRefreshScheduled(this PlayerItemModel item, DateTime now, int maxCountBonus,
        int regenPeriodBonus)
    {
        if (item.Data.RegenPeriod == 0)
            return DateTime.MaxValue;

        ValidateTicketRegenConfiguration(item);

        var offsetTime = now.ToOffsetTime();
        var state = item.GetTicketState();
        var maxCount = state.GetEffectiveMaxCount(item.Data, maxCountBonus);
        if (state.TotalCount >= maxCount)
        {
            if (state.RefreshOffsetTime != 0)
                item.SetTicketState(state with { RefreshOffsetTime = 0 });
            return DateTime.MaxValue;
        }

        var regenPeriod = ResolveTicketRegenPeriod(item, regenPeriodBonus);
        if (state.RefreshOffsetTime == 0)
        {
            state = state with { RefreshOffsetTime = offsetTime };
            item.SetTicketState(state);
        }

        var remainingSeconds = regenPeriod - (offsetTime - state.RefreshOffsetTime);
        return remainingSeconds < 60 ? now.AddMinutes(1) : now.AddSeconds(remainingSeconds);
    }

    public static DateTime RefreshTicketCount(this PlayerItemModel item, DateTime now)
    {
        return item.RefreshTicketCount(now, 0, 0);
    }

    public static DateTime RefreshTicketCount(this PlayerItemModel item, DateTime now, int maxCountBonus,
        int regenPeriodBonus)
    {
        if (item.Data.RegenPeriod == 0)
            return DateTime.MaxValue;

        ValidateTicketRegenConfiguration(item);

        var offsetTime = now.ToOffsetTime();
        var state = item.GetTicketState();
        var maxCount = state.GetEffectiveMaxCount(item.Data, maxCountBonus);
        if (state.TotalCount >= maxCount)
        {
            if (state.RefreshOffsetTime != 0)
                item.SetTicketState(state with { RefreshOffsetTime = 0 });
            return DateTime.MaxValue;
        }

        var regenPeriod = ResolveTicketRegenPeriod(item, regenPeriodBonus);
        if (state.RefreshOffsetTime == 0)
            state = state with { RefreshOffsetTime = offsetTime };

        var totalCount = state.TotalCount;
        var regenCount = (int)Math.Min(maxCount - totalCount, (offsetTime - state.RefreshOffsetTime) / regenPeriod);
        var reachedMaxCount = totalCount + regenCount >= maxCount;

        state = state with
        {
            RegenReserveCount = state.RegenReserveCount + regenCount,
            RefreshOffsetTime = reachedMaxCount ? 0 : state.RefreshOffsetTime + regenPeriod * regenCount,
        };
        item.SetTicketState(state);

        return reachedMaxCount ? DateTime.MaxValue : item.EnsureTicketRefreshScheduled(now, maxCountBonus, regenPeriodBonus);
    }

    private static void ValidateTicketRegenConfiguration(PlayerItemModel item)
    {
        if (item.Data.ContainsTag(Tag.AddParam1ToCount))
            return;

        throw new InvalidResourceException(item.Data, "Data with RegenPeriod requires the AddParam1ToCount tag");
    }

    private static int ResolveTicketRegenPeriod(PlayerItemModel item, int regenPeriodBonus)
    {
        var regenPeriod = item.GetTicketState().GetEffectiveRegenPeriod(item.Data, regenPeriodBonus);
        if (regenPeriod <= 0)
            throw new InvalidResourceException(item.Data, "Ticket regen period must be positive");
        return regenPeriod;
    }
}
