using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.UI;
using ZLinq;

public partial class ZModeManagerLobby
{
    public enum BottomButtonType
    {
        NONE,
        SHOP,
        UNIT,
        LOBBY,
        TRAIN,
        COMING_SOON,
    }

    [Serializable]
    public struct PageData
    {
        public BottomButtonType type;
        public ZModePage page;
    }
    
    [Title("HUD Bottom")] 
    public Dictionary<BottomButtonType, CustomToggle> bottomToggles = new();
    public List<PageData> pages = new();
    public RedDot redDotEquipment;
    public RedDot redDotShop;
    public RedDot redDotTraining;

    [Title("Covered UI")] 
    public RectTransform rtCoveredUI;
    public RectTransform rtCoveredUIPageParent;

    private float bottomButtonFlexibleWidthPool;
    public BottomButtonType currentType = BottomButtonType.NONE;
    public ZModePage currentPage => pages.FirstOrDefault(p => p.type == currentType).page;
    
    private IEnumerator InitBottoms()
    {
        for (var index = 0; index < pages.Count; index++)
        {
            var data = pages[index];
            var handle = InstantiateAsync(data.page, rtCoveredUIPageParent);
            yield return handle;
            var pageInstance = handle.Result[0];
            pageInstance.transform.localPosition = Vector3.zero;
            ((RectTransform)pageInstance.transform).anchoredPosition = Vector2.zero;
            pageInstance.gameObject.SetActive(false);
            data.page = pageInstance;
            pages[index] = data;
        }
        
        RefreshBottoms();
        ClickBottomButton(BottomButtonType.LOBBY);
        OnClickBottomButton(BottomButtonType.LOBBY);

        using (var scope = new NoticeSystem.RegisterScope(redDotEquipment))
        {
            scope.AddNoticeRelevanceEntities(Page_Equipment.GetNoticeRelevanceEntities());
            scope.AddPrerequisitesConditions(Page_Equipment.GetNoticePrerequisites());
        }
        
        redDotShop.Register(Page_Shop.GetNoticeRelevanceEntities());
        
        using (var scope = new NoticeSystem.RegisterScope(redDotTraining))
        {
            foreach (var statItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Stat).AsValueEnumerable().Where(x => x.IsValid && x.IsValidByRequiredAndExclusive()))
            {
                scope.AddNoticeRelevanceEntity(statItem);
            }
        }
    }

    public void ClickBottomButton(BottomButtonType buttonType)
    {
        if (bottomToggles.TryGetValue(buttonType, out var toggle))
        {
            if (toggle != null)
                toggle.isOn = true;
        }
    }

    private void RefreshBottoms()
    {
        foreach (var (type, toggle) in bottomToggles)
        {
            toggle.onValueChanged.RemoveAllListeners();
            toggle.onValueChanged.AddListener(isOn =>
            {
                if (isOn)
                    OnClickBottomButton(type);
            });
        }
    }

    public void ShowComingSoon()
    {
        Toast.Show<Popup_Toast>("ComingSoon".L());
    }

    public void OnClickBottomButton(BottomButtonType type)
    {
        var prevType = currentType;
        currentType = type;
        
        //var spaceTotal = bottomButtonsLayoutGroup.padding.horizontal + bottomButtonsLayoutGroup.spacing * (bottomToggles.Count - 1);
        //bottomButtonFlexibleWidthPool = ((RectTransform)bottomButtonsLayoutGroup.transform).rect.width - spaceTotal;

        RefreshCoveredUI();

        foreach (var pageData in pages)
        {
            pageData.page.SetActive(pageData.type == type);
            if (pageData.type == prevType)
                pageData.page.OnHide();
            else if (pageData.type == type)
                pageData.page.OnVisible();
        }

        //var button = bottomButtons[type];
        //button.GetComponent<LayoutElement>().DOFlexibleSize(new Vector2(focusButtonFlexWidth, 1f), focusDuration);
        //
        ////focusWidth + (1 * count)
        //var totalFlexibleSize = focusButtonFlexWidth + bottomButtons.Count - 1;
        //var flexibleWidth = bottomButtonFlexibleWidthPool / totalFlexibleSize;
        //var buttonIndex = (int)currentType - 1; //temp
        //var destPosX = bottomButtonsLayoutGroup.padding.left + (flexibleWidth * focusButtonFlexWidth * 0.5f) + (flexibleWidth + bottomButtonsLayoutGroup.spacing) * buttonIndex;
        ////rtArrow.DOAnchorPosX(destPosX, focusDuration);

        if (prevType != currentType)
        {
            GameManager.Get().DispatchEvent(GameEventType.LobbyHUDPageUpdated, type);
            PlatformManager.Get().LogEvent("page_open", ("Name", currentType.ToString()));
            AudioManager.Get().PlayFX("click_Lobby_Tab");
            AudioManager.Get().PlayBGM("BGM_" + currentType);
        }
    }

    private void RefreshCoveredUI()
    {
        switch (currentType)
        {
            case BottomButtonType.LOBBY:
            {
                TurnOffCoverUI();
                return;
            }
            case BottomButtonType.UNIT:
            {
                TurnOnCoverUI();
                return;
            }
            case BottomButtonType.TRAIN:
            {
                TurnOnCoverUI();
                return;
            }
            case BottomButtonType.SHOP:
            {
                TurnOnCoverUI();
                return;
            }
            default:
            {
                TurnOffCoverUI();
                Toast.Show<Popup_Toast>("ComingSoon".L());
                break;
            }
        }

        void TurnOffCoverUI()
        {
            ShowLobbyMainHUD(true);
            rtCoveredUI.gameObject.SetActive(false);
            //rtCoveredUIPageParent.localScale = new Vector3(1, 0, 1);
        }

        void TurnOnCoverUI()
        {
            ShowLobbyMainHUD(false);
            rtCoveredUI.gameObject.SetActive(true);
            //rtCoveredUIPageParent.DOScaleY(1f, focusDuration);
        }
        
    }
    
}
