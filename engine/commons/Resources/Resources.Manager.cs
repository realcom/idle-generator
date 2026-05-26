using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class Resources
    {
        public partial class Types
        {
            public partial class GlobalData
            {
                internal GlobalData Init()
                {
                    return this;
                }
            }
        }

        public static Types.GlobalData Global = new();
        
        private static void Reload(Types.GlobalData global)
        {
            Global = global.Init();
            Reload();
        }
        
        static partial void Reload();
        
        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.GlobalData);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Parser.ParseFrom(bytes);
            Reload(resources.GlobalData);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.GlobalData.Init();

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                GlobalData = Global,
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                GlobalData = Global,
            }.ToByteArray();
        }

    }
}