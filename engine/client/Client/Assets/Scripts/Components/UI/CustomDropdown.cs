using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.UI;
#endif

[AddComponentMenu("UI/Custom Dropdown", 35)]
[RequireComponent(typeof(Canvas))]
[RequireComponent(typeof(GraphicRaycaster))]
public class CustomDropdown : TMP_Dropdown
{
    public Canvas cavasOverlay;
    public GraphicRaycaster graphicRaycaster;

    protected override void Awake()
    {
        base.Awake();
        cavasOverlay = GetComponent<Canvas>();
        cavasOverlay.overrideSorting = true;
        cavasOverlay.sortingLayerID = SortingLayer.NameToID("UI");
        cavasOverlay.sortingOrder = 29999;
        cavasOverlay.overrideSorting = false;
        graphicRaycaster = GetComponent<GraphicRaycaster>();
        graphicRaycaster.blockingMask = LayerMask.GetMask("UI");
    }

    public override void OnPointerClick(PointerEventData eventData)
    {
        base.OnPointerClick(eventData);
        cavasOverlay.overrideSorting = IsExpanded;
    }

    public override void OnSubmit(BaseEventData eventData)
    {
        base.OnSubmit(eventData);
        cavasOverlay.overrideSorting = IsExpanded;
    }

    protected override void DestroyBlocker(GameObject blocker)
    {
        this.Run(OnHide, alphaFadeSpeed);
        base.DestroyBlocker(blocker);
    }
    
    protected virtual void OnHide()
    {
        cavasOverlay.overrideSorting = false;
    }
    
}

#if UNITY_EDITOR
[CustomEditor(typeof(CustomDropdown))]
public class CustomDropdownEditor : DropdownEditor {
    SerializedProperty m_canvasOverlay;
    SerializedProperty m_graphicRaycaster;

    protected override void OnEnable()
    {
        m_canvasOverlay = serializedObject.FindProperty("cavasOverlay");
        m_graphicRaycaster = serializedObject.FindProperty("graphicRaycaster");
        base.OnEnable();
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUILayout.PropertyField(m_canvasOverlay);
        EditorGUILayout.PropertyField(m_graphicRaycaster);
        serializedObject.ApplyModifiedProperties();
        base.OnInspectorGUI();
    }
}
#endif