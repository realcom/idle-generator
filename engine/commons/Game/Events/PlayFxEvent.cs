using System.Collections.Generic;
using Commons.Types;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game.Events
{
    public partial class PlayFxEvent : BoardEvent
    {
        public override Type EventType => Type.PlayFx;

        public FixedVector2? Position;
        public long UnitId;
        public long SkillId;
        public long BuffId;
        
        public string? Prefab;
        public float Speed = 1f;

        public bool IsSpecial = false;
        public long Count;
    }
}
