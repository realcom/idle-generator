using Commons.Game.Events;
using Commons.Resources;
using Commons.Utility;
using Server.Events;
using static Commons.Game.Events.BoardEvent.Type;
using static Commons.Resources.ResourceAchievement.ConditionQuery;
using static Commons.Resources.ResourceAchievement.Types;
using BoardEvent = Server.Events.BoardEvent;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager : IServerEventSubscriber
{
    public void HandleEvent(ServerEvent @event)
    {
        switch (@event.EventType)
        {
            case ServerEvent.Type.BoardEvent:
            {
                var boardEvent = ((BoardEvent)@event).Event;
                
                switch (boardEvent.EventType)
                {
                    case EndGame:
                    {
                        var endGame = (EndGameEvent)boardEvent;
                        var board = Player.Board!; 
                        var playerUnit = board.GetUnitByPlayerId(Player.Id);
                        if (playerUnit == null)
                            break;

                        if (endGame.WinningTeam == playerUnit.Team)
                        {
                            var scoutItems = GetItemsByType(ResourceItem.Types.Type.Scout).Where(e => e.Data.MapGroup == board.ResMap.Group);
                            foreach (var scoutItem in scoutItems)
                            {
                                scoutItem.param1 = board.ResMap.Id;
                                if (scoutItem.param2 == 0)
                                    scoutItem.param2 = DateTime.UtcNow.ToOffsetTime();
                            }
                        }
                        break;
                    }
                }

                break;
            }
            case ServerEvent.Type.ItemLevelUpEvent:
            {
                var ev = (ItemLevelUpEvent)@event;
                if (ev.Item.item_data_id == ResourceItem.Global.DataId.PlayerLevel)
                {
                    Player.Level = ev.Item.level;
                }
                break;
            }
        }
    }
}
