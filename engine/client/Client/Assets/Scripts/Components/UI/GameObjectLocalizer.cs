using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameObjectLocalizer : MonoBehaviour
{
    [Serializable]
    public class GameObjectByLanguage
    {
        public SystemLanguage language;
        public GameObject gameObject;
    }
    
    public GameObjectByLanguage[] objects;
    
    public void Start()
    {
        if (objects == null || objects.Length == 0)
            return;

        foreach (var l in objects)
            l.gameObject.SetActive(false);
        
        var language = PlatformManager.GetSystemLanguage();
        var obj = objects.FirstOrDefault(o => o.language == language);
        if (obj == null)
            objects[0].gameObject.SetActive(true);
        else
            obj.gameObject.SetActive(true);
    }
    
}
