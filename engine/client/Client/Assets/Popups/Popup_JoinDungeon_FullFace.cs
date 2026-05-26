using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class Popup_JoinDungeon_FullFace : Popup_JoinDungeonBase
{
    public Color[] detailInfoColors = {
        Color.white,
        Color.white
    };
    
    public UnitUIRenderer[] unitUIRenderers = new UnitUIRenderer[0];
    public CustomButton btnEnter;
    
    public override bool Initialize(ResourceMap resMap)
    {
        if (!base.Initialize(resMap))
            return false;
        
        btnEnter.SetOnClick(() =>
        {
            GameBoardManager.Get().GoToMapLocalToNet(_resMap.Id).Forget();
        });
        
        foreach (var (element, i, inText) in detailInfoCells.GetElements(_resMapMeta.GetLocalizedStrings("DetailInfo")))
        {
            element.imgCell.color = detailInfoColors[i % detailInfoColors.Length];
        }

        var step = resMap.GetProgressStep();
        txtDungeonStep.text = $"Popup_JoinDungeon_FullFace_{resMap.Id}".L(step.ToString());

        var addItems = ResourceAchievement.Get(resMap.ReferenceAchievementDataIds.GetClamped(step - 1))!.RewardAddItemGroups.GetAddItems();
        foreach (var (element, index, addItem) in rewardCells.GetElements(addItems))
        {
            element.Get<ItemCell>().Refresh(addItem);
        }

        var monsterDataIdsByStep = CRC.Get().appearMonsterDataIdsByMapId.GetValueOrDefault(resMap.Id);
        if (monsterDataIdsByStep != null)
        {
            for (var i = 0; i < unitUIRenderers.Length; i++)
            {
                var unitIds = monsterDataIdsByStep[(step - 1) % monsterDataIdsByStep.Count];
                unitUIRenderers[i].Initialize(ResourceUnit.Get(unitIds.GetClamped(i)));
            }
        }

        return true;
    }
    
}
