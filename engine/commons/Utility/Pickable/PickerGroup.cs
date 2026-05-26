using System.Collections.Generic;
using System.Linq;
using Commons.Types;

namespace Commons.Utility.Pickable
{
    public abstract class PickerGroup<T> where T : class, IPickable, new()
    {
        private bool _inited;
        private float _totalWeight;
        public float TotalWeight
        {
            get
            {
                Init();
                return _totalWeight;
            }
        }

        protected abstract IReadOnlyList<T> container { get; }

        protected void Init()
        {
            if (_inited)
                return;
            _inited = true;
            _totalWeight = container.Sum(pickable => pickable.Weight);
            OnInit();
        }

        protected abstract void OnInit();
        protected abstract bool CanSample();
        protected abstract bool CanSample(IRng rng);

        public T? Sample()
        {
            Init();
            if (!CanSample())
                return null;
            return container.CryptoPickWeighted(_totalWeight, ai => ai.Weight);
        }

        public T? Sample(IRng rng)
        {
            Init();
            if (!CanSample(rng))
                return null;
            return container.PickWeighted(rng, _totalWeight, ai => ai.Weight);
        }

        public List<T> SampleMany(int count)
        {
            Init();
            if (!CanSample())
                return new();
            return container.CrpytoPickManyWeighted(count, ai => ai.Weight).ToList();
        }

        public List<T> SampleManyUnique(int count)
        {
            Init();
            if (!CanSample())
                return new();
            return container.CryptoPickManyWeightedUnique(count, ai => ai.Weight).ToList();
        }

        public List<T> SampleMany(IRng rng, int count)
        {
            Init();
            if (!CanSample(rng))
                return new();
            return container.PickManyWeighted(count, rng, ai => ai.Weight).ToList();
        }

        public List<T> SampleManyUnique(IRng rng, int count)
        {
            Init();
            if (!CanSample(rng))
                return new();
            return container.PickManyWeightedUnique(count, rng, ai => ai.Weight).ToList();
        }
    }
}