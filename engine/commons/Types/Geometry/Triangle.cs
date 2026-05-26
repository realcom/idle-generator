using Commons.Resources;
using Commons.Utility;
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct Triangle : IGeometry
    {
        public static readonly FixedFloat Epsilon = 1e-3f;
        public IGeometry.Type GeometryType => IGeometry.Type.Triangle;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 P1;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 P2;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 P3;
        
        public Triangle(FixedVector2 p1, FixedVector2 p2, FixedVector2 p3)
        {
            P1 = p1;
            P2 = p2;
            P3 = p3;
        }

        public bool Contains(FixedVector2 point)
        {
            var v1v2 = P2 - P1;
            var v2v3 = P3 - P2;
            var v3v1 = P1 - P3;

            var v1p = point - P1;
            var v2p = point - P2;
            var v3p = point - P3;

            var cross1 = Vector2Extensions.Cross(v1v2, v1p);
            var cross2 = Vector2Extensions.Cross(v2v3, v2p);
            var cross3 = Vector2Extensions.Cross(v3v1, v3p);
            
            return (cross1 >= -Epsilon && cross2 >= -Epsilon && cross3 >= -Epsilon) || (cross1 <= Epsilon && cross2 <= Epsilon && cross3 <= Epsilon);
        }

        public bool Intersects(in IGeometry other)
        {
            switch (other.GeometryType)
            {
                case IGeometry.Type.Line:
                    return other.Intersects(this);
                case IGeometry.Type.Triangle:
                {
                    foreach (var line1 in GetLines())
                    {
                        foreach (var line2 in ((Triangle)other).GetLines())
                        {
                            if (line2.Intersects(line1))
                                return true;
                        }
                    }
        
                    return false;
                }
                case IGeometry.Type.Circle:
                {
                    if (Contains(((Circle)other).Center))
                        return true;
                    if (other.Contains(P1) || other.Contains(P2) || other.Contains(P3))
                        return true;
                    foreach (var line in GetLines())
                    {
                        if (line.Intersects(other))
                            return true;
                    }
        
                    return false;
                }
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
            return GetClosestPoint(point, out var _);
        }

        public FixedVector2 GetClosestPoint(FixedVector2 point, out FixedFloat distance)
        {
            if (Contains(point))
            {
                distance = FixedFloat.Zero;
                return point;
            }
            
            // Calculate the distance to each edge
            var closest1 = new Line(P1, P2).GetClosestPoint(point, out var distanceEdge1);
            var closest2 = new Line(P2, P3).GetClosestPoint(point, out var distanceEdge2);
            var closest3 = new Line(P3, P1).GetClosestPoint(point, out var distanceEdge3);

            distance = FixedFloat.MaxValue;
            var nearestPosition = FixedVector2.zero;

            if (distanceEdge1 < distance)
            {
                nearestPosition = closest1;
                distance = distanceEdge1;
            }

            if (distanceEdge2 < distance)
            {
                nearestPosition = closest2;
                distance = distanceEdge2;
            }

            if (distanceEdge3 < distance)
            {
                nearestPosition = closest3;
                distance = distanceEdge3;
            }
            
            return nearestPosition;
        }

        public FixedVector2 GetRandomPoint()
        {
            var r1 = StaticRandom.NextFloat();
            var r2 = StaticRandom.NextFloat();

            if (r1 + r2 >= 1)
            {
                r1 = 1 - r1;
                r2 = 1 - r2;
            }

            var r3 = 1 - r1 - r2;
            var x = r1 * P1.x + r2 * P2.x + r3 * P3.x;
            var y = r1 * P1.y + r2 * P2.y + r3 * P3.y;

            return new FixedVector2(x, y);
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            var r1 = rng.RandomFloat();
            var r2 = rng.RandomFloat();

            if (r1 + r2 >= 1)
            {
                r1 = 1 - r1;
                r2 = 1 - r2;
            }

            var r3 = 1 - r1 - r2;
            var x = r1 * P1.x + r2 * P2.x + r3 * P3.x;
            var y = r1 * P1.y + r2 * P2.y + r3 * P3.y;

            return new FixedVector2(x, y);
        }

        public bool IsCloserThan(FixedVector2 point, FixedFloat distance)
        {
            return GetDistance(point) < distance;
        }

        public FixedFloat GetDistance(FixedVector2 point)
        {
            GetClosestPoint(point, out var distance);
            return distance;
        }

        public BoundingBox GetBoundingBox()
        {
            var minX = FixedFloatMath.Min(P1.x, P2.x, P3.x);
            var minY = FixedFloatMath.Min(P1.y, P2.y, P3.y);
            var maxX = FixedFloatMath.Max(P1.x, P2.x, P3.x);
            var maxY = FixedFloatMath.Max(P1.y, P2.y, P3.y);

            var center = new FixedVector2((minX + maxX) / 2, (minY + maxY) / 2);
            var extents = new FixedVector2((maxX - minX) / 2, (maxY - minY) / 2);

            return new BoundingBox(center, extents);
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            var p1 = GeometricMath.RotateVector2(P1, rotation) + position;
            var p2 = GeometricMath.RotateVector2(P2, rotation) + position;
            var p3 = GeometricMath.RotateVector2(P3, rotation) + position;
            
            return new Triangle(p1, p2, p3);
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            var p1 = GeometricMath.RotateVector2(scale * P1, rotation) + position;
            var p2 = GeometricMath.RotateVector2(scale * P2, rotation) + position;
            var p3 = GeometricMath.RotateVector2(scale * P3, rotation) + position;
            
            return new Triangle(p1, p2, p3);
        }

        public override string ToString()
        {
            return $"Triangle({P1}, {P2}, {P3})";
        }

        public List<Line> GetLines()
        {
            return new List<Line>
            {
                new(P1, P2),
                new(P2, P3),
                new(P3, P1)
            };
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator Triangle(GeometryMessage.Types.Triangle t) => new(t.P1, t.P2, t.P3);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.Triangle(Triangle t) => new() { P1 = (Vector2Message)t.P1, P2 = (Vector2Message)t.P2, P3 = (Vector2Message)t.P3 };
    }
}