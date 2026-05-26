using System;
using Commons.Types;

namespace Commons.Utility
{
    public static class FixedFloatMath
    {
        private const ulong Precision = FixedFloat.Precision;
        private const ulong Mask = FixedFloat.Mask;
        private const ulong PositiveLimit = long.MaxValue;
        private const ulong NegativeLimit = PositiveLimit + 1UL;

        public static readonly FixedFloat QuarterPi = 0.78539816339744830962f;
        public static readonly FixedFloat NegativeQuarterPi = -0.78539816339744830962f;
        public static readonly FixedFloat HalfPi = 1.57079632679489661923f;
        public static readonly FixedFloat NegativeHalfPi = -1.57079632679489661923f;
        public static readonly FixedFloat Pi = 3.14159265358979323846f;
        public static readonly FixedFloat ThreeQuartersPi = 2.35619449019234492884f;
        public static readonly FixedFloat TwoPi = 6.28318530717958647693f;
        public static readonly FixedFloat Rad2Deg = 57.2957795130823208768f;
        public static readonly FixedFloat Deg2Rad = 0.01745329251994329577f;
        
        public static readonly FixedFloat E = 2.71828182845904523536f;
        
        private static readonly FixedFloat Tolerance = 1e-3f;
        
        public static FixedFloat Abs(FixedFloat a)
        {
            return a >= FixedFloat.Zero ? a : -a;
        }
        
        public static FixedFloat Min(FixedFloat a, FixedFloat b)
        {
            return a < b ? a : b;
        }
        
        public static FixedFloat Min(FixedFloat a, FixedFloat b, FixedFloat c)
        {
            return Min(Min(a, b), c);
        }
        
        public static FixedFloat Min(FixedFloat a, FixedFloat b, FixedFloat c, FixedFloat d)
        {
            return Min(Min(a, b), Min(c, d));
        }
        
        public static FixedFloat Max(FixedFloat a, FixedFloat b)
        {
            return a > b ? a : b;
        }
        
        public static FixedFloat Max(FixedFloat a, FixedFloat b, FixedFloat c)
        {
            return Max(Max(a, b), c);
        }
        
        public static FixedFloat Max(FixedFloat a, FixedFloat b, FixedFloat c, FixedFloat d)
        {
            return Max(Max(a, b), Max(c, d));
        }

        public static FixedFloat AddSaturated(FixedFloat a, FixedFloat b)
        {
            if (b.Raw > 0 && a.Raw > long.MaxValue - b.Raw)
                return FixedFloat.MaxValue;
            if (b.Raw < 0 && a.Raw < long.MinValue - b.Raw)
                return FixedFloat.MinValue;
            return FixedFloat.FromRaw(a.Raw + b.Raw);
        }

        public static FixedFloat MultiplySaturated(FixedFloat a, FixedFloat b)
        {
            if (a.Raw == 0 || b.Raw == 0)
                return FixedFloat.Zero;

            var negative = a.Raw < 0 ^ b.Raw < 0;
            var absA = AbsToUInt64(a.Raw);
            var absB = AbsToUInt64(b.Raw);
            var limit = negative ? NegativeLimit : PositiveLimit;

            if (!TryMultiplyAbs(absA, absB, limit, out var resultAbs, out var hasRemainder))
                return negative ? FixedFloat.MinValue : FixedFloat.MaxValue;

            if (negative && hasRemainder)
            {
                if (resultAbs == NegativeLimit)
                    return FixedFloat.MinValue;
                resultAbs += 1UL;
            }

            if (!negative)
                return FixedFloat.FromRaw((long)resultAbs);
            return resultAbs == NegativeLimit ? FixedFloat.MinValue : FixedFloat.FromRaw(-(long)resultAbs);
        }

        public static FixedFloat RatioFromPercentSaturated(FixedFloat percent)
        {
            return AddSaturated(FixedFloat.One, percent / 100);
        }
        
        public static FixedFloat Clamp(FixedFloat value, FixedFloat min, FixedFloat max)
        {
            return Max(min, Min(value, max));
        }
        
        public static FixedFloat Lerp(FixedFloat a, FixedFloat b, FixedFloat t)
        {
            return a + (b - a) * t;
        }
        
