using Commons.Resources;

namespace Commons.Game.Interfaces
{
    public interface IAttackSource
    {
        public long AttackerUnitId { get; }
        public GameUnit? Attacker { get; }
        
        void HandleKill(GameUnit target);
    }
}