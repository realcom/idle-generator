using System;
using System.Xml;
using SimpleJSON;
using UnityEngine;


namespace Commons
{
    // TODO: use partial class - Commons.Config
    public static partial class Config
    {
        // from gameConfig
        public static string patchsetVersion;
        public static string commonsCommitHash;
        //
        public static string fixHost;
        public static string fixEdgeHost;
        public static string fixWebHost;
        public static string startMap;
        public static string snsID;
        public static string defaultLanguage;
        public static bool runStandaloneIOS;
        public static bool enableSocketConnection;
        public static bool connectByTelegram;
        public static bool AutoPlay;
        public static float AutoPlayInterval;

        public static void InitializeConfigForUnity()
        {
            LogInfo = Debug.Log;
            LogError = Debug.LogError;

            void Apply(string name)
            {
                try
                {
                    var x = UnityEngine.Resources.Load<TextAsset>(name);
                    if (x == null)
                        return;

                    var doc = new XmlDocument();
                    doc.LoadXml(x.text);

                    //
                    fixHost = doc.GetChildText(".//FixHost");
                    fixEdgeHost = doc.GetChildText(".//FixEdgeHost");
                    fixWebHost = doc.GetChildText(".//FixWebHost");
                    startMap = doc.GetChildText(".//StartMap");
                    snsID = doc.GetChildText(".//SNSID");
                    defaultLanguage = doc.GetChildText("Language");
                    enableSocketConnection = doc.GetChildBoolean(".//EnableSocketConnection");
                    connectByTelegram = doc.GetChildBoolean(".//ConnectByTelegram");
                    IsDebug = doc.GetChildBoolean(".//IsDebug");
                    AutoPlay = doc.GetChildBoolean(".//AutoPlay");
                    AutoPlayInterval = doc.GetChildFloat(".//AutoPlayInterval", 1f);
                    
                    Debug.Log($"Loaded {name}.xml.");
                }
                catch (Exception e)
                {
                    // ignored
                }
            }

            Apply(Application.isEditor ? "Debug" : "Debug.Build");
            
#if UNITY_EDITOR
            IsDebug = true;
#endif
        }
        
        public static void InitializeConfigFromGameConfig()
        {
            if (Constants.IGNORE_ASSETBUNDLE)
            {
                var jsonStr = global::Utility.LoadResource<string>("GameConfig.json");
                if (string.IsNullOrEmpty(jsonStr))
                {
                    Debug.LogWarning("GameConfig.json not found or empty.");
                    return;
                }
                var data = SimpleJSON.JSON.Parse(jsonStr);
                patchsetVersion = data["patchsetVersion"];
                commonsCommitHash = data["commonsCommitHash"];
            }
            // else
            // {
            //     var bytes = global::Utility.LoadResource<byte[]>("GameConfig.bytes");
            //     
            //
            //     patchsetVersion = ResourceGameConfig.PatchsetVersion;
            //     commonsCommitHash = ResourceGameConfig.CommonsCommitHash;
            // }
        }
    }
    
}