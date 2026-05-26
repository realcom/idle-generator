using System;
using System.IO;
using Commons.Utility;

namespace Commons.Resources
{
    public class InvalidResourceException : Exception
    {
        public InvalidResourceException(ResourceEntity resourceEntity)
            : base($"Resource Info: {resourceEntity}")
        {
        }
        
        public InvalidResourceException(ResourceEntity resourceEntity, string message)
            : base($"{message}\nResource Info: {resourceEntity}")
        {
        }

        public InvalidResourceException(ResourceEntity resourceEntity, string message, Exception innerException)
            : base($"{message}\nResource Info: {resourceEntity}", innerException)
        {
            
        }
        
    }
    
    public static class ResourceManager
    {
        public static readonly byte[] EncryptKey = "ResourceManager".ToBytes().Sha256();
        
        public static void ReloadJson(string path)
        {
            Config.LogInfo($"Reload Resources from {path}");

            string json;
            Config.LogInfo($"Reload ResourceGlobals.json");
            json = File.ReadAllText(Path.Combine(path, "ResourceGlobals.json"));
            Resources.ReloadJson(json);
            
            // 반드시 Triggers 가장 먼저 로드
            Config.LogInfo($"Reload Triggers.json");
            json = File.ReadAllText(Path.Combine(path, "Triggers.json"));
            ResourceTrigger.ReloadJson(json);
            
            Config.LogInfo($"Reload Strings.json");
            json = File.ReadAllText(Path.Combine(path, "Strings.json"));
            ResourceString.ReloadJson(json);

            Config.LogInfo($"Reload Achievements.json");
            json = File.ReadAllText(Path.Combine(path, "Achievements.json"));
            ResourceAchievement.ReloadJson(json);
            
            Config.LogInfo($"Reload Audio.json");
            json = File.ReadAllText(Path.Combine(path, "Audios.json"));
            ResourceAudio.ReloadJson(json);

            Config.LogInfo($"Reload Buffs.json");
            json = File.ReadAllText(Path.Combine(path, "Buffs.json"));
            ResourceBuff.ReloadJson(json);

            Config.LogInfo($"Reload Items.json");
            json = File.ReadAllText(Path.Combine(path, "Items.json"));
            ResourceItem.ReloadJson(json);

            Config.LogInfo($"Reload Maps.json");
            json = File.ReadAllText(Path.Combine(path, "Maps.json"));
            ResourceMap.ReloadJson(json);

            Config.LogInfo($"Reload Skills.json");
            json = File.ReadAllText(Path.Combine(path, "Skills.json"));
            ResourceSkill.ReloadJson(json);

            Config.LogInfo($"Reload Units.json");
            json = File.ReadAllText(Path.Combine(path, "Units.json"));
            ResourceUnit.ReloadJson(json);
        }

        public static void ReloadBinary(string path)
        {
            Config.LogInfo($"Reload Binary Resources from {path}");
        
            byte[] bytes;
            Config.LogInfo($"Reload ResourceGlobals.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "ResourceGlobals.bytes"));
            Resources.ReloadBinary(bytes.DecryptAes(EncryptKey));
            
            // 반드시 Triggers 가장 먼저 로드
            Config.LogInfo($"Reload Triggers.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Triggers.bytes"));
            ResourceTrigger.ReloadBinary(bytes.DecryptAes(EncryptKey));
            
            Config.LogInfo($"Reload Strings.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Strings.bytes"));
            ResourceString.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Achievements.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Achievements.bytes"));
            ResourceAchievement.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Audio.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Audios.bytes"));
            ResourceAudio.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Buffs.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Buffs.bytes"));
            ResourceBuff.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Items.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Items.bytes"));
            ResourceItem.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Maps.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Maps.bytes"));
            ResourceMap.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Skills.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Skills.bytes"));
            ResourceSkill.ReloadBinary(bytes.DecryptAes(EncryptKey));
        
            Config.LogInfo($"Reload Units.bytes");
            bytes = File.ReadAllBytes(Path.Combine(path, "Units.bytes"));
            ResourceUnit.ReloadBinary(bytes.DecryptAes(EncryptKey));
        }
    }
}