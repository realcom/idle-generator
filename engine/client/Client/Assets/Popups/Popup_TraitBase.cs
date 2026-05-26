using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Utility.ObjectPool;
using TMPro;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Pool;
using UnityEngine.Timeline;
using UnityEngine.UI;

using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

[Serializable]
public abstract class TraitCellBase : UIElement
{
    public CustomButton btnCell;
    public Image imgIcon;
    public TextMeshProUGUI txtRarity;
    public Image imgRarityFrame;
    public Image imgRarityNameFrame;
        
    public PlayableDirector pdUIVFX;
    
}

public interface IPopup_Trait
{
    public void Initialize();
    public void OnReroll();
}

public static class Popup_TraitHelper
{
    public static IPopup_Trait ShowTraitPopup(GameBoard gameBoard)
    {
        var shouldAddAll = gameBoard.Variables.GetInt((int)SelectTraitShouldAddAll) == 1;
        return shouldAddAll ? GameManager.Get().GetOrShowPopup<Popup_GotTraits>() : GameManager.Get().GetOrShowPopup<Popup_SelectTrait>();
    }
}

public abstract class Popup_TraitBase<TTraitCellType> : UIPopup, IPopup_Trait where TTraitCellType : TraitCellBase, new()
{
    public UIElementContainer<TTraitCellType> levelUpSelections = new();
    
    [SerializeField] protected PlayableAsset[] m_CellRarityAnimations = new PlayableAsset[0];
    
    [SerializeField] protected PlayableDirector m_RootAnimation;
    [SerializeField] protected PlayableAsset[] m_RootAnimations = new PlayableAsset[0];
    
    [SerializeField] 
    protected SpriteContainer m_CellRarityNameFrames;
    
    [SerializeField]
    protected UnitUIRenderer m_UnitUIRenderer;
    
    [SerializeField]
    protected TextMeshProUGUI m_txtTitle;
    [SerializeField] 
    protected TextMeshProUGUI m_txtScript;

    [SerializeField] protected GameObject m_SkipTrigger;

    private int m_TraitCount = 0;
    
    protected TraitItemGroup.Types.Type m_TraitType;

    protected abstract string GetTitleKey();
    protected abstract string GetScriptKey();

    protected abstract void RefreshCell(TTraitCellType cell, ResourceItem resItem, int maxRarity);
    public void Initialize()
    {
        
        
        UnfreezeInteraction();
        m_SkipTrigger.SetActive(false);
        
        var gameBoardManager = GameBoardManager.Get();
        var gameBoard = gameBoardManager.gameBoard;
        if (gameBoard == null || MyPlayer.GameUnit == null || gameBoard.ResMap == null)
        {
            gameObject.SetActive(false);
            return;
        }
        
        var unitDataId = gameBoard.Variables.GetInt((int)SelectTraitUnitDataId);
        m_TraitType = (TraitItemGroup.Types.Type)gameBoard.Variables.GetInt((int)SelectTraitType);
        var resUnit = ResourceUnit.Get(unitDataId);
        if (resUnit == null)
        {
            gameObject.SetActive(false);
            return;
        }
        
        using var resTraits = PooledList<ResourceItem>.Get();
        for (var i = 0; i < 5; i++)
        {
            var traitDataId = gameBoard.Variables.GetInt((int)SelectTraitUnitDataId + 1 + i);
            if (traitDataId != 0)
            {
                var statResItem = ResourceItem.Get(traitDataId);
                if (statResItem != null)
                    resTraits.Add(statResItem);
                else
                    Debug.LogError($"choice data Not Found: {traitDataId}");
            }
        }
        
        if (resTraits.Count  == 0)
        {
            gameObject.SetActive(false);
            return;
        }
        
        m_TraitCount = resTraits.Count;
        
        m_txtTitle.text = resUnit.GetLocalizedString(GetTitleKey());
        m_txtScript.text = resUnit.GetLocalizedString(GetScriptKey());
        
        m_UnitUIRenderer.Initialize(resUnit);
        
        m_RootAnimation.playableAsset = m_RootAnimations[0];
        m_RootAnimation.time = 0;
        m_RootAnimation.Play();
        bShowBoard = false;

        if (resTraits.Count > 0)
        {
            var maxRarity = resTraits.Max(x => x.Rarity);
            foreach (var (cell, index, choiceResItem) in levelUpSelections.GetElements(resTraits))
            {
                RefreshCell(cell, choiceResItem, maxRarity);
            }

            // 먼저 선택지 리스트 초기화 후 setActive는 애니메이션 보여주면서
            AudioManager.Get().PlayFX("Levelup_1");
            gameBoardManager.PauseBoard(GetType().Name);

            string candidates = "";
            for (int i = 0; i < resTraits.Count; i++)
            {
                if (i > 0) candidates += ",";
                candidates += resTraits[i].Id.ToString();
            }

            PlatformManager.Get().LogEvent(
                "selectTrait_start", 
                ("TraitType", m_TraitType.ToString()),
                ("UnitDataId", resUnit.Id.ToString()),
                ("Candidates", candidates)
            );
            
            // gameBoardManager.Run(() =>
            // {
            //     // 0.3초 뒤 게임 일시정지
            //     
            // }, .5f);
        }
        else
        {
            OnCancel();
        }
        
    }
    
    public abstract void OnReroll();
    
    private bool bShowBoard;
    public void ToggleDisplayBoard()
    {
        bShowBoard = !bShowBoard;
        m_RootAnimation.playableAsset = bShowBoard ? m_RootAnimations[2] : m_RootAnimations[1];
        m_RootAnimation.time = 0;
        m_RootAnimation.Play();
    }
    
    public override void OnCancel()
    {
        if (bShowBoard)
        {
            ToggleDisplayBoard();
            m_RootAnimation.time = m_RootAnimation.duration;
            m_RootAnimation.Evaluate();
        }
        
        PlayClick();
        
        base.OnCancel();
    }

    protected override void OnHideImpl()
    {
        gameObject.SetActive(false);
    }

    public void PlayCellAnimations()
    {
        var minTime = double.MaxValue;
        foreach (var (cell, index) in levelUpSelections.GetElements(m_TraitCount))
        {
            cell.pdUIVFX.time = 0f;
            cell.pdUIVFX.Play();
            
            var timelineAsset = (TimelineAsset)cell.pdUIVFX.playableAsset;
            var marker = timelineAsset.GetOutputTrack(0).GetMarker(0);
            minTime = Math.Min(minTime, marker.time);
        }
        
        m_SkipTrigger.SetActive(true);

        this.Run(() =>
        {
            m_SkipTrigger.SetActive(false);
        }, (float)minTime);
    }

    public void SkipCellAnimations()
    {
        foreach (var (cell, index) in levelUpSelections.GetElements(m_TraitCount))
        {
            var timelineAsset = (TimelineAsset)cell.pdUIVFX.playableAsset;
            var marker = timelineAsset.GetOutputTrack(0).GetMarker(0);
            cell.pdUIVFX.time = marker.time;
            cell.pdUIVFX.Evaluate();
        }
        
        m_SkipTrigger.SetActive(false);
    }
}
