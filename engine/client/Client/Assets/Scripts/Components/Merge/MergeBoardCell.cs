using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using DG.Tweening;
using DG.Tweening.Core;
using DG.Tweening.Plugins.Options;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class MergeBoardCell : MergeBoardCellBase
{
    public RectTransform rtDragDropRoot;
    
    private Sequence _fxSequence;
    private Coroutine _fxCoroutine;
    
    private float _prevRemaining;
    public bool isDisabled { get; private set; }

    public MergeBoard parentBoard => (MergeBoard)parentBoardBase;

    private void Update()
    {
        RefreshCoolTime();
    }

    private bool _isUsingSkill;
    private void RefreshCoolTime()
    {
        if (resSkill == null || playerItem == null || !inventoryItemImage || isDisabled || _isUsingSkill)
            return;
        
        var myGameUnit = MyGameUnitObject.Get()?.gameUnit;
        
        if (myGameUnit == null)
            return;
        
        var remaining = myGameUnit.GetSkillCooldown(resSkill.Id, (int)playerItem.Id);
        
        var max = resSkill.Cooldown;
        var cooldown = ((float)remaining / max).Clamp01();

        if (_prevRemaining < remaining) // 스킬을 쓴 직후
        {
            _isUsingSkill = true;
            
            inventoryItemImage.imgCoolTimeFill.fillAmount = 0;
            inventoryItemImage.imgItem.transform.DOPunchScale(Vector3.one * 0.3f, 0.5f, 1, 0).OnComplete(() =>
            {
                _isUsingSkill = false;
            });
            _prevRemaining = (float)remaining;
            return;
        }
        
        _prevRemaining = (float)remaining;
        
        if (Math.Abs(inventoryItemImage.imgCoolTimeFill.fillAmount - cooldown) > float.Epsilon)
            inventoryItemImage.imgCoolTimeFill.fillAmount = cooldown;
    }

    public override void Refresh(int index, PlayerItemMessage item, MergeBoardBase parentBoard, MergeBoardCellBase baseCell, bool hideCell = false)
    {
        isDisabled = hideCell;
        base.Refresh(index, item, parentBoard, baseCell, hideCell);
    }

    protected override bool HideThis(MergeBoardBase parentBoard)
    {
        var board = (MergeBoard)parentBoard;
        
        var floatingIndex = -1;
        if (board.dragDropParent.floatingObject)
            floatingIndex = board.dragDropParent.floatingObject.index;
            
        var thisIndex = index;
        return floatingIndex == thisIndex;
    }
}
