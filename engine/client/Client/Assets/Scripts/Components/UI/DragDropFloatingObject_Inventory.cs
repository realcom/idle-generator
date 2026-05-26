using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using DG.Tweening;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Serialization;
using UnityEngine.UI;


public class DragDropFloatingObject_Inventory : DragDropFloatingObject
{
    public MergeBoardCell originCell;
    public Vector2 inventoryOffset;

    private readonly List<Rect> _checkRects = new();
    private readonly HashSet<Rect> _otherRects = new();
    private readonly HashSet<DragDropObject_Inventory> _otherObjects = new();
    private DragDropObject_Inventory _targetObject;
    protected override void Update()
    {
        if (Input.GetMouseButton(0))
        {
            _otherRects.Clear();
            _checkRects.Clear();
            _otherObjects.Clear();
            
            _targetObject = null;

            var cellSize = originCell.parentBoard.cellSize;
            var resItem = originCell.playerItem?.GetData();
            
            if (resItem == null)
                return;
            
            var isExpandItem = resItem.ContainsTag(Tag.InventoryExpand);
            
            var screenPos = Input.mousePosition; // 마우스 화면 좌표
            screenPos.z = 0;

            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                parent.GetComponent<RectTransform>(), // Overlay Canvas의 RectTransform
                screenPos,
                null, // Overlay 모드이므로 camera는 null
                out var localPoint
            );
            transform.localPosition = localPoint - (Vector2)offset;
            
            // var screenPosition = RectTransformUtility.WorldToScreenPoint(GameScene.Get().camera, transform.position);
            // RectTransformUtility.ScreenPointToLocalPointInRectangle(parent.GetComponent<RectTransform>(), screenPosition, GameScene.Get().camera, out var localPosition);
            var localPosition = originCell.parentBoard.transform.parent.InverseTransformPoint(transform.position); 
            var checkRectCenter = new Vector3(localPosition.x - cellSize.x / 2f, localPosition.y - cellSize.y / 2, 0f);
            
            var (centerOffset, size) = MergeBoardCellBase.GetCenterAndSize(resItem, cellSize);

            checkRectCenter -= centerOffset;

            var baseRect = new Rect(checkRectCenter.x, checkRectCenter.y, cellSize.x, cellSize.y);
            _checkRects.Add(baseRect);
            
            CheckCollapsingRects(baseRect, inventoryOffset == Vector2.zero);
            
            foreach (var resItemInventoryCell in resItem.InventoryCells)
            {
                var deltaPos = new Vector3(resItemInventoryCell.Dx * cellSize.x , -resItemInventoryCell.Dy * cellSize.y, 0);
                
                var modifiedCheckRectCenter = checkRectCenter + deltaPos;
            
                var checkRect = new Rect(modifiedCheckRectCenter.x, modifiedCheckRectCenter.y, cellSize.x, cellSize.y);
                _checkRects.Add(checkRect);
                
                CheckCollapsingRects(checkRect, resItemInventoryCell.Dx == (int)inventoryOffset.x && resItemInventoryCell.Dy == (int)inventoryOffset.y);
            }
            
            // overlap processing
            
            foreach (var dragDropObject in parent.dragDropObjects)
            {
                var cell = dragDropObject.GetComponent<MergeBoardCell>();
                if (cell && !cell.isDisabled)
                {
                    if (originCell.parentBoard.inventory[dragDropObject.index] is { Id: -1 })
                        cell.imgBg.color = cell.expandColor;
                    else
                        cell.imgBg.color = isExpandItem
                            ? Color.gray 
                            : cell.emptyColor;
                }
            }

            var paintRed = _otherObjects.Count != resItem.InventoryCells.Count + 1;
            var paintColor = paintRed ? Color.red : Color.green;
            if (!paintRed)
            {
                foreach (var dragDropObject in _otherObjects)
                {
                    var cell = dragDropObject.GetComponent<MergeBoardCell>();
                    if (!cell || cell.isDisabled)
                        continue;
                    if (cell.playerItem != null && cell.playerItem.Id != originCell.playerItem.Id)
                    {
                        //dragDropObject.originCell.baseCell.inventoryItemImage.DoShake();
                        paintColor = Color.yellow;
                    }
                }
            }

            
            foreach (var dragDropObject in _otherObjects)
            {
                var cell = dragDropObject.GetComponent<MergeBoardCell>();
                if (!cell || cell.isDisabled)
                    continue;

                if (isExpandItem && originCell.parentBoard.inventory[dragDropObject.index] is not { Id: -1 })
                    continue;

                cell.imgBg.color = paintColor;
            }

            var isHoveringOverDiscard = _targetObject && _targetObject.index == MergeBoard.SellIndexNumber;
            originCell.parentBoard.SetSellActivated(isHoveringOverDiscard);
            
            originCell.parentBoard.ShakeMergeableItems(resItem);
            
            if (parent.scroll)
            {
                var localPt = localPoint;
                var rect = parent.rectScroll.rect;

                var autoScrollAreaSize = 150;
                var autoScrollAreaTop = rect.yMax - autoScrollAreaSize;
                var autoScrollAreaBottom = rect.yMin + autoScrollAreaSize;

                var scrollPos = parent.scroll.verticalNormalizedPosition;
                if (localPt.y > autoScrollAreaTop)
                    scrollPos += Time.deltaTime * Mathf.Lerp(0f, 3f, Mathf.Clamp(Mathf.Abs(localPt.y - autoScrollAreaTop) / autoScrollAreaSize, 0f, 1f));
                else if (localPt.y < autoScrollAreaBottom)
                    scrollPos -= Time.deltaTime * Mathf.Lerp(0f, 3f, Mathf.Clamp(Mathf.Abs(localPt.y - autoScrollAreaBottom) / autoScrollAreaSize, 0f, 1f));
                parent.scroll.verticalNormalizedPosition = Mathf.Clamp(scrollPos, 0f, 1f);
            }
        }
        else
        {
            Debug.Log($"[Hormon] DragDropFloatingObject_Inventory Update() mouse button is not pressed");
            parent.OnEndDrag(this, _targetObject);
        }
    }

    private void CheckCollapsingRects(Rect checkRect, bool isCurrentRect = false)
    {
        foreach (var dragDropObject in parent.dragDropObjects.Concat(originCell.parentBoard.holdItemDropObjects))
        {
            var rectTransform = dragDropObject.GetComponent<RectTransform>();
            var otherRect = rectTransform.rect;
            
            var anchoredPos = originCell.parentBoard.transform.parent.InverseTransformPoint(rectTransform.position);
            
            otherRect.x = anchoredPos.x - otherRect.width / 2;
            otherRect.y = anchoredPos.y - otherRect.height / 2;
            var xMin = Mathf.Max(checkRect.xMin, otherRect.xMin);
            var xMax = Mathf.Min(checkRect.xMax, otherRect.xMax);
            var yMin = Mathf.Max(checkRect.yMin, otherRect.yMin);
            var yMax = Mathf.Min(checkRect.yMax, otherRect.yMax);
                    
            var intersectionWidth = xMax - xMin;
            var intersectionHeight = yMax - yMin;
                    
            if (intersectionWidth >= checkRect.width / 2 && intersectionHeight >= checkRect.height / 2)
            {
                _otherRects.Add(otherRect);
                var ddObj = (DragDropObject_Inventory)dragDropObject;
                _otherObjects.Add(ddObj);
                
                if (isCurrentRect)
                {
                    _targetObject = ddObj;
                }
            }
        }
    }

    public override void Destroy()
    {
        foreach (var dropObjectInventory in _otherObjects)
        {
            var cell = dropObjectInventory.GetComponent<MergeBoardCell>();
            if (cell && !cell.isDisabled)
            {
                if (originCell.parentBoard.inventory[dropObjectInventory.index] is { Id: -1 })
                    cell.imgBg.color = cell.expandColor;
                else
                    cell.imgBg.color = originCell.baseCell.playerItem.GetData()!.ContainsTag(Tag.InventoryExpand)
                        ? Color.gray 
                        : cell.emptyColor;
            }
        }
        
        base.Destroy();
    }
    
    private void OnDrawGizmos()
    {
        var rectTransform = parent.GetComponent<RectTransform>();
        
        for (var i = 0; i < _checkRects.Count; i++)
        {
            Gizmos.color = Color.red;

            if (i > 0)
                Gizmos.color = Color.magenta;
            
            var checkRect = _checkRects[i];
            var worldRectCenter = rectTransform.TransformPoint(checkRect.center);
            var worldRectSize = rectTransform.TransformVector(checkRect.size);
            
            Gizmos.DrawWireCube(worldRectCenter, worldRectSize);
        }
        
        foreach (var otherRect in _otherRects)
        {
            var worldOtherRectCenter = rectTransform.TransformPoint(otherRect.center);
            var worldOtherRectSize = rectTransform.TransformVector(otherRect.size);
            
            Gizmos.color = Color.green;
            Gizmos.DrawWireCube(worldOtherRectCenter, worldOtherRectSize);
        }
    }
}
