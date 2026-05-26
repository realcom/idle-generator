using Newtonsoft.Json.Linq;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public class DbConfig
    {
        public string Host { get; set; } = "localhost";
        public int Port { get; set; } = 5432;
        public string Database { get; set; } = "idlez";
        public string Username { get; set; } = "idlez";
        public string Password { get; set; } = "";
        public int MaxPoolSize { get; set; } = IsDebug ? 16 : 16 * Environment.ProcessorCount;

        public string ConnectionString = null!;
    }
    
    public static DbConfig Db { get; private set; } = new();

    private static void LoadDbConfig(JObject config)
    {
        if (config.TryGetValue(nameof(Db), out var dbConfig))
        {
            var db = dbConfig.ToObject<DbConfig>()!;
            db.Host = GetEnvString("IDLEZ_DB_HOST") ?? db.Host;
            db.Port = GetEnvInt(db.Port, "IDLEZ_DB_PORT");
            db.Database = GetEnvString("IDLEZ_DB_NAME", "IDLEZ_DB_DATABASE") ?? db.Database;
            db.Username = GetEnvString("IDLEZ_DB_USER", "IDLEZ_DB_USERNAME") ?? db.Username;
            db.Password = GetEnvString("IDLEZ_DB_PASSWORD") ?? db.Password;
            db.MaxPoolSize = GetEnvInt(db.MaxPoolSize, "IDLEZ_DB_MAX_POOL_SIZE");
            db.ConnectionString = $"Host={db.Host};Port={db.Port};Database={db.Database};Username={db.Username};Password={db.Password};Maximum Pool Size={db.MaxPoolSize};Include Error Detail=true";
            Db = db;
        }
    }
}
