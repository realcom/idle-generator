using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Text;
using Google.Protobuf.Collections;
using Spine;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.UI;
using Object = UnityEngine.Object;
using Resources = UnityEngine.Resources;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
#endif

public static partial class Utility
{
    [Serializable]
    public class TextCell : UIElement
    {
        public TextMeshProUGUI txtString;
    }
    
    [Serializable]
    public class GoodsCell : UIElement
    {
        public CustomButton btnGoodsCell;
        public Image imgIcon;
        public RectTransform rtGotoShop;
        public TextMeshProUGUI txtAmount;
        public TextTimer timerTimeLeft;
        
        public RedDot redDot;
    }

    public static void RefreshGoods(this UIElementContainer<GoodsCell> goodsContainer, IList<int> goodsIds)
    {
        foreach (var (element, index) in goodsContainer.GetElements(goodsIds.Count))
        {
            var goodsId = goodsIds[index];
            var resGoods = ResourceItem.Get(goodsId);
            var myItem = MyPlayer.GetItemByDataID(goodsId, checkTimeValid: false);
            if (resGoods == null || myItem == null)
            {
                element.elementRoot.SetActive(false);
                continue;
            }

            element.elementRoot.SetActive(true);
            element.imgIcon.sprite = resGoods.ClientSpriteIcon;
            
            if (resGoods.Category == ResourceItem.Types.Category.Boost)
            {
                if (myItem.UntilAt is not null && myItem.IsValid())
                {
                    element.timerTimeLeft.SetActive(true);
                    element.txtAmount.SetActive(false);
                    
                    element.timerTimeLeft.targetTimeAt = myItem.UntilAt.ToDateTime().ToSeconds();
                    element.timerTimeLeft.SetExpiredCallback(() =>
                    {
                        element.timerTimeLeft.SetActive(false);
                    });
                }
                else
                {
                    element.elementRoot.SetActive(false);
                    continue;
                }
            }
            else
            {
                if (resGoods.RegenPeriod > 0)
                {
                    element.timerTimeLeft.SetActive(myItem.GetCount() < resGoods.MaxCount + myItem.Param3);
                    element.timerTimeLeft.targetTimeAt = OffsetSecondsToSeconds(myItem.Param2) + resGoods.RegenPeriod + myItem.Param4;
                    element.timerTimeLeft.SetExpiredCallback(() => { element.timerTimeLeft.SetActive(false); });
                }
                else
                {
                    element.timerTimeLeft.SetActive(false);
                }
                
                element.txtAmount.SetActive(true);
                element.txtAmount.text = resGoods.ContainsTag(Tag.AddParam1ToCount) ? $"{myItem.GetCountString()}/{resGoods.MaxCount + (myItem?.Param3 ?? 0)}" : myItem.GetCountString();
            }
            
            var hasAcquisitionablePopup = resGoods.HasPopupArgs("AcquisitionablePopup");

            element.rtGotoShop.SetActive(hasAcquisitionablePopup);
            element.redDot.Register(resGoods);
            
            if (element.btnGoodsCell)
            {
                element.btnGoodsCell.interactable = hasAcquisitionablePopup;
                element.btnGoodsCell.SetOnClick(resGoods.ShowAcquisitionablePopup);
            }
        }
    }
    
    [Serializable]
    public class RequirementMaterialCell : UIElement
    {
        public TextMeshProUGUI txtAmount;
    }

    public static void Clear(this UIElementContainer<RequirementMaterialCell> container)
    {
        foreach (var valueTuple in container.GetElements(0))
        {
            
        }
    }

    public static bool RefreshRequirements(this UIElementContainer<RequirementMaterialCell> container, IEnumerable<MaterialItem> materialItems, float priceMultiplier = 1.0f)
    {
        var hasEveryMaterialEnough = true;
        
        foreach (var (element, index, materialItem) in container.GetElements(materialItems ?? Enumerable.Empty<MaterialItem>()))
        {
            var neededCount = materialItem.Count * priceMultiplier;
            var currentCount = MyPlayer.GetValidMaterialCount(materialItem.Id);
                
            var hasEnough = currentCount >= neededCount;
                
            hasEveryMaterialEnough &= hasEnough;

            element.txtAmount.text = materialItem.ToStringWithIconFormat("{0} {9}/{2}", priceMultiplier: priceMultiplier);
        }

        return hasEveryMaterialEnough;
    }
    
