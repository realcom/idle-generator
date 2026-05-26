using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Types;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Popup_Alert : UIPopup
{
    public static Popup_Alert Show()
    {
        var popup = GameManager.Get().ShowPopup<Popup_Alert>(GameManager.Get().scene.GetToastParent());
        if (popup == null)
            return null;
        
        popup.Initialize();
        return popup;
    }

    [Flags]
    public enum ButtonViewFlag
    {
        NONE = 0,
        OK = 1,
        NO = 2,
        ALL = ~NONE,
    }
    
    private UnityAction okCallback;
    private UnityAction noCallback;

    public TextMeshProUGUI txtTitle;
    public TextMeshProUGUI txtFootNote;

    public StringGroupPanel stringGroupPanel;

    public GameObject panelItems;
    public TextMeshProUGUI txtItemDesc;

    [Serializable]
    public class TableElement : UITableElement<ItemCellBehaviourWrapperElement>
    {
        
    }
    public TableElement tableElement = new();

    public CustomButton btClose;
    
    public GameObject goButtons;
    public HorizontalOrVerticalLayoutGroup layoutButtons;
    
    public CustomButton btOK;
    public TextMeshProUGUI txtOK;
    
    public CustomButton btNo;
    public TextMeshProUGUI txtNO;

    //public GameObject panelItems;
    //public UITableView tableItems;

    private Popup_Alert Initialize()
    {
        txtTitle.text = "Alert".L();
        txtOK.text = "OK".L();
        txtNO.text = "NO".L();

        txtFootNote.SetActive(false);
        
        btClose.SetActive(true);
        stringGroupPanel.SetActive(false);
        panelItems.SetActive(false);
        
        SetButtonsReverseAlignment(false);
        ShowButtons(true);
        
        btOK.SetOnClick(OnOK);
        btNo.SetOnClick(OnCancel);
        
        return this;
    }
    
    public Popup_Alert ShowDim(bool show)
    {
        if (backgroundDimTransform)
            backgroundDimTransform.SetActive(show);
        return this;
    }
    
    public Popup_Alert SetTitle(string title)
    {
        txtTitle.text = title;
        return this;
    }

    public Popup_Alert SetButtonType(ButtonViewFlag flag)
    {
        viewFlag = flag;
        RefreshButtonView();
        return this;
    }

    public Popup_Alert SetButtonsReverseAlignment(bool bReverse)
    {
        layoutButtons.reverseArrangement = bReverse;
        return this;
    }

    public Popup_Alert SetOkText(string text)
    {
        viewFlag |= ButtonViewFlag.OK;
        RefreshButtonView();
        txtOK.text = text;
        return this;
    }
    
    public Popup_Alert SetNoText(string text)
    {
        viewFlag |= ButtonViewFlag.NO;
        RefreshButtonView();
        txtNO.text = text;
        return this;
    }

    public Popup_Alert SetOkCallback(UnityAction callback)
    {
        viewFlag |= ButtonViewFlag.OK;
        RefreshButtonView();
        okCallback = callback;
        return this;
    }
	
    public Popup_Alert SetNoCallback(UnityAction callback)
    {
        viewFlag |= ButtonViewFlag.NO;
        RefreshButtonView();
        noCallback = callback;
        return this;
    }

    public Popup_Alert ShowButtons(bool show)
    {
        viewFlag = show ? ButtonViewFlag.ALL : ButtonViewFlag.NONE;
        RefreshButtonView();
        return this;
    }
    
    public Popup_Alert ShowCloseButton(bool show)
    {
        btClose.SetActive(show);
        return this;
    }
    
    public Popup_Alert SetFootNote(string footNote)
    {
        txtFootNote.text = footNote;
        txtFootNote.SetActive(!string.IsNullOrEmpty(footNote));
        return this;
    }
    
    public Popup_Alert SetDesc(string desc, TextAlignmentOptions alignment = TextAlignmentOptions.Top)
    {
        var descriptions = ListPool<string>.Get();
        descriptions.Clear();
        descriptions.Add(desc);

        SetDescriptions(descriptions, alignment);
		
        ListPool<string>.Release(descriptions);

        return this;
    }
    
    public Popup_Alert SetDescriptions(IList<string> descriptions, TextAlignmentOptions alignment = TextAlignmentOptions.Top)
    {
        stringGroupPanel.SetDescriptions((RectTransform)contents.transform, descriptions, alignment);
        return this;
    }
    
    public Popup_Alert SetDescriptions(IList<(string title, string desc)> descriptions, TextAlignmentOptions alignment = TextAlignmentOptions.Top)
    {
        stringGroupPanel.SetDescriptions((RectTransform)contents.transform, descriptions, alignment);
        return this;
    }
    
    public Popup_Alert SetDescScrollEnableLineCount(int count)
    {
        stringGroupPanel.SetDescScrollEnableLineCount((RectTransform)contents.transform, count);
        return this;
    }

    public Popup_Alert SetItems(IEnumerable<AddItem> items, string itemDesc = null)
    {
        itemDesc ??= "Items".L();
        txtItemDesc.text = itemDesc;
        panelItems.SetActive(true);
        
        tableElement.table.Initialize<AddItem, ItemCellBehaviourWrapperElement>(items, (list, idx, element) =>
        {
            element.Get<ItemCell>().Refresh(list.GetSafe(idx));
        });

        return this;
    }

    private UniTaskCompletionSource<bool> _tcs = null;
    public UniTask<bool> WaitResultAsync()
    {
        _tcs = new UniTaskCompletionSource<bool>();
        return _tcs.Task;
    }

    public override void OnOK()
    {
        _tcs?.TrySetResult(true);
        okCallback?.Invoke();
        Hide();
    }

    public override void OnCancel()
    {
        _tcs?.TrySetResult(false);
        noCallback?.Invoke();
        base.OnCancel();
    }

    private ButtonViewFlag viewFlag = ButtonViewFlag.NONE;
    private void RefreshButtonView()
    {
        goButtons.SetActive(viewFlag != ButtonViewFlag.NONE);
        btOK.SetActive(viewFlag.HasFlag(ButtonViewFlag.OK));
        btNo.SetActive(viewFlag.HasFlag(ButtonViewFlag.NO));
    }
    
    protected override void RefreshByFlag() { }
}
