using System;
using System.IO;

namespace Commons.Utility
{
    public static class ReadOnlyMemoryExtensions
    {
        public static Stream AsStream(this ReadOnlyMemory<byte> memory)
        {
            return new ReadOnlyMemoryStream(memory);
        }
    }
}