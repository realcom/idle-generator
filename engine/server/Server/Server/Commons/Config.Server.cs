using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class ServerConfig
    {
        public int WorldPort { get; set; } = 11177;
        public bool WorldWebSocket { get; set; }
        public string? WorldProtocol { get; set; }

        public int EdgePort { get; set; } = 11178;
        public bool EdgeWebSocket { get; set; }
        public string? EdgeProtocol { get; set; }

        public bool EnablePushServices { get; set; } = true;
    }
    
    public static ServerConfig Server { get; private set; } = new();

    private static void LoadServerConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Server), out var serverConfig))
        {
            var server = serverConfig.ToObject<ServerConfig>()!;
            server.WorldProtocol ??= server.WorldWebSocket ? "WebSocket" : "TcpAndWebSocket";
            server.EdgeProtocol ??= server.EdgeWebSocket ? "WebSocket" : "TcpAndWebSocket";
            server.EnablePushServices = GetEnvBool(server.EnablePushServices, "IDLEZ_ENABLE_PUSH_SERVICES");
            Server = server;
        }
    }
}
