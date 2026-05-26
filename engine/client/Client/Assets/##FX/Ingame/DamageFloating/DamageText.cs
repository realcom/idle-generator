using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEngine;
using Random = UnityEngine.Random;

public enum DamageTextType
{
    Default,
};

public enum IconType
{
    Miss,
    Critical,
    Execution,
    Heal,
    Damage,
};

public enum EffectType
{
    Default,
    Ineffective,
    Effective,
};

[Serializable]
public class DamageRenderSet
{
    public int spriteID = -1;
    public Sprite sprite;
    public Vector3 scale = Vector3.one;

    [Range(-1f, 1f)] 
    public float overlapPercent = 0f;
    public int paddingY;
    
    public Rect spriteRect;

    public void CacheAssetData()
    {
        if (sprite == null)
        {
            spriteID = -1;
            spriteRect = Rect.zero;
            return;
        }

        spriteID = int.Parse(sprite.name.Split('_')[^1]); 
        spriteRect = sprite.rect;
    }
}

[Serializable]
public class DamageIconRenderSet
{
    public IconType iconType;
    public DamageRenderSet renderSet;
}

public struct DamageUnitEmitData
{
    public Vector3 position;
    public Vector3 scale;
    public Rect rect;
    public int id;
    
    public Vector4 customData;
    public Color color;
}

[ExecuteAlways]
[RequireComponent(typeof(ParticleSystem))]
public class DamageText : SerializedMonoBehaviour
{
    public int[] yPaddingByDigits;
    
    public DamageRenderSet[] numberData;
    public DamageRenderSet dotData;
    public DamageRenderSet[] unitData;
    public DamageIconRenderSet[] iconData;

    private ParticleSystemRenderer particleSystemRenderer;
    private new ParticleSystem particleSystem;
    
    [SerializeField] private int _testCountPerTick;
    [SerializeField] private IconType _testIconType;
    [SerializeField] private ulong _testDamage;
    [SerializeField] private Color _testColor = Color.white;
    
    [Button("TestText")]
    public void TestText(int count = 1)
    {
        for (var i = 0; i < count; i++)
        {
            Show(transform.position + (Vector3)Random.insideUnitCircle, _testIconType, _testDamage, _testColor);
        }
    }

    [ContextMenu("CacheSpriteAssetData")]
    public void CacheSpriteAssetData()
    {
        for (var i = 0; i < numberData.Length; i++)
        {
            numberData[i].CacheAssetData();
        }
        for (var i = 0; i < unitData.Length; i++)
        {
            unitData[i].CacheAssetData();
        }
        for (var i = 0; i < iconData.Length; i++)
        {
            iconData[i].renderSet.CacheAssetData();
        }
        dotData.CacheAssetData();
    }

    private void OnValidate()
    {
        CacheSpriteAssetData();
    }

    private void Awake()
    {
        Initialize();
    }

    private bool initialized = false;
    private void Initialize()
    {
        if (initialized)
            return;
        initialized = true;
        
        if (particleSystem == null) 
            particleSystem = GetComponent<ParticleSystem>();

        if (particleSystemRenderer == null)
        {
            particleSystemRenderer = particleSystem.GetComponent<ParticleSystemRenderer>();
            var streams = new List<ParticleSystemVertexStream>();
            particleSystemRenderer.GetActiveVertexStreams(streams);
            
            //필수 stream 추가
            if (!streams.Contains(ParticleSystemVertexStream.UV2)) 
                streams.Add(ParticleSystemVertexStream.UV2);
            if (!streams.Contains(ParticleSystemVertexStream.Custom1XYZW))
                streams.Add(ParticleSystemVertexStream.Custom1XYZW);
            if (!streams.Contains(ParticleSystemVertexStream.Color))
                streams.Add(ParticleSystemVertexStream.Color);
            
            particleSystemRenderer.SetActiveVertexStreams(streams);
        }
    }
    
    
#if UNITY_EDITOR
    private void Update()
    {
        if (particleSystem.particleCount < _testCountPerTick)
            TestText();
        
        //particleSystem.GetCustomParticleData(customData, ParticleSystemCustomData.Custom1);
        //customData.Sort(DataComparer.Comparer);
        //particleSystem.SetCustomParticleData(customData, ParticleSystemCustomData.Custom1);
    }
#endif

