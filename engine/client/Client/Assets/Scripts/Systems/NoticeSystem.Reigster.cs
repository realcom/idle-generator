using System;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using ZLinq;

public partial class NoticeSystem
{
    public readonly struct RegisterScope : IDisposable
    {
        private readonly INoticeListener _listener;
        
        public RegisterScope(INoticeListener listener)
        {
            _listener = listener;
            UnregisterListener(listener);
        }
        
        private PooledList<ResourceEntity> GetOrCreateRelevanceEntities()
        {
            if (!_entitiesByNoticeListener.TryGetValue(_listener, out var entities))
                _entitiesByNoticeListener[_listener] = entities = PooledList<ResourceEntity>.Get();
            return entities;
        }
        
        public void AddNoticeRelevanceEntity(ResourceEntity resource)
        {
            GetOrCreateRelevanceEntities().Add(resource);
        }
        
        public void AddNoticeRelevanceEntities(IEnumerable<ResourceEntity> enumerable)
        {
            GetOrCreateRelevanceEntities().AddRange(enumerable);
        }
        
        private PooledList<ResourceAchievement> GetOrCreatePrerequisitesConditions()
        {
            if (!_prerequisitesConditionsByNoticeListener.TryGetValue(_listener, out var conditions))
                _prerequisitesConditionsByNoticeListener[_listener] = conditions = PooledList<ResourceAchievement>.Get();
            return conditions;
        }
        
        public void AddPrerequisitesCondition(ResourceAchievement conditionAchievement)
        {
            GetOrCreatePrerequisitesConditions().Add(conditionAchievement);
        }
        
        public void AddPrerequisitesCondition(int achievementDataId)
        {
            var conditionAchievement = ResourceAchievement.Get(achievementDataId);
            if (conditionAchievement == null)
                return;
            
            GetOrCreatePrerequisitesConditions().Add(conditionAchievement);
        }
        
        public void AddPrerequisitesConditions(IEnumerable<ResourceAchievement> achievements)
        {
            GetOrCreatePrerequisitesConditions().AddRange(achievements);
        }
        
        public void AddPrerequisitesConditions(IEnumerable<int> achievementDataIds)
        {
            var enumerable = achievementDataIds
                .AsValueEnumerable()
                .Select(ResourceAchievement.Get)
                .Where(resAch => resAch != null);
            
            var conditions = GetOrCreatePrerequisitesConditions();
            foreach (var resAch in enumerable)
                conditions.Add(resAch);
        }
        
        public void Dispose()
        {
            var completedPrerequisitesCondition = CheckPrerequisitesCondition(_listener);
            var hasRelevanceNotice = _entitiesByNoticeListener.GetValueOrDefault(_listener)?
                .AsValueEnumerable()
                .Any(x => x.HasRelevanceNotice()) == true;

            _listener.RefreshNotice(completedPrerequisitesCondition && hasRelevanceNotice);
        }
    }
    
    private static bool CheckPrerequisitesCondition(INoticeListener listener)
    {
        var hasCompletedPrerequisitesCondition = true;
        if (_prerequisitesConditionsByNoticeListener.TryGetValue(listener, out var achievements))
        {
            using var unclearedAchievements = PooledList<ResourceAchievement>.Get();
            foreach (var entity in achievements)
            {
                var condition = MyPlayer.IsAchievementCompletedOrRewarded(entity);
                hasCompletedPrerequisitesCondition &= condition;

                if (!condition)
                    unclearedAchievements.Add(entity);
            }
            
            achievements.Clear();
            achievements.AddRange(unclearedAchievements);
        }

        return hasCompletedPrerequisitesCondition;
    }
    
    public static void UnregisterListener(INoticeListener listener)
    {
        if (_entitiesByNoticeListener.Remove(listener, out var entities))
            entities.Dispose();
        if (_prerequisitesConditionsByNoticeListener.Remove(listener, out var conditions))
            conditions.Dispose();
    }
    
}

public static class NoticeSystemHelper
{
    public static void Register(this INoticeListener listener, ResourceEntity entity)
    {
        using var scope = new NoticeSystem.RegisterScope(listener);
        scope.AddNoticeRelevanceEntity(entity);
    }
    
    public static void Register<T>(this INoticeListener listener, int dataId) where T : ResourceEntity
    {
        using var scope = new NoticeSystem.RegisterScope(listener);
        scope.AddNoticeRelevanceEntity(ResourceEntityExtensions.Get<T>(dataId));
    }
    
    public static void Register(this INoticeListener listener, IEnumerable<ResourceEntity> entities)
    {
        using var scope = new NoticeSystem.RegisterScope(listener);
        scope.AddNoticeRelevanceEntities(entities);
    }
    
}