using System;
using Google.Protobuf;

#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons
{
    public static partial class Config
    {
        public static bool IsDebug;
        public static string CommonsCommitHash;

#if UNITY_5_3_OR_NEWER
        public static Action<string?> LogInfo = Debug.Log;
        public static Action<string?> LogError = Debug.LogError;
#else
        public static Action<string?> LogInfo = Console.WriteLine;
        public static Action<string?> LogError = Console.Error.WriteLine;
#endif
        
        public static bool IsLinux => Environment.OSVersion.Platform == PlatformID.Unix;
        
        public static readonly JsonParser JsonParser = new(JsonParser.Settings.Default.WithIgnoreUnknownFields(true));
        public static readonly JsonFormatter JsonFormatter = new(JsonFormatter.Settings.Default);
        public static readonly JsonFormatter JsonMinFormatter = new(JsonFormatter.Settings.Default.WithIndentation(null));
    }
}
