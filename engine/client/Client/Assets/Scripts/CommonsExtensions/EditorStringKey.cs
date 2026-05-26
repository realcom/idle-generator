using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Sirenix.OdinInspector;
using UnityEngine;

[InlineProperty]
[Serializable]
public struct EditorStringKey
{
    [
        ShowInInspector,
        HideLabel,
        ValueDropdown("GetKeys", DropdownTitle = "Select Key", OnlyChangeValueOnConfirm = true),
        OnValueChanged("OnValueChanged_Key")
    ]
    [field: SerializeField, HideInInspector]
    public string name { get; private set; }
    [field: SerializeField, HideInInspector]
    public int hash { get; private set; }
    
#if UNITY_EDITOR
    public IEnumerable GetKeys()
    {
        return ResourceString.GetEditorStringKeys().Select(x => x.name);
    }

    private void OnValueChanged_Key()
    {
        var key = this;
        hash = ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.name == key.name)!.hash;
    }
    
    public static implicit operator EditorStringKey(int hash)
    {
        return ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.hash == hash);
    }
#endif
    
    public EditorStringKey(string name, int hash)
    {
        this.name = name;
        this.hash = hash;
    }

    public static implicit operator string(EditorStringKey key)
    {
        return key.name;
    }

    public static implicit operator int(EditorStringKey key)
    {
        return key.hash;
    }

    public override string ToString()
    {
        return name;
    }
}

public abstract class EditorKeyParent
{
    [
        ShowInInspector,
        HideLabel,
        ValueDropdown("GetKeys", DropdownTitle = "Select Key", OnlyChangeValueOnConfirm = true),
        OnValueChanged("OnValueChanged_Key")
    ]
    [field: SerializeField, HideInInspector]
    public string name { get; protected set; }

    [field: SerializeField, HideInInspector]
    public int key { get; set; }

#if UNITY_EDITOR
    public abstract IEnumerable GetKeys();
    protected abstract void OnValueChanged_Key();
#endif
    
    public static implicit operator string(EditorKeyParent key)
    {
        return key.name;
    }

    public static implicit operator int(EditorKeyParent key)
    {
        return key.key;
    }

    public override string ToString()
    {
        return name;
    }
}

[InlineProperty]
[Serializable]
public class PredefinedLocationId : EditorKeyParent
{
#if UNITY_EDITOR
    public override IEnumerable GetKeys()
    {
        return typeof(ResourceMap.LocationId).GetFields().Select(x => x.Name).Where(n => !n.StartsWith("Player") || n == "Player");
    }
        
    protected override void OnValueChanged_Key()
    {
        key = (int)typeof(ResourceMap.LocationId).GetField(name).GetValue(null);
    }
#endif
    
}

[InlineProperty]
[Serializable]
public class KeyLocationId : EditorKeyParent
{
#if UNITY_EDITOR
    public override IEnumerable GetKeys()
    {
        return ResourceString.GetEditorStringKeys().Where(x => x.name.Contains("Location")).Select(x => x.name);
    }

    protected override void OnValueChanged_Key()
    {
        var thisKey = this;
        key = ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.name == thisKey.name)!.hash;
    }
#endif
    
}

[InlineProperty]
[Serializable]
public class DamageKey : EditorKeyParent
{
#if UNITY_EDITOR
    public override IEnumerable GetKeys()
    {
        return ResourceString.GetEditorStringKeys().Where(x => x.name.Contains("TIMELINE_DAMAGE")).Select(x => x.name);
    }

    protected override void OnValueChanged_Key()
    {
        var thisKey = this;
        key = ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.name == thisKey.name)!.hash;
    }
#endif
    
}

[InlineProperty]
[Serializable]
public class HealKey : EditorKeyParent
{
#if UNITY_EDITOR
    public override IEnumerable GetKeys()
    {
        return ResourceString.GetEditorStringKeys().Where(x => x.name.Contains("TIMELINE_HEAL")).Select(x => x.name);
    }

    protected override void OnValueChanged_Key()
    {
        var thisKey = this;
        key = ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.name == thisKey.name)!.hash;
    }
#endif
    
}

[InlineProperty, Serializable]
public abstract class GenericEditorStringKey : EditorKeyParent
{
    protected abstract string keyIdentifier { get; }

#if UNITY_EDITOR
    public override IEnumerable GetKeys()
    {
        if (string.IsNullOrEmpty(keyIdentifier))
            return Enumerable.Empty<string>();
        
        return ResourceString.GetEditorStringKeys().Where(x => x.name.Contains(keyIdentifier)).Select(x => x.name);
    }

    protected override void OnValueChanged_Key()
    {
        var thisKey = this;
        key = ResourceString.GetEditorStringKeys().FirstOrDefault(x => x.name == thisKey.name)!.hash;
    }
#endif
}

[InlineProperty, Serializable]
public class AddDamageKey : GenericEditorStringKey
{
    protected override string keyIdentifier => "TIMELINE_DAMAGE";
}

[InlineProperty, Serializable]
public class AddHealKey : GenericEditorStringKey
{
    protected override string keyIdentifier => "TIMELINE_HEAL";
}

[InlineProperty, Serializable]
public class SenderAddHealKey : GenericEditorStringKey
{
    protected override string keyIdentifier => "TIMELINE_SENDER_HEAL";
}