    public static bool RefreshRequirements(this TextMeshProUGUI text, IEnumerable<MaterialItem> materialItems, float priceMultiplier = 1.0f)
    {
        var hasEveryMaterialEnough = true;

        using var sb = ZString.CreateStringBuilder();
        
        foreach (var materialItem in materialItems ?? Enumerable.Empty<MaterialItem>())
        {
            var neededCount = materialItem.Count * priceMultiplier;
            var currentCount = MyPlayer.GetValidMaterialCount(materialItem.Id);
                
            var hasEnough = currentCount >= neededCount;
                
            hasEveryMaterialEnough &= hasEnough;

            sb.Append(materialItem.ToStringWithIconFormat("{0} {9}/{2}", priceMultiplier: priceMultiplier));
            sb.Append("  ");
        }

        if (sb.Length > 0)
        {
            sb.Remove(sb.Length - 2, 2);
            text.SetText(sb);
        }

        return hasEveryMaterialEnough;
    }
    
    public static string ToHex(this Color color)
    {
        var hex = ColorUtility.ToHtmlStringRGBA(color);
        return hex;
    }

    public static void ToToastFromRaw(this string message)
    {
        Toast.Show<Popup_Toast>(message);
    }

    public static void ToToast(this string key, params object[] args)
    {
        ToToastFromRaw(key.L(args));
    }

    public static void ToToast(this StatusCode status)
    {
        ToToastFromRaw(status.ToString().L());
    }
    
    public static string GetInfiniteSign(this TMP_Text text)
    {
        return text.GetInfiniteSignContainBuilder().ToString();
    }

    public static Utf16ValueStringBuilder GetInfiniteSignContainBuilder(this TMP_Text text)
    {
        var signFontSize = text.fontSize * 2;
        var builder = ZString.CreateStringBuilder();
        builder.AppendFormat("<size={0}><voffset={1}>∞</voffset></size>", signFontSize, -(signFontSize / 8));
        return builder;
    }
    
    public static void SetUnitSpineUI(this SkeletonGraphic avatar, ResourceUnit resUnit, string animationName = "Idle", float animTimeScale = float.NegativeInfinity)
    {
        var skeletonAnimation = resUnit?.ClientPrefab?.Get()?.GetComponentInChildren<SkeletonAnimation>();
        if (skeletonAnimation == null)
        {
            avatar.SetActive(false);
            return;
        }

        avatar.SetActive(true);
        foreach (var componentsInChild in avatar.GetComponentsInChildren<RawImage>())
        {
            componentsInChild.color = Color.clear;
        }

        var prefab = resUnit!.ClientPrefab!.Get();
        avatar.transform.localScale.Scale(prefab.transform.localScale);
        avatar.skeletonDataAsset = skeletonAnimation.skeletonDataAsset;
        avatar.initialSkinName = skeletonAnimation.initialSkinName;
        avatar.Initialize(true);

        if (!string.IsNullOrEmpty(animationName))
            avatar.SetAnimation(animationName, true, 0, animTimeScale);

        avatar.SetMaterialDirty();
    }
    
    public static TrackEntry SetAnimation(this SkeletonGraphic avatar, string animationName, bool loop = true, int trackIndex = 0, float animTimeScale = float.NegativeInfinity, string afterAnimationName = "")
    {
        var animation = avatar.SkeletonDataAsset.GetSkeletonData(true).FindAnimation(animationName);
        if (animation == null)
            return null;
        
        var entry = avatar.AnimationState.SetAnimation(trackIndex, animationName, loop);
        if (!float.IsNegativeInfinity(animTimeScale))
            entry.TimeScale = animTimeScale;
        
        if (!loop)
        {
            if (string.IsNullOrEmpty(afterAnimationName))
                avatar.AnimationState.AddEmptyAnimation(trackIndex, avatar.SkeletonDataAsset.defaultMix, animation.Duration);
            else
                avatar.AnimationState.AddAnimation(trackIndex, afterAnimationName, true, animation.Duration);
        }
        return entry;
    }

