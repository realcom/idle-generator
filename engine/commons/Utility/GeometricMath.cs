using Commons.Types;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Utility
{
    public static class GeometricMath
    {
        public static FixedFloat NormalizeAngle(FixedFloat radians) => (radians + FixedFloat.Two * FixedFloatMath.Pi) % (FixedFloat.Two * FixedFloatMath.Pi);

        public static bool ContainsAngle(FixedFloat minRadians, FixedFloat maxRadians, FixedFloat radians)
        {
            if (minRadians < maxRadians)
                return NormalizeAngle(radians) >= minRadians && NormalizeAngle(radians) <= maxRadians;
            return NormalizeAngle(radians) >= minRadians || NormalizeAngle(radians) <= maxRadians;
        }
        
        public static FixedVector2 AngleToUnitVector2(FixedFloat radians)
        {
            return new FixedVector2(FixedFloatMath.Cos(radians), FixedFloatMath.Sin(radians));
        }
        
        public static FixedVector2 RotateVector2(FixedVector2 vector, FixedFloat radians)
        {
            var cos = FixedFloatMath.Cos(radians);
            var sin = FixedFloatMath.Sin(radians);
            return new FixedVector2(vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos);
        }
    }
}