        public static FixedFloat Sqrt(FixedFloat x)
        {
            if (x < FixedFloat.Zero)
                throw new ArgumentException("Negative value passed to Sqrt");
            if (x == FixedFloat.Zero)
                return FixedFloat.Zero;
            
            var x0 = x;
            var x1 = (x0 + FixedFloat.One) >> 1;
            while (Abs(x1 - x0) > Tolerance)
            {
                x0 = x1;
                x1 = (x0 + x / x0) >> 1;
            }
            return x1;
        }
        
        public static FixedFloat Pow(this FixedFloat x, FixedFloat y)
        {
            if (y == FixedFloat.Zero)
                return FixedFloat.One;
            if (x == FixedFloat.Zero)
            {
                if (y < FixedFloat.Zero)
                    throw new ArgumentException("Zero raised to a negative power");
                return FixedFloat.Zero;
            }
            if (x == FixedFloat.One)
                return FixedFloat.One;
            if (y == FixedFloat.One)
                return x;
            if (y < FixedFloat.Zero)
                return FixedFloat.One / Pow(x, -y);
            if (x < FixedFloat.Zero)
                throw new ArgumentException("Negative base raised to a non-integer power");
            
            return Exp(y * Log(x));
        }

        public static FixedFloat MapRangeClamped(FixedFloat value, FixedFloat fromMin, FixedFloat fromMax)
        {
            return MapRangeClamped(value, fromMin, fromMax, FixedFloat.Zero, FixedFloat.One);
        }
        
        public static FixedFloat MapRangeClamped(FixedFloat value, FixedFloat fromMin, FixedFloat fromMax, FixedFloat toMin, FixedFloat toMax)
        {
            var mappedValue = (value - fromMin) / (fromMax - fromMin) * (toMax - toMin) + toMin;
            return Clamp(mappedValue, Min(toMin, toMax), Max(toMin, toMax));
        }
        
        // Padé approximant
        private static readonly FixedFloat ExpP0 = 1.0f;
        private static readonly FixedFloat ExpP1 = 4.0f / 7.0f;
        private static readonly FixedFloat ExpP2 = 1.0f / 7.0f;
        private static readonly FixedFloat ExpP3 = 2.0f / 105.0f;
        private static readonly FixedFloat ExpP4 = 1.0f / 840.0f;
        private static readonly FixedFloat ExpQ0 = 1.0f;
        private static readonly FixedFloat ExpQ1 = -3.0f / 7.0f;
        private static readonly FixedFloat ExpQ2 = 1.0f / 14.0f;
        private static readonly FixedFloat ExpQ3 = -1.0f / 210.0f;
        public static FixedFloat Exp(FixedFloat x)
        {
            if (x == FixedFloat.Zero)
                return FixedFloat.One;
            if (x < FixedFloat.Zero)
                return FixedFloat.One / Exp(-x);
            
            var exponent = 0;
            while (x >= FixedFloat.Two)
            {
                x >>= 1;
                exponent += 1;
            }
            
            var x2 = x * x;
            var x3 = x2 * x;
            var x4 = x2 * x2;
            var p = ExpP4 * x4 + ExpP3 * x3 + ExpP2 * x2 + ExpP1 * x + ExpP0;
            var q = ExpQ3 * x3 + ExpQ2 * x2 + ExpQ1 * x + ExpQ0;
            
            var result = p / q;
            for (var i = 0; i < exponent; ++i)
                result *= result;

            return result;
        }

        private static readonly FixedFloat LogC1 = 1f / 3;
        private static readonly FixedFloat LogC2 = 1f / 5;
        private static readonly FixedFloat LogC3 = 1f / 7;
        private static readonly FixedFloat LogC4 = 1f / 9;
        public static FixedFloat Log(FixedFloat x)
        {
            if (x <= FixedFloat.Zero)
                throw new ArgumentException("Non-positive value passed to Log");
            
            var exponent = 0;
            while (x >= FixedFloat.Two)
            {
                x >>= 1;
                exponent += 1;
            }
            while (x < FixedFloat.Half)
            {
                x <<= 1;
                exponent -= 1;
            }
            
            var y = (x - FixedFloat.One) / (x + FixedFloat.One);
            var y2 = y * y;
            
            var result = FixedFloat.Two * y * (FixedFloat.One + y2 * (LogC1 + y2 * (LogC2 + y2 * (LogC3 + y2 * LogC4))));
            
            return result + FixedFloat.Log2 * exponent;
        }

