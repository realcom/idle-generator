using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using Random = UnityEngine.Random;

public enum UnitBehaviour
{
    None,
    Patrol,
    Assembled,
    Holden,
    Work,
    Battle,
    Invalid,
}

[CreateAssetMenu(fileName = "ClientBubbleTextDefine", menuName = "ClientBubbleTextDefine")]
public class ClientBubbleTextDefine : ClientScriptableSingleton<ClientBubbleTextDefine>
{
    public interface IBubbleSequence
    {
        public string RandomStringKey { get; set; }
        public float MinDuration { get; set; }
        public float MaxDuration { get; set; }
        public float Duration => Random.Range(MinDuration, MaxDuration);
    }
    
    [Serializable, HideReferenceObjectPicker]
    public class BehaviourBubbleSequence : IBubbleSequence
    {
        [field: SerializeField] public string RandomStringKey { get; set; }
        [field: SerializeField] public float MinDuration { get; set; }
        [field: SerializeField] public float MaxDuration { get; set; }
        
        //public string randomStringKey;
        [SerializeField] private float ProbPercent = 100f;
        [SerializeField] private float MinInitialDelay;
        [SerializeField] private float MaxInitialDelay;
        [SerializeField] private float MinPeriod = -1f;
        [SerializeField] private float MaxPeriod = -1f;
        
        public float InitialDelay => Random.Range(MinInitialDelay, MaxInitialDelay);
        public float Period => Random.Range(MinPeriod, MaxPeriod);
        public bool CheckProb() => Random.Range(0f, 100f) <= ProbPercent;
    }

    [Serializable]
    public class TransientBubbleSequence : IBubbleSequence
    {
        [field: SerializeField] public string RandomStringKey { get; set; }
        [field: SerializeField] public float MinDuration { get; set; }
        [field: SerializeField] public float MaxDuration { get; set; }
    }
    
    public Dictionary<UnitBehaviour, BehaviourBubbleSequence> BubbleSequenceByBehaviour = new();
    public TransientBubbleSequence OnAssembleRequestSuccess = new();
    public TransientBubbleSequence OnAssembleRequestFailed = new();


    protected override void OnLoaded()
    {
        
    }
}
