using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public abstract class LazyLoad
{
    protected static readonly List<LazyLoad> _loadedInstances = new List<LazyLoad>();

    public static void UnloadAll()
    {
        foreach (var instance in _loadedInstances)
            instance.Unload();
        _loadedInstances.Clear();
    }
	
    public abstract void Unload();
}

public class LazyLoad<T> : LazyLoad where T : Object
{
    private string _name;
    private string _fallbackName;
    private bool _loaded;
    private T _obj;

    public string name => _name;

    public LazyLoad(string name, string fallbackName = null)
    {
        _name = name;
        _fallbackName = fallbackName;
    }

    public T Get()
    {
        if(_loaded)
            return _obj;
        _loaded = true;

        if (string.IsNullOrEmpty(_name))
            return _obj = null;
		
        _obj = Utility.LoadResource<T>(_name);
        if (!_obj)
            _obj = Utility.LoadResource<T>(_fallbackName);

        _loadedInstances.Add(this);
		
        return _obj;
    }

    public override void Unload()
    {
        _loaded = false;
        _obj = null;
    }

    public static implicit operator T(LazyLoad<T> obj)
    {
        return obj?.Get();
    }

    public static implicit operator bool(LazyLoad<T> obj)
    {
        return !ReferenceEquals(obj, null) && obj.Get();
    }
}