using System.Collections;
using System.Collections.Generic;
using System.Text;
using Febucci.UI;
using Febucci.UI.Effects;
using Sirenix.OdinInspector;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

[RequireComponent(typeof(TextAnimator_TMP))]
[RequireComponent(typeof(TypewriterByCharacter))]
public class CustomTMP_NumberOnly : CustomTextMeshProUGUI
{
    [SerializeField] private TextAnimator_TMP m_TextAnimator;
    [SerializeField] private TypewriterByCharacter m_TypewriterByCharacter;
    
    [SerializeField] private string[] m_AppearanceTags = new string[0];
    [SerializeField] private string[] m_ValueUpTags = new string[0];
    [SerializeField] private string[] m_ValueDownTags = new string[0];
    [SerializeField] private string[] m_DisappearanceTags = new string[0];
    
    [SerializeField] private int m_TestValue = 0;

    private int m_PrevIntValue = int.MinValue;
    public void SetText(int value, bool bZeroBased = true)
    {
        if (m_PrevIntValue == value)
            return;
        
        var valueString = value.ToString();
        if (value > m_PrevIntValue)
        {
            if (bZeroBased && m_PrevIntValue <= 0)
            {
                SetTextToAnimator(valueString, m_AppearanceTags);
                DoStartShowingText();
            }
            else
            {
                SetTextToAnimator(valueString, m_ValueUpTags);
            }
        }
        else if (value < m_PrevIntValue)
        {
            if (bZeroBased && value <= 0)
            {
                SetTextToAnimator(valueString, m_DisappearanceTags);
                DoStartDisappearingText();
            }
            else
            {
                SetTextToAnimator(valueString, m_ValueDownTags);
            }
        }
        m_PrevIntValue = value;
    }

    private static readonly StringBuilder m_StringBuilder = new(); 
    private void SetTextToAnimator(string valueString, string[] tags)
    {
        m_StringBuilder.Clear();
        
        foreach (var tag in tags)
        {
            m_StringBuilder.AppendFormat("<{0}>", tag);
        }
        m_StringBuilder.Append(valueString);
        
        m_TextAnimator.SetText(m_StringBuilder.ToString());
        m_TextAnimator.SetBehaviorsActive(tags.Length > 0);
        m_TextAnimator.time.RestartTime();
    }

    private void DoStartShowingText()
    {
        m_TypewriterByCharacter.StartShowingText();
    }
    
    private void DoStartDisappearingText()
    {
        m_TypewriterByCharacter.StartDisappearingText();
    }

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        base.OnValidate();
        
        if (m_TextAnimator == null)
            m_TextAnimator = GetComponent<TextAnimator_TMP>();
        
        if (m_TypewriterByCharacter == null)
            m_TypewriterByCharacter = GetComponent<TypewriterByCharacter>();
    }

    [MenuItem("GameObject/UI/Text - CustomTextMeshPro (NumberOnly)", false, 2001)]
    static void CreateCustomTMP_NumberOnly(MenuCommand menuCommand)
    {
        CreateTMP<CustomTMP_NumberOnly>(menuCommand);
    }
#endif
}

#if UNITY_EDITOR
[CustomEditor(typeof(CustomTMP_NumberOnly))]
public class CustomTMP_NumberOnlyEditor : CustomTextMeshProUGUIEditor
{
    private SerializedProperty m_TextAnimator;
    private SerializedProperty m_TypewriterByCharacter;
    
    private SerializedProperty m_AppearanceTags;
    private SerializedProperty m_ValueUpTags;
    private SerializedProperty m_ValueDownTags;
    private SerializedProperty m_DisappearanceTags;
    
    private SerializedProperty m_TestValue;

    protected override void OnEnable()
    {
        base.OnEnable();
        
        m_TextAnimator = serializedObject.FindProperty("m_TextAnimator");
        m_TypewriterByCharacter = serializedObject.FindProperty("m_TypewriterByCharacter");
        
        m_AppearanceTags = serializedObject.FindProperty("m_AppearanceTags");
        m_ValueUpTags = serializedObject.FindProperty("m_ValueUpTags");
        m_ValueDownTags = serializedObject.FindProperty("m_ValueDownTags");
        m_DisappearanceTags = serializedObject.FindProperty("m_DisappearanceTags");
        
        m_TestValue = serializedObject.FindProperty("m_TestValue");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.PropertyField(m_TextAnimator);
        EditorGUILayout.PropertyField(m_TypewriterByCharacter);
        
        EditorGUILayout.Space();
        
        EditorGUILayout.PropertyField(m_AppearanceTags, true);
        EditorGUILayout.PropertyField(m_ValueUpTags, true);
        EditorGUILayout.PropertyField(m_ValueDownTags, true);
        EditorGUILayout.PropertyField(m_DisappearanceTags, true);
        
        EditorGUILayout.Space();
        
        EditorGUILayout.PropertyField(m_TestValue);
        
        // Show SetValue button. args: input field
        if (GUILayout.Button("Set Value"))
        {
            ((CustomTMP_NumberOnly)target).SetText(m_TestValue.intValue);
        }

        serializedObject.ApplyModifiedProperties();
        
        base.OnInspectorGUI();
    }
}
#endif