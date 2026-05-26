using System.Collections;
using System.Collections.Generic;
using Commons.Game;
using Sirenix.OdinInspector;
using UnityEngine;

public abstract class FxEventDispatchSettings : FxSettings
{
    public abstract GameEventType EventType { get; }
    
    public class ContextWrapper
    {
        public FxContext FxContext;
    }
    
    public override void Apply(FxContext fxContext)
    {
        GameManager.Get().DispatchEvent(EventType, fxContext.authorEvent);
    }
}
