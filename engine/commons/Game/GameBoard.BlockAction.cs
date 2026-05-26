using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using RBush;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameBoard
    {
        /// <summary>
        /// Returns true if the given action flag is currently blocked.
        /// </summary>
        public bool HasBlockedAction(Types.BlockActionFlag flag)
        {
            return (ActionBlockFlags & (ulong)flag) != 0;
        }

        /// <summary>
        /// Adds (sets) the given action flag to the block mask.
        /// </summary>
        public void BlockAction(Types.BlockActionFlag flag)
        {
            ActionBlockFlags |= (ulong)flag;
        }

        /// <summary>
        /// Removes (clears) the given action flag from the block mask.
        /// </summary>
        public void UnblockAction(Types.BlockActionFlag flag)
        {
            ActionBlockFlags &= ~(ulong)flag;
        }

        /// <summary>
        /// Clears all blocked action flags.
        /// </summary>
        public void ClearAllBlockedActions()
        {
            ActionBlockFlags = 0ul;
        }

        /// <summary>
        /// Returns all currently blocked actions as an enumerable of flags.
        /// </summary>
        public IEnumerable<Types.BlockActionFlag> GetBlockedActions()
        {
            foreach (Types.BlockActionFlag flag in Enum.GetValues(typeof(Types.BlockActionFlag)))
            {
                if (flag == Types.BlockActionFlag.None)
                    continue;
                if (HasBlockedAction(flag))
                    yield return flag;
            }
        }

    }
}
