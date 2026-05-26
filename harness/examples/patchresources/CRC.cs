using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Units;
using Commons.Utility;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "ClientResourceContainer", menuName = "ClientResourceContainer")]
public class CRC : ClientScriptableSingleton<CRC>
{
    [Serializable]
    public struct TabBarSpriteSet
    {
        public Sprite normalLeft;
        public Sprite normalCenter;
        public Sprite normalRight;
        public Sprite selectedLeft;
        public Sprite selectedCenter;
        public Sprite selectedRight;
    }
    
    [Serializable]
    public class GlobalParameters
    {
        public float hitEffectIntensity = 0.5f;
        [Tooltip("Half")] public float hitEffectDuration = 0.2f;
        public Color playerHitEffectColor = Color.red;
        public Color playerHealEffectColor = Color.green;
        public Color playerShieldHealEffectColor = Color.blue;
        public Color enemyHitEffectColor = Color.white;
        public float rebirthValidDuration = 5f;
        public float rebirthDelay = 1.5f;
        public float autoSpawnPeriod = 1f;
    }
    
    [Serializable]
    public class NinjaPointAmountSpritePair
    {
        public long amount;
        public Sprite sprite;
    }

    [Serializable]
    public class TabDesignDefinition
    {
        [SerializeField] private string tabNameKey;
        [SerializeField] private string tabIconPath;
        
        public string tabName { get; private set; }
        public LazyLoad<Sprite> tabIcon { get; private set; }

        public void OnLoaded()
        {
            tabName = tabNameKey.L();
            if (!string.IsNullOrEmpty(tabIconPath))
                tabIcon = new LazyLoad<Sprite>(tabIconPath);
        }
    }

    public string enoughColorHex => enoughColor.ToHex();
    public string notEnoughColorHex => notEnoughColor.ToHex();
    
    public GlobalParameters globalParameters = new();
    
    //Row: Rarity, Column: Grade
    [TableMatrix(SquareCells = true, HorizontalTitle = "Grade", VerticalTitle = "Rarity")]
    public int[,] luckyEffectLevels = new int[0, 0];
    
    public Dictionary<string, List<TabDesignDefinition>> tabDefinitions = new();

    private static List<TabDesignDefinition> emptyTabs = new();
    public IList<TabDesignDefinition> GetTabDefinitionsByKey(string key)
    {
        return tabDefinitions.GetValueOrDefault(key) ?? emptyTabs;
    }

    public Dictionary<string, List<int>> goodsItemDataIdsByKey = new();

    private static int[] defaultGoodsItemDataIds = null;
    public IList<int> GetGoodsItemDataIds(string key)
    {
        defaultGoodsItemDataIds ??= new[] { ResourceItem.Global.DataId.Credit, ResourceItem.Global.DataId.Ruby, ResourceItem.Global.DataId.Energy };
        if (goodsItemDataIdsByKey.TryGetValue(key, out var list))
            return list;

        return defaultGoodsItemDataIds;
    }
    
    public Dictionary<string, int> premiumItemDataIdByKey = new();

    public Color enoughColor;
    public Color notEnoughColor;
    public Color[] gradeColors = new Color[0];
    public Sprite[] gradeIcons = new Sprite[0];
    public Sprite[] extraGradeIcons = new Sprite[0];
    public Sprite[] gradeCellFrameSprites = new Sprite[0];
    public Sprite[] gradeMiniFrameSprites = new Sprite[0];
    public Sprite[] gradeSymbolSprites = new Sprite[0];
    public Sprite[] gradeFootboardSprites = new Sprite[0];
    public Sprite[] miniGradeFrameSprites = new Sprite[0];
    public Sprite[] miniGradeDecoSprites = new Sprite[0];
    public Sprite[] levelStarSprites = new Sprite[0];
    public Sprite[] rankCellSprites = new Sprite[0];
    public Sprite[] equipmentFrameSprites = new Sprite[0];
    //public TabBarSpriteSet tabBarSpriteSet;
    public Sprite[] staminaBorderSprites = new Sprite[0];
    public Sprite[] staminaFillSprites = new Sprite[0];
    public Sprite[] staminaCircleFillSprites = new Sprite[0];
    public Sprite[] staminaBatteryFillSprites = new Sprite[0];
    public NinjaPointAmountSpritePair[] ninjaPointSpritePairs = new NinjaPointAmountSpritePair[0];
    
