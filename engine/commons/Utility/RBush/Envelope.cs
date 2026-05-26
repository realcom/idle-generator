using System;
using System.Runtime.InteropServices;

namespace RBush
{
    /// <summary>
    /// A bounding envelope, used to identify the bounds of of the points within
    /// a particular node.
    /// </summary>
    /// <param name="MinX">The minimum X value of the bounding box.</param>
    /// <param name="MinY">The minimum Y value of the bounding box.</param>
    /// <param name="MaxX">The maximum X value of the bounding box.</param>
    /// <param name="MaxY">The maximum Y value of the bounding box.</param>
    [StructLayout(LayoutKind.Sequential)]
    public readonly struct Envelope
    {
        public readonly float MinX;
        public readonly float MinY;
        public readonly float MaxX;
        public readonly float MaxY;

        public Envelope(float MinX, float MinY, float MaxX, float MaxY)
        {
            this.MinX = MinX;
            this.MinY = MinY;
            this.MaxX = MaxX;
            this.MaxY = MaxY;
        }

        public float Area => Math.Max(MaxX - MinX, 0) * Math.Max(MaxY - MinY, 0);

        public float Margin => Math.Max(MaxX - MinX, 0) + Math.Max(MaxY - MinY, 0);

        public Envelope Extend(Envelope other) => new Envelope(
            Math.Min(this.MinX, other.MinX),
            Math.Min(this.MinY, other.MinY),
            Math.Max(this.MaxX, other.MaxX),
            Math.Max(this.MaxY, other.MaxY)
        );

        public Envelope Intersection(Envelope other) => new Envelope(
            Math.Max(this.MinX, other.MinX),
            Math.Max(this.MinY, other.MinY),
            Math.Min(this.MaxX, other.MaxX),
            Math.Min(this.MaxY, other.MaxY)
        );

        public bool Contains(Envelope other) =>
            this.MinX <= other.MinX &&
            this.MinY <= other.MinY &&
            this.MaxX >= other.MaxX &&
            this.MaxY >= other.MaxY;

        public bool Intersects(Envelope other) =>
            this.MinX <= other.MaxX &&
            this.MinY <= other.MaxY &&
            this.MaxX >= other.MinX &&
            this.MaxY >= other.MinY;

        public static Envelope InfiniteBounds => new Envelope(
            float.NegativeInfinity,
            float.NegativeInfinity,
            float.PositiveInfinity,
            float.PositiveInfinity);

        public static Envelope EmptyBounds => new Envelope(
            float.PositiveInfinity,
            float.PositiveInfinity,
            float.NegativeInfinity,
            float.NegativeInfinity);

        public override bool Equals(object? obj)
        {
            if (obj is Envelope other)
            {
                return MinX == other.MinX && MinY == other.MinY &&
                       MaxX == other.MaxX && MaxY == other.MaxY;
            }

            return false;
        }

        public override int GetHashCode()
        {
            unchecked // Overflow is fine, just wrap
            {
                int hash = 17;
                hash = hash * 23 + MinX.GetHashCode();
                hash = hash * 23 + MinY.GetHashCode();
                hash = hash * 23 + MaxX.GetHashCode();
                hash = hash * 23 + MaxY.GetHashCode();
                return hash;
            }
        }
    }
}