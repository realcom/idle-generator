using System;using System.Collections.Generic;
using System.Linq;
using Cysharp.Threading.Tasks;
using UnityEngine;
using Object = UnityEngine.Object;

public interface IObjectPool<T> where T : Object
{
    int CountInactive { get; }
    T Get_internal(T prefab, Vector3 pos, Quaternion rotation, Transform parent);
    ZPooledObject<T> Get_internal(out T v, T prefab, Vector3 pos, Quaternion rotation, Transform parent);
    void Release_internal(T obj);
    void Clear();
}

public readonly struct ZPooledObject<T> : IDisposable where T : Object
{
    private readonly T m_ToReturn;
    private readonly IObjectPool<T> m_Pool;

    internal ZPooledObject(T value, IObjectPool<T> pool)
    {
        m_ToReturn = value;
        m_Pool = pool;
    }

    void IDisposable.Dispose() => m_Pool.Release_internal(m_ToReturn);
}

public abstract class ZObjectPool<TObject, TPool> : IDisposable, EventListener, IObjectPool<TObject> where TObject : Object where TPool : ZObjectPool<TObject, TPool>, new()
{
    public static readonly Dictionary<long, TPool> s_pools = new();
    
    private static bool GetPool(long poolId, out TPool pool, int defaultCapacity = 1)
    {
        if (!s_pools.TryGetValue(poolId, out pool))
        {
            s_pools[poolId] = pool = new TPool();
            
            GameManager.Get().AddListener(pool);
            ZWorldClient.Get().AddListener(pool);
            
            pool.PoolId = poolId;
            pool.m_PooledObjectList = new (defaultCapacity);
            pool.m_ObjectTracker = new (defaultCapacity);
            return true;
        }

        return false;
    }

    private HashSet<TObject> m_ObjectTracker;
    private HashSet<TObject> m_PooledObjectList;
    public long PoolId { get; private set; }

    public static TObject Get(TObject prefab, Vector3 pos, Quaternion rotation, Transform parent, long poolId = -1, int defaultCapacity = 1)
    {
        if (poolId == -1)
            poolId = prefab.GetInstanceID();

        if (GetPool(poolId, out var pool, defaultCapacity))
        {
            for (var i = 0; i < defaultCapacity; i++)
            {
                var obj = Object.Instantiate(prefab, pos, rotation, parent);
                s_pools[obj.GetInstanceID()] = pool;
                pool.m_PooledObjectList.Add(obj);
                pool.m_ObjectTracker.Add(obj);
                pool.Release_Implementation(obj);
            }
        }

        return pool.Get_internal(prefab, pos, rotation, parent);
    }

    public static TObject GetTransient(TObject prefab, Vector3 pos, Quaternion rotation, Transform parent, float duration = 1f, long poolId = -1, int defaultCapacity = 1)
    {
        if (poolId == -1)
            poolId = prefab.GetInstanceID();

        if (GetPool(poolId, out var pool, defaultCapacity))
        {
            for (var i = 0; i < defaultCapacity; i++)
            {
                var objCapacity = Object.Instantiate(prefab, pos, rotation, parent);
                s_pools[objCapacity.GetInstanceID()] = pool;
                pool.m_PooledObjectList.Add(objCapacity);
                pool.m_ObjectTracker.Add(objCapacity);
                pool.Release_Implementation(objCapacity);
            }
        }
        
        var obj = pool.Get_internal(prefab, pos, rotation, parent);
        pool.ReleaseAfterDelay(obj, duration);
        
        return obj;
    }
    
    public static ZPooledObject<TObject> Get(out TObject v, TObject prefab, Vector3 pos, Quaternion rotation, Transform parent, long poolId = -1, int defaultCapacity = 1)
    {
        if (poolId == -1)
            poolId = prefab.GetInstanceID();

        if (GetPool(poolId, out var pool, defaultCapacity))
        {
            for (var i = 0; i < defaultCapacity; i++)
            {
                var objCapacity = Object.Instantiate(prefab, pos, rotation, parent);
                s_pools[objCapacity.GetInstanceID()] = pool;
                pool.m_PooledObjectList.Add(objCapacity);
                pool.m_ObjectTracker.Add(objCapacity);
                pool.Release_Implementation(objCapacity);
            }
        }

        return pool.Get_internal(out v, prefab, pos, rotation, parent);
    }
    
    public static void Release(TObject obj, long poolId = -1)
    {
        if (obj == null)
            return;
        
        if (poolId == -1)
            poolId = obj.GetInstanceID();

        if (s_pools.TryGetValue(poolId, out var pool))
            pool.Release_internal(obj);
        else
        {
            Object.Destroy(obj);
            Debug.LogWarning($"Object {obj.name} with poolId {poolId} not found in pool");
        }
    }

