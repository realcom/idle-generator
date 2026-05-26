using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public abstract class MergeBoardCellBase : MonoBehaviour
{
    // public Image imgItem;
    public Image imgBg;
    public RectTransform rtFill;

    [SerializeField] private RectTransform m_FillLeftPad;
    [SerializeField] private RectTransform m_FillRightPad;
    [SerializeField] private RectTransform m_FillTopPad;
    [SerializeField] private RectTransform m_FillBottomPad;

    public Color emptyColor;
    public Color expandColor;
    
    // public Image imgEffect;
    public CustomButton btnCell;
    public InventoryItemImage inventoryItemImage { get; set; }
    public MergeBoardCellBase baseCell { get; private set; }

    protected ResourceSkill resSkill;
    public PlayerItemMessage playerItem;

    public void Clear()
    {
        index = -1;
        resSkill = null;
        playerItem = null;
        imgBg.color = emptyColor;
        rtFill.SetActive(false);
        ResetFill();

        ClearInventoryItemImage();
    }

    public void ClearInventoryItemImage()
    {
        if (inventoryItemImage)
        {
            inventoryItemImage.Clear();

            if (parentBoardBase)
                parentBoardBase.ReturnInventoryItemImage(inventoryItemImage);
        }

        inventoryItemImage = null;
    }

    public void ResetFill()
    {
        rtFill.anchorMin = Vector2.zero;
        rtFill.anchorMax = Vector2.one;
    }

    public bool isValid => !hideCell && playerItem != null;

    public void ShowFill(bool show)
    {
        rtFill.SetActive(show);
    }

    protected MergeBoardBase parentBoardBase { get; private set; } = null;
    protected int index = -1;
    
    private bool hideCell = false;

    public virtual void Refresh(int index, PlayerItemMessage item, MergeBoardBase parentBoard, MergeBoardCellBase baseCell, bool hideCell = false)
    {
        if (playerItem?.Id != item.Id)
        {
            if (inventoryItemImage)
                ClearInventoryItemImage();
        }

        ResetFill(); 
        playerItem = item;
        this.baseCell = baseCell;
        this.parentBoardBase = parentBoard;

        this.index = index;
        
        var resItem = item?.GetData();
        if (resItem == null)
        {
            Clear();
            return;
        }

        this.hideCell = hideCell;
        rtFill.SetActive(!hideCell);
        
        if (baseCell != this)
        {
            ClearInventoryItemImage();
            return;
        }
        
        resSkill = ResourceSkill.Get(resItem.SkillDataId);
        
        if (baseCell == this)
        {
            var (centerOffset, sizeDelta) = GetCenterAndSize(resItem, parentBoard.cellSize);
            
            if (!inventoryItemImage)
            {
                var go = parentBoard.RentInventoryItemImage(Vector3.zero, Quaternion.identity, transform.parent);
                inventoryItemImage = go.GetComponent<InventoryItemImage>();
            }

            inventoryItemImage.name = $"InventoryItemImage_{resItem.Id}_{index}";
            inventoryItemImage.Refresh(resItem, sizeDelta, HideThis(parentBoard));
        }
    }
    
    public Vector3 GetCenterLocalPosition()
    {
        if (playerItem == null)
            return Vector3.zero;

        var centerOffset = GetCenterAndSize(playerItem.GetData(), parentBoardBase.cellSize).centerOffset;
        return hideCell ? transform.localPosition : transform.localPosition + centerOffset;
    }
    
    public Vector3 GetCenterWorldPosition()
    {
        if (playerItem == null)
            return Vector3.zero;

        return transform.parent.TransformPoint(GetCenterLocalPosition());
    }

    public void RefreshFillPad(Vector2Int cellIndex, HashSet<Vector2Int> indexes)
    {
        var hasLeft = indexes.Contains(new Vector2Int(cellIndex.x - 1, cellIndex.y));
        var hasRight = indexes.Contains(new Vector2Int(cellIndex.x + 1, cellIndex.y));
        var hasTop = indexes.Contains(new Vector2Int(cellIndex.x, cellIndex.y - 1));
        var hasBottom = indexes.Contains(new Vector2Int(cellIndex.x, cellIndex.y + 1));
        var hasLeftTop = indexes.Contains(new Vector2Int(cellIndex.x - 1, cellIndex.y - 1));
        var hasRightTop = indexes.Contains(new Vector2Int(cellIndex.x + 1, cellIndex.y - 1));
        var hasLeftBottom = indexes.Contains(new Vector2Int(cellIndex.x - 1, cellIndex.y + 1));
        var hasRightBottom = indexes.Contains(new Vector2Int(cellIndex.x + 1, cellIndex.y + 1));
        
        m_FillLeftPad.SetActive(hasLeft);
        m_FillRightPad.SetActive(hasRight);
        m_FillTopPad.SetActive(hasTop);
        m_FillBottomPad.SetActive(hasBottom);

        m_FillLeftPad.offsetMax = new Vector2(m_FillLeftPad.offsetMax.x, hasLeft && hasTop && hasLeftTop ? 1.5f : 1f);
        m_FillLeftPad.offsetMin = new Vector2(m_FillLeftPad.offsetMin.x, hasLeft && hasBottom && hasLeftBottom ? -0.5f : 0f);
        m_FillRightPad.offsetMax = new Vector2(m_FillRightPad.offsetMax.x, hasRight && hasTop && hasRightTop ? 1.5f : 1f);
        m_FillRightPad.offsetMin = new Vector2(m_FillRightPad.offsetMin.x, hasRight && hasBottom && hasRightBottom ? -0.5f : 0f);
        m_FillTopPad.offsetMax = new Vector2(hasTop && hasRight && hasRightTop ? 1.5f : 1f, m_FillTopPad.offsetMax.y);
        m_FillTopPad.offsetMin = new Vector2(hasTop && hasLeft && hasLeftTop ? -0.5f : 0f, m_FillTopPad.offsetMin.y);
        m_FillBottomPad.offsetMax = new Vector2(hasBottom && hasRight && hasRightBottom ? 1.5f : 1f, m_FillBottomPad.offsetMax.y);
        m_FillBottomPad.offsetMin = new Vector2(hasBottom && hasLeft && hasLeftBottom ? -0.5f : 0f, m_FillBottomPad.offsetMin.y);
        
        m_FillLeftPad.sizeDelta = m_FillRightPad.sizeDelta = m_FillTopPad.sizeDelta = m_FillBottomPad.sizeDelta = Vector2.zero;
        m_FillLeftPad.anchoredPosition = m_FillRightPad.anchoredPosition = m_FillTopPad.anchoredPosition = m_FillBottomPad.anchoredPosition = Vector2.zero;
    }

    protected abstract bool HideThis(MergeBoardBase parentBoard);
    
    public static (Vector3 centerOffset, Vector2 size) GetCenterAndSize(ResourceItem resItem, Vector2 cellSize)
    {
        var maxDx = 0;
        var minDx = 0;
        var maxDy = 0;
        var minDy = 0;

        var cells = resItem.InventoryCells;
        if (cells.Count > 0)
        {
            maxDx = cells.Max(x => x.Dx);
            minDx = cells.Min(x => x.Dx);
            maxDy = cells.Max(x => x.Dy);
            minDy = cells.Min(x => x.Dy);
        }
        
        if (maxDx < 0)
            maxDx = 0;
        
        if (maxDy < 0)
            maxDy = 0;
        
        if (minDx > 0)
            minDx = 0;
        
        if (minDy > 0)
            minDy = 0;

        var widthUnit = maxDx - minDx + 1;
        var heightUnit = maxDy - minDy + 1;

        var centerOffset = new Vector3((maxDx + minDx) * 0.5f, -(maxDy + minDy) * 0.5f, 0) * cellSize.x;
        var sizeDelta = new Vector2(widthUnit, heightUnit) * cellSize.x;

        return (centerOffset, sizeDelta);
    }
    
    public static (int dx, int dy) GetDxDyFromPositionOffset(ResourceItem resItem, Vector2 cellSize, Vector2 positionOffset)
    {
        var maxDx = 0;
        var minDx = 0;
        var maxDy = 0;
        var minDy = 0;

        var cells = resItem.InventoryCells;
        if (cells.Count > 0)
        {
            maxDx = cells.Max(x => x.Dx);
            minDx = cells.Min(x => x.Dx);
            maxDy = cells.Max(x => x.Dy);
            minDy = cells.Min(x => x.Dy);
        }

        if (maxDx < 0)
            maxDx = 0;

        if (maxDy < 0)
            maxDy = 0;

        if (minDx > 0)
            minDx = 0;

        if (minDy > 0)
            minDy = 0;

        var centerDx = (maxDx + minDx) * 0.5f;
        var centerDy = (maxDy + minDy) * 0.5f;

        var offsetDxByCenter = (positionOffset.x) / cellSize.x;
        var offsetDyByCenter = (positionOffset.y) / cellSize.y;

        var offsetDxByPivot = offsetDxByCenter + centerDx;
        var offsetDyByPivot = offsetDyByCenter + centerDy;
            
        var dx = (int)Math.Round(offsetDxByPivot);
        var dy = (int)Math.Round(offsetDyByPivot);

        return (dx, dy);
    }
    
}
