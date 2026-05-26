using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility;
using Commons.Utility.Pickable;

namespace Commons.Types
{
    public partial class AddItem : IPickable
    {
        public ResourceItem GetData()
        {
            return ResourceItem.Get(itemDataId_)!;
        }
        
        public long GetCount()
        {
            if (maxCount_ > 0)
                return StaticRandom.CryptoNext(minCount_, maxCount_);
            return count_ == 0 ? 1 : count_;
        }
        
        public long GetCount(IRng rng)
        {
            if (maxCount_ > 0)
                return NextInclusive(rng, minCount_, maxCount_);
            return count_ == 0 ? 1 : count_;
        }

        public int GetLevel()
        {
            if (maxLevel_ > 0)
                return StaticRandom.CryptoNext(minLevel_, maxLevel_);
            return level_ == 0 ? 1 : level_;
        }
        
        public int GetLevel(IRng rng)
        {
            if (maxLevel_ > 0)
                return NextInclusive(rng, minLevel_, maxLevel_);
            return level_ == 0 ? 1 : level_;
        }
        
        public long GetExp()
        {
            if (maxExp_ > 0)
                return StaticRandom.CryptoNext(minExp_, maxExp_);
            return exp_;
        }
        
        public long GetExp(IRng rng)
        {
            if (maxExp_ > 0)
                return NextInclusive(rng, minExp_, maxExp_);
            return exp_;
        }
        
        public TimeSpan? GetDuration()
        {
            if (days_ == 0 && hours_ == 0 && minutes_ == 0)
                return null;
            return new TimeSpan(days_, hours_, minutes_, 0);
        }

        private static int NextInclusive(IRng rng, int minValue, int maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            return minValue + rng.Random(maxValueInclusive - minValue + 1);
        }

        private static long NextInclusive(IRng rng, long minValue, long maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            return minValue + rng.Random(maxValueInclusive - minValue + 1);
        }
    }
    
    public partial class AddItemGroup : PickerGroup<AddItem>
    {
        private float _prob;
        protected override IReadOnlyList<AddItem> container => addItems_;

        protected override void OnInit()
        {
            _prob = probPercent_ == 0f ? 1f : probPercent_ / 100f;
        }

        protected override bool CanSample()
        {
            return Math.Abs(_prob - 1f) < float.Epsilon || !(StaticRandom.CryptoNextFloat() > _prob);
        }

        protected override bool CanSample(IRng rng)
        {
            return Math.Abs(_prob - 1f) < float.Epsilon || !(rng.RandomFloat() > _prob);
        }

        public bool CanSampleGroup()
        {
            Init();
            return CanSample();
        }

        public bool CanSampleGroup(IRng rng)
        {
            Init();
            return CanSample(rng);
        }
    }
}
