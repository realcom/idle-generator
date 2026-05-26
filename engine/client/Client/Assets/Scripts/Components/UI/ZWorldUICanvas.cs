using UnityEngine;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;

public abstract class ZWorldUICanvas<T, U> : ZUIBehaviour, EventListener where T : ZWorldUICanvas<T, U> where U : MonoBehaviour
{
    public Canvas canvas;
    
    protected readonly HashSet<long> RemovableIds = new();
    protected readonly HashSet<long> ForceRemovableIds = new();
    protected readonly Dictionary<long, U> Items = new();
    
    private static T _instance;
    public static T Get() => _instance;

    protected virtual GameEventType[] GameEventTypes => new GameEventType[0];

    protected override void Awake()
    {
        base.Awake();
        
        _instance = this as T;

        GameManager.Get().AddGameEventListener(this, GameEventTypes);
        ZWorldClient.Get().AddGameEventListener(this, GameEventTypes);
    }

    protected override void OnDestroy()
    {
        Items.Clear();
        
        GameManager.Get().RemoveListener(this);
        ZWorldClient.Get().RemoveListener(this);
        
        _instance = null;
        
        base.OnDestroy();
    }

    protected override void Update()
    {
        base.Update();
        Loop();
    }

    protected abstract void Loop();

    protected Vector2 GetCellViewPoint(Vector3 worldPos)
    {
        var cam = GameScene.Get().GetCamera();
        var sp  = cam.WorldToScreenPoint(worldPos);   // 픽셀(전체 화면 좌표계)

        var point = new Vector2(sp.x / Screen.width, sp.y / Screen.height);
        return point;
    }

    protected void RemoveItem(long id, U cell)
    {
        Items.Remove(id);
        ReleaseCell(cell);
    }
    
    protected void ForceRemoveItem(long id)
    {
        Items.Remove(id);
    }
    
    protected abstract void ReleaseCell(U cell);

    public abstract UniTask HandleEvent(GameEvent e);
}