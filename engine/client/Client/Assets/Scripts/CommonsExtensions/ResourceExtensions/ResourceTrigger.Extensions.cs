using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        public override int GetId() => -1;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Trigger;
        public override bool CanDisplay => false;

        public override bool HasRelevanceNotice()
        {
            return false;
        }
    }
}