using System;
using Commons.Game;
using Commons.Resources;
using JetBrains.Annotations;
using UnityEngine;

public class GameDropItemObject : GameBoardObject
{
    public ResourceItem ResItem => resource as ResourceItem;
    [CanBeNull] public GameDropItem gameDropItem => GameBoardManager.Get().gameBoard.GetDropItemById(syncId);
    
    private Vector3 m_InitPos;
    
    private long m_PickupUnitId = -1;

    public void Initialize(Vector3 initPos)
    {
        transform.position = initPos;
        transform.localScale = Vector3.one;
    }

    public override void HandleDestroy(bool pool = true)
    {
        base.HandleDestroy(pool);
    }

    public void HandleGetDropItem(long unitId)
    {
        m_PickupUnitId = unitId;
    }
}