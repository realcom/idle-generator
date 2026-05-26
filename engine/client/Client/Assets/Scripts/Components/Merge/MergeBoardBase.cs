using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility;
using Sirenix.OdinInspector;
using Unity.VisualScripting;
using UnityEngine;

public abstract class MergeBoardBase : ZEventBehaviour
{
    [SerializeField] protected Transform m_TrCellParent;
    [SerializeField] protected GameObject m_GoCellPrefab;
    [SerializeField] protected GameObject m_InventoryItemImagePrefab;
    public GameObject inventoryItemImagePrefab => m_InventoryItemImagePrefab;
    
    [SerializeField] protected Vector2 m_CellSize;
    [SerializeField] private Vector2Int m_BoardSize = new(7, 4);
    public Vector2 cellSize => m_CellSize;
    [SerializeField] protected Vector2 m_BoardSizePadding = Vector2.zero;
    
    public List<MergeBoardCellBase> cells = new();
    
    public int gridCellCountX => ResourceMap.Global?.BoardConstants?.BoardMaxX ?? m_BoardSize.x;
    public int gridCellCountY => ResourceMap.Global?.BoardConstants?.BoardMaxY ?? m_BoardSize.y;
    
    protected int gridTotalCellCount => gridCellCountX * gridCellCountY;
    
    protected bool[][] m_MapInventoryGrid;

    public override void Start()
    {
        base.Start();
        
        AllocateMapInventoryGrid();
    }

    public GameObject RentInventoryItemImage(Vector3 position, Quaternion rotation, Transform parent = null)
    {
        return GameObjectPool.Get(m_InventoryItemImagePrefab, position, rotation, parent ?? m_TrCellParent);
    }
    
    public void ReturnInventoryItemImage(InventoryItemImage inventoryItemImage)
    {
        if (inventoryItemImage == null)
            return;

        inventoryItemImage.DisableDragDrop();

        GameObjectPool.Release(inventoryItemImage.gameObject);
    }

    protected void AllocateMapInventoryGrid()
    {
        m_MapInventoryGrid ??= new bool[gridCellCountY][];
        for (var row = 0; row < gridCellCountY; row++)
            m_MapInventoryGrid[row] ??= new bool[gridCellCountX];
    }

    protected void RefreshMapInventoryGrid()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        if (m_MapInventoryGrid == null)
            AllocateMapInventoryGrid();

        if (m_MapInventoryGrid == null)
            return;

        if (myBoardPlayer.Inventories.Count == 0)
        {
            foreach (var row in m_MapInventoryGrid)
            {
                if (row == null)
                    continue;

                Array.Clear(row, 0, row.Length);
            }

            return;
        }
        
        var inventory = myBoardPlayer.Inventories.First();
        for (var row = 0; row < inventory.Rows.Count; row++)
        {
            for (var index = 0; index < inventory.Rows[row].Items.Count; index++)
            {
                m_MapInventoryGrid[row][index] = inventory.Rows[row].Items[index]?.Id != -1;
            }
        }
    }
    
    protected Vector2 GetBoardSize(bool[][] grid = null)
    {
        var minRow = int.MaxValue;
        var maxRow = 0;
        
        var minIndex = int.MaxValue;
        var maxIndex = 0;
        var anyShown = false;

        for (var row = 0; row < gridCellCountY; row++)
        {
            for (var index = 0; index < gridCellCountX; index++)
            {
                var isShown = true;
                if (grid != null)
                {
                    var rowValues = row < grid.Length ? grid[row] : null;
                    if (rowValues == null || index >= rowValues.Length)
                        continue;

                    isShown = rowValues[index];
                }

                if (isShown)
                {
                    anyShown = true;

                    if (row < minRow)
                        minRow = row;
                    if (row > maxRow)
                        maxRow = row;

                    if (index < minIndex)
                        minIndex = index;
                    if (index > maxIndex)
                        maxIndex = index;
                }
            }
        }

        if (!anyShown)
            return Vector2.zero;

        var cellXMiddleIndex = gridCellCountX / 2;
        var maxOffset = Math.Max(cellXMiddleIndex - minIndex, maxIndex - cellXMiddleIndex) * 2;
        var requiredWidth = Math.Max((maxOffset + 1) * m_CellSize.x + m_BoardSizePadding.x, 0f);
        var requiredHeight = Math.Max((maxRow - minRow + 1) * m_CellSize.y + m_BoardSizePadding.y, 0f);

        return new Vector2(requiredWidth, requiredHeight);
    }
    
    [Button]
    public void FillCells()
    {
        if (m_TrCellParent == null)
            return;

        m_TrCellParent.DestroyAllChildren();
        cells.Clear();

        var list = cells.ToList();

        var listCount = list.Count;

        var boardSize = GetBoardSize();
        ((RectTransform)transform).sizeDelta = boardSize;
        ((RectTransform)m_TrCellParent).sizeDelta = boardSize;

        if (listCount < gridTotalCellCount)
        {
            for (var i = 0; i < gridTotalCellCount - listCount; i++)
            {
                var cell = Instantiate(m_GoCellPrefab, m_TrCellParent, false).GetComponent<MergeBoardCellBase>();
                ((RectTransform)cell.transform).sizeDelta = m_CellSize;
                list.Add(cell);
            }
        }

        var index = 0;
        var paddingX = m_CellSize.x * 0.5f;
        var paddingY = m_CellSize.y * 0.5f;
        for (var y = 0; y < gridCellCountY; y++)
        {
            for (var x = 0; x < gridCellCountX; x++)
            {
                if (index >= list.Count)
                    break;

                var posX = paddingX + + x * m_CellSize.x;
                var posY = -paddingY - y * m_CellSize.y;
                var pos = new Vector2(posX, posY);

                var rtFloor = list[index].transform.GetComponent<RectTransform>();
                rtFloor.anchoredPosition = pos;
                rtFloor.localScale = Vector3.one;
                rtFloor.SetActive(true);

                index++;
            }
        }

        if (list.Count > gridTotalCellCount)
        {
            for (var i = gridTotalCellCount; i < list.Count; i++)
            {
                list[i].transform.SetActive(false);
            }
        }

        cells = list.ToList();
    }

    protected void PositionCells(bool[][] grid, bool init = false, bool doRefresh = true)
    {
        if (grid == null)
        {
            AllocateMapInventoryGrid();
            grid = m_MapInventoryGrid;
        }

        if (grid == null)
            return;

        for (var i = 0; i < cells.Count; i++)
        {
            var cell = cells[i].transform.gameObject;

            var row = i / gridCellCountX;
            var index = i % gridCellCountX;
            var rowValues = row < grid.Length ? grid[row] : null;
            if (rowValues == null || index >= rowValues.Length)
            {
                cell.SetActive(false);
                continue;
            }
            
            var isShown = rowValues[index];
            cell.SetActive(isShown);
        }
        
        DoFitBoard(grid, init, doRefresh);
    }
    
    protected abstract void DoFitBoard(bool[][] grid, bool init = false, bool doRefresh = true);
    
}
