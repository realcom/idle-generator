using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

[CreateAssetMenu(fileName = nameof(CRCExtension), menuName = nameof(CRCExtension))]
public class CRCExtension : ClientScriptableSingleton<CRCExtension>
{
    [NonSerialized, OdinSerialize]
    public PageShopDesignDefinition pageShopDesignDefinition = new ();

    protected override void OnLoaded()
    {
        
    }
}

public abstract class DesignDefinition
{
}

[Serializable]
public class PageShopDesignDefinition : DesignDefinition
{
    [Serializable]
    public class TabDesign
    {
        public string titleStringKey;
        public Sprite spriteBanner;
    }
    
    [Serializable]
    public class GroupDesign
    {
        public enum PackageType
        {
            None,
            SimpleGrid,
            BannerPackage,
            ChestGacha,
            SpecialGacha,
        }
        
        public string titleStringKey;
        public PackageType packageType = PackageType.None;
        public int group = 0;
    }
    
    public Dictionary<int, TabDesign> tabDesigns = new();
    public List<List<GroupDesign>> groupDesigns = new();
    
    public TabDesign GetTabDesignByTabIndex(int tabIndex)
    {
        return tabDesigns.GetValueOrDefault(tabIndex);
    }
}