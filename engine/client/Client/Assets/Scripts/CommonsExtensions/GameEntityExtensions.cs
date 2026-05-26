using Commons.Types.Geometry;

namespace Commons.Game
{
    public interface GameEntity
    {
        public Vector2Message Position { get; set; }
        public Vector2Message Direction { get; set; }
        public Vector2Message Velocity { get; set; }
    }
    public partial class GameUnit : GameEntity
    {
        public void ClearMoveDestination()
        {
            Stop();
        }
    }
    
    public partial class GameSkill : GameEntity
    {
    }
    
    public partial class GameBuff : GameEntity
    {
        public Vector2Message Position { get; set; }
        public Vector2Message Direction { get; set; }
        public Vector2Message Velocity { get; set; }
    }
    
    public partial class GameDropItem : GameEntity
    {
        public Vector2Message Direction { get; set; }
        public Vector2Message Velocity { get; set; }
    }
}
