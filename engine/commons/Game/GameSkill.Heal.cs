using Commons.Resources;
using Commons.Types.Units;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

namespace Commons.Game
{
    public partial class GameSkill
    {
        internal long HandleHeal(GameUnit healer, GameUnit target, AddHeal addHeal)
        {
            var heal = addHeal.GetHeal(healer, target, level_);
            if (_triggerOnHeal != null)
            {
                using var state = CreateState();
                state.slotUnit = target;
                state.SetParameter(Board, Heal, LongFixedFloatMath.ToFixedFloatSaturated(heal));
                _triggerOnHeal.Run(Board, state);
                heal = state.GetLongPredefinedVariableSaturated(Board, Return, heal);
            }
            return heal;
        }
    }
}
