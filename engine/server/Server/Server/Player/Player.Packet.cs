using Commons.Packets;
using Commons.Packets.Updates;
using Commons.Types.Players;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    public void SendAcquiredItemsUpdate(IEnumerable<PlayerItemMessage> addedItems,
        PlayerAcquiredItemsUpdate.Types.Type type = PlayerAcquiredItemsUpdate.Types.Type.Unspecified,
        int achievementDataId = 0, int mapDataId = 0, int productItemDataId = 0,
        Action<PlayerAcquiredItemsUpdate>? handleUpdateAction = null,
        bool silent = false)
    {
        var update = new PlayerAcquiredItemsUpdate
        {
            Type = type,
            AchievementDataId = achievementDataId,
            MapDataId = mapDataId,
            ProductItemDataId = productItemDataId,
            Silent = silent,
            Items = { addedItems }
        };
        if (update.Items.Count == 0)
            return;
        handleUpdateAction?.Invoke(update);
        var packet = Packet.Pop(GetNextPacketKey(), update);
        SendPacket(packet);
    }

    public void SendDisplayMessageUpdate(PlayerDisplayMessageUpdate.Types.Type type = PlayerDisplayMessageUpdate.Types.Type.Toast,
        string title = "", string message = "")
    {
        var update = new PlayerDisplayMessageUpdate
        {
            Type = type,
            Title = title,
            Message = message
        };
        var packet = Packet.Pop(GetNextPacketKey(), update);
        SendPacket(packet);
    }
}
