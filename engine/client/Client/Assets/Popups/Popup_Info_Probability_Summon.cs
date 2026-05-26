using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Interfaces;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Info_Probability_Summon : Popup_Gacha_Probability
{
    public TextMeshProUGUI txtLevel;
    
    public CustomButton btnPrevLevel;
    public CustomButton btnNextLevel;

    private int level = 1;
    
    public override void Initialize(ResourceItem inResSummonLevelItem)
    {
        base.Initialize(inResSummonLevelItem);
        
        level = MyPlayer.GetItemByDataID(inResSummonLevelItem.Id)?.Level ?? 1;
    }

    protected override void Start()
    {
        btnNextLevel.SetOnClick(() =>
        {
            level++;
            Refresh();
        });
        
        btnPrevLevel.SetOnClick(() =>
        {
            level--;
            Refresh();
        });
        
        base.Start();
    }

    public override void Refresh()
    {
        txtLevel.text = "Level".L(level);
        
        btnPrevLevel.SetActive(level > 1);
        btnNextLevel.SetActive(level < resGachaItem.MaxLevel);

        var aig = resGachaItem.AddItemGroups.First(x => x.Level == level);
        RefreshTable(aig);
    }

    protected override void RefreshByFlag()
    {
    }

}
