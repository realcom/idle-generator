using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Utility.ObjectPool;
using DG.Tweening;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.UI;

#if UNITY_EDITOR
using UnityEditor;
#endif

public interface IUITableGenericInvoker
{
    public Type type { get; }
    public void InvokeElementDelegate(int idx, IUIElement element);
}

public class UITableGenericInvoker<T> : IUITableGenericInvoker where T : UIElement, new()
{
    public delegate void ElementDelegate(int idx, T element);

    public Type type => typeof(T);
    public ElementDelegate elementDelegate = null;

    public void InvokeElementDelegate(int idx, IUIElement element)
    {
        if (elementDelegate != null)
        {
            try
            {
                elementDelegate(idx, element as T);
            }
            catch (Exception ex)
            {
                Debug.LogError(ex);
            }
        }
    }
}

public interface IUITableDataEx
{
    public Type type { get; }
    public IList list { get; }

    public void InvokeElementDelegate(int idx, IUIElement element);
}

public class UITableGenericDataEx<T, TElement> : IUITableDataEx where TElement : UIElement, new()
{
    public delegate void ElementDelegate(List<T> datas, int idx, TElement element);

    public readonly List<T> datas = new();
    public ElementDelegate elementDelegate = null;

    public Type type => typeof(T);
    public IList list => datas;
    public void InvokeElementDelegate(int idx, IUIElement element)
    {
        if (elementDelegate != null)
        {
            try
            {
                elementDelegate(datas, idx, element as TElement);
            }
            catch (Exception ex)
            {
                Debug.LogError(ex);
            }
        }
    }
    
}

public interface IUITableEx
{
    public void LinkElementReference(IUITableElement element);
    
    public UITableViewEx.Direction direction { get; }
    public RectOffset padding { get; }
    public float spacing { get; }
    public RectTransform content { get; }
    public RectTransform viewport { get; }
}

[RequireComponent(typeof(RectTransform))]
[RequireComponent(typeof(RectMask2D))]
[RequireComponent(typeof(ScrollRectEx))]
public class UITableViewEx : SerializedMonoBehaviour, IUITableEx
{
    public enum Direction
    {
        TOP_TO_BOTTOM,
        BOTTOM_TO_TOP,
        LEFT_TO_RIGHT,
        RIGHT_TO_LEFT,
    }
    
    [Serializable]
    public struct HandleFocusInfo
    {
        public float ratioByViewportSize;
        public GameObject focusedGameObjectStartDirection;
        public GameObject focusedGameObjectEndDirection;

        public static HandleFocusInfo Default => new()
        {
            ratioByViewportSize = 0.25f,
            focusedGameObjectStartDirection = null,
            focusedGameObjectEndDirection = null
        };
    }

    [SerializeField] private Direction m_Direction = Direction.TOP_TO_BOTTOM;
    [SerializeField] private ScrollRectEx m_ScrollRect;
    [SerializeField] private RectOffset m_Padding = new();
    [SerializeField] private float m_Spacing = 0;
    [SerializeField] private HandleFocusInfo m_HandleFocusInfo = HandleFocusInfo.Default;
    [SerializeField] private RectTransform m_ElementParent;
    [SerializeField] private GameObject m_EmptyElement;
    [SerializeReference, ReadOnly] private IUITableElement m_Element;

    public ScrollRectEx scrollRect
    {
        get
        {
            if (m_ScrollRect == null)
                m_ScrollRect = GetComponent<ScrollRectEx>();
            return m_ScrollRect;
        }
    }

    public void LinkElementReference(IUITableElement element)
    {
        m_Element = element;
    }
    
    private DrivenRectTransformTracker m_Tracker;

    public RectOffset padding => m_Padding;
    public float spacing => m_Spacing;
    public Direction direction => m_Direction;
    public RectTransform content => scrollRect.content;
    public RectTransform viewport => scrollRect.viewport;
    public RectTransform elementParent => m_ElementParent == null ? content : m_ElementParent;
    
    public Vector2 ElementSize => m_Element.GetElementCellSize();
    
    private IUITableDataEx m_tableData = null;
    private IUITableGenericInvoker m_tableInvoker = null;
    private int m_dataCount = 0;

    public Vector2 FocusHandleAnchoredPosition { get; set; } = Vector2.negativeInfinity;

