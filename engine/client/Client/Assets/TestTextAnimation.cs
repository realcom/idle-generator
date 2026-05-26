using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using TMPro;
using Febucci.UI;
using Febucci.UI.Core;
using Febucci.Attributes;
using JetBrains.Annotations;

public class TestTextAnimation : MonoBehaviour
{
    [SerializeField]
    private TextAnimator_TMP textAnimator;
    [SerializeField]
    private TypewriterByCharacter typewriter;

    [Button]
    private void VisibleText()
    {
        if (textAnimator == null) { return; }
        if (typewriter == null) { return; }

        typewriter.ShowText("1234" + Random.Range(1, 9));
        textAnimator.SetBehaviorsActive(false);
        typewriter.StartShowingText(true);
    }

    [Button]
    private void ChangeText_Up()
    {
        if (textAnimator == null) { return; }
        if (typewriter == null) { return; }

        textAnimator.SetText("<upOnce>1234" + Random.Range(1, 9));
        textAnimator.SetBehaviorsActive(true);
        textAnimator.time.RestartTime();
    }

    [Button]
    private void ChangeText_Down()
    {
        if (textAnimator == null) { return; }
        if (typewriter == null) { return; }

        textAnimator.SetText("<impact>1234" + Random.Range(1, 9));
        textAnimator.SetBehaviorsActive(true);
        textAnimator.time.RestartTime();
    }

    [Button]
    private void InvisibleText()
    {
        if (textAnimator == null) { return; }
        if (typewriter == null) { return; }
        textAnimator.SetBehaviorsActive(true);
        textAnimator.SetText("<impact>0");
        textAnimator.time.RestartTime();
        typewriter.StartDisappearingText();
    }
}
