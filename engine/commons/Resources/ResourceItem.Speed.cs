using System;
using System.Globalization;

namespace Commons.Resources
{
    public partial class ResourceItem
    {
        public const string GameSpeedMultiplierPopupArg = "GameSpeedMultiplier";
        public const float MinGameSpeedMultiplier = 1f;
        public const float MaxGameSpeedMultiplier = 8f;

        public float GetGameSpeedMultiplier()
        {
            return TryGetGameSpeedMultiplier(out var multiplier) ? multiplier : MinGameSpeedMultiplier;
        }

        public bool TryGetGameSpeedMultiplier(out float multiplier)
        {
            multiplier = MinGameSpeedMultiplier;
            if (!PopupArgs.TryGetValue(GameSpeedMultiplierPopupArg, out var rawValue) ||
                string.IsNullOrWhiteSpace(rawValue))
            {
                return false;
            }

            if (!float.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out var parsed))
                return false;

            multiplier = NormalizeGameSpeedMultiplier(parsed);
            return multiplier > MinGameSpeedMultiplier;
        }

        public static float NormalizeGameSpeedMultiplier(float multiplier)
        {
            if (float.IsNaN(multiplier) || float.IsInfinity(multiplier))
                return MinGameSpeedMultiplier;

            return Math.Max(MinGameSpeedMultiplier, Math.Min(MaxGameSpeedMultiplier, multiplier));
        }
    }
}
