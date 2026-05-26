using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Types.Geometry;
using UnityEngine;

public class InteractableUnitSkin : UnitSkin, IInteractableBehaviour
{
    public new Collider2D collider2D;
    public new Collider2D collider => collider2D;
    
    public void ShowTextBubble(string text, float duration = float.PositiveInfinity)
    {
        BubbleCanvas.Get().ShowBubble(unit, text, duration);
    }
    
    public void HideTextBubble()
    {
        BubbleCanvas.Get().HideBubble(unit);
    }
    
    public void ShowArrow(bool show, float duration = float.PositiveInfinity)
    {
        unit.unitCanvasCell.ShowArrow(show, duration);
    }
    
}
