using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Commons.Game
{
    public partial class GameUnit
    {
        public long GetId()
        {
            return PlayerAvatar?.Character?.Id ?? Id;
        }
    }    
}
