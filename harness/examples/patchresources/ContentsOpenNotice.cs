using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

[CreateAssetMenu(fileName = nameof(ContentsOpenNotice), menuName = nameof(ContentsOpenNotice))]
public class ContentsOpenNotice : ClientScriptableSingleton<ContentsOpenNotice>
{
    [Serializable, HideReferenceObjectPicker]
    public class Parameter
    {
        public int contentsOpenAchievementDataId;
        public string contentsNameKey;
        public Sprite contentsIcon;
        
    }

    public Parameter[] parameters = new Parameter[0];

    protected override void OnLoaded()
    {
        
    }
}
