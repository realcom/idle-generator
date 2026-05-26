#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public static class Vector2MessageExtensions
    {
        public static void Set(this Vector2Message v, FixedVector2 value)
        {
            v.X = (float)value.x;
            v.Y = (float)value.y;
        }
        
        public static void Set(this Vector2Message v, Vector2Message value)
        {
            v.X = value.X;
            v.Y = value.Y;
        }
        
#if UNITY_5_3_OR_NEWER
        public static void Set(this Vector2Message v, Vector2 value)
        {
            v.X = value.x;
            v.Y = value.y;
        }
#endif
    }
}