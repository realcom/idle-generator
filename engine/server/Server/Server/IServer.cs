using Server.Player;

namespace Server;

public interface IServer
{
    public bool OnMaintenance { get; }
    public IPlayer? GetIPlayerById(long id);
}
