using System.Collections.Generic;
using Commons.Utility;
using Commons.Utility.Pickable;

namespace Commons.Types
{
    public partial class ItemOption : IPickable
    {
        partial void OnConstruction()
        {
            if (weight_ <= float.Epsilon)
                weight_ = 1f;

            if (minLevel_ == 0)
                minLevel_ = 1;

            if (maxLevel_ == 0)
                maxLevel_ = 1;
        }
        
        public int GetLevel()
        {
            return minLevel_ == maxLevel_ ? minLevel_ : StaticRandom.CryptoNext(minLevel_, maxLevel_);
        }
        
        public int GetLevel(IRng rng)
        {
            return minLevel_ == maxLevel_ ? minLevel_ : rng.Random(maxLevel_) + minLevel_;
        }
        
    }

    
    public partial class ItemOptionGroup : PickerGroup<ItemOption>
    {
        protected override IReadOnlyList<ItemOption> container => options_;

        private readonly Dictionary<int, ItemOption> optionsById_ = new();
        public IReadOnlyDictionary<int, ItemOption> OptionsById
        {
            get
            {
                Init();
                return optionsById_;
            }
        }

        protected override void OnInit()
        {
            optionsById_.Clear();
            foreach (var itemOption in options_)
            {
                optionsById_[itemOption.Id] = itemOption;
            }
        }

        protected override bool CanSample()
        {
            return true;
        }

        protected override bool CanSample(IRng rng)
        {
            return true;
        }
    }
}