    public int CountAll => m_ObjectTracker.Count;
    public int CountActive => CountAll - CountInactive;
    public int CountInactive => m_PooledObjectList.Count;
    
    public TObject Get_internal(TObject prefab, Vector3 pos, Quaternion rotation, Transform parent)
    {
        TObject obj;
        if (CountInactive == 0)
        {
            obj = Object.Instantiate(prefab, pos, rotation, parent);
            s_pools[obj.GetInstanceID()] = this as TPool;
            m_ObjectTracker.Add(obj);
        }
        else
        {
            obj = m_PooledObjectList.Last();
            m_PooledObjectList.Remove(obj);
        }

        Get_Implementation(obj, prefab, pos, rotation, parent);

        return obj;
    }

    public ZPooledObject<TObject> Get_internal(out TObject v, TObject prefab, Vector3 pos, Quaternion rotation, Transform parent)
    {
        return new ZPooledObject<TObject>(v = Get_internal(prefab, pos, rotation, parent), this);
    }

    public void Release_internal(TObject obj)
    {
        if (obj)
        {
            Release_Implementation(obj);
            m_PooledObjectList.Add(obj);
        }
    }

    public void Clear()
    {
        foreach (var item in m_ObjectTracker)
        {
            if (item)
            {
                s_pools.Remove(item.GetInstanceID());
                Clear_Implementation(item);
            }
        }
        m_ObjectTracker.Clear();
        m_PooledObjectList.Clear();
    }

    protected abstract void ReleaseAfterDelay(TObject obj, float duration);
    protected abstract void Get_Implementation(TObject obj, TObject prefab, Vector3 pos, Quaternion rotation, Transform parent);
    protected abstract void Release_Implementation(TObject obj);
    protected abstract void Clear_Implementation(TObject obj);

    public void Dispose()
    {
        Clear();
        s_pools.Remove(PoolId);
    }

    public async UniTask HandleEvent(GameEvent e)
    {
        switch (e.type)
        {
            case GameEventType.MAP_RELEASED:
            {
                GameManager.Get().RemoveListener(this);
                ZWorldClient.Get().RemoveListener(this);

                Dispose();
                break;
            }
        }
    }
}

public class GameObjectPool : ZObjectPool<GameObject, GameObjectPool>
{
    protected override void ReleaseAfterDelay(GameObject obj, float duration)
    {
        obj.GetOrAdd<CoroutineRunner>().RunWithDelay(() => Release_internal(obj), duration);
    }

    protected override void Get_Implementation(GameObject obj, GameObject prefab, Vector3 pos, Quaternion rotation, Transform parent)
    {
        obj.SetActive(true);
        var transform = obj.transform;
        transform.SetParent(parent, false);
        
        if (transform is RectTransform rectTransform)
            rectTransform.anchoredPosition3D = pos;
        else
            transform.localPosition = pos;
        
        transform.rotation = rotation;
        transform.localScale = prefab.transform.localScale;
    }

    protected override void Release_Implementation(GameObject obj)
    {
        var parent = obj.transform switch
        {
            RectTransform => GameScene.Get().rtSafeArea,
            _ => GameBoardManager.Get().transform
        };
        
        obj.transform.SetParent(parent, false);
        obj.SetActive(false);
    }

    protected override void Clear_Implementation(GameObject obj)
    {
        Object.Destroy(obj);
    }
}

public class BehaviourPool<TBehaviour> : ZObjectPool<TBehaviour, BehaviourPool<TBehaviour>> where TBehaviour : MonoBehaviour
{
    protected override void ReleaseAfterDelay(TBehaviour obj, float duration)
    {
        obj.Run(() => Release_internal(obj), duration);
    }

    protected override void Get_Implementation(TBehaviour obj, TBehaviour prefab, Vector3 pos, Quaternion rotation, Transform parent)
    {
        obj.SetActive(true);
        var transform = obj.transform;
        transform.SetParent(parent, false);

        if (transform is RectTransform rectTransform)
            rectTransform.anchoredPosition3D = pos;
        else
            transform.localPosition = pos;
        
        transform.rotation = rotation;
        transform.localScale = prefab.transform.localScale;
    }

    protected override void Release_Implementation(TBehaviour obj)
    {
        var parent = obj.transform switch
        {
            RectTransform => GameScene.Get().rtSafeArea,
            _ => GameBoardManager.Get().transform
        };
        
        obj.transform.SetParent(parent, false);
        obj.SetActive(false);        
    }

    protected override void Clear_Implementation(TBehaviour obj)
    {
        Object.Destroy(obj.gameObject);
    }
}