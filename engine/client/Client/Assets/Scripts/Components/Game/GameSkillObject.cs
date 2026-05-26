using Commons.Game;
using Commons.Resources;
using JetBrains.Annotations;

public class GameSkillObject : GameBoardObject
{
    public ResourceSkill ResSkill => resource as ResourceSkill;
    [CanBeNull] public GameSkill gameSkill => GameBoardManager.Get().gameBoard.GetSkillById(syncId);

    public virtual void Awake()
    {
    }

    public override void HandleUpdate(GameEntity gameEntity, float dt)
    {
        base.HandleUpdate(gameEntity, dt);
    }
    
    public override void HandleDestroy(bool pool = true)
    {
        base.HandleDestroy(pool);
    }
}
