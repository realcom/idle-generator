using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using RBush;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameBoard
    {
        // only callable when the board is single map type.
        public BoardPlayerMessage? GetMainPlayer()
        {
            var player = Players.Values.FirstOrDefault();
            if (player == null)
                Config.LogInfo($"GetMainPlayer: player is null");
            
            return player;
        }
        
        public GameUnit? GetMainPlayerUnit()
        {
            var player = GetMainPlayer();
            return player != null ? GetUnitByPlayerId(player.Id) : _unitsByPlayerId.Values.FirstOrDefault()?.FirstOrDefault().Value;
        }
    }
}
