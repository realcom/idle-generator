using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class ZEventTrigger : EventTrigger
{
    [SerializeField] private bool m_Interactable = true;

    public bool IsInteractable => m_Interactable && m_CanInteractionByCanvasGroup;
    
    protected void OnTransformParentChanged()
    {
        OnCanvasGroupChanged();
    }

    private bool m_CanInteractionByCanvasGroup = true;
    protected void OnCanvasGroupChanged()
    {
        m_CanInteractionByCanvasGroup = CanInteractionByCanvasGroup();
    }

    private readonly List<CanvasGroup> m_canvasGroups = new();
    private bool CanInteractionByCanvasGroup()
    {
        m_canvasGroups.Clear();
        
        var t = transform;
        while (t != null)
        {
            t.GetComponents(m_canvasGroups);
            for (var i = 0; i < m_canvasGroups.Count; i++)
            {
                if (m_canvasGroups[i].enabled && !m_canvasGroups[i].interactable)
                    return false;

                if (m_canvasGroups[i].ignoreParentGroups)
                    return true;
            }

            t = t.parent;
        }

        return true;
    }

    private void OnEnable()
    {
        m_CanInteractionByCanvasGroup = CanInteractionByCanvasGroup();
    }

    public override void OnPointerEnter(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnPointerEnter(eventData);
    }
    
    public override void OnPointerExit(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnPointerExit(eventData);
    }
    
    public override void OnPointerDown(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnPointerDown(eventData);
    }
    
    public override void OnPointerUp(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnPointerUp(eventData);
    }
    
    public override void OnPointerClick(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnPointerClick(eventData);
    }
    
    public override void OnDrag(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnDrag(eventData);
    }
    
    public override void OnDrop(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnDrop(eventData);
    }
    
    public override void OnScroll(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnScroll(eventData);
    }
    
    public override void OnUpdateSelected(BaseEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnUpdateSelected(eventData);
    }
    
    public override void OnSelect(BaseEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnSelect(eventData);
    }
    
    public override void OnDeselect(BaseEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnDeselect(eventData);
    }
    
    public override void OnMove(AxisEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnMove(eventData);
    }
    
    public override void OnSubmit(BaseEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnSubmit(eventData);
    }
    
    public override void OnCancel(BaseEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnCancel(eventData);
    }
    
    public override void OnInitializePotentialDrag(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnInitializePotentialDrag(eventData);
    }
    
    public override void OnBeginDrag(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnBeginDrag(eventData);
    }
    
    public override void OnEndDrag(PointerEventData eventData)
    {
        if (!IsInteractable)
            return;
        base.OnEndDrag(eventData);
    }
    
}

#if UNITY_EDITOR
[CustomEditor(typeof(ZEventTrigger))]
public class ZEventTriggerEditor : UnityEditor.EventSystems.EventTriggerEditor
{
    private SerializedProperty m_Interactable;

    protected override void OnEnable()
    {
        base.OnEnable();
        
        m_Interactable = serializedObject.FindProperty("m_Interactable");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        
        EditorGUILayout.PropertyField(m_Interactable);
        
        serializedObject.ApplyModifiedProperties();
        
        base.OnInspectorGUI();
    }
}
#endif