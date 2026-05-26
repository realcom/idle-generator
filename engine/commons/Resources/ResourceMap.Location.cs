using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using static Commons.Resources.ResourceMap.Types;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceMap
    {
        public partial class Types
        {
            public partial class Location
            {
                private bool _inited;
                private List<IGeometry> _geometries;
                        
                private void Init()
                {
                    if (_inited)
                        return;
                    _inited = true;
                    _geometries = geometries_.Select(g => g.ToGeometry().Transform(position_, FixedFloat.Zero)).ToList();
                }
                        
                public IReadOnlyList<IGeometry> IGeometries
                {
                    get
                    {
                        Init();
                        return _geometries;
                    }
                }
                
                public FixedVector2 GetRandomPoint(GameBoard board)
                {
                    return IGeometries.PickOne(board)!.GetRandomPoint(board);
                }

                public bool Contains(FixedVector2 point)
                {
                    return IGeometries.Any(g => g.Contains(point));
                }
            }
        }
        
        private Dictionary<int, List<Location>>? _locationsById;

        private ResourceMap InitLocation()
        {
            _locationsById = locations_.GroupBy(l => l.Id).ToDictionary(g => g.Key, g => g.ToList());
            return this;
        }
        
        public bool HasLocationById(int locationId)
        {
            return _locationsById!.ContainsKey(locationId);
        }

        public Location? GetLocationById(int locationId, IRng rng)
        {
            var locations = _locationsById!.GetValueOrDefault(locationId);
            return locations?.PickOne(rng);
        }

        public IEnumerable<Location> GetLocationsById(int locationId, int cnt, IRng rng)
        {
            var locations = _locationsById!.GetValueOrDefault(locationId);
            return locations?.PickMany(cnt, rng) ?? Enumerable.Empty<Location>();
        }

        public IEnumerable<Location> GetBalancedLocationsById(int locationId, int cnt, IRng rng)
        {
            var locations = _locationsById!.GetValueOrDefault(locationId);
            return locations?.PickManyBalanced(cnt, rng) ?? Enumerable.Empty<Location>();
        }
    }
}