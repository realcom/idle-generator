using Commons.Packets.Requests;
using Server;
using Server.Session;

namespace EdgeServer;

public partial class EdgeServer
{
    protected override async Task<EdgePlayer.EdgePlayer?> LoginInternal(Session<EdgeServer, EdgePlayer.EdgePlayer> session, LoginRequest loginRequest)
    {
        throw new NotImplementedException();
    }
}