    public readonly struct FormatableStatInfo
    {
        public readonly UnitStatType type;
        public readonly CRC.StatInfo info;
        public readonly AddUnitStat stat;
        
        public FormatableStatInfo(UnitStatType type, CRC.StatInfo info, AddUnitStat stat)
        {
            this.type = type;
            this.info = info;
            this.stat = stat;
        }
        
        public float GetValue(int level)
        {
            return stat?.Value.GetClamped(level - 1) ?? 0f;
        }

        public string GetFormatString(int level)
        {
            return info.Format(GetValue(level));
        }
        
        public string GetNameString(bool nameWithIcon = true)
        {
            return nameWithIcon ? info.GetNameWithIcon() : info.GetName();
        }
        
        public string GetInlineFormatString(int level, bool nameWithIcon = true)
        {
            return $"{GetNameString(nameWithIcon)} {GetFormatString(level)}";
        }
        
    }
    
    public static IEnumerable<FormatableStatInfo> AsSorted(this RepeatedField<AddUnitStat> source, int displayTargetLevel = 0)
    {
        using var infos = PooledList<FormatableStatInfo>.Get();
        using var stats = PooledDictionary<UnitStatType, AddUnitStat>.Get();

        foreach (var stat in source)
        {
            if (displayTargetLevel > 0 && Math.Abs(stat.Value.GetClamped(displayTargetLevel - 1)) < float.Epsilon)
                continue;

            stats[stat.Type] = stat;
        }
        
        foreach (var (type, value) in stats)
        {
            if (CRC.Get().statInfo.TryGetValue(type, out var info))
                infos.Add(new FormatableStatInfo(type, info, value));
        }

        infos.Sort((x, y) => x.info.order.CompareTo(y.info.order));
        
        foreach (var tuple in infos)
        {
            yield return tuple;
        }
    }

    public static FormatableStatInfo GetStatInfo(this RepeatedField<AddUnitStat> source, UnitStatType statType)
    {
        var info = CRC.Get().statInfo[statType];
        return new FormatableStatInfo(statType, info, source.FirstOrDefault(x => x.Type == statType));
    }
    
        /**
     * Exmaple:
     * <LayoutGroup Key="Key">
     *      <Padding>0,0,0,0</Padding>
     *      <Alignment>Vertical+Horzontal</Alignment> (Horizontal: Left, Center, Right / Vertical: Uppder, Middle, Lower)
     *      <Alignment>MiddleCenter</Alignment>
     *      <Constraint Count="2">Flexible,FixedColumnCount,FixedRowCount</Constraint>
     * </LayoutGroup>
     */
    public struct LayoutGroupParams
    {
        public readonly struct Padding : IEquatable<Padding>, IEqualityComparer<Padding>
        {
            public readonly int left;
            public readonly int right;
            public readonly int top;
            public readonly int bottom;
            
            public Padding(int inLeft, int inRight, int inTop, int inBottom)
            {
                left = inLeft;
                right = inRight;
                top = inTop;
                bottom = inBottom;
            }
            
            public static Padding zero = new(0, 0, 0, 0);

            public bool Equals(Padding other)
            {
                return left == other.left && right == other.right && top == other.top && bottom == other.bottom;
            }

            public override bool Equals(object obj)
            {
                return obj is Padding other && Equals(other);
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(left, right, top, bottom);
            }

            public bool Equals(Padding x, Padding y)
            {
                return x.left == y.left && x.right == y.right && x.top == y.top && x.bottom == y.bottom;
            }

            public int GetHashCode(Padding obj)
            {
                return obj.GetHashCode();
            }
            
            public static bool operator ==(Padding left, Padding right)
            {
                return left.Equals(right);
            }

            public static bool operator !=(Padding left, Padding right)
            {
                return !(left == right);
            }
        }

        public readonly Padding padding;
        public readonly Vector2 cellSize;
        public readonly Vector2 spacing;
        public readonly TextAnchor alignment;
        public readonly GridLayoutGroup.Constraint constraint;
        public readonly int constraintCount;

