using System;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using Commons.Resources;
using DG.Tweening;
using Sirenix.Utilities;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using Resources = UnityEngine.Resources;

public class GameScene : BaseScene<GameScene>
{
	public RectTransform rtSafeArea;
    public FollowTargetCamera followTargetCamera;

    
	// for reconnect
	
    public override void Awake()
    {
        base.Awake();
        
        followTargetCamera = camera.GetComponent<FollowTargetCamera>();
        
        if (!GameManager.Get().startSceneIsLogin)
        {
	        SceneManager.LoadScene(Constants.LOGIN_SCENE);
            return;
        }
    }

    private readonly Dictionary<Type, Queue<GameObject>> _popupPool = new();
    // public readonly HashSet<Type> PopupsToPreloadAndPool = new() { typeof(Popup_Inventory), typeof(Popup_Stats), typeof(Popup_PlayerLevelUp) };
    //public readonly HashSet<Type> PopupsToPreloadAndPool = new() { typeof(Popup_Inventory) };
    
    public void PreloadPopups(params Type[] popupTypes)
    {
	    //PopupsToPreloadAndPool.AddRange(popupTypes);
	    this.RunAfterFrame(() => { StartCoroutine(PreloadPopupsCoroutine(popupTypes)); });
    }
    private IEnumerator PreloadPopupsCoroutine(IEnumerable<Type> popupTypes)
    {
	    yield return null;

	    foreach (var typeId in popupTypes)
	    {
		    var request = Resources.LoadAsync<GameObject>($"Popups/{typeId}");
		    yield return request;

		    // skip preloading if this.GetPopup is called in advance
		    if (request.asset is GameObject popupPrefab && !_popupPool.ContainsKey(typeId))
		    {
			    _popupPool[typeId] = new Queue<GameObject>();

			    var parent = trPopup ? trPopup : transform;
			    var instance = Instantiate(popupPrefab, parent);
			    instance.SetActive(false);
			    _popupPool[typeId].Enqueue(instance);
			    yield return null;
		    }
	    }
    }

    public void ReturnPopup(Type popupType, GameObject instance)
    {
	    if (_popupPool.TryGetValue(popupType, out var value))
	    {
		    instance.SetActive(false);
		    value.Enqueue(instance);
	    }
	    else
		    Destroy(instance);
    }

    public GameObject GetPopup(Type popupType)
    {
	    if (_popupPool.ContainsKey(popupType) && _popupPool[popupType].Count > 0)
	    {
		    var instance = _popupPool[popupType].Dequeue();
		    instance.SetActive(true);
		    return instance;
	    }

	    var prefab = Resources.Load<GameObject>($"Popups/{popupType.Name}");
	    if (prefab != null)
	    {
		    var parent = trPopup ? trPopup : transform;
		    var instance = Instantiate(prefab, parent, false);

		    //if (PopupsToPreloadAndPool.Contains(popupType) && !_popupPool.ContainsKey(popupType))
		    //{
			//    _popupPool[popupType] = new Queue<GameObject>();
			//    _popupPool[popupType].Enqueue(instance);
		    //}

		    return instance;
	    }

	    return null;
    }
    
    public virtual void LateUpdate()
    {
	    //
		base.LateUpdate();
    }

    public override void Refresh()
    {
	    base.Refresh();
	    
    }
    
    public override void Start()
    {
        base.Start();
    }

    public override void Update()
    {
	    base.Update();
    }
}