    [Tooltip("            public const int Neutral = 0;\n\n            public const int Player = 1;\n            public const int PlayerRed = 2;\n            public const int PlayerBlue = 3;\n            \n            public const int Enemy = 4;\n            public const int EnemyElite = 5;\n            public const int EnemyBoss = 6;")]
    public Sprite[] unitHpBarFill = new Sprite[0];
    public Sprite[] unitHpBarFillFake = new Sprite[0];
    
    public Color[] unitHpBarFillColor = new Color[0];
    public Color[] unitHpBarFillFakeColor = new Color[0];
    public Vector3[] unitHpBarScales = new Vector3[0];
    
    [SerializeField] private Color[] m_RarityCellColors = new Color[0];
    public Color GetRarityCellColor(int rarity)
    {
        return m_RarityCellColors.GetClamped(rarity);
    }
    
    [SerializeField] private Sprite[] m_RarityCellFrameSprites = new Sprite[0];
    public Sprite GetRarityCellFrameSprite(int rarity)
    {
        return m_RarityCellFrameSprites.GetClamped(rarity);
    }

    public Dictionary<ResourceItem.Types.Type, Sprite> itemTypeIcons = new();
    
    [SerializeField] private Dictionary<ResourceItem.Types.WeaponCategory, Color> m_WeaponCategoryCellColors = new ();
    public Color GetWeaponCategoryCellColor(ResourceItem.Types.WeaponCategory weaponCategory)
    {
        return m_WeaponCategoryCellColors.GetValueOrDefault(weaponCategory, Color.white);
    }
    
    [SerializeField] private Material[] m_BoardWeaponImageMaterials = new Material[0];
    public Material GetBoardWeaponImageMaterial(int rarity)
    {
        return m_BoardWeaponImageMaterials.GetClamped(rarity);
    }
    
    public Dictionary<ArmorType, Sprite> unitArmorTypeIcons;
    public Dictionary<DamageType, Sprite> damageTypeIcons;
    public Sprite consumableTypeIcon;
    public Dictionary<EffectType, Color> effectTypeColors;
    
    public Dictionary<int, Color> damageTextColorsBySkillGroup = new();
    public Dictionary<int, Color> damageTextColorsByBuffGroup = new();

    [Serializable]
    public struct AbilityTrainingUnitStep
    {
        public string stepNameKey;
        public int openAchievementDataId;
        public int focusAchievementDataId;
        public int completeAchievementDataId;
    }
    
    public AbilityTrainingUnitStep[] abilityTrainingUnitSteps = new AbilityTrainingUnitStep[0];
    
    public enum SnsType
    {
        Telegram,
        TwitterX,
        AAO,
        Mhaya,
        FishWar,
        ElectionWars,
        Chickizen,
        PANIE,
        CoinCrypto,
        Mimiland,
        Poplaunch,
        Yuligo
    }
    
    [DictionaryDrawerSettings(KeyLabel = "SNS 종류", ValueLabel = "아이콘")]
    public Dictionary<SnsType, Sprite> snsIconSprites;
    
    [Serializable, HideReferenceObjectPicker]
    public class StatInfo
    {
        public string temporaryName;
        public string stringKey;
        [Obsolete("Use spritePath instead.")] public Sprite sprite;
        public string spritePath;
        [Tooltip("오름차순 표기. 해당 값이 0이하라면 주둔지 능력 확인 팝업에서 미표기")]
        public int order;
        public float minDisplayValue;
        public float maxDisplayValue;
        public string displayFormat = "{0:NF0}";
        public float displayCoefficient = 1;

        public string GetName()
        {
            var name = stringKey.L();
            if (ReferenceEquals(name, stringKey))
                name = temporaryName;

            return name;
        }

        private LazyLoad<Sprite> _lazySprite;
        public Sprite GetSprite()
        {
            _lazySprite ??= new LazyLoad<Sprite>(spritePath);
            return _lazySprite;
        }

        public string GetNameWithIcon()
        {
            return spritePath.ToIconSpriteString() + " " + GetName();
        }
		
        public string Format(double value)
        {
            return string.Format(_formatter, displayFormat, value * displayCoefficient);
        }
    
        private static readonly StatFormatter _formatter = new StatFormatter();
    
        private const int CUSTOM_FORMATTER_INDEX = 1;
        private const int DECIMAL_PLACES_INDEX = 2;
    
        private class StatFormatter : IFormatProvider, ICustomFormatter
        {
            public object GetFormat(System.Type formatType)
            {
                return formatType == typeof(ICustomFormatter) ? this : null;
            }

