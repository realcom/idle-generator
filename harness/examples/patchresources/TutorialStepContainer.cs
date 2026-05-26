using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;


[CreateAssetMenu(fileName = "TutorialStepContainer", menuName = "TutorialStepContainer")]
public class TutorialStepContainer : ClientScriptableSingleton<TutorialStepContainer>
{
    [Serializable]
    public class TutorialStep
    {
        public string titleKey;
        public string descKey;
        public Sprite spritePhoto;
    }
    
    public List<TutorialStep> tutorialSteps = new();

    protected override void OnLoaded()
    {
        
    }
}
