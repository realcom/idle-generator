using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
public class WiggleImageAlpha : MonoBehaviour
{
    [SerializeField] private Vector2 wiggleRange = new Vector2(0f, 1f);
    [SerializeField] private Image wiggleTarget;
    
    void Update()
    {
        if (wiggleTarget == null)
            return;
        
        wiggleTarget.SetAlpha(Random.Range(wiggleRange.x, wiggleRange.y));
    }
}
