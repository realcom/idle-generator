using System;
using System.IO;

namespace Commons.Utility
{
    public class ReadOnlyMemoryStream : Stream
    {
        private readonly ReadOnlyMemory<byte> _memory;
        private int _position;

        public ReadOnlyMemoryStream(ReadOnlyMemory<byte> memory)
        {
            _memory = memory;
        }

        public override bool CanRead => true;
        public override bool CanSeek => true;
        public override bool CanWrite => false;
        public override long Length => _memory.Length;
        public override long Position
        {
            get => _position;
            set => _position = (int)value;
        }

        public override void Flush()
        {
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            var remaining = _memory.Length - _position;
            if (remaining <= 0)
                return 0;

            var read = Math.Min(remaining, count);
            _memory.Slice(_position, read).CopyTo(buffer.AsMemory(offset));
            _position += read;
            return read;
        }

        public override long Seek(long offset, SeekOrigin origin)
        {
            _position = origin switch
            {
                SeekOrigin.Begin => (int)offset,
                SeekOrigin.Current => _position + (int)offset,
                SeekOrigin.End => _memory.Length + (int)offset,
                _ => throw new ArgumentOutOfRangeException(nameof(origin), origin, null)
            };

            return _position;
        }

        public override void SetLength(long value)
        {
            throw new NotSupportedException();
        }

        public override void Write(byte[] buffer, int offset, int count)
        {
            throw new NotSupportedException();
        }
    }
}
