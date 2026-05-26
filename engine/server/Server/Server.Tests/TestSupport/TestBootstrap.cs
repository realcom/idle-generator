using System.IO;
using System.Runtime.CompilerServices;

namespace Server.Tests.TestSupport;

internal static class TestBootstrap
{
    [ModuleInitializer]
    internal static void Initialize()
    {
        Directory.CreateDirectory(Path.Combine(Environment.CurrentDirectory, "logs"));
        global::Server.Logger.Init(typeof(TestBootstrap));
    }
}
