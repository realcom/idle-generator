using System.Text.Json;
using Server.Models;

namespace Server.Managers;

public static class WorldManager
{
    private static Dictionary<long, WorldModel> _worlds = new();

    public static async Task ReloadWorldModels()
    {
        _worlds.Clear();
        foreach (var worldModel in await WorldModel.GetAllAsync().ConfigureAwait(false))
        {
            _worlds[worldModel.id] = worldModel;
        }
    }
    public static WorldModel? GetWorldById(long worldId)
    {
        _worlds.TryGetValue(worldId, out var world);
        return world;
    }

    public static IEnumerable<WorldModel> GetAllWorlds() => _worlds.Values;
}