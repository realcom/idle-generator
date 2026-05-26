using System;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct Rectangle : IGeometry
    {
        public IGeometry.Type GeometryType => IGeometry.Type.Rectangle;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 Pivot;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat Angle;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat HalfWidth;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat Height;
        
        public Rectangle(FixedVector2 pivot, FixedFloat angle, FixedFloat halfWidth, FixedFloat height)
        {
            Pivot = pivot;
            Angle = angle;
            HalfWidth = halfWidth;
            Height = height;
        }

        public bool Contains(FixedVector2 point)
        {
            var cos = FixedFloatMath.Cos(Angle);
            var sin = FixedFloatMath.Sin(Angle);
            
            var pointVec = point - Pivot;
            var rotatedPoint = new FixedVector2(pointVec.x * cos - pointVec.y * sin, pointVec.x * sin + pointVec.y * cos);

            return FixedFloatMath.Abs(rotatedPoint.y) <= HalfWidth && rotatedPoint.x >= 0 && rotatedPoint.x <= Height;
        }

        public bool Intersects(in IGeometry other)
        {
            switch (other.GeometryType)
            {
                case IGeometry.Type.Line:
                    return other.Intersects(this);
                case IGeometry.Type.Triangle:
                    throw new NotImplementedException();
                case IGeometry.Type.Circle:
                    return other.Intersects(this);
                case IGeometry.Type.CircleSector:
                    throw new NotImplementedException();
                case IGeometry.Type.Rectangle:
                    throw new NotImplementedException();
                default:
                    throw new NotImplementedException();
            }
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
            var x = StaticRandom.NextFloat() * 2 * HalfWidth - HalfWidth;
            var y = StaticRandom.NextFloat() * Height;
            var cos = FixedFloatMath.Cos(Angle);
            var sin = FixedFloatMath.Sin(Angle);
            return Pivot + new FixedVector2(y * cos - x * sin, y * sin + x * cos);
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            var x = rng.RandomFloat() * 2 * HalfWidth - HalfWidth;
            var y = rng.RandomFloat() * Height;
            var cos = FixedFloatMath.Cos(Angle);
            var sin = FixedFloatMath.Sin(Angle);
            return Pivot + new FixedVector2(y * cos - x * sin, y * sin + x * cos);
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
            var cos = FixedFloatMath.Cos(Angle);
            var sin = FixedFloatMath.Sin(Angle);
            var widthVec = new FixedVector2(-HalfWidth * sin, HalfWidth * cos);
            var heightVec = new FixedVector2(Height * cos, Height * sin);
            var p1 = Pivot + widthVec;
            var p2 = Pivot - widthVec;
            var p3 = Pivot + widthVec + heightVec;
            var p4 = Pivot - widthVec + heightVec;
            
            var minX = FixedFloatMath.Min(p1.x, p2.x, p3.x, p4.x);
            var minY = FixedFloatMath.Min(p1.y, p2.y, p3.y, p4.y);
            var maxX = FixedFloatMath.Max(p1.x, p2.x, p3.x, p4.x);
            var maxY = FixedFloatMath.Max(p1.y, p2.y, p3.y, p4.y);
            
            return new BoundingBox(new FixedVector2((minX + maxX) / 2, (minY + maxY) / 2), new FixedVector2((maxX - minX) / 2, (maxY - minY) / 2));
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            var pivot = GeometricMath.RotateVector2(Pivot, rotation) + position;
            var angle = Angle + rotation;
            
            return new Rectangle(pivot, angle, HalfWidth, Height);
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            var pivot = GeometricMath.RotateVector2(scale * Pivot, rotation) + position;
            var angle = Angle + rotation;
            var halfWidth = scale * HalfWidth;
            var height = scale * Height;
            
            return new Rectangle(pivot, angle, halfWidth, height);
        }

        public override string ToString()
        {
            return $"Rectangle({Pivot}, {Angle}, {HalfWidth}, {Height})";
        }
        
        public Line[] Outlines()
        {
            var lines = new Line[4];
            
            var cos = FixedFloatMath.Cos(Angle);
            var sin = FixedFloatMath.Sin(Angle);
            var widthVec = new FixedVector2(-HalfWidth * sin, HalfWidth * cos);
            var heightVec = new FixedVector2(Height * cos, Height * sin);
            var p1 = Pivot + widthVec;
            var p2 = Pivot - widthVec;
            var p3 = Pivot + widthVec + heightVec;
            var p4 = Pivot - widthVec + heightVec;
            
            lines[0] = new Line(p1, p2);
            lines[1] = new Line(p2, p3);
            lines[2] = new Line(p3, p4);
            lines[3] = new Line(p4, p1);
            
            return lines;
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator Rectangle(GeometryMessage.Types.Rectangle r) => new(r.Pivot, r.Angle, r.HalfWidth, r.Height);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.Rectangle(Rectangle r) => new() { Pivot = (Vector2Message)r.Pivot, Angle = (float)r.Angle, HalfWidth = (float)r.HalfWidth, Height = (float)r.Height };
    }
}