using System.Reflection;
using System.Text;
using Commons;
using log4net;
using log4net.Config;

namespace Server;

public static class Logger
{
    public static void Init(Type type)
    {
        const string config = """
<log4net>
    <appender name="ConsoleAppender" type="log4net.Appender.ConsoleAppender">
        <layout type="log4net.Layout.PatternLayout">
            <conversionPattern value="%date [%thread] %-5level %logger - %message%newline" />
        </layout>
    </appender>

    <appender name="RollingFileAppender" type="log4net.Appender.RollingFileAppender">
        <file value="logs/server.log" />
        <appendToFile value="true" />
        <rollingStyle value="Size" />
        <maxSizeRollBackups value="10" />
        <maximumFileSize value="10MB" />
        <staticLogFileName value="true" />
        <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%date [%thread] %-5level %logger - %message%newline" />
        </layout>
    </appender>

    <root>
        <level value="ALL" />
        <appender-ref ref="ConsoleAppender" />
        <appender-ref ref="RollingFileAppender" />
    </root>
</log4net>
""";
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes(config));
        XmlConfigurator.Configure(LogManager.CreateRepository(""), stream);

        var logger = LogManager.GetLogger("", type);
        Config.LogInfo = logger.Info;
        Config.LogError = logger.Error;
    }
}
