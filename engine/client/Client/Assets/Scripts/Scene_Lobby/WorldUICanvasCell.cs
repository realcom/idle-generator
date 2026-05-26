using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public abstract class WorldUICanvasCell : MonoBehaviour
{
    public RectTransform rt;

    public abstract void Initialize(GameUnitObject unit);
}
