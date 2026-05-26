using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using TMPro;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;
using Object = UnityEngine.Object;

public abstract class UIElementAttribute : Attribute
{
    
}

[AttributeUsage(AttributeTargets.Field)]
public class NonCopyableAttribute : UIElementAttribute
{
}


public interface IUIElement
{
    public void FillReference();
}

[Serializable, HideReferenceObjectPicker]
public abstract class UIElement : IUIElement
{
    [OnValueChanged("FillReference")]
    public GameObject elementRoot;

    [Button]
    public void FillReference()
    {
        if (elementRoot == null)
            return;
        
        var type = GetType();
        using var stopObjectNames = PooledHashSet<string>.Get();
        stopObjectNames.AddRange(this.GetElementSearchStopNames());
        
        foreach (var field in type.GetFields(BindingFlags.Instance | BindingFlags.Public))
        {
            if (typeof(IUIElementContainer).IsAssignableFrom(field.FieldType))
            {
                if (field.GetValue(this) is IUIElementContainer container)
                {
                    container.Refresh();
                }
                continue;
            }
            
            if (typeof(IUIElement).IsAssignableFrom(field.FieldType))
            {
                if (field.GetValue(this) is UIElement uiElement)
                {
                    uiElement.elementRoot = elementRoot.SearchIgnoreCase(typeof(GameObject), field.GetTypeStrippedName().name) as GameObject;
                    uiElement.FillReference();
                }
                continue;
            }
            
            if (!field.IsUIElementTarget())
                continue;

            field.SetValue(this, this.GetReference(field, stopObjectNames));
        }
    }
    
}

public interface IUIElementContainer
{
    public void Refresh();
    public IEnumerable<UIElement> GetElements();
}

[Serializable]
public class UIElementContainer<T> : IUIElementContainer where T : UIElement, new()
{
    public bool appendIndexToElementName;
    
    [OnValueChanged("Refresh"), SerializeField]
    private List<T> elements = new()
    {
        new T()
    };
    
    public T this[int index] => elements.GetSafe(index);
    public int Length => elements.Count;
    public Transform elementParent => elements.FirstOrDefault()?.elementRoot.transform.parent;

    public IEnumerable<UIElement> GetElements()
    {
        elements.RemoveAll(x => x.elementRoot == null);
        
        foreach (var element in elements)
        {
            yield return element;
        }
    }

    public IEnumerable<(T element, int index)> GetElements(int count, bool refreshLayoutBeforeIterate = false)
    {
        elements.RemoveAll(x => x.elementRoot == null);

        if (elements.Count < 1)
        {
            throw new IndexOutOfRangeException(count.ToString());
        }
        
        elementParent?.SetActive(count > 0);
        
        var countIncreased = count > elements.Count;
        while (elements.Count < count)
        {
            elements.Add(new T());
        }

        if (countIncreased)
        {
            Refresh();
        }

        if (countIncreased || refreshLayoutBeforeIterate)
            LayoutRebuilder.ForceRebuildLayoutImmediate(elements.First().elementRoot.transform.parent as RectTransform);

        var i = 0;
        for (; i < count; i++)
        {
            var element = elements[i];
            if (element.elementRoot == null)
                continue;

            element.elementRoot.SetActive(true);
            yield return (element, i);
        }

        for (; i < elements.Count; i++)
        {
            var element = elements[i];
            if (element.elementRoot == null)
                continue;
            
            element.elementRoot.SetActive(false);
        }

    }

    public void RefreshElements(int index, Action<T, int> action)
    {
        elements.RemoveAll(x => x.elementRoot == null);
        
        for (var i = 0; i < elements.Count; i++)
        {
            if (index == i)
                action?.Invoke(elements[i], i);
        }
    }

    public IEnumerable<(T element, int index, Data data)> GetElements<Data>(IEnumerable<Data> datas, bool refreshLayoutBeforeIterate = false)
    {
        using var list = PooledList<Data>.Get();
        list.AddRange(datas);

        foreach (var (element, index) in GetElements(list.Count, refreshLayoutBeforeIterate))
        {
            yield return (element, index, list[index]);
        };
    }
    
