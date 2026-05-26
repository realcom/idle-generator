#if UNITY_5_3_OR_NEWER
using System.Runtime.CompilerServices;
using UnityEngine;

namespace Commons.Types.Geometry
{
    public partial class Vector2Message
    {
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static implicit operator Vector2(Vector2Message v) => new Vector2(v.X, v.Y);
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static explicit operator Vector2Message(Vector2 v) => new Vector2Message { X = v.x, Y = v.y };
    }
}
#endif
