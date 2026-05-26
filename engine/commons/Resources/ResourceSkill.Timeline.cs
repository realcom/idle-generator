using System.Collections.Generic;
using System.Linq;
using Commons.Types.Geometry;

namespace Commons.Resources
{
    public partial class ResourceSkill
    {
        public partial class Types
        {
            public partial class Timeline
            {
                public partial class Types
                {
                    public partial class Hit
                    {
                        private bool _inited;
                        private List<IGeometry> _geometries;
                        private BoundingBox _boundingBox;
                        
                        private void Init()
                        {
                            if (_inited)
                                return;
                            _inited = true;
                            _geometries = geometries_.Select(g => g.ToGeometry()).ToList();
                            _boundingBox = BoundingBox.Merge(_geometries.Select(g => g.GetBoundingBox()));
                        }
                        
                        public IReadOnlyList<IGeometry> IGeometries
                        {
                            get
                            {
                                Init();
                                return _geometries;
                            }
                        }
                        
                        public ref readonly BoundingBox BoundingBox
                        {
                            get
                            {
                                Init();
                                return ref _boundingBox;
                            }
                        }
                    }
                    
                    public partial class RunTrigger
                    {
                        private ResourceTrigger? _trigger;
                        public ResourceTrigger Trigger
                        {
                            get
                            {
                                _trigger ??= ResourceTrigger.Get(name_)!;
                                return _trigger;
                            }
                        }
                    }
                }
            }
        }
    }
}
