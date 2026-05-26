using System.IO;
using System.Linq;
using System.Security.Cryptography;

namespace Commons.Utility
{
    public static class CryptographyExtensions
    {
        public static byte[] Sha256(this byte[] data)
        {
            using var sha = SHA256.Create();
            return sha.ComputeHash(data);
        }
        
        public static byte[] HmacSha256(this byte[] data, byte[] key)
        {
            using var hmac = new HMACSHA256(key);
            return hmac.ComputeHash(data);
        }
        
        public static byte[] EncryptAes(this byte[] data, byte[] key)
        {
            using var aes = Aes.Create();
            aes.Key = key;
            aes.Mode = CipherMode.CBC;
            var iv = aes.IV;
            using var encryptor = aes.CreateEncryptor();
            using var ms = new MemoryStream();
            ms.Write(iv, 0, iv.Length);
            using var cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write);
            cs.Write(data, 0, data.Length);
            cs.FlushFinalBlock();
            return ms.ToArray();
        }
        
        public static byte[] DecryptAes(this byte[] data, byte[] key)
        {
            using var aes = Aes.Create();
            aes.Key = key;
            aes.Mode = CipherMode.CBC;
            var ivLength = aes.BlockSize / 8;
            aes.IV = data.Take(ivLength).ToArray();
            using var decryptor = aes.CreateDecryptor();
            using var ms = new MemoryStream(data, aes.IV.Length, data.Length - ivLength, writable: false);
            using var cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read);
            using var msOut = new MemoryStream();
            cs.CopyTo(msOut);
            return msOut.ToArray();
        }
    }
}
