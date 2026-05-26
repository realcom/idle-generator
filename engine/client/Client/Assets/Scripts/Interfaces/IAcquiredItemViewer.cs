using System.Collections.Generic;
using Commons.Resources;
using Commons.Types.Players;
using UnityEngine;

namespace Interfaces
{
    public interface IAcquiredItemViewer
    {
        public IAcquiredItemViewer Initialize(IList<PlayerItemMessage> items, string title = null, ResourceItem resAcquiredItemSource = null);
    }
}