        private static bool TryMultiplyAbs(ulong a, ulong b, ulong limit, out ulong result, out bool hasRemainder)
        {
            var aWhole = a >> FixedFloat.Shift;
            var aFraction = a & Mask;
            var bWhole = b >> FixedFloat.Shift;
            var bFraction = b & Mask;

            result = 0UL;
            hasRemainder = false;

            if (aWhole != 0)
            {
                if (b > limit / aWhole)
                    return false;
                result = aWhole * b;
            }

            if (aFraction != 0 && bWhole != 0)
            {
                if (aFraction > (limit - result) / bWhole)
                    return false;
                result += aFraction * bWhole;
            }

            var fractionProduct = aFraction * bFraction;
            var fractionResult = fractionProduct >> FixedFloat.Shift;
            hasRemainder = (fractionProduct & Mask) != 0;
            if (fractionResult > limit - result)
                return false;

            result += fractionResult;
            return true;
        }

        private static ulong AbsToUInt64(long value)
        {
            return value >= 0 ? (ulong)value : (ulong)(-(value + 1L)) + 1UL;
        }
        
        private static readonly FixedFloat SinC1 = -0.16666666666666666f;
        private static readonly FixedFloat SinC2 = 0.008333333333333333f;
        private static readonly FixedFloat SinC3 = -0.0001984126984126984f;
        public static FixedFloat Sin(FixedFloat x)
        {
            x %= TwoPi;
            if (x < FixedFloat.Zero)
                x += TwoPi;
            var negate = false;
            if (x > Pi)
            {
                x -= Pi;
                negate = true;
            }
            if (x > HalfPi)
                x = Pi - x;
            
            var x2 = x * x;
            var result = x + x * x2 * (SinC1 + x2 * (SinC2 + SinC3 * x2));
            if (negate)
                result = -result;
            
            return Clamp(result, FixedFloat.NegativeOne, FixedFloat.One);
        }
        
        private static readonly FixedFloat CosC1 = -0.5f;
        private static readonly FixedFloat CosC2 = 0.041666666666666664f;
        private static readonly FixedFloat CosC3 = -0.001388888888888889f;
        public static FixedFloat Cos(FixedFloat x)
        {
            x %= TwoPi;
            if (x < FixedFloat.Zero)
                x += TwoPi;
            var negate = false;
            if (x > Pi)
            {
                x -= Pi;
                negate = true;
            }
            if (x > HalfPi)
            {
                x = Pi - x;
                negate = !negate;
            }
            
            var a2 = x * x;
            var result = FixedFloat.One + a2 * (CosC1 + a2 * (CosC2 + CosC3 * a2));
            if (negate)
                result = -result;
            
            return Clamp(result, FixedFloat.NegativeOne, FixedFloat.One);
        }
        
        public static FixedFloat Tan(FixedFloat a)
        {
            var sinValue = Sin(a);
            var cosValue = Cos(a);

            if (cosValue == FixedFloat.Zero)
                throw new DivideByZeroException("Tangent is undefined for angles where cosine is zero.");

            return sinValue / cosValue;
        }
        
        public static FixedFloat Atan2(FixedFloat y, FixedFloat x)
        {
            if (x == FixedFloat.Zero)
                return y > FixedFloat.Zero ? HalfPi : y < FixedFloat.Zero ? -HalfPi : FixedFloat.Zero;
            if (y == FixedFloat.Zero)
                return x > FixedFloat.Zero ? FixedFloat.Zero : -Pi;
            
            if (Abs(y) > Abs(x))
            {
                var z = x / y;
                var result = HalfPi - Atan(z);
                if (y < FixedFloat.Zero)
                    return result - Pi;
                return result;
            }
            else
            {
                var z = y / x;
                var result = Atan(z);
                if (x < FixedFloat.Zero)
                {
                    if (y < FixedFloat.Zero)
                        return result - Pi;
                    return result + Pi;
                }
                return result;
            }
        }
        
