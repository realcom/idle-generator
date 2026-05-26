using System;
using UnityEngine;

namespace Components
{
    public static class AdManager
    {
        public static IAdsManager Instance { get; private set; }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        private static void Initialize()
        {
            var go = new GameObject("[AdManager]");
            GameObject.DontDestroyOnLoad(go);

            Instance = go.AddComponent<NoOpAdsManager>();
            
            Instance.Initialize();
        }
    }
}
