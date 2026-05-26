using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

#if UNITY_EDITOR
using TMPro.EditorUtilities;
using UnityEditor;
using UnityEditor.Presets;
#endif

public class CustomTextMeshProUGUI : TextMeshProUGUI
{
#if UNITY_EDITOR
    [MenuItem("GameObject/UI/Text - CustomTextMeshPro", false, 2001)]
    static void CreateTextMeshProGuiObjectPerform(MenuCommand menuCommand)
    {
        CreateTMP<CustomTextMeshProUGUI>(menuCommand);
    }

    protected static void CreateTMP<TMP>(MenuCommand menuCommand) where TMP : CustomTextMeshProUGUI
    {
        var go = ObjectFactory.CreateGameObject("Text");
        ObjectFactory.AddComponent<TMP>(go);

        // Override text color and font size
        var textComponent = go.GetComponent<TMP>();

        // Get reference to potential Presets for <TextMeshProUGUI> component
        Preset[] presets = Preset.GetDefaultPresetsForObject(textComponent);

        if (presets == null || presets.Length == 0)
        {
            textComponent.fontSize = TMP_Settings.defaultFontSize;
            textComponent.color = Color.white;
            textComponent.text = "--";
        }

        if (TMP_Settings.autoSizeTextContainer)
        {
            Vector2 size = textComponent.GetPreferredValues(TMP_Math.FLOAT_MAX, TMP_Math.FLOAT_MAX);
            textComponent.rectTransform.sizeDelta = size;
        }
        else
        {
            textComponent.rectTransform.sizeDelta = TMP_Settings.defaultTextMeshProUITextContainerSize;
        }

        Utility.PlaceUIElementRoot(go, menuCommand);
    }
    
#endif
}

#if UNITY_EDITOR
[CustomEditor(typeof(CustomTextMeshProUGUI), true)]
public class CustomTextMeshProUGUIEditor : TMP_EditorPanelUI 
{
    
}
#endif