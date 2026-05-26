using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class FieldToggle<T> : IEnumerable<T>
{
    private readonly T[] _toggles;
    private int current = 0;

    public FieldToggle(T t1, T t2)
    {
        _toggles = new[] { t1, t2 };
    }

    public T this[int idx] => _toggles.GetSafe(idx);
    
    public int Length => _toggles.Length;
    
    public void Toggle()
    {
        current = current == 0 ? 1 : 0;
    }

    public T Current => _toggles[current];
    public static implicit operator T(FieldToggle<T> field) => field.Current;
    public IEnumerator<T> GetEnumerator()
    {
        for (var i = 0; i < _toggles.Length; i++)
        {
            yield return _toggles[i];
        }
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
}