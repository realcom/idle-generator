using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
using Object = UnityEngine.Object;

public abstract class ZMonoBehaviour : SerializedMonoBehaviour
{
    public new virtual bool enabled
    {
        get => base.enabled;
        set => base.enabled = value;
    }
    
    protected virtual void Awake()
    {
        CacheReferences(gameObject);
    }

    protected virtual void OnValidate()
    {
        
    }
    
    protected virtual void Reset()
    {
    }

    protected virtual void OnEnable()
    {
        
    }

    protected virtual void OnDisable()
    {
        
    }

    protected virtual void Start()
    {
    }

    protected virtual void Update()
    {
        
    }

    protected virtual void FixedUpdate()
    {
        
    }
    
    protected virtual void LateUpdate()
    {
        
    }

    public void CacheReferences(GameObject rootObj)
    {
        var type = GetType();
        foreach (var field in type.GetFields(BindingFlags.Instance | BindingFlags.Public))
        {
            if (!field.IsTarget())
                continue;

            if (field.GetValue(this) != null)
                continue;

            field.SetValue(this, this.GetReference(field, rootObj));
        }

        do
        {
            foreach (var field in type.GetFields(BindingFlags.Instance | BindingFlags.NonPublic))
            {
                if (!field.IsTarget())
                    continue;
                
                if (field.GetValue(this) != null)
                    continue;

                field.SetValue(this, this.GetReference(field, rootObj));
            }
        } while ((type = type.BaseType) != null);
    }
    
    public void OnPrefabStageOpened(GameObject obj)
    {
        CacheReferences(obj);
    }

    public void OnSaving(GameObject obj)
    {
        CacheReferences(obj);
    }

    public void OnSaved(GameObject obj)
    {
        var type = GetType();
        foreach (var field in type.GetFields(BindingFlags.Instance | BindingFlags.Public))
        {
            if (!field.IsTarget())
                continue;

            if (field.GetValue(this) == null)
            {
                Debug.LogWarning($"{GetType().Name}::{name} is invalid.\n{field.Name} is null.");
            }
        }

        do
        {
            foreach (var field in type.GetFields(BindingFlags.Instance | BindingFlags.NonPublic))
            {
                if (!field.IsTarget())
                    continue;

                if (field.GetValue(this) == null)
                {
                    Debug.LogWarning($"{GetType().Name}::{name} is invalid.\n{field.Name} is null.");
                }
            }
        } while ((type = type.BaseType) != null);
    }

}

public static class ZMonoBehaviourExtensions
{
    public static bool IsTarget(this FieldInfo info)
    {
        if (!info.IsDefined(typeof(SerializeField)))
            return false;

        if (!info.FieldType.IsClass)
            return false;
        
        if (typeof(UnityEventBase).IsAssignableFrom(info.FieldType))
            return false;
        
        return true;
    }

    public static Object GetReference(this ZMonoBehaviour zMonoBehaviour, FieldInfo info, GameObject rootObj)
    {
        var type = info.FieldType;

        if (type == typeof(GameObject))
            return zMonoBehaviour.gameObject;
            
        return zMonoBehaviour.GetComponentInChildren(type) ?? rootObj.GetComponentInChildren(type);
    }
    
}