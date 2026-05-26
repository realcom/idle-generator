using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public partial class PooledDictionary<TKey, TValue> : Dictionary<TKey, TValue>, IPooledObject<PooledDictionary<TKey, TValue>>
    {
        private IObjectPool<PooledDictionary<TKey, TValue>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledDictionary<TKey, TValue>> pool)
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