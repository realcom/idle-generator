using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct BoundingBox : IGeometry
    {
        public static readonly BoundingBox Empty = new(FixedVector2.zero, FixedVector2.zero);

        public IGeometry.Type GeometryType => IGeometry.Type.BoundingBox;

        public static BoundingBox FromMinMax(FixedVector2 min, FixedVector2 max)
        {
            var center = (min + max) / 2;
            var extents = (max - min) / 2;
            return new BoundingBox(center, extents);
        }
        
        public static BoundingBox Merge(IEnumerable<BoundingBox> boxes)
        {
            var min = new FixedVector2(FixedFloat.MaxValue, FixedFloat.MaxValue);
            var max = new FixedVector2(FixedFloat.MinValue, FixedFloat.MinValue);
            foreach (var box in boxes)
            {
                min = FixedVector2.Min(min, box.Min);
                max = FixedVector2.Max(max, box.Max);
            }
            return FromMinMax(min, max);
        }

        public readonly FixedVector2 Center;
        public readonly FixedVector2 Extents;
        public readonly FixedVector2 Min;
        public readonly FixedVector2 Max;
        
        public BoundingBox(FixedVector2 center, FixedVector2 extents)
        {
            Center = center;
            Extents = extents;
            Min = Center - Extents;
            Max = Center + Extents;
        }

        public bool Contains(FixedVector2 point)
        {
            return point.x >= Min.x && point.x <= Max.x && point.y >= Min.y && point.y <= Max.y;
        }

        public bool Intersects(in IGeometry other)
        {
            throw new NotImplementedException();
        }

        public FixedVector2 GetClosestPoint(FixedVector2 point)
        {
            throw new NotImplementedException();
        }

        public FixedVector2 GetClosestPoint(FixedVector2 point, out FixedFloat distance)
        {
            throw new NotImplementedException();
        }
        
        public FixedVector2 GetRandomPoint()
        {
            var x = StaticRandom.NextFloat();
            var y = StaticRandom.NextFloat();
            return new FixedVector2(
                FixedFloatMath.Lerp(Min.x, Max.x, x),
                FixedFloatMath.Lerp(Min.y, Max.y, y)
            );
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            var x = rng.RandomFloat();
            var y = rng.RandomFloat();
            return new FixedVector2(
                FixedFloatMath.Lerp(Min.x, Max.x, x),
                FixedFloatMath.Lerp(Min.y, Max.y, y)
            );
        }

        public bool IsCloserThan(FixedVector2 point, FixedFloat distance)
        {
            throw new NotImplementedException();
        }

        public FixedFloat GetDistance(FixedVector2 point)
        {
            throw new NotImplementedException();
        }

        public BoundingBox GetBoundingBox()
        {
            return this;
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            throw new NotImplementedException();
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            throw new NotImplementedException();
        }
        
        public override string ToString()
        {
            return $"BoundingBox({Center}, {Extents})";
        }

        public static BoundingBox operator +(BoundingBox b1, BoundingBox b2)
        {
            var min = FixedVector2.Min(b1.Min, b2.Min);
            var max = FixedVector2.Max(b1.Max, b2.Max);
            return FromMinMax(min, max);
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator BoundingBox(GeometryMessage.Types.BoundingBox b) => new(b.Center, b.Extents);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.BoundingBox(BoundingBox b) => new() { Center = (Vector2Message)b.Center, Extents = (Vector2Message)b.Extents };
    }    
}
