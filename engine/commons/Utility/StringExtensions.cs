using System;
using System.Text;
using Google.Protobuf;

namespace Commons.Utility
{
    public static class StringExtensions
    {
        public static ByteString ToByteString(this string str)
        {
            return ByteString.CopyFromUtf8(str);
        }
        
        public static string ToString(this ByteString byteString)
        {
            return byteString.ToStringUtf8();
        }
        
        public static byte[] ToBytes(this string str)
        {
            return Encoding.UTF8.GetBytes(str);
        }

        public static string Truncate(this string str, int length)
        {
            return str[..Math.Min(length, str.Length)];
        }
        
        public static string ToHex(this byte[] bytes)
        {
            var sb = new StringBuilder(bytes.Length * 2);
            foreach (var b in bytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
        
        public static byte[] HexToBytes(this string hex)
        {
            var bytes = new byte[hex.Length / 2];
            for (var i = 0; i < bytes.Length; i++)
                bytes[i] = Convert.ToByte(hex.Substring(i * 2, 2), 16);
            return bytes;
        }
        
        public static string ToBase64(this byte[] bytes)
        {
            return Convert.ToBase64String(bytes);
        }
        
        public static string UrlEncode(this string str)
        {
            return Uri.EscapeDataString(str);
        }
        
        public static string UrlDecode(this string str)
        {
            return Uri.UnescapeDataString(str);
        }
        
        public static string SafeUtf8Substring(this string str, int startIndex, int length)
        {
            if (string.IsNullOrEmpty(str))
                return str;
            
            if (str.Length <= startIndex)
                return string.Empty;
            if (str.Length <= startIndex + length)
                return str[startIndex..];
            
            var substring = str.Substring(startIndex, length);
            var bytes = Encoding.UTF8.GetBytes(substring);

            var validEndIndex = bytes.Length;
            while (validEndIndex > 0 && (bytes[validEndIndex - 1] & 0xC0) == 0x80)
                validEndIndex -= 1;
            
            return Encoding.UTF8.GetString(bytes, 0, validEndIndex);
        }
    }
}