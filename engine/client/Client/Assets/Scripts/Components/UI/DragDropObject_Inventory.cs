using System;
using Commons.Resources;
using Commons.Types.Players;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Serialization;
using UnityEngine.UI;


public class DragDropObject_Inventory : DragDropObject
{
    [ReadOnly]
    public MergeBoardCell originCell;

    private Vector2 pointerOffset;
    
    public override void OnBeginDrag(PointerEventData eventData)
    {
        DoForParents<IBeginDragHandler>((parent) =>
        {
            parent.OnBeginDrag(eventData);
        });
        
        if (dropOnly || _pointerDownAt + dragThreshHold - Utility.GetTime() > 0)
            return;

        if (parent.floatingObject != null)
            // (parent.pointerEnterObject != null && parent.pointerEnterObject.index != index))
            return;
        
        parent.pointerEnterObject = this;

        if (canDrag?.Invoke(index) != true)
            return;
        

    }
    
    public override void OnPointerDown(PointerEventData eventData)
    {
        base.OnPointerDown(eventData);
        
        if (dropOnly || canDrag?.Invoke(index) != true)
            return;
        
        var resItem = originCell.playerItem?.GetData();
        if (resItem == null)
            return;
        
        var cellSize = originCell.parentBoard.cellSize;

        if (resItem.ContainsTag(Tag.InventoryExpand) == true)
            originCell.parentBoard.ShowAdjacentInactiveCells();
        
        if (index < MergeBoard.HoldIndexNumber)
        {
            var baseIndex = originCell.baseCell.GetComponent<DragDropObject_Inventory>().index;
            var currentRow = index / originCell.parentBoard.gridCellCountX;
            var currentCol = index % originCell.parentBoard.gridCellCountX;

            pointerOffset.y = currentRow - Mathf.FloorToInt(baseIndex / (float)originCell.parentBoard.gridCellCountX);
            pointerOffset.x = currentCol - baseIndex % originCell.parentBoard.gridCellCountX;
        }
        else
        {
            var pos = GameManager.Get().GetMouseWorldPosition();
            var imageCenter = GameManager.Get().ScreenToWorldPoint(originCell.baseCell.inventoryItemImage.transform.position);
            var offsetX = pos.x - imageCenter.x;
            var offsetY = imageCenter.y - pos.y;
            var positionOffset = new Vector2(offsetX, offsetY);
            var cam = GameScene.Get().GetCamera();
            var orthographicSize = cam.orthographicSize;
            var unitsPerPixel = orthographicSize * 2 / cam.pixelHeight;
            (pointerOffset.x, pointerOffset.y) = MergeBoardCell.GetDxDyFromPositionOffset(resItem, cellSize, positionOffset / unitsPerPixel);
        }
        
        var inventoryImage = originCell.baseCell.inventoryItemImage;
        inventoryImage.gameObject.SetActive(false);
        var go = inventoryImage.gameObject.Clone();

        var floatingObj = go.AddComponent<DragDropFloatingObject_Inventory>();
        floatingObj.Initialize(index, parent);
        
        floatingObj.originCell = originCell;
        
        floatingObj.inventoryOffset = pointerOffset;
        
        foreach (var cell in originCell.parentBoard.cells)
        {
            if (cell.isValid)
                cell.ShowFill(false);
            //if (cell.inventoryItemImage && cell.inventoryItemImage.showBackground)
            //    cell.inventoryItemImage.ShowBackground(false);
        }
    }
}