        public static FixedFloat Asin(FixedFloat a)
        {
            if (a < -FixedFloat.One || a > FixedFloat.One)
                throw new ArgumentException("Value passed to Asin is out of range");
            return Atan2(a, Sqrt(FixedFloat.One - a * a));
        }
        
        public static FixedFloat Acos(FixedFloat a)
        {
            if (a < -FixedFloat.One || a > FixedFloat.One)
                throw new ArgumentException("Value passed to Acos is out of range");
            return Atan2(Sqrt(FixedFloat.One - a * a), a);
        }
        
        private static readonly FixedFloat AtanC1 = 0.9998660f;
        private static readonly FixedFloat AtanC2 = -0.3302995f;
        private static readonly FixedFloat AtanC3 = 0.1801410f;
        private static readonly FixedFloat AtanC4 = -0.085133f;
        private static readonly FixedFloat AtanC5 = 0.0208351f;
        public static FixedFloat Atan(FixedFloat x)
        {
            var invert = false;
            if (Abs(x) > FixedFloat.One)
            {
                x = FixedFloat.One / x;
                invert = true;
            }

            var x2 = x * x;
            var result = ((AtanC5 * x2 + AtanC4) * x2 + AtanC3) * x2 + AtanC2;
            result = result * x2 + AtanC1;
            result = result * x;

            if (invert)
                result = x > FixedFloat.Zero ? HalfPi - result : -HalfPi - result;

            return Clamp(result, -HalfPi, HalfPi);
        }
        
        public static FixedFloat Sinh(FixedFloat a)
        {
            return (Exp(a) - Exp(-a)) / FixedFloat.Two;
        }
        
        public static FixedFloat Cosh(FixedFloat a)
        {
            return (Exp(a) + Exp(-a)) / FixedFloat.Two;
        }
        
        public static FixedFloat Tanh(FixedFloat a)
        {
            return Sinh(a) / Cosh(a);
        }
        
        public static FixedFloat Asinh(FixedFloat a)
        {
            return Log(a + Sqrt(a * a + FixedFloat.One));
        }
        
        public static FixedFloat Acosh(FixedFloat a)
        {
            return Log(a + Sqrt(a * a - FixedFloat.One));
        }
        
        public static FixedFloat Atanh(FixedFloat a)
        {
            return Log((FixedFloat.One + a) / (FixedFloat.One - a)) / FixedFloat.Two;
        }
        
        public static FixedFloat Floor(FixedFloat a)
        {
            return FixedFloat.FromRaw(a.Raw & FixedFloat.InvertedMask);
        }
        
        public static FixedFloat Ceiling(FixedFloat a)
        {
            return FixedFloat.FromRaw((a.Raw + FixedFloat.Mask) & FixedFloat.InvertedMask);
        }
        
        public static FixedFloat Round(FixedFloat a)
        {
            return FixedFloat.FromRaw((a.Raw + FixedFloat.HalfPrecision) & FixedFloat.InvertedMask);
        }
        
        public static FixedFloat Truncate(FixedFloat a)
        {
            return a >= FixedFloat.Zero ? Floor(a) : Ceiling(a);
        }
        
        public static FixedFloat Frac(FixedFloat a)
        {
            return a - Floor(a);
        }
        
        public static FixedFloat Sign(FixedFloat a)
        {
            return a > FixedFloat.Zero ? FixedFloat.One : a < FixedFloat.Zero ? -FixedFloat.One : FixedFloat.Zero;
        }
        
        public static FixedFloat Mod(FixedFloat a, FixedFloat b)
        {
            return a - Floor(a / b) * b;
        }
        
        public static FixedFloat Rem(FixedFloat a, FixedFloat b)
        {
            return a - Floor(a / b) * b;
        }

        public static FixedFloat Clamp01(FixedFloat value)
        {
            if (value < FixedFloat.Zero)
                return FixedFloat.Zero;
            if (value > FixedFloat.One)
                return FixedFloat.One;
            return value;
        }
    }
}
