using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Components.UI.Toggle;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_GamePass_Preview : UIPopup
{
    [Serializable]
    public class Cell : UIElement
    {
        public Image imgCell;
        public CustomButton btnCell;
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtShortName;
        public CustomToggle togglePurchased;
        public RectTransform rtUntilAt;
        public TextTimer txtUntilAt;
        public TextMeshProUGUI txtProgress;
        public RedDot redDot;

        public void Refresh(ResourceItem resPassGroup)
        {
            var resActivatedPass = Popup_GamePass.GetMainPassItems(resPassGroup).Last(x => MyPlayer.GetItemByDataID(x.Id, checkCount: true) != null);
            
            imgCell.sprite = resPassGroup.GetSpriteByKey("Banner");
            txtName.text = resPassGroup.ClientName;

            var activatedItem = MyPlayer.GetItemByDataID(resActivatedPass.Id, checkCount: true)!;
            
            txtShortName.text = resActivatedPass.ClientShortName;
            togglePurchased.isOn = MyPlayer.GetItemByDataID(resActivatedPass.TargetItemDataIds[1], checkCount: true) != null;
            
            rtUntilAt.SetActive(activatedItem.UntilAt != null);
            if (activatedItem.UntilAt != null)
                txtUntilAt.targetTimeAt = activatedItem.UntilAt.ToSeconds();

            var resSubPass = ResourceItem.Get(resActivatedPass.TargetItemDataIds[0])!;
            var progress = resSubPass.TargetAchievementDataIds.Count(MyPlayer.IsAchievementCompletedOrRewarded);
            txtProgress.text = $"{progress}/{resSubPass.TargetAchievementDataIds.Count}";

            redDot.Register(resPassGroup);
            btnCell.SetOnClick(resPassGroup.ShowPopup);
        }
    }

    [Serializable]
    public class TableElement : UITableElement<Cell>
    {
        
    }

    public TableElement tableElement = new();
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    private static List<ResourceItem> _passGroups = new();
    public override void Refresh()
    {
        base.Refresh();
        
        _passGroups.Clear();
        foreach (var resPassGroup in ResourceItem.GetAllByType(ResourceItem.Types.Type.GamePassGroup))
        {
            if (resPassGroup.Tab == -1)
                continue;
            
            var passGroupItem = MyPlayer.GetItemByDataID(resPassGroup.Id, checkCount: true);
            if (passGroupItem == null)
                continue;

            if (Popup_GamePass.GetMainPassItems(resPassGroup).All(x => MyPlayer.GetItemByDataID(x.Id, checkCount: true) == null))
                continue;
            
            _passGroups.Add(resPassGroup);
        }

        _passGroups.Sort((x, y) => x.Order.CompareTo(y.Order));

        
        tableElement.table.Initialize<ResourceItem, Cell>(_passGroups, (groups, idx, element) =>
        {
            element.Refresh(groups[idx]);
        });
    }
    
}
