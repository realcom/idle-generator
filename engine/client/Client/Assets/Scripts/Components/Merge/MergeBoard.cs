using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Coffee.UIExtensions;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class MergeBoard : MergeBoardBase
{
    public Transform trHoldCellParent;

    public RectTransform rtDim;
    public RectTransform rtHighlightedItemImageParent;
    
    [Title("드래그드랍 셀")]
    public DragDropParent dragDropParent;
    public float dragThreshHold = 0.1f;
    public List<MergeBoardCell> holdCells = new();
    
    [Title("하단")]
    public DragDropObject_Inventory[] sellDropObjects;
    public CanvasGroup cgBoardRoot;
    public TextMeshProUGUI txtPlayerHandHoldGold;
    public DOTweenAnimation animPlayerHandHoldGoldIncrease;
    public RectTransform rtPlayerHeldGold;
    //public GameObject goSell;
    //public CustomButton btnSell;
    //public Animator animatorForSell;
    //public UnitUIRenderer unitUIRendererForSell;
    //public Transform sellPivotTransform;
    public GameObject goFreeSpawn;
    public CustomButton btnFreeSpawn;
    public TextMeshProUGUI txtFreeSpawn;
    public GameObject goSummon;
    public CustomButton btnSummon;
    public CustomToggle toggleAutoSpawn;
    public Image imgAutoSpawnCoolTimeFill;
    public Transform summonPivotTransform;
    public Transform summonMidwayPivotTransform;
    public GameObject goGameStart;
    public CustomButton btnGameStart;
    public GameObject goForceBlock;
    public TextMeshProUGUI txtForceBlock;
    public RectTransform rtHoldCountParent;
    public TextMeshProUGUI txtHoldCount;

    public UIParticle[] particleLuckyEffects = new UIParticle[0];
    public UIParticle particleLuckySummonEffect;

    [Title("폴리스 라인")] 
    public GameObject goPoliceLine;
    public Animator animPoliceLine;
    

    public const int HoldIndexNumber = 1000;
    public const int SellIndexNumber = -1000;
    
    public override void Refresh()
    {
        base.Refresh();
        
        RefreshInventory(true);
        RefreshInfos();
    }

    private void RefreshInfos()
    {
        RefreshSummonInfo();
        RefreshButtons();
        RefreshHoldCount();
    }
    
    public IEnumerator Initialize(ResourceMap resMap)
    {
        PositionCells(m_MapInventoryGrid, true);
        ResetHoldCells();
        
        Refresh();
        
        btnSummon.SetOnClick(OnClickSpawn);
        btnFreeSpawn.SetOnClick(OnClickSpawn);

        btnGameStart.SetOnClick(() =>
        {
            if (GameBoardManager.Get().gameBoard?.State != GameBoard.Types.State.Initialized)
                return;
            
            GameBoardManager.Get().UpdateBoardState(MyPlayer.Player.Id, GameBoard.Types.State.Playing);
        });

        isAutoSpawnEnabled = toggleAutoSpawn && !resMap.ContainsTag(Tag.HideAutoSpawn) && MyPlayer.IsAchievementCompletedOrRewarded(ResourceAchievement.Global.DataId.InventoryAutoSpawnUnlock);
        //isAutoSpawnEnabled = true;
        
        if (toggleAutoSpawn)
        {
            toggleAutoSpawn.isOn = InventoryAutoSpawnEnabled.Get();
            toggleAutoSpawn.onChanged += isOn =>
            {
                InventoryAutoSpawnEnabled.Set(isOn);
                imgAutoSpawnCoolTimeFill.SetActive(isOn);
                if (isOn)
                    MarkCooldownAutoSpawn();
            };
            toggleAutoSpawn.SetActive(isAutoSpawnEnabled);
            imgAutoSpawnCoolTimeFill.SetActive(isAutoSpawnEnabled && toggleAutoSpawn.isOn);
        }
        
        RefreshSummonInfo();
        RefreshButtons();
        
        yield break;
    }

    private void OnClickSpawn()
    {
        //GameBoardManager.Get().UpdateBoardPlayerInventorySpawn(resetHoldItemsWhenSpawn, MyPlayer.Player.Id);
        GameManager.Get().PlayFX("Ingame_Reroll");
        GameBoardManager.Get().UpdateBoardPlayerInventorySpawn(MyPlayer.Player.Id);

        MarkCooldownAutoSpawn();
    }
    
    private void MarkCooldownAutoSpawn()
    {
        nextAutoSpawnAvailableAt = TimeSystem.time + CRC.Get().globalParameters.autoSpawnPeriod;
    }

    protected override void DoFitBoard(bool[][] grid, bool init = false, bool doRefresh = true)
    {
        var rectTransform = (RectTransform)transform;
        var requiredSize = GetBoardSize(grid);
        
        rectTransform.DOKill();
        rectTransform.DOSizeDelta(requiredSize, init ? 0 : 0.3f)
            .SetEase(Ease.OutBack)
            .OnComplete(() =>
            {
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

                    var isCellActive = cell.gameObject.activeInHierarchy;
                    cell.SetActive(isShown);
                    if (!isCellActive && isShown)
                    {
                        cell.transform.DOPunchScale(Vector3.one * 0.1f, 0.5f);
                        
                        var obj = GameObjectPool.GetTransient(fxPung, Vector3.zero, Quaternion.identity, cgBoardRoot.transform);
                        obj.transform.position = cell.transform.position;
                    }
                }
                
                if (doRefresh)
                    Refresh();
            });
    }

    private void ResetHoldCells()
    {
        foreach (var holdCell in holdCells)
        {
            holdCell.Clear();
            holdCell.SetActive(false);
        }
    }

    private IEnumerable<PlayerItemMessage> GetRemovedInventoryItems()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            yield break;
        
        using var set = PooledHashSet<PlayerItemMessage>.Get();
        set.AddRange(inventory);
        
        foreach (var itemMessage in myBoardPlayer.GetFlatInventories())
        {
            set.Remove(itemMessage);
        }
        
        //remove inventory to holdItems case
        foreach (var itemMessage in myBoardPlayer.HoldItems)
        {
            set.Remove(itemMessage);
        }
        
        foreach (var itemMessage in set)
        {
            inventory.Remove(itemMessage);
            yield return itemMessage;
        }
    }

    private IEnumerable<PlayerItemMessage> GetRemovedHoldItems()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            yield break;
        
        using var set = PooledHashSet<PlayerItemMessage>.Get();
        set.AddRange(holdInventory);
        
        foreach (var itemMessage in myBoardPlayer.HoldItems)
        {
            set.Remove(itemMessage);
        }
        
        //remove holdItems to inventory case
        foreach (var itemMessage in myBoardPlayer.GetFlatInventories())
        {
            set.Remove(itemMessage);
        }
        
        foreach (var itemMessage in set)
        {
            holdInventory.Remove(itemMessage);
            yield return itemMessage;
        }
    }

    public void SellItem(PlayerItemMessage item)
    {
        if (item == null)
            return;

        var index = int.MinValue;
        for (var i = 0; i < inventory.Count; i++)
        {
            if (inventory[i].Id == item.Id && cells.GetSafe(i).baseCell == cells.GetSafe(i))
            {
                index = i;
                break;
            }
        }

        if (index == int.MinValue)
        {
            for (var i = 0; i < holdInventory.Count; i++)
            {
                if (holdInventory[i].Id == item.Id)
                {
                    index = HoldIndexNumber + i;
                    break;
                }
            }
        }

        if (index == int.MinValue)
            return;

        var type = index >= HoldIndexNumber ? BoardPlayerInventoryTransferUpdate.Types.Type.Hold : BoardPlayerInventoryTransferUpdate.Types.Type.Inventory;
        var row = index >= HoldIndexNumber ? 0 : index / gridCellCountX;
        var col = index >= HoldIndexNumber ? index - HoldIndexNumber : index % gridCellCountX;

        GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(type, row, col,
            BoardPlayerInventoryTransferUpdate.Types.Type.Sell, -1, -2, MyPlayer.Player.Id);
        
        PlatformManager.Get().LogEvent("sellWeapon", value: item.DataId);
    }
    
    private void LockInventoryRefresh()
    {
        bLockInventoryRefresh = true;
    }
    
    private void UnlockInventoryRefresh(bool doRefresh = true)
    {
        bLockInventoryRefresh = false;
        
        if (doRefresh)
            RefreshInventory(true);
    }

    private bool bLockInventoryRefresh = false;
    
    [NonSerialized] public readonly List<DragDropObject_Inventory> holdItemDropObjects = new();
    
    [NonSerialized]
    public readonly List<PlayerItemMessage> inventory = new();
    private List<PlayerItemMessage> holdInventory = new();
    
    private readonly HashSet<InventoryItemImage> _refreshExcludeInventoryImages = new();
    private readonly Dictionary<long, float> _randomAngleByItemId = new();
    
    private HashSet<long> prevInventoryIdSet;
    private HashSet<long> prevHoldInventoryIdSet;

    private Coroutine _autoEquipSequence = null;
    private void RefreshInventory(bool rebuildHoldLayout, InventorySpawnEvent spawnEvent = null)
    {
        RefreshMapInventoryGrid();
        //DisappearAllRemovedItems();
        
        if (bLockInventoryRefresh)
            return;
        
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        //Init item containers
        inventory.Clear();
        inventory.AddRange(myBoardPlayer.GetFlatInventories());
        prevInventoryIdSet ??= new(inventory.Select(x => x.Id));
        
        using var newInventoryIdSet = PooledHashSet<long>.Get();
        foreach (var item in inventory)
        {
            if (!prevInventoryIdSet.Contains(item.Id))
                newInventoryIdSet.Add(item.Id);
        }
        
        prevInventoryIdSet.Clear();
        prevInventoryIdSet.AddRange(inventory.Select(x => x.Id));
        
        holdInventory.Clear();
        holdInventory.AddRange(myBoardPlayer.HoldItems);
        prevHoldInventoryIdSet ??= new(holdInventory.Select(x => x.Id));
        
        using var newHoldInventoryIdSet = PooledHashSet<long>.Get();
        foreach (var item in holdInventory)
        {
            if (!prevHoldInventoryIdSet.Contains(item.Id))
                newHoldInventoryIdSet.Add(item.Id);
        }
        
        prevHoldInventoryIdSet.Clear();
        prevHoldInventoryIdSet.AddRange(holdInventory.Select(x => x.Id));
        
        dragDropParent.onSwapIndex.RemoveAllListeners();
        dragDropParent.onSwapIndex.AddListener(OnSwapInventoryIndex);
        
        // dx dy 처리
        using var _ = ListPool<int>.Get(out var subCellIndexes);
        for (var i = 0; i < inventory.Count; i++)
        {
            var item = inventory[i];

            var resItem = item.GetData()!;

            if (resItem != null)
            {
                foreach (var inventoryCell in resItem.InventoryCells)
                {
                    var index = i + inventoryCell.Dx + inventoryCell.Dy * gridCellCountX;
                    if (index < 0 || index >= cells.Count)
                        continue;
                    
                    subCellIndexes.Add(index);
                }
            }
        }
        
        // holdItems마다 placeHolder cell 배치
        for (var i = 0; i < holdCells.Count; i++)
        {
            var holdCell = holdCells[i];
            
            var holdItem = holdInventory.GetSafe(i);
            if (holdItem == null || holdItem.Id == 0)
            {
                holdCell.Clear();
                holdCell.SetActive(false);
                continue;
            }
            
            holdCell.SetActive(true);
        }

        if (rebuildHoldLayout)
            LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)trHoldCellParent.transform);
        
        holdItemDropObjects.Clear();
        for (var i = 0; i < holdInventory.Count; i++)
        {
            var holdItem = holdInventory[i];
            var holdCell = holdCells[i];
            
            if (holdItem == null || holdItem.Id == 0)
                continue;

            holdCell.Refresh(HoldIndexNumber + i, holdItem, this, holdCell, true);

            if (!_refreshExcludeInventoryImages.Contains(holdCell.inventoryItemImage))
            {
                holdCell.inventoryItemImage.LimitScale(cellSize);

                //Do spawn sequence: 대기열로 가는 연출
                if (spawnEvent != null && newHoldInventoryIdSet.Contains(holdItem.Id))
                {
                    holdCell.inventoryItemImage.DoMoveToPath(summonPivotTransform.position, holdCell.GetCenterWorldPosition());
                }
                else
                {
                    holdCell.inventoryItemImage.DoMoveToPath(holdCell.GetCenterWorldPosition());
                }
            }
            
            if (!_randomAngleByItemId.TryGetValue(holdItem.Id, out var angle))
                angle = _randomAngleByItemId[holdItem.Id] = UnityEngine.Random.Range(-20f, 20f);
            holdCell.inventoryItemImage.imgItem.transform.localRotation = Quaternion.Euler(0, 0, angle);
            
            var itemImage = holdCell.inventoryItemImage;
            itemImage.EnableDragDrop();
            holdItemDropObjects.Add(itemImage.dragDropObject);
            itemImage.dragDropObject.parent = dragDropParent;
            itemImage.dragDropObject.index = HoldIndexNumber + i;
            itemImage.dragDropObject.dropOnly = false;
            itemImage.dragDropObject.originCell = holdCell;
            itemImage.dragDropObject.dragThreshHold = dragThreshHold;
            itemImage.dragDropObject.canDrag = (_) => true;
            
            // ddObj.canDrag = (ind) => myBoardPlayer.HoldItems.GetSafe(ind) is {Id: > 0};
        }
        
        dragDropParent.dragDropObjects.Clear();
        for (var i = 0; i < inventory.Count; i++)
        {
            var item = inventory[i];
            var cell = (MergeBoardCell)cells[i];
            
            if (subCellIndexes.Contains(i))
                continue;
            
            var resItem = item.GetData()!;
            
            var dragDropObject = cell.rtDragDropRoot.GetOrAdd<DragDropObject_Inventory>();
            dragDropObject.parent = dragDropParent;
            dragDropObject.index = i;
            dragDropObject.dropOnly = false;
            dragDropObject.originCell = cell;
            dragDropObject.dragThreshHold = dragThreshHold;
            dragDropObject.canDrag = (index) => inventory.GetSafe(index) is {Id: > 0} && cell.btnCell.IsInteractable();
            
            if (item != null && item.Id != -1)
                dragDropParent.dragDropObjects.Add(dragDropObject);

            cell.Refresh(i, item, this, cell);
            
            if (resItem != null)
            {
                cell.inventoryItemImage.DisableDragDrop();
                cell.inventoryItemImage.ClearTransform();
                
                if (!_refreshExcludeInventoryImages.Contains(cell.inventoryItemImage))
                {
                    //Do spawn sequence: 자동장착
                    if (spawnEvent != null && newInventoryIdSet.Contains(item.Id))
                    {
                        LockInventoryRefresh();
                        
                        var parent = cell.transform.parent;
                        var initPosition = summonPivotTransform.position;
                        // var midPoint = parent.InverseTransformPoint(summonMidwayPivotTransform.position);
                        var endPoint = cell.GetCenterWorldPosition();
                        
                        cell.inventoryItemImage.InitPosition(initPosition);
                        
                        var sequence = DOTween.Sequence();
                        sequence.Join(cell.inventoryItemImage.transform.DOMoveX(endPoint.x, 0.35f)
                            .SetEase(Ease.OutCubic));
                        sequence.Insert(0.05f,
                            cell.inventoryItemImage.transform.DOMoveY(endPoint.y, 0.35f).SetEase(Ease.InOutCubic));
                        sequence.OnComplete(() =>
                        {
                            cell.inventoryItemImage.InitPosition(endPoint);
                            UnlockInventoryRefresh();
                        });
                    }
                    else
                    {
                        cell.inventoryItemImage.DoMoveToPath(cell.GetCenterWorldPosition());
                    }
                }

                var baseCellIndex = new Vector2Int(i % gridCellCountX, i / gridCellCountX);
                foreach (var inventoryCell in resItem.InventoryCells)
                {
                    var index = i + inventoryCell.Dx + inventoryCell.Dy * gridCellCountX;
                    if (index < 0 || index >= cells.Count)
                        continue;
                    
                    var otherCell = (MergeBoardCell)cells[index];
                    otherCell.Refresh(index, item, this, cell);
                    
                    var ddObj = otherCell.rtDragDropRoot.GetOrAdd<DragDropObject_Inventory>();
                    ddObj.parent = dragDropParent;
                    dragDropParent.dragDropObjects.Add(ddObj);
                    ddObj.index = index;
                    ddObj.dropOnly = false;
                    ddObj.originCell = cell;
                    ddObj.dragThreshHold = dragThreshHold;
                    ddObj.canDrag = (ind) => inventory.GetSafe(ind) is {Id: > 0} && cell.btnCell.IsInteractable();
            
                    inventory[index] = item;
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
        
        foreach (var ddoForSell in sellDropObjects)
        {
            ddoForSell.parent = dragDropParent;
            dragDropParent.dragDropObjects.Add(ddoForSell);
            ddoForSell.index = SellIndexNumber;
            ddoForSell.dropOnly = true;    
        }

        using var adjacentInactiveCells = PooledList<(int row, int col)>.Get();
        GetAdjacentInactiveCells(adjacentInactiveCells);
        
        foreach (var (row, col) in adjacentInactiveCells)
        {
            var cell = GetInventoryCellByRowIndex(row, col);
            var ddObj = cell.GetOrAdd<DragDropObject_Inventory>();
            ddObj.parent = dragDropParent;
            dragDropParent.dragDropObjects.Add(ddObj);
            var index = GetIndexByRowIndex(row, col);
            ddObj.index = index;
            ddObj.dropOnly = true;
            ddObj.originCell = cell;
        }
    }

    private void OnSwapInventoryIndex(DragDropParent.SwapIndexEventParameter param)
    {
        var fromIndex = param.fromIndex;
        var toIndex = param.toIndex;

        Debug.Log($"[Hormon] onSwapIndex fromIndex: {fromIndex}, toIndex: {toIndex}");

        if (fromIndex < 0)
            return;

        var sourceType = fromIndex >= HoldIndexNumber ? BoardPlayerInventoryTransferUpdate.Types.Type.Hold : BoardPlayerInventoryTransferUpdate.Types.Type.Inventory;
        var targetType = toIndex >= HoldIndexNumber ? BoardPlayerInventoryTransferUpdate.Types.Type.Hold : BoardPlayerInventoryTransferUpdate.Types.Type.Inventory;

        var isSourceInventory = sourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory;
        var isTargetInventory = targetType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory;

        if (isSourceInventory && fromIndex >= inventory.Count)
            return;
        if (isTargetInventory && toIndex >= inventory.Count)
            return;

        fromIndex = isSourceInventory ? fromIndex : fromIndex - HoldIndexNumber;
        toIndex = isTargetInventory ? toIndex : toIndex - HoldIndexNumber;

        var sourceRow = isSourceInventory ? fromIndex / gridCellCountX : 0;
        var sourceIndex = isSourceInventory ? fromIndex % gridCellCountX : fromIndex;

        var sourceItem = isSourceInventory ? inventory[fromIndex] : holdInventory[fromIndex];
        var sourceCell = isSourceInventory ? cells.GetClamped(fromIndex) : holdCells.GetClamped(fromIndex);
        var resSourceItem = sourceItem.GetData();

        //제자리 클릭
        if (sourceType == targetType && fromIndex == toIndex)
        {
            if (resSourceItem?.ContainsTag(Tag.InventoryExpand) == true)
                PositionCells(m_MapInventoryGrid);

            if (param.dragPendingTime < 0.1f && !GameManager.Get().blockDisplayWeaponFloatingDropdown)
            {
                var worldBounds = sourceCell.baseCell.inventoryItemImage.rectTransform.GetWorldBounds();
                var inventoryItemImage = sourceCell.baseCell.inventoryItemImage;
                inventoryItemImage.transform.SetParent(rtHighlightedItemImageParent, true);
                _refreshExcludeInventoryImages.Add(inventoryItemImage);
                var popup = Popup_WeaponFloatingDropdown.Show(sourceItem, worldBounds.GetPointInBounds(new Vector2(0.5f, 0f)));
                popup.onHide.AddListener(() =>
                {
                    if (rtHighlightedItemImageParent == null)
                        return;

                    if (inventoryItemImage)
                    {
                        inventoryItemImage.transform.SetParent(sourceCell.transform.parent, true);
                        _refreshExcludeInventoryImages.Remove(inventoryItemImage);   
                    }
                    Refresh();
                });
            }

            Refresh();
            return;
        }

        //sell 
        if (toIndex == SellIndexNumber)
        {
            var fromCell = isSourceInventory ? cells.GetClamped(fromIndex) : holdCells.GetClamped(fromIndex);
            if (fromCell)
            {
                fromCell.ShowFill(false);
                var inventoryItemImage = fromCell.inventoryItemImage;
                if (inventoryItemImage)
                {
                    //inventoryItemImage.ShowBackground(false, false);
                    inventoryItemImage.imgCoolTimeFill.fillAmount = 0;
                    inventoryItemImage.SetActive(true);
                    inventoryItemImage.transform.position = new Vector3(param.dropWorldPosition.x, param.dropWorldPosition.y, inventoryItemImage.transform.position.z);
                }
            }

            // sell
            GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(sourceType, sourceRow, sourceIndex,
                BoardPlayerInventoryTransferUpdate.Types.Type.Sell, -1, -2, MyPlayer.Player.Id);
            return;
        }

        //빈 곳에 던지기
        if (toIndex < 0)
        {
            if (isSourceInventory)
            {
                // to hold
                GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(sourceType, sourceRow, sourceIndex,
                    BoardPlayerInventoryTransferUpdate.Types.Type.Hold, -1, -1, MyPlayer.Player.Id);
            }
            else if (resSourceItem?.ContainsTag(Tag.InventoryExpand) == true)
            {
                PositionCells(m_MapInventoryGrid);
            }
            else
            {
                Refresh();   
            }
            return;
        }

        var targetRow = isTargetInventory ? toIndex / gridCellCountX : 0;
        var targetIndex = isTargetInventory ? toIndex % gridCellCountX : toIndex;

        var targetItem = isTargetInventory ? inventory[toIndex] : holdInventory[toIndex];
        if (resSourceItem?.ContainsTag(Tag.InventoryExpand) == true)
        {
            if (targetItem.Id == -1)
            {
                // expand
                GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(sourceType, sourceRow, sourceIndex, BoardPlayerInventoryTransferUpdate.Types.Type.Discard, -1, -2, MyPlayer.Player.Id);
                GameBoardManager.Get().UpdateBoardPlayerInventoryExpand(targetRow, targetIndex, MyPlayer.Player.Id);
            }
            else
            {
                PositionCells(m_MapInventoryGrid);
            }

            return;
        }
        
        if (resSourceItem == null)
            return;

        var isMovable = true;

        if (isTargetInventory)
        {
            // sourceItem dx dy inventory bound 검사
            if (!IsValidIndex(targetRow, targetIndex))
                isMovable = false;
            else
            {
                foreach (var inventoryCell in resSourceItem.InventoryCells)
                {
                    var cellRow = targetRow + inventoryCell.Dy;
                    var cellIndex = targetIndex + inventoryCell.Dx;
                    if (!IsValidIndex(cellRow, cellIndex))
                    {
                        isMovable = false;
                        break;
                    }
                }
            }
        }

        if (isMovable)
            GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(sourceType, sourceRow, sourceIndex, targetType, targetRow, targetIndex, MyPlayer.Player.Id);
        else
        {
            if (!isSourceInventory)
                Refresh();
            else
                GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(sourceType, sourceRow, sourceIndex,
                    BoardPlayerInventoryTransferUpdate.Types.Type.Hold, -1, -1, MyPlayer.Player.Id);
        }
    }

    [Button]
    public void DoSummonAnimation()
    {
        //animatorForSummon.SetTrigger(AnimatorHash.Execution);
        //unitUIRendererForSummon.SetAnimation("Draw", false);
    }
    
    public void SetSellActivated(bool isActivated)
    {
        //trSellRoot.SetActive(isActivated);
        //btnSummon.SetActive(!isActivated);
        // goSellHamzziDeactivated.SetActive(!isActivated);
        // goSellHamzziActivated.SetActive(isActivated);
        
        // goRefreshHamzziActivated(isActivated);
        // goRefreshHamzziDeactivated(isActivated);
    }

    public void ShakeMergeableItems(ResourceItem floatingResItem)
    {
        if (ResourceItem.GetAllByParentId(floatingResItem.Id).Count == 0)
            return;

        foreach (var mergeBoardCell in cells)
        {
            if (mergeBoardCell.baseCell.playerItem == null || mergeBoardCell.baseCell.playerItem.Id == 0)
                continue;

            if (mergeBoardCell.baseCell.playerItem.ItemDataId == floatingResItem.Id)
            {
                if (mergeBoardCell.baseCell.inventoryItemImage)
                    mergeBoardCell.baseCell.inventoryItemImage.DoShake();
            }
        }
        
        foreach (var mergeBoardCell in holdCells)
        {
            if (mergeBoardCell.playerItem == null || mergeBoardCell.playerItem.Id == 0)
                continue;

            if (mergeBoardCell.playerItem.ItemDataId == floatingResItem.Id)
            {
                if (mergeBoardCell.baseCell.inventoryItemImage)
                    mergeBoardCell.baseCell.inventoryItemImage.DoShake();
            }
        }
    }

    protected void OnItemDragStarted()
    {
        RefreshButtons();
        //animatorForHoldingSell.SetTrigger(AnimatorHash.Start);
        //unitUIRendererForHoldingSell.SkeletonGraphic.AnimationState.SetAnimation(0, "Sell_Selected_Start", false);
        //unitUIRendererForHoldingSell.SkeletonGraphic.AnimationState.AddAnimation(0, "Sell_Selected_Loop", true, 0);
    }

    protected void OnItemDragEnded()
    {
        RefreshButtons();
        //animatorForHoldingSell.SetTrigger(AnimatorHash.End);
        //unitUIRendererForHoldingSell.SetAnimation("Sell_Selected_Done", false);
    }

    private void RefreshButtons()
    {
        var gameBoard = GameBoardManager.Get().gameBoard;
        if (gameBoard == null)
            return;
        
        var myBoardPlayer = gameBoard.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        var resMap = gameBoard.ResMap;
        if (resMap == null)
            return;

        var freeRollCount = (int)(MyPlayer.GameUnit?.Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.FreeRollCount) ?? FixedFloat.Zero);

        var blockUserInteraction = gameBoard.State > GameBoard.Types.State.Initialized && resMap.ContainsTag(Tag.BlockUserInteraction);
        var canSpawn = gameBoard.State != GameBoard.Types.State.Initialized || !blockUserInteraction;
        goSummon.SetActive(canSpawn && freeRollCount <= 0);
        goFreeSpawn.SetActive(canSpawn && freeRollCount > 0);
        goGameStart.SetActive(gameBoard.State == GameBoard.Types.State.Initialized);
        goForceBlock.SetActive(blockUserInteraction);
        txtForceBlock.text = resMap.GetLocalizedString($"BlockDescription_{gameBoard.State}");
        
        cgBoardRoot.interactable = !blockUserInteraction;
    }

    public void OnResetHoldEvent(InventoryResetHoldEvent resetHoldEvent)
    {
        RefreshButtons();
        DisappearAllRemovedItems();
    }

    public void DisappearAllRemovedItems(float duration = 0.15f, bool isSell = true)
    {
        foreach (var removedInventoryItem in GetRemovedInventoryItems())
        {
            var cell = cells.FirstOrDefault(x => x.playerItem?.Id == removedInventoryItem.Id);
            if (cell == null)
                continue;
            
            var inventoryItemImage = cell.inventoryItemImage;
            if (inventoryItemImage == null)
                continue;
            
            var obj = GameObjectPool.GetTransient(fxPung, Vector3.zero, Quaternion.identity, cgBoardRoot.transform);
            obj.transform.position = inventoryItemImage.transform.position;
            inventoryItemImage.Disappear(duration, isSell);
        }
        
        foreach (var removedHoldItem in GetRemovedHoldItems())
        {
            var cell = holdCells.FirstOrDefault(x => x.playerItem?.Id == removedHoldItem.Id);
            if (cell == null)
                continue;
            
            var inventoryItemImage = cell.inventoryItemImage;
            if (inventoryItemImage == null)
                continue;
            
            var obj = GameObjectPool.GetTransient(fxPung, Vector3.zero, Quaternion.identity, cgBoardRoot.transform);
            obj.transform.position = inventoryItemImage.transform.position;
            inventoryItemImage.Disappear(duration, isSell);
        }
        
        LockInventoryRefresh();
        this.Run(() =>
        {
            UnlockInventoryRefresh();
        }, duration + 0.1f);
    }
    
    public GameObject fxPung;
    public void OnMergeEvent(InventoryMergeEvent mergeEvent)
    {
        var sourceCell = GetCellByTypeRowIndex(mergeEvent.SourceType, mergeEvent.SourceRow, mergeEvent.SourceIndex);
        var targetCell = GetCellByTypeRowIndex(mergeEvent.TargetType, mergeEvent.TargetRow, mergeEvent.TargetIndex);
        
        var sourceInventoryItemImage = sourceCell.inventoryItemImage;
        if (sourceInventoryItemImage == null)
            return;
        
        sourceCell.inventoryItemImage = null;
        
        var targetInventoryItemImage = targetCell.inventoryItemImage;
        if (targetInventoryItemImage == null)
            return;
        
        var originalSourceCellPos = sourceCell.transform.localPosition;
        var originalSourceCellPosUnderTargetTransform = targetCell.transform.parent.InverseTransformPoint(sourceCell.transform.position);
        var originalTargetCellPos = targetCell.transform.localPosition;
        var originalTargetCellPosUnderSourceTransform = sourceCell.transform.parent.InverseTransformPoint(targetCell.transform.position);
        
        var midPointUnderTargetTransform = (originalSourceCellPosUnderTargetTransform +  originalTargetCellPos) / 2;
        midPointUnderTargetTransform.y += 30f;
        var midPointUnderSourceTransform = (originalTargetCellPosUnderSourceTransform + originalSourceCellPos) / 2;
        midPointUnderSourceTransform.y += 30f;
        AudioManager.Get().PlayFX("Levelup");
        sourceInventoryItemImage.SetSequence(seq =>
        {
            seq.Append(sourceInventoryItemImage.Fly(midPointUnderSourceTransform, 0.3f))
                .OnComplete(() =>
                {
                    sourceInventoryItemImage.Clear();
                    ReturnInventoryItemImage(sourceInventoryItemImage);
                });
        });

        var originalTargetImagePos = targetInventoryItemImage.transform.localPosition;
        targetInventoryItemImage.SetSequence(seq =>
        {
            seq.Append(targetInventoryItemImage.Fly(midPointUnderTargetTransform, 0.3f))
                .AppendCallback(() =>
                {
                    var obj = GameObjectPool.GetTransient(fxPung, Vector3.zero, Quaternion.identity, cgBoardRoot.transform);
                    obj.transform.position = targetInventoryItemImage.transform.position;
                    var newResItem = ResourceItem.Get(mergeEvent.NextItemDataId);
                    targetInventoryItemImage.Refresh(newResItem, MergeBoardCellBase.GetCenterAndSize(newResItem, cellSize).size, false);
                })
                .AppendInterval(0.2f)
                .Append(targetInventoryItemImage.Fly(originalTargetImagePos, 0.15f))
                .Append(targetInventoryItemImage.Stamp(Vector3.one, 0.3f))
                .OnComplete(() =>
                {
                    UnlockInventoryRefresh();
                });
        });
        PlatformManager.Get().LogEvent("mergeWeapon", value: mergeEvent.PrevItemDataId);
        LockInventoryRefresh();
    }
    
    public void OnMoveEvent(InventoryMoveEvent moveEvent)
    {
        if (moveEvent.TargetType is InventoryMoveEvent.InventoryType.Sell or InventoryMoveEvent.InventoryType.Discard)
        {
            var isSell = moveEvent.TargetIndex == -3;
            DisappearAllRemovedItems(isSell: moveEvent.TargetType == InventoryMoveEvent.InventoryType.Sell);
        }
        
        var sourceCell = GetCellByTypeRowIndex(moveEvent.SourceType, moveEvent.SourceRow, moveEvent.SourceIndex);
        if (sourceCell != null && sourceCell.baseCell != null && sourceCell.baseCell.playerItem != null && sourceCell.baseCell.playerItem.GetData()!.ContainsTag(Tag.InventoryExpand))
            PositionCells(m_MapInventoryGrid);
        
    }

    public void OnSpawnEvent(InventorySpawnEvent spawnEvent)
    {
        RefreshInventory(true, spawnEvent);
        RefreshInfos();
        PlatformManager.Get().LogEvent("spawnWeapon", value: spawnEvent.ItemDataId);


        if (spawnEvent.LuckApplied)
        {
            var spawnItem = ResourceItem.Get(spawnEvent.ItemDataId)!;
            
            var ps = particleLuckyEffects.GetClamped(CRC.Get().luckyEffectLevels[spawnItem.Rarity, spawnItem.Grade] - 1);
            ps.Stop();
            ps.Play();
        
            particleLuckySummonEffect.Stop();
            particleLuckySummonEffect.Play();
            
            AudioManager.Get().PlayFX("SFX_LuckyTrigger");
        }
    }

    public void RefreshInventoryBySpawn()
    {
    }
    
    public void OnExpandEvent(InventoryExpandEvent expandEvent)
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        RefreshMapInventoryGrid();
        PositionCells(m_MapInventoryGrid);
        PlatformManager.Get().LogEvent("expandInventory",
            ("Row", expandEvent.Row.ToString()),
            ("Index", expandEvent.Index.ToString())
        );
        AudioManager.Get().PlayFX("Item_Equip");
    }
    
    private bool[][] m_MapInventoryGridWithAdjacentInactiveCells = null;
    public void ShowAdjacentInactiveCells()
    {
        using var _ = ListPool<(int row, int col)>.Get(out var adjacentInactiveCells);
        GetAdjacentInactiveCells(adjacentInactiveCells);
        
        m_MapInventoryGridWithAdjacentInactiveCells ??= new bool[gridCellCountY][];
        for (var y = 0; y < gridCellCountY; y++)
        {
            m_MapInventoryGridWithAdjacentInactiveCells[y] ??= new bool[gridCellCountX];
            for (var x = 0; x < gridCellCountX; x++)
            {
                m_MapInventoryGridWithAdjacentInactiveCells[y][x] = false;
                m_MapInventoryGridWithAdjacentInactiveCells[y][x] = m_MapInventoryGrid[y][x];
            }
        }
        
        foreach (var (row, col) in adjacentInactiveCells)
        {
            if (row >= 0 && row < m_MapInventoryGridWithAdjacentInactiveCells.Length && col >= 0 && col < m_MapInventoryGridWithAdjacentInactiveCells[row].Length)
            {
                m_MapInventoryGridWithAdjacentInactiveCells[row][col] = true;
            }
        }
        
        PositionCells(m_MapInventoryGridWithAdjacentInactiveCells, doRefresh: false);
    }
    
    [Button]
    // public void ShowAdjacentInactiveCells()
    // {
    //     using var _ = ListPool<(int row, int col)>.Get(out var adjacentInactiveCells);
    //     GetAdjacentInactiveCells(adjacentInactiveCells);
    //     
    //     for (var i = 0; i < inventory.Count; i++)
    //     {
    //         var item = inventory[i];
    //         var cell = cells[i];
    //
    //         if (item != null && item.Id != -1)
    //         {
    //             cell.imgBg.color = Color.gray;
    //             // cell.GetOrAdd<DragDropObject_Inventory>().enabled = false;
    //         }
    //     }
    //     
    //     // TODO: 나이스한 연출 추가
    //
    //     foreach (var (row, col) in adjacentInactiveCells)
    //     {
    //         var cell = GetInventoryCellByRowIndex(row, col);
    //         cell.SetActive(true);
    //         cell.imgBg.color = Color.white;
    //         var ddObj = cell.GetOrAdd<DragDropObject_Inventory>();
    //         ddObj.parent = dragDropParent;
    //         dragDropParent.dragDropObjects.Add(ddObj);
    //         var index = GetIndexByRowIndex(row, col);
    //         ddObj.index = index;
    //         ddObj.dropOnly = true;
    //         ddObj.originCell = cell;
    //     }
    // }
    //
    private void GetAdjacentInactiveCells(ICollection<(int row, int col)> adjacentInactiveCells)
    {
        for (var row = 0; row < gridCellCountY; row++)
        {
            for (var ind = 0; ind < gridCellCountX; ind++)
            {
                if (!m_MapInventoryGrid[row][ind])
                {
                    if (IsAdjacentToActiveCell(row, ind))
                    {
                        adjacentInactiveCells.Add((row, ind));
                    }
                }
            }
        }
    }
    
    private int[] dRow = { -1, 1, 0, 0 };
    private int[] dCol = { 0, 0, -1, 1 };
    private bool IsAdjacentToActiveCell(int row, int col)
    {
        for (var i = 0; i < 4; i++)
        {
            var newRow = row + dRow[i];
            var newCol = col + dCol[i];

            if (newRow >= 0 && newRow < gridCellCountY && newCol >= 0 && newCol < gridCellCountX)
            {
                if (m_MapInventoryGrid[newRow][newCol])
                    return true;
            }
        }
        return false;
    }
    
    private void Update()
    {
        UpdateInventoryAutoSpawn();
    }

    public MergeBoardCell GetInventoryCellByRowIndex(int row, int index)
    {
        return (MergeBoardCell)cells[row * gridCellCountX + index];
    }
    
    public MergeBoardCell GetCellByTypeRowIndex(InventoryMergeEvent.InventoryType type, int row, int index)
    {
        return type == InventoryMergeEvent.InventoryType.Inventory ? GetInventoryCellByRowIndex(row, index) : holdCells[index];
    }
    
    public MergeBoardCell GetCellByTypeRowIndex(InventoryMoveEvent.InventoryType type, int row, int index)
    {
        return type == InventoryMoveEvent.InventoryType.Inventory ? GetInventoryCellByRowIndex(row, index) : holdCells[index];
    }
    
    public int GetIndexByRowIndex(int row, int index)
    {
        return row * gridCellCountX + index;
    }
    
    public bool IsValidIndex(int row, int index)
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard.GetPlayerById(MyPlayer.Player.Id)!;
        if (myBoardPlayer.Inventories.Count == 0)
            return false;

        var playerInventory = myBoardPlayer.Inventories[0];
        
        var notMovable = row < 0 || index < 0 || row >= playerInventory.Rows.Count || index >= playerInventory.Rows[row].Items.Count || playerInventory.Rows[row].Items[index].Id == -1;
        
        return !notMovable;
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        if (!enabled)
            return;

        switch (e.type)
        {
            case GameEventType.BoardItemDragStarted:
            {
                GameManager.Get().PlayFX("Default_Weapon_Drag_Start");
                OnItemDragStarted();
                break;
            }
            case GameEventType.BoardItemDragEnded:
            {
                GameManager.Get().PlayFX("Default_Weapon_Drop_End");
                OnItemDragEnded();
                break;
            }
            case GameEventType.BoardInventoryResetHold:
            {
                if (e.args.GetSafe(0) is not InventoryResetHoldEvent @event)
                    break;
                OnResetHoldEvent(@event);
                break;
            }
            case GameEventType.BoardInventorySpawned:
            {
                if (e.args.GetSafe(0) is not InventorySpawnEvent spawnEvent)
                    break;
                OnSpawnEvent(spawnEvent);
                break;
            }
            case GameEventType.BoardInventoryMerged:
            {
                if (e.args.GetSafe(0) is not InventoryMergeEvent mergeEvent)
                    break;
                OnMergeEvent(mergeEvent);
                break;
            }
            case GameEventType.BoardInventoryMoved:
            {
                if (e.args.GetSafe(0) is not InventoryMoveEvent moveEvent)
                    break;
                OnMoveEvent(moveEvent);
                break;
            }
            case GameEventType.BoardInventoryExpanded:
            {
                if (e.args.GetSafe(0) is not InventoryExpandEvent expandEvent)
                    break;
                OnExpandEvent(expandEvent); 
                break;
            }
            case GameEventType.MyBoardPlayerGoldUpdated:
            case GameEventType.MyUnitFreeRollCountUpdated:
            {
                RefreshSummonInfo();
                RefreshButtons();
                break;
            }
            case GameEventType.PopupShown:
            {
                if (e.args.GetSafe(0) is not Popup_WeaponFloatingDropdown weaponFloatingDropdown)
                    break;

                rtDim.SetActive(true);
                break;
            }
            case GameEventType.PopupHidden:
            {
                if (e.args.GetSafe(0) is not Popup_WeaponFloatingDropdown weaponFloatingDropdown)
                    break;

                rtDim.SetActive(false);
                break;
            }
            case GameEventType.GAMEBOARD_REPLACED:
            {
                RefreshInventory(true);
                break;
            }
            case GameEventType.BoardEventDispatched:
            {
                var boardEvent = e.args.GetSafe(0) as BoardEvent;
                if (boardEvent == null)
                    break;
                
                HandleBoardEventDispatched(boardEvent);

                if (boardEvent is 
                    InventoryExpandEvent or 
                    InventoryMergeEvent or 
                    InventoryMoveEvent or 
                    InventoryResetHoldEvent)
                {
                    Refresh();   
                }
                break;
            }
        }
    }
    
    private void HandleBoardEventDispatched(BoardEvent boardEvent)
    {
        var gameBoard = GameBoardManager.Get().gameBoard;
        var resMap = gameBoard?.ResMap;
        if (resMap == null)
            return;
        
        switch (boardEvent)
        {
            case BoardStateChangedEvent boardStateChangedEvent:
            {
                HandleBoardStateChanged(gameBoard.State);
                break;
            }
        }
    }
    
    private void HandleBoardStateChanged(GameBoard.Types.State state)
    {
        var resMap = GameBoardManager.Get().gameBoard?.ResMap;
        if (resMap == null)
            return;

        var doBlockInteraction = resMap.ContainsTag(Tag.BlockUserInteraction);
        switch (state)
        {
            case GameBoard.Types.State.Idle:
            {
                goPoliceLine.SetActive(false); 
                break;
            }
            case GameBoard.Types.State.Playing:
            {
                if (doBlockInteraction)
                {
                    goPoliceLine.SetActive(true);
                    animPoliceLine.PlayForward(this, AnimatorHash.Enter);
                }
                break;
            }
            case GameBoard.Types.State.WillEnded:
            {
                if (doBlockInteraction)
                {
                    animPoliceLine.PlayBackward(this, AnimatorHash.Enter, OnEnd: () =>
                    {
                        if (this)
                            goPoliceLine.SetActive(false);
                    });
                }
                break;
            }
        }
    }

    private void RefreshHoldCount()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;

        var holdItemCount = myBoardPlayer.HoldItems.Count(x => x.ItemDataId != 0);
        var maxHoldCount = GameBoardManager.Get().gameBoard?.ResMap.MaxHoldCount ?? 0;

        if (txtHoldCount)
        {
            txtHoldCount.text = $"{holdItemCount}/{maxHoldCount}";
            txtHoldCount.color = holdItemCount >= maxHoldCount ? Color.red : Color.white;   
        }
    }

    private long prevGold = long.MinValue;
    private void RefreshSummonInfo()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;
        var resMap = GameBoardManager.Get().gameBoard?.ResMap;
        if (resMap == null)
            return;

        rtPlayerHeldGold.SetActive(!resMap.ContainsTag(Tag.HideHeldGold));
        
        var gold = myBoardPlayer.Gold;
        var cumulativeSpawnCountWithoutReset = (int)MyPlayer.GameUnit.Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.CumulativeSpawnCountWithoutReset);
        var cumulativeFreeRollCount = (int)MyPlayer.GameUnit.Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.CumulativeFreeRollCount);
        var fixedSpawnPrice = (int)MyPlayer.GameUnit.Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.FixedSpawnPrice, -1);
        var spawnPrice = fixedSpawnPrice>=0 ? fixedSpawnPrice : resMap.SpawnPrices.GetClamped(cumulativeSpawnCountWithoutReset - cumulativeFreeRollCount);
        
        var freeRollCount = (int)MyPlayer.GameUnit.Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.FreeRollCount);

        var holdItemCount = myBoardPlayer.HoldItems.Count(x => x.ItemDataId != 0) + resMap.SpawnCount;
        var maxHoldCount = resMap.MaxHoldCount;

        var hasEnoughGold = gold >= spawnPrice;
        var hasFreeSpawn = freeRollCount > 0;
        
        using (var interactor = new ButtonInteractor(btnSummon))
        {
            interactor.Update(hasEnoughGold, "NotEnoughGold".L());
            interactor.Update(holdItemCount <= maxHoldCount, "HoldItemFull".L(maxHoldCount));
        }
        
        using (var interactor = new ButtonInteractor(btnFreeSpawn))
        {
            interactor.Update(hasFreeSpawn, "NotEnoughFreeSpawn".L());
            interactor.Update(holdItemCount <= maxHoldCount, "HoldItemFull".L(maxHoldCount));
        }

        var inGoldText = gold.ToString().ColorText(hasEnoughGold ? Color.white : CRC.Get().notEnoughColor);
        txtPlayerHandHoldGold.text = $"{ResourceItem.Get(ResourceItem.Global.DataId.Gold)!.ClientSpriteIconString}{inGoldText}/{spawnPrice}";
        txtFreeSpawn.text = "RemainFreeRollCount".L(freeRollCount);

        if (prevGold != long.MinValue && prevGold < gold)
            animPlayerHandHoldGoldIncrease.DORestart();
        prevGold = gold;
    }

    private static GamePrefs<bool> InventoryAutoSpawnEnabled = new(nameof(InventoryAutoSpawnEnabled), autoSave: true);

    private bool isAutoSpawnEnabled = false;
    private double nextAutoSpawnAvailableAt = 0;
    private void UpdateInventoryAutoSpawn()
    {
        if (!isAutoSpawnEnabled)
            return;

        imgAutoSpawnCoolTimeFill.fillAmount = 1f - (float)((nextAutoSpawnAvailableAt - TimeSystem.time) / CRC.Get().globalParameters.autoSpawnPeriod);
        
        if (GameBoardManager.Get().BoardPaused)
            return;
        
        if (!toggleAutoSpawn.isOn)
            return;
        
        if (!btnSummon.interactable && !btnFreeSpawn.interactable)
            return;

        if (nextAutoSpawnAvailableAt > TimeSystem.time)
            return;

        OnClickSpawn();
    }
}
