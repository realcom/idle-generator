using RBush;

namespace Commons.Types.Geometry
{
    public class BoundingBoxEnvelope : ISpatialData
    {
        private Envelope _envelope;
        
        public ref readonly Envelope Envelope => ref _envelope;
        
        public BoundingBoxEnvelope(BoundingBox box)
        {
            _envelope = new Envelope((float)box.Min.x, (float)box.Min.y, (float)box.Max.x, (float)box.Max.y);
        }

        public BoundingBoxEnvelope(float minX, float minY, float maxX, float maxY)
        {
            _envelope = new Envelope(minX, minY, maxX, maxY);
        }
        
        public static implicit operator BoundingBoxEnvelope(BoundingBox box) => new(box);
        
        public void Set(in BoundingBox box)
        {
            _envelope = new Envelope((float)box.Min.x, (float)box.Min.y, (float)box.Max.x, (float)box.Max.y);
        }
    }
}
