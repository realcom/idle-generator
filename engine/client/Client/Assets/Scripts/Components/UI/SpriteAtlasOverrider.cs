using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Components.UI;
using Components.UI.Selectable;
using Components.UI.Toggle;
using Sirenix.OdinInspector;
using UnifiedToggle;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.U2D;
using UnityEngine.UI;
using Object = UnityEngine.Object;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.U2D;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings.GroupSchemas;
#endif

public class SpriteAtlasOverrider : MonoBehaviour
{
    [SerializeField] private SpriteAtlas m_SpriteAtlas;
    [SerializeField] private string m_SpriteAtlasPath;
    
    [SerializeField, ReadOnly] private List<Image> m_Images = new();
    [SerializeField, ReadOnly] private List<CustomSelectable> m_Selectables = new();
    [SerializeField, ReadOnly] private List<CustomToggle> m_Toggles = new();
    [SerializeField, ReadOnly] private List<SpriteContainer> m_SpriteContainers = new();
    [SerializeField, ReadOnly] private List<UnifiedToggleImage> m_UnifiedToggleImage = new();
    
    private readonly Dictionary<string, Sprite> m_GeneratedSprites = new(StringComparer.OrdinalIgnoreCase);

    private SpriteAtlas spriteAtlas { get; set; } = null;
    
    private void Awake()
    {
        spriteAtlas = m_SpriteAtlas;
        if (spriteAtlas != null)
        {
            try
            {
                OverrideSprites();
            }
            catch (Exception e)
            {
                Debug.LogError($"SpriteAtlas Override Failed: {gameObject.name}");
                throw;
            }
        }
    }

    private void OnDestroy()
    {
        //if (spriteAtlas != null)
        //    Addressables.Release(spriteAtlas);
        Resources.UnloadUnusedAssets();
    }

#if UNITY_EDITOR
    private void OnValidate()
    {
        CollectAll();
        CacheSpriteAtlasPath();
    }

    private void CacheSpriteAtlasPath()
    {
        if (m_SpriteAtlas != null)
            m_SpriteAtlasPath = AssetDatabase.GetAssetPath(m_SpriteAtlas);
    }
#endif

