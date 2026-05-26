using System;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;


public class DragDropObject : MonoBehaviour, IPointerDownHandler, IPointerEnterHandler, IPointerExitHandler, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    [ReadOnly]
    public int index;
    public DragDropParent parent;

    public bool dropOnly;

    public float dragThreshHold;
    protected double _pointerDownAt;
    
    [Serializable]
    public class DropEvent: UnityEvent<int>
    {
    }

    public DropEvent onDrop = new DropEvent();

    public Func<int, bool> canDrag = null;
    
    public virtual void OnBeginDrag(PointerEventData eventData)
    {
        DoForParents<IBeginDragHandler>((parent) =>
        {
            parent.OnBeginDrag(eventData);
        });
        
        if (dropOnly || _pointerDownAt + dragThreshHold - Utility.GetTime() > 0)
            return;

        if (parent.floatingObject != null ||
            (parent.pointerEnterObject != null && parent.pointerEnterObject.index != index))
            return;

        if (canDrag?.Invoke(index) != true)
            return;
        
        var go = gameObject.Clone();
        go.AddComponent<DragDropFloatingObject>().Initialize(index, parent);
    }

    public virtual void OnDrag(PointerEventData eventData)
    {
        if (parent.floatingObject != null)
            return;
        
        DoForParents<IDragHandler>((parent) =>
        {
            parent.OnDrag(eventData);
        });
    }

    public virtual void OnEndDrag(PointerEventData eventData)
    {
        DoForParents<IEndDragHandler>((parent) =>
        {
            parent.OnEndDrag(eventData);
        });
    }
    
    protected void DoForParents<T>(Action<T> action) where T : IEventSystemHandler
    {
        var parent = transform.parent;

        while (parent != null)
        {
            foreach (var component in parent.GetComponents<Component>())
            {
                if (component is T)
                    action((T)(IEventSystemHandler)component);
            }

            parent = parent.parent;
        }
    }
    
    public virtual void OnPointerDown(PointerEventData eventData)
    {
        _pointerDownAt = Utility.GetTime();
    }
    
    public virtual void OnPointerEnter(PointerEventData eventData)
    {
        parent.OnPointerEnter(this);
    }
    
    public virtual void OnPointerExit(PointerEventData eventData)
    {
        parent.OnPointerExit(this);
    }
}
