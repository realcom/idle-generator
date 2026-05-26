using System;
using System.Runtime.CompilerServices;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public readonly struct CircleSector : IGeometry
    {
        public IGeometry.Type GeometryType => IGeometry.Type.CircleSector;
        
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedVector2 Center;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat Radius;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat Angle;
#if UNITY_5_3_OR_NEWER
        [field: SerializeReference]
#endif
        public readonly FixedFloat AngleOffset;

        public FixedFloat MinAngle => AngleOffset - Angle;
        public FixedFloat MaxAngle => AngleOffset + Angle;
        
        public CircleSector(FixedVector2 center, FixedFloat radius, FixedFloat angle, FixedFloat angleOffset)
        {
            Center = center;
            Radius = radius;
            Angle = angle;
            AngleOffset = angleOffset;
        }

        public bool Contains(FixedVector2 point)
        {
            var angle = GeometricMath.NormalizeAngle(FixedFloatMath.Atan2(point.y - Center.y, point.x - Center.x));
            var r = FixedFloatMath.Sqrt((point.x - Center.x) * (point.x - Center.x) + (point.y - Center.y) * (point.y - Center.y));

            return r <= Radius && ContainsAngle(angle);
        }

        public bool ContainsAngle(FixedFloat radians)
        {
            var minAngle = GeometricMath.NormalizeAngle(MinAngle);
            var maxAngle = GeometricMath.NormalizeAngle(MaxAngle);
            return GeometricMath.ContainsAngle(minAngle, maxAngle, radians);
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
            var randomRadius = StaticRandom.NextFloat() * Radius;
            var randomAngle = StaticRandom.NextFloat() * Angle * 2 - Angle + AngleOffset;
            return Center + randomRadius * GeometricMath.AngleToUnitVector2(randomAngle);
        }

        public FixedVector2 GetRandomPoint(IRng rng)
        {
            var randomRadius = rng.RandomFloat() * Radius;
            var randomAngle = rng.RandomFloat() * Angle * 2 - Angle + AngleOffset;
            return Center + randomRadius * GeometricMath.AngleToUnitVector2(randomAngle);
        }

        public bool IsCloserThan(FixedVector2 point, FixedFloat distance)
        {
            throw new NotImplementedException();
        }

        public FixedFloat GetDistance(FixedVector2 point)
        {
            throw new NotImplementedException();
        }

        // Get approximate bounding box
        public BoundingBox GetBoundingBox()
        {
            return new BoundingBox(Center, new FixedVector2(Radius, Radius));
        }
        
        public IGeometry Transform(FixedVector2 position, FixedFloat rotation)
        {
            var center = GeometricMath.RotateVector2(Center, rotation) + position;
            var angleOffset = AngleOffset + rotation;
            return new CircleSector(center, Radius, Angle, angleOffset);
        }
        
        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale)
        {
            var center = GeometricMath.RotateVector2(scale * Center, rotation) + position;
            var radius = scale * Radius;
            var angleOffset = AngleOffset + rotation;
            return new CircleSector(center, radius, Angle, angleOffset);
        }

        public override string ToString()
        {
            return $"CircleSector({Center}, {Radius}, {Angle}, {AngleOffset})";
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator CircleSector(GeometryMessage.Types.CircleSector c) => new(c.Center, c.Radius, c.Angle, c.AngleOffset);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator GeometryMessage.Types.CircleSector(CircleSector c) => new() { Center = (Vector2Message)c.Center, Radius = (float)c.Radius, Angle = (float)c.Angle, AngleOffset = (float)c.AngleOffset };

        public FixedVector2 ArcStartPoint()
        {
            return Center + Radius * GeometricMath.AngleToUnitVector2(MinAngle);
        }

        public FixedVector2 ArcEndPoint()
        {
            return Center + Radius * GeometricMath.AngleToUnitVector2(MaxAngle);
        }
    }
}
