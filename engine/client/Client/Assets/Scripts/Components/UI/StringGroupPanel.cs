using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class StringGroupPanel : MonoBehaviour
{
    [Serializable]
    public class DescCell : UIElement
    {
        public TextMeshProUGUI txtTitle;
        public TextMeshProUGUI txtDesc;
        public LayoutElement layoutElementDescView;
    }

    public UIElementContainer<DescCell> descContainer = new();
    public int descScrollEnableLineCount = int.MaxValue;
    
    public StringGroupPanel SetDescriptions(RectTransform root, IList<string> descriptions, TextAlignmentOptions alignment = TextAlignmentOptions.Top)
    {
        transform.SetActive(descriptions.Count > 0 && descriptions.All(x => !string.IsNullOrEmpty(x)));
        var descChanged = false;
        foreach (var (element, index, data) in descContainer.GetElements(descriptions))
        {
            element.txtTitle.text = string.Empty;
            element.txtDesc.text = data;
            element.txtDesc.alignment = alignment;
            descChanged = true;
        }
        
        if (descChanged)
        {
            RefreshDescLayout(root);
        }
        
        return this;
    }
    
    public StringGroupPanel SetDescriptions(RectTransform root, IList<(string title, string desc)> descriptions, TextAlignmentOptions alignment = TextAlignmentOptions.Top)
    {
        transform.SetActive(descriptions.Count > 0 && descriptions.All(x => !string.IsNullOrEmpty(x.desc)));
        var descChanged = false;
        foreach (var (element, index, data) in descContainer.GetElements(descriptions))
        {
            element.txtTitle.text = data.title;
            element.txtDesc.text = data.desc;
            element.txtDesc.alignment = alignment;
            descChanged = true;
        }

        if (descChanged)
        {
            RefreshDescLayout(root);
        }
        
        return this;
    }
    
    private void RefreshDescLayout(RectTransform root)
    {
        root ??= (RectTransform)transform;
        LayoutRebuilder.ForceRebuildLayoutImmediate(root);
        
        foreach (var element in descContainer.Elements)
        {
            var preferredHeight = Mathf.Min(
                element.txtDesc.fontSize * descScrollEnableLineCount + element.txtDesc.lineSpacing * (descScrollEnableLineCount - 1),
                element.txtDesc.preferredHeight);
            element.layoutElementDescView.preferredHeight = preferredHeight;
        }
    }
    
    public StringGroupPanel SetDescScrollEnableLineCount(RectTransform root, int count)
    {
        descScrollEnableLineCount = count;
        RefreshDescLayout(root);
        return this;
    }
    
}
