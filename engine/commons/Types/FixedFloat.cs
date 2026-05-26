using System;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types
{
#if UNITY_EDITOR
    [FixedFloatDrawer]
#endif
    public readonly struct FixedFloat :
        IComparable,
        IComparable<FixedFloat>,
        IEquatable<FixedFloat>
    {
        public const int Shift = 16;
        public const long Precision = 1 << Shift;
        public const long HalfPrecision = Precision >> 1;
        public const long Mask = Precision - 1;
        public const long InvertedMask = ~Mask;
        
        public static readonly FixedFloat MaxValue = FromRaw(long.MaxValue);
        public static readonly FixedFloat MinValue = FromRaw(long.MinValue);
        public static readonly float MaxValueFloat = (float)MaxValue;
        public static readonly float MinValueFloat = (float)MinValue;
        // MaxValueDouble = long.MaxValue / 2^16 ≈ 140,737,488,355,327.9999847412109375
        public static readonly double MaxValueDouble = (double)MaxValue;
        // MinValueDouble = long.MinValue / 2^16 ≈ -140,737,488,355,328.0000152587890625
        public static readonly double MinValueDouble = (double)MinValue;
        
        public static readonly FixedFloat Zero = new(0);
        public static readonly FixedFloat One = FromRaw(Precision);
        public static readonly FixedFloat NegativeOne = FromRaw(-Precision);
        public static readonly FixedFloat Half = FromRaw(Precision >> 1);
        public static readonly FixedFloat Two = FromRaw(Precision << 1);
        public static readonly FixedFloat NegativeTwo = FromRaw(-Precision << 1);
        public static readonly FixedFloat Sqrt2 = 1.41421356237309504880f;
        public static readonly FixedFloat Three = FromRaw(Precision * 3);
        public static readonly FixedFloat Four = FromRaw(Precision << 2);
        public static readonly FixedFloat Eight = FromRaw(Precision << 3);
        public static readonly FixedFloat Fifty = 50;
        public static readonly FixedFloat Hundred = 100;
        public static readonly FixedFloat Log2 = 0.69314718055994530941f;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly long Raw;
        
        private FixedFloat(long raw)
        {
            Raw = raw;
        }
        
        public static FixedFloat FromRaw(long raw)
        {
            return new FixedFloat(raw);
        }
        
        public static implicit operator FixedFloat(float value)
        {
            if (value <= MinValueFloat)
                return MinValue;
            if (value >= MaxValueFloat)
                return MaxValue;
            if (float.IsNaN(value))
                throw new ArgumentException("NaN is not supported");
            if (float.IsInfinity(value))
                throw new ArgumentException("Infinity is not supported");
            var raw = (long)(value * Precision + (value >= 0 ? 0.5f : -0.5f));
            if (raw == 0 && value != 0f)
                raw = value < 0 ? -1 : 1;
            return new FixedFloat(raw);
        }
        
        public static explicit operator float(FixedFloat value)
        {
            return (float)value.Raw / Precision;
        }

        public static implicit operator FixedFloat(double value)
        {
            if (value <= MinValueDouble)
                return MinValue;
            if (value >= MaxValueDouble)
                return MaxValue;
            if (double.IsNaN(value))
                throw new ArgumentException("NaN is not supported");
            if (double.IsInfinity(value))
                throw new ArgumentException("Infinity is not supported");
            var raw = (long)(value * Precision + (value >= 0 ? 0.5 : -0.5));
            if (raw == 0 && value != 0.0)
                raw = value < 0 ? -1 : 1;
            return new FixedFloat(raw);
        }
        
        public static explicit operator double(FixedFloat value)
        {
            return (double)value.Raw / Precision;
        }
        
        public static implicit operator FixedFloat(int value)
        {
            return new FixedFloat(value * Precision);
        }
        
        public static explicit operator int(FixedFloat value)
        {
            return (int)(value.Raw / Precision);
        }

        public static FixedFloat Abs(FixedFloat v)
        {
            return FromRaw(v.Raw < 0 ? -v.Raw : v.Raw);
        }

        public static implicit operator FixedFloat(uint value)
        {
            return new FixedFloat(value * Precision);
        }
        
        public static explicit operator uint(FixedFloat value)
        {
            return (uint)(value.Raw / Precision);
        }
        
        public static implicit operator FixedFloat(long value)
        {
            return new FixedFloat(value * Precision);
        }
        
        public static implicit operator FixedFloat(bool value)
        {
            return value ? FixedFloat.One : FixedFloat.Zero;
        }
        
        public static explicit operator long(FixedFloat value)
        {
            return value.Raw / Precision;
        }
        
        public static FixedFloat operator +(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat(a.Raw + b.Raw);
        }
        
        public static FixedFloat operator -(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat(a.Raw - b.Raw);
        }
        
        public static FixedFloat operator *(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat((a.Raw * b.Raw) >> Shift);
        }
        
        public static FixedFloat operator *(FixedFloat a, int b)
        {
            return new FixedFloat(a.Raw * b);
        }
        
        public static FixedFloat operator *(FixedFloat a, long b)
        {
            return new FixedFloat(a.Raw * b);
        }
        
        public static FixedFloat operator /(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat((a.Raw << Shift) / b.Raw);
        }

        public static FixedFloat operator /(FixedFloat a, int b)
        {
            return new FixedFloat(a.Raw / b);
        }

        public static FixedFloat operator /(FixedFloat a, long b)
        {
            return new FixedFloat(a.Raw / b);
        }
        
        public static FixedFloat operator -(FixedFloat a)
        {
            return new FixedFloat(-a.Raw);
        }
        
        public static FixedFloat operator %(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat(a.Raw % b.Raw);
        }
        
        public static FixedFloat operator ++(FixedFloat a)
        {
            return new FixedFloat(a.Raw + Precision);
        }
        
        public static FixedFloat operator --(FixedFloat a)
        {
            return new FixedFloat(a.Raw - Precision);
        }
        
        public static FixedFloat operator &(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat(a.Raw & b.Raw);
        }
        
        public static FixedFloat operator |(FixedFloat a, FixedFloat b)
        {
            return new FixedFloat(a.Raw | b.Raw);
        }
        
        public static bool operator ==(FixedFloat a, FixedFloat b)
        {
            return a.Raw == b.Raw;
        }
        
        public static bool operator !=(FixedFloat a, FixedFloat b)
        {
            return a.Raw != b.Raw;
        }
        
        public static bool operator <(FixedFloat a, FixedFloat b)
        {
            return a.Raw < b.Raw;
        }
        
        public static bool operator >(FixedFloat a, FixedFloat b)
        {
            return a.Raw > b.Raw;
        }
        
        public static bool operator <=(FixedFloat a, FixedFloat b)
        {
            return a.Raw <= b.Raw;
        }
        
        public static bool operator >=(FixedFloat a, FixedFloat b)
        {
            return a.Raw >= b.Raw;
        }
        
        public static FixedFloat operator <<(FixedFloat a, int b)
        {
            return new FixedFloat(a.Raw << b);
        }
        
        public static FixedFloat operator >>(FixedFloat a, int b)
        {
            return new FixedFloat(a.Raw >> b);
        }

        public int CompareTo(FixedFloat other)
        {
            return Raw.CompareTo(other.Raw);
        }

        public bool Equals(FixedFloat other)
        {
            return Raw == other.Raw;
        }

        public override bool Equals(object? obj)
        {
            return obj is FixedFloat other && Raw == other.Raw;
        }
        
        public override int GetHashCode()
        {
            return Raw.GetHashCode();
        }
        
        public override string ToString()
        {
            return ((float)this).ToString();
        }

        public string ToString(string? format)
        {
            return ((float)this).ToString(format);
        }

        public string ToString(string? format, IFormatProvider? provider)
        {
            return ((float)this).ToString(format, provider);
        }

        public int CompareTo(object obj)
        {
            if (obj is FixedFloat other)
                return Raw.CompareTo(other.Raw);
            throw new ArgumentException();
        }
    }
}
