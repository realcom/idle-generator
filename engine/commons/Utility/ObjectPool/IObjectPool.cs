namespace Commons.Utility.ObjectPool
{
    public interface IObjectPool<T>
    {
        public int MaxSize { get; }

        public void Push(T item);
        
        public T Pop();
    }
}
