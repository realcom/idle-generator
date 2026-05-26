

using System;
using System.Collections.Generic;
using Commons.Game;
using Commons.Resources;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// All the buttons in the game play an animation when they are pressed. This class, modeled after Unity's Button,
/// enables that behavior.
/// </summary>
public class ZSkillButton : ZButton
{
    public Image imgIcon;
    
    public GameObject goEquipped;
    public GameObject goNotEquipped;
    public GameObject goStack;
    
    public Image imgCoolTimeFill;
    public TextMeshProUGUI txtCooldown;
    public TextMeshProUGUI txtStack;
    
    public Image imgHighlight;

    [NonSerialized] 
    public ResourceSkill resSkill;
    [NonSerialized] 
    public ResourceItem resSkillItem;
    
    private bool _isRestricted;
    
    private float _prevRemaining;
    
    public void Initialize(ResourceItem resSkillItem, Action callback)
    {
        this.resSkillItem = resSkillItem;
        var resSkill = ResourceSkill.Get(resSkillItem.SkillDataId);
        
        imgIcon.sprite = resSkillItem.ClientSpriteIcon;
        
        Initialize(resSkill, callback);
        RefreshStack();
    }

    public void Initialize(ResourceSkill resSkill, Action callback)
    {
        this.resSkill = resSkill;
        _isRestricted = false;
        
        // goEquipped.SetActive(resSkill != null);
        // goNotEquipped.SetActive(resSkill == null);
        
        this.SetOnClick(() =>
        {
            callback?.Invoke();
        });
    }

    private void RefreshStack()
    {
        if (resSkill == null)
            return;
        
        var mySkillItem = MyPlayer.GetItemByDataID(resSkillItem.Id);
        
        var stackCnt = mySkillItem.GetCount();
        txtStack.text = stackCnt.ToString();
        txtStack.color = stackCnt <= 0 ? CRC.Get().notEnoughColor : Color.white;
    }

    private const float OnlyOnceCoolTime = 999f; 
    private void RefreshCoolTime()
    {
        if (resSkill == null || _isRestricted)
            return;
        
        var nowTick = GameBoardManager.Get().gameBoard.Tick;

        var remainingTick = 0L;
        var canUseSkill = false;
        var everyUnitAlive = true;
        foreach (var gameUnit in GameBoardManager.Get().gameBoard.Units.Values)
        {
            if (gameUnit == null || gameUnit.PlayerId != MyPlayer.Player.Id || (!gameUnit.IsAlive && !resSkill.ContainsTag(Tag.IgnoreAlive)))
                continue;
            
            var coolDownUntil = gameUnit.Cooldowns.GetValueOrDefault(resSkill.Id, nowTick);
            
            var tempRemainingTick = (int)coolDownUntil - nowTick;
            if (tempRemainingTick > 0)
                remainingTick = Math.Max(remainingTick, tempRemainingTick);

            // 모두가 false이면 false인 걸로.
            canUseSkill |= gameUnit.CanUseSkill(resSkill.ItemDataId);
            
            everyUnitAlive &= gameUnit.IsAlive;
        }

        var blockSkill = false;
        // TODO: add btn interactor strings
        if (resSkill.ContainsTag(Tag.SelfRespawnWhenDead))
            blockSkill = everyUnitAlive;
        
        if (GameBoard.TicksToTime((uint)remainingTick) > OnlyOnceCoolTime)
            blockSkill = true;

        if (resSkillItem != null && MyPlayer.GetItemByDataID(resSkillItem.Id).GetCount() <= 0)
            blockSkill = true;

        var remaining = GameBoard.TicksToTime((uint)remainingTick);
        var max = resSkill.Cooldown;
        var cooldown = ((float)remaining / max).Clamp01();

        // 쿨타임이 감소한 경우 highlight
        if (max > 0.5f && _prevRemaining - remaining > 0.5f)
        {
            imgHighlight.color = Color.white;
            imgHighlight.DOFade(0, 0.3f);
        }

        _prevRemaining = (float)remaining;
        
        if (blockSkill)
            imgCoolTimeFill.fillAmount = 1;
        else if (Math.Abs(imgCoolTimeFill.fillAmount - cooldown) > float.Epsilon)
            imgCoolTimeFill.fillAmount = cooldown;
        else if (cooldown == 0 && !canUseSkill)
            imgCoolTimeFill.fillAmount = 1;

        if (remaining >= OnlyOnceCoolTime)
            txtCooldown.text = "OneTimeUse".L();
        else if (remaining >= 1f)
            txtCooldown.text = ((int) Math.Ceiling((float)remaining)).ToString();
        else if (remaining > 0f)
            txtCooldown.text = remaining.ToString("F1");
        else
            txtCooldown.text = "";
        
        GetInteractor().Update(cooldown <= 0f && canUseSkill && !blockSkill).Apply();
    }
    
    protected override void Update()
    {
        base.Update();
        
        RefreshCoolTime();
        RefreshStack();
    }
}