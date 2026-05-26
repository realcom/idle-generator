using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public partial class PooledHashSet<T> : HashSet<T>, IPooledObject<PooledHashSet<T>>
    {
        private IObjectPool<PooledHashSet<T>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledHashSet<T>> pool)
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
