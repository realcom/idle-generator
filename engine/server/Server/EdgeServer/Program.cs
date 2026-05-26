using System.Diagnostics;
using System.Reflection;
using Commons;
using Commons.Resources;
using log4net;
using Server;
using Server.Managers;

Logger.Init(typeof(EdgeServer.EdgeServer));

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

Config.LogError("EdgeServer is disabled because its player/login flow is not implemented yet.");
Environment.ExitCode = 1;
