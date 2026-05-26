using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public class PooledQueue<T> : Queue<T>, IPooledObject<PooledQueue<T>>
    {
        private IObjectPool<PooledQueue<T>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledQueue<T>> pool)
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
