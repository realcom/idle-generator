using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using DG.Tweening;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Pool;

public class MergeAltar : ZEventBehaviour
{
    public SpriteRenderer[] mergePoints = new SpriteRenderer[3];
    public Transform[] nearPoints = new Transform[0];

    public override void Start()
    {
        base.Start();

        mergePoints.ForEach(x => x.color = new Color(1, 1, 1, 0));
    }

    public int GetAvailableMergeIndex()
    {
        var list = ListPool<int>.Get();

        for (var i = 0; i < mergePoints.Length; i++)
        {
            if (mergeableUnitByIndex.GetValueOrDefault(i) != null)
                continue;

            var point = mergePoints[i];
            if (point == null)
                continue;

            list.Add(i);
        }

        var randomIndex = list.PickOne(_default: -1);

        ListPool<int>.Release(list);

        return randomIndex;
    }
    
    private Dictionary<int, InteractableUnitSkin> mergeableUnitByIndex = new();

    public bool RegisterToMergePoint(InteractableUnitSkin unit)
    {
        if (unit == null)
            return false;

        var index = GetAvailableMergeIndex();
        if (index == -1)
            return false;

        var point = mergePoints[index];
        mergeableUnitByIndex[index] = unit;
        point.DOFade(1f, 0.33f);

        if (unit.unit.gameUnit != null)
        {
            var position = point.transform.position;
            unit.unit.gameUnit.Position.X = position.x;
            unit.unit.gameUnit.Position.Y = position.y;
        }

        return true;
    }

    public Vector2? UnregisterUnit(InteractableUnitSkin unit)
    {
        var index = mergeableUnitByIndex.FirstOrDefault(x => x.Value == unit).Key;
        if (mergeableUnitByIndex.Remove(index))
        {
            var point = mergePoints[index];
            point.DOFade(0f, 0.1f);
            return nearPoints.PickOne().position;
        }

        return null;
    }

    public IEnumerable<Vector2> UnregisterAll()
    {
        var list = ListPool<Vector2>.Get();
        foreach (var tr in nearPoints.PickMany(mergeableUnitByIndex.Count))
        {
            list.Add(tr.position);
        }

        foreach (var pos in list)
        {
            yield return pos;
        }
        
        mergePoints.ForEach(x => x.DOFade(0f, 0.1f));
        
        mergeableUnitByIndex.Clear();
        ListPool<Vector2>.Release(list);
    }
    
    public void ClearRegisteredUnits()
    {
        mergeableUnitByIndex.Clear();
    }
    
}
