using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Types.Players;
using Commons.Utility;
using Interfaces;
using UnityEngine;
using UnityEngine.UI;

public class LevelStars : MonoBehaviour
{
    [Serializable]
    public class LevelStar : UIElement
    {
        public Image imgStar;
    }
    
    public UIElementContainer<LevelStar> stars = new();

    public void Refresh(IItemModelViewFormatter formatter)
    {
        var level = formatter?.GetLevel() ?? 0;
        Refresh(level);
    }

    public virtual void Refresh(int level)
    {
        if (level < Constants.STAR_GRADE_UNIT)
        {
            stars.elementParent.SetActive(false);
            return;
        }

        var starSpriteIndex = (level - Constants.STAR_GRADE_UNIT) / (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT);
        var starCount = level % (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT) / Constants.STAR_GRADE_UNIT;
        if (starCount == 0)
            starCount = Constants.STAR_GRADE_UNIT;
        
        foreach (var (element, i) in stars.GetElements(starCount))
        {
            element.imgStar.sprite = CRC.Get().levelStarSprites.GetClamped(starSpriteIndex);
        }
    }

    public static int GetStarIndex(int level)
    {
        return  level % (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT) / Constants.STAR_GRADE_UNIT;
    }
    
    public static int GetStarCount(int level)
    {
        if (level < Constants.STAR_GRADE_UNIT)
            return 0;

        var starCount = level % (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT) / Constants.STAR_GRADE_UNIT;
        if (starCount == 0)
            starCount = Constants.STAR_GRADE_UNIT;

        return starCount;
    }
    
    public static int GetStarSpriteIndex(int level)
    {
        if (level < Constants.STAR_GRADE_UNIT)
            return 0;

        return (level - Constants.STAR_GRADE_UNIT) / (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT);
    }
    
    public static bool IsChanged(int oldLevel, int newLevel)
    {
        var oldSpriteIndex = GetStarSpriteIndex(oldLevel);
        var newSpriteIndex = GetStarSpriteIndex(newLevel);
        if (oldSpriteIndex != newSpriteIndex)
            return true;
        
        var oldStarCount = GetStarCount(oldLevel);
        var newStarCount = GetStarCount(newLevel);
        if (oldStarCount != newStarCount)
            return true;
        
        return false;
    }
    
}
