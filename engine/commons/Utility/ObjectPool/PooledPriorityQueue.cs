using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public class PooledPriorityQueue<TElement, TPriority> : PriorityQueue<TElement, TPriority>, IPooledObject<PooledPriorityQueue<TElement, TPriority>>
    {
        private IObjectPool<PooledPriorityQueue<TElement, TPriority>> _pool = null!;

        public void SetPool(IObjectPool<PooledPriorityQueue<TElement, TPriority>> pool)
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
