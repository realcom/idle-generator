using System;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct Circle : IGeometry
    {
        public IGeometry.Type GeometryType => IGeometry.Type.Circle;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 Center;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat Radius;
        
        public Circle(FixedVector2 center, FixedFloat radius)
        {
            Center = center;
            Radius = radius;
        }

        public bool Contains(FixedVector2 point)
        {
            return FixedVector2.Distance(Center, point) <= Radius;
        }

        public bool Intersects(in IGeometry other)
        {
            switch (other.GeometryType)
            {
                case IGeometry.Type.Line:
                    return other.Intersects(this);
                case IGeometry.Type.Triangle:
                    return other.Intersects(this);
                case IGeometry.Type.Circle:
                {
                    var circle = (Circle)other;
                    return FixedVector2.Distance(Center, circle.Center) <= Radius + circle.Radius;
                }
                case IGeometry.Type.CircleSector:
                {
                    // Check if the center of the circle is within the sector
                    var sector = (CircleSector)other;
                    if (sector.Contains(Center))
                        return true;
        
                    // Check if the center of the sector is within the circle
                    if (Contains(sector.Center))
                        return true;
        
                    // Check if the circle intersects with the sector's bounding lines
                    var vector = Center - sector.Center;
                    var angle = FixedFloatMath.Atan2(vector.y, vector.x);
                    if (sector.ContainsAngle(angle))
                    {
                        if (FixedVector2.Distance(Center, sector.Center) <= Radius + sector.Radius)
                            return true;
                        return false;
                    }
        
                    var radius1 = new Line(sector.Center, sector.ArcStartPoint());
                    var radius2 = new Line(sector.Center, sector.ArcEndPoint());
                    if (radius1.Intersects(this) || radius2.Intersects(this))
                        return true;
        
                    // Further checks could include line-circle intersections for each bounding line of the sector
                    return false;
                }
                case IGeometry.Type.Rectangle:
                {
                    // Rectangle is contained within the circle
                    foreach (var outline in ((Rectangle)other).Outlines())
                    {
                        if (GetDistance(outline.P1) <= Radius)
                            return true;
                    }
                    // Circle is contained within the rectangle
                    if (((Rectangle)other).Contains(Center))
                        return true;
                    foreach (var outline in ((Rectangle)other).Outlines())
                    {
                        if (Intersects(outline))
                            return true;
                    }

                    return false;
                }
                default:
                    throw new NotImplementedException();
            }
        }

        public FixedVector2 GetClosestPoint(FixedVector2 point)
        {
            return GetClosestPoint(point, out var _);
        }

        public FixedVector2 GetClosestPoint(FixedVector2 point, out FixedFloat distance)
        {
            var vector = point - Center;
            var distanceFromCenterToPoint = vector.magnitude;
            distance = distanceFromCenterToPoint - Radius;
            return Radius / distanceFromCenterToPoint * vector;
        }

        public FixedVector2 GetRandomPoint()
        {
            var randomRadius = StaticRandom.NextFloat() * Radius;
            var randomAngle = StaticRandom.NextFloat() * FixedFloatMath.TwoPi;
            return Center + randomRadius * GeometricMath.AngleToUnitVector2(randomAngle);
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            var randomRadius = rng.RandomFloat() * Radius;
            var randomAngle = rng.RandomFloat() * FixedFloatMath.TwoPi;
            return Center + randomRadius * GeometricMath.AngleToUnitVector2(randomAngle);
        }

        public bool IsCloserThan(FixedVector2 point, FixedFloat distance)
        {
            return (point - Center).sqrMagnitude < distance * distance;
        }

        public FixedFloat GetDistance(FixedVector2 point)
        {
            return FixedFloatMath.Abs(FixedVector2.Distance(Center, point) - Radius);
        }

        public BoundingBox GetBoundingBox()
        {
            return new BoundingBox(Center, new FixedVector2(Radius, Radius));
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            return new Circle(GeometricMath.RotateVector2(Center, rotation) + position, Radius);
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            return new Circle(GeometricMath.RotateVector2(scale * Center, rotation) + position, scale * Radius);
        }
        
        public override string ToString()
        {
            return $"Circle({Center}, {Radius})";
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator Circle(GeometryMessage.Types.Circle c) => new(c.Center, c.Radius);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.Circle(Circle c) => new() { Center = (Vector2Message)c.Center, Radius = (float)c.Radius };
    }
}