    [Button]
    private void OverrideSprites()
    {
        if (this == null)
            return;

        m_Images.RemoveAll(x => x == null);
        m_Selectables.RemoveAll(x => x == null);
        m_Toggles.RemoveAll(x => x == null);
        m_SpriteContainers.RemoveAll(x => x == null);
        m_UnifiedToggleImage.RemoveAll(x => x == null);
        
        m_GeneratedSprites.Clear();
        
        foreach (var image in m_Images)
        {
            image.sprite = GetGeneratedSprite(image.sprite);
        }
    
        foreach (var selectable in m_Selectables)
        {
            foreach (var transition in selectable.transitions)
            {
                switch (transition)
                {
                    case SpriteSwapTransition spriteSwapTransition:
                        var state = spriteSwapTransition.spriteState;
                        state.highlightedSprite = GetGeneratedSprite(state.highlightedSprite);
                        state.pressedSprite = GetGeneratedSprite(state.pressedSprite);
                        state.selectedSprite = GetGeneratedSprite(state.selectedSprite);
                        state.disabledSprite = GetGeneratedSprite(state.disabledSprite);
                        spriteSwapTransition.spriteState = state;
                        break;
                    case DisabledSpriteSwapTransition disabledSpriteSwapTransition:
                        disabledSpriteSwapTransition.disabledSprite = GetGeneratedSprite(disabledSpriteSwapTransition.disabledSprite);
                        break;
                }
    
            }
        }
        
        foreach (var toggle in m_Toggles)
        {
            foreach (var transition in toggle.toggleTransitions)
            {
                if (transition is not SpriteOverrideTransition spriteOverrideTransition)
                    continue;

                spriteOverrideTransition.overrideSprite = GetGeneratedSprite(spriteOverrideTransition.overrideSprite);
            }
        }
        
        foreach (var spriteContainer in m_SpriteContainers)
        {
            for (var i = 0; i < spriteContainer.sprites.Count; i++)
            {
                spriteContainer.sprites[i] = GetGeneratedSprite(spriteContainer.sprites[i]);
            }
        }
        
        foreach (var toggle in m_UnifiedToggleImage)
        {
            foreach (var option in toggle.Options)
            {
                switch (option)
                {
                    case UnifiedOptionImageSprite optionSprite:
                    {
                        foreach (var spriteOption in optionSprite.Options)
                        {
                            spriteOption.option = GetGeneratedSprite(spriteOption.option);
                        }
                        break;
                    }
                    case UnifiedOptionImageOverrideSprite optionOverrideSprite:
                    {
                        foreach (var spriteOption in optionOverrideSprite.Options)
                        {
                            spriteOption.option = GetGeneratedSprite(spriteOption.option);
                        }
                        break;
                    }
                }
            }
        }
        
        return;
    
        Sprite GetGeneratedSprite(Sprite originalSprite)
        {
            if (originalSprite == null)
                return null;
            
            var spriteName = originalSprite.name.Replace("(Clone)", "");
            if (!m_GeneratedSprites.TryGetValue(spriteName, out var sprite))
                m_GeneratedSprites[spriteName] = sprite = spriteAtlas.GetSprite(spriteName);
            sprite.name = spriteName;
            return sprite;
        }
        
    }

#if UNITY_EDITOR
    [Button]
    private void CollectAll(bool force = false)
    {
        var images = this.GetComponentsInChildrenWithSkip<Image, SpriteAtlasOverrider>(gameObject);
        m_Images.Clear();
        foreach (var image in images)
        {
            if (image.sprite == null)
                continue;

            if (!IsValidSprite(image.sprite))
                continue;

            if (!force && m_SpriteAtlas != null && !m_SpriteAtlas.CanBindTo(image.sprite))
                continue;
    
            m_Images.Add(image);
        }
        
        var selectables =  this.GetComponentsInChildrenWithSkip<CustomSelectable, SpriteAtlasOverrider>(gameObject);
        m_Selectables.Clear();
        foreach (var selectable in selectables)
        {
            if (selectable.transitions == null)
                continue;
            
            var found = false;
            foreach (var transition in selectable.transitions)
            {
                switch (transition)
                {
                    case SpriteSwapTransition spriteSwapTransition:
                        if (IsValidSprite(spriteSwapTransition.spriteState.highlightedSprite) ||
                            IsValidSprite(spriteSwapTransition.spriteState.pressedSprite) ||
                            IsValidSprite(spriteSwapTransition.spriteState.selectedSprite) ||
                            IsValidSprite(spriteSwapTransition.spriteState.disabledSprite))
                        {
                            found = true;
                        }
                        break;
                    case DisabledSpriteSwapTransition disabledSpriteSwapTransition:
                        if (IsValidSprite(disabledSpriteSwapTransition.disabledSprite))
                            found = true;
                        break;
                }
                
                if (found)
                    break;
            }

            if (!found)
                continue;
            
            m_Selectables.Add(selectable);
        }

        var toggles =  this.GetComponentsInChildrenWithSkip<CustomToggle, SpriteAtlasOverrider>(gameObject);
        m_Toggles.Clear();
        foreach (var toggle in toggles)
        {
            if (toggle.toggleTransitions == null)
                continue;
            
            var found = false;
            foreach (var transition in toggle.toggleTransitions)
            {
                switch (transition)
                {
                    case SpriteOverrideTransition spriteOverrideTransition:
                        if (IsValidSprite(spriteOverrideTransition.overrideSprite))
                            found = true;
                        break;
                }
                
                if (found)
                    break;
            }
            
            if (!found)
                continue;

            m_Toggles.Add(toggle);
        }
        
        var spriteContainers =  this.GetComponentsInChildrenWithSkip<SpriteContainer, SpriteAtlasOverrider>(gameObject);
        m_SpriteContainers.Clear();
        foreach (var spriteContainer in spriteContainers)
        {
            if (spriteContainer.sprites?.Count < 1)
                continue;

            if (spriteContainer.sprites?.All(x => !IsValidSprite(x)) == true)
                continue;

            if (!force && m_SpriteAtlas != null && spriteContainer.sprites?.Any(x => !m_SpriteAtlas.CanBindTo(x)) == true)
                continue;

            m_SpriteContainers.Add(spriteContainer);
        }
        
        var unifiedToggleImages = this.GetComponentsInChildrenWithSkip<UnifiedToggleImage, SpriteAtlasOverrider>(gameObject);
        m_UnifiedToggleImage.Clear();
        foreach (var unifiedToggleImage in unifiedToggleImages)
        {
            var found = false;
            foreach (var option in unifiedToggleImage.Options)
            {
                switch (option)
                {
                    case UnifiedOptionImageSprite optionSprite:
                    {
                        foreach (var spriteOption in optionSprite.Options)
                        {
                            if(spriteOption.option == null)
                                continue;

                            if (!IsValidSprite(spriteOption.option))
                                continue;
                                    
                            if (!force && m_SpriteAtlas != null && !m_SpriteAtlas.CanBindTo(spriteOption.option))
                                continue;

                            found = true;
                            break;
                        }
                        break;
                    }
                    case UnifiedOptionImageOverrideSprite optionOverrideSprite:
                    {
                        foreach (var spriteOption in optionOverrideSprite.Options)
                        {
                            if(spriteOption.option == null)
                                continue;

                            if (!IsValidSprite(spriteOption.option))
                                continue;
                                    
                            if (!force && m_SpriteAtlas != null && !m_SpriteAtlas.CanBindTo(spriteOption.option))
                                continue;

                            found = true;
                            break;
                        }
                        break;
                    }
                }

                if (found)
                    break;

            }

            if (!found)
                continue;
            
            m_UnifiedToggleImage.Add(unifiedToggleImage);
        }
        

    }
    