    public IEnumerable<(T element, int index, Data data)> GetElements<Data>(ArraySegment<Data> datas, bool refreshLayoutBeforeIterate = false)
    {
        foreach (var (element, index) in GetElements(datas.Count, refreshLayoutBeforeIterate))
        {
            yield return (element, index, datas[index]);
        };
    }
    
    public IEnumerable<(T element, int index, Data data)> GetElements<Data>(IList<Data> datas, bool refreshLayoutBeforeIterate = false)
    {
        foreach (var (element, index) in GetElements(datas.Count, refreshLayoutBeforeIterate))
        {
            yield return (element, index, datas[index]);
        }
    }

    private string GetElementName(string originalName, int index)
    {
        var name = originalName;
        name = name.Replace("(Clone)", "");

        if (int.TryParse(name.Split('_').LastOrDefault(), out _))
            name = name[..name.LastIndexOf('_')];
        if (appendIndexToElementName)
            name += $"_{index:00}";

        return name;
    }

    [Button]
    public void Refresh()
    {
        var first = elements.GetSafe(0);
        if (first == null || first.elementRoot == null)
            return;
        
        var parent = first.elementRoot.transform.parent;
        
        first.elementRoot.name = GetElementName(first.elementRoot.name, 0);

#if UNITY_EDITOR
        if (!Application.isPlaying)
            first.FillReference();
#endif
        
        foreach (var field in first.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public))
        {
            if (typeof(IUIElementContainer).IsAssignableFrom(field.FieldType))
            {
                if (field.GetValue(first) is IUIElementContainer container)
                {
                    var copyWriter = first.elementRoot.AddComponent<UIElementCopywriter>();
                    copyWriter.container = container;
                    copyWriter.copyKey = field.Name;
                }
            }
        }
        
        var layoutGroup = parent.GetComponent<LayoutGroup>();
        var layoutHolder = parent.GetComponent<IUILayoutOptionHolder>();
        if (layoutGroup && layoutHolder is not { holdLayoutEnabled: true })
        {
            layoutGroup.enabled = true;
        }

        for (var i = 1; i < elements.Count; i++)
        {
            var element = elements[i];
            if (element.elementRoot != null) //에디터 모드에선 무조건 재생성. 그 외엔 유효하다 판단하여 스킵.
            {
#if UNITY_EDITOR
                if (!Application.isPlaying)
                {
                    Object.DestroyImmediate(element.elementRoot, true);
                }
                else
#endif
                {
                    continue;
                }
            }

#if UNITY_EDITOR
            var obj = Utility.DuplicateGameObject(first.elementRoot);
#else
            var obj = Object.Instantiate(first.elementRoot, parent, false);
#endif
            obj.name = GetElementName(obj.name, i);
            
            obj.transform.SetAsLastSibling();
            obj.SetActive(true);
            
            //copywriter를 통해 복사된 컨테이너를 찾아서 적용 (reference deep copy 용)
            foreach (var field in element.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public))
            {
                if (typeof(IUIElementContainer).IsAssignableFrom(field.FieldType))
                {
                    foreach (var copywriter in obj.GetComponentsInChildren<UIElementCopywriter>())
                    {
                        if (copywriter && copywriter.copyKey == field.Name)
                        {
                            field.SetValue(element, copywriter.container);
                            Object.DestroyImmediate(copywriter);
                        }
                    }
                }
            }
            
            element.elementRoot = obj;
            element.FillReference();
        }
        
        foreach (var copywriter in first.elementRoot.GetComponentsInChildren<UIElementCopywriter>(true))
        {
            Object.DestroyImmediate(copywriter);       
        }

        using var _ = ListPool<GameObject>.Get(out var willDestroys);
        
        var childCount = parent.childCount;
        for (var i = 0; i < childCount; i++)
        {
            var go = parent.GetChild(i).gameObject;
            if (elements.Any(x => x.elementRoot == go))
                continue;

            using var components = PooledList<ILayoutIgnorer>.Get();
            go.GetComponents(components);
            if (components.Any(x => x.ignoreLayout))
                continue;
            
            willDestroys.Add(go);
        }

        foreach (var willDestroy in willDestroys)
            Object.DestroyImmediate(willDestroy, true);

        if (layoutGroup && layoutHolder is not { holdLayoutEnabled: true })
        {
            LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)layoutGroup.transform);
            layoutGroup.enabled = false;
        }
    }

    public List<T> Elements => elements;

}

