using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class TelegramConfig
    {
        public string? BotToken { get; set; }
        public string? ApiToken { get; set; }
        
        public string? HelloText { get; set; }
        public string? HelloImage { get; set; }
        public string? HelloWebAppText { get; set; }
        public string? HelloWebAppUrl { get; set; }
        public string? HelloAnnouncementText { get; set; }
        public string? HelloAnnouncementUrl { get; set; }
        public string? HelloCommunityText { get; set; }
        public string? HelloCommunityUrl { get; set; }
    }
    
    public static TelegramConfig Telegram { get; private set; } = new();

    private static void LoadTelegramConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Telegram), out var telegramConfig))
        {
            var telegram = telegramConfig.ToObject<TelegramConfig>()!;
            telegram.BotToken = GetEnvString("IDLEZ_TELEGRAM_BOT_TOKEN") ?? telegram.BotToken;
            telegram.ApiToken = GetEnvString("IDLEZ_TELEGRAM_API_TOKEN") ?? telegram.ApiToken;
            Telegram = telegram;
        }
    }
}
