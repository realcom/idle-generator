using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class UIElementCopywriter : SerializedMonoBehaviour
{
    [HideReferenceObjectPicker]
    public IUIElementContainer container;
    [ReadOnly] 
    public string copyKey;
}
