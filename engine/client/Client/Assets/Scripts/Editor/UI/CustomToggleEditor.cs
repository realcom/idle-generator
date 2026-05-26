using System.Collections;
using System.Collections.Generic;
using Components.UI;
using Components.UI.Toggle;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace PM.Editor.UI
{
    [CustomEditor((typeof(CustomToggle)), true)]
    [CanEditMultipleObjects]
    public class CustomToggleEditor : OdinEditor
    {
        SerializedProperty m_OnValueChangedProperty;
        SerializedProperty m_GroupProperty;
        SerializedProperty m_IsOnProperty;
        SerializedProperty m_InteractableProperty;
     
        protected override void OnEnable()
        {
            base.OnEnable();
            
            m_GroupProperty = serializedObject.FindProperty("m_Group");
            m_IsOnProperty = serializedObject.FindProperty("m_IsOn");
            m_OnValueChangedProperty = serializedObject.FindProperty("onValueChanged");
            m_InteractableProperty = serializedObject.FindProperty("m_Interactable");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            
            serializedObject.Update();
            
            var toggle = serializedObject.targetObject as CustomToggle;
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.PropertyField(m_IsOnProperty);
            if (EditorGUI.EndChangeCheck())
            {
                if (!Application.isPlaying)
                    EditorSceneManager.MarkSceneDirty(toggle.gameObject.scene);

                var group = m_GroupProperty.objectReferenceValue as CustomToggleGroup;

                toggle.isOn = m_IsOnProperty.boolValue;

                if (group != null && group.isActiveAndEnabled && toggle.IsActive())
                {
                    if (toggle.isOn || (!group.AnyTogglesOn() && !group.allowSwitchOff))
                    {
                        toggle.isOn = true;
                        group.NotifyToggleOn(toggle);
                    }
                }
            }

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.PropertyField(m_GroupProperty);
            if (EditorGUI.EndChangeCheck())
            {
                if (!Application.isPlaying)
                    EditorSceneManager.MarkSceneDirty(toggle.gameObject.scene);

                var group = m_GroupProperty.objectReferenceValue as CustomToggleGroup;
                toggle.group = group;
            }

            EditorGUILayout.Space();

            // Draw the event notification options
            EditorGUILayout.PropertyField(m_OnValueChangedProperty);

            serializedObject.ApplyModifiedProperties();
        }
    }
    
}
