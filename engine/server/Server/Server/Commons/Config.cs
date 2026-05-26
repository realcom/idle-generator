using System.Diagnostics;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Runtime.ExceptionServices;
using System.Security.Cryptography.X509Certificates;
using DotNetty.Transport.Channels;
using Newtonsoft.Json.Linq;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace Commons;

public static partial class Config
{
    public static string WorkingDirectory { get; } = Environment.CurrentDirectory;
    
    private static Dictionary<string, ConfigModel> _configModels = new();
    
    static Config()
    {
        if (IsLinux)
        {
            ThreadPool.SetMinThreads(16 * Environment.ProcessorCount, 4 * Environment.ProcessorCount);
            ThreadPool.SetMaxThreads(32 * Environment.ProcessorCount, 16 * Environment.ProcessorCount);
        }
            
        // AppDomain.CurrentDomain.FirstChanceException += FirstChanceHandler;
        AppDomain.CurrentDomain.UnhandledException += UnhandledHandler;
        TaskScheduler.UnobservedTaskException += UnobservedHandler;
        
        ServicePointManager.ServerCertificateValidationCallback += ValidateRemoteCertificate;
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
    }
    
    private static void FirstChanceHandler(object? sender, FirstChanceExceptionEventArgs e)
    {
        if (e.Exception is SocketException)
            return;
        LogError("FirstChanceException");
        LogError(e.Exception.ToString());
    }
    
    private static void UnhandledHandler(object? sender, UnhandledExceptionEventArgs e)
    {
        LogError("UnhandledException");
        LogError(e.ExceptionObject.ToString());
    }
    
    private static void UnobservedHandler(object? sender, UnobservedTaskExceptionEventArgs e)
    {
        e.SetObserved();
        e.Exception?.Handle(ex =>
        {
            if (ex is ClosedChannelException)
                return true;
            
            LogError("UnobservedTaskException");
            LogError(ex.ToString());
            return true;
        });
    }
    
    private static bool ValidateRemoteCertificate(object? sender, X509Certificate? certificate, X509Chain? chain, SslPolicyErrors sslPolicyErrors)
    {
        if (sslPolicyErrors == SslPolicyErrors.None)
            return true;
        LogError("RemoteCertificateValidationCallback");
        LogError($"Certificate error: {sslPolicyErrors}");
        return false;
    }

    public static async Task Reload(bool reloadDb = true)
    {
        var path = System.IO.Path.Join(WorkingDirectory, "Config.json");
        if (!File.Exists(path))
            throw new FileNotFoundException("Config.json not found", path);
        var config = JObject.Parse(await File.ReadAllTextAsync(path).ConfigureAwait(false));

        var localPath = System.IO.Path.Join(WorkingDirectory, "Config.local.json");
        if (File.Exists(localPath))
        {
            var localConfig = JObject.Parse(await File.ReadAllTextAsync(localPath).ConfigureAwait(false));
            MergeJson(config, localConfig);
        }

        IsDebug = config["Debug"]?.Value<bool>() ?? IsDebug;
        LoadDbConfig(config);
        LoadPathConfig(config);
        LoadServerConfig(config);
        LoadTelegramConfig(config);
        LoadTonConfig(config);
        LoadAdminConfig(config);
        
        if (reloadDb)
            await ReloadConfigModels().ConfigureAwait(false);
    }

    public static async Task ReloadCommonsCommitHash()
    {
        if (IsDebug)
        {
            // Get Git Commit Hash
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "git",
                    Arguments = "rev-parse HEAD",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    WorkingDirectory = System.IO.Path.Combine(WorkingDirectory, "../Commons"),
                };

                using (Process process = Process.Start(psi))
                {
                    if (process != null)
                    {
                        Config.CommonsCommitHash = await process.StandardOutput.ReadToEndAsync();
                        Config.CommonsCommitHash = Config.CommonsCommitHash.Trim(); // Remove any whitespace
                        Config.LogInfo($"Git Commit Hash: {Config.CommonsCommitHash}");
                    }
                }
            }
            catch (Exception ex)
            {
                Config.LogInfo($"Failed to get Git Commit Hash: {ex.Message}");
                Config.CommonsCommitHash = "Unknown"; // Set to unknown if failed
            }
        }
    }

    public static async Task ReloadConfigModels()
    {
        _configModels = (await ConfigModel.GetAllAsync().ConfigureAwait(false)).ToDictionary(x => x.key);
    }
    
    public static bool GetBool(string key, bool @default = false)
    {
        return _configModels.GetValueOrDefault(key)?.value_bool ?? @default;
    }
    
    public static int GetInt(string key, int @default = 0)
    {
        return _configModels.GetValueOrDefault(key)?.value_int ?? @default;
    }
    
    public static float GetFloat(string key, float @default = 0)
    {
        return _configModels.GetValueOrDefault(key)?.value_float ?? @default;
    }
    
    public static string GetString(string key, string @default = "")
    {
        return _configModels.GetValueOrDefault(key)?.value_string ?? @default;
    }
    
    public static DateTime GetDateTime(string key, DateTime @default = default)
    {
        return _configModels.GetValueOrDefault(key)?.value_datetime ?? @default;
    }

    internal static string? GetEnvString(params string[] keys)
    {
        foreach (var key in keys)
        {
            var value = Environment.GetEnvironmentVariable(key);
            if (!string.IsNullOrWhiteSpace(value))
                return value;
        }

        return null;
    }

    internal static int GetEnvInt(int fallback, params string[] keys)
    {
        var value = GetEnvString(keys);
        return Int32.TryParse(value, out var parsed) ? parsed : fallback;
    }

    internal static bool GetEnvBool(bool fallback, params string[] keys)
    {
        var value = GetEnvString(keys);
        return Boolean.TryParse(value, out var parsed) ? parsed : fallback;
    }

    private static void MergeJson(JObject target, JObject source)
    {
        foreach (var property in source.Properties())
        {
            if (target[property.Name] is JObject targetObject && property.Value is JObject sourceObject)
            {
                MergeJson(targetObject, sourceObject);
                continue;
            }

            target[property.Name] = property.Value.DeepClone();
        }
    }
}
