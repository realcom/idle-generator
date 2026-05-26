using System;

namespace Commons.Utility.ObjectPool
{
    public interface IPooledObject<T> : IDisposable
    {
        public void SetPool(IObjectPool<T> pool);
    }
}
