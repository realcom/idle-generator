using Commons.Game.Events;
using Commons.Game.Interfaces;
using Commons.Resources;
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
        public struct AddHealResult
        {
            public static readonly AddHealResult Ignored = new() { IsIgnored = true };
            
            public bool IsIgnored;
            
            public long Heal;
            public long ValidHeal;
            public long SpHeal;
            public long GuardHeal;
            public long ShieldHeal;
            
            public bool IsValid => !IsIgnored;
        }
        
        private long ApplyHeal(long heal, IAttackSource? source = null)
        {
            if (!IsAlive)
                return 0L;
            
            var prevHp = hp_;
            AddHp(heal, source);
            return hp_ - prevHp;
        }

        private readonly struct HealSourceContext
        {
            public readonly GameUnit Healer;
            public readonly GameSkill? Skill;
            public readonly GameBuff? Buff;

            public HealSourceContext(GameUnit healer, GameSkill skill)
            {
                Healer = healer;
                Skill = skill;
                Buff = null;
            }

            public HealSourceContext(GameUnit healer, GameBuff buff)
            {
                Healer = healer;
                Skill = null;
                Buff = buff;
            }

            public int Level => Skill?.Level ?? Buff!.Level;
            public IAttackSource AttackSource => Skill != null ? (IAttackSource)Skill : Buff!;

            public long GetHeal(GameUnit target, AddHeal addHeal)
            {
                return Skill != null
                    ? Skill.HandleHeal(Healer, target, addHeal)
                    : Buff!.HandleHeal(Healer, target, addHeal);
            }

            public void ApplyTo(UnitHealedEvent e)
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
        
        internal AddHealResult AddHeal(GameSkill skill, AddHeal addHeal)
        {
            return TryCreateHealSource(skill, out var source)
                ? AddHeal(source, addHeal)
                : AddHealResult.Ignored;
        }
        
        internal AddHealResult AddHeal(GameBuff buff, AddHeal addHeal)
        {
            return TryCreateHealSource(buff, out var source)
                ? AddHeal(source, addHeal)
                : AddHealResult.Ignored;
        }

        private bool TryCreateHealSource(GameSkill skill, out HealSourceContext source)
        {
            source = default;
            if (!IsAlive)
                return false;

            var healer = skill.Sender;
            if (healer == null || !healer.IsAlive && !skill.ResSkill.ContainsTag(Tag.IgnoreAlive))
                return false;

            source = new HealSourceContext(healer, skill);
            return true;
        }

        private bool TryCreateHealSource(GameBuff buff, out HealSourceContext source)
        {
            source = default;
            if (!IsAlive)
                return false;

            var healer = buff.Attacker;
            if (healer == null || !healer.IsAlive)
                return false;

            source = new HealSourceContext(healer, buff);
            return true;
        }

        private AddHealResult AddHeal(HealSourceContext source, AddHeal addHeal)
        {
            var healer = source.Healer;
            var heal = source.GetHeal(this, addHeal);
            heal = LongFixedFloatMath.ScaleSaturated(heal, healer.Stat.HealEfficiencyPercent);
            heal = healer.HandleHeal(this, heal, skill: source.Skill, buff: source.Buff);
            heal = HandleHealed(healer, heal, skill: source.Skill, buff: source.Buff);
            if (heal <= 0L)
                return AddHealResult.Ignored;

            var validHeal = ApplyHeal(heal, source.AttackSource);
            var spHeal = ApplySpHeal(addHeal, source.Level);
            var guardHeal = ApplyGuardHeal(addHeal, source.Level);
            var shieldHeal = ApplyShieldHeal(addHeal, source);
            QueueUnitHealedEvent(source, heal, validHeal, spHeal, guardHeal, shieldHeal);
            QueueHealFx(addHeal, source);
            UseOnHealSkill(addHeal, source);

            return new AddHealResult { Heal = heal, ValidHeal = validHeal, SpHeal = spHeal, GuardHeal = guardHeal, ShieldHeal = shieldHeal };
        }

        private long ApplySpHeal(AddHeal addHeal, int sourceLevel)
        {
            var spHeal = addHeal.SpHeals.GetClamped(sourceLevel - 1);
            if (spHeal > 0L)
                AddSp(spHeal);

            return spHeal;
        }

        private long ApplyGuardHeal(AddHeal addHeal, int sourceLevel)
        {
            var guardHeal = addHeal.GuardHeals.GetClamped(sourceLevel - 1);
            if (guardHeal > 0L)
                AddGuard(LongFixedFloatMath.ScaleSaturated(guardHeal, GuardRatio));

            return guardHeal;
        }

        private long ApplyShieldHeal(AddHeal addHeal, HealSourceContext source)
        {
            var shieldHeal = addHeal.GetShieldHeal(source.Healer, this, source.Level);
            if (shieldHeal > 0L)
                AddShield(shieldHeal);

            return shieldHeal;
        }

        private void QueueUnitHealedEvent(
            HealSourceContext source,
            long heal,
            long validHeal,
            long spHeal,
            long guardHeal,
            long shieldHeal)
        {
            var e = new UnitHealedEvent
            {
                UnitId = id_,
                Heal = heal,
                ValidHeal = validHeal,
                SpHeal = spHeal,
                GuardHeal = guardHeal,
                ShieldHeal = shieldHeal,
            };
            source.ApplyTo(e);
            Board.QueueEvent(e);
        }

        private void QueueHealFx(AddHeal addHeal, HealSourceContext source)
        {
            if (!string.IsNullOrEmpty(ResUnit.HitHealFx))
                Board.QueueEvent(new PlayFxEvent
                {
                    UnitId = id_,
                    Position = position_,
                    Prefab = ResUnit.HitHealFx,
                });
            if (addHeal.FxOnHit != null)
            {
                var fx = new PlayFxEvent
                {
                    UnitId = id_,
                    Position = position_,
                    Prefab = addHeal.FxOnHit,
                };
                source.ApplyTo(fx);
                if (source.Skill != null)
                    fx.Speed = source.Skill.TimelineSpeed;
                Board.QueueEvent(fx);
            }
        }

        private void UseOnHealSkill(AddHeal addHeal, HealSourceContext source)
        {
            if (addHeal.OnHealUseSkill != null)
            {
                if (source.Skill != null)
                {
                    source.Healer.UseSkill(
                        addHeal.OnHealUseSkill,
                        addHeal.OnHealUseSkill.AtTarget ? position_ : source.Skill.Position,
                        source.Skill.Direction,
                        itemId: source.Skill.ItemId,
                        itemDataId: source.Skill.ItemDataId,
                        ignoreActable: true);
                }
                else
                    source.Healer.UseSkill(addHeal.OnHealUseSkill, position_, direction_, ignoreActable: true);
            }
        }

        private long HandleHeal(GameUnit target, long heal, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (_triggerOnHeal != null)
            {
                using var state = CreateState();
                state.slotUnit = target;
                state.SetParameter(Board, Heal, LongFixedFloatMath.ToFixedFloatSaturated(heal));
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnHeal.Run(Board, state);
                heal = state.GetLongPredefinedVariableSaturated(Board, Return, heal);
            }
            return heal;
        }

        private long HandleHealed(GameUnit? healer, long heal, GameSkill? skill = null, GameBuff? buff = null)
        {
            if (_triggerOnHealed != null)
            {
                using var state = CreateState();
                state.slotUnit = healer;
                state.SetParameter(Board, Heal, LongFixedFloatMath.ToFixedFloatSaturated(heal));
                if (skill != null)
                    state.SetParameter(Board, SkillDataId, skill.ResSkill.Id);
                if (buff != null)
                    state.SetParameter(Board, BuffDataId, buff.ResBuff.Id);
                _triggerOnHealed.Run(Board, state);
                heal = state.GetLongPredefinedVariableSaturated(Board, Return, heal);
            }
            return heal;
        }
    }
}
