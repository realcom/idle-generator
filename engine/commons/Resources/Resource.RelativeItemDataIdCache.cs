using System.Collections.Generic;

namespace Commons.Resources
{
    public partial class ResourceMap
    {
        public int ScoutQuickItemDataId => GetRelativeItemDataId("ScoutQuick");
        public int ProductScoutQuickItemDataId => GetRelativeItemDataId("ProductScoutQuick");
        
        public int ProductBuyTicketItemDataId => GetRelativeItemDataId("ProductBuyTicket");
    }

    public partial class ResourceItem
    {
        public int TimeLimitedMissionPointItemDataId => GetRelativeItemDataId("TimeLimitedMissionPoint");
    }
    
}