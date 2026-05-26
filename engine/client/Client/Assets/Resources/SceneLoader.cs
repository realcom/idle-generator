using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Random = System.Random;
using Resources = UnityEngine.Resources;

public class SceneLoader : MonoBehaviour
{
    private static SceneLoader _singleton;

    public static SceneLoader Get()
    {
        if (!_singleton)
        {
            var prefab = Resources.Load<GameObject>("SceneLoader");
            var obj = Instantiate(prefab);
            DontDestroyOnLoad(obj);

            //
            _singleton = obj.Get<SceneLoader>();
        }

        return _singleton;
    }

    public CanvasGroup cg;
    public Image unitIcon;
    public TextMeshProUGUI txtLoading;
    public TextMeshProUGUI txtMap;
    public TextMeshProUGUI txtTip;
    public List<string> tips = new();

    private string loadSceneName;
    private Action onLoad = null;
    private bool loadInProgress = false;

    private bool _active = false;
    public void Refresh()
    {
        // txtMap.text = Old_ResourceMap.Get(Room.Get().troom.mapID).name;
        // txtTip.text = tips[Random.Range(0, tips.Count)];
    }
    
    private Coroutine _animCoroutine;
    public void SetActive(bool active, bool immediate = false)
    {
        if (_active == active) return;

        _active = active;
        cg.DOKill();

        if (active)
        {
            if (immediate)
            {
                cg.alpha = 1;
            }
            else
            {
                cg.alpha = 0;
                cg.DOFade(1, 0.5f);   
            }
            
            StopAnim();
            _animCoroutine = StartCoroutine(LoadingAnim());
        }
        else
        {
            if (immediate)
            {
                cg.alpha = 0;
            }
            else
            {
                cg.alpha = 1;
                cg.DOFade(0, 0.5f);    
            }
            
            StopAnim();
        }
    }
    
    private void StopAnim()
    {
        if (_animCoroutine != null)
            StopCoroutine(_animCoroutine);
    }
    
    public IEnumerator LoadingAnim()
    {
        var rnd = new Random();
        while (true)
        {
            txtLoading.text = "Loading.";
            //UpdateIcon(rnd);
            yield return Utility.GetWaitForSeconds(500);
            txtLoading.text = "Loading..";
            //UpdateIcon(rnd);
            yield return Utility.GetWaitForSeconds(500);
            txtLoading.text = "Loading...";
            //UpdateIcon(rnd);
            yield return Utility.GetWaitForSeconds(500);
        }
        
        void UpdateIcon(Random random)
        {
            var units = ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Unit);
            var unit = units[random.Next(0, units.Count)];
            unitIcon.sprite = unit.ClientSpriteIcon;
        }
    }

    public void LoadScene(string sceneName, Action onLoad = null, bool forced = false)
    {
        if (loadInProgress)
            return;
        if (!forced && SceneManager.GetSceneByName(sceneName).IsValid())
            return;
        Debug.Log($"Load {sceneName}");

        loadInProgress = true;

        //
        this.onLoad = onLoad;

        Refresh();
        
        //
        SetActive(true);
        this.Run(() =>
        {
            StartCoroutine(Load());
        }, 1f);
        
        //
        SceneManager.sceneLoaded += LoadSceneEnd;
        loadSceneName = sceneName;

        // 중복 패킷처리 방지
        ZWorldClient.Get().GatherPackets();
        // EdgeClient.Get().GatherPackets();
    }

    private IEnumerator Load()
    {
        AsyncOperation async = SceneManager.LoadSceneAsync(loadSceneName);

        while (!async.isDone)
        {
#if UNITY_EDITOR
            Debug.Log($"Load {loadSceneName} - {(int)(async.progress * 100)}%");
#endif
            yield return null;
        }

        try
        {
            UnityEngine.EventSystems.
                EventSystem.current.SetSelectedGameObject(null);
        }
        catch (Exception) { }
    }

    private void LoadSceneEnd(Scene scene, LoadSceneMode loadSceneMode)
    {
        if (scene.name != loadSceneName) return;

        loadInProgress = false;

        //
        onLoad?.Invoke();
        onLoad = null;
        SceneManager.sceneLoaded -= LoadSceneEnd;
    }
}