        [NonSerialized] public readonly bool hasPadding;
        [NonSerialized] public readonly bool hasAlignment;
        [NonSerialized] public readonly bool hasConstraint;
        [NonSerialized] public readonly bool hasCellSize;
        [NonSerialized] public readonly bool hasSpacing;

        public LayoutGroupParams(Padding inPadding = default,
            Vector2 inCellSize = default,
            Vector2 inSpacing = default,
            TextAnchor inAlignment = TextAnchor.MiddleCenter,
            GridLayoutGroup.Constraint inConstraint = GridLayoutGroup.Constraint.Flexible,
            int inConstraintCount = 1)
        {
            padding = inPadding;
            cellSize = inCellSize;
            spacing = inSpacing;
            alignment = inAlignment;
            constraint = inConstraint;
            constraintCount = inConstraintCount;

            hasPadding = padding != default;
            hasAlignment = alignment != TextAnchor.MiddleCenter;
            hasConstraint = constraint != GridLayoutGroup.Constraint.Flexible || constraintCount > 1;
            hasCellSize = cellSize != Vector2.zero;
            hasSpacing = spacing != Vector2.zero;
        }
        
        public static bool operator ==(LayoutGroupParams left, LayoutGroupParams right)
        {
            return left.padding == right.padding &&
                   left.cellSize == right.cellSize &&
                   left.spacing == right.spacing &&
                   left.alignment == right.alignment &&
                   left.constraint == right.constraint &&
                   left.constraintCount == right.constraintCount;
        }

        public static bool operator !=(LayoutGroupParams left, LayoutGroupParams right)
        {
            return !(left == right);
        }
    }
    
    public static GridLayoutGroup ApplyLayoutGroup(this GridLayoutGroup gridLayoutGroup, LayoutGroupParams layoutGroupParams = default)
    {
        if (layoutGroupParams == default)
            return gridLayoutGroup;

        ApplyLayoutGroup((LayoutGroup)gridLayoutGroup, layoutGroupParams);

        if (layoutGroupParams.hasConstraint)
        {
            gridLayoutGroup.constraint = layoutGroupParams.constraint;
            gridLayoutGroup.constraintCount = layoutGroupParams.constraintCount;
        }

        if (layoutGroupParams.hasCellSize)
            gridLayoutGroup.cellSize = layoutGroupParams.cellSize;

        if (layoutGroupParams.hasSpacing)
            gridLayoutGroup.spacing = layoutGroupParams.spacing;

        return gridLayoutGroup;
    }

    public static LayoutGroup ApplyLayoutGroup(this LayoutGroup layoutGroup, LayoutGroupParams layoutGroupParams = default)
    {
        if (layoutGroupParams == default)
            return layoutGroup;

        if (layoutGroupParams.hasPadding)
        {
            layoutGroup.padding.left = layoutGroupParams.padding.left;
            layoutGroup.padding.right = layoutGroupParams.padding.right;
            layoutGroup.padding.top = layoutGroupParams.padding.top;
            layoutGroup.padding.bottom = layoutGroupParams.padding.bottom;
        }

        if (layoutGroupParams.hasAlignment)
        {
            layoutGroup.childAlignment = layoutGroupParams.alignment;
        }

        return layoutGroup;
    }
    
    #region Copy Write from unity il code

    public static void SetParentAndAlign(GameObject child, GameObject parent)
    {
        if (parent == null)
            return;

        child.transform.SetParent(parent.transform, false);
        SetLayerRecursively(child, parent.layer);
    }

    public static void SetLayerRecursively(GameObject go, int layer)
    {
        go.layer = layer;
        Transform t = go.transform;
        for (int i = 0; i < t.childCount; i++)
            SetLayerRecursively(t.GetChild(i).gameObject, layer);
    }

#if UNITY_EDITOR
    
    public class DefaultEditorFactory : DefaultControls.IFactoryControls
    {
        public static DefaultEditorFactory Default = new DefaultEditorFactory();

        public GameObject CreateGameObject(string name, params Type[] components)
        {
            return ObjectFactory.CreateGameObject(name, components);
        }
    }

    public class FactorySwapToEditor : IDisposable
    {
        DefaultControls.IFactoryControls factory;

