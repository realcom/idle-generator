


using Commons.Packets.Updates;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private partial void HandleUpdateInternal(VariableUpdate update)
        {
            switch (update.Type)
            {
                case VariableUpdate.Types.Type.BoardVariable:
                {
                    Variables.Set(update.Key, update.Value);
                    break;
                }
                // Note: unsupported for unit variables, skill variables, buff variables and object variables
                default:
                {
                    break;
                }
            }
        }
    }
}