using Server;

namespace WorldServer;

public partial class WorldServer(int port) : Server<WorldServer, WorldPlayer.WorldPlayer>(port)
{
}
