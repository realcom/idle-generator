using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets.Requests;
using Commons.Utility;
using Google.Protobuf;
using static Commons.Resources.ResourceString.Types;

namespace Commons.Resources
{
    public partial class ResourceString
    {
        private static readonly IReadOnlyList<ResourceString> EmptyList = Array.Empty<ResourceString>();
        
        public partial class Types
        {
            public partial class Global
            {
                internal Global Init()
                {
                    DataId ??= new Types.DataId();
                    return this;
                }
            }
        }
        
        public static Types.Global Global = new();
        
        private static Dictionary<(Category, int), Dictionary<string, ResourceString>> _stringByCategoryIdKey = new();

        private static void Reload(Types.Global global, IList<ResourceString> strings)
        {
            Global = global.Init();
            
            Reload();
            
            _stringByCategoryIdKey = strings
                .GroupBy(s => (s.Category, s.Id))
                .ToDictionary(g => g.Key, g => g.ToDictionary(s => s.Init().Key));
        }
        
        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.StringGlobal, resources.Strings);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.StringGlobal, resources.Strings);
        }

        public static string FormatJson()
        {
            return new Resources
            {
                StringGlobal = Global,
                Strings = { _stringByCategoryIdKey.Values.SelectMany(d => d.Values) },
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                StringGlobal = Global,
                Strings = { _stringByCategoryIdKey.Values.SelectMany(d => d.Values) },
            }.ToByteArray();
        }
        
        public static ResourceString? Get(Category category, int id)
        {
            return Get(category, id, "");
        }
        
        public static ResourceString? Get(Category category, int id, string key)
        {
            return _stringByCategoryIdKey.GetValueOrDefault((category, id))?.GetValueOrDefault(key);
        }
        
        public static ResourceString? Get(Category category, string key)
        {
            return Get(category, 0, key);
        }
        
        public static string Get(Category category, int id, Language language, string? @default = null)
        {
            var resString = Get(category, id);
            if (resString == null)
                return @default ?? id.ToString();
            switch (language)
            {
                case Language.Korean:
                    return resString.korean_;
                default:
                    return resString.english_;
            }
        }
        
        public static string Get(Category category, string key, Language language, string? @default = null)
        {
            var resString = Get(category, key);
            if (resString == null)
                return @default ?? key;
            switch (language)
            {
                case Language.Korean:
                    return resString.korean_;
                default:
                    return resString.english_;
            }
        }
        
        public static string Get(Category category, int id, string key, Language language, string? @default = null)
        {
            var resString = Get(category, id, key);
            if (resString == null)
                return @default ?? (string.IsNullOrEmpty(key) ? id.ToString() : key);
            switch (language)
            {
                case Language.Korean:
                    return resString.korean_;
                default:
                    return resString.english_;
            }
        }

        public static bool Get(out string result, Category category, int id, string key, Language language, string? @default = null)
        {
            var resourceString = Get(category, id, key);
            if (resourceString == null)
            {
                result = @default ?? (string.IsNullOrEmpty(key) ? id.ToString() : key);
                return false;
            }
            
            result = language switch
            {
                Language.Korean => resourceString.korean_,
                _ => resourceString.english_,
            };
            
            return true;
        }
        
        public static string Get(StatusCode code, Language language = Language.English)
        {
            return Get(Category.Server, (int)code, language, code.ToString());
        }
        
        public static string Get(StatusCode code, Language language = Language.English, params object[] args)
        {
            return string.Format(Get(Category.Server, (int)code, language, code.ToString()), args);
        }
    
        public static string Get(string key, Language language = Language.English)
        {
            return Get(Category.Server, key, language);
        }
        
        public static string Get(string key, Language language = Language.English, params object[] args)
        {
            return string.Format(Get(Category.Server, key, language), args);
        }
        
        private ResourceString Init()
        {
            if (string.IsNullOrEmpty(korean_))
                korean_ = english_;
            
            InitUnity();
            return this;
        }

        partial void InitUnity();
    }
}
