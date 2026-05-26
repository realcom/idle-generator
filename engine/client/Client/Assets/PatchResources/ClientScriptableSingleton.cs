using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public abstract class ClientScriptableSingleton<T> : SerializedScriptableObject where T : ClientScriptableSingleton<T>
{
    private static T _singleton;
    public static T Get()
    {
        if (_singleton == null)
        {
            var resourceNameWithExtension = typeof(T).Name + ".asset";
            _singleton = Utility.LoadResource<T>(resourceNameWithExtension);
            _singleton.OnLoaded();
            DontDestroyOnLoad(_singleton);
        }

        return _singleton;
    }

    protected abstract void OnLoaded();

}
