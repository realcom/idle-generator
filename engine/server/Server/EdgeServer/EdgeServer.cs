using Server;

namespace EdgeServer;

public partial class EdgeServer(int port) : Server<EdgeServer, EdgePlayer.EdgePlayer>(port)
{
}