public interface IUITableElement
{
    public IEnumerable<UIElement> GetElements();
    public Vector2 GetElementCellSize();
    public UIElement AddElement();
    
    public void FitElements();
}

[Serializable]
public abstract class UITableElement<TableElements> : IUITableElement where TableElements : UIElement, new()
{
    [OnValueChanged("LinkReference")]
    public UITableViewEx table;
    
    public TableElements elementFormat = new();

    [ReadOnly]
    public UIElementContainer<TableElements> container = new();

    public IEnumerable<UIElement> GetElements()
    {
        return container.GetElements();
    }

    public Vector2 GetElementCellSize()
    {
        if (elementFormat.elementRoot == null)
            return Vector2.zero;

        var rt = (RectTransform)elementFormat.elementRoot.transform;
        return rt.rect.size * rt.localScale;
    }

    public UIElement AddElement()
    {
        container.Elements.Add(new());
        container.Refresh();
        
        LinkReference();
        
        return container.Elements[^1];
    }

    private void LinkReference()
    {
        table?.LinkElementReference(this);
    }
    
    [Button]
    public void FitElements()
    {
        if (table == null)
            return;

        if (container.Elements.Count > 1)
        {
            var willDestroys = container.Elements.GetRange(1, container.Elements.Count - 1).Select(x => x.elementRoot);
            foreach (var willDestroy in willDestroys)
                Object.DestroyImmediate(willDestroy, true);
            container.Elements.RemoveRange(1, container.Elements.Count - 1);
        }

        if (elementFormat.elementRoot == null)
            return;

        container.Elements[0] = elementFormat;
        var cellSize = GetElementCellSize();
        var cellSpace = table.direction switch
        {
            UITableViewEx.Direction.TOP_TO_BOTTOM => cellSize.y,
            UITableViewEx.Direction.BOTTOM_TO_TOP => cellSize.y,
            UITableViewEx.Direction.LEFT_TO_RIGHT => cellSize.x,
            UITableViewEx.Direction.RIGHT_TO_LEFT => cellSize.x,
            _ => throw new ArgumentOutOfRangeException()
        };
        
        var viewportSize = table.direction switch
        {
            UITableViewEx.Direction.TOP_TO_BOTTOM => table.viewport.rect.height,
            UITableViewEx.Direction.BOTTOM_TO_TOP => table.viewport.rect.height,
            UITableViewEx.Direction.LEFT_TO_RIGHT => table.viewport.rect.width,
            UITableViewEx.Direction.RIGHT_TO_LEFT => table.viewport.rect.width,
            _ => throw new ArgumentOutOfRangeException()
        };

        float i = table.direction switch
        {
            UITableViewEx.Direction.TOP_TO_BOTTOM => table.padding.top,
            UITableViewEx.Direction.BOTTOM_TO_TOP => table.padding.bottom,
            UITableViewEx.Direction.LEFT_TO_RIGHT => table.padding.left,
            UITableViewEx.Direction.RIGHT_TO_LEFT => table.padding.right,
            _ => throw new ArgumentOutOfRangeException()
        };
        
        var positions = new List<float>();
        for (; i < viewportSize; i += cellSpace + table.spacing)
        {
            container.Elements.Add(new TableElements());
            positions.Add(i);
        }
        positions.Add(i);
        container.Refresh();
        
        for (var j = 0; j < container.Elements.Count; j++)
        {
            var rt = (RectTransform)container[j].elementRoot.transform;
            rt.anchoredPosition = table.direction switch
            {
                UITableViewEx.Direction.TOP_TO_BOTTOM => new Vector2(0, -positions[j]),
                UITableViewEx.Direction.BOTTOM_TO_TOP => new Vector2(0, positions[j]),
                UITableViewEx.Direction.LEFT_TO_RIGHT => new Vector2(positions[j], 0),
                UITableViewEx.Direction.RIGHT_TO_LEFT => new Vector2(-positions[j], 0),
                _ => throw new ArgumentOutOfRangeException()
            };
        }
        
        if (table.content != null)
        {
            table.content.sizeDelta = table.direction switch
            {
                UITableViewEx.Direction.TOP_TO_BOTTOM => new Vector2(-table.padding.horizontal, positions[^1] + cellSize.y + table.padding.bottom),
                UITableViewEx.Direction.BOTTOM_TO_TOP => new Vector2(-table.padding.horizontal, positions[^1] + cellSize.y + table.padding.top),
                UITableViewEx.Direction.LEFT_TO_RIGHT => new Vector2(positions[^1] + cellSize.x + table.padding.right, -table.padding.vertical),
                UITableViewEx.Direction.RIGHT_TO_LEFT => new Vector2(positions[^1] + cellSize.x + table.padding.left, -table.padding.vertical),
                _ => throw new ArgumentOutOfRangeException()
            };
        }
        
        LinkReference();
    }
    
}