            public string Format(string format, object arg, IFormatProvider formatProvider)
            {
                if (arg is not double value)
                    return string.Empty;

                var isPercent = format.EndsWith("%");

                var decimal_places = format[DECIMAL_PLACES_INDEX];

                var multiplier = Math.Max(1, Math.Pow(10, (decimal_places - '0')));
                value *= multiplier;

                value = format[CUSTOM_FORMATTER_INDEX] switch
                {
                    'R' => Math.Round(value),
                    'F' => Math.Floor(value),
                    'C' => Math.Ceiling(value),
                    _ => value
                };
                
                value /= multiplier;

                decimal_places = value % 1 < float.Epsilon ? '0' : decimal_places;

                var numberFormat = $"{{0:N{decimal_places}}}";
                if (isPercent)
                    numberFormat += "%"; // Add percent sign for percentage values

                return string.Format(numberFormat, value);
            }
        }
    }
    [DictionaryDrawerSettings(KeyLabel = "스탯 종류", ValueLabel = "스탯 정보")]
    public Dictionary<UnitStatType, StatInfo> statInfo;
    
    public Color GetGradeColor(int grade)
    {
        return gradeColors.GetClamped(grade);
    }
    
    public Sprite GetGradeIcon(int grade)
    {
        return gradeIcons.GetClamped(grade);
    }
    
    public Sprite GetGradeCellFrameSprite(int grade)
    {
        return gradeCellFrameSprites.GetClamped(grade);
    }
    
    public Sprite GetGradeMiniFrameSprite(int grade)
    {
        return gradeMiniFrameSprites.GetClamped(grade);
    }
    
    public Sprite GetRankCellSprite(int rank)
    {
        return rankCellSprites.GetClamped(rank - 1);
    }
    
    public Sprite GetStaminaBorderSprite(float normalizedStaminaValue)
    {
        var index = Mathf.RoundToInt(normalizedStaminaValue * (staminaBorderSprites.Length - 1));
        return staminaBorderSprites.GetClamped(index);
    }
    
    public Sprite GetStaminaFillSprite(float normalizedStaminaValue)
    {
        var index = Mathf.RoundToInt(normalizedStaminaValue * (staminaFillSprites.Length - 1));
        return staminaFillSprites.GetClamped(index);
    }
    
    public Sprite GetStaminaCircleFillSprite(float normalizedStaminaValue)
    {
        var index = Mathf.CeilToInt(normalizedStaminaValue / (1.0f / staminaCircleFillSprites.Length));
        return staminaCircleFillSprites.GetClamped(index);
    }
    
    public Sprite GetStaminaBatteryFillSprite(float normalizedStaminaValue)
    {
        var index = Mathf.CeilToInt(normalizedStaminaValue / (1.0f / staminaCircleFillSprites.Length));
        return staminaBatteryFillSprites.GetClamped(index);
    }
    
    public Sprite GetSnsIconSprite(SnsType snsType)
    {
        return snsIconSprites.GetValueOrDefault(snsType);
    }
    
    public Sprite GetUnitHpBarFillSprite(int team)
    {
        return unitHpBarFill.GetClamped(team);
    }
    
    public Color GetUnitHpBarFillColor(int team)
    {
        return unitHpBarFillColor.GetClamped(team);
    }
    
    public Sprite GetUnitHpBarFillFakeSprite(int team)
    {
        return unitHpBarFillFake.GetClamped(team);
    }
    
    public Color GetUnitHpBarFillFakeColor(int team)
    {
        return unitHpBarFillFakeColor.GetClamped(team);
    }
    
    public Vector3 GetUnitHpBarScale(int team)
    {
        return unitHpBarScales.GetClamped(team);
    }
    
    public Sprite GetUnitArmorTypeSprite(ArmorType armorType)
    {
        return unitArmorTypeIcons.GetValueOrDefault(armorType);
    }
    
    public Sprite GetDamageTypeSprite(DamageType damageType)
    {
        return damageTypeIcons.GetValueOrDefault(damageType);
    }
    
    public Color GetEffectTypeColor(EffectType effectType)
    {
        return effectTypeColors.GetValueOrDefault(effectType);
    }
    
    [SerializeField] private Dictionary<ZModeManagerBattle.WavePointType, Sprite> m_WavePointSprites = new();
    public Sprite GetWavePointSprite(ZModeManagerBattle.WavePointType wavePointType)
    {
        return m_WavePointSprites.GetValueOrDefault(wavePointType);
    }
    
    public Dictionary<int, List<List<int>>> appearMonsterDataIdsByMapId = new();

    protected override void OnLoaded()
    {
        foreach (var definitions in tabDefinitions.Values)
        {
            foreach (var definition in definitions)
            {
                definition.OnLoaded();
            }
        }
    }
}
