
using System;

namespace Components
{
    public enum AdType
    {
        Banner,
        Interstitial,
        Rewarded,
    }

    public interface IAdsManager
    {
        void Initialize();
        void ShowRewardedAd(int productDataId, string productName, Action success, Action failed = null);
    }
}
