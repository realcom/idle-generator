using System.Runtime.CompilerServices;

namespace Commons.Utility.ObjectPool
{
    public abstract class PooledObject<T> : IPooledObject<T> where T : PooledObject<T>
    {
        private IObjectPool<T> _pool = null!;
        
        public void SetPool(IObjectPool<T> pool)
        {
            _pool = pool;
        }

        public void Dispose()
        {
            Clear();
            _pool.Push(Unsafe.As<T>(this));
        }

        protected abstract void Clear();
    }
}
