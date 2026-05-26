using System.Collections;
using System.Collections.Generic;
using Febucci.UI;
using Febucci.UI.Core.Parsing;
using UnityEngine;

public static partial class Utility
{
    public static void ModifyModiferValues(this AnimationRegion[] regions, string modifierName, float value)
    {
        foreach (var region in regions)
        {
            foreach (var range in region.ranges)
            {
                for (var i = 0; i < range.modifiers.Length; i++)
                {
                    if (range.modifiers[i].name == modifierName)
                        range.modifiers[i] = new ModifierInfo()
                        {
                            name = modifierName,
                            value = value
                        };
                }
            }
        }
    }
    
    public static void ModifyModiferValues(this AnimationRegion[] regions, ModifierInfo info)
    {
        if (regions == null)
            return;

        foreach (var region in regions)
        {
            if (region == null || region.ranges == null)
                continue;

            foreach (var range in region.ranges)
            {
                if (range.modifiers == null)
                    continue;

                for (var i = 0; i < range.modifiers.Length; i++)
                {
                    if (range.modifiers[i].name == info.name)
                        range.modifiers[i] = info;
                }
            }
        }
    }
    
}
