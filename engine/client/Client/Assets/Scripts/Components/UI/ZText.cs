using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

[DisallowMultipleComponent]
[RequireComponent(typeof(TextMeshProUGUI))]
public class ZText : ZMonoBehaviour
{
    [SerializeField] private TextMeshProUGUI text;
    
    protected override void OnValidate()
    {
        base.OnValidate();
        
        
    }
}
