using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Pool;

public class MergeBoardViewer : MergeBoardBase
{
    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        if (!isActiveAndEnabled)
            return;

        switch (e.type)
        {
            case GameEventType.BoardInventoryExpanded:
            case GameEventType.BoardInventoryMerged:
            case GameEventType.BoardInventoryMoved:
            case GameEventType.BoardInventorySpawned:
            {
                Refresh();
                break;
            }
        }
    }

    private void OnEnable()
    {
        Refresh();
    }

    public override void Refresh()
    {
        base.Refresh();
        
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        RefreshMapInventoryGrid();

        using var inventoryItems = PooledList<PlayerItemMessage>.Get();
        foreach (var playerItemMessage in myBoardPlayer.GetFlatInventories())
        {
            inventoryItems.Add(playerItemMessage);
        }
        
        // dx dy 처리
        using var preDefinedIndices = PooledList<int>.Get();
        for (var i = 0; i < inventoryItems.Count; i++)
        {
            var item = inventoryItems[i];

            var resItem = item.GetData()!;

            if (resItem != null)
            {
                foreach (var inventoryCell in resItem.InventoryCells)
                {
                    var index = i + inventoryCell.Dx + inventoryCell.Dy * gridCellCountX;
                    if (index < 0 || index >= cells.Count)
                        continue;
                    
                    preDefinedIndices.Add(index);
                }
            }
        }
        
        for (var i = 0; i < inventoryItems.Count; i++)
        {
            var item = inventoryItems[i];
            var cell = cells[i];

            var resItem = item.GetData()!;
            
            if (preDefinedIndices.Contains(i))
                continue;
            
            cell.btnCell.SetOnClick(() =>
            {
                if (item == null || item.Id == 0 || resItem == null)
                    return;
                GameManager.Get().ShowPopup<Popup_WeaponInfo>().Initialize(resItem);
            });
            
            cell.Refresh(i, item, this, cell);
            
            if (resItem != null)
            {
                cell.inventoryItemImage.DisableDragDrop();
                cell.inventoryItemImage.InitPosition(cell.GetCenterWorldPosition());
                
                var baseCellIndex = new Vector2Int(i % gridCellCountX, i / gridCellCountX);
                foreach (var inventoryCell in resItem.InventoryCells)
                {
                    var index = i + inventoryCell.Dx + inventoryCell.Dy * gridCellCountX;
                    if (index < 0 || index >= cells.Count)
                        continue;
                    
                    var otherCell = cells[index];
                    
                    otherCell.btnCell.SetOnClick(() =>
                    {
                        if (item == null || item.Id == 0)
                            return;
                        GameManager.Get().ShowPopup<Popup_WeaponInfo>().Initialize(resItem);
                    });

                    otherCell.Refresh(index, item, this, cell, false);
                    
                    inventoryItems[index] = item;
                }
                
                using var indexes = PooledHashSet<Vector2Int>.Get();
                indexes.Add(baseCellIndex);
                foreach (var inventoryCell in resItem.InventoryCells)
                {
                    indexes.Add(new Vector2Int(baseCellIndex.x + inventoryCell.Dx, baseCellIndex.y + inventoryCell.Dy));
                }
                
                foreach (var index in indexes)
                {
                    if (index.x < 0 || index.x >= gridCellCountX || index.y < 0 || index.y >= gridCellCountY)
                        continue;
                    
                    var cellIndex = index.x + index.y * gridCellCountX;
                    if (cellIndex < 0 || cellIndex >= cells.Count)
                        continue;

                    var targetCell = cells.GetClamped(cellIndex);
                    targetCell.RefreshFillPad(index, indexes);
                }
            }
        }
        
        PositionCells(m_MapInventoryGrid);
    }

    protected override void DoFitBoard(bool[][] grid, bool init = false, bool doRefresh = true)
    {
        var boardSize = GetBoardSize(grid);
        transform.DOKill();
        ((RectTransform)transform).sizeDelta = boardSize;
    }
}