    private readonly List<Vector4> customData = new();
    private readonly List<DamageUnitEmitData> _emitDataList = new();
    private static ParticleSystem.EmitParams _params;

    private int _globalSortIndex = 0;
    public void Show(Vector3 pos, IconType type, ulong value, Color? textColor = null)
    {
        Initialize();
        
        _globalSortIndex++;
        _globalSortIndex %= 999;

        var globalZ = _globalSortIndex / 1000;
        var globalW = _globalSortIndex % 1000;
        
        pos.z = 0f;
        
        _emitDataList.Clear();

        var width = 0f;
        var textDigit = 0;
        
        if (textColor == null)
            textColor = Color.white;

        AddUnitEmitData(iconData.GetSafe((int)type)?.renderSet, Color.white);

        if (value > 0)
        {
            AddValueText(textColor.Value);
        }

        for (var i = 0; i < _emitDataList.Count; i++)
        {
            var data = _emitDataList[i];
            
            data.position.x -= width * 0.5f;

            var localSortIndex = i + 1;
            data.customData.x = data.rect.x + 1000 * localSortIndex;
            data.customData.y = data.rect.y + 1000;
            data.customData.z = data.rect.width + 1000 * globalZ;
            data.customData.w = data.rect.height + 1000 * globalW;
            
            _emitDataList[i] = data;

            _params.position = pos + data.position;
            _params.position = new Vector3(_params.position.x, _params.position.y, -(0.00001f * i + 0.001f * _globalSortIndex));
            _params.startSize3D = data.scale * particleSystem.main.startSizeMultiplier;
            
            _params.startColor = data.color;

            particleSystem.Emit(_params, 1);
        }

        particleSystem.GetCustomParticleData(customData, ParticleSystemCustomData.Custom1);
        var dataCount = customData.Count;
        var emitCount = _emitDataList.Count;
        for (var i = 0; i < emitCount; i++)
        {
            customData[dataCount - emitCount + i] = _emitDataList[i].customData;
        }

        //customData.Sort(_dataComparer);
        particleSystem.SetCustomParticleData(customData, ParticleSystemCustomData.Custom1);
        //Debug.Log(string.Join("\n", customData));
        
        return;

        void AddValueText(Color color)
        {
            var values = value.ToUnitValues();
            
            for (var i = 0; i < values.Count; i++)
            {
                var unitValue = values[i];

                switch (unitValue.Item1)
                {
                    case Utility.UnitValueType.NUM:
                    {
                        if (numberData.GetSafe(unitValue.Item2, out var data))
                        {
                            AddUnitEmitData(data, color);
                        }
                        break;
                    }
                    case Utility.UnitValueType.DOT:
                    {
                        AddUnitEmitData(dotData, color);
                        break;
                    }
                    case Utility.UnitValueType.UNIT:
                    {
                        if (unitData.GetSafe(unitValue.Item2, out var data))
                        {
                            AddUnitEmitData(data, color);
                        }
                        break;
                    }
                    default:
                        throw new ArgumentOutOfRangeException();
                }
            }
        }
        
        void AddUnitEmitData(DamageRenderSet renderSet, Color color)
        {
            if (renderSet is null)
                return;
                
            DamageUnitEmitData data;

            var PPU = 1 / renderSet.sprite.pixelsPerUnit;
            
            data.id = renderSet.spriteID;
            data.scale = renderSet.scale;
            data.rect = renderSet.spriteRect;
            data.position.x = width + (data.rect.width * data.scale.x * PPU * 0.5f);
            var digitPadding = yPaddingByDigits?.GetSafe(textDigit++ % Math.Max(yPaddingByDigits.Length, 1)) ?? 0;
            data.position.y = (renderSet.paddingY + digitPadding) * PPU;
            data.position.z = 0f;
            data.customData = Vector4.zero;
            data.color = color;

            width += ((data.rect.width * data.scale.x) * (1f - renderSet.overlapPercent)) * PPU;
                
            _emitDataList.Add(data);
        }
        
    }

}