    private bool IsValidSprite(Sprite sprite)
    {
        if (sprite == null)
            return false;
        
        var assetPath = AssetDatabase.GetAssetPath(sprite);
        if (assetPath.Contains("FX", StringComparison.OrdinalIgnoreCase) || assetPath.Contains("##", StringComparison.OrdinalIgnoreCase))
            return false;

        return true;
    }
    
    [Button]
    private void CreateSpriteAtlasWithSprites()
    {
        CollectAll(m_SpriteAtlas == null);
        
        m_Images.RemoveAll(x => x == null);
        m_Selectables.RemoveAll(x => x == null);
        m_Toggles.RemoveAll(x => x == null);
        m_SpriteContainers.RemoveAll(x => x == null);
        
        HashSet<Sprite> sprites = new();
        
        m_Images.ForEach(x =>
        {
            if (IsValidSprite(x.sprite))
                sprites.Add(x.sprite);
        });
        
        m_Selectables.ForEach(x =>
        {
            foreach (var transition in x.transitions)
            {
                switch (transition)
                {
                    case SpriteSwapTransition spriteSwapTransition:

                        var state = spriteSwapTransition.spriteState;
                        if (IsValidSprite(state.highlightedSprite))
                            sprites.Add(state.highlightedSprite);
                        if (IsValidSprite(state.pressedSprite))
                            sprites.Add(state.pressedSprite);
                        if (IsValidSprite(state.selectedSprite))
                            sprites.Add(state.selectedSprite);
                        if (IsValidSprite(state.disabledSprite))
                            sprites.Add(state.disabledSprite);
                        break;
                    case DisabledSpriteSwapTransition disabledSpriteSwapTransition:
                        if (IsValidSprite(disabledSpriteSwapTransition.disabledSprite))
                            sprites.Add(disabledSpriteSwapTransition.disabledSprite);
                        break;
                }
            }
        });
        
        m_Toggles.ForEach(x =>
        {
            foreach (var transition in x.toggleTransitions)
            {
                if (transition is not SpriteOverrideTransition spriteOverrideTransition)
                    continue;

                if (IsValidSprite(spriteOverrideTransition.overrideSprite))
                    sprites.Add(spriteOverrideTransition.overrideSprite);
            }
        });
        
        m_SpriteContainers.ForEach(x =>
        {
            foreach (var sprite in x.sprites)
            {
                if (IsValidSprite(sprite))
                    sprites.Add(sprite);
            }
        });
        
        //해당 스프라이트들은 압축 해제
        foreach (var sprite in sprites)
        {
            var path = AssetDatabase.GetAssetPath(sprite);
            var imp = (TextureImporter)AssetImporter.GetAtPath(path);
            if (imp.textureType != TextureImporterType.Sprite)
                continue;
            
            if (imp.spriteImportMode != SpriteImportMode.Single)
                continue;
            
            if (imp.mipmapEnabled || imp.textureCompression != TextureImporterCompression.Uncompressed || imp.isReadable)
            {
                imp.mipmapEnabled = false;
                imp.textureCompression = TextureImporterCompression.Uncompressed;
                imp.isReadable = false;
                AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
            }
        }

        // 새로운 SpriteAtlas 인스턴스 생성
        var atlas = new SpriteAtlasAsset();
        // SpriteAtlasExtensions.Add 메서드를 사용해 스프라이트 추가
        atlas.Add(sprites.ToArray());

        var atlasAssetPath = $"Assets/Popups/{gameObject.name}.spriteatlasv2";
        SpriteAtlasAsset.Save(atlas, atlasAssetPath);
        
        AssetDatabase.Refresh();

        var importer = (SpriteAtlasImporter)AssetImporter.GetAtPath(atlasAssetPath);
        // (선택 사항) Packing 설정
        var packingSettings = new SpriteAtlasPackingSettings()
        {
            blockOffset = 1,
            padding = 2,
            enableRotation = true,
            enableTightPacking = false,
            enableAlphaDilation = true
        };
        importer.packingSettings = packingSettings;
        importer.includeInBuild = false;

        // (선택 사항) Texture 설정
        var textureSettings = new SpriteAtlasTextureSettings()
        {
            generateMipMaps = false,
            sRGB = true,
            filterMode = FilterMode.Bilinear,
            readable = false
        };
        importer.textureSettings = textureSettings;

        AssetDatabase.WriteImportSettingsIfDirty(atlasAssetPath);
        
        //var settings = AddressableAssetSettingsDefaultObject.Settings;
        //if (settings != null)
        //{
        //    // "Atalses" 그룹 검색, 없으면 생성
        //    var group = settings.FindGroup("Atlases");
        //    if (group == null)
        //    {
        //        // 기본 그룹의 스키마를 사용하여 그룹을 생성합니다.
        //        group = settings.CreateGroup("Atlases", false, false, false, settings.DefaultGroup.Schemas, typeof(BundledAssetGroupSchema));
        //    }
        //    
        //    // 에셋의 GUID를 얻어 Addressable Asset Entry를 생성하거나 이동합니다.
        //    string guid = AssetDatabase.AssetPathToGUID(atlasAssetPath);
        //    var entry = settings.CreateOrMoveEntry(guid, group);
        //    
        //    // 주소(Address)를 파일명(확장자 제외)으로 설정 (원하는 주소를 지정할 수 있습니다)
        //    entry.address = atlasAssetPath;
        //    Debug.Log("Atlas를 Addressable 그룹 'Atalses'에 등록했습니다. 주소: " + entry.address);
        //}
        
        m_SpriteAtlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(atlasAssetPath);
        CacheSpriteAtlasPath();
    }
#endif
}
