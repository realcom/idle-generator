using System.Collections.Generic;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using Google.Protobuf.Collections;
using RBush;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        private void GetDropItems()
        {
            var hitSize = ResUnit.HitDropItemSize;
            if (hitSize <= 0f)
                return;

            using var envelopes = Board.GetDropItemsInBound(new Envelope(position_.X - hitSize,
                position_.Y - hitSize, position_.X + hitSize, position_.Y + hitSize));
            foreach (var envelope in envelopes)
            {
                var dropItem = envelope.DropItem;
                dropItem.GetItem(this);
            }
        }

        private void AddDeadDropItems(GameUnit? attacker = null)
        {
            AddItems(ResUnit.DropAddItemGroups, attacker);
        }
    }
}
