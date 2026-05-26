using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class PathConfig
    {
        public string Resources { get; set; } = "";
        
        public string GoogleServiceAccountForBillingCredential { get; set; } = "";
        
        public string GoogleServiceAccountForPushCredential { get; set; } = "";
        
        
    }
    
    public static PathConfig Path { get; private set; } = new();

    private static void LoadPathConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Path), out var pathConfig))
        {
            var path = pathConfig.ToObject<PathConfig>()!;
            path.Resources = GetEnvString("IDLEZ_RESOURCES_PATH") ?? path.Resources;
            path.GoogleServiceAccountForBillingCredential =
                GetEnvString("IDLEZ_GOOGLE_BILLING_CREDENTIAL_PATH") ?? path.GoogleServiceAccountForBillingCredential;
            path.GoogleServiceAccountForPushCredential =
                GetEnvString("IDLEZ_GOOGLE_PUSH_CREDENTIAL_PATH") ?? path.GoogleServiceAccountForPushCredential;
            Path = path;
        }
    }
}