    public int FocusHandleIndex
    {
        set
        {
            if (m_dataCount == 0)
            {
                FocusHandleAnchoredPosition = Vector2.negativeInfinity;
                return;
            }
            
            FocusHandleRatio = value / (float)m_dataCount;
        }
    }

    public float FocusHandleRatio
    {
        get
        {
            if (FocusHandleAnchoredPosition == Vector2.negativeInfinity)
                return float.NegativeInfinity;

            switch (m_Direction)
            {
                case Direction.TOP_TO_BOTTOM:
                case Direction.BOTTOM_TO_TOP:
                    return Mathf.Clamp01(FocusHandleAnchoredPosition.y / GetRealizedContentSize().y);
                case Direction.LEFT_TO_RIGHT:
                case Direction.RIGHT_TO_LEFT:
                    return Mathf.Clamp01(FocusHandleAnchoredPosition.x / GetRealizedContentSize().x);
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }
        set
        {
            var v = Mathf.Clamp01(value);

            FocusHandleAnchoredPosition = m_Direction switch
            {
                Direction.TOP_TO_BOTTOM => new Vector2(0, GetRealizedContentSize().y * v + padding.top),
                Direction.BOTTOM_TO_TOP => new Vector2(0, -GetRealizedContentSize().y * v - padding.bottom),
                Direction.LEFT_TO_RIGHT => new Vector2(-GetRealizedContentSize().x * v - padding.left, 0),
                Direction.RIGHT_TO_LEFT => new Vector2(GetRealizedContentSize().x * v + padding.right, 0),
                _ => throw new ArgumentOutOfRangeException()
            };
        }
    }

    //테이블 크기를 항상 최대로 생각하고, 셀의 동적 생성을 막는다.
    private readonly List<UIElement> m_Elements = new();

    public void Initialize<T>(int count, UITableGenericInvoker<T>.ElementDelegate @delegate = null) where T : UIElement, new()
    {
        m_tableInvoker = m_tableInvoker == null || m_tableInvoker.type != typeof(T) ? new UITableGenericInvoker<T>() : m_tableInvoker;
        m_dataCount = count;
        
        var invoker = m_tableInvoker as UITableGenericInvoker<T>;
        invoker!.elementDelegate = @delegate;

        Initialize();
    }
	
    public void Initialize<ItemType, TElement>(
        IEnumerable<ItemType> enumerable,
        UITableGenericDataEx<ItemType, TElement>.ElementDelegate @delegate = null,
        int count = int.MinValue) where TElement : UIElement, new()
    {
        m_tableData = m_tableData == null || m_tableData.type != typeof(ItemType) ? new UITableGenericDataEx<ItemType, TElement>() : m_tableData;

        var list = m_tableData.list as IList<ItemType>;
        list!.Clear();
        list!.AddRange(enumerable);

        var elements = m_tableData as UITableGenericDataEx<ItemType, TElement>;
        elements!.elementDelegate = @delegate;

        Initialize<TElement>(count == int.MinValue ? list.Count : count);
    }

    [NotNull]
    public List<T> GetElements<T>()
    {
        return m_tableData?.list as List<T> ?? new List<T>();
    }
    
    public int DataCount => m_dataCount;
    
    public void OnRectTransformDimensionsChange()
    {
        if (!isActiveAndEnabled)
            return;
        if (CanvasUpdateRegistry.IsRebuildingLayout())
            this.RunAfterFrame(ReloadData);
        else
            ReloadData();
    }

    private void Initialize()
    {
        DeepCopyElements();
        
        var (newStartElementIdx, newEndElementIdx) = GetRefreshIndexRange();
        if (newStartElementIdx == m_prevStartElementIdx && newEndElementIdx == m_prevEndElementIdx)
        {
            //인덱스가 변경되지 않았으면 요소만 업데이트
            RefreshElements();
            return;
        }
        
        m_prevStartElementIdx = 0;
        m_prevEndElementIdx = -1;
        
        while (m_Elements.Count > 0)
        {
            m_RecycleQueue.Enqueue(m_Elements[0]);
            m_Elements.RemoveAt(0);
        }

        var parent = elementParent;
        foreach (var element in m_RecycleQueue)
        {
            element.elementRoot.transform.SetParent(parent, false);
            element.elementRoot.transform.SetActive(false);
        }
        
        if (m_EmptyElement)
            m_EmptyElement.SetActive(m_dataCount == 0);
        
        Refresh();
    }

    public void ReloadData()
    {
        Initialize();
    }

    private Vector2 GetRealizedContentSize()
    {
        var v = content.rect.size;
        switch (m_Direction)
        {
            case Direction.TOP_TO_BOTTOM:
            case Direction.BOTTOM_TO_TOP:
                v.y -= padding.vertical;
                break;
            case Direction.LEFT_TO_RIGHT:
            case Direction.RIGHT_TO_LEFT:
                v.x -= padding.horizontal;
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }

        return v;
    }

    private Vector2 FitPaddingAndPivot(Vector2 v, float viewportPivot)
    {
        var l_Padding = m_Padding;
        var delta = viewport.rect.size * (1f - viewportPivot);
        var contentSize = content.rect.size;
        switch (m_Direction)
        {
            case Direction.TOP_TO_BOTTOM:
                v.x = 0;
                v.y -= l_Padding.top;
                v.y = Mathf.Clamp(v.y - delta.y, 0, contentSize.y);
                break;
            case Direction.BOTTOM_TO_TOP:
                v.x = 0;
                v.y = -v.y + l_Padding.bottom;
                v.y = Mathf.Clamp(v.y + delta.y, -contentSize.y, 0);
                break;
            case Direction.LEFT_TO_RIGHT:
                v.x = -v.x + l_Padding.left;
                v.x = Mathf.Clamp(v.x + delta.x, -contentSize.x, 0);
                v.y = 0;
                break;
            case Direction.RIGHT_TO_LEFT:
                v.x -= l_Padding.right;
                v.x = Mathf.Clamp(v.x - delta.x, 0, contentSize.x);
                v.y = 0;
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }

        return v;
    }
    
    private Vector2 GetTargetAnchoredPosition(int index , float viewPortPivot = 0.5f)
    {
        DeepCopyElements();
        
        var elementSize = m_Element.GetElementCellSize();
        var l_ElementOffset = new Vector2(elementSize.x + m_Spacing, elementSize.y + m_Spacing);
        var v = index * l_ElementOffset;

        return FitPaddingAndPivot(v, viewPortPivot);
    }
    
    private Vector2 GetTargetAnchoredPosition(float ratio, float viewPortPivot = 0.5f)
    {
        DeepCopyElements();

        var v = GetRealizedContentSize();
        v *= ratio;
        
        return FitPaddingAndPivot(v, viewPortPivot);
    }

    private Tween _scrollTween = null;
    private Tween DoScroll(Vector2 anchoredPosition, float duration)
    {
        if (!this || !isActiveAndEnabled)
            return null;

        if (content.anchoredPosition == anchoredPosition)
            return null;
        
        _scrollTween?.Kill();
        scrollRect.enabled = false;
        _scrollTween = DOTween.To(() => content.anchoredPosition, (pos) =>
        {
            content.anchoredPosition = pos;
            scrollRect.onValueChanged?.Invoke(scrollRect.normalizedPosition);
        }, anchoredPosition, duration);
        
        _scrollTween.onComplete += () =>
        {
            _scrollTween = null;
            scrollRect.enabled = true;
            scrollRect.onValueChanged?.Invoke(scrollRect.normalizedPosition);
        };

        return _scrollTween;
    }
    
    public void ScrollToIndex(int index, float viewPortPivot = 0.5f)
    {
        if (!this || !isActiveAndEnabled)
            return;
        
        var v = GetTargetAnchoredPosition(index, viewPortPivot);
        content.anchoredPosition = v;
        
        Refresh();
    }
    
    public Tween DoScrollToIndex(int index, float duration, float viewPortPivot = 0.5f)
    {
        if (!this || !isActiveAndEnabled)
            return null;
        
        var pos = GetTargetAnchoredPosition(index, viewPortPivot);
        return DoScroll(pos, duration);
    }
    
    public void ScrollToRatio(float ratio, float viewPortPivot = 0.5f)
    {
        if (!this || !isActiveAndEnabled)
            return;
        
        var pos = GetTargetAnchoredPosition(ratio, viewPortPivot);
        content.anchoredPosition = pos;

        Refresh();
    }
    
    public Tween DoScrollToRatio(float ratio, float duration, float viewPortPivot = 0.5f)
    {
        if (!this || !isActiveAndEnabled)
            return null;
        
        var pos = GetTargetAnchoredPosition(ratio, viewPortPivot);
        return DoScroll(pos, duration);
    }

    public void ScrollToStart()
    {
        content.anchoredPosition = Vector2.zero;   
    }
    
    public void ScrollToEnd()
    {
        content.anchoredPosition = -GetRealizedContentSize();
    }

    private (int startIdx, int endIdx) GetRefreshIndexRange()
    {
        var pos = content.anchoredPosition;
        var startIdx = 0;
        var endIdx = m_dataCount;
        
        var viewportSize = viewport.rect.size;
        var elementSize = ElementSize;
        var elementOffset = new Vector2(elementSize.x + m_Spacing, elementSize.y + m_Spacing);
        
        switch (m_Direction)
        {
            case Direction.TOP_TO_BOTTOM:
                pos.y -= m_Padding.top;
                startIdx = Mathf.Max(0, (int)(pos.y / elementOffset.y));
                endIdx = Mathf.Min((int)((pos.y + viewportSize.y) / elementOffset.y) + 1, m_dataCount);
                break;
            case Direction.BOTTOM_TO_TOP:
                pos.y += m_Padding.bottom;
                startIdx = Mathf.Max(0, (int)(-pos.y / elementOffset.y));
                endIdx = Mathf.Min((int)((-pos.y + viewportSize.y) / elementOffset.y) + 1, m_dataCount);
                break;
            case Direction.LEFT_TO_RIGHT:
                pos.x += m_Padding.left;
                startIdx = Mathf.Max(0, (int)(-pos.x / elementOffset.x));
                endIdx = Mathf.Min((int)((-pos.x + viewportSize.x) / elementOffset.x) + 1, m_dataCount);
                break;
            case Direction.RIGHT_TO_LEFT:
                pos.x -= m_Padding.right;
                startIdx = Mathf.Max(0, (int)(-pos.x / elementOffset.x));
                endIdx = Mathf.Min((int)((-pos.x + viewportSize.x) / elementOffset.x) + 1, m_dataCount);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
        
        return (startIdx, endIdx);
    }

    private void Refresh()
    {
        if (m_dataCount == 0)
            return;
        
        var (startIdx, endIdx) = GetRefreshIndexRange();
        Refresh(startIdx, endIdx);
    }

    private readonly Queue<UIElement> m_RecycleQueue = new();
    private int m_prevStartElementIdx = 0, m_prevEndElementIdx = -1;
    private void Refresh(int newStartElementIdx, int newEndElementIdx)
    {
        DeepCopyElements();

        var elementSize = ElementSize;
        
        var l_padding = m_Padding;
        var l_ElementOffset = new Vector2(elementSize.x + m_Spacing, elementSize.y + m_Spacing);

        using var itemsToRemove = PooledList<UIElement>.Get();
        
        //기존 범위에서 벗어난 셀은 재사용 큐로 이동
        for (int i = m_prevStartElementIdx, j = 0; i < m_prevEndElementIdx; i++, j++)
        {
            if (!(i >= newStartElementIdx && i < newEndElementIdx))
            {
                m_Elements[j].elementRoot.SetActive(false);
                m_RecycleQueue.Enqueue(m_Elements[j]);
                itemsToRemove.Add(m_Elements[j]);
            }
        }

        //재사용 큐로 이동 된 셀 제거
        for (var i = m_Elements.Count - 1; i >= 0; --i)
        {
            if (itemsToRemove.Contains(m_Elements[i]))
                m_Elements.RemoveAt(i);
        }
        
        for (int i = newStartElementIdx, j = 0; i < newEndElementIdx; ++i)
        {
            //기존 범위 안에 있으면 스킵
            if (i >= m_prevStartElementIdx && i < m_prevEndElementIdx)
                continue;

            //
            if (!m_RecycleQueue.TryDequeue(out var element))
            {
                element = m_Element.AddElement();
            }

            element.elementRoot.SetActive(true);
            
            var rt = (RectTransform)element.elementRoot.transform;

            var pos = rt.anchoredPosition;
            rt.anchoredPosition = m_Direction switch
            {
                Direction.TOP_TO_BOTTOM => new Vector2(pos.x, -i * l_ElementOffset.y - l_padding.top),
                Direction.BOTTOM_TO_TOP => new Vector2(pos.x, i * l_ElementOffset.y + l_padding.bottom),
                Direction.LEFT_TO_RIGHT => new Vector2(i * l_ElementOffset.x + l_padding.left, pos.y),
                Direction.RIGHT_TO_LEFT => new Vector2(-i * l_ElementOffset.x - l_padding.right, pos.y),
                _ => throw new ArgumentOutOfRangeException()
            };

            InvokeElementDelegate(i, element);

            //기존 범위 이전, 이후에 맞게 Insert 및 Add
            if (i >= m_prevEndElementIdx)
            {
                m_Elements.Add(element);
            }
            else if (i < m_prevStartElementIdx)
            {
                m_Elements.Insert(j++, element);
            }
        }
        
        // m_Elements 리스트를 직접 정렬하면 인덱스 기반의 재활용 로직이 깨지므로, SiblingIndex 설정을 위해 임시 리스트를 만들어 정렬합니다.
        using (var sortedElements = PooledList<UIElement>.Get())
        {
            sortedElements.AddRange(m_Elements);
            
            sortedElements.Sort((a, b) =>
            {
                var posA = ((RectTransform)a.elementRoot.transform).anchoredPosition;
                var posB = ((RectTransform)b.elementRoot.transform).anchoredPosition;

                return posB.y.CompareTo(posA.y);
            });

            for (var i = 0; i < sortedElements.Count; i++)
            {
                sortedElements[i].elementRoot.transform.SetSiblingIndex(i);
            }
        }

        m_prevStartElementIdx = newStartElementIdx;
        m_prevEndElementIdx = newEndElementIdx;

        var prevSizeDelta = content.sizeDelta;
        content.sizeDelta = GetContentSize(m_dataCount);
        
        RefreshFocusHandle();

        if (prevSizeDelta != content.sizeDelta)
        {
            foreach (var subscriber in viewport.GetComponentsInChildren<IUITableViewEventSubscribers>())
            {
                subscriber.OnTableViewContentSizeChanged(content.sizeDelta);
            }
        }
    }

    public Vector2 GetContentSize(int dataCount, int size = 0)
    {
        var elementSize = new Vector2(size, size);
        if (size == 0)
        {
            DeepCopyElements();

            if (m_Element != null)
                elementSize = ElementSize;
        }
        
        var elementOffset = new Vector2(elementSize.x + m_Spacing, elementSize.y + m_Spacing);
        var contentSizeDelta = dataCount * elementOffset;
        
        return m_Direction switch
        {
            Direction.TOP_TO_BOTTOM => new Vector2(-padding.horizontal, contentSizeDelta.y - m_Spacing + padding.vertical),
            Direction.BOTTOM_TO_TOP => new Vector2(-padding.horizontal, contentSizeDelta.y - m_Spacing + padding.vertical),
            Direction.LEFT_TO_RIGHT => new Vector2(contentSizeDelta.x - m_Spacing + padding.horizontal, -padding.vertical),
            Direction.RIGHT_TO_LEFT => new Vector2(contentSizeDelta.x - m_Spacing + padding.horizontal, -padding.vertical),
            _ => throw new ArgumentOutOfRangeException()
        };
    }

    public void RefreshElements<TUIElement>(UITableGenericInvoker<TUIElement>.ElementDelegate action) where TUIElement : UIElement, new()
    {
        if (m_tableInvoker == null || m_tableInvoker.type != typeof(TUIElement))
            return;
        
        DeepCopyElements();
        
        for (int i = m_prevStartElementIdx, j = 0; i < m_prevEndElementIdx; i++, j++)
        {
            var element = m_Elements[j];
            action?.Invoke(i, element as TUIElement);
        }
    }

    public void RefreshElements<DataType, TUIElement>(UITableGenericDataEx<DataType, TUIElement>.ElementDelegate action) where TUIElement : UIElement, new()
    {
        if (m_tableData == null || m_tableData.type != typeof(DataType))
            return;
        
        DeepCopyElements();
        
        for (int i = m_prevStartElementIdx, j = 0; i < m_prevEndElementIdx; i++, j++)
        {
            var element = m_Elements[j];
            action?.Invoke(m_tableData.list as List<DataType>, i, element as TUIElement);
        }
    }

    public void RefreshElements()
    {
        DeepCopyElements();
        
        for (int i = m_prevStartElementIdx, j = 0; i < m_prevEndElementIdx; i++, j++)
        {
            var element = m_Elements[j];
            InvokeElementDelegate(i, element);
        }   
    }
    
    private void InvokeElementDelegate(int idx, IUIElement element)
    {
        m_tableInvoker?.InvokeElementDelegate(idx, element);
        m_tableData?.InvokeElementDelegate(idx, element);
    }

    private bool wasCopy = false;
    private void DeepCopyElements()
    {
        if (wasCopy)
            return;
        wasCopy = true;
        
        m_Elements.Clear();
        m_Elements.AddRange(m_Element.GetElements());
    }

    private void Awake()
    {
        if (enabled)
            DeepCopyElements();
    }
    
    private void Start()
    {
        scrollRect.onValueChanged.RemoveListener(OnScrollValueChanged);
        scrollRect.onValueChanged.AddListener(OnScrollValueChanged);
    }
    
    private void OnScrollValueChanged(Vector2 normalizedPosition)
    {
        Refresh();
    }

    private void RefreshFocusHandle()
    {
        if (FocusHandleAnchoredPosition == Vector2.negativeInfinity)
            return;

        var focusCheckDelta = viewport.rect.size * m_HandleFocusInfo.ratioByViewportSize;

        switch (m_Direction)
        {
            case Direction.TOP_TO_BOTTOM:
            {
                if (m_HandleFocusInfo.focusedGameObjectStartDirection)
                    m_HandleFocusInfo.focusedGameObjectStartDirection.SetActive(content.anchoredPosition.y > FocusHandleAnchoredPosition.y + focusCheckDelta.y);
                if (m_HandleFocusInfo.focusedGameObjectEndDirection)
                    m_HandleFocusInfo.focusedGameObjectEndDirection.SetActive(content.anchoredPosition.y < FocusHandleAnchoredPosition.y - viewport.rect.size.y - focusCheckDelta.y);
                break;
            }
            case Direction.BOTTOM_TO_TOP:
            {
                if (m_HandleFocusInfo.focusedGameObjectStartDirection)
                    m_HandleFocusInfo.focusedGameObjectStartDirection.SetActive(content.anchoredPosition.y < FocusHandleAnchoredPosition.y - focusCheckDelta.y);
                if (m_HandleFocusInfo.focusedGameObjectEndDirection)
                    m_HandleFocusInfo.focusedGameObjectEndDirection.SetActive(content.anchoredPosition.y > FocusHandleAnchoredPosition.y + viewport.rect.size.y + focusCheckDelta.y);
                break;
            }
            case Direction.LEFT_TO_RIGHT:
            {
                if (m_HandleFocusInfo.focusedGameObjectStartDirection)
                    m_HandleFocusInfo.focusedGameObjectStartDirection.SetActive(content.anchoredPosition.x < FocusHandleAnchoredPosition.x - focusCheckDelta.x);
                if (m_HandleFocusInfo.focusedGameObjectEndDirection)
                    m_HandleFocusInfo.focusedGameObjectEndDirection.SetActive(content.anchoredPosition.x > FocusHandleAnchoredPosition.x + viewport.rect.size.x + focusCheckDelta.x);
                break;
            }
            case Direction.RIGHT_TO_LEFT:
            {
                if (m_HandleFocusInfo.focusedGameObjectStartDirection)
                    m_HandleFocusInfo.focusedGameObjectStartDirection.SetActive(content.anchoredPosition.x > FocusHandleAnchoredPosition.x + focusCheckDelta.x);
                if (m_HandleFocusInfo.focusedGameObjectEndDirection)
                    m_HandleFocusInfo.focusedGameObjectEndDirection.SetActive(content.anchoredPosition.x < FocusHandleAnchoredPosition.x - viewport.rect.size.x - focusCheckDelta.x);
                break;
            }
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    protected void OnEnable()
    {
        UpdateContent();
    }

    protected void OnDisable()
    {
        m_Tracker.Clear();
    }

    private void UpdateContent()
    {
        m_Tracker.Clear();
        
        if (content != null)
        {
            m_Tracker.Add(this, content,
                DrivenTransformProperties.Rotation |
                DrivenTransformProperties.Scale |
                DrivenTransformProperties.Anchors |
                DrivenTransformProperties.Pivot |
                DrivenTransformProperties.AnchoredPosition3D |
                GetDrivenPropertiesByDirection());
            
            var l_Content = content;
            
            l_Content.localRotation = Quaternion.identity;
            l_Content.localScale = Vector3.one;
            
            var (min, max) = GetAnchor();
            l_Content.anchorMin = min;
            l_Content.anchorMax = max;
            
            var pivot = GetPivot();
            l_Content.pivot = pivot;
            
            var contentSize = content.rect.size;
            contentSize = Vector2.Max(contentSize, new Vector2(100, 100));

            switch (m_Direction)
            {
                case Direction.TOP_TO_BOTTOM:
                    l_Content.sizeDelta = new Vector2(-padding.horizontal, contentSize.y);
                    break;
                case Direction.BOTTOM_TO_TOP:
                    l_Content.sizeDelta = new Vector2(-padding.horizontal, contentSize.y);
                    break;
                case Direction.LEFT_TO_RIGHT:
                    l_Content.sizeDelta = new Vector2(contentSize.x, -padding.vertical);
                    break;
                case Direction.RIGHT_TO_LEFT:
                    l_Content.sizeDelta = new Vector2(contentSize.x, -padding.vertical);
                    break;
            }
            
        }
        
    }

    private Vector2 GetPivot()
    {
        return m_Direction switch
        {
            Direction.TOP_TO_BOTTOM => new Vector2(0.5f, 1f),
            Direction.BOTTOM_TO_TOP => new Vector2(0.5f, 0f),
            Direction.LEFT_TO_RIGHT => new Vector2(0f, 0.5f),
            Direction.RIGHT_TO_LEFT => new Vector2(1f, 0.5f),
            _ => Vector2.zero
        };
    }
    
    private (Vector2 min, Vector2 max) GetAnchor()
    {
        return m_Direction switch
        {
            Direction.TOP_TO_BOTTOM => (new Vector2(0f, 1f), new Vector2(1f, 1f)),
            Direction.BOTTOM_TO_TOP => (new Vector2(0f, 0f), new Vector2(1f, 0f)),
            Direction.LEFT_TO_RIGHT => (new Vector2(0f, 0f), new Vector2(0f, 1f)),
            Direction.RIGHT_TO_LEFT => (new Vector2(1f, 0f), new Vector2(1f, 1f)),
            _ => (Vector2.zero, Vector2.zero)
        };
    }
    
    private DrivenTransformProperties GetDrivenPropertiesByDirection()
    {
        return m_Direction switch
        {
            Direction.TOP_TO_BOTTOM => DrivenTransformProperties.SizeDeltaX,
            Direction.BOTTOM_TO_TOP => DrivenTransformProperties.SizeDeltaX,
            Direction.LEFT_TO_RIGHT => DrivenTransformProperties.SizeDeltaY,
            Direction.RIGHT_TO_LEFT => DrivenTransformProperties.SizeDeltaY,
            _ => DrivenTransformProperties.SizeDelta 
        };
    }

#if UNITY_EDITOR
    protected void OnValidate()
    {
        UpdateContent(); 
    }

    [MenuItem("GameObject/UI/Table - Extensions", false, 3000)]
    public static void AddTableViewEx(MenuCommand menuCommand)
    {
        var go = CreateTableViewEx("TableViewEx");
        Utility.PlaceUIElementRoot(go, menuCommand);
    }
    
    private static GameObject CreateTableViewEx(string name)
    {
        var go = new GameObject(name);
        var table = go.AddComponent<UITableViewEx>();
        var image = go.AddComponent<Image>();
        image.color = new Color(1f, 1f, 1f, 0f);
        
        var content = new GameObject("Content");
        var contentRectTransform = content.AddComponent<RectTransform>();
        Utility.SetParentAndAlign(content, go);
        
        var rectTransform = go.GetComponent<RectTransform>();
        var scrollRect = go.GetComponent<ScrollRectEx>();
        scrollRect.viewport = rectTransform;
        scrollRect.content = contentRectTransform;
        scrollRect.movementType = ScrollRect.MovementType.Clamped;
        table.m_ScrollRect = scrollRect;
        table.UpdateContent();
        
        return go;
    }
#endif

    
}