        public FactorySwapToEditor()
        {
            factory = DefaultControls.factory;
            DefaultControls.factory = DefaultEditorFactory.Default;
        }

        public void Dispose()
        {
            DefaultControls.factory = factory;
        }
    }
    
    public static void PlaceUIElementRoot(GameObject element, MenuCommand menuCommand)
    {
        GameObject parent = menuCommand.context as GameObject;
        bool explicitParentChoice = true;
        if (parent == null)
        {
            parent = GetOrCreateCanvasGameObject();
            explicitParentChoice = false;

            // If in Prefab Mode, Canvas has to be part of Prefab contents,
            // otherwise use Prefab root instead.
            PrefabStage prefabStage = PrefabStageUtility.GetCurrentPrefabStage();
            if (prefabStage != null && !prefabStage.IsPartOfPrefabContents(parent))
                parent = prefabStage.prefabContentsRoot;
        }

        if (parent.GetComponentsInParent<Canvas>(true).Length == 0)
        {
            // Create canvas under context GameObject,
            // and make that be the parent which UI element is added under.
            GameObject canvas = CreateNewUI();
            Undo.SetTransformParent(canvas.transform, parent.transform, "");
            parent = canvas;
        }

        GameObjectUtility.EnsureUniqueNameForSibling(element);

        SetParentAndAlign(element, parent);
        if (!explicitParentChoice) // not a context click, so center in sceneview
            SetPositionVisibleinSceneView(parent.GetComponent<RectTransform>(), element.GetComponent<RectTransform>());

        // This call ensure any change made to created Objects after they where registered will be part of the Undo.
        Undo.RegisterFullObjectHierarchyUndo(parent == null ? element : parent, "");

        // We have to fix up the undo name since the name of the object was only known after reparenting it.
        Undo.SetCurrentGroupName("Create " + element.name);

        Selection.activeGameObject = element;
    }

    public static GameObject GetOrCreateCanvasGameObject()
    {
        GameObject selectedGo = Selection.activeGameObject;

        // Try to find a gameobject that is the selected GO or one if its parents.
        Canvas canvas = (selectedGo != null) ? selectedGo.GetComponentInParent<Canvas>() : null;
        if (IsValidCanvas(canvas))
            return canvas.gameObject;

        // No canvas in selection or its parents? Then use any valid canvas.
        // We have to find all loaded Canvases, not just the ones in main scenes.
        Canvas[] canvasArray = StageUtility.GetCurrentStageHandle().FindComponentsOfType<Canvas>();
        for (int i = 0; i < canvasArray.Length; i++)
            if (IsValidCanvas(canvasArray[i]))
                return canvasArray[i].gameObject;

        // No canvas in the scene at all? Then create a new one.
        return CreateNewUI();
    }

    public static bool IsValidCanvas(Canvas canvas)
    {
        if (canvas == null || !canvas.gameObject.activeInHierarchy)
            return false;

        // It's important that the non-editable canvas from a prefab scene won't be rejected,
        // but canvases not visible in the Hierarchy at all do. Don't check for HideAndDontSave.
        if (EditorUtility.IsPersistent(canvas) || (canvas.hideFlags & HideFlags.HideInHierarchy) != 0)
            return false;

        if (StageUtility.GetStageHandle(canvas.gameObject) != StageUtility.GetCurrentStageHandle())
            return false;

        return true;
    }

    public static GameObject CreateNewUI()
    {
        // Root for the UI
        var root = new GameObject("Canvas");
        root.layer = LayerMask.NameToLayer("UI");
        Canvas canvas = root.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        root.AddComponent<CanvasScaler>();
        root.AddComponent<GraphicRaycaster>();

        // Works for all stages.
        StageUtility.PlaceGameObjectInCurrentStage(root);
        bool customScene = false;
        PrefabStage prefabStage = PrefabStageUtility.GetCurrentPrefabStage();
        if (prefabStage != null)
        {
            root.transform.SetParent(prefabStage.prefabContentsRoot.transform, false);
            customScene = true;
        }

        Undo.RegisterCreatedObjectUndo(root, "Create " + root.name);

        // If there is no event system add one...
        // No need to place event system in custom scene as these are temporary anyway.
        // It can be argued for or against placing it in the user scenes,
        // but let's not modify scene user is not currently looking at.
        if (!customScene)
            CreateEventSystem(false);
        return root;
    }

