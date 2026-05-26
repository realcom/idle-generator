using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class DragDropParent : MonoBehaviour
{
    public ScrollRectEx scroll;
    
    private RectTransform _rectScroll;
    public RectTransform rectScroll => _rectScroll != null ? _rectScroll : _rectScroll = scroll.Get<RectTransform>();
    
    public DragDropFloatingObject floatingObject;
    public DragDropObject pointerEnterObject;
    
    [HideInInspector]
    public List<DragDropObject> dragDropObjects = new();

    public struct SwapIndexEventParameter
    {
        public int fromIndex;
        public int toIndex;
        public Vector2 dropWorldPosition;
        public float dragPendingTime;
    }
    
    [Serializable]
    public class SwapIndexEvent: UnityEvent<SwapIndexEventParameter>
    {
    }

    public SwapIndexEvent onSwapIndex = new SwapIndexEvent();
    
    [Serializable]
    public class CellEvent: UnityEvent<int>
    {
    }
    
    public CellEvent onOverlapCell = new();
    public CellEvent onCellDragStart = new();
    public CellEvent onCellDragEnd = new();

    private double m_DragStartAt = 0f;

    public void OnBeginDrag(DragDropFloatingObject floatingObject)
    {
        m_DragStartAt = TimeSystem.time;
        
        this.floatingObject = floatingObject;
        onCellDragStart?.Invoke(this.floatingObject.index);
        GameManager.Get().DispatchEvent(GameEventType.BoardItemDragStarted);
    }

    public void OnEndDrag(DragDropFloatingObject floatingObject, DragDropObject pointerEnterObject = null)
    {
        var pendingTime = (float)(TimeSystem.time - m_DragStartAt);
        
        var dragIndex = floatingObject.index;
        if (!pointerEnterObject)
            pointerEnterObject = this.pointerEnterObject;
        
        var dropPosition = floatingObject.transform.position;
        
        Debug.Log($"[Hormon] OnEndDrag: {dragIndex} -> {pointerEnterObject?.index}");
        
        if (!pointerEnterObject)
        {
            floatingObject.Destroy();
            this.floatingObject = null;

            if (floatingObject is DragDropFloatingObject_Inventory fo)
            {
                var mergeBoard = transform.Get<MergeBoard>("MergeBoard");
                if (dragIndex < MergeBoard.HoldIndexNumber)
                    dragIndex = dragIndex - (int)fo.inventoryOffset.x - (int)fo.inventoryOffset.y * mergeBoard.gridCellCountX;
            }
            
            onSwapIndex?.Invoke(new SwapIndexEventParameter()
            {
                dropWorldPosition = dropPosition,
                fromIndex = dragIndex,
                toIndex = -1,
                dragPendingTime = pendingTime
            });
            GameManager.Get().DispatchEvent(GameEventType.BoardItemDragEnded, dropPosition);
            return;
        }
        
        var pointerIndex = pointerEnterObject.index;
        
        if (floatingObject is DragDropFloatingObject_Inventory fOBj)
        {
            floatingObject.Destroy();
            this.pointerEnterObject = null;
            this.floatingObject = null;
            
            var mergeBoard = transform.Get<MergeBoard>("MergeBoard");
            if (pointerIndex is > 0 and < MergeBoard.HoldIndexNumber) 
                pointerIndex = pointerIndex - (int)fOBj.inventoryOffset.x - (int)fOBj.inventoryOffset.y * mergeBoard.gridCellCountX;
            if (dragIndex < MergeBoard.HoldIndexNumber)
                dragIndex = dragIndex - (int)fOBj.inventoryOffset.x - (int)fOBj.inventoryOffset.y * mergeBoard.gridCellCountX;
            
            onSwapIndex?.Invoke(new SwapIndexEventParameter()
            {
                dropWorldPosition = dropPosition,
                fromIndex = dragIndex,
                toIndex = pointerIndex,
                dragPendingTime = pendingTime
            });
        }
        else
        {
            floatingObject.Destroy();
            this.pointerEnterObject = null;
            this.floatingObject = null;
            
            if (pointerEnterObject && pointerIndex != floatingObject.index)
            {
                if (pointerEnterObject.dropOnly)
                    pointerEnterObject.onDrop.Invoke(dragIndex);
                else
                    onSwapIndex?.Invoke(new SwapIndexEventParameter()
                    {
                        dropWorldPosition = dropPosition,
                        fromIndex = dragIndex,
                        toIndex = pointerIndex,
                        dragPendingTime = pendingTime
                    });
            }
        }
        
        onCellDragEnd?.Invoke(floatingObject.index);
        GameManager.Get().DispatchEvent(GameEventType.BoardItemDragEnded, dropPosition);

        // floatingObject.Destroy();
        // this.pointerEnterObject = null;
        // this.floatingObject = null;
    }
    
    public void OnPointerEnter(DragDropObject dragDropObject)
    {
        pointerEnterObject = dragDropObject;
        if (floatingObject != null)
            onOverlapCell?.Invoke(floatingObject.index != pointerEnterObject.index ? pointerEnterObject.index : -1);
    }

    public void OnPointerExit(DragDropObject dragDropObject)
    {
        if (pointerEnterObject == dragDropObject)
            pointerEnterObject = null;

        if (floatingObject != null)
            onOverlapCell?.Invoke(-1);
            //onOverlapCell?.Invoke(floatingObject.index != dragDropObject.index ? dragDropObject.index : -1);
    }
}
