using System;
using System.Collections.Generic;

namespace Commons.Utility.ObjectPool
{
    public class ObjectPool<T> : IObjectPool<T> where T : IPooledObject<T>, new()
    {
        private static ObjectPool<T>? _staticPool;
        public static ObjectPool<T> StaticPool =>
            _staticPool ??= new ObjectPool<T>(64);
        
        private readonly Stack<T> _pooledObjects = new();

        public int MaxSize { get; }
        public readonly Action<T>? Initializer;
        
        public ObjectPool(int maxSize)
        {
            MaxSize = maxSize;
            Initializer = null;
        }
        
        public ObjectPool(int maxSize, Action<T> initializer)
        {
            MaxSize = maxSize;
            Initializer = initializer;
        }

        public void Push(T item)
        {
            if (_pooledObjects.Count < MaxSize)
                _pooledObjects.Push(item);
        }

        public T Pop()
        {
            if (_pooledObjects.TryPop(out var item))
                return item;
            var obj = new T();
            obj.SetPool(this);
            Initializer?.Invoke(obj);
            return obj;
        }
    }
}
