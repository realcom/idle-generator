using System;
using System.Collections.Generic;
using Commons.Game;
using Commons.Game.Events;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using UnityEngine;
#if UNITY_EDITOR
using Sirenix.OdinInspector.Editor;
using UnityEditor;
#endif

public abstract class FxSettings : SerializedScriptableObject
{
    public readonly struct FxContext
    {
        [CanBeNull] public readonly PlayFxEvent authorEvent;
        [CanBeNull] public readonly GameUnitObject fxApplyingUnitObject;
        [CanBeNull] public readonly GameSkill fxGeneratingSkill;
        
        public float fxSpeed => authorEvent?.Speed ?? 1f;

        public FxContext(PlayFxEvent authorEvent, GameUnitObject fxApplyingUnitObject = null, GameSkill fxGeneratingSkill = null)
        {
            this.authorEvent = authorEvent;
            this.fxApplyingUnitObject = fxApplyingUnitObject;
            this.fxGeneratingSkill = fxGeneratingSkill;
        }
        
        public static FxContext Empty => new(null);
    }
    
    public abstract void Apply(FxContext fxContext);
    
    
#if UNITY_EDITOR
    public static void CopyValuesWithName(FxSettings source, FxSettings destination, string name)
    {
        if (source.GetType() != destination.GetType())
        {
            EditorUtility.DisplayDialog("Type Mismatch", "The source and destination objects must be of the same type.", "OK");
            return;
        }

        var sourceSerializedObject = new SerializedObject(source);
        var destinationSerializedObject = new SerializedObject(destination);

        var sourceProperty = sourceSerializedObject.GetIterator();
        var destinationProperty = destinationSerializedObject.GetIterator();

        sourceProperty.NextVisible(true); // skip the script reference property
        destinationProperty.NextVisible(true); // skip the script reference property

        while (sourceProperty.NextVisible(false))
        {
            if (destinationProperty.NextVisible(false))
            {
                if (sourceProperty.name != "name")
                {
                    destinationProperty.serializedObject.CopyFromSerializedProperty(sourceProperty);
                }
            }
        }

        destination.name = name;

        destinationSerializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(destination);
    }

    // public virtual void MigrateValuesToProperties()
    // {
    // }
#endif
}

public abstract class FxSettingsProperties
{
    public enum EffectTriggerType
    {
        GLOBAL,
        LOCAL,
    }
    
    [BoxGroup("Settings")]
    [LabelText("Trigger Type")]
    public EffectTriggerType triggerType;

    public bool TryApply(FxSettings.FxContext context)
    {
        if (CanApply(context))
            Apply(context);

        return CanApply(context);
    }

    protected abstract void Apply(FxSettings.FxContext fxContext);

    protected virtual bool CanApply(FxSettings.FxContext fxContext)
    {
        var checkTriggerType = triggerType != EffectTriggerType.LOCAL || (fxContext.fxApplyingUnitObject && fxContext.fxApplyingUnitObject.isLocalPlayer);
        return checkTriggerType;
    }
}


#if UNITY_EDITOR
[CustomEditor(typeof(FxSettings), true), CanEditMultipleObjects]
public class FxSettingsEditor : OdinEditor
{
    public FxSettings sourceFxSettings;

    private bool showDetails = false;  // Tracks the toggle state

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        GUILayout.Space(40);

        GUILayout.Space(20);
        showDetails = EditorGUILayout.Foldout(showDetails, "FX 세팅 도우미", true);
        
        if (showDetails)
        {
            GUILayout.BeginHorizontal();

            var specificType = target.GetType();
            sourceFxSettings = EditorGUILayout.ObjectField("세팅 값 불러오기", sourceFxSettings, specificType, false) as FxSettings;

            if (GUILayout.Button("붙여넣기", GUILayout.Height(20), GUILayout.ExpandWidth(false)))
            {
                if (sourceFxSettings != null)
                {
                    FxSettings.CopyValuesWithName(sourceFxSettings, (FxSettings)target, sourceFxSettings.name);
                    EditorUtility.SetDirty(target);
                }
            }

            GUILayout.EndHorizontal();
        }

        GUILayout.Space(10);
    }
}
#endif