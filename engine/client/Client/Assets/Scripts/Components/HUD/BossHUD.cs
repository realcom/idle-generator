using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class BossHUD : ZEventBehaviour
{
    public Animator animator;
    public TextMeshProUGUI txtBossName;
    public LazySlider lazySliderHp;

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            {
                foreach (var gameUnitObject in GameBoardManager.Get().UnitObjectById.Values)
                {
                    OnCreated(gameUnitObject);
                }
                break;
            }
            case GameEventType.UnitCreated:
            {
                if (e.args.GetSafe(0) is not GameUnitObject unitObject)
                    return;
                
                OnCreated(unitObject);
                break;
            }
            case GameEventType.UnitHpUpdated:
            {
                if (e.args.GetSafe(0) is not GameUnitObject unitObject)
                    return;
                
                RefreshBoss(unitObject);
                break;
            }
        }
    }

    private void OnCreated(GameUnitObject bossUnitObject)
    {
        if (bossUnitObject.ResUnit.Type != ResourceUnit.Types.Type.Boss)
            return;
        
        RefreshBoss(bossUnitObject);

        if (animator)
            animator.Play(AnimatorHash.Start, -1, 0.0f);
    }

    private void RefreshBoss(GameUnitObject bossUnitObject)
    {
        if (bossUnitObject.ResUnit.Type != ResourceUnit.Types.Type.Boss)
            return;
        
        var bossUnit = bossUnitObject.gameUnit;
        if (bossUnit == null)
            return;
        
        txtBossName.text = bossUnit.ResUnit.Name;
        var hp = bossUnit.Hp;
        var maxHp = bossUnit.MaxHp;

        RefreshHp(hp, maxHp);

        if (!bossUnit.IsAlive)
        {
            if (animator)
                animator.Play(AnimatorHash.Hide, -1, 0.0f);
        }
    }
    
    private void RefreshHp(float hp, float maxHp)
    {
        lazySliderHp.Set(hp / maxHp);
    }
    
}
