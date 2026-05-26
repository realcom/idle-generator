using System;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct Line : IGeometry
    {
        public IGeometry.Type GeometryType => IGeometry.Type.Line;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 P1;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 P2;
        
        public Line(FixedVector2 p1, FixedVector2 p2)
        {
            P1 = p1;
            P2 = p2;
        }

        public bool Contains(FixedVector2 point)
        {
            // will not be implemented
            throw new NotImplementedException();
        }

        public bool Intersects(in IGeometry other)
        {
            switch (other.GeometryType)
            {
                case IGeometry.Type.Line:
                {
                    var otherLine = (Line)other;
                    var o1 = Orientation(P1, P2, otherLine.P1);
                    var o2 = Orientation(P1, P2, otherLine.P2);
                    var o3 = Orientation(otherLine.P1, otherLine.P2, P1);
                    var o4 = Orientation(otherLine.P1, otherLine.P2, P2);
                
                    if (o1 != o2 && o3 != o4)
                        return true;
                
                    if (o1 == 0 && OnSegment(otherLine.P1)) return true;
                    if (o2 == 0 && OnSegment(otherLine.P2)) return true;
                    if (o3 == 0 && otherLine.OnSegment(P1)) return true;
                    if (o4 == 0 && otherLine.OnSegment(P2)) return true;
                
                    return false;
                }
                case IGeometry.Type.Triangle:
                {
                    var triangle = (Triangle)other;
                    foreach (var line in triangle.GetLines())
                    {
                        // we can just ignore the warning.
                        if (Intersects(line))
                            return true;
                    }
                
                    return false;
                }
                case IGeometry.Type.Circle:
                {
                    var circle = (Circle)other;
                    return circle.Contains(GetClosestPoint(circle.Center));
                }
                case IGeometry.Type.CircleSector:
                    throw new NotImplementedException();
                case IGeometry.Type.Rectangle:
                    // If the line intersects with any of the rectangle's lines, return true
                    foreach (var line in ((Rectangle)other).Outlines())
                    {
                        if (Intersects(line))
                            return true;
                    }
                    // If the line is inside the rectangle, return true
                    // Both the logical AND and OR can be used here, but use OR for short circuiting
                    return ((Rectangle)other).Contains(P1) || ((Rectangle)other).Contains(P2);
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
            // This function will give error if start == end (Division by zero)
            var isPerpendicularLineValid = PerpendicularFootExists(point);
            // If the foot of the perpendicular line is outside the line segment, return the distance to the nearest vertex
            if (!isPerpendicularLineValid)
            {
                var distance1 = FixedVector2.Distance(P1, point);
                var distance2 = FixedVector2.Distance(P2, point);
                if (distance1 < distance2)
                {
                    distance = distance1;
                    return P1;
                }
                distance = distance2;
                return P2;
            }

            var xDiff = P2.x - P1.x;
            var yDiff = P2.y - P1.y;
            var pointXDiff = point.x - P1.x;
            var pointYDiff = point.y - P1.y;

            var ABSQ = xDiff * xDiff + yDiff * yDiff;
            var ABDotAP = pointXDiff * xDiff + pointYDiff * yDiff;
            var t = ABDotAP / ABSQ;
            
            var closestPoint = new FixedVector2(P1.x + t * xDiff, P1.y + t * yDiff);
            distance = FixedVector2.Distance(closestPoint, point);
            return closestPoint;
        }

        public FixedVector2 GetRandomPoint()
        {
            return P1 + (P2 - P1) * StaticRandom.NextFloat();
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            return P1 + (P2 - P1) * rng.RandomFloat();
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
            return BoundingBox.FromMinMax(FixedVector2.Min(P1, P2), FixedVector2.Max(P1, P2));
        }
        
        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            var p1 = GeometricMath.RotateVector2(P1, rotation) + position;
            var p2 = GeometricMath.RotateVector2(P2, rotation) + position;
            
            return new Line(p1, p2);
        }

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            var p1 = GeometricMath.RotateVector2(scale * P1, rotation) + position;
            var p2 = GeometricMath.RotateVector2(scale * P2, rotation) + position;
            
            return new Line(p1, p2);
        }

        public bool PerpendicularFootExists(FixedVector2 point)
        {
            var xDiff = P2.x - P1.x;
            var yDiff = P2.y - P1.y;
            var t = ((point.x - P1.x) * xDiff + (point.y - P1.y) * yDiff) /
                    (xDiff * xDiff +
                     yDiff * yDiff);
            return t >= FixedFloat.Zero && t <= FixedFloat.One;
        }
        
        public override string ToString()
        {
            return $"Line({P1}, {P2})";
        }
        
        // Function to check orientation of ordered triplet (p, q, r).
        // 0 -> p, q and r are collinear
        // 1 -> Clockwise
        // 2 -> Counterclockwise
        private static int Orientation(FixedVector2 p, FixedVector2 q, FixedVector2 r)
        {
            var val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
            if (val <= IGeometry.Epsilon && val >= -IGeometry.Epsilon) return 0; // Collinear
            return (val > 0) ? 1 : 2; // Clock or counterclockwise
        }
        
        private bool OnSegment(FixedVector2 q)
        {
            if (q.x <= FixedFloatMath.Max(P1.x, P2.x) && q.x >= FixedFloatMath.Min(P1.x, P2.x) &&
                q.y <= FixedFloatMath.Max(P1.y, P2.y) && q.y >= FixedFloatMath.Min(P1.y, P2.y))
                return true;

            return false;
        }
        
        public FixedVector2 GetCenter()
        {
            return (P1 + P2) / 2;
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator Line(GeometryMessage.Types.Line l) => new(l.P1, l.P2);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.Line(Line l) => new() { P1 = (Vector2Message)l.P1, P2 = (Vector2Message)l.P2 };
    }
}
