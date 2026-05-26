using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using UnityEngine;
using UnityEngine.Serialization;

using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type;

public class MyGameUnitObject : GameUnitObject
{
    public static MyGameUnitObject instance;
    
    public static MyGameUnitObject Get()
    {
        return instance ? instance : null;
    }

    public void Awake()
    {
        instance = this;
        isLocalPlayer = true;
    }

    public override void Start()
    {
        base.Start();
    }

    private FixedFloat _cachedAttack;
    private FixedFloat _cachedDefense;
    protected override void SyncStats(GameUnit gameUnit, bool init = false)
    {
        base.SyncStats(gameUnit, init);

        if (init || _cachedAttack != gameUnit.Attack)
        {
            _cachedAttack = gameUnit.Attack;
            GameManager.Get().DispatchEvent(GameEventType.MyUnitAttackUpdated);
        }
        
        if (init || _cachedDefense != gameUnit.Defense)
        {
            _cachedDefense = gameUnit.Defense;
            GameManager.Get().DispatchEvent(GameEventType.MyUnitDefenseUpdated);
        }
        
        if (init || _cachedGameUnit.Exp != gameUnit.Exp || _cachedGameUnit.Level != gameUnit.Level)
        {
            _cachedGameUnit.Exp = gameUnit.Exp;
            _cachedGameUnit.Level = gameUnit.Level;
            
            GameManager.Get().DispatchEvent(GameEventType.MyUnitExpUpdated);
        }
    }

    protected override bool SyncBuffs(GameUnit gameUnit)
    {
        var isBuffUpdated = base.SyncBuffs(gameUnit);
        
        if (isBuffUpdated)
            GameManager.Get().DispatchEvent(GameEventType.MyUnitBuffUpdated);
        
        return isBuffUpdated;
    }

    
    protected override void SyncVariables(GameUnit updatedUnit, bool init = false)
    {
        base.SyncVariables(updatedUnit, init);

        if (init || _cachedGameUnit.Variables.Get((int)FreeRollCount) != updatedUnit.Variables.Get((int)FreeRollCount))
        {
            _cachedGameUnit.Variables.Set((int)FreeRollCount, updatedUnit.Variables.Get((int)FreeRollCount));
            GameManager.Get().DispatchEvent(GameEventType.MyUnitFreeRollCountUpdated);
        }
    }

    public override void HandleAttacked(UnitAttackedEvent attackedEvent, EffectType effectType = EffectType.Default)
    {
        base.HandleAttacked(attackedEvent, effectType);
        
        // HUDManager.Get().ShowPain();
    }

    public override void HandleUpdate(GameEntity gameEntity, float dt)
    {
        base.HandleUpdate(gameEntity, dt);
    }
}