public static class UIElementExtensions
{
    public static bool IsUIElementTarget(this FieldInfo info)
    {
        if (info.IsPrivate && !info.IsDefined(typeof(SerializeField)))
            return false;

        if (!info.FieldType.IsClass)
            return false;

        if (string.Equals(info.Name, "elementRoot", StringComparison.InvariantCultureIgnoreCase))
            return false;
        
        if (!typeof(Object).IsAssignableFrom(info.FieldType))
            return false;

        if (info.GetCustomAttribute<NonCopyableAttribute>() != null)
            return false;
        
        return true;
    }
    
    public static (string name, bool result) GetTypeStrippedName(this FieldInfo info, string targetName = null)
    {
        var comparison = StringComparison.InvariantCultureIgnoreCase;
        var type = info.FieldType;
        
        //Field Name을 Hierachy에서 찾기 위해 type prefix 제거
        var name = targetName ?? info.Name;
        if (typeof(PurchaseProductCell).IsAssignableFrom(type))
        {
            if (name.StartsWith("cell", comparison))
                name = name[4..];
        }
        if (typeof(Image).IsAssignableFrom(type) || type == typeof(SmartItemIcon))
        {
            if (name.StartsWith("image", comparison))
                name = name[5..];
            else if (name.StartsWith("img", comparison))
                name = name[3..];
        }
        else if (type == typeof(GameObject))
        {
            if (name.StartsWith("gameobject", comparison))
                name = name[9..];
            else if (name.StartsWith("element", comparison))
                name = name[7..];
            else if (name.StartsWith("cell", comparison))
                name = name[4..];
            else if (name.StartsWith("obj", comparison))
                name = name[3..];
            else if (name.StartsWith("go", comparison))
                name = name[2..];
        }
        else if (type == typeof(TextMeshProUGUI))
        {
            if (name.StartsWith("text", comparison))
                name = name[4..];
            else if (name.StartsWith("txt", comparison))
                name = name[3..];
        }
        else if (type == typeof(Transform) || type == typeof(RectTransform))
        {
            if (name.StartsWith("tr", comparison))
                name = name[2..];
            else if (name.StartsWith("rt", comparison))
                name = name[2..];
        }
        else if (type == typeof(LayoutElement))
        {
            if (name.StartsWith("layoutElement", comparison))
                name = name[13..];
            else if (name.StartsWith("layout", comparison))
                name = name[6..];
        }
        else if (type == typeof(Slider))
        {
            if (name.StartsWith("slider", comparison))
                name = name[6..];
        }
        else if (type == typeof(TextTimer))
        {
            if (name.StartsWith("txt", comparison))
                name = name[3..];
            else if (name.StartsWith("text", comparison))
                name = name[9..];
            if (name.StartsWith("timer", comparison))
                name = name[5..];
            else if (name.StartsWith("txtTimer", comparison))
                name = name[8..];
        }
        else if (type == typeof(ParticleSystem))
        {
            if (name.StartsWith("ps", comparison))
                name = name[2..];
            else if (name.StartsWith("particle", comparison))
                name = name[8..];
        }
        else if (type == typeof(PlayableDirector))
        {
            if (name.StartsWith("pd", comparison))
                name = name[2..];
            else if (name.StartsWith("playable", comparison))
                name = name[8..];
        }
        else if (type == typeof(Animator))
        {
            if (name.StartsWith("animator", comparison))
                name = name[8..];
            else if (name.StartsWith("anim", comparison))
                name = name[4..];
        }
        else if (type == typeof(Toggle) || type == typeof(CustomToggle))
        {
            if (name.StartsWith("toggle", comparison))
                name = name[6..];
            else if (name.StartsWith("tg", comparison))
                name = name[2..];
        }
        else if (type == typeof(ZButton) || type == typeof(CustomButton) || typeof(CustomButton).IsAssignableFrom(type))
        {
            if (name.StartsWith("btn", comparison))
                name = name[3..];
            else if (name.StartsWith("bt", comparison))
                name = name[2..];
        }
        else if (type == typeof(CanvasGroup))
        {
            if (name.StartsWith("cg", comparison))
                name = name[2..];
            else if (name.StartsWith("canvasGroup", comparison))
                name = name[11..];
            else if (name.StartsWith("canvas", comparison))
                name = name[6..];
        }
        else
        {
            return (name, false);
        }
        
        //뒤 인덱서도 제거
        if (int.TryParse(name.Split('_').LastOrDefault(), out _))
            name = name[..name.LastIndexOf('_')];
        return (name, true);
    }

