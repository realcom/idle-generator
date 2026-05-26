using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.UI;

//copied from https://github.com/Unity-UI-Extensions/com.unity.uiextensions
[AddComponentMenu("Layout/PuzzleMonsters/Radial Layout Ex")]
public class RadialLayoutEx : LayoutGroup
{
    public float fDistance;
    [Range(0f, 360f)] public float MinAngle, MaxAngle, StartAngle;
    public bool OnlyLayoutVisible = true;
    public bool applyRotationToChildren = true;
    [ShowIf("applyRotationToChildren")]
    public float rotationOffset = 0f;
    
    public bool fitCenterWithPivot = true;

    protected override void OnEnable()
    {
        base.OnEnable();
        CalculateRadial();
    }

    public override void SetLayoutHorizontal()
    {
    }

    public override void SetLayoutVertical()
    {
    }

    public override void CalculateLayoutInputVertical()
    {
        CalculateRadial();
    }

    public override void CalculateLayoutInputHorizontal()
    {
        CalculateRadial();
    }
#if UNITY_EDITOR
    protected override void OnValidate()
    {
        base.OnValidate();
        CalculateRadial();
    }
#endif

    protected override void OnDisable()
    {
        m_Tracker.Clear(); // key change - do not restore - false
        LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
    }

    void CalculateRadial()
    {
        m_Tracker.Clear();

        if (!enabled)
            return;
        
        if (transform.childCount == 0)
            return;

        var ChildrenToFormat = 0;
        var toIgnoreList = ListPool<Component>.Get();
        for (var i = 0; i < transform.childCount; i++)
        {
            var child = (RectTransform)transform.GetChild(i);
            if (child == null)
                continue;

            if (OnlyLayoutVisible && !child.gameObject.activeSelf)
                continue;
                
            child.GetComponents(typeof(ILayoutIgnorer), toIgnoreList);
            if (toIgnoreList.Any(comp => ((ILayoutIgnorer)comp).ignoreLayout))
                continue;
                
            ChildrenToFormat++;
        }

        var center = fitCenterWithPivot ? GetRelativeCenter(rectTransform) + rectTransform.anchoredPosition : rectTransform.anchoredPosition;

        var fAngleStep = (MaxAngle - MinAngle) / ChildrenToFormat;
        var fAngle = StartAngle;
        for (var i = 0; i < transform.childCount; i++)
        {
            var child = (RectTransform)transform.GetChild(i);
            if (child == null)
                continue;

            if (OnlyLayoutVisible && !child.gameObject.activeSelf)
                continue;

            child.GetComponents(typeof(ILayoutIgnorer), toIgnoreList);
            if (toIgnoreList.Any(comp => ((ILayoutIgnorer)comp).ignoreLayout))
                continue;

            //Adding the elements to the tracker stops the user from modifying their positions via the editor.
            m_Tracker.Add(this, child,
                DrivenTransformProperties.Anchors |
                DrivenTransformProperties.AnchoredPosition |
                DrivenTransformProperties.Pivot);

            if (applyRotationToChildren)
                m_Tracker.Add(this, child, DrivenTransformProperties.Rotation);
            
            var vPos = new Vector3(Mathf.Cos(fAngle * Mathf.Deg2Rad), Mathf.Sin(fAngle * Mathf.Deg2Rad), 0);
            child.localPosition = center + (Vector2)(vPos * fDistance);
            //Force objects to be center aligned, this can be changed however I'd suggest you keep all of the objects with the same anchor points.
            child.anchorMin = child.anchorMax = child.pivot = new Vector2(0.5f, 0.5f);

            if (applyRotationToChildren)
            {
                child.localRotation = Quaternion.Euler(0, 0, fAngle + rotationOffset);
            }

            fAngle += fAngleStep;
        }
        ListPool<Component>.Release(toIgnoreList);
    }
    
    private Vector2 GetRelativeCenter(RectTransform rt)
    {
        // pivot을 고려한 anchoredPosition을 구합니다.
        var pivotOffset = new Vector2((0.5f - rt.pivot.x) * rt.rect.width, (0.5f - rt.pivot.y) * rt.rect.height);
        var anchoredPos = rt.anchoredPosition + pivotOffset;
		
        return anchoredPos;
    }
    
}