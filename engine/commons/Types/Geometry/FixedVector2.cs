using System;
using System.Globalization;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
#if UNITY_EDITOR
    [FixedVector2Drawer]
#endif
    public struct FixedVector2 : IEquatable<FixedVector2>
    {
        /// <summary>
        ///   <para>X component of the vector.</para>
        /// </summary>
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public FixedFloat x;

        /// <summary>
        ///   <para>Y component of the vector.</para>
        /// </summary>
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public FixedFloat y;

        private static readonly FixedVector2 zeroVector = new FixedVector2(FixedFloat.Zero, FixedFloat.Zero);
        private static readonly FixedVector2 oneVector = new FixedVector2(FixedFloat.One, FixedFloat.One);
        private static readonly FixedVector2 upVector = new FixedVector2(FixedFloat.Zero, FixedFloat.One);
        private static readonly FixedVector2 downVector = new FixedVector2(FixedFloat.Zero, FixedFloat.NegativeOne);
        private static readonly FixedVector2 leftVector = new FixedVector2(FixedFloat.NegativeOne, FixedFloat.Zero);
        private static readonly FixedVector2 rightVector = new FixedVector2(FixedFloat.One, FixedFloat.Zero);

        public FixedFloat this[int index]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get
            {
                switch (index)
                {
                    case 0:
                        return this.x;
                    case 1:
                        return this.y;
                    default:
                        throw new IndexOutOfRangeException("Invalid FixedVector2 index!");
                }
            }
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                switch (index)
                {
                    case 0:
                        this.x = value;
                        break;
                    case 1:
                        this.y = value;
                        break;
                    default:
                        throw new IndexOutOfRangeException("Invalid FixedVector2 index!");
                }
            }
        }

        /// <summary>
        ///   <para>Constructs a new vector with given x, y components.</para>
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public FixedVector2(FixedFloat x, FixedFloat y)
        {
            this.x = x;
            this.y = y;
        }

        /// <summary>
        ///   <para>Set x and y components of an existing FixedVector2.</para>
        /// </summary>
        /// <param name="newX"></param>
        /// <param name="newY"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Set(FixedFloat newX, FixedFloat newY)
        {
            this.x = newX;
            this.y = newY;
        }

        /// <summary>
        ///   <para>Linearly interpolates between vectors a and b by t.</para>
        /// </summary>
        /// <param name="a"></param>
        /// <param name="b"></param>
        /// <param name="t"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Lerp(FixedVector2 a, FixedVector2 b, FixedFloat t)
        {
            t = FixedFloatMath.Clamp01(t);
            return new FixedVector2(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
        }

        /// <summary>
        ///   <para>Linearly interpolates between vectors a and b by t.</para>
        /// </summary>
        /// <param name="a"></param>
        /// <param name="b"></param>
        /// <param name="t"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 LerpUnclamped(FixedVector2 a, FixedVector2 b, FixedFloat t)
        {
            return new FixedVector2(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
        }

        /// <summary>
        ///   <para>Moves a point current towards target.</para>
        /// </summary>
        /// <param name="current"></param>
        /// <param name="target"></param>
        /// <param name="maxDistanceDelta"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 MoveTowards(FixedVector2 current, FixedVector2 target, FixedFloat maxDistanceDelta)
        {
            var num1 = target.x - current.x;
            var num2 = target.y - current.y;
            var d = num1 * num1 + num2 * num2;
            if (d == FixedFloat.Zero || maxDistanceDelta >= FixedFloat.Zero &&
                d <= maxDistanceDelta * maxDistanceDelta)
                return target;
            var num3 = FixedFloatMath.Sqrt(d);
            return new FixedVector2(current.x + num1 / num3 * maxDistanceDelta, current.y + num2 / num3 * maxDistanceDelta);
        }

        /// <summary>
        ///   <para>Multiplies two vectors component-wise.</para>
        /// </summary>
        /// <param name="a"></param>
        /// <param name="b"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Scale(FixedVector2 a, FixedVector2 b) => new FixedVector2(a.x * b.x, a.y * b.y);

        /// <summary>
        ///   <para>Multiplies every component of this vector by the same component of scale.</para>
        /// </summary>
        /// <param name="scale"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Scale(FixedVector2 scale)
        {
            this.x *= scale.x;
            this.y *= scale.y;
        }

        /// <summary>
        ///   <para>Makes this vector have a magnitude of 1.</para>
        /// </summary>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Normalize()
        {
            var magnitude = this.magnitude;
            if (magnitude.Raw > 0)
                this = this / magnitude;
            else
                this = FixedVector2.zero;
        }

        /// <summary>
        ///   <para>Returns this vector with a magnitude of 1 (Read Only).</para>
        /// </summary>
        public FixedVector2 normalized
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get
            {
                FixedVector2 normalized = new FixedVector2(this.x, this.y);
                normalized.Normalize();
                return normalized;
            }
        }

        /// <summary>
        ///   <para>Returns a formatted string for this vector.</para>
        /// </summary>
        /// <param name="format">A numeric format string.</param>
        /// <param name="formatProvider">An object that specifies culture-specific formatting.</param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public override string ToString() => this.ToString(null!, null!);

        /// <summary>
        ///   <para>Returns a formatted string for this vector.</para>
        /// </summary>
        /// <param name="format">A numeric format string.</param>
        /// <param name="formatProvider">An object that specifies culture-specific formatting.</param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public string ToString(string format) => this.ToString(format, null!);

        /// <summary>
        ///   <para>Returns a formatted string for this vector.</para>
        /// </summary>
        /// <param name="format">A numeric format string.</param>
        /// <param name="formatProvider">An object that specifies culture-specific formatting.</param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public string ToString(string format, IFormatProvider formatProvider)
        {
            if (string.IsNullOrEmpty(format))
                format = "F2";
            if (formatProvider == null)
                formatProvider = (IFormatProvider)CultureInfo.InvariantCulture.NumberFormat;
            return
                $"({(object)this.x.ToString(format, formatProvider)}, {(object)this.y.ToString(format, formatProvider)})";
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public override int GetHashCode() => this.x.GetHashCode() ^ this.y.GetHashCode() << 2;

        /// <summary>
        ///   <para>Returns true if the given vector is exactly equal to this vector.</para>
        /// </summary>
        /// <param name="other"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public override bool Equals(object? other) => other != null && other is FixedVector2 other1 && this.Equals(other1);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public bool Equals(FixedVector2 other)
        {
            return x == other.x && y == other.y;
        }

        /// <summary>
        ///   <para>Reflects a vector off the vector defined by a normal.</para>
        /// </summary>
        /// <param name="inDirection"></param>
        /// <param name="inNormal"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Reflect(FixedVector2 inDirection, FixedVector2 inNormal)
        {
            var num = FixedFloat.NegativeTwo * Dot(inNormal, inDirection);
            return new FixedVector2(num * inNormal.x + inDirection.x, num * inNormal.y + inDirection.y);
        }

        /// <summary>
        ///   <para>Returns the 2D vector perpendicular to this 2D vector. The result is always rotated 90-degrees in a counter-clockwise direction for a 2D coordinate system where the positive Y axis goes up.</para>
        /// </summary>
        /// <param name="inDirection">The input direction.</param>
        /// <returns>
        ///   <para>The perpendicular direction.</para>
        /// </returns>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Perpendicular(FixedVector2 inDirection)
        {
            return new FixedVector2(-inDirection.y, inDirection.x);
        }

        /// <summary>
        ///   <para>Dot Product of two vectors.</para>
        /// </summary>
        /// <param name="lhs"></param>
        /// <param name="rhs"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat Dot(FixedVector2 lhs, FixedVector2 rhs)
        {
            return lhs.x * rhs.x + lhs.y * rhs.y;
        }

        /// <summary>
        ///   <para>Returns the length of this vector (Read Only).</para>
        /// </summary>
        public FixedFloat magnitude
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get { return FixedFloatMath.Sqrt(x * x + y * y); }
        }

        /// <summary>
        ///   <para>Returns the squared length of this vector (Read Only).</para>
        /// </summary>
        public FixedFloat sqrMagnitude
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get { return x * x + y * y; }
        }

        /// <summary>
        ///   <para>Gets the unsigned angle in degrees between from and to.</para>
        /// </summary>
        /// <param name="from">The vector from which the angular difference is measured.</param>
        /// <param name="to">The vector to which the angular difference is measured.</param>
        /// <returns>
        ///   <para>The unsigned angle in degrees between the two vectors.</para>
        /// </returns>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat Angle(FixedVector2 from, FixedVector2 to)
        {
            var num = FixedFloatMath.Sqrt(from.sqrMagnitude * to.sqrMagnitude);
            return num.Raw == 0
                ? FixedFloat.Zero
                : FixedFloatMath.Acos(FixedFloatMath.Clamp(Dot(from, to) / num, FixedFloat.NegativeOne, FixedFloat.One)) * FixedFloatMath.Rad2Deg;
        }

        /// <summary>
        ///   <para>Gets the signed angle in degrees between from and to.</para>
        /// </summary>
        /// <param name="from">The vector from which the angular difference is measured.</param>
        /// <param name="to">The vector to which the angular difference is measured.</param>
        /// <returns>
        ///   <para>The signed angle in degrees between the two vectors.</para>
        /// </returns>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat SingleAngle(FixedVector2 from, FixedVector2 to)
        {
            return Angle(from, to) * FixedFloatMath.Sign((from.x * to.y - from.y * to.x));
        }

        /// <summary>
        ///   <para>Returns the distance between a and b.</para>
        /// </summary>
        /// <param name="a"></param>
        /// <param name="b"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat Distance(FixedVector2 a, FixedVector2 b)
        {
            var num1 = a.x - b.x;
            var num2 = a.y - b.y;
            return FixedFloatMath.Sqrt(num1 * num1 + num2 * num2);
        }

        /// <summary>
        ///   <para>Returns a copy of vector with its magnitude clamped to maxLength.</para>
        /// </summary>
        /// <param name="vector"></param>
        /// <param name="maxLength"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 ClampMagnitude(FixedVector2 vector, FixedFloat maxLength)
        {
            var sqrMagnitude = vector.sqrMagnitude;
            if (sqrMagnitude <= maxLength * maxLength)
                return vector;
            var num1 = FixedFloatMath.Sqrt(sqrMagnitude);
            var num2 = vector.x / num1;
            var num3 = vector.y / num1;
            return new FixedVector2(num2 * maxLength, num3 * maxLength);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat SqrMagnitude(FixedVector2 a)
        {
            return a.x * a.x + a.y * a.y;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public FixedFloat SqrMagnitude()
        {
            return x * x + y * y;
        }

        /// <summary>
        ///   <para>Returns a vector that is made from the smallest components of two vectors.</para>
        /// </summary>
        /// <param name="lhs"></param>
        /// <param name="rhs"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Min(FixedVector2 lhs, FixedVector2 rhs)
        {
            return new FixedVector2(FixedFloatMath.Min(lhs.x, rhs.x), FixedFloatMath.Min(lhs.y, rhs.y));
        }

        /// <summary>
        ///   <para>Returns a vector that is made from the largest components of two vectors.</para>
        /// </summary>
        /// <param name="lhs"></param>
        /// <param name="rhs"></param>
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 Max(FixedVector2 lhs, FixedVector2 rhs)
        {
            return new FixedVector2(FixedFloatMath.Max(lhs.x, rhs.x), FixedFloatMath.Max(lhs.y, rhs.y));
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator +(FixedVector2 a, FixedVector2 b) => new FixedVector2(a.x + b.x, a.y + b.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator -(FixedVector2 a, FixedVector2 b) => new FixedVector2(a.x - b.x, a.y - b.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator *(FixedVector2 a, FixedVector2 b) => new FixedVector2(a.x * b.x, a.y * b.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator /(FixedVector2 a, FixedVector2 b) => new FixedVector2(a.x / b.x, a.y / b.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator -(FixedVector2 a) => new FixedVector2(-a.x, -a.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator *(FixedVector2 a, FixedFloat d) => new FixedVector2(a.x * d, a.y * d);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator *(FixedFloat d, FixedVector2 a) => new FixedVector2(a.x * d, a.y * d);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedVector2 operator /(FixedVector2 a, FixedFloat d) => new FixedVector2(a.x / d, a.y / d);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static bool operator ==(FixedVector2 lhs, FixedVector2 rhs)
        {
            return lhs.x == rhs.x && lhs.y == rhs.y;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static bool operator !=(FixedVector2 lhs, FixedVector2 rhs) => !(lhs == rhs);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator FixedVector2(Vector2Message v) => new FixedVector2(v.X, v.Y);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static explicit operator Vector2Message(FixedVector2 v) => new Vector2Message { X = (float)v.x, Y = (float)v.y };

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(0, 0).</para>
        /// </summary>
        public static FixedVector2 zero
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.zeroVector;
        }

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(1, 1).</para>
        /// </summary>
        public static FixedVector2 one
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.oneVector;
        }

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(0, 1).</para>
        /// </summary>
        public static FixedVector2 up
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.upVector;
        }

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(0, -1).</para>
        /// </summary>
        public static FixedVector2 down
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.downVector;
        }

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(-1, 0).</para>
        /// </summary>
        public static FixedVector2 left
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.leftVector;
        }

        /// <summary>
        ///   <para>Shorthand for writing FixedVector2(1, 0).</para>
        /// </summary>
        public static FixedVector2 right
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => FixedVector2.rightVector;
        }
        
#if UNITY_5_3_OR_NEWER
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static explicit operator Vector2(FixedVector2 v) => new Vector2((float)v.x, (float)v.y);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator FixedVector2(Vector2 v) => new FixedVector2(v.x, v.y);
#endif
    }
}
