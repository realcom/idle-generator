using Google.Protobuf;

namespace Commons.Utility
{
    public static class JsonExtensions
    {
        public static string FormatJson(this IMessage message, bool minify = false)
        {
            return minify ? Config.JsonMinFormatter.Format(message) : Config.JsonFormatter.Format(message).Replace("\r\n", "\n");
        }
    }
}
