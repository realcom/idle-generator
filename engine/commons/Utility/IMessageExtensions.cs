using System.IO;
using System.IO.Compression;
using Google.Protobuf;

namespace Commons.Utility
{
    public static class IMessageExtensions
    {
        public static ByteString Compress(this IMessage message)
        {
            using var stream = new MemoryStream();
            using var gzip = new GZipStream(stream, CompressionLevel.Optimal);
            message.WriteTo(gzip);
            gzip.Flush();
            stream.Seek(0, SeekOrigin.Begin);
            return ByteString.FromStream(stream);
        }
        
        public static T Decompress<T>(this ByteString bytes) where T : IMessage, new()
        {
            using var gzip = new GZipStream(bytes.Memory.AsStream(), CompressionMode.Decompress);
            var message = new T();
            message.MergeFrom(gzip);
            return message;
        }
    }
}
