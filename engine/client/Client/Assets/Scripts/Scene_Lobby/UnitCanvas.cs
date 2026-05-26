using Commons.Resources;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;

public class UnitCanvas : ZWorldUICanvas<UnitCanvas, UnitCanvasCell>
{
    [FormerlySerializedAs("defaultUnitCanvasCell")] [SerializeField] private UnitCanvasCell prefabDefaultUnitCanvasCell;
    [FormerlySerializedAs("playerUnitCanvasCell")] [SerializeField] private UnitCanvasCell prefabPlayerUnitCanvasCell;

    protected virtual UnitCanvasCell GetCellPrefab(GameUnitObject unit)
    {
        if (unit.ResUnit.Type == ResourceUnit.Types.Type.Player)
            return BehaviourPool<UnitCanvasCell>.Get(prefabPlayerUnitCanvasCell, Vector3.zero, Quaternion.identity, transform);
        
        return BehaviourPool<UnitCanvasCell>.Get(prefabDefaultUnitCanvasCell, Vector3.zero, Quaternion.identity, transform);
    }

    protected override void Loop()
    {
        using var cells = PooledList<WorldUICanvasCell>.Get();
        
        foreach (var (Id, cell) in Items)
        {
            if (cell == null)
            {
                ForceRemovableIds.Add(Id);
                continue;
            }
            
            var unit = GameBoardManager.Get().GetUnitByID(Id);
            if (unit == null)
            {
                RemovableIds.Add(Id);
                continue;
            }

            UpdateCellPos(unit.unitSkin.trPanelStatus.position, cell);
            cells.Add(cell);
        }
        
        foreach (var forceRemovableId in ForceRemovableIds)
            ForceRemoveItem(forceRemovableId);
        
        foreach (var id in RemovableIds)
        {
            if (Items.TryGetValue(id, out var cell))
                RemoveItem(id, cell);
        }

        ForceRemovableIds.Clear();
        RemovableIds.Clear();
        
        cells.Sort((x, y) =>
        {
            var AxisY1 = (int)-x.rt.anchorMin.y * 10000000f;
            var AxisY2 = (int)-y.rt.anchorMin.y * 10000000f;
            return AxisY1.CompareTo(AxisY2);
        });
        
        foreach (var x in cells)
            x.rt.SetAsLastSibling();
    }

    protected override GameEventType[] GameEventTypes => new[]
    {
        GameEventType.UnitCreated,
        GameEventType.UnitDestroyed,
    };

    public override async UniTask HandleEvent(GameEvent e)
    {
        var unit = e.args.GetSafe(0) as GameUnitObject;
        if (unit == null)
            return;
        
        switch (e.type)
        {
            case GameEventType.UnitCreated:
            {
                var gameBoardManager = GameBoardManager.Get();
                var mapType = gameBoardManager.gameBoard?.ResMap.Type;

                if (!unit.unitSkin.trPanelStatus)
                    break;
                if (unit.ResUnit.ContainsTag(Tag.HideUnitCanvas))
                    break;
                
                if (mapType == ResourceMap.Types.Type.Lobby)
                    break;
                
                if (!Items.TryGetValue(unit.syncId, out var cell))
                {
                    cell = GetCellPrefab(unit);
                    Items[unit.syncId] = cell;
                    cell.Initialize(unit);
                }

                UpdateCellPos(unit.unitSkin.trPanelStatus.position, cell);

                GameManager.Get().DispatchEvent(GameEventType.UnitCanvasCreated, unit);
                break;
            }
            case GameEventType.UnitDestroyed:
            {
                RemovableIds.Add(unit.syncId);
                break;
            }
        }
    }

    private void UpdateCellPos(Vector3 worldPos, UnitCanvasCell cell)
    {
        cell.rt.anchorMin = cell.rt.anchorMax = GetCellViewPoint(worldPos);
    }

    protected override void ReleaseCell(UnitCanvasCell cell)
    {
        switch (cell)
        {
            case LobbyUnitCanvasCell:
                BehaviourPool<UnitCanvasCell>.Release(cell);
                break;
            default:
                BehaviourPool<UnitCanvasCell>.Release(cell);
                break;
        }   
    }
}
