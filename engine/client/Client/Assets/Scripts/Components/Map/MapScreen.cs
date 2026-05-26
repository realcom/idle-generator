using System.Collections.Generic;
using Commons.Game;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class MapScreen : ZEventBehaviour
{
    public class RuntimeBackgroundObject
    {
        public readonly GameObject backgroundObjectPrefab;
        public readonly List<GameObject> backgroundObjects = new();
        public readonly List<Vector3> backgroundLastDeltaWorldPositions = new();
        public readonly List<Vector3> backgroundPositions = new();
        
        public float scrollSpeedMultiplier { get; private set; }
        public float defaultScrollSpeed { get; private set; }
        
        //
        public float scrollSpeed;
        public int firstIndex;
        public int lastIndex => (firstIndex + backgroundObjects.Count - 1) % backgroundObjects.Count;
        
        public RuntimeBackgroundObject(float defaultScrollSpeed, float scrollSpeedMultiplier, GameObject backgroundObjectPrefab)
        {
            this.defaultScrollSpeed = defaultScrollSpeed;
            this.scrollSpeedMultiplier = scrollSpeedMultiplier;
            this.backgroundObjectPrefab = backgroundObjectPrefab;
        }
    }
    
    private List<RuntimeBackgroundObject> runtimeBackgroundObjects = new();
    
    public override void Awake()
    {
        base.Awake();
    }

    public override void Start()
    {
        base.Start();

        if (GameBoardManager.Get().modeManager == null)
            enabled = false;
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            {
                enabled = true;
                break;
            }
            case GameEventType.MAP_RELEASED:
            {
                enabled = false;
                break;
            }
        }
    }

    public void Initialize()
    {
        var mapRoot = GameBoardManager.Get()?.mapRoot;
        
        if (!mapRoot)
            return;
        
        foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
            runtimeBackgroundObject.backgroundObjects.ForEach(Destroy);
        runtimeBackgroundObjects.Clear();
        
        foreach (var bgData in mapRoot.backgroundData)
        {
            var bgObjectFirst = bgData.backgroundObject;
            if (bgObjectFirst == null)
                continue;

            runtimeBackgroundObjects.Add(new RuntimeBackgroundObject(bgData.defaultScrollSpeed, bgData.scrollSpeedMultiplier, bgObjectFirst));
        }
        
        foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
        {
            var prefab = runtimeBackgroundObject.backgroundObjectPrefab;
            
            var camBounds = GameScene.Get().GetCamera().GetWorldBoundOrthographic();
            //prefab.transform.localPosition = new Vector3(-camBounds.size.x + mapRoot.width / (2f * prefab.transform.parent.localScale.x), prefab.transform.localPosition.y, prefab.transform.localPosition.z);
            
            runtimeBackgroundObject.backgroundObjects.Clear();
            runtimeBackgroundObject.backgroundObjects.Add(prefab);
            runtimeBackgroundObject.backgroundPositions.Add(prefab.transform.localPosition);
            runtimeBackgroundObject.backgroundLastDeltaWorldPositions.Add(Vector3.zero);
            
            var cnt = 0;
            while (mapRoot.width * cnt <= camBounds.size.x)
            {
                cnt++;
                var duplicatedMapObject = Instantiate(prefab, prefab.transform.parent);
                duplicatedMapObject.transform.position = new Vector3(prefab.transform.position.x + mapRoot.width * cnt, prefab.transform.position.y, prefab.transform.position.z);
                runtimeBackgroundObject.backgroundObjects.Add(duplicatedMapObject);
                runtimeBackgroundObject.backgroundPositions.Add(duplicatedMapObject.transform.localPosition);
                runtimeBackgroundObject.backgroundLastDeltaWorldPositions.Add(Vector3.zero);
            }
        }
        
    }

    public void UpdateMapPosition()
    {
        var mapRoot = GameBoardManager.Get()?.mapRoot;
        if (!mapRoot)
            return;
       
        var cam = GameScene.Get().GetCamera();
        var posY = MyGameUnitObject.Get()?.gameUnit?.Position.Y ?? 0;

        //if (mapRoot.isOldMap)
        //{
        //    transform.position = new Vector3(cam.transform.position.x, posY - mapRoot.groundY, transform.position.z);
        //}
        //else
        //{
        //}
        transform.position = new Vector3(transform.position.x, posY - mapRoot.groundY, transform.position.z);
    }

    private bool _dirtyResetScroll = false;
    public void ResetScroll()
    {
        var mapRoot = GameBoardManager.Get()?.mapRoot;
        if (!mapRoot)
            return;

        if (mapRoot.resetScroll)
        {
            //Scroll 초기화
            foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
            {
                for (var i = 0; i < runtimeBackgroundObject.backgroundObjects.Count; i++)
                {
                    runtimeBackgroundObject.backgroundObjects[i].transform.localPosition = runtimeBackgroundObject.backgroundPositions[i];
                }

                runtimeBackgroundObject.firstIndex = 0;
            }
        }
        else
        {
            //Scroll 유지
            _dirtyResetScroll = true;   
        }
    }

    public void UpdateBackgroundScroll()
    {
        var myGameUnit = MyGameUnitObject.Get()?.gameUnit;
        if (myGameUnit != null)
        {
            if (!GameBoardManager.Get().BoardPaused && UnitSkin.HasState(myGameUnit.State, GameUnit.StateFlag.Running))
                SetScrollSpeed((float)myGameUnit.MoveSpeed);
            else
                SetScrollSpeed(0f);
        }
        else
            SetScrollSpeed(0f);

        Scroll();
    }

    private void LateUpdate()
    {
        UpdateMapPosition();
        UpdateBackgroundScroll();
    }

    public void SetScrollSpeed(float scrollSpeed)
    {
        foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
        {
            runtimeBackgroundObject.scrollSpeed = runtimeBackgroundObject.defaultScrollSpeed + scrollSpeed * runtimeBackgroundObject.scrollSpeedMultiplier;
        }
    }

    private void Scroll()
    {
        var mapRoot = GameBoardManager.Get()?.mapRoot;
        
        if (!mapRoot)
            return;
        
        var camBounds = GameScene.Get().GetCamera().GetWorldBoundOrthographic();
        
        if (_dirtyResetScroll)
        {
            _dirtyResetScroll = false;
            foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
            {
                for (var i = 0; i < runtimeBackgroundObject.backgroundObjects.Count; i++)
                {
                    var newPos = camBounds.center - runtimeBackgroundObject.backgroundLastDeltaWorldPositions[i];
                    var tr = runtimeBackgroundObject.backgroundObjects[i].transform;
                    tr.position = new Vector3(newPos.x, newPos.y, tr.position.z);
                }
            }

            return;
        }
        
        var boardUpdateTick = GameBoardManager.Get().BoardUpdateTick;
        var effectiveDeltaTime = Mathf.Min(Time.unscaledDeltaTime, boardUpdateTick);  
        foreach (var runtimeBackgroundObject in runtimeBackgroundObjects)
        {
            var scrollSpeed = runtimeBackgroundObject.scrollSpeed;
            for (var i = 0; i < runtimeBackgroundObject.backgroundObjects.Count; i++)
            {
                var backgroundObject = runtimeBackgroundObject.backgroundObjects[i];
                var tr = backgroundObject.transform;
                tr.localPosition -= new Vector3(scrollSpeed * effectiveDeltaTime, 0, 0);
            }

            // 위 로직에서 미리 포지션을 전체 업데이트 후 바운드 검사
            for (var i = 0; i < runtimeBackgroundObject.backgroundObjects.Count; i++)
            {
                var backgroundObject = runtimeBackgroundObject.backgroundObjects[i];
                var tr = backgroundObject.transform;

                var worldMaxX = tr.position.x + mapRoot.width / 2f;
                if (worldMaxX <= camBounds.min.x)
                {
                    var obj = runtimeBackgroundObject.backgroundObjects[runtimeBackgroundObject.lastIndex];
                    tr.position = new Vector3(obj.transform.position.x + mapRoot.width, tr.position.y, tr.position.z);
                    runtimeBackgroundObject.firstIndex = (runtimeBackgroundObject.firstIndex + 1) % runtimeBackgroundObject.backgroundObjects.Count;
                }

                var worldMinX = tr.position.x - mapRoot.width / 2f;
                if (worldMinX >= camBounds.max.x && scrollSpeed < 0f)
                {
                    var obj = runtimeBackgroundObject.backgroundObjects[runtimeBackgroundObject.firstIndex];
                    tr.position = new Vector3(obj.transform.position.x - mapRoot.width, tr.position.y, tr.position.z);
                    runtimeBackgroundObject.firstIndex = i;
                }
                
                runtimeBackgroundObject.backgroundLastDeltaWorldPositions[i] = camBounds.center - tr.position;
            }
        }
    }
    
}