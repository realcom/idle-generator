using System;
using Newtonsoft.Json;
using Server.Managers;

namespace Commons.Types.Players
{
    public partial class PlayerAvatar
    {
        [NonSerialized]
        public ICashItemManager? CashItemManager;

        private bool _dirty;
        [JsonIgnore]
        public bool Dirty
        {
            get => _dirty;
            set
            {
                _dirty = value;
                if (value)
                    CashItemManager?.SetDirty();
            }
        }
    }
}
