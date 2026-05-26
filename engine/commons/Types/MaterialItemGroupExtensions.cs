using System.Collections.Generic;
using Commons.Resources;

namespace Commons.Types
{
    public static class MaterialItemGroupExtensions
    {
        public static IEnumerable<MaterialItem> Flatten(this MaterialItemGroup? group)
        {
            if (group == null)
                yield break;

            foreach (var item in group.MaterialItems)
            {
                yield return item;
            }
        }
        
        public static IEnumerable<MaterialItem> Flatten(this IEnumerable<MaterialItemGroup>? groups)
        {
            if (groups == null)
                yield break;

            foreach (var group in groups)
            {
                foreach (var item in group.Flatten())
                {
                    yield return item;
                }
            }
        }
    }
}
