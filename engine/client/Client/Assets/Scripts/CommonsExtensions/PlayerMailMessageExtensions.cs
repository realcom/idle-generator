
using Commons.Resources;
using Interfaces;

namespace Commons.Types.Players
{
    public partial class  PlayerMailMessage
    {
        public bool HasRelevanceNotice()
        {
            if (IsClientPredefinedMail())
                return ResourceItem.Get(itemDataId_)!.HasRelevanceNotice();
            
            return untilAt_ == null || untilAt_.ToSeconds() > TimeSystem.time;
        }

        public bool IsClientPredefinedMail()
        {
            return sender_?.Id < 0;
        }
    }

    public partial class PlayerMailAddItem : IItemModelViewFormatter<PlayerMailAddItem>
    {
        public long Id => 0;
        
        public long GetCount()
        {
            return itemCount_;
        }

        public int GetLevel()
        {
            return itemLevel_;
        }
    }
}