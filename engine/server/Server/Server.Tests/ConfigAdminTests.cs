using System.Reflection;
using System.Security.Cryptography;
using Commons;
using Xunit;

namespace Server.Tests;

public sealed class ConfigAdminTests
{
    [Fact]
    public void HasAdminCredentialsConfigured_requires_id_and_password_or_hash()
    {
        using var scope = new AdminConfigScope();

        Assert.False(Config.HasAdminCredentialsConfigured());

        Config.Admin.defaultId = "admin";
        Assert.False(Config.HasAdminCredentialsConfigured());

        Config.Admin.defaultPassword = "plain-secret";
        Assert.True(Config.HasAdminCredentialsConfigured());

        Config.Admin.defaultPassword = "";
        Config.Admin.passwordHash = CreatePbkdf2Hash("hashed-secret", new byte[] { 1, 2, 3, 4 }, 1000);
        Assert.True(Config.HasAdminCredentialsConfigured());
    }

    [Fact]
    public void GetJwtSecret_returns_configured_secret_or_stable_generated_secret()
    {
        using var scope = new AdminConfigScope();

        Config.Admin.jwtSecret = "configured-secret";
        Assert.Equal("configured-secret", Config.GetJwtSecret());

        Config.Admin.jwtSecret = "";
        var generated = Config.GetJwtSecret();

        Assert.False(string.IsNullOrWhiteSpace(generated));
        Assert.Equal(generated, Config.GetJwtSecret());
    }

    [Fact]
    public void VerifyAdminPassword_supports_plaintext_and_pbkdf2_hashes()
    {
        using var scope = new AdminConfigScope();

        Config.Admin.defaultPassword = "plain-secret";
        Assert.True(Config.VerifyAdminPassword("plain-secret"));
        Assert.False(Config.VerifyAdminPassword("wrong-secret"));
        Assert.False(Config.VerifyAdminPassword(""));

        Config.Admin.defaultPassword = "";
        Config.Admin.passwordHash = CreatePbkdf2Hash("hashed-secret", new byte[] { 10, 20, 30, 40 }, 2048);

        Assert.True(Config.VerifyAdminPassword("hashed-secret"));
        Assert.False(Config.VerifyAdminPassword("wrong-secret"));

        Config.Admin.passwordHash = "invalid-hash";
        Assert.False(Config.VerifyAdminPassword("hashed-secret"));
    }

    [Fact]
    public void VerifyConfirmPlayersApiKey_requires_exact_match()
    {
        using var scope = new AdminConfigScope();

        Config.Admin.confirmPlayersApiKey = "key-123";
        Assert.True(Config.VerifyConfirmPlayersApiKey("key-123"));
        Assert.False(Config.VerifyConfirmPlayersApiKey("KEY-123"));
        Assert.False(Config.VerifyConfirmPlayersApiKey(null));

        Config.Admin.confirmPlayersApiKey = "";
        Assert.False(Config.VerifyConfirmPlayersApiKey("key-123"));
    }

    private static string CreatePbkdf2Hash(string password, byte[] salt, int iterations)
    {
        var derived = Rfc2898DeriveBytes.Pbkdf2(password, salt, iterations, HashAlgorithmName.SHA256, 32);
        return $"pbkdf2-sha256${iterations}${Convert.ToBase64String(salt)}${Convert.ToBase64String(derived)}";
    }

    private sealed class AdminConfigScope : IDisposable
    {
        private static readonly FieldInfo GeneratedJwtSecretField =
            typeof(Config).GetField("_generatedJwtSecret", BindingFlags.NonPublic | BindingFlags.Static)!;

        private readonly string _defaultId = Config.Admin.defaultId;
        private readonly string _defaultPassword = Config.Admin.defaultPassword;
        private readonly string _passwordHash = Config.Admin.passwordHash;
        private readonly string _jwtSecret = Config.Admin.jwtSecret;
        private readonly string _confirmPlayersApiKey = Config.Admin.confirmPlayersApiKey;
        private readonly string? _generatedJwtSecret = (string?)GeneratedJwtSecretField.GetValue(null);

        public AdminConfigScope()
        {
            Config.Admin.defaultId = "";
            Config.Admin.defaultPassword = "";
            Config.Admin.passwordHash = "";
            Config.Admin.jwtSecret = "";
            Config.Admin.confirmPlayersApiKey = "";
            GeneratedJwtSecretField.SetValue(null, null);
        }

        public void Dispose()
        {
            Config.Admin.defaultId = _defaultId;
            Config.Admin.defaultPassword = _defaultPassword;
            Config.Admin.passwordHash = _passwordHash;
            Config.Admin.jwtSecret = _jwtSecret;
            Config.Admin.confirmPlayersApiKey = _confirmPlayersApiKey;
            GeneratedJwtSecretField.SetValue(null, _generatedJwtSecret);
        }
    }
}
