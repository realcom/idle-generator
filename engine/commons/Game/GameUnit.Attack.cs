using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using static Commons.Resources.ResourceSkill.Types.Timeline.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        public struct AddDamageResult
        {
            public static readonly AddDamageResult Ignored = new() { IsIgnored = true };
            public static readonly AddDamageResult Dodged = new() { IsDodged = true };
            
            public bool IsIgnored;
            public bool IsDodged;
            public bool IsCritical;
            
            public long Damage;
            public long ValidDamage;
            public long SpDamage;
            
            public bool IsValid => !IsIgnored && !IsDodged;
        }
        
        public ArmorType ArmorType { get; internal set; }
        private Dictionary<int, DamageType> _damageTypeByItemGroup = new();
        
        private void SetDamageTypeByItemGroup(int itemGroup, DamageType damageType)
        {
            _damageTypeByItemGroup[itemGroup] = damageType;
        }
        
        private void ClearDamageTypeByItemGroup(int itemGroup)
        {
            _damageTypeByItemGroup.Remove(itemGroup);
        }
        
        internal DamageType GetDamageTypeByItemGroup(int itemGroup, DamageType @default)
        {
            return _damageTypeByItemGroup.GetValueOrDefault(itemGroup, @default);
        }

        private long ApplyDamage(long damage, IAttackSource? attackSource = null)
        {
            if (!IsAlive)
                return 0L;
            if (damage <= 0L)
                return 0L;

            if (guard_ > 0L)
            {
                if (guard_ >= damage)
                {
                    AddGuard(-damage);
                    damage = 0L;
                }
                else
                {
                    var absorbedGuard = guard_;
                    SetGuard(0L);
                    damage = LongFixedFloatMath.SubtractSaturated(damage, absorbedGuard);
                }
            }
            
            if (shield_ > 0L)
            {
                if (shield_ >= damage)
                {
                    AddShield(-damage);
                    damage = 0L;
                }
                else
                {
                    var absorbedShield = shield_;
                    SetShield(0L);
                    damage = LongFixedFloatMath.SubtractSaturated(damage, absorbedShield);
                }
            }

            if (damage > 0L)
            {
                noDamageTick_ = 0;
                AddHp(-damage, attackSource);
            }
            
            return damage;
        }
        
        private readonly struct DamageSourceContext
        {
            public readonly GameUnit Attacker;
            public readonly GameSkill? Skill;
            public readonly GameBuff? Buff;

            public DamageSourceContext(GameUnit attacker, GameSkill skill)
            {
                Attacker = attacker;
                Skill = skill;
                Buff = null;
            }

            public DamageSourceContext(GameUnit attacker, GameBuff buff)
            {
                Attacker = attacker;
                Skill = null;
                Buff = buff;
            }

            public int Level => Skill?.Level ?? Buff!.Level;
            public bool IsSkill => Skill != null;
            public IAttackSource AttackSource => Skill != null ? (IAttackSource)Skill : Buff!;

            public bool ContainsTag(Tag tag)
            {
                return Skill != null ? Skill.ResSkill.ContainsTag(tag) : Buff!.ResBuff.ContainsTag(tag);
            }

            public long HandleAttackLong(GameUnit target, long damage, bool isCritical)
            {
                return Skill != null
                    ? Skill.HandleAttackLong(Attacker, target, damage, isCritical)
                    : Buff!.HandleAttackLong(Attacker, target, damage, isCritical);
            }

            public void ApplyTo(UnitAttackedEvent e)
            {
                if (Skill != null)
                    e.SkillDataId = Skill.ResSkill.Id;
                else
                    e.BuffDataId = Buff!.ResBuff.Id;
            }

            public void ApplyTo(PlayFxEvent e)
            {
                if (Skill != null)
                    e.SkillId = Skill.Id;
                else
                    e.BuffId = Buff!.Id;
            }
        }

        internal AddDamageResult AddDamage(GameSkill skill, AddDamage addDamage)
        {
            return TryCreateDamageSource(skill, out var source)
                ? AddDamage(source, addDamage)
                : AddDamageResult.Ignored;
        }

        internal AddDamageResult AddDamage(GameBuff buff, AddDamage addDamage)
        {
            return TryCreateDamageSource(buff, out var source)
                ? AddDamage(source, addDamage)
                : AddDamageResult.Ignored;
        }

        private bool TryCreateDamageSource(GameSkill skill, out DamageSourceContext source)
        {
            source = default;
            if (!IsAlive)
                return false;

            var attacker = skill.Sender;
            if (attacker == null || attacker.IsAlive != true && !skill.ResSkill.ContainsTag(Tag.IgnoreAlive))
                return false;

            source = new DamageSourceContext(attacker, skill);
            return true;
        }

        private bool TryCreateDamageSource(GameBuff buff, out DamageSourceContext source)
        {
            source = default;
            if (!IsAlive)
                return false;
            
            var attacker = Board.GetUnitById(buff.AttackerUnitId);
            if (attacker?.IsAlive != true)
                return false;

            source = new DamageSourceContext(attacker, buff);
            return true;
        }

        private AddDamageResult AddDamage(DamageSourceContext source, AddDamage addDamage)
        {
            var attacker = source.Attacker;
            var addDamageRatio = CalculateAddDamageRatio(source);
            var damage = addDamage.GetDamageLong(attacker, this, source.Level, addDamageRatio);
            var isCritical = false;
            if (source.Skill != null)
                damage = attacker.ApplyCriticalLong(this, damage, source.Skill, out isCritical);
            damage = source.HandleAttackLong(this, damage, isCritical);
            damage = attacker.HandleAttackLong(this, damage, false, skill: source.Skill, buff: source.Buff);
            damage = ApplyArmorLong(attacker, damage, out var damageType, out var armorType, skill: source.Skill, buff: source.Buff);
            damage = ApplyDefenseLong(attacker, damage, skill: source.Skill, buff: source.Buff, isMagic: addDamage.IsMagic);
            damage = ApplyDamageTakenEfficiencyLong(attacker, damage);
            damage = HandleAttackedLong(attacker, damage, isCritical, skill: source.Skill, buff: source.Buff);
            if (damage <= 0L && !source.ContainsTag(Tag.ValidWithoutDamage))
                return AddDamageResult.Ignored;

            var longDamage = damage;
            var validDamage = ApplyDamage(longDamage, source.AttackSource);
            HandleAttackedPostLong(attacker, damage, validDamage, isCritical, skill: source.Skill, buff: source.Buff);
            ApplyDamageSideEffects(addDamage, source, isCritical);
            var spDamage = ApplySpDamage(addDamage, source.Level);
            QueueUnitAttackedEvent(source, longDamage, validDamage, spDamage, isCritical, damageType, armorType);
            QueueHitFx(addDamage, source, isCritical);
            UseOnDamageSkill(addDamage, source);

            return new AddDamageResult { Damage = longDamage, ValidDamage = validDamage, SpDamage = spDamage, IsCritical = isCritical };
        }

        private FixedFloat CalculateAddDamageRatio(DamageSourceContext source)
        {
            var attacker = source.Attacker;
            var addDamageRatio = FixedFloat.One;
            var addDamagePercent = FixedFloat.Zero;

            if (source.Skill != null)
            {
                var skill = source.Skill;
                if (skill.ItemId != 0 &&
                    Board.PlayerActiveInventoryData.TryGetValue(attacker.PlayerId, out var activeInventoryData) &&
                    activeInventoryData.SlotsByItemId.TryGetValue(skill.ItemId, out var slots))
                {
                    foreach (var slot in slots)
                    {
                        addDamagePercent = FixedFloatMath.AddSaturated(
                            addDamagePercent,
                            attacker.SlotStats.GetValueOrDefault(slot)?.DamagePercent ?? FixedFloat.Zero);
                    }
                }

                if (skill.ItemDataId != 0 && ResourceItem.Get(skill.ItemDataId) is { } resItem)
                {
                    addDamagePercent = FixedFloatMath.AddSaturated(
                        addDamagePercent,
                        attacker.ItemGroupStats.GetValueOrDefault(resItem.Group)?.DamagePercent ?? FixedFloat.Zero);
                    addDamageRatio = FixedFloatMath.MultiplySaturated(addDamageRatio, resItem.ConstantDamageRatio);
                }

                addDamagePercent = FixedFloatMath.AddSaturated(
                    addDamagePercent,
                    attacker.SkillGroupStats.GetValueOrDefault(skill.ResSkill.Group)?.DamagePercent ?? FixedFloat.Zero);

                addDamageRatio = FixedFloatMath.MultiplySaturated(addDamageRatio, FixedFloatMath.RatioFromPercentSaturated(addDamagePercent));
            }

            addDamageRatio = FixedFloatMath.MultiplySaturated(addDamageRatio, ResUnit.TypeGroup switch
            {
                ResourceUnit.Types.TypeGroup.BossGroup => attacker.Stat.BossDamageEfficiencyPercent,
                _ => attacker.Stat.MonsterDamageEfficiencyPercent
            });
            
            addDamageRatio = FixedFloatMath.MultiplySaturated(addDamageRatio, attacker.ResUnit.TypeGroup switch
            {
                ResourceUnit.Types.TypeGroup.BossGroup => Stat.BossDamageTakenEfficiencyPercent,
                _ => Stat.MonsterDamageTakenEfficiencyPercent
            });

            return addDamageRatio;
        }

        private void ApplyDamageSideEffects(AddDamage addDamage, DamageSourceContext source, bool isCritical)
        {
            if (addDamage.TryApplyKnockback(this, source.AttackSource) &&
                !string.IsNullOrEmpty(addDamage.FxOnKnockback))
            {
                var fx = new PlayFxEvent
                {
                    UnitId = id_,
                    Position = position_,
                    Prefab = addDamage.FxOnKnockback
                };
                source.ApplyTo(fx);
                Board.QueueEvent(fx);
            }
            if (addDamage.DisableMoveDuration > 0f
                && !ResUnit.ContainsTag(Tag.IgnoreDisableMoveByDamage)
                && !HasBuffByTag(Tag.IgnoreDisableMoveByDamage))
                DisableMove(GameBoard.TimeToTicksDuration(addDamage.DisableMoveDuration));
            if (addDamage.DisableActionDuration > 0f
                && !ResUnit.ContainsTag(Tag.IgnoreDisableActionByDamage)
                && !HasBuffByTag(Tag.IgnoreDisableActionByDamage))
                DisableAction(GameBoard.TimeToTicksDuration(addDamage.DisableActionDuration));
        }

        private long ApplySpDamage(AddDamage addDamage, int sourceLevel)
        {
            var spDamage = addDamage.SpDamages.GetClamped(sourceLevel - 1);
            if (spDamage > 0L)
                AddSp(-spDamage);

            return spDamage;
        }

        private void QueueUnitAttackedEvent(
            DamageSourceContext source,
            long damage,
            long validDamage,
            long spDamage,
            bool isCritical,
            DamageType damageType,
            ArmorType armorType)
        {
            var e = new UnitAttackedEvent
            {
                UnitId = id_,
                Damage = damage,
                ValidDamage = validDamage,
                SpDamage = spDamage,
                IsCritical = isCritical,
                DamageType = damageType,
                ArmorType = armorType,
            };
            source.ApplyTo(e);
            Board.QueueEvent(e);
        }

        private void QueueHitFx(AddDamage addDamage, DamageSourceContext source, bool isCritical)
        {
            if (!string.IsNullOrEmpty(ResUnit.HitFx))
                Board.QueueEvent(new PlayFxEvent
                {
                    UnitId = id_,
                    Position = position_,
                    Prefab = ResUnit.HitFx,
                });

            var fxOnHit = source.IsSkill && isCritical && !string.IsNullOrEmpty(addDamage.FxOnCriticalHit)
                ? addDamage.FxOnCriticalHit
                : addDamage.FxOnHit;
            if (!string.IsNullOrEmpty(fxOnHit))
            {
                var fx = new PlayFxEvent
                {
                    UnitId = id_,
                    Position = position_,
                    Prefab = fxOnHit,
                };
                source.ApplyTo(fx);
                if (source.Skill != null)
                {
                    fx.Speed = source.Skill.TimelineSpeed;
                    fx.IsSpecial = isCritical;
                }
                Board.QueueEvent(fx);
            }
        }

        private void UseOnDamageSkill(AddDamage addDamage, DamageSourceContext source)
        {
            if (addDamage.OnDamageUseSkill != null)
            {
                if (source.Skill != null)
                {
                    source.Attacker.UseSkill(
                        addDamage.OnDamageUseSkill,
                        addDamage.OnDamageUseSkill.AtTarget ? position_ : source.Skill.Position,
                        source.Skill.Direction,
                        itemId: source.Skill.ItemId,
                        itemDataId: source.Skill.ItemDataId,
                        ignoreActable: true);
                }
                else
                    source.Attacker.UseSkill(addDamage.OnDamageUseSkill, position_, direction_, ignoreActable: true);
            }
        }

        private FixedFloat HandleAttack(GameUnit target, FixedFloat damage, bool isCritical, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (_triggerOnAttack != null)
            {
                using var state = CreateState();
                state.slotUnit = target;
                state.SetPredefinedVariable(Board,Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnAttack.Run(Board, state);
                damage = state.GetPredefinedVariable(Board, Return, damage);
            }
            return damage;
        }

        private long HandleAttackLong(GameUnit target, long damage, bool isCritical, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (_triggerOnAttack == null)
                return damage;

            using var state = CreateState();
            state.slotUnit = target;
            state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, LongFixedFloatMath.ToFixedFloatSaturated(damage));
            state.SetPredefinedVariable(Board, IsCritical, isCritical);
            if (skill != null)
                state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
            if (buff != null)
                state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
            _triggerOnAttack.Run(Board, state);
            return state.GetLongPredefinedVariableSaturated(Board, Return, damage);
        }
        
        private FixedFloat ApplyArmor(GameUnit attacker, FixedFloat damage,
            out DamageType damageType, out ArmorType armorType, GameSkill? skill = null, GameBuff? buff = null)
        {
            armorType = attacker.ArmorType;
            if (skill != null)
            {
                if (skill.ResItem != null)
                    damageType = GetDamageTypeByItemGroup(skill.ResItem.Group, skill.ResSkill.DamageType);
                else
                    damageType = skill.ResSkill.DamageType;
            }
            else if (buff != null)
                damageType = buff.ResBuff.DamageType;
            else
            {
                damageType = default;
                return damage;
            }

            switch (damageType)
            {
                case DamageType.NormalDamage:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreNormalDamage) || HasBuffByTag(Tag.IgnoreNormalDamage))
                        return FixedFloat.Zero;
                    break;
                }
                case DamageType.Pierce:
                {
                    if (ResUnit.ContainsTag(Tag.IgnorePierceDamage) || HasBuffByTag(Tag.IgnorePierceDamage))
                        return FixedFloat.Zero;
                    break;
                }
                case DamageType.Explosive:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreExplosiveDamage) || HasBuffByTag(Tag.IgnoreExplosiveDamage))
                        return FixedFloat.Zero;
                    break;
                }
                case DamageType.Spell:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreSpellDamage) || HasBuffByTag(Tag.IgnoreSpellDamage))
                        return FixedFloat.Zero;
                    break;
                }
            }

            damage = FixedFloatMath.MultiplySaturated(damage, ResourceUnit.Global.StatConstants.GetDamageCoefficient(armorType, damageType));
            damage = FixedFloatMath.MultiplySaturated(damage, attacker.DamageTypeDamageRatio.GetValueOrDefault(damageType, FixedFloat.One));
            damage = FixedFloatMath.MultiplySaturated(damage, attacker.ArmorTypeDamageRatio.GetValueOrDefault(armorType, FixedFloat.One));
            damage = FixedFloatMath.MultiplySaturated(damage, DamageTypeGotDamageRatio.GetValueOrDefault(damageType, FixedFloat.One));

            return damage;
        }

        private long ApplyArmorLong(GameUnit attacker, long damage,
            out DamageType damageType, out ArmorType armorType, GameSkill? skill = null, GameBuff? buff = null)
        {
            armorType = attacker.ArmorType;
            if (skill != null)
            {
                if (skill.ResItem != null)
                    damageType = GetDamageTypeByItemGroup(skill.ResItem.Group, skill.ResSkill.DamageType);
                else
                    damageType = skill.ResSkill.DamageType;
            }
            else if (buff != null)
                damageType = buff.ResBuff.DamageType;
            else
            {
                damageType = default;
                return damage;
            }

            switch (damageType)
            {
                case DamageType.NormalDamage:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreNormalDamage) || HasBuffByTag(Tag.IgnoreNormalDamage))
                        return 0L;
                    break;
                }
                case DamageType.Pierce:
                {
                    if (ResUnit.ContainsTag(Tag.IgnorePierceDamage) || HasBuffByTag(Tag.IgnorePierceDamage))
                        return 0L;
                    break;
                }
                case DamageType.Explosive:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreExplosiveDamage) || HasBuffByTag(Tag.IgnoreExplosiveDamage))
                        return 0L;
                    break;
                }
                case DamageType.Spell:
                {
                    if (ResUnit.ContainsTag(Tag.IgnoreSpellDamage) || HasBuffByTag(Tag.IgnoreSpellDamage))
                        return 0L;
                    break;
                }
            }

            damage = LongFixedFloatMath.ScaleSaturated(damage, ResourceUnit.Global.StatConstants.GetDamageCoefficient(armorType, damageType));
            damage = LongFixedFloatMath.ScaleSaturated(damage, attacker.DamageTypeDamageRatio.GetValueOrDefault(damageType, FixedFloat.One));
            damage = LongFixedFloatMath.ScaleSaturated(damage, attacker.ArmorTypeDamageRatio.GetValueOrDefault(armorType, FixedFloat.One));
            damage = LongFixedFloatMath.ScaleSaturated(damage, DamageTypeGotDamageRatio.GetValueOrDefault(damageType, FixedFloat.One));

            return damage;
        }
        
        private FixedFloat ApplyDefense(GameUnit attacker, FixedFloat damage, GameSkill? skill = null, GameBuff? buff = null, bool isMagic = false)
        {
            if (damage <= FixedFloat.Zero)
                return damage;
            
            var defense = isMagic ? MagicResist : Defense;
            var statConstants = ResourceUnit.Global.StatConstants;
            if (statConstants.UsePercentDefense)
            {
                if (defense >= FixedFloat.Zero)
                    damage = FixedFloatMath.MultiplySaturated(damage, FixedFloat.Hundred / FixedFloatMath.AddSaturated(FixedFloat.Hundred, defense));
                else
                {
                    var denominator = defense.Raw < long.MinValue + FixedFloat.Hundred.Raw
                        ? FixedFloat.MaxValue
                        : FixedFloatMath.AddSaturated(FixedFloat.Hundred, -defense);
                    damage = FixedFloatMath.MultiplySaturated(damage, FixedFloat.Two - FixedFloat.Hundred / denominator);
                }
            }
            else
                damage -= defense;
            
            return FixedFloatMath.Max(FixedFloat.One, damage);
        }

        private long ApplyDefenseLong(GameUnit attacker, long damage, GameSkill? skill = null, GameBuff? buff = null, bool isMagic = false)
        {
            if (damage <= 0L)
                return damage;

            var defense = isMagic ? MagicResist : Defense;
            var statConstants = ResourceUnit.Global.StatConstants;
            if (statConstants.UsePercentDefense)
            {
                FixedFloat defenseRatio;
                if (defense >= FixedFloat.Zero)
                {
                    if (defense.Raw > long.MaxValue - FixedFloat.Hundred.Raw)
                        return 1L;
                    defenseRatio = FixedFloat.Hundred / FixedFloat.FromRaw(FixedFloat.Hundred.Raw + defense.Raw);
                }
                else
                {
                    defenseRatio = defense.Raw < long.MinValue + FixedFloat.Hundred.Raw
                        ? FixedFloat.Two
                        : FixedFloat.Two - FixedFloat.Hundred / FixedFloat.FromRaw(FixedFloat.Hundred.Raw - defense.Raw);
                }

                return Math.Max(1L, LongFixedFloatMath.ScaleSaturated(damage, defenseRatio));
            }

            var defenseLong = LongFixedFloatMath.ToLongSaturated(defense);
            return Math.Max(1L, LongFixedFloatMath.SubtractSaturated(damage, defenseLong));
        }

        private FixedFloat ApplyDamageTakenEfficiency(GameUnit attacker, FixedFloat damage)
        {
            damage = FixedFloatMath.MultiplySaturated(damage, FixedFloatMath.Max(0, Stat.DamageTakenEfficiency));
            return damage;
        }

        private long ApplyDamageTakenEfficiencyLong(GameUnit attacker, long damage)
        {
            return LongFixedFloatMath.ScaleSaturated(damage, FixedFloatMath.Max(0, Stat.DamageTakenEfficiency));
        }

        private FixedFloat ApplyCritical(GameUnit target, FixedFloat damage, GameSkill skill, out bool isCritical)
        {
            var criticalPercent = Stat.CriticalPercent;
            var criticalDamagePercent = Stat.CriticalDamagePercent;

            if (skill.ItemDataId != 0)
            {
                var resItem = ResourceItem.Get(skill.ItemDataId)!;
                criticalPercent = FixedFloatMath.AddSaturated(
                    criticalPercent,
                    ItemGroupStats.GetValueOrDefault(resItem.Group)?.CriticalPercent ?? FixedFloat.Zero);
                criticalDamagePercent = FixedFloatMath.AddSaturated(
                    criticalDamagePercent,
                    ItemGroupStats.GetValueOrDefault(resItem.Group)?.CriticalDamagePercent ?? FixedFloat.Zero);
                
                if (
                    Board.PlayerActiveInventoryData.TryGetValue(this.PlayerId, out var activeInventoryData) &&
                    activeInventoryData.SlotsByItemId.TryGetValue(skill.ItemId, out var slots))
                {
                    foreach (var slot in slots)
                    {
                        // addDamagePercent += attacker.SlotStats.GetValueOrDefault(slot)?.DamagePercent ?? FixedFloat.Zero;
                        criticalPercent = FixedFloatMath.AddSaturated(
                            criticalPercent,
                            this.SlotStats.GetValueOrDefault(slot)?.CriticalPercent ?? FixedFloat.Zero);
                        criticalDamagePercent = FixedFloatMath.AddSaturated(
                            criticalDamagePercent,
                            this.SlotStats.GetValueOrDefault(slot)?.CriticalDamagePercent ?? FixedFloat.Zero);
                    }
                }
            }

            var criticalProb = FixedFloatMath.Max(FixedFloat.Zero, criticalPercent / FixedFloat.Hundred);
            var criticalDamageRatio = FixedFloatMath.RatioFromPercentSaturated(criticalDamagePercent);
            
            isCritical = criticalProb > FixedFloat.Zero && Board.RandomFloat() < criticalProb;
            if (!isCritical)
                return damage;
            return FixedFloatMath.MultiplySaturated(criticalDamageRatio, damage);
        }

        private long ApplyCriticalLong(GameUnit target, long damage, GameSkill skill, out bool isCritical)
        {
            var criticalPercent = Stat.CriticalPercent;
            var criticalDamagePercent = Stat.CriticalDamagePercent;

            if (skill.ItemDataId != 0)
            {
                var resItem = ResourceItem.Get(skill.ItemDataId)!;
                criticalPercent = FixedFloatMath.AddSaturated(
                    criticalPercent,
                    ItemGroupStats.GetValueOrDefault(resItem.Group)?.CriticalPercent ?? FixedFloat.Zero);
                criticalDamagePercent = FixedFloatMath.AddSaturated(
                    criticalDamagePercent,
                    ItemGroupStats.GetValueOrDefault(resItem.Group)?.CriticalDamagePercent ?? FixedFloat.Zero);

                if (
                    Board.PlayerActiveInventoryData.TryGetValue(PlayerId, out var activeInventoryData) &&
                    activeInventoryData.SlotsByItemId.TryGetValue(skill.ItemId, out var slots))
                {
                    foreach (var slot in slots)
                    {
                        criticalPercent = FixedFloatMath.AddSaturated(
                            criticalPercent,
                            SlotStats.GetValueOrDefault(slot)?.CriticalPercent ?? FixedFloat.Zero);
                        criticalDamagePercent = FixedFloatMath.AddSaturated(
                            criticalDamagePercent,
                            SlotStats.GetValueOrDefault(slot)?.CriticalDamagePercent ?? FixedFloat.Zero);
                    }
                }
            }

            var criticalProb = FixedFloatMath.Max(FixedFloat.Zero, criticalPercent / FixedFloat.Hundred);
            var criticalDamageRatio = FixedFloatMath.RatioFromPercentSaturated(criticalDamagePercent);

            isCritical = criticalProb > FixedFloat.Zero && Board.RandomFloat() < criticalProb;
            return isCritical ? LongFixedFloatMath.ScaleSaturated(damage, criticalDamageRatio) : damage;
        }

        private FixedFloat HandleAttacked(GameUnit attacker, FixedFloat damage, bool isCritical, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (targetMode_ == ResourceUnit.Types.TargetMode.Avenger)
                Target = attacker;
            
            if (ResUnit.ContainsTag(Tag.Invincible))
                damage = FixedFloat.Zero;
            foreach (var unitBuff in buffs_.Values)
                damage = unitBuff.HandleAttacked(attacker, this, damage, isCritical);
            
            if (_triggerOnAttacked != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board,Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnAttacked.Run(Board, state);
                damage = state.GetPredefinedVariable(Board, Return, damage);
            }
            return damage;
        }

        private long HandleAttackedLong(GameUnit attacker, long damage, bool isCritical, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (targetMode_ == ResourceUnit.Types.TargetMode.Avenger)
                Target = attacker;

            if (ResUnit.ContainsTag(Tag.Invincible))
                damage = 0L;
            foreach (var unitBuff in buffs_.Values)
                damage = unitBuff.HandleAttackedLong(attacker, this, damage, isCritical);

            if (_triggerOnAttacked != null)
            {
                var fixedDamage = LongFixedFloatMath.ToFixedFloatSaturated(damage);
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, fixedDamage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnAttacked.Run(Board, state);
                damage = state.GetLongPredefinedVariableSaturated(Board, Return, damage);
            }

            return damage;
        }

        private void HandleAttackedPost(GameUnit attacker, FixedFloat damage, FixedFloat validDamage, bool isCritical = false, GameSkill? skill = null,
            GameBuff? buff = null)
        {
            foreach (var unitBuff in buffs_.Values)
                unitBuff.HandleAttackedPost(attacker, damage, validDamage, isCritical);
            if (_triggerOnAttackedPost != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board,Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, ValidDamage, validDamage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnAttackedPost.Run(Board, state);
            }
        }

        private void HandleAttackedPostLong(GameUnit attacker, long damage, long validDamage, bool isCritical = false, GameSkill? skill = null,
            GameBuff? buff = null)
        {
            foreach (var unitBuff in buffs_.Values)
                unitBuff.HandleAttackedPostLong(attacker, damage, validDamage, isCritical);
            if (_triggerOnAttackedPost != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, LongFixedFloatMath.ToFixedFloatSaturated(damage));
                state.SetPredefinedVariable(Board, ValidDamage, LongFixedFloatMath.ToFixedFloatSaturated(validDamage));
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnAttackedPost.Run(Board, state);
            }
        }
    }
}
