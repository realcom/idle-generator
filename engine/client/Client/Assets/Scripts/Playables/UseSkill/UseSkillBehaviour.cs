using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class UseSkillBehaviour : ZPlayableBehaviour
{
    public enum UseSkillType
    {
        AddSkill, //Default
        UnitUseSkill,
        OwnerUseSkill,
    }

    public UseSkillType useSkillType = UseSkillType.AddSkill;
    public AttackBehaviour.UseSkillSettings settings;
}
