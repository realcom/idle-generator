using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_SelectEventDungeon : UIPopup, IGoodsViewer
{
    public GoodsContainer goodsContainer;

    [Serializable]
    public class DungeonCell : UIElement
    {
        public RedDot redDot;
        
        public CustomButton btnCell;
        
        public Image imgBanner;
        public TextMeshProUGUI txtDungeonName;

        public RectTransform rtRewardRoot;
        public Image imgRewardIcon;
        public TextMeshProUGUI txtReward;

        public RectTransform rtProgressStepRoot;
        public Image imgProgressStepIcon;
        public TextMeshProUGUI txtProgressStep;

        public RectTransform rtHighestDifficultyRoot;
        public TextMeshProUGUI txtHighestDifficulty;
        
        public RectTransform rtTicketRoot;
        public Image imgTicketIcon;
        public TextMeshProUGUI txtTicket;

        public RectTransform rtRankingRoot;
        public TextMeshProUGUI txtRanking;

        public void Refresh(int mapMetaId)
        {
            var mapMeta = ResourceMap.Get(mapMetaId)!;

            var resUnClearedDungeon = mapMeta.GetUnclearedMap();
            
            redDot.Register(mapMeta);

            imgBanner.sprite = mapMeta.GetSpriteByKey("Banner");
            txtDungeonName.text = mapMeta.ClientName;

            rtRewardRoot.SetActive(imgRewardIcon.sprite = mapMeta.GetSpriteByKey("RewardIcon"));
            txtReward.text = mapMeta.GetLocalizedString("RewardList");

            var progressStepString = resUnClearedDungeon.GetMapProgressStepString();
            rtProgressStepRoot.SetActive(resUnClearedDungeon.Stage == 0);
            imgProgressStepIcon.sprite = mapMeta.GetSpriteByKey("ProgressStepIcon");
            txtProgressStep.text = progressStepString;

            rtHighestDifficultyRoot.SetActive(resUnClearedDungeon.Stage > 0);
            txtHighestDifficulty.text = progressStepString;

            var hasTicket = resUnClearedDungeon.EntryMaterialItemGroups.Any();
            rtTicketRoot.SetActive(hasTicket);
            if (hasTicket)
            {
                var entryMaterial = resUnClearedDungeon.EntryMaterialItemGroups.First().MaterialItems.First();
                var resTicketItem = entryMaterial.GetData();
                imgTicketIcon.sprite = resTicketItem.ClientSpriteIcon;
                txtTicket.text = MyPlayer.GetItemByDataID(resTicketItem.Id)?.GetCountString() ?? string.Empty;    
            }

            btnCell.SetOnClick(resUnClearedDungeon.ShowJoinPopup);
        }
    }

    [Serializable]
    public class TableElement : UITableElement<DungeonCell>
    {
    }

    public TableElement tableElement = new();

    [Serializable]
    public class TabElement : UITabBar.BasicTabElement
    {
        public Image imgIcon;
    }
    
    public UITabBar tabBar;
    public UIElementContainer<TabElement> tabElements = new();

    private SortedDictionary<int, List<ResourceMap>> _mapsByTab = new();
    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);
        
        using var dungeonMetas = PooledList<ResourceMap>.Get();
        dungeonMetas.AddRange(ResourceMap.GetAllByTargetPopupName(nameof(Popup_SelectEventDungeon)));
        dungeonMetas.RemoveAll(x => !x.CanDisplay || x.Id != x.Group);
        
        foreach (var meta in dungeonMetas)
        {
            var tab = meta.GetTargetPopupArgument(0);

            if (!_mapsByTab.TryGetValue(tab, out var list))
                _mapsByTab[tab] = list = new();
            
            list.Add(meta);
        }

        foreach (var (element, _, (tab, metas)) in tabBar.AllocateTabs(tabElements, _mapsByTab, OnTabSelected))
        {
            var tabDefs = CRC.Get().GetTabDefinitionsByKey(nameof(Popup_SelectEventDungeon));
            var tabDef = tabDefs[tab];
            element.txtName.text = tabDef.tabName;
            element.imgIcon.sprite = tabDef.tabIcon;
            element.redDot.Register(metas);
        }

        var defaultTab = 0;
        if (tokens.Length > 0)
            defaultTab = int.Parse(tokens[0]);
        
        tabBar.selectedIndex = defaultTab;
        tabBar.RefreshTab();
    }
    
    private void OnTabSelected(int index)
    {
        AddRefreshFlag(RefreshFlag.ALL);
    }

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshTable(_mapsByTab[tabBar.selectedIndex]);
    }

    private void RefreshTable(List<ResourceMap> dungeonGroups)
    {
        tableElement.table.Initialize<ResourceMap, DungeonCell>(dungeonGroups, (groups, idx, element) =>
        {
            element.Refresh(groups.GetSafe(idx)?.Id ?? 0);
        });        
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED))
        {
            RefreshGoods();
        }

        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh();
        }
    }

    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds(nameof(Popup_SelectEventDungeon)));
    }

    public void RefreshGoods(IList<int> goodsIds)
    {
        goodsContainer.RefreshGoods(goodsIds);
    }
}
