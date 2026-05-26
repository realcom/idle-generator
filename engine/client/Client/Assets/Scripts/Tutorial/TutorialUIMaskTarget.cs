using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class TutorialUIMaskTarget : MonoBehaviour
{
    public enum MaskTarget
    {
        None,
        TrainingTab,
        AttackStat,
        Pass,
        PassReward,
        ShopTab,
        GachaButton,
        EquipmentTab,
        Equipment,
        PetButton,
        PetGachaButton,
        PetManagementButton,
        EquipButton,
        TrainingCell,
        LobbyTab,
        EnterChapterButton,
    }

    public MaskTarget maskTarget = MaskTarget.None;
    public RectTransform rt;

    public static readonly Dictionary<MaskTarget, TutorialUIMaskTarget> MaskTargets = new();
    private void Awake()
    {
        if (maskTarget != MaskTarget.None)
            MaskTargets[maskTarget] = this;
    }
}
