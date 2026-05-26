using System.Collections.Generic;
using Commons.Resources;
using Commons.Utility;

namespace Commons.Types.Players
{
    public partial class PlayerItemMessage : IReadOnlyPlayerItem
    {
        public enum State : uint
        {
            None = 0,
            InUse = 1 << 0,
            UserLocked = 1 << 1,
            
            NotConsumable = InUse | UserLocked,
            All = ~None
        }
        
        public bool HasFlag(State flag) => (stateFlag_ & (uint)flag) != 0;
        public bool IsConsumable => !HasFlag(State.NotConsumable);
        
        public int DataId => itemDataId_;
        public PlayerItemOption? PlayerItemOption => option_;

        private ResourceItem? _resourceItem;
        public ResourceItem? GetData()
        {
            return _resourceItem ??= ResourceItem.Get(itemDataId_);
        }
    }
    
    public static class PlayerItemOptionExtensions
    {
        public static bool IsValid(this PlayerItemOption.Types.Option? option)
        {
            return option != null && option.Id != 0 && option.PoolId != 0;
        }

        public static IEnumerable<(ItemOption option, int optionLevel)> GetRerollOptions(this PlayerItemOption playerItemOption, ResourceItem? resItem)
        {
            if (resItem == null)
                yield break;

            foreach (var option in playerItemOption.RerollOptions)
            {
                if (option.IsValid() == false)
                    continue;

                var optionGroup = resItem.Options.GetClamped(option.PoolId - 1)!;
                var optionData = optionGroup.OptionsById.GetValueOrDefault(option.Id);
                if (optionData == null)
                    continue;
                
                yield return (optionData, option.Level);
            }
        }

        public static PlayerItemOption.Types.ProductOption GetProductOption(this PlayerItemOption playerItemOption)
        {
            return playerItemOption.ProductOption ??= new();
        }
    }
    
}
