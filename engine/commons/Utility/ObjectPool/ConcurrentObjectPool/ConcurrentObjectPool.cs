using System;
using System.Collections.Concurrent;

namespace Commons.Utility.ObjectPool.ConcurrentObjectPool
{
    public class ConcurrentObjectPool<T> : IObjectPool<T> where T : IPooledObject<T>, new()
    {
        private static ConcurrentObjectPool<T>? _staticPool;
        public static ConcurrentObjectPool<T> StaticPool =>
            _staticPool ??= new ConcurrentObjectPool<T>(2 * Environment.ProcessorCount);
        
        private readonly ConcurrentBag<T> _pooledObjects = new();
        
        public int MaxSize { get; }
        public readonly Action<T>? Initializer;
        
        public ConcurrentObjectPool(int maxSize)
        {
            MaxSize = maxSize;
        }
        
        public ConcurrentObjectPool(int maxSize, Action<T> initializer)
        {
            MaxSize = maxSize;
            Initializer = initializer;
        }

        public void Push(T item)
        {
            if (_pooledObjects.Count < MaxSize)
                _pooledObjects.Add(item);
        }

        public T Pop()
        {
            if (_pooledObjects.TryTake(out var item))
                return item;
            var obj = new T();
            obj.SetPool(this);
            Initializer?.Invoke(obj);
            return obj;
        }
    }
}
