using System;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.Pool;
using ZLinq;
using Object = UnityEngine.Object;

public partial class NoticeSystem : BaseSystem<NoticeSystem>, EventListener
{
    private static NoticeSystem _instance = null;
    private static NoticeSystem Instance => _instance ??= new();
    
    [RuntimeInitializeOnLoadMethod]
    private static void Initialize() 
    {
        Debug.Log("NoticeSystem Initialize");
        
        ZPlayerLoopSystemHelper.InsertSystemAfter(typeof(NoticeSystem), Instance.Update,
            typeof(UnityEngine.PlayerLoop.PostLateUpdate));
        
        GameManager.Get().AddListener(Instance);
        ZWorldClient.Get().AddListener(Instance);
        
        Application.quitting += Instance.Release;
    }

    private void Release()
    {
        ZWorldClient.Get().RemoveListener(Instance);
        GameManager.Get().RemoveListener(Instance);
    }

    private const float NoticeRefreshDelayByEvent = 0.5f;
    private const int LazyRefreshLimit = 10;

    private static double _lazyRefreshAt = 0f;
    private static int _lazyRefreshRequestCount = 0;
    
    private void Update()
    {
        if (_lazyRefreshAt > 0 && _lazyRefreshAt <= TimeSystem.time)
        {
            RefreshNotice();
            _lazyRefreshAt = 0;
        }
    }
    
    private static readonly Dictionary<INoticeListener, PooledList<ResourceEntity>> _entitiesByNoticeListener = new();
    private static readonly Dictionary<INoticeListener, PooledList<ResourceAchievement>> _prerequisitesConditionsByNoticeListener = new();

    private void RefreshNotice()
    {
        _lazyRefreshRequestCount = 0;

        Debug.Log("NoticeSystem RefreshNotice");

        using var noticeResultByEntityId = PooledDictionary<(ResourceType, int), bool>.Get();

        ShrinkNoticeListeners();

        foreach (var (listener, entities) in _entitiesByNoticeListener.AsValueEnumerable())
        {
            var hasRelevanceNotice = false;
            foreach (var entity in entities)
            {
                var key = (entity.ResourceType, entity.GetId());
                if (!noticeResultByEntityId.TryGetValue(key, out var result))
                {
                    try
                    {
                        result = noticeResultByEntityId[key] = entity.HasRelevanceNotice();
                    }
                    catch (Exception e)
                    {
                        Debug.LogError($"Failed to check HasRelevanceNotice for entity {entity}: {e}");
                        throw;
                    }
                }

                if (result)
                {
                    hasRelevanceNotice = true;
                    break;
                }
            }

            listener.RefreshNotice(CheckPrerequisitesCondition(listener) && hasRelevanceNotice);
        }
    }
    
    private void ShrinkNoticeListeners()
    {
        using var validNoticeListenersWithEntities = PooledList<(INoticeListener, PooledList<ResourceEntity>)>.Get();
        foreach (var (listener, list) in _entitiesByNoticeListener)
        {
            if (listener == null || listener is Object obj && obj == null)
                continue;
            
            if (list.Count > 0)
                validNoticeListenersWithEntities.Add((listener, list));
            else
                list.Dispose();
        }
        
        _entitiesByNoticeListener.Clear();
        _entitiesByNoticeListener.EnsureCapacity(validNoticeListenersWithEntities.Count);
        foreach (var (listener, list) in validNoticeListenersWithEntities)
            _entitiesByNoticeListener[listener] = list;
        
        using var validNoticeListenersWithPrerequisitesConditions = PooledList<(INoticeListener, PooledList<ResourceAchievement>)>.Get();
        foreach (var (listener, list) in _prerequisitesConditionsByNoticeListener)
        {
            if (listener == null || listener is Object obj && obj == null)
                continue;
            
            if (list.Count > 0)
                validNoticeListenersWithPrerequisitesConditions.Add((listener, list));
            else
                list.Dispose();
        }
        
        _prerequisitesConditionsByNoticeListener.Clear();
        _prerequisitesConditionsByNoticeListener.EnsureCapacity(validNoticeListenersWithPrerequisitesConditions.Count);
        foreach (var (listener, list) in validNoticeListenersWithPrerequisitesConditions)
            _prerequisitesConditionsByNoticeListener[listener] = list;
    }

    public async UniTask HandleEvent(GameEvent e)
    {
        switch (e.type)
        {
            case GameEventType.MyPlayerAchievementUpdated:
            case GameEventType.MyPlayerItemUpdated:
            case GameEventType.MAP_LOADED:
            {
                if (_lazyRefreshRequestCount < LazyRefreshLimit)
                {
                    _lazyRefreshRequestCount++;
                }
                else
                {
                    RefreshNotice();
                }

                _lazyRefreshAt = TimeSystem.time + NoticeRefreshDelayByEvent;
                
                break;
            }
        }
    }
}
