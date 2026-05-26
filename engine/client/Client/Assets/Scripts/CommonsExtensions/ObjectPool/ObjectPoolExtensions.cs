
namespace Commons.Utility.ObjectPool
{
    public partial class PooledList<T>
    {
        public static PooledList<T> Get() => ObjectPool<PooledList<T>>.StaticPool.Pop();
    }
    
    public partial class PooledDictionary<TKey, TValue>
    {
        public static PooledDictionary<TKey, TValue> Get() => ObjectPool<PooledDictionary<TKey, TValue>>.StaticPool.Pop();
    }
    
    public partial class PooledHashSet<T>
    {
        public static PooledHashSet<T> Get() => ObjectPool<PooledHashSet<T>>.StaticPool.Pop();
    }

    public partial class PooledSortedDictionary<TKey, TValue>
    {
        public static PooledSortedDictionary<TKey, TValue> Get() => ObjectPool<PooledSortedDictionary<TKey, TValue>>.StaticPool.Pop();
    }
    
}