using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Packets.Updates;
using Commons.Resources;
using UnityEngine;

public class Popup_GotTraits : Popup_TraitBase<Popup_GotTraits.TraitCell>
{
    [Serializable]
    public class TraitCell : TraitCellBase
    {
    }

    protected override void RefreshByFlag()
    {
        
    }

    protected override string GetTitleKey()
    {
        return nameof(Popup_GotTraits) + "_Title";
    }

    protected override string GetScriptKey()
    {
        return nameof(Popup_GotTraits) + "_Script";
    }

    protected override void RefreshCell(TraitCell cell, ResourceItem resItem, int maxRarity)
    {
        cell.imgIcon.sprite = resItem.ClientSpriteIcon;

        var rarity = resItem.Rarity;
        var rarityToIndex = rarity - 1;
        cell.imgRarityFrame.sprite = resItem.ClientSpriteBackground;
        cell.imgRarityNameFrame.sprite = m_CellRarityNameFrames[rarityToIndex];
        cell.txtRarity.text = resItem.Rarity.ToLocalizedRarityString();

        cell.btnCell.SetActive(false);

        cell.pdUIVFX.playableAsset = m_CellRarityAnimations[maxRarity - 1];

        cell.btnCell.SetOnClick(() => resItem.ShowInfoPopup());
    }

    public override void OnReroll()
    {
        
    }

    public void Continue()
    {
        var gameBoardManager = GameBoardManager.Get();
        var gameBoard = gameBoardManager.gameBoard;
        gameBoardManager.ResumeBoard(GetType().Name);
        gameBoardManager.Run(() =>
        {
            gameBoard.QueueUpdate(new CompleteSelectTraitUpdate
            {
                PlayerId = MyPlayer.Player.Id,
                TraitDataId = 0
            });    
        }, 0.5f);
        OnCancel();
    }
    
}
