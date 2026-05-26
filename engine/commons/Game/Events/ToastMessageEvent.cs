using Commons.Types;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game.Events
{
    public partial class ToastMessageEvent : BoardEvent
    {
        public override Type EventType => Type.ToastMessage;

        public string ArgumentString;
        public FixedFloat[] ArgumentExpressions;
    }
}