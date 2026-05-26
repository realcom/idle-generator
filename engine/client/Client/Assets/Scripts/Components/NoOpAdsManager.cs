using System;
using UnityEngine;

namespace Components
{
    /// <summary>
    /// Fallback ad implementation used when the production ad SDK is not present.
    /// </summary>
    public class NoOpAdsManager : MonoBehaviour, IAdsManager
    {
        public void Initialize()
        {
            Debug.LogWarning("[AdManager] Ad SDK is not installed. Rewarded ads will use the fallback implementation.");
        }

        public void ShowRewardedAd(int productDataId, string productName, Action success, Action failed = null)
        {
            Debug.LogWarning($"[AdManager] Rewarded ad requested for product {productDataId} ({productName}) without an installed ad SDK.");

            if (Application.isEditor)
            {
                success?.Invoke();
                return;
            }

            failed?.Invoke();
        }
    }
}
