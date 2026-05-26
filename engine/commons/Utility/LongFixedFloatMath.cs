using Commons.Types;

namespace Commons.Utility
{
    public static class LongFixedFloatMath
    {
        private const ulong Precision = FixedFloat.Precision;
        private const ulong PositiveLimit = long.MaxValue;
        private const ulong NegativeLimit = PositiveLimit + 1UL;

        public static long AddSaturated(long a, long b)
        {
            if (b > 0 && a > long.MaxValue - b)
                return long.MaxValue;
            if (b < 0 && a < long.MinValue - b)
                return long.MinValue;
            return a + b;
        }

        public static long SubtractSaturated(long a, long b)
        {
            if (b == long.MinValue)
                return long.MaxValue;
            return AddSaturated(a, -b);
        }

        public static long ScaleSaturated(long value, FixedFloat ratio)
        {
            if (value == 0 || ratio.Raw == 0)
                return 0L;

            var negative = value < 0 ^ ratio.Raw < 0;
            var absValue = AbsToUInt64(value);
            var absRatioRaw = AbsToUInt64(ratio.Raw);
            var limit = negative ? NegativeLimit : PositiveLimit;

            if (!TryScaleAbs(absValue, absRatioRaw, limit, out var resultAbs))
                return negative ? long.MinValue : long.MaxValue;

            if (!negative)
                return (long)resultAbs;
            return resultAbs == NegativeLimit ? long.MinValue : -(long)resultAbs;
        }

        public static FixedFloat ToFixedFloatSaturated(long value)
        {
            var max = (long)FixedFloat.MaxValue;
            var min = (long)FixedFloat.MinValue;
            if (value >= max)
                return FixedFloat.MaxValue;
            if (value <= min)
                return FixedFloat.MinValue;
            return value;
        }

        public static long ToLongSaturated(FixedFloat value)
        {
            return (long)value;
        }

        private static bool TryScaleAbs(ulong value, ulong ratioRaw, ulong limit, out ulong result)
        {
            var whole = ratioRaw / Precision;
            var fraction = ratioRaw % Precision;

            result = 0UL;
            if (whole != 0)
            {
                if (value > limit / whole)
                    return false;
                result = value * whole;
            }

            var remaining = limit - result;
            var fractionResult = ScaleFractionAbs(value, fraction);
            if (fractionResult > remaining)
                return false;

            result += fractionResult;
            return true;
        }

        private static ulong ScaleFractionAbs(ulong value, ulong fraction)
        {
            var whole = value / Precision;
            var remainder = value % Precision;
            return whole * fraction + remainder * fraction / Precision;
        }

        private static ulong AbsToUInt64(long value)
        {
            return value >= 0 ? (ulong)value : (ulong)(-(value + 1L)) + 1UL;
        }
    }
}
