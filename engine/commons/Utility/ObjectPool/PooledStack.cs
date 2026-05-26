using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public class PooledStack<T> : Stack<T>, IPooledObject<PooledStack<T>>
    {
        private IObjectPool<PooledStack<T>> _pool = null!;
        
        public void SetPool(IObjectPool<PooledStack<T>> pool)
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