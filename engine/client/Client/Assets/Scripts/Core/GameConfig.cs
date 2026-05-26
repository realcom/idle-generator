
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Assets.Scripts.Core
{
    public class GameConfigData
    {
        public string patchsetVersion;
        public string commonsCommitHash;
    }

    public static class GameConfig
    {
        
        private static GameConfigData _config;
        private static string GameConfigPath => Path.Combine(Application.dataPath, "PatchResources/GameConfig.json");

        public static GameConfigData Config
        {
            get
            {
                if (_config == null)
                {
                    Load();
                }
                return _config;
            }
        }

        private static void Load()
        {
            string path = Path.Combine(GameConfigPath);
            if (File.Exists(path))
            {
                string json = File.ReadAllText(path);
                _config = JsonUtility.FromJson<GameConfigData>(json);
            }
            else
            {
                Debug.LogError("GameConfig.json not found at " + path);
                _config = new GameConfigData(); // Provide default values or handle error
            }
        }

        public static void UpdatePatchsetVersion()
        {
#if UNITY_EDITOR
            Reload();
            var appVersion = 
                PlayerSettings.bundleVersion;
            var patchsetVersion = _config.patchsetVersion;
            
            string nextPatchVersion;

            var versionParts = patchsetVersion.Split('.');
            var currentAppVersionInPatch = string.Join(".", versionParts.Take(3));

            if (currentAppVersionInPatch == appVersion)
            {
                int revision = int.Parse(versionParts.Last());
                revision++;
                nextPatchVersion = appVersion + "." + revision.ToString("D3");
            }
            else
            {
                nextPatchVersion = appVersion + ".001";
            }
            _config.patchsetVersion = nextPatchVersion;

            var globalConfigJson = JsonUtility.ToJson(_config, true);
            File.WriteAllText(GameConfigPath, globalConfigJson);
#endif
        }
        // Optional: A method to force a reload of the config file
        public static void Reload()
        {
            _config = null;
            Load();
        }
    }
}
