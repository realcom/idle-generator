using System;
using System.Linq;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_SelectTrait : Popup_TraitBase<Popup_SelectTrait.TraitCell>
{
    [Serializable]
    public class TraitCell : TraitCellBase
    {
        public TextMeshProUGUI txtTitle;
        public TextMeshProUGUI txtDesc;
        
        public Image imgRarityBackground;
    }
    
    [SerializeField] 
    private SpriteContainer m_CellRarityBackgrounds;
    
    [SerializeField]
    private CustomButton m_BtnRerollTraits;
    [SerializeField]
    private TextMeshProUGUI m_TxtRerollTraits;

    protected override void OnEnable()
    {
        base.OnEnable();
        
        AddRefreshAll();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.ALL))
        {
            Refresh();
        }
    }

    public override void Refresh()
    {
        base.Refresh();

        m_BtnRerollTraits.SetActive(m_TraitType == TraitItemGroup.Types.Type.LevelUp &&
                                    MyPlayer.BoardPlayer?.RerollLevelUpSelectTrait != -1);

        using (var interactor = new ButtonInteractor(m_BtnRerollTraits))
        {
            interactor.Update(MyPlayer.BoardPlayer?.RerollLevelUpSelectTrait > 0, "NotEnoughRerollCounts".L());
        }
        
        m_TxtRerollTraits.text = "Reroll_F".L(MyPlayer.BoardPlayer?.RerollLevelUpSelectTrait ?? 0);
    }

    public void SelectRandom()
    {
        var a = levelUpSelections.Elements.PickOne();
        if (a.elementRoot != null)
            a.btnCell.onClick?.Invoke();
        else
        {
            GameBoardManager.Get().PauseBoard(GetType().Name);
            OnCancel();
        }
    }
    
    public override void OnReroll()
    {
        AddRefreshAll();
    }

    public void RerollTraits()
    {
        // GameBoardManager.Get().
        GameBoardManager.Get().UpdateRerollSelectTraitUpdate(SelectTraitUpdate.Types.Type.LevelUp, MyPlayer.Player.Id);
        GameBoardManager.Get().FlushUpdates();
    }

    protected override string GetTitleKey()
    {
        return nameof(Popup_SelectTrait) + "_Title";
    }

    protected override string GetScriptKey()
    {
        return nameof(Popup_SelectTrait) + "_Script";
    }

    protected override void RefreshCell(TraitCell cell, ResourceItem resItem, int maxRarity)
    {
        cell.txtTitle.text = resItem.ClientName;
        cell.txtDesc.text = resItem.ClientDesc;
        cell.imgIcon.sprite = resItem.ClientSpriteIcon;

        var rarity = resItem.Rarity;
        var rarityToIndex = rarity - 1;
        cell.imgRarityBackground.sprite = m_CellRarityBackgrounds[rarityToIndex];
        cell.imgRarityFrame.sprite = resItem.ClientSpriteBackground;
        cell.imgRarityNameFrame.sprite = m_CellRarityNameFrames[rarityToIndex];
        cell.txtRarity.text = resItem.Rarity.ToLocalizedRarityString();

        cell.btnCell.SetActive(false);

        cell.pdUIVFX.playableAsset = m_CellRarityAnimations[maxRarity - 1];

        cell.btnCell.SetOnClick(() =>
        {
            var gameBoardManager = GameBoardManager.Get();
            var gameBoard = gameBoardManager.gameBoard;
            gameBoardManager.ResumeBoard(GetType().Name);
            gameBoardManager.Run(() =>
            {
                gameBoard.QueueUpdate(new CompleteSelectTraitUpdate
                {
                    PlayerId = MyPlayer.Player.Id,
                    TraitDataId = resItem.Id
                });
                PlatformManager.Get().LogEvent("selectTrait_end", value: resItem.Id);
            }, 0.5f);
            
            OnCancel();
        });
    }
}
