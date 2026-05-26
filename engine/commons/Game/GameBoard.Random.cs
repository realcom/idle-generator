using System;
using Commons.Types;

namespace Commons.Game
{
    public partial class GameBoard : IRng
    {
        private void InitSeed()
        {
            seed_ = (uint)DateTime.Now.Ticks;
        }

        private uint GetNextSeed()
        {
            seed_ = 1103515245 * seed_ + 12345;
            if (seed_ == 0)
                seed_ = 1;
            return seed_;
        }
        
        public int Random()
        {
            return Math.Abs((int)GetNextSeed());
        }

        public int Random(int maxValueExclusive)
        {
            return Random() % maxValueExclusive;
        }
        
        public long Random(long maxValueExclusive)
        {
            var r = Math.Abs((long)uint.MaxValue * GetNextSeed() + GetNextSeed());
            return r % maxValueExclusive;
        }

        public FixedFloat RandomFloat()
        {
            var raw = GetNextSeed() & FixedFloat.Mask;
            return FixedFloat.FromRaw(raw);
        }

        // public double RandomDouble()
        // {
        //     var ul = ((ulong)GetNextSeed() << 32) | GetNextSeed();
        //     var result = BitConverter.Int64BitsToDouble((long)ul & 0x000FFFFFFFFFFFFFL | 0x3FF0000000000000L) - 1;
        //     return result;
        // }
    }
}
