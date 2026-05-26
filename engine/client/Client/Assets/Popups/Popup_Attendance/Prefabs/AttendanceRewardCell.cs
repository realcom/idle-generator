using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using TMPro;
using UnityEngine;

public class AttendanceRewardCell : MonoBehaviour
{
    public GameObject goCompleted;
    public GameObject goDimmed;
    public TextMeshProUGUI txtDay;

    public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();

    public void Refresh(ResourceAchievement resAchievement)
    {
        var achievement = MyPlayer.GetAchievementByDataID(resAchievement.Id);
        goCompleted.SetActive(achievement.State == PlayerAchievementMessage.Types.State.InProgress);
        goDimmed.SetActive(achievement.IsAchievementRewarded());

        txtDay.text = resAchievement.ClientName;

        var attendanceProduct = ResourceItem
            .GetAllByType(ResourceItem.Types.Type.MaterialSingle)
            .First(x => 
                x.IsValid &&
                x.IsFreeProduct() &&
                x.TargetAchievementDataIds.Contains(resAchievement.Id));
        
        foreach (var (element, _, addItem) in rewards.GetElements(attendanceProduct.AddItemGroups.GetAddItems()))
        {
            element.Get<ItemCell>().Refresh(addItem);
        }
    }

}
