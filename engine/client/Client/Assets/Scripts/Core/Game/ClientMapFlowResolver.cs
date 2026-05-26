using System;
using System.Globalization;
using Commons.Resources;

public static class ClientMapFlowResolver
{
    public const string ClientModeManagerPopupArg = "ClientModeManager";
    public const string ClientHomeMapDataIdPopupArg = "ClientHomeMapDataId";
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
}