    public static void CreateEventSystem(bool select)
    {
        CreateEventSystem(select, null);
    }


    public static void CreateEventSystem(bool select, GameObject parent)
    {
        var esys = Object.FindObjectOfType<EventSystem>();
        if (esys == null)
        {
            var eventSystem = new GameObject("EventSystem");
            GameObjectUtility.SetParentAndAlign(eventSystem, parent);
            esys = eventSystem.AddComponent<EventSystem>();
            eventSystem.AddComponent<StandaloneInputModule>();

            Undo.RegisterCreatedObjectUndo(eventSystem, "Create " + eventSystem.name);
        }

        if (select && esys != null)
        {
            Selection.activeGameObject = esys.gameObject;
        }
    }

    public static void SetPositionVisibleinSceneView(RectTransform canvasRTransform, RectTransform itemTransform)
    {
        // Find the best scene view
        SceneView sceneView = SceneView.lastActiveSceneView;

        if (sceneView == null && SceneView.sceneViews.Count > 0)
            sceneView = SceneView.sceneViews[0] as SceneView;

        // Couldn't find a SceneView. Don't set position.
        if (sceneView == null || sceneView.camera == null)
            return;

        // Create world space Plane from canvas position.
        Camera camera = sceneView.camera;
        Vector3 position = Vector3.zero;
        Vector2 localPlanePosition;

        if (RectTransformUtility.ScreenPointToLocalPointInRectangle(canvasRTransform, new Vector2(camera.pixelWidth / 2, camera.pixelHeight / 2), camera, out localPlanePosition))
        {
            // Adjust for canvas pivot
            localPlanePosition.x = localPlanePosition.x + canvasRTransform.sizeDelta.x * canvasRTransform.pivot.x;
            localPlanePosition.y = localPlanePosition.y + canvasRTransform.sizeDelta.y * canvasRTransform.pivot.y;

            localPlanePosition.x = Mathf.Clamp(localPlanePosition.x, 0, canvasRTransform.sizeDelta.x);
            localPlanePosition.y = Mathf.Clamp(localPlanePosition.y, 0, canvasRTransform.sizeDelta.y);

            // Adjust for anchoring
            position.x = localPlanePosition.x - canvasRTransform.sizeDelta.x * itemTransform.anchorMin.x;
            position.y = localPlanePosition.y - canvasRTransform.sizeDelta.y * itemTransform.anchorMin.y;

            Vector3 minLocalPosition;
            minLocalPosition.x = canvasRTransform.sizeDelta.x * (0 - canvasRTransform.pivot.x) + itemTransform.sizeDelta.x * itemTransform.pivot.x;
            minLocalPosition.y = canvasRTransform.sizeDelta.y * (0 - canvasRTransform.pivot.y) + itemTransform.sizeDelta.y * itemTransform.pivot.y;

            Vector3 maxLocalPosition;
            maxLocalPosition.x = canvasRTransform.sizeDelta.x * (1 - canvasRTransform.pivot.x) - itemTransform.sizeDelta.x * itemTransform.pivot.x;
            maxLocalPosition.y = canvasRTransform.sizeDelta.y * (1 - canvasRTransform.pivot.y) - itemTransform.sizeDelta.y * itemTransform.pivot.y;

            position.x = Mathf.Clamp(position.x, minLocalPosition.x, maxLocalPosition.x);
            position.y = Mathf.Clamp(position.y, minLocalPosition.y, maxLocalPosition.y);
        }

        itemTransform.anchoredPosition = position;
        itemTransform.localRotation = Quaternion.identity;
        itemTransform.localScale = Vector3.one;
    }

    public static void SetDefaultColorTransitionValues(Selectable selectable)
    {
        var colors = selectable.colors;
        colors.highlightedColor = new Color(0.882f, 0.882f, 0.882f);
        colors.pressedColor = new Color(0.698f, 0.698f, 0.698f);
        colors.disabledColor = new Color(0.521f, 0.521f, 0.521f);
    }

#endif

    #endregion
    
}
