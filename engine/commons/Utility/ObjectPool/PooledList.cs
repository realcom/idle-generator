using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public partial class PooledList<T> : List<T>, IPooledObject<PooledList<T>>
    {
        private IObjectPool<PooledList<T>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledList<T>> pool)
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
