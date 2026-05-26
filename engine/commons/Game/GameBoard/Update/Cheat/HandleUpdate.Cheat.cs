

using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Utility;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private partial void HandleUpdateInternal(BoardPlayerRunCheatUpdate update)
        {
            var unit = GetUnitByPlayerId(update.PlayerId)!;
            var parameters = update.Parameters;
            switch (update.CheatType)
            {
                case BoardPlayerRunCheatUpdate.Types.CheatType.Buff:
                {
                    var buffDataId = parameters[0];
                    var level = parameters.Count > 2 ? parameters[1] : 1;
                    unit.QueueAddBuff(new GameUnit.QueuedAddBuff(unit, buffDataId, level));
                    break;
                }
                
                case BoardPlayerRunCheatUpdate.Types.CheatType.Spawn:
                {
                    var positionDeltaX = parameters.GetSafe(1);
                    var positionDeltaY = parameters.GetSafe(2);
                    var position = new Vector2Message { X = unit.Position.X + positionDeltaX, Y = unit.Position.Y + positionDeltaY };
                    
                    var unitDataId = parameters[0];
                    var resUnit = ResourceUnit.Get(unitDataId);
                    if (resUnit == null)
                        return;
                    
                    QueueAddUnit(new GameUnit
                    {
                        DataId =  unitDataId,
                        Offset = 0,
                        Position = position,
                        Direction = (Vector2Message)FixedVector2.left,
                        Velocity = new Vector2Message(),
                        Team = Team.Enemy,
                    });
                    
                    break;
                }
                
                case BoardPlayerRunCheatUpdate.Types.CheatType.Weapon:
                {
                    var player = GetPlayerById(update.PlayerId);
                    AddInventoryItem(player, player.Inventories[0], parameters[0]);
                    
                    break;
                }
                
                case BoardPlayerRunCheatUpdate.Types.CheatType.Trait:
                {
                    AcquireTrait(unit, parameters[0]);
                    break;
                }
                    
            default:
                break;
            }
        }
    }
}