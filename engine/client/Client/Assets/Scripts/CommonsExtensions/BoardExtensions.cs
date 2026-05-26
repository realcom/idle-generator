using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Types.Geometry;
using UnityEngine;


namespace Commons.Game
{
    public static class BoardVariableId
    {
        public static class Map
        {
            
            public const int wave = 601;
            public const int displayWinningTeam = 718;
            public static class Wave
            {
                public const int stringId = 602;
                public const int step = 711;
                public const int startTick = 714;
                public const int endTick = 715;
                public const int state = 716;
            
                public static class Step
                {
                    public const int tick = 712;
                }
            }
        }
    }
    
    public partial class GameBoard
    {
        public Vector2 ToSafePosition(FixedVector2 position)
        {
            const float defaultSearchRange = 10f;
            
            var searchRange = defaultSearchRange;
            
            var camera = GameScene.Get().GetCamera();
            if (camera != null)
                searchRange = camera.orthographicSize;
            
            return (Vector2)ResMap.UnitTerrain.GetNearbyPositionOnTerrain(position, DisabledTerrainTriangles, out _, searchRange);
        }
        
    }
}

namespace Commons.Types.Players
{
    public partial class BoardPlayerMessage
    {
        public IEnumerable<PlayerItemMessage> GetFlatInventories()
        {
            var defaultInventory = Inventories.FirstOrDefault();
            if (defaultInventory == null)
                yield break;
            
            foreach (var row in defaultInventory.Rows)
            {
                foreach (var item in row.Items)
                {
                    yield return item;
                }
            }
        }
    }
}