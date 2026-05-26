using Commons.Game.Events;
using Commons.Resources;
using Server.Events;
using static Commons.Game.Events.BoardEvent.Type;
using static Commons.Resources.ResourceAchievement.ConditionQuery;
using static Commons.Resources.ResourceAchievement.Types;
using BoardEvent = Server.Events.BoardEvent;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager : IServerEventSubscriber
{
    public void HandleEvent(ServerEvent @event)
    {
        switch (@event.EventType)
        {
            case ServerEvent.Type.ItemAddedEvent:
            {
                var ev = (ItemAddedEvent)@event;
                var resItem = ev.Item.Data;
                var achievementItemDataId = resItem.AchievementItemDataId > 0
                    ? resItem.AchievementItemDataId
                    : resItem.Id;
                var count = (int)Math.Min(int.MaxValue, ev.Count);
                IncreaseAchievement(Condition.AcquireItemAny, count, ev.AddedItemStuffs);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.AcquireItem, Comparer.Equal, achievementItemDataId),
                    count,
                    ev.AddedItemStuffs);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.AcquireItemLevel,
                        Comparer.Equal, achievementItemDataId,
                        Comparer.GreaterOrEqual, ev.Level),
                    count,
                    ev.AddedItemStuffs);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.AcquireItemGrade,
                        Comparer.Equal, achievementItemDataId,
                        Comparer.GreaterOrEqual, resItem.Grade),
                    count,
                    ev.AddedItemStuffs);

                if (Enum.TryParse($"Acquire{resItem.Category}ItemAny", out Condition acquireCondition))
                    IncreaseAchievement(acquireCondition, count, ev.AddedItemStuffs);
                if (Enum.TryParse($"Acquire{resItem.Category}ItemGrade", out acquireCondition))
                    IncreaseAchievement(
                        new ResourceAchievement.ConditionQuery(acquireCondition,
                            Comparer.GreaterOrEqual, resItem.Grade),
                        count,
                        ev.AddedItemStuffs);
                if (Enum.TryParse($"Acquire{resItem.Type}ItemAny", out acquireCondition))
                    IncreaseAchievement(acquireCondition, count,
                        ev.AddedItemStuffs);
                if (Enum.TryParse($"Acquire{resItem.Type}ItemGrade", out acquireCondition))
                    IncreaseAchievement(
                        new ResourceAchievement.ConditionQuery(acquireCondition,
                            Comparer.GreaterOrEqual, resItem.Grade),
                        count,
                        ev.AddedItemStuffs);
                
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.HasItem,
                        Comparer.Equal, achievementItemDataId,
                        Comparer.GreaterOrEqual, ev.Item.count > int.MaxValue ? int.MaxValue : (int)ev.Item.count),
                    -1,
                    ev.AddedItemStuffs);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.HasItemLevel,
                        Comparer.Equal, achievementItemDataId,
                        Comparer.GreaterOrEqual, ev.Level),
                    -1,
                    ev.AddedItemStuffs);
                
                break;
            }
            case ServerEvent.Type.ItemLevelUpEvent:
            {
                var ev = (ItemLevelUpEvent)@event;
                var resItem = ev.Item.Data;
                var achievementItemDataId = resItem.AchievementItemDataId > 0
                    ? resItem.AchievementItemDataId
                    : resItem.Id;
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.HasItemLevel,
                        Comparer.Equal, achievementItemDataId,
                        Comparer.GreaterOrEqual, ev.Item.level),
                    -1);
                IncreaseAchievement(Condition.LevelUpItemAny, ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.LevelUpItem, Comparer.Equal, achievementItemDataId),
                    ev.Count);
                break;
            }
            case ServerEvent.Type.ItemAddExpEvent:
            {
                var ev = (ItemAddExpEvent)@event;
                var resItem = ev.Item.Data;
                var achievementItemDataId = resItem.AchievementItemDataId;

                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.ExpUpItem, Comparer.Equal, achievementItemDataId),
                    (int) ev.Exp);
                
                break;
            }
            case ServerEvent.Type.ItemCreateEvent:
            {
                var ev = (ItemCreateEvent)@event;
                var achievementItemDataId = ev.ResRecipeItem.AchievementItemDataId > 0
                    ? ev.ResRecipeItem.AchievementItemDataId
                    : ev.ResRecipeItem.Id;
                IncreaseAchievement(Condition.CreateItemAny, ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.CreateItemRecipe, Comparer.Equal, achievementItemDataId),
                    ev.Count);
                break;
            }
            case ServerEvent.Type.ItemUseEvent:
            {
                var ev = (ItemUseEvent)@event;
                var resItem = ev.Item.Data;
                var achievementItemDataId = resItem.AchievementItemDataId > 0
                    ? resItem.AchievementItemDataId
                    : resItem.Id;
                IncreaseAchievement(Condition.UseItemAny, ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.UseItem, Comparer.Equal, achievementItemDataId),
                    ev.Count);
                switch (resItem.Category)
                {
                    case ResourceItem.Types.Category.Unit:
                    {
                        if (ev.TargetItemId == 0L && ev.Param1 == 0)
                        {
                            IncreaseAchievement(
                                new ResourceAchievement.ConditionQuery(Condition.UseUnitItemAvatar, Comparer.Equal, ev.Param2),
                                ev.Count);
                        }
                        break;
                    }
                }
                break;
            }
            case ServerEvent.Type.ItemBuyEvent:
            {
                var ev = (ItemBuyEvent)@event;
                var achievementItemDataId = ev.ResProductItem.AchievementItemDataId > 0
                    ? ev.ResProductItem.AchievementItemDataId
                    : ev.ResProductItem.Id;
                IncreaseAchievement(Condition.BuyItemAny, ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.BuyItemProduct, Comparer.Equal, achievementItemDataId),
                    ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.BuyItemProductAction, Comparer.Equal, achievementItemDataId));
                break;
            }
            case ServerEvent.Type.ItemConsumeEvent:
            {
                var ev = (ItemConsumeEvent)@event;
                var achievementItemDataId = ev.Item.Data.AchievementItemDataId;
                IncreaseAchievement(Condition.ConsumeItemAny, ev.Count);
                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(Condition.ConsumeItem, Comparer.Equal, achievementItemDataId),
                    ev.Count);
                break;
            }
            case ServerEvent.Type.BoardEvent:
            {
                var boardEvent = ((BoardEvent)@event).Event;
                switch (boardEvent.EventType)
                {
                    case UseSkill:
                    {
                        var useSkill = (UseSkillEvent)boardEvent;
                        if (useSkill.SenderPlayerId == Player.Id)
                        {
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.UseSkillAny));
                            var resSkill = ResourceSkill.Get(useSkill.SkillDataId)!;
                            var achievementSkillDataId = resSkill.AchievementSkillDataId;

                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.UseSkill, Comparer.Equal, achievementSkillDataId));
                        }
                        break;
                    }
                    case UnitDeath:
                    {
                        var unitDeath = (UnitDeathEvent)boardEvent;
                        if (unitDeath.AttackerPlayerId == Player.Id)
                        {
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.KillUnitAny));
                            var resUnit = ResourceUnit.Get(unitDeath.UnitDataId)!;
                            var achievementUnitDataId = resUnit.AchievementUnitDataId > 0
                                ? resUnit.AchievementUnitDataId
                                : unitDeath.UnitDataId;
                            IncreaseAchievement(
                                new ResourceAchievement.ConditionQuery(Condition.KillUnit, Comparer.Equal, achievementUnitDataId));
                        }
                        break;
                    }
                    case EndGame:
                    {
                        var endGame = (EndGameEvent)boardEvent;
                        var board = Player.Board!;
                        var playerUnit = board.GetUnitByPlayerId(Player.Id);
                        if (playerUnit == null)
                            break;
                        var achievementMapDataId = board.ResMap.AchievementMapDataId > 0
                            ? board.ResMap.AchievementMapDataId
                            : board.ResMap.Id;
                        if (endGame.WinningTeam == playerUnit.Team)
                        {
                            IncreaseAchievement(Condition.WinGameAny);
                            
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.WinGame, Comparer.Equal, achievementMapDataId));
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.WinWave,
                                Comparer.Equal, achievementMapDataId));
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.WinGameGroup, Comparer.Equal, board.ResMap.Group));
                        }
                        else
                        {
                            IncreaseAchievement(Condition.LoseGameAny);
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.LoseGame, Comparer.Equal, achievementMapDataId));
                            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.LoseGameGroup, Comparer.Equal, board.ResMap.Group));
                        }
                        break;
                    }
                }
                break;
            }
        }
    }
}
