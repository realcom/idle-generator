using Commons.Resources;

namespace Commons.Types.Players
{
    public partial class PlayerMailAddItem
    {
        public ResourceItem? GetData()
        {
            return ResourceItem.Get(itemDataId_);
        }
        
        public static implicit operator PlayerMailAddItem(AddItem addItem)
        {
            return new PlayerMailAddItem()
            {
                itemDataId_ = addItem.ItemDataId,
                itemCount_ = addItem.Count,
                itemLevel_ = addItem.Level,
                itemDays_ = addItem.Days,
                itemHours_ = addItem.Hours,
            };
        }
        
        public static implicit operator PlayerMailAddItem(PlayerMailMessage message)
        {
            return new PlayerMailAddItem()
            {
                itemDataId_ = message.ItemDataId,
                itemCount_ = message.ItemCount,
                itemLevel_ = message.ItemLevel,
                itemDays_ = message.ItemDays,
                itemHours_ = message.ItemHours,
                itemOption_ = message.ItemOption
            };
        }
    }
}