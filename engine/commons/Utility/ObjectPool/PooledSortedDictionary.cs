using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public partial class PooledSortedDictionary<TKey, TValue> : SortedDictionary<TKey, TValue>, IPooledObject<PooledSortedDictionary<TKey, TValue>>
    {
        private IObjectPool<PooledSortedDictionary<TKey, TValue>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledSortedDictionary<TKey, TValue>> pool)
        {
            _pool = pool;
        }

        public void Dispose()
        {
            Clear();
            _pool.Push(this);
        }
    }
}