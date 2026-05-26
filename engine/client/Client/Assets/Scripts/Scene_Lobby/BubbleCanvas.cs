using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Rendering;

public class BubbleCanvas : ZWorldUICanvas<BubbleCanvas, BubbleCanvasCell>
{
    public BubbleCanvasCell prefab;

    public Coroutine ShowBubble(GameUnitObject unit, string text, float duration = float.PositiveInfinity)
    {
        var Id = unit.gameUnit?.Id ?? -1;
        if (Id == -1)
            return null;

        if (!Items.TryGetValue(Id, out var cell))
        {
            cell = BehaviourPool<BubbleCanvasCell>.Get(prefab, Vector3.zero, Quaternion.identity, transform);
            Items[Id] = cell;
            cell.Initialize(unit);
        }

        return cell.ShowBubble(text, duration);
    }
    
    public void HideBubble(GameUnitObject unit)
    {
        var Id = unit.gameUnit?.Id ?? -1;
        if (Items.TryGetValue(Id, out var cell))
        {
            cell.HideBubble();
        }
    }

    protected override void Loop()
    {
        RemovableIds.Clear();
        ForceRemovableIds.Clear();

        using var cells = PooledList<WorldUICanvasCell>.Get();
        
        foreach (var (Id, cell) in Items)
        {
            if (cell == null)
            {
                ForceRemovableIds.Add(Id);
                continue;
            }
            
            var unit = GameBoardManager.Get().GetUnitByID(Id);
            if (cell.expired || unit == null || unit.unitSkin.trPanelBubble == null || unit.gameUnit == null)
            {
                RemovableIds.Add(Id);
                continue;
            }
            
            cell.rt.anchorMin = cell.rt.anchorMax = GetCellViewPoint(unit.unitSkin.trPanelBubble.position);
            cells.Add(cell);
        }
        
        foreach (var forceRemovableId in ForceRemovableIds)
            ForceRemoveItem(forceRemovableId);
        
        foreach (var id in RemovableIds)
        {
            RemoveItem(id, Items[id]);
        }
        
        cells.Sort((x, y) =>
        {
            var AxisY1 = (int)-x.rt.anchorMin.y * 10000000f;
            var AxisY2 = (int)-y.rt.anchorMin.y * 10000000f;
            return AxisY1.CompareTo(AxisY2);
        });

        foreach (var x in cells)
            x.rt.SetAsLastSibling();
    }

    protected override void ReleaseCell(BubbleCanvasCell cell)
    {
        BehaviourPool<BubbleCanvasCell>.Release(cell);
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        
    }
}
