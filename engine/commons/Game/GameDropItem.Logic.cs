using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using RBush;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameDropItem
    {
        public const uint GetItemDelayTicks = 15;
        
        public class DropItemBoundingBoxEnvelope : BoundingBoxEnvelope
        {
            public readonly GameDropItem DropItem;

            public DropItemBoundingBoxEnvelope(GameDropItem dropItem) : base(dropItem.position_.X, dropItem.position_.Y,
                dropItem.position_.X, dropItem.position_.Y)
            {
                DropItem = dropItem;
            }
        }
        
        private bool _inited;
        
        public GameBoard Board { private set; get; }

        public ResourceItem ResItem { private set; get; }
        
        internal DropItemBoundingBoxEnvelope HitBoundingBoxEnvelope { get; private set; }

        public bool Destroyed { private set; get; }
        
        internal GameDropItem Init(GameBoard board)
        {
            if (_inited)
                return this;
            _inited = true;
            Board = board;
            
            ResItem = ResourceItem.Get(itemDataId_)!;

            HitBoundingBoxEnvelope = new DropItemBoundingBoxEnvelope(this);

            return this;
        }

        internal bool GetItem(GameUnit unit, bool force = false)
        {
            if (Destroyed)
                return false;
            if (ttl_ > 0)
                return false;
            if (!force && getItemDelay_ > 0)
                return false;
            
            Expire();
            Board.QueueEvent(new UnitGetDropItemEvent
            {
                UnitId = unit.Id,
                PlayerId = unit.PlayerId,
                DropItemId = id_,
                ItemDataId = ResItem.Id,
                Count = count_,
                Level = level_,
            });

            var player = Board.GetPlayerById(unit.PlayerId);
            player?.AddAcquireItem(unit, ResItem, count_, level_, enableUnitExp: Board.ResMap.EnableUnitExp);

            return true;
        }
        
        internal void Update()
        {
            try
            {
                UpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameDropItem.Update failed: {ex}");
            }
        }

        private void UpdateInternal()
        {
            UpdateDestroy();
            
            if (Destroyed)
                return;
            
            if (getItemDelay_ > 0)
                getItemDelay_ -= 1;
            if (timeToExpiration_ > 0 && --timeToExpiration_ == 0)
                Expire(true);
        }

        private void UpdateDestroy()
        {
            if (ttl_ > 0 && --ttl_ == 0)
                Destroy();
        }

        public void Destroy()
        {
            if (Destroyed)
                return;

            Destroyed = true;
            Board.QueueDestroyDropItem(this);
        }

        public void Expire(bool timeOut = false)
        {
            if (Destroyed)
                return;

            if (ttl_ > 0)
                return;
            
            if (timeOut && isDropAutoGetExpired_)
            {
                var ownerUnit = Board.GetUnitById(ownerUnitId_);
                if (ownerUnit != null)
                {
                    GetItem(ownerUnit, true);
                }
            }

            if (destroyDelay_ > 0)
                ttl_ = destroyDelay_;
            else
                Destroy();
        }
        
    }
}
