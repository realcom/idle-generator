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
        private readonly List<GameDropItem> _addDropItems = new();

        private readonly List<GameDropItem> _destroyedDropItems = new();
        
        private readonly RBush<GameDropItem.DropItemBoundingBoxEnvelope> _dropItemRTree = new();

        private void ClearDropItems()
        {
            _dropItemRTree.Clear();
        }

        private void InitDropItems()
        {
            ClearDropItems();

            using var envelopes = ConcurrentObjectPool<PooledList<GameDropItem.DropItemBoundingBoxEnvelope>>.StaticPool.Pop();
            foreach (var dropItem in dropItems_.Values)
            {
                dropItem.Init(this);
                envelopes.Add(dropItem.HitBoundingBoxEnvelope);
            }
            _dropItemRTree.BulkLoad(envelopes);
        }

        internal void QueueAddDropItem(GameDropItem dropItem)
        {
            _addDropItems.Add(dropItem);
        }

        internal void QueueAddDropItem(AddItem addItem, FixedVector2 position, FixedFloat distance = default,
            GameUnit? dropUnit = null, GameUnit? ownerUnit = null)
        {
            var resItem = addItem.GetData();
            var count = addItem.GetCount(this);
            
            if (distance != default)
            {
                var theta = FixedFloatMath.TwoPi * RandomFloat();
                distance *= RandomFloat();
                position += distance * new FixedVector2(FixedFloatMath.Cos(theta), FixedFloatMath.Sin(theta));
            }
            
            var dropUnitId = dropUnit?.Id ?? 0L;
            ownerUnit = resItem.IsDropPublic ? null : ownerUnit;
            var ownerUnitId = ownerUnit?.Id ?? 0L;
            
            var prefabId = addItem.DropPrefabId == 0 ? -1 : addItem.DropPrefabId;
            var timeToExpiration = TimeToTicksDuration(FixedFloatMath.Max(addItem.DropTimeToExpiration, resItem.DropTtl));
            var destroyDelay = TimeToTicksDuration(FixedFloatMath.Max(addItem.DropDestroyDelay, FixedFloat.Zero));
            var isDropAutoGetExpired = addItem.IsDropAutoGetExpired | resItem.IsDropAutoGetExpired;
            
            if (resItem.Unstackable)
            {
                for (var i = 0; i < count; ++i)
                {
                    QueueAddDropItem(new GameDropItem
                    {
                        ItemDataId = resItem.Id,
                        Count = 1,
                        Level = addItem.GetLevel(this),
                        Position = (Vector2Message)position,
                        DropUnitId = dropUnitId,
                        OwnerUnitId = ownerUnitId,
                        PrefabId = prefabId,
                        TimeToExpiration = timeToExpiration,
                        DestroyDelay = destroyDelay,
                        GetItemDelay = 0,
                        IsDropAutoGetExpired = isDropAutoGetExpired
                    });
                }
            }
            else
            {
                QueueAddDropItem(new GameDropItem
                {
                    ItemDataId = resItem.Id,
                    Count = count,
                    Level = addItem.GetLevel(this),
                    Position = (Vector2Message)position,
                    DropUnitId = dropUnitId,
                    OwnerUnitId = ownerUnitId,
                    PrefabId = prefabId,
                    TimeToExpiration = timeToExpiration,
                    DestroyDelay = destroyDelay,
                    GetItemDelay = 0,
                    IsDropAutoGetExpired = isDropAutoGetExpired
                });
            }
        }

        private void HandleAddDropItems()
        {
            if (_addDropItems.Count == 0)
                return;
            
            foreach (var dropItem in _addDropItems)
                AddDropItem(dropItem);
            _addDropItems.Clear();
        }

        private void AddDropItem(GameDropItem dropItem)
        {
            nextDropItemId_++;
            dropItem.Id = nextDropItemId_;
            dropItem.Init(this);

            dropItems_.Add(dropItem.Id, dropItem);
            _dropItemRTree.Insert(dropItem.HitBoundingBoxEnvelope);
        }
        
        internal void QueueDestroyDropItem(GameDropItem dropItem)
        {
            _destroyedDropItems.Add(dropItem);
        }

        private void RemoveDestroyedDropItems()
        {
            if (_destroyedDropItems.Count == 0)
                return;
            
            foreach (var dropItem in _destroyedDropItems)
            {
                dropItems_.Remove(dropItem.Id);
            }
            
            using var envelopes = ConcurrentObjectPool<PooledList<GameDropItem.DropItemBoundingBoxEnvelope>>.StaticPool.Pop();
            foreach (var dropItem in dropItems_.Values)
            {
                envelopes.Add(dropItem.HitBoundingBoxEnvelope);
            }
            
            _destroyedDropItems.Clear();
            
            _dropItemRTree.Clear();
            _dropItemRTree.BulkLoad(envelopes);
        }

        public GameDropItem? GetDropItemById(long id)
        {
            return dropItems_.GetValueOrDefault(id);
        }
        
        public PooledList<GameDropItem.DropItemBoundingBoxEnvelope> GetDropItemsInBound(in Envelope envelope)
        {
            return _dropItemRTree.SearchNonAlloc(envelope);
        }
    }
}
