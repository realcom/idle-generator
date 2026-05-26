public static class CurrentBundleMarket
{
#if UNITY_ANDROID
	public const string market = "google";
#elif UNITY_IPHONE
	public const string market = Market.APPLE;
#else
	public const string market = Market.GOOGLE;
#endif

}

