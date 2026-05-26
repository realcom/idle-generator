using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class TonConfig
    {
        public string? Endpoint { get; set; }
        public string? TonAddress { get; set; }
    }

    public static TonConfig Ton { get; private set; } = new();

    private static void LoadTonConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Ton), out var tonConfig))
        {
            var ton = tonConfig.ToObject<TonConfig>()!;
            ton.Endpoint = GetEnvString("IDLEZ_TON_ENDPOINT") ?? ton.Endpoint;
            ton.TonAddress = GetEnvString("IDLEZ_TON_ADDRESS") ?? ton.TonAddress;
            Ton = ton;
        }
    }
}
