using System;
using System.Globalization;
using Commons.Resources;

public static class ClientMapFlowResolver
{
    public const string ClientModeManagerPopupArg = "ClientModeManager";
    public const string ClientHomeMapDataIdPopupArg = "ClientHomeMapDataId";
    public const string ClientAutoAdvancePopupArg = "ClientAutoAdvance";
    public const string ClientNextMapDataIdPopupArg = "ClientNextMapDataId";
    public const string ClientRetryMapDataIdPopupArg = "ClientRetryMapDataId";
    public const string ClientLoopMapDataIdPopupArg = "ClientLoopMapDataId";
    public const string CurrentMapHomeValue = "self";

    public static string ResolveModeManagerAddressableKey(ResourceMap resMap)
    {
        if (TryGetPopupArg(resMap, ClientModeManagerPopupArg, out var modeManagerKey))
            return modeManagerKey;

        return resMap?.Type switch
        {
            ResourceMap.Types.Type.Lobby => "ModeManagerLobby",
            ResourceMap.Types.Type.ScenarioLobby => "ModeManagerLobby",
            _ => "ModeManagerBattle"
        };
    }

    public static ResourceMap ResolveHomeMap(ResourceMap currentMap)
    {
        if (currentMap == null)
            return null;

        if (TryGetPopupArgInt(currentMap, ClientHomeMapDataIdPopupArg, out var homeMapDataId) &&
            ResourceMap.Get(homeMapDataId) is { } homeMap)
        {
            return homeMap;
        }

        if (TryGetPopupArg(currentMap, ClientHomeMapDataIdPopupArg, out var homeMapToken) &&
            homeMapToken.Equals(CurrentMapHomeValue, StringComparison.OrdinalIgnoreCase))
        {
            return currentMap;
        }

        return ResourceMap.Get(currentMap.Id + 10000) ?? currentMap;
    }

    public static bool ShouldAutoAdvance(ResourceMap currentMap)
    {
        if (currentMap == null)
            return false;

        if (TryGetPopupArgBool(currentMap, ClientAutoAdvancePopupArg, out var explicitlyEnabled))
            return explicitlyEnabled;

        return currentMap.ContainsTag(Tag.InfiniteWaves);
    }

    public static ResourceMap ResolveAutoAdvanceMap(ResourceMap currentMap, bool playerWon)
    {
        if (currentMap == null)
            return null;

        if (!ShouldAutoAdvance(currentMap))
            return null;

        if (!playerWon)
        {
            return TryGetPopupArgMap(currentMap, ClientRetryMapDataIdPopupArg, out var retryMap)
                ? retryMap
                : currentMap;
        }

        if (TryGetPopupArgMap(currentMap, ClientNextMapDataIdPopupArg, out var nextMap))
            return nextMap;

        if (TryGetPopupArgMap(currentMap, ClientLoopMapDataIdPopupArg, out var loopMap))
            return loopMap;

        if (currentMap.ContainsTag(Tag.InfiniteWaves))
            return currentMap;

        return null;
    }

    private static bool TryGetPopupArg(ResourceMap resMap, string key, out string value)
    {
        value = string.Empty;

        if (resMap?.PopupArgs == null)
            return false;

        if (!resMap.PopupArgs.TryGetValue(key, out var rawValue))
            return false;

        if (string.IsNullOrWhiteSpace(rawValue))
            return false;

        value = rawValue.Trim();
        return true;
    }

    private static bool TryGetPopupArgInt(ResourceMap resMap, string key, out int value)
    {
        value = default;
        return TryGetPopupArg(resMap, key, out var rawValue) &&
               int.TryParse(rawValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out value);
    }

    private static bool TryGetPopupArgBool(ResourceMap resMap, string key, out bool value)
    {
        value = default;
        if (!TryGetPopupArg(resMap, key, out var rawValue))
            return false;

        if (bool.TryParse(rawValue, out value))
            return true;

        if (int.TryParse(rawValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out var intValue))
        {
            value = intValue != 0;
            return true;
        }

        switch (rawValue.ToLowerInvariant())
        {
            case "yes":
            case "y":
            case "on":
                value = true;
                return true;
            case "no":
            case "n":
            case "off":
                value = false;
                return true;
            default:
                return false;
        }
    }

    private static bool TryGetPopupArgMap(ResourceMap resMap, string key, out ResourceMap value)
    {
        value = null;
        if (!TryGetPopupArg(resMap, key, out var rawValue))
            return false;

        if (rawValue.Equals(CurrentMapHomeValue, StringComparison.OrdinalIgnoreCase))
        {
            value = resMap;
            return true;
        }

        if (!int.TryParse(rawValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out var mapDataId))
            return false;

        value = ResourceMap.Get(mapDataId);
        return value != null;
    }
}
