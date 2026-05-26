#if UNITY_5_3_OR_NEWER
using System.Linq;
using UnityEngine;

namespace Commons.Types
{
    public partial class Curve
    {
        public static implicit operator AnimationCurve(Curve c) => new(c.keys_.Select(k =>
            new Keyframe(k.Time, k.Value, k.InTangent, k.OutTangent, k.InWeight, k.OutWeight)
            {
                weightedMode = (WeightedMode)k.WeightedMode,
            }).ToArray());

        public static implicit operator Curve(AnimationCurve c)
        {
            var curve = new Curve();
            curve.keys_.AddRange(c.keys.Select(k => new Types.Keyframe
            {
                Time = k.time,
                Value = k.value,
                InTangent = k.inTangent,
                OutTangent = k.outTangent,
                InWeight = k.inWeight,
                OutWeight = k.outWeight,
                WeightedMode = (int)k.weightedMode,
            }));
            return curve;
        }
    }
}
#endif
