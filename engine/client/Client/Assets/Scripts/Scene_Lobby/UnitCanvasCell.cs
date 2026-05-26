using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using DG.Tweening;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class UnitCanvasCell : WorldUICanvasCell
{
    public GameObject panelHp;
    public Slider sliderHp;
    public Image imgSliderHpFill;
    public Slider sliderFakeHp;
    public Image imgSliderFakeHpFill;
    
    public Image imgShield;
    public TextMeshProUGUI txtShield;

    public ParticleSystem particleSystem;

    [Serializable]
    public class BuffCell : UIElement
    {
        public Image imgIcon;
        public TextMeshProUGUI txtStack;
        public TextMeshProUGUI txtLevel;
    }

    public UIElementContainer<BuffCell> buffCells = new();
    
    public void EmitShieldParticle(Vector2 worldPos)
    {
        var emitParams = new ParticleSystem.EmitParams()
        {
            position = worldPos
        };
        particleSystem.Emit(emitParams, 1);
    }

    public void OnAttracted()
    {
        var unit = GameBoardManager.Get().GetUnitByID(unitId);
        if (unit != null)
        {
            unit.unitSkin.FlushHitEffect(CRC.Get().globalParameters.playerShieldHealEffectColor);
        }
    }

    private long unitId = 0;
    public override void Initialize(GameUnitObject unit)
    {
        unit.unitCanvasCell = this;
        sliderHp.value = 1;
        if (unit.gameUnit != null)
        {
            name = $"UnitCanvasCell@{unit.gameUnit.GetId()}@{unit.ResUnit.Id}";
            RefreshGrade(unit.gameUnit.ResUnit);
            RefreshArmorType(unit.gameUnit.ResUnit);

            var team = unit.gameUnit.Team;

            panelHp.transform.localScale = CRC.Get().GetUnitHpBarScale(team);

            imgSliderHpFill.sprite = CRC.Get().GetUnitHpBarFillSprite(team);
            imgSliderHpFill.color = CRC.Get().GetUnitHpBarFillColor(team);
            imgSliderFakeHpFill.sprite = CRC.Get().GetUnitHpBarFillFakeSprite(team);
            imgSliderFakeHpFill.color = CRC.Get().GetUnitHpBarFillFakeColor(team);
            
            UpdateHP(unit.gameUnit.Hp, unit.gameUnit.MaxHp, false);
            UpdateShield(unit.gameUnit.Shield, unit.gameUnit.MaxHp, false);

            RefreshBuffCells(unit);
        }

        unitId = unit.syncId;
    }

    private Tweener fakeHpTweener = null;
    public void UpdateHP(long hp, long maxHP, bool animated)
    {
        var value = hp / (float)maxHP;
        value = float.IsNaN(value) ? 0 : value;

        sliderHp.value = value;

        fakeHpTweener ??= DOTween.To(v =>
        {
            sliderFakeHp.value = Mathf.Lerp(sliderFakeHp.value, sliderHp.value, v);
        }, 0f, 1f, 0.3f).SetDelay(0.3f).OnComplete(() => fakeHpTweener = null);
    }
    
    public void UpdateMP(long mp, long maxMP, bool increase, bool animated)
    {
    }

    public void UpdateShield(long shield, long maxHP, bool animated)
    {
        imgShield.SetActive(shield > 0);
        txtShield.text = $"<sprite name=icn_shield> {shield}";
    }
    
    public void ShowArrow(bool bActive, float duration = float.PositiveInfinity)
    {
        return;
    }

    public void RefreshGrade(ResourceUnit resUnit)
    {
    }

    public void RefreshArmorType(ResourceUnit resUnit)
    {
    }

    public void RefreshBuffCells(GameUnitObject unit)
    {
        using var forDisplayBuffs = PooledList<GameBuff>.Get();
        foreach (var gameBuff in unit.gameUnit?.Buffs.Values ?? Enumerable.Empty<GameBuff>())
        {
            if (gameBuff?.ResBuff == null)
                continue;

            if (!gameBuff.ResBuff.ContainsTag(Tag.DisplayOnUnit))
                continue;

            if (!gameBuff.Enabled)
                continue;
            
            forDisplayBuffs.Add(gameBuff);
        }
        
        foreach (var (element, i, gameBuff) in buffCells.GetElements(forDisplayBuffs))
        {
            element.imgIcon.sprite = gameBuff.ResBuff.ClientSpriteIcon;
            element.txtStack.text = gameBuff.ResBuff.GetLocalizedString("StackFormat").GetParsedString(gameBuff.Stack);
            element.txtStack.SetActive(gameBuff.ResBuff.ContainsTag(Tag.DisplayStack));
            element.txtLevel.text = gameBuff.ResBuff.GetLocalizedString("LevelFormat").GetParsedString(gameBuff.Level);
            element.txtLevel.SetActive(gameBuff.ResBuff.ContainsTag(Tag.DisplayLevel));
        }
    }
    
}
