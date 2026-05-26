using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

namespace Commons.Game
{
    public partial class GameBuff : IAttackSource
    {
        public GameUnit? Attacker => Board.GetUnitById(AttackerUnitId);

        void IAttackSource.HandleKill(GameUnit target)
        {
            if (_triggerOnKill != null)
            {
                using var state = CreateState();
                state.slotUnit = target;
                _triggerOnKill.Run(Board, state);
            }
        }
        
        internal FixedFloat HandleAttack(GameUnit attacker, GameUnit target, FixedFloat damage, bool isCritical)
        {
            if (_triggerOnAttack != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board,Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                _triggerOnAttack.Run(Board, state);
                damage = state.GetPredefinedVariable(Board, Return, damage);
            }
            return damage;
        }

        internal long HandleAttackLong(GameUnit attacker, GameUnit target, long damage, bool isCritical)
        {
            if (_triggerOnAttack == null)
                return damage;

            using var state = CreateState();
            state.slotUnit = attacker;
            state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, LongFixedFloatMath.ToFixedFloatSaturated(damage));
            state.SetPredefinedVariable(Board, IsCritical, isCritical);
            _triggerOnAttack.Run(Board, state);
            return state.GetLongPredefinedVariableSaturated(Board, Return, damage);
        }
        
        internal FixedFloat HandleAttacked(GameUnit attacker, GameUnit target, FixedFloat damage, bool isCritical = false)
        {
            if (ResBuff.ContainsTag(Tag.Invincible))
                return FixedFloat.Zero;

            if (ResBuff.OnAttackedSelfAddDamage != null)
                target.AddDamage(this, ResBuff.OnAttackedSelfAddDamage);
            if (ResBuff.OnAttackedAttackerAddDamage != null)
                attacker.AddDamage(this, ResBuff.OnAttackedAttackerAddDamage);
            
            if (_triggerOnAttacked != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                state.SetPredefinedVariable(Board,Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                _triggerOnAttacked.Run(Board, state);
                damage = state.GetPredefinedVariable(Board, Return, damage);
            }
            return damage;
        }

        internal long HandleAttackedLong(GameUnit attacker, GameUnit target, long damage, bool isCritical = false)
        {
            if (ResBuff.ContainsTag(Tag.Invincible))
                return 0L;

            if (ResBuff.OnAttackedSelfAddDamage != null)
                target.AddDamage(this, ResBuff.OnAttackedSelfAddDamage);
            if (ResBuff.OnAttackedAttackerAddDamage != null)
                attacker.AddDamage(this, ResBuff.OnAttackedAttackerAddDamage);

            if (_triggerOnAttacked == null)
                return damage;

            var fixedDamage = LongFixedFloatMath.ToFixedFloatSaturated(damage);
            using var state = CreateState();
            state.slotUnit = attacker;
            state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, fixedDamage);
            state.SetPredefinedVariable(Board, IsCritical, isCritical);
            _triggerOnAttacked.Run(Board, state);
            return state.GetLongPredefinedVariableSaturated(Board, Return, damage);
        }
        
        internal void HandleAttackedPost(GameUnit attacker, FixedFloat damage, FixedFloat validDamage, bool isCritical = false)
        {
            if (_triggerOnAttackedPost != null)
            {
                using var state = CreateState();
                state.slotUnit = attacker;
                
                state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
                state.SetPredefinedVariable(Board, IsCritical, isCritical);
                state.SetPredefinedVariable(Board, ValidDamage, validDamage);
                _triggerOnAttackedPost.Run(Board, state);
            }
        }

        internal void HandleAttackedPostLong(GameUnit attacker, long damage, long validDamage, bool isCritical = false)
        {
            if (_triggerOnAttackedPost == null)
                return;

            HandleAttackedPost(
                attacker,
                LongFixedFloatMath.ToFixedFloatSaturated(damage),
                LongFixedFloatMath.ToFixedFloatSaturated(validDamage),
                isCritical);
        }
    }
}
