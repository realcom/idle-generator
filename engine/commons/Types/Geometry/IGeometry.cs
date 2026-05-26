#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Types.Geometry
{
    public interface IGeometry
    {
        public enum Type
        {
            Line,
            BoundingBox,
            Triangle,
            Circle,
            CircleSector,
            Rectangle,
        }
        
        // epsilon is used to compare floating point numbers
        protected static readonly FixedFloat Epsilon = 1e-5f;

        Type GeometryType { get; }
        
        public bool Contains(FixedVector2 point);
        
        public bool Intersects(in IGeometry other);
        
        public FixedVector2 GetClosestPoint(FixedVector2 point);
        
        public FixedVector2 GetClosestPoint(FixedVector2 point, out FixedFloat distance);

        public FixedVector2 GetRandomPoint();
        
        public FixedVector2 GetRandomPoint(IRng rng);

        public bool IsCloserThan(FixedVector2 point, FixedFloat distance);

        public FixedFloat GetDistance(FixedVector2 point);
        
        public BoundingBox GetBoundingBox();

        public IGeometry Transform(FixedVector2 position, FixedFloat rotation);
        
        public IGeometry Transform(FixedVector2 position, FixedFloat rotation, FixedFloat scale);
    }
}
