using System.Collections.Generic;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

namespace Commons.Game
{
    public partial class GameSkill : IAttackSource
    {
        public long AttackerUnitId => SenderUnitId;
        public GameUnit? Attacker => Sender;

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
                state.slotUnit = target;
                state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, damage);
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
            state.slotUnit = target;
            state.SetPredefinedVariable(Board, Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Damage, LongFixedFloatMath.ToFixedFloatSaturated(damage));
            state.SetPredefinedVariable(Board, IsCritical, isCritical);
                
            _triggerOnAttack.Run(Board, state);
            return state.GetLongPredefinedVariableSaturated(Board, Return, damage);
        }
    }
}
