using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Components.UI.Toggle;
using Interfaces;
using TMPro;
using UnityEngine;

public class Popup_GachaResult : UIPopup, IAcquiredItemViewer
{
    public PurchaseProductCell cellPurchaseProduct;

    public CustomToggle toggleSkip;
    
    public TextMeshProUGUI txtTitle;
    
    public Animator animator;

    public GameObject[] gachaBackgroundsPerGrade = new GameObject[0];
    public GameObject[] gachaObjectsPerGrade = new GameObject[0];
    
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>>
    {
        
    }

    public TableElement tableElement = new();

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    public override void Refresh()
    {
        base.Refresh();
        
        cellPurchaseProduct.Refresh(_resAcquiredItemSource);
        cellPurchaseProduct.elementRoot.SetActive(_resAcquiredItemSource!.ContainsTag(Tag.DirectRepurchaseAvailable));
    }

    public void StartSequence()
    {
        animator.Play(AnimatorHash.Sequence);
        
        gachaBackgroundsPerGrade[0].SetActive(true);
        gachaObjectsPerGrade[0].SetActive(true);
        AudioManager.Get().PlayFX("SFX_Gacha_Enter");
        AudioManager.Get().PlayFX("SFX_Gacha_Starfall");
    }

   

    public void SequenceChangeGrade()
    {
        gachaBackgroundsPerGrade[0].SetActive(false);
        gachaObjectsPerGrade[0].SetActive(false);

        var index = Mathf.Clamp(_topGrade, 1, gachaBackgroundsPerGrade.Length - 1);
        
        gachaBackgroundsPerGrade.GetClamped(index).SetActive(true);
        gachaObjectsPerGrade.GetClamped(index).SetActive(true);
        if (index == gachaBackgroundsPerGrade.Length - 1)
        {
            AudioManager.Get().PlayFX("SFX_Gacha_Starfall_ColorChange_S");
        }
        else
        {
            AudioManager.Get().PlayFX("SFX_Gacha_Starfall_ColorChange_Basic");
        }
        
    }
    
    public void SequenceStartGachaResult()
    {
        AudioManager.Get().StopFx("SFX_Gacha_Starfall");
    }

    public void SkipSequence()
    {
        var clips = animator.GetCurrentAnimatorClipInfo(0);
        var clip = clips[0].clip;

        if (clip.events.Length == 0)
            return;
        
        var time = clip.events.Last().time;
        var stateInfo = animator.GetCurrentAnimatorStateInfo(0);
        time /= stateInfo.length;
        animator.Play(AnimatorHash.Sequence, 0, time);
    }

    public void OnClickSkip()
    {
        animator.Play(AnimatorHash.Result);
    }
    
    private ResourceItem _resAcquiredItemSource = null!;

    private int _topGrade = 1;
    public IAcquiredItemViewer Initialize(IList<PlayerItemMessage> items, string title = null, ResourceItem resAcquiredItemSource = null)
    {
        const int countPerRow = 5;
        var count = items.Count;
        tableElement.table.Initialize<PlayerItemMessage, UITableRow<ItemCellBehaviourWrapperElement>>(items, (list, row, element) =>
        {
            for (var i = 0; i < countPerRow; i++)
            {
                var index = row * countPerRow + i;
                var item = list.GetSafe(index);
                var cell = element.cells[i];
                cell.Get<ItemCell>().Refresh(item);
            }
        }, Mathf.CeilToInt(count / (float)countPerRow));

        txtTitle.text = title;

        _topGrade = items.Max(x =>
        {
            var resItem = x.GetData()!;
            //S급 영웅은 노랑색이 나와야 하는 느낌
            return resItem.Grade + resItem.ExtraGrade - 1;
        });
        
        _resAcquiredItemSource = resAcquiredItemSource;
        
        cellPurchaseProduct.btnPurchaseProduct.SetPurchaseCallback(OnCancel);

        var key = $"{nameof(Popup_GachaResult)}_Skip_{resAcquiredItemSource!.Group}";
        var prefs = GameManager.Get().GetTransientPrefs<bool>(key);
        toggleSkip.isOn = prefs;
        toggleSkip.onChanged += isOn =>
        {
            prefs.Set(isOn);
        };
        
        if (toggleSkip.isOn)
            OnClickSkip();
        else
        {
            animator.Play(AnimatorHash.Start);
        }
            
        return this;
    }
}
