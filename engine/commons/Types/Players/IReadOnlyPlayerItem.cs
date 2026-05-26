
using Commons.Resources;
using Commons.Types.Units;

namespace Commons.Types.Players
{
    public interface IReadOnlyPlayerItem
    {
        public long Id { get; }
        public int DataId { get; }
        public int Level { get; }
        public PlayerItemOption? PlayerItemOption { get; }
    }
    
}