    public static Object GetReference(this UIElement element, FieldInfo info, HashSet<string> stopObjectNames)
    {
        var found = element.GetReferenceInternal(info, stopObjectNames); 
        if (found == null)
        {
#if UNITY_EDITOR
            Debug.LogWarning($"{info.Name} not found in {element.elementRoot.name} type: {info.FieldType}");
#endif
            
            foreach (var serializedAsAttribute in info.GetCustomAttributes<FormerlySerializedAsAttribute>())
            {
                found = element.GetReferenceInternal(info, stopObjectNames, serializedAsAttribute.oldName);
                if (found != null)
                    return found;
            }
            
            return info.GetValue(element) as Object;
        }
        
        return found;
    }

    private static Object GetReferenceInternal(this UIElement element, FieldInfo info, HashSet<string> stopObjectNames, string targetName = null)
    {
        var type = info.FieldType;
        var (name, result) = info.GetTypeStrippedName(targetName);

        if (info.GetCustomAttribute<ForceCacheAttribute>() is not null)
            return element.elementRoot.GetComponentInChildren(type, true);
        
        return element.elementRoot.SearchIgnoreCase(type, name, stopObjectNames);
    }
    
    public static Object SearchIgnoreCase(this GameObject target, Type type, string name, HashSet<string> stopObjectNames = null)
    {
        var objectName = target.name;
        
        //Hierachy 상에서 구별용 prefix 제거
        if (objectName.StartsWith("Text_"))
            objectName = objectName[5..];
        else if(objectName.StartsWith("Btn_"))
            objectName = objectName[4..];
        
        if (stopObjectNames?.Contains(objectName) == true)
            return null;

        if (string.Equals(objectName, name, StringComparison.InvariantCultureIgnoreCase))
        {
            if (type == typeof(GameObject))
                return target;

            if (target.TryGetComponent(type, out var component))
                return component;
        }

        if (target.TryGetComponent<UIElementGroup>(out var group) && group.enabled)
            return null;

        for (var i = 0; i < target.transform.childCount; ++i)
        {
            var go = target.transform.GetChild(i).gameObject;
            var result = SearchIgnoreCase(go, type, name, stopObjectNames);

            if (result != null) 
                return result;
        }

        return null;
    }
    
    public static IEnumerable<string> GetElementSearchStopNames(this UIElement element)
    {
        foreach (var field in element.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public))
        {
            if (typeof(UIElement).IsAssignableFrom(field.FieldType))
            {
                yield return field.GetTypeStrippedName().name;
            }
            else if (typeof(IUIElementContainer).IsAssignableFrom(field.FieldType))
            {
                if (field.GetValue(element) is IUIElementContainer container)
                {
                    var e = container.GetElements().FirstOrDefault();
                    if (e != null)
                        yield return e.elementRoot.transform.parent.name;
                }
            }
        }
    }
    
}