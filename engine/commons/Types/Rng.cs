using System;

namespace Commons.Types
{
    public struct Rng: IRng
    {
        private uint _seed;
        public Rng(uint seed)
        {
            _seed = seed;
        }
        private uint GetNextSeed()
        {
            _seed = 20020907 * _seed + 20020108;
            if (_seed == 0)
                _seed = 1;
            return _seed;
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
    }
}