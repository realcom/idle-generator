using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using UnityEngine;
using ZLinq;

public class Popup_Attendance_7Day : Popup_Attendance
{
    public AttendanceRewardCell cellDay1;
    public AttendanceRewardCell cellDay2;
    public AttendanceRewardCell cellDay3;
    public AttendanceRewardCell cellDay4;
    public AttendanceRewardCell cellDay5;
    public AttendanceRewardCell cellDay6;
    public AttendanceRewardCell cellDay7;
    
    public static ResourceItem GetDefaultAttendanceItem()
    {
        using var list = PooledList<ResourceItem>.Get();
        
        foreach (var resAttendance in ResourceItem.GetAllByType(ResourceItem.Types.Type.Attendance7Day))
        {
            if (!resAttendance.IsValid)
                continue;
                
            list.Add(resAttendance);
        }

        list.Sort((x, y) => x.Order.CompareTo(y.Order));
        return list.First();
    }

    public static IEnumerable<ResourceEntity> GetNoticeRelevanceEntities()
    {
        var attendanceItem = MyPlayer.GetItemByDataID(GetDefaultAttendanceItem().Id);
        return ResourceItem.GetAllByTargetPopupNameWithArgs(nameof(Popup_Attendance_7Day), attendanceItem.DataId, (int)attendanceItem.GetCount());
    }

    protected override ResourceItem GetAttendanceItem()
    {
        return GetDefaultAttendanceItem();
    }

    protected override IEnumerable<ResourceAchievement> GetAttendanceAchievements()
    {
        var item = MyPlayer.GetItemByDataID(_resAttendanceItem.Id);
        if (item == null)
            return Array.Empty<ResourceAchievement>();
        
        return ResourceAchievement.GetAllByTargetPopupNameWithArgs(
            nameof(Popup_Attendance_7Day),
            _resAttendanceItem.Id,
            (int)item.GetCount());
    }

    protected override void RefreshAttendanceInfo(ResourceAchievement resAchievement, int index)
    {
        var day = index + 1;
        switch (day)
        {
            case 1:
                cellDay1.Refresh(resAchievement);
                break;
            case 2:
                cellDay2.Refresh(resAchievement);
                break;
            case 3:
                cellDay3.Refresh(resAchievement);
                break;
            case 4:
                cellDay4.Refresh(resAchievement);
                break;
            case 5:
                cellDay5.Refresh(resAchievement);
                break;
            case 6:
                cellDay6.Refresh(resAchievement);
                break;
            case 7:
                cellDay7.Refresh(resAchievement);
                break;
            default:
                throw new IndexOutOfRangeException($"Invalid day index: {day}");
        }
    }
}
