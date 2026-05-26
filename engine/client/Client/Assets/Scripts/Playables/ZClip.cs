using System;
using System.Collections.Generic;
using Sirenix.Serialization;
using Sirenix.Serialization.Utilities;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class ZClip<BehaviourType> : PlayableAsset, ITimelineClipAsset, IZClip where BehaviourType : ZPlayableBehaviour, IPlayableBehaviour, new()
{
    public BehaviourType template = new();
    
    public virtual ClipCaps clipCaps => ClipCaps.None;

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        template.OnBeforeCreate(graph, owner);
        return ScriptPlayable<BehaviourType>.Create(graph, template);
    }

    public ZPlayableBehaviour GetTemplate()
    {
        return template;
    }
}

[Serializable]
public class ZSerializedClip<BehaviourType> : ZClip<BehaviourType>, ISerializationCallbackReceiver where BehaviourType : ZPlayableBehaviour, IPlayableBehaviour, new()
{
    [SerializeField]
    [HideInInspector]
    private SerializationData serializationData;
    
    void ISerializationCallbackReceiver.OnAfterDeserialize()
    {
        if (this != null)
        {
            using (var cachedContext = Cache<DeserializationContext>.Claim())
            {
                cachedContext.Value.Config.SerializationPolicy = SerializationPolicies.Everything;
                UnitySerializationUtility.DeserializeUnityObject(this, ref this.serializationData, cachedContext.Value);
            }
        }
    }

    void ISerializationCallbackReceiver.OnBeforeSerialize()
    {
        if (this != null)
        {
            using (var cachedContext = Cache<SerializationContext>.Claim())
            {
                cachedContext.Value.Config.SerializationPolicy = SerializationPolicies.Everything;
                UnitySerializationUtility.SerializeUnityObject(this, ref this.serializationData, serializeUnityFields: true, context: cachedContext.Value);
            }
        }
    }
}

[Serializable]
public class ZFxClip<BehaviourType, TFxSettings> : ZClip<BehaviourType>, IFxClip where BehaviourType : ZFxPlayableBehaviour<TFxSettings>, IPlayableBehaviour, new() where TFxSettings : FxSettings
{
    public delegate void PostRefreshCallback(TimelineClip clip);
    public virtual PostRefreshCallback postRefreshCallback { get; set; }
    
#if UNITY_EDITOR
    public virtual void RefreshFxSettings(string clipFxName, TimelineClip clip, ref Dictionary<string, FxSettings> settingsList)
    {
        if (template.fxSettings == null)
        {
            template.fxSettings = CreateInstance<TFxSettings>();
        }
        else if (template.fxSettings.name != clipFxName)
        {
            var newFxSettings = CreateInstance<TFxSettings>();
            FxSettings.CopyValuesWithName(template.fxSettings, newFxSettings, clipFxName);
            template.fxSettings = newFxSettings;
        }
        // else
        //     newFxSettings = template.fxSettings;
        
        // newFxSettings.MigrateValuesToProperties();
        
        postRefreshCallback?.Invoke(clip);
        
        settingsList[clipFxName] = template.fxSettings;
    }
#endif
}

[Serializable]
public class ZFxSerializedClip<BehaviourType, TFxSettings> : ZFxClip<BehaviourType, TFxSettings>, ISerializationCallbackReceiver where BehaviourType : ZFxPlayableBehaviour<TFxSettings>, IPlayableBehaviour, new() where TFxSettings : FxSettings
{
    [SerializeField]
    [HideInInspector]
    private SerializationData serializationData;
    
    void ISerializationCallbackReceiver.OnAfterDeserialize()
    {
        if (this != null)
        {
            using (var cachedContext = Cache<DeserializationContext>.Claim())
            {
                cachedContext.Value.Config.SerializationPolicy = SerializationPolicies.Everything;
                UnitySerializationUtility.DeserializeUnityObject(this, ref this.serializationData, cachedContext.Value);
            }
        }
    }

    void ISerializationCallbackReceiver.OnBeforeSerialize()
    {
        if (this != null)
        {
            using (var cachedContext = Cache<SerializationContext>.Claim())
            {
                cachedContext.Value.Config.SerializationPolicy = SerializationPolicies.Everything;
                UnitySerializationUtility.SerializeUnityObject(this, ref this.serializationData, serializeUnityFields: true, context: cachedContext.Value);
            }
        }
    }
}

public interface IZClip
{
    public ZPlayableBehaviour GetTemplate();
}

public interface IFxClip
{
#if UNITY_EDITOR
    public void RefreshFxSettings(string clipFxName, TimelineClip clip, ref Dictionary<string, FxSettings> settingsList);
#endif
}