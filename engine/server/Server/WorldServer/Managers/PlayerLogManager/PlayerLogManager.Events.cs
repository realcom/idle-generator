using Commons.Resources;
using Server.Events;
using Server.Models;

namespace WorldServer.Managers.PlayerLogManager;

public partial class PlayerLogManager : IServerEventSubscriber
{
    public void HandleEvent(ServerEvent @event)
    {
        switch (@event.EventType)
        {
            case ServerEvent.Type.ItemLevelUpEvent:
            {
                var ev = (ItemLevelUpEvent)@event;
                var resItem = ev.Item.Data;

                if (resItem.Id == ResourceItem.Global.DataId.PlayerLevel)
                {
                    Queue(PlayerLogModel.Type.LevelUp, new
                    {
                        Level = ev.Item.level,
                    });
                }
                
                break;
            }
        }
    }
}
