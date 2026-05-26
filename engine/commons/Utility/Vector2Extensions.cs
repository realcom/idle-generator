using Commons.Types;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Utility
{
    public static class Vector2Extensions
    {
        public static FixedFloat GetAngle(this FixedVector2 v)
        {
            return FixedFloatMath.Atan2(v.y, v.x);
        }
        
        public static FixedVector2 Rotate(this FixedVector2 v, FixedFloat radians)
        {
            var cos = FixedFloatMath.Cos(radians);
            var sin = FixedFloatMath.Sin(radians);
            return new FixedVector2(v.x * cos - v.y * sin, v.x * sin + v.y * cos);
        }
        
        public static FixedVector2 Rotate(this FixedVector2 v, FixedVector2 direction)
        {
            var radians = FixedFloatMath.Atan2(direction.y, direction.x);
            return v.Rotate(radians);
        }
        
        public static FixedFloat Cross(this FixedVector2 v, FixedVector2 other)
        {
            return v.x * other.y - v.y * other.x;
        }
        
        public static bool IsCloserThan(this FixedVector2 v1, FixedVector2 v2, FixedFloat distance)
        {
            var dx = v1.x - v2.x;
            if (dx < -distance || dx > distance)
                return false;
            var dy = v1.y - v2.y;
            if (dy < -distance || dy > distance)
                return false;
            return dx * dx + dy * dy < distance * distance;
        }
    }
}
