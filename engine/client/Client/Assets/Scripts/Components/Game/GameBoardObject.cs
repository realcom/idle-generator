using System;
using Commons.Game;
using Commons.Resources;
using UnityEngine;

public class GameBoardObject : MonoBehaviour
{
    [NonSerialized]
    public long syncId;
    protected ResourceEntity resource;

    protected long _poolId;
    
    public virtual void HandleCreate(long poolId, long syncId, ResourceEntity resource)
    {
        _poolId = poolId;

        this.syncId = syncId;
        this.resource = resource;
        clientPosition = transform.position;
    }

    public virtual void HandleUpdate(GameEntity gameEntity, float dt)
    {
        UpdateTransform(gameEntity.Position.X0Z(), gameEntity.Direction.X0Z(), gameEntity.Velocity.X0Z(), dt);
    }

    public virtual void HandleDestroy(bool pool = true)
    {
        if (pool)
            GameBoardManager.Get().ReturnToPool(_poolId, gameObject, 100);
        else
            Destroy(gameObject);
    }
    
    internal Vector3 clientPosition;
    private const float m_ExtrapolationLimit = 0.5f;
    
    protected virtual void UpdateTransform(Vector3 pos, Vector3 dir, Vector3 velocity, float timeDelta)
    {
        var now = Utility.GetTime();
        // var dt = Mathf.Clamp((float)( - _interpolationBackTime), -_interpolationBackTime, m_ExtrapolationLimit);
        var gameBoard = GameBoardManager.Get();
        var dt = Mathf.Clamp((float)((now - gameBoard.GetBoardLastUpdatedTime()) - gameBoard.BoardUpdateTick), -GameBoard.TickDuration, m_ExtrapolationLimit * Time.deltaTime);

        pos =  new Vector3(pos.x, pos.y, clientPosition.z);
        if (dt < 0f)
        {
            var distance = (clientPosition - pos).sqrMagnitude;
            if (distance > 4f)
                clientPosition = pos;
            else
                clientPosition = Vector3.Lerp(clientPosition, pos, timeDelta / (-dt + timeDelta));
        }
        else
            clientPosition = pos + (Vector3)velocity * dt;

        // TODO: find a better way to get height, best if it's internally done in unit itself
        //var posBeforeExtrapolation = dt > 0f ? pos : clientPosition; // ensure height finding is always done inside ground area
        //var height  = GameBoardManager.Get().gameBoard.ResMap.UnitTerrain.GetHeight(posBeforeExtrapolation.XZ());
        //if (!float.IsNaN(height))
        //    clientPosition.y = height;

        if (float.IsNaN(clientPosition.x))
            clientPosition.x = 0.0f;
        if (float.IsNaN(clientPosition.y))
            clientPosition.y = 0.0f;
        if (float.IsNaN(clientPosition.z))
            clientPosition.z = 0.0f;
        
    }

    protected virtual void Update()
    {
        transform.position = clientPosition;
    }
}
