using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace Commons.Game
{
    public partial class GameUnit
    {
        public struct QueuedAddBuff
        {
            public readonly GameUnit? Attacker;
            public readonly int BuffDataId;
            public readonly int Level;
            public float Duration;
            
            public readonly AddBuff? AddBuff;
            
            public QueuedAddBuff(GameUnit? attacker, int buffDataId, int level)
            {
                Attacker = attacker;
                AddBuff = null;
                BuffDataId = buffDataId;
                Duration = 0f;
                Level = level;
            }

            public QueuedAddBuff(GameUnit? attacker, AddBuff addBuff, int level = 1)
            {
                Attacker = attacker;
                AddBuff = addBuff;
                BuffDataId = addBuff.BuffDataId;
                Duration = addBuff.Duration;
                Level = Math.Max(level, addBuff.Level);
            }
        }
        
        private bool _buffsDirty;
        
        private readonly Queue<QueuedAddBuff> _queuedAddBuffs = new();
        
        private readonly Dictionary<int, SortedDictionary<long, GameBuff>> _buffsByDataId = new();
        private readonly Dictionary<int, SortedDictionary<long, GameBuff>> _buffsByGroup = new();
        private readonly List<GameBuff> _destroyedBuffs = new();

        private readonly Dictionary<Tag, int> _buffCountByTag = new();
        private readonly Dictionary<int, SortedDictionary<long, GameBuff>> _replaceItemDamageTypeByGroups = new();

        private void ClearBuffs()
        {
            _buffsByDataId.Clear();
            _buffCountByTag.Clear();
            _replaceItemDamageTypeByGroups.Clear();
        }

        private void InitBuffs()
        {
            ClearBuffs();

            foreach (var buff in buffs_.Values)
            {
                buff.Init(Board, this);
                if (!_buffsByDataId.TryGetValue(buff.DataId, out var buffs))
                    _buffsByDataId[buff.DataId] = buffs = new SortedDictionary<long, GameBuff>();
                buffs[buff.Id] = buff;
                foreach (var tag in buff.ResBuff.Tags)
                    _buffCountByTag[tag] = _buffCountByTag.GetValueOrDefault(tag) + 1;
                for (var i = 0; i < buff.ResBuff.ReplaceSourceSkillDataIds.Count; ++i)
                    AddReplaceSkillDataId(buff.ResBuff.ReplaceSourceSkillDataIds[i], buff.ResBuff.ReplaceTargetSkillDataIds[i]);
                if (buff.ResBuff.ReplaceItemDamageTypeGroup != 0)
                {
                    if (!_replaceItemDamageTypeByGroups.TryGetValue(buff.ResBuff.ReplaceItemDamageTypeGroup, out buffs))
                        _replaceItemDamageTypeByGroups[buff.ResBuff.ReplaceItemDamageTypeGroup] = buffs =
                            new SortedDictionary<long, GameBuff>(Comparer<long>.Create((a, b) => b.CompareTo(a)));
                    buffs[buff.Id] = buff;
                }
                
                if (!_buffsByGroup.TryGetValue(buff.ResBuff.Group, out buffs))
                    _buffsByGroup[buff.ResBuff.Group] = buffs = new SortedDictionary<long, GameBuff>();
                buffs[buff.Id] = buff;
                
                foreach (var initVariable in buff.ResBuff.InitVariables)
                {
                    buff.Variables.Set(initVariable.CallerKey, initVariable.Value);
                }

                foreach (var addVariable in buff.ResBuff.AddVariables)
                {
                    var value = variables_.Get(addVariable.CallerKey);
                    variables_.Set(addVariable.CallerKey, value + addVariable.Value);
                }
            }
            
            foreach (var (itemGroup, buffs) in _replaceItemDamageTypeByGroups)
            {
                if (buffs.Count > 0)
                    SetDamageTypeByItemGroup(itemGroup, buffs.Values.First().ResBuff.ReplaceItemDamageType);
                else
                    ClearDamageTypeByItemGroup(itemGroup);
            }
        }

        internal void QueueAddBuff(QueuedAddBuff addBuff)
        {
            if (addBuff.BuffDataId == 0)
                return;
            
            if (addBuff.AddBuff == null)
            {
                _queuedAddBuffs.Enqueue(addBuff);
                return;
            }
            
            var owner = Owner;
            switch (addBuff.AddBuff.ApplyTarget)
            {
                case Types.Units.AddBuff.Types.ApplyTarget.Self:
                    _queuedAddBuffs.Enqueue(addBuff);
                    break;
                case Types.Units.AddBuff.Types.ApplyTarget.ToOwner:
                    owner?._queuedAddBuffs.Enqueue(addBuff);
                    break;
                case Types.Units.AddBuff.Types.ApplyTarget.WithOwner:
                    _queuedAddBuffs.Enqueue(addBuff);
                    owner?._queuedAddBuffs.Enqueue(addBuff);
                    break;
                case Types.Units.AddBuff.Types.ApplyTarget.WithTeam:
                    foreach (var unit in Board.GetUnitsByTeam(team_))
                    {
                        unit._queuedAddBuffs.Enqueue(addBuff);
                    }
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

        }

        internal void HandleAddBuffs()
        {
            using var appliedBuffs = ConcurrentObjectPool<PooledList<(GameBuff, QueuedAddBuff)>>.StaticPool.Pop();

            while (_queuedAddBuffs.TryDequeue(out var queuedAddBuff))
            {
                var buffDataId = queuedAddBuff.BuffDataId;
                if (buffDataId == 0)
                    continue;
                
                var resBuff = ResourceBuff.Get(buffDataId);
                if (resBuff == null)
                {
                    Config.LogInfo($"invalid buffDataId: {buffDataId}");
                    continue;
                }

                var buffApplicant = queuedAddBuff.Attacker;
                var buff = GetBuffByDataId(buffDataId);
                
                if (!HandleBuffApplyProbability(resBuff, buffApplicant, buff?.Level - 1 ?? 0))
                    continue;
                
                // override buff. If Destroyed, create new buff.
                if (buff?.Destroyed == false)
                {
                    buff.OverrideBuff(queuedAddBuff, buffApplicant);
                    
                    if (buff.ResBuff.HasAddStats())
                        SetStatDirty();
                    
                    QueueAddShield(buff.ResBuff.AddStats.GetStat(UnitStatType.ShieldPercent, buff.Level));

                    foreach (var consecutiveApplyAddBuff in queuedAddBuff.AddBuff?.ConsecutiveApplyAddBuffs ?? Enumerable.Empty<AddBuff>())
                        QueueAddBuff(new QueuedAddBuff(buffApplicant, consecutiveApplyAddBuff));

                    appliedBuffs.Add((buff, queuedAddBuff));
                    continue;
                }

                if (!HandleBuffGroupPolicy(resBuff))
                    continue;
                
                var newBuff = new GameBuff
                {
                    DataId = buffDataId,
                    Team = buffApplicant?.Team ?? 0,
                    AttackerUnitId = buffApplicant?.Id ?? 0L,
                    Level = queuedAddBuff.Level,
                    Stack = resBuff.Stack,
                    Enabled = true,
                };
                AddBuff(newBuff, queuedAddBuff);
                
                foreach (var consecutiveApplyAddBuff in queuedAddBuff.AddBuff?.ConsecutiveApplyAddBuffs ?? Enumerable.Empty<AddBuff>())
                    QueueAddBuff(new QueuedAddBuff(buffApplicant, consecutiveApplyAddBuff));
                
                appliedBuffs.Add((newBuff, queuedAddBuff));
            }

            foreach (var (appliedBuff, addBuffParam) in appliedBuffs)
                HandleBuffApply(addBuffParam.Attacker, appliedBuff);
        }

        private bool HandleBuffApplyProbability(ResourceBuff resBuff, GameUnit? buffApplicant, int buffLevel)
        {
            const int defaultBuffApplyProbabilitiesKey = 0;
            var probability = ResourceBuff.Global.BuffApplyProbabilities.GetValueOrDefault(resBuff.Group) ??
                              ResourceBuff.Global.BuffApplyProbabilities[defaultBuffApplyProbabilitiesKey]!;
            var baseApplyProb = FixedFloatMath.Max(FixedFloat.Zero, probability.Probabilities.GetClamped(buffLevel) / FixedFloat.Hundred);
            //저항력 적용
            var buffApplyResistancePercent = Stat.BuffApplyResistancePercent;
            buffApplyResistancePercent += ResUnit.TypeGroup switch
            {
                ResourceUnit.Types.TypeGroup.BossGroup => BuffGroupStats.GetValueOrDefault(resBuff.Group)?.BossBuffApplyResistancePercent,
                _ => BuffGroupStats.GetValueOrDefault(resBuff.Group)?.BuffApplyResistancePercent
            } ?? FixedFloat.Zero;

            //저항력 감소 적용
            var buffApplyResistanceReducePercent = buffApplicant?.Stat.BuffApplyResistanceReducePercent ?? FixedFloat.Zero;
            buffApplyResistanceReducePercent += ResUnit.TypeGroup switch
            {
                ResourceUnit.Types.TypeGroup.BossGroup => buffApplicant?.BuffGroupStats.GetValueOrDefault(resBuff.Group)?.BossBuffApplyResistanceReducePercent,
                _ => buffApplicant?.BuffGroupStats.GetValueOrDefault(resBuff.Group)?.BuffApplyResistanceReducePercent
            } ?? FixedFloat.Zero;

            buffApplyResistancePercent -= buffApplyResistanceReducePercent;
            baseApplyProb *= FixedFloat.One - FixedFloatMath.Clamp(buffApplyResistancePercent, FixedFloat.Zero, FixedFloat.Hundred) / FixedFloat.Hundred;

            //증폭 적용
            var buffApplyAmplifyPercent = buffApplicant?.Stat.BuffApplyAmplifyPercent ?? FixedFloat.Zero;
            buffApplyAmplifyPercent += buffApplicant?.BuffGroupStats.GetValueOrDefault(resBuff.Group)?.BuffApplyAmplifyPercent ?? FixedFloat.Zero;
            baseApplyProb *= FixedFloat.One + FixedFloatMath.Max(buffApplyAmplifyPercent, -FixedFloat.Hundred) / FixedFloat.Hundred;

            return baseApplyProb > FixedFloat.Zero && Board.RandomFloat() < baseApplyProb;
        }

        private bool HandleBuffGroupPolicy(ResourceBuff resBuff)
        {
            if (resBuff.Group == 0)
                return true;
            
            if (!ResourceBuff.Global.BuffGroupPolicy.TryGetValue(resBuff.Group, out var groupPolicy))
                return true;
            
            switch (groupPolicy)
            {
                case ResourceBuff.Types.Global.Types.BuffGroupPolicy.UseHighestTier:
                {
                    var prevBuffs = GetBuffsByGroup(resBuff.Group);
                    var maxTier = resBuff.GroupTier;
                    foreach (var prevBuff in prevBuffs)
                    {
                        if (prevBuff.ResBuff.GroupTier < maxTier)
                            prevBuff.Destroy();
                        else
                            maxTier = prevBuff.ResBuff.GroupTier;
                    }

                    if (resBuff.GroupTier < maxTier)
                    {
                        Config.LogInfo($"Buff is not applied due to UseHighestTier Rule: Group: {resBuff.Group} maxTier: {maxTier}");
                        return false;
                    }

                    break;
                }
                case ResourceBuff.Types.Global.Types.BuffGroupPolicy.UseLowestTier:
                {
                    var prevBuffs = GetBuffsByGroup(resBuff.Group);
                    var minTier = resBuff.GroupTier;
                    foreach (var prevBuff in prevBuffs)
                    {
                        if (prevBuff.ResBuff.GroupTier > minTier)
                            prevBuff.Destroy();
                        else
                            minTier = prevBuff.ResBuff.GroupTier;
                    }

                    if (resBuff.GroupTier > minTier)
                    {
                        Config.LogInfo($"Buff is not applied due to UseLowestTier Rule: Group: {resBuff.Group} maxTier: {minTier}");
                        return false;
                    }

                    break;
                }
            }

            return true;
        }
        
        private void AddBuff(GameBuff buff, QueuedAddBuff addBuff)
        {
            nextBuffId_++;
            buff.Id = nextBuffId_;
            buff.Init(Board, this);
            buff.ApplyDuration(addBuff);
            
            if (!buff.ResBuff.ContainsTag(Tag.IgnoreAlive) && !IsAlive)
                return;

            _buffsDirty = true;
            buffs_.Add(buff.Id, buff);
            if (!_buffsByDataId.TryGetValue(buff.DataId, out var buffs))
                _buffsByDataId[buff.DataId] = buffs = new SortedDictionary<long, GameBuff>();
            buffs[buff.Id] = buff;
            foreach (var tag in buff.ResBuff.Tags)
                _buffCountByTag[tag] = _buffCountByTag.GetValueOrDefault(tag) + 1;
            for (var i = 0; i < buff.ResBuff.ReplaceSourceSkillDataIds.Count; ++i)
                AddReplaceSkillDataId(buff.ResBuff.ReplaceSourceSkillDataIds[i], buff.ResBuff.ReplaceTargetSkillDataIds[i]);
            if (buff.ResBuff.ReplaceItemDamageTypeGroup != 0)
            {
                if (!_replaceItemDamageTypeByGroups.TryGetValue(buff.ResBuff.ReplaceItemDamageTypeGroup, out buffs))
                    _replaceItemDamageTypeByGroups[buff.ResBuff.ReplaceItemDamageTypeGroup] = buffs =
                        new SortedDictionary<long, GameBuff>(Comparer<long>.Create((a, b) => b.CompareTo(a)));
                buffs[buff.Id] = buff;
                SetDamageTypeByItemGroup(buff.ResBuff.ReplaceItemDamageTypeGroup, buffs.Values.First().ResBuff.ReplaceItemDamageType);
            }
            if (!_buffsByGroup.TryGetValue(buff.ResBuff.Group, out buffs))
                _buffsByGroup[buff.ResBuff.Group] = buffs = new SortedDictionary<long, GameBuff>();
            buffs[buff.Id] = buff;
            
            foreach (var initVariable in buff.ResBuff.InitVariables)
            {
                buff.Variables.Set(initVariable.CallerKey, initVariable.Value);
            }
            
            foreach (var addVariable in buff.ResBuff.AddVariables)
            {
                var value = variables_.Get(addVariable.CallerKey);
                variables_.Set(addVariable.CallerKey, value + addVariable.Value);
            }

            if (buff.ResBuff.HasAddStats())
                SetStatDirty();
            
            QueueAddShield(buff.ResBuff.AddStats.GetStat(UnitStatType.ShieldPercent, buff.Level));
        }
        
        private void HandleBuffApply(GameUnit? buffApplicant, GameBuff appliedBuff)
        {
            if (_triggerOnBuffApply != null)
            {
                using var state = CreateState();
                state.slotUnit = buffApplicant ?? state.slotUnit;
                state.slotBuff = appliedBuff;

                _triggerOnBuffApply.Run(Board, state);    
            }
            
            foreach (var gameBuff in buffs_.Values)
            {
                gameBuff.HandleBuffApply(buffApplicant, appliedBuff);
            }
        }
        
        internal void QueueDestroyBuff(GameBuff buff)
        {
            _destroyedBuffs.Add(buff);
        }

        internal void RemoveDestroyedBuffs()
        {
            if (_destroyedBuffs.Count == 0)
                return;
            
            foreach (var buff in _destroyedBuffs)
            {
                buffs_.Remove(buff.Id);
                _buffsByDataId[buff.DataId].Remove(buff.Id);
                _buffsByGroup[buff.ResBuff.Group].Remove(buff.Id);
                foreach (var tag in buff.ResBuff.Tags)
                    _buffCountByTag[tag] = Math.Max(0, _buffCountByTag.GetValueOrDefault(tag) - 1);
                for (var i = 0; i < buff.ResBuff.ReplaceSourceSkillDataIds.Count; ++i)
                    RemoveReplaceSkillDataId(buff.ResBuff.ReplaceSourceSkillDataIds[i], buff.ResBuff.ReplaceTargetSkillDataIds[i]);
                if (buff.ResBuff.ReplaceItemDamageTypeGroup != 0)
                {
                    var buffs = _replaceItemDamageTypeByGroups[buff.ResBuff.ReplaceItemDamageTypeGroup];
                    buffs.Remove(buff.Id);
                    if (buffs.Count == 0)
                        ClearDamageTypeByItemGroup(buff.ResBuff.ReplaceItemDamageTypeGroup);
                    else
                        SetDamageTypeByItemGroup(buff.ResBuff.ReplaceItemDamageTypeGroup, buffs.Values.First().ResBuff.ReplaceItemDamageType);
                }
                
                foreach (var addVariable in buff.ResBuff.AddVariables)
                {
                    var value = variables_.Get(addVariable.CallerKey);
                    variables_.Set(addVariable.CallerKey, value - addVariable.Value);
                }

                if (buff.ResBuff.HasAddStats())
                    SetStatDirty();
            }
            _destroyedBuffs.Clear();
        }
        
        internal bool FinalizeBuffState()
        {
            if (!_buffsDirty)
                return false;
            _buffsDirty = false;

            var buffStates = StateFlag.Clear;
            foreach (var buff in buffs_.Values)
                buffStates |= buff.ResBuff.AddState;
            
            state_ = (state_ & ~StateFlag.BuffMask) | (buffStates & StateFlag.BuffMask);
            return true;
        }

        public bool RemoveAllBuffs()
        {
            if (buffs_.Count == 0)
                return false;

            foreach (var buff in buffs_.Values)
                if (buff.ResBuff.Type == ResourceBuff.Types.Type.UnitBuff)
                    buff.Destroy();
            return true;
        }

        public bool RemoveAllDebuffs()
        {
            if (buffs_.Count == 0)
                return false;

            foreach (var buff in buffs_.Values)
                if (buff.ResBuff.Type == ResourceBuff.Types.Type.UnitDebuff)
                    buff.Destroy();
            return true;
        }

        public GameBuff? GetBuffById(long id)
        {
            return buffs_.GetValueOrDefault(id);
        }
        
        public GameBuff? GetBuffByDataId(int dataId)
        {
            return _buffsByDataId.GetValueOrDefault(dataId)?.Values.FirstOrDefault();
        }
        
        public IEnumerable<GameBuff> GetBuffsByDataId(int dataId)
        {
            return (IEnumerable<GameBuff>?)_buffsByDataId.GetValueOrDefault(dataId)?.Values ?? Enumerable.Empty<GameBuff>();
        }
        
        public IEnumerable<GameBuff> GetBuffsByGroup(int group)
        {
            return (IEnumerable<GameBuff>?)_buffsByGroup.GetValueOrDefault(group)?.Values ?? Enumerable.Empty<GameBuff>();
        }

        
        public bool HasBuffByDataId(int dataId)
        {
            return _buffsByDataId.TryGetValue(dataId, out var buffs) && buffs.Count > 0;
        }
        
        public bool HasBuffByTag(Tag tag)
        {
            return _buffCountByTag.TryGetValue(tag, out var count) && count > 0;
        }
    }
}
