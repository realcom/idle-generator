using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;

public partial class Utility
{
    public static string ToLocalizedString(this ResourceItem.Types.WeaponCategory category)
    {
        return $"WeaponCategory_{category}".L();
    }

    public static string ToLocalizedRarityString(this int rarity)
    {
        return $"Rarity_{rarity}".L();
    }
    
    public static string ToLocalizedGradeString(this int grade, int extraGrade = 0)
    {
        return $"Grade_{grade + 100 * extraGrade}".L();
    }
    
    public static string ToLocalizedTierString(this int tier)
    {
        if (tier == 0)
            return string.Empty;
        
        return $"Tier_{tier}".L(tier);
    }
    
    public static string ToLocalizedPotentialGradeString(this int potentialGrade)
    {
        return $"PotentialGrade_{potentialGrade}".L();
    }
    
    public static string ToLocalizedLevelString(this int level)
    {
        return "Level".L(level);
    }

}
