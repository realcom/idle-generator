using System.Diagnostics;
using System.Reflection;
using Commons;
using Commons.Resources;
using log4net;
using Server;
using Server.Managers;
using WorldServer.Managers;

Logger.Init(typeof(WorldServer.WorldServer));

await Config.Reload(false).ConfigureAwait(false);
#if DEBUG
Config.LogInfo("Debug build");
#else
Config.LogInfo("Release build");
#endif
Config.LogInfo(Config.IsDebug ? "Config.IsDebug enabled" : "Config.IsDebug disabled");
var debuggableAttribute = typeof(Program).Assembly.GetCustomAttribute<DebuggableAttribute>();
if (debuggableAttribute == null || !debuggableAttribute.IsJITOptimizerDisabled)
    Config.LogInfo("JIT Optimizations enabled");
else
    Config.LogInfo("JIT Optimizations disabled");

ResourceManager.ReloadJson(Config.Path.Resources);

DbManager.Init();

BoardManager.BoardAutoProgress = false;
BoardManager.BoardServerUpdateIntervalSeconds = 0.5f;
await WorldManager.ReloadWorldModels();
// await Config.ReloadCommonsCommitHash();

WorldServer.WorldServer? server = null;
try
{
    server = await new WorldServer.WorldServer(Config.Server.WorldPort).Start(Config.Server.WorldWebSocket).ConfigureAwait(false);
    BoardManager.Server = server;
    ChatManager.Server = server;
    Console.CancelKeyPress += (_, e) =>
    {
        e.Cancel = true;
        server.Stop().Wait();
    };
    while (server.IsRunning)
        await Task.Delay(1000).ConfigureAwait(false);
}
finally
{
    if (server != null)
        await server.Stop().ConfigureAwait(false);
}
