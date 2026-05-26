using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using UnityEngine;

public class Popup_HoldingTrait : UIPopup
{
    public CustomButton btnGoToLobby;
    public CustomToggle toggleInGameSound;

    [Serializable]
    public class TraitCellRow : UIElement
    {
        public UIElementContainer<TraitCell> cells = new();
    }
    
    [Serializable]
    public class TraitTableElement : UITableElement<TraitCellRow>
    {
        
    }

    public TraitTableElement tableElement = new();
    
    protected override void Start()
    {
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.PauseBoard(nameof(Popup_HoldingTrait));
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.ALL))
        {
            btnGoToLobby.interactable = !GameBoardManager.Get().gameBoard.ResMap.LockLeaveUntilEnd;
            RefreshHoldingTraits();
        }
    }

    private void RefreshHoldingTraits()
    {
        var myPlayer = MyPlayer.BoardPlayer;
        if (myPlayer == null)
            return;

        using var traits = PooledList<ResourceItem>.Get();
        foreach (var trait in myPlayer.AppliedTraits)
        {
            if (!trait.IsValid())
                continue;
            
            var resItem = trait.GetData();
            if (resItem == null)
                continue;

            if (!resItem.CanDisplay || resItem.Category != ResourceItem.Types.Category.Trait)
                continue;
            
            traits.Add(resItem);
        }
        
        const int columnCount = 5;

        tableElement.table.Initialize<ResourceItem, TraitCellRow>(traits, (items, row, rows) =>
        {
            for (var i = 0; i < columnCount; i++)
            {
                var cell = rows.cells[i];
                var index = row * columnCount + i;
                var resItem = items.GetSafe(index);
                cell.elementRoot.SetActive(resItem != null);
                if (resItem == null)
                    continue;

                cell.Refresh(resItem);
            }
        }, Mathf.CeilToInt(traits.Count / (float)columnCount));

    }

    public void GoToLobby()
    {
        GameBoardManager.Get()?.GetModeManager<ZModeManagerBattle>()?.GoToLobby();
    }

    public override void OnCancel()
    {
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.ResumeBoard(nameof(Popup_HoldingTrait));
        base.OnCancel();
    }
}
