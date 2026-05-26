using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Sirenix.OdinInspector;
using UnityEngine;

[Serializable]
public class NoticeEntities
{
    public enum PredefinedNoticeEntitiesQuery
    {
        None,
        ChapterReward,
        Scout,
        Setting,
        MailBox,
        Attendance,
        HamburgerMenu
    }
    
    [Serializable]
    public struct EntityPair
    {
        public ResourceType type;
        public List<int> dataIds;
    }

    [SerializeField] private PredefinedNoticeEntitiesQuery _predefinedNoticeEntitiesQuery = PredefinedNoticeEntitiesQuery.None;
    [SerializeField, ShowIf("@_predefinedNoticeEntitiesQuery == PredefinedNoticeEntitiesQuery.None")] 
    private List<EntityPair> _noticeTargetResourceDataIds = new()
    {
        new EntityPair()
        {
            type = ResourceType.Item,
            dataIds = new List<int>()
        },
        new EntityPair()
        {
            type = ResourceType.Achievement,
            dataIds = new List<int>()
        }
    };

    public IEnumerable<ResourceEntity> GetNoticeRelevanceEntities()
    {
        if (_predefinedNoticeEntitiesQuery != PredefinedNoticeEntitiesQuery.None)
            return GetNoticeRelevanceEntitiesByQuery(_predefinedNoticeEntitiesQuery);

        return GetSpecifiedNoticeRelevanceEntities();
    }
    
    private IEnumerable<ResourceEntity> GetSpecifiedNoticeRelevanceEntities()
    {
        foreach (var pair in _noticeTargetResourceDataIds)
        {
            foreach (var dataId in pair.dataIds)
            {
                var resourceEntity = ResourceEntityExtensions.Get(pair.type, dataId);
                if (resourceEntity != null)
                    yield return resourceEntity;
            }
        }
    }

    public static IEnumerable<ResourceEntity> GetNoticeRelevanceEntitiesByQuery(PredefinedNoticeEntitiesQuery query)
    {
        switch (query)
        {
            case PredefinedNoticeEntitiesQuery.ChapterReward:
                return Popup_ChapterReward.GetChapterRewardAchievements();
            case PredefinedNoticeEntitiesQuery.Scout:
                return ResourceItem.GetAllByTag(Tag.ScoutNormal)
                    .Concat(ResourceItem.GetAllByParentId(
                        ResourceMap.GetAllByTag(Tag.Main).First(x => x.ContainsTag(Tag.Meta)).ProductScoutQuickItemDataId));
            case PredefinedNoticeEntitiesQuery.HamburgerMenu:
                return GetNoticeRelevanceEntitiesByQuery(PredefinedNoticeEntitiesQuery.Setting)
                    .Concat(GetNoticeRelevanceEntitiesByQuery(PredefinedNoticeEntitiesQuery.MailBox))
                    .Concat(GetNoticeRelevanceEntitiesByQuery(PredefinedNoticeEntitiesQuery.Attendance));
            case PredefinedNoticeEntitiesQuery.Setting:
                return Enumerable.Empty<ResourceEntity>();
            case PredefinedNoticeEntitiesQuery.MailBox:
                return Popup_MailBox.GetNoticeRelevanceEntities();
            case PredefinedNoticeEntitiesQuery.Attendance:
                return Popup_Attendance_7Day.GetNoticeRelevanceEntities();
            default:
                return Enumerable.Empty<ResourceEntity>();
        }
    }
    
    private static IEnumerable<TResource> ToEnumerable<TResource>(TResource resource) where TResource : ResourceEntity
    {
        if (resource != null)
            yield return resource;
    }
    
}
