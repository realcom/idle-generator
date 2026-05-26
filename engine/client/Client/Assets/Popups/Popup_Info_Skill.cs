using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Interfaces;
using TMPro;
using UnityEngine;

public class Popup_Info_Skill : UIPopup
{
    public TextMeshProUGUI txtName;
    public ItemCellBehaviourWrapperElement petCell;

    [Serializable]
    public class TableElement : UITableElement<SkillInfoCell_Expanded>
    {
    }
    
    public TableElement tableElement = new();

    [Serializable]
    public class SkillInfoCell : UIElement
    {
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtLevel;
        public TextMeshProUGUI txtDesc;

        public virtual void Refresh(ResourceSkill resSkill, int level)
        {
            if (txtName)
                txtName.text = resSkill.ClientName;

            if (txtLevel)
                txtLevel.text = "Level".L(level);

            if (txtDesc)
                txtDesc.text = resSkill.ClientDesc;
        }
    }

    [Serializable]
    public class SkillInfoCell_Expanded : SkillInfoCell
    {
        public GameObject goDim;
    }

    public void Initialize(IItemModelViewFormatter formatter)
    {
        petCell.Get<PetCell>().Refresh(formatter);
        var petLevel = formatter.GetLevel();
        var resItem = formatter.GetData()!;

        txtName.text = ResourceSkill.Get(resItem.EquipSkillDataIds.GetClamped(petLevel - 1))!.ClientName;

        using var dict = PooledDictionary<int, int>.Get();
        var focusIdx = 0;
        for (var i = 0; i < resItem.EquipSkillDataIds.Count; i++)
        {
            if (i == 0 || resItem.EquipSkillDataIds[i] != resItem.EquipSkillDataIds[i - 1])
            {
                var level = i + 1;
                dict.Add(resItem.EquipSkillDataIds[i], level);

                if (petLevel >= level)
                {
                    focusIdx = Math.Max(focusIdx, i);
                }
            }
        }

        
        tableElement.table.Initialize<KeyValuePair<int, int>, SkillInfoCell_Expanded>(dict, (pairs, idx, cell) =>
        {
            var skillDataId = pairs[idx].Key;
            var level = pairs[idx].Value;
            var resSkill = ResourceSkill.Get(skillDataId)!;
            cell.Refresh(resSkill, level);
            cell.goDim.SetActive(petLevel < level);
        });

        tableElement.table.ScrollToIndex(focusIdx);
    }

    protected override void RefreshByFlag()
    {
        
    }

}
