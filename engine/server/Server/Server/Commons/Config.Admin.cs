using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class AdminConfig
    {
        public string defaultId { get; set; } = "";
        public string defaultPassword { get; set; } = "";
        public string passwordHash { get; set; } = "";
        public string jwtSecret { get; set; } = "";
        public string confirmPlayersApiKey { get; set; } = "";
    }

    public static AdminConfig Admin { get; private set; } = new();
    private static string? _generatedJwtSecret;

    private static void LoadAdminConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Admin), out var AdminConfig))
        {
            var admin = AdminConfig.ToObject<AdminConfig>()!;
            admin.defaultId = GetEnvString("IDLEZ_ADMIN_ID") ?? admin.defaultId;
            admin.defaultPassword = GetEnvString("IDLEZ_ADMIN_PASSWORD") ?? admin.defaultPassword;
            admin.passwordHash = GetEnvString("IDLEZ_ADMIN_PASSWORD_HASH") ?? admin.passwordHash;
            admin.jwtSecret = GetEnvString("IDLEZ_ADMIN_JWT_SECRET") ?? admin.jwtSecret;
            admin.confirmPlayersApiKey = GetEnvString("IDLEZ_CONFIRM_PLAYERS_API_KEY") ?? admin.confirmPlayersApiKey;
            Admin = admin;
        }
    }

    public static bool HasAdminCredentialsConfigured()
    {
        return !string.IsNullOrWhiteSpace(Admin.defaultId) &&
               (!string.IsNullOrWhiteSpace(Admin.defaultPassword) || !string.IsNullOrWhiteSpace(Admin.passwordHash));
    }

    public static string GetJwtSecret()
    {
        if (!string.IsNullOrWhiteSpace(Admin.jwtSecret))
            return Admin.jwtSecret;

        _generatedJwtSecret ??= Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
        return _generatedJwtSecret;
    }

    public static bool VerifyAdminPassword(string password)
    {
        if (string.IsNullOrEmpty(password))
            return false;

        if (!string.IsNullOrWhiteSpace(Admin.passwordHash))
            return VerifyPbkdf2Password(password, Admin.passwordHash);

        return SecureEquals(password, Admin.defaultPassword);
    }

    public static bool VerifyConfirmPlayersApiKey(string? apiKey)
    {
        if (string.IsNullOrWhiteSpace(Admin.confirmPlayersApiKey) || string.IsNullOrEmpty(apiKey))
            return false;

        return SecureEquals(apiKey, Admin.confirmPlayersApiKey);
    }

    private static bool SecureEquals(string left, string right)
    {
        var leftBytes = Encoding.UTF8.GetBytes(left);
        var rightBytes = Encoding.UTF8.GetBytes(right);
        return leftBytes.Length == rightBytes.Length &&
               CryptographicOperations.FixedTimeEquals(leftBytes, rightBytes);
    }

    private static bool VerifyPbkdf2Password(string password, string passwordHash)
    {
        const string Prefix = "pbkdf2-sha256$";
        if (!passwordHash.StartsWith(Prefix, StringComparison.Ordinal))
            return false;

        var parts = passwordHash.Split('$', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length != 4 || !Int32.TryParse(parts[1], out var iterations))
            return false;

        try
        {
            var salt = Convert.FromBase64String(parts[2]);
            var expected = Convert.FromBase64String(parts[3]);
            var actual = Rfc2898DeriveBytes.Pbkdf2(password, salt, iterations, HashAlgorithmName.SHA256, expected.Length);
            return CryptographicOperations.FixedTimeEquals(actual, expected);
        }
        catch (FormatException)
        {
            return false;
        }
    }
}
