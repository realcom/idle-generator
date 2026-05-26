using System.Collections;
using System.Collections.Generic;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;
using UnityEngine;

public class LobbyGameUnitObject : GameUnitObject
{
    private PlayerItemMessage item => MyPlayer.GetItem(_cachedGameUnit.PlayerAvatar.Character.Id);
    public LobbyUnitCanvasCell lobbyUnitCanvasCell => unitCanvasCell as LobbyUnitCanvasCell;

    private int _cachedStamina = -1;
    public void UpdateStamina(PlayerItemMessage baseItem)
    {
        if (_cachedStamina == baseItem.Param1)
            return;
        _cachedStamina = baseItem.Param1;

        lobbyUnitCanvasCell.RefreshStamina((float)_cachedStamina / baseItem.GetData()!.GetMaxStamina());
    }

    public void StartWork()
    {
        lobbyUnitCanvasCell.ShowWorkStatus();
        UpdateStamina(item);
    }

    public void StopWork()
    {
        lobbyUnitCanvasCell.HideWorkStatus();
    }

    public override void HandleCreate(long poolId, long syncId, ResourceEntity resource)
    {
        base.HandleCreate(poolId, syncId, resource);
    }

    public override void HandleDestroy(bool pool = true)
    {
        base.HandleDestroy(pool);
    }
}
