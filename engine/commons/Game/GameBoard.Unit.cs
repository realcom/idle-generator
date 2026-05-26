using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using RBush;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private readonly List<GameUnit> _addUnits = new();

        private readonly Dictionary<long, SortedDictionary<long, GameUnit>> _unitsByPlayerId = new();
        private readonly Dictionary<int, SortedDictionary<long, GameUnit>> _unitsByDataId = new();
        private readonly Dictionary<int, SortedDictionary<long, GameUnit>> _unitsByTeam = new();
        private readonly List<GameUnit> _destroyedUnits = new();

        private readonly Dictionary<int, int> _unitCountByDataId = new();
        private readonly Dictionary<int, int> _unitCountByOffset = new();
        private readonly Dictionary<int, int> _unitCountByTeam = new();
        private readonly RBush<GameUnit.UnitBoundingBoxEnvelope> _unitRTree = new();

        private void ClearUnits()
        {
            _unitsByPlayerId.Clear();
            _unitsByDataId.Clear();
            _unitsByTeam.Clear();
            _unitCountByDataId.Clear();
            _unitCountByOffset.Clear();
            _unitCountByTeam.Clear();
            _unitRTree.Clear();
        }

        internal void QueueAddUnit(GameUnit unit)
        {
            _addUnits.Add(unit);
            _unitCountByDataId[unit.DataId] = _unitCountByDataId.GetValueOrDefault(unit.DataId) + 1;
            _unitCountByOffset[unit.Offset] = _unitCountByOffset.GetValueOrDefault(unit.Offset) + 1;
            _unitCountByTeam[unit.Team] = _unitCountByTeam.GetValueOrDefault(unit.Team) + 1;
        }

        private void HandleAddUnits()
        {
            if (_addUnits.Count == 0)
                return;

            foreach (var unit in _addUnits)
            {
                DecrementUnitCount(_unitCountByDataId, unit.DataId);
                DecrementUnitCount(_unitCountByOffset, unit.Offset);
                DecrementUnitCount(_unitCountByTeam, unit.Team);
                AddUnit(unit);
            }
            _addUnits.Clear();
        }

        private void InitUnits()
        {
            ClearUnits();

            using var envelopes = ConcurrentObjectPool<PooledList<GameUnit.UnitBoundingBoxEnvelope>>.StaticPool.Pop();
            foreach (var unit in units_.Values)
            {
                unit.Init(this);
                if (unit.PlayerId != 0L)
                {
                    if (!_unitsByPlayerId.TryGetValue(unit.PlayerId, out var units))
                        _unitsByPlayerId[unit.PlayerId] = units = new SortedDictionary<long, GameUnit>();
                    units[unit.Id] = unit;
                    
                    InitAllPlayerUnitItemVariables(unit);
                }
                if (!_unitsByDataId.TryGetValue(unit.DataId, out var unitsByDataId))
                    _unitsByDataId[unit.DataId] = unitsByDataId = new SortedDictionary<long, GameUnit>();
                unitsByDataId[unit.Id] = unit;
                if (!_unitsByTeam.TryGetValue(unit.Team, out var unitsByTeam))
                    _unitsByTeam[unit.Team] = unitsByTeam = new SortedDictionary<long, GameUnit>();
                unitsByTeam[unit.Id] = unit;
                _unitCountByDataId[unit.DataId] = _unitCountByDataId.GetValueOrDefault(unit.DataId) + 1;
                _unitCountByOffset[unit.Offset] = _unitCountByOffset.GetValueOrDefault(unit.Offset) + 1;
                _unitCountByTeam[unit.Team] = _unitCountByTeam.GetValueOrDefault(unit.Team) + 1;
                
                envelopes.Add(unit.HitBoundingBoxEnvelope);
            }
            
            _unitRTree.BulkLoad(envelopes);
        }

        public void AddUnit(GameUnit unit, GameUnit? owner = null)
        {
            nextUnitId_++;
            unit.Id = nextUnitId_;
            unit.State |= GameUnit.StateFlag.Alive;
            unit.Init(this, owner);

            units_.Add(unit.Id, unit);
            if (!_unitsByDataId.TryGetValue(unit.DataId, out var unitsByDataId))
                _unitsByDataId[unit.DataId] = unitsByDataId = new SortedDictionary<long, GameUnit>();
            unitsByDataId[unit.Id] = unit;
            if (!_unitsByTeam.TryGetValue(unit.Team, out var unitsByTeam))
                _unitsByTeam[unit.Team] = unitsByTeam = new SortedDictionary<long, GameUnit>();
            unitsByTeam[unit.Id] = unit;
            _unitCountByDataId[unit.DataId] = _unitCountByDataId.GetValueOrDefault(unit.DataId) + 1;
            _unitCountByOffset[unit.Offset] = _unitCountByOffset.GetValueOrDefault(unit.Offset) + 1;
            _unitCountByTeam[unit.Team] = _unitCountByTeam.GetValueOrDefault(unit.Team) + 1;
            _unitRTree.Insert(unit.HitBoundingBoxEnvelope);
            
            if (unit.PlayerId != 0L)
            {
                if (!_unitsByPlayerId.TryGetValue(unit.PlayerId, out var units))
                    _unitsByPlayerId[unit.PlayerId] = units = new SortedDictionary<long, GameUnit>();
                units[unit.Id] = unit;
                
                InitAllPlayerUnitItemVariables(unit);

                foreach (var addBuff in ResMap.PlayerEntryAddBuffs)
                    unit.QueueAddBuff(new GameUnit.QueuedAddBuff(null, addBuff));
            }

            var avatar = unit.PlayerAvatar;
            if (avatar != null)
            {
                for (var i = 0; i < avatar.Pets.Count; i++)
                {
                    var pet = avatar.Pets[i];
                    if (pet == null || pet.ItemDataId == 0)
                        continue;
                    
                    var resPetItem = ResourceItem.Get(pet.ItemDataId)!;
                    var petUnit = new GameUnit()
                    {
                        DataId = resPetItem.UnitDataId,
                        Level = pet.Level,
                        Position = unit.InitPosition.Clone(),
                        Direction = (Vector2Message)FixedVector2.right,
                        Velocity = new Vector2Message(),
                        PositionOffset = ResourceMap.Global.PetSpawnOffsets.GetClamped(i),
                        Team = unit.Team,
                    };
                    
                    petUnit.EquipSkillDataIds.Clear();
                    //Add auto using pet skills
                    petUnit.EquipSkillDataIds.Add(resPetItem.EquipSkillDataIds.GetClamped(pet.Level - 1));
                    
                    AddUnit(petUnit, unit);
                }
            }
        }
        
        internal void QueueDestroyUnit(GameUnit unit)
        {
            _destroyedUnits.Add(unit);
        }

        private bool RemoveDestroyedUnits()
        {
            if (_destroyedUnits.Count == 0)
                return false;
            
            foreach (var unit in _destroyedUnits)
            {
                units_.Remove(unit.Id);
                if (unit.PlayerId != 0L)
                    _unitsByPlayerId[unit.PlayerId].Remove(unit.Id);
                _unitsByDataId[unit.DataId].Remove(unit.Id);
                _unitsByTeam[unit.Team].Remove(unit.Id);
                DecrementUnitCount(_unitCountByDataId, unit.DataId);
                DecrementUnitCount(_unitCountByOffset, unit.Offset);
                DecrementUnitCount(_unitCountByTeam, unit.Team);
            }
            _destroyedUnits.Clear();

            return true;
        }

        private static void DecrementUnitCount(Dictionary<int, int> counts, int key)
        {
            if (!counts.TryGetValue(key, out var count))
                return;

            counts[key] = Math.Max(0, count - 1);
        }

        public GameUnit? GetUnitById(long id)
        {
            return units_.GetValueOrDefault(id);
        }
        
        public GameUnit? GetUnitByPlayerId(long playerId)
        {
            return _unitsByPlayerId.GetValueOrDefault(playerId)?.Values.FirstOrDefault();
        }
        
        public IEnumerable<GameUnit> GetUnitsByPlayerId(long playerId)
        {
            return _unitsByPlayerId.GetValueOrDefault(playerId)?.Values ?? Enumerable.Empty<GameUnit>();
        }
        
        public GameUnit? GetUnitByDataId(int dataId)
        {
            return _unitsByDataId.GetValueOrDefault(dataId)?.Values.FirstOrDefault();
        }
        
        public IEnumerable<GameUnit> GetUnitsByDataId(int dataId)
        {
            return _unitsByDataId.GetValueOrDefault(dataId)?.Values ?? Enumerable.Empty<GameUnit>();
        }
        
        public GameUnit? GetUnitByTeam(int team)
        {
            return _unitsByTeam.GetValueOrDefault(team)?.Values.FirstOrDefault();
        }
        
        public IEnumerable<GameUnit> GetUnitsByTeam(int team)
        {
            return _unitsByTeam.GetValueOrDefault(team)?.Values ?? Enumerable.Empty<GameUnit>();
        }
        
        public int GetUnitCountByDataId(int dataId)
        {
            return _unitCountByDataId.GetValueOrDefault(dataId);
        }
        
        public int GetUnitCountByOffset(int offset)
        {
            return _unitCountByOffset.GetValueOrDefault(offset);
        }
        
        public int GetUnitCountByTeam(int team)
        {
            return _unitCountByTeam.GetValueOrDefault(team);
        }
        
        public PooledList<GameUnit.UnitBoundingBoxEnvelope> GetUnitsInBound(in BoundingBox bound)
        {
            return _unitRTree.SearchNonAlloc(new Envelope((float)bound.Min.x, (float)bound.Min.y, (float)bound.Max.x, (float)bound.Max.y));
        }
        
        public PooledList<GameUnit.UnitBoundingBoxEnvelope> GetUnitsInBound(in Envelope envelope)
        {
            return _unitRTree.SearchNonAlloc(envelope);
        }
    }
}
