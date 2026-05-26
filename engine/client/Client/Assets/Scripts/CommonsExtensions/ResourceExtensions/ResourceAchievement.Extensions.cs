using System;
using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Interfaces;
using JetBrains.Annotations;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceAchievement
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Achievement;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);
        
        public static readonly Comparer comparer = new();
        public class Comparer : IComparer<ResourceAchievement>
        {
            public int Compare(ResourceAchievement a, ResourceAchievement b)
            {
                if (a == null)
                    return 0;
                if (b == null)
                    return 0;
                
                return PlayerAchievementMessage.comparer.Compare(MyPlayer.GetAchievementByDataID(a.Id), MyPlayer.GetAchievementByDataID(b.Id));
            }
        }
        
        static partial void Reload()
        {
            PopupArgsContainer<ResourceAchievement>.Clear();
        }
        
        partial void InitUnity()
        {
            InitEntity(ResourceString.Types.Category.Achievement, Id);

            PopupArgsContainer<ResourceAchievement>.Register(this);
        }


        
        private static readonly object[] descArgs = new object[10];
        public override string ClientDesc {
            get
            {
                for (var i = 0; i < descArgs.Length; i++)
                    descArgs[i] = "";

                descArgs[9] = MyPlayer.IsAchievementCompletedOrRewarded(id_) ? CRC.Get().enoughColorHex : CRC.Get().notEnoughColorHex;
                
                return _clientDesc.GetParsedString(descArgs);
            }
        }

        public string GetProgressText(PlayerAchievementMessage achievement = null, bool useColor = true)
        {
            achievement ??= MyPlayer.GetAchievementByDataID(Id);
            if (achievement == null)
                return string.Empty;

            var colorHex = achievement.IsAchievementCompletedOrRewarded() ? CRC.Get().enoughColorHex : CRC.Get().notEnoughColorHex;
            if (!useColor)
                return $"{achievement.Progress}/{targetProgress_}";
            
            return $"<color=#{colorHex}>{achievement.Progress}</color>/{targetProgress_}";
        }
        
        public override bool HasRelevanceNotice()
        {
            return MyPlayer.GetAchievementByDataID(Id)?.IsAchievementCompleted() == true;
        }
    }
}

public static class ResourceAchievementQuery
{
    // public static IEnumerable<ResourceAchievement> CurrentSeasonAttendanceAchievements() => ResourceAchievement.GetAchievementsByPopupNameWithArgs(nameof(Popup_Attendance), GameManager.Get().GetSeasonDate().ToString());
}

public static class AchievementExtensions
{
    [CanBeNull]
    public static ResourceAchievement GetData(this PlayerAchievementMessage achievement)
    {
        return ResourceAchievement.Get(achievement.AchievementDataId);
    }

    public static bool IsAchievementCompleted(this PlayerAchievementMessage achievement)
    {
        return achievement?.State == PlayerAchievementMessage.Types.State.Completed;
    }

    public static bool IsAchievementRewarded(this PlayerAchievementMessage achievement)
    {
        return achievement?.State == PlayerAchievementMessage.Types.State.Rewarded;
    }

    public static bool IsAchievementCompletedOrRewarded(this PlayerAchievementMessage achievement)
    {
        return achievement.IsAchievementCompleted() || achievement.IsAchievementRewarded();
    }

    public static bool IsLockedByAchievement(this ResourceItem.Types.Type partType, out ResourceAchievement lockedAchievement)
    {
        lockedAchievement = null;
        var achievementId = partType switch
        {
            ResourceItem.Types.Type.Head => ResourceAchievement.Global.DataId.EquipmentSlotUnlockHead,
            ResourceItem.Types.Type.Chest => ResourceAchievement.Global.DataId.EquipmentSlotUnlockChest,
            ResourceItem.Types.Type.Boots => ResourceAchievement.Global.DataId.EquipmentSlotUnlockBoots,
            ResourceItem.Types.Type.Gloves => ResourceAchievement.Global.DataId.EquipmentSlotUnlockGloves,
            ResourceItem.Types.Type.Necklace => ResourceAchievement.Global.DataId.EquipmentSlotUnlockNecklace,
            ResourceItem.Types.Type.Ring => ResourceAchievement.Global.DataId.EquipmentSlotUnlockRing,
            _ => throw new ArgumentOutOfRangeException()
        };

        if (achievementId == 0)
            return false;

        var achievement = MyPlayer.GetAchievementByDataID(achievementId);
        if (achievement == null)
            return false;

        if (achievement.IsAchievementCompletedOrRewarded())
            return false;

        lockedAchievement = ResourceAchievement.Get(achievementId);
        return true;
    }
}