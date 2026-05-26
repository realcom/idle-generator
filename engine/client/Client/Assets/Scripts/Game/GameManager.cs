using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using SimpleJSON;
using System.Linq;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Mopsicus.Plugins;
using UnityEditor;
using UnityEngine.AddressableAssets;
using UnityEngine.Pool;
using UnityEngine.ResourceManagement.AsyncOperations;
using Resources = UnityEngine.Resources;

public class GameFlag
{
    private Dictionary<string, bool> _flags = new Dictionary<string, bool>();
    private bool _value;
    private bool _isDirty;

    public void Set(string name, bool value)
    {
        _flags[name] = value;

        var oldValue = _value;
        if (value)
            _value = true;
        else
        {
            _value = false;

            foreach (var flagsValue in _flags.Values)
                _value |= flagsValue;
        }
        
        _isDirty |= oldValue != value;
    }

    public bool Get() => _value;

    public bool IsDirty() => _isDirty;

    public bool GetDirtyOutValue(out bool value)
    {
        value = _value;
        return _isDirty;
    }

    public void Clear()
    {
        _value = false;
        _isDirty = false;
        _flags.Clear();
    }

    public void ClearDirty() => _isDirty = false;
}

public abstract class TransientGamePrefs
{
    
}

public class TransientGamePrefs<T> : TransientGamePrefs where T : struct, IEquatable<T>
{
    private T _value;
    private readonly T _default;
    
    private readonly Action<T> _onValueChange;

    public TransientGamePrefs(T @default = default, Action<T> onValueChange = null)
    {
        _value = @default;
        _default = @default;
        _onValueChange = onValueChange;
    }

    public static implicit operator T(TransientGamePrefs<T> prefs)
    {
        return prefs._value;
    }
    
    public void Set(T newValue)
    {
        if (_value.Equals(newValue))
            return;
        
        _value = newValue;
        _onValueChange?.Invoke(newValue);
    }
    
    public void Clear()
    {
        _value = _default;
    }
    
    public void InvokeOnValueChanged()
    {
        _onValueChange?.Invoke(_value);
    }
}

public class GamePrefs<T> where T : struct, IEquatable<T>
{
    private bool _loaded;
    
    private readonly string _key;
    private T _value;
    private T _default;
    private readonly Action<T> _onValueChange;
    private readonly bool _autoSave;

    public GamePrefs(string key, T @default = default, bool autoLoad = false, bool autoSave = false,
        Action<T> onValueChange = null)
    {
        _key = key;
        _value = @default;
        _default = @default;
        _onValueChange = onValueChange;
        _autoSave = autoSave;
        
        if (autoLoad)
            Load();
    }

    public T Get()
    {
        if (!_loaded)
            Load();
        
        return _value;
    }

    public void Set(T newValue)
    {
        if (_value.Equals(newValue))
            return;
        _value = newValue;
        _onValueChange?.Invoke(newValue);
        
        if (_autoSave)
            Save();
    }

    public void Clear()
    {
        _loaded = false;
        _value = _default;
    }

    public void Load()
    {
        _loaded = true;

        if (!PlayerPrefs.HasKey(_key))
        {
            Set(_value);
            return;
        }
            
        if (typeof(T) == typeof(int))
            Set((T)(object)PlayerPrefs.GetInt(_key));
        else if (typeof(T) == typeof(float))
            Set((T)(object)PlayerPrefs.GetFloat(_key));
        else if (typeof(T) == typeof(bool))
            Set((T)(object)(PlayerPrefs.GetInt(_key) > 0));
        else if (typeof(T) == typeof(long))
            Set((T)(object)long.Parse(PlayerPrefs.GetString(_key)));
        
        _onValueChange?.Invoke(_value);
    }

    public void Save()
    {
        switch (_value)
        {
            case int value:
                PlayerPrefs.SetInt(_key, value);
                break;
            case float value:
                PlayerPrefs.SetFloat(_key, value);
                break;
            case bool value:
                PlayerPrefs.SetInt(_key, value ? 1 : 0);
                break;
            case long value:
                PlayerPrefs.SetString(_key, value.ToString());
                break;
        }
        
        PlayerPrefs.Save();
    }

    public void InvokeOnValueChanged()
    {
        _onValueChange?.Invoke(_value);
    }
}

public class GameListPrefs<T>
{
    private bool _loaded;
    
    private readonly string _key;
    private readonly Action _onValueChange;
    private readonly List<T> _value = new List<T>();
    private readonly bool _autoSave;
    
    public GameListPrefs(string key, bool autoSave = false, Action onValueChange = null)
    {
        _key = key;
        _onValueChange = onValueChange;
        _autoSave = autoSave;
    }

    private void Load()
    {
        var stored = PlayerPrefs.GetString(_key, "");
        if (string.IsNullOrEmpty(stored))
            return;
        
        var parsed = stored.Split(',').ToList();
        foreach (var s in parsed)
        {
            try
            {
                _value.Add((T)Convert.ChangeType(s, typeof(T)));
            }
            catch (Exception ex)
            {
                Debug.LogError($"GameListPrefs: {_key} {stored}");
                Debug.LogException(ex);
            }
        }
    }

    public List<T> Get()
    {
        if (!_loaded)
        {
            _loaded = true;
            Load();
        }
        
        return _value;
    }

    public void Save()
    {
        var s = "";
        foreach (var v in Get())
        {
            if (!string.IsNullOrEmpty(s))
                s += ",";
            s += v.ToString();
        }
        
        PlayerPrefs.SetString(_key, s);
        PlayerPrefs.Save();
        
        _onValueChange?.Invoke();
    }
    
    public bool Contains(T id)
    {
        return Get().Contains(id);
    }

    public int Count => Get().Count;

    public void Add(T id)
    {
        if (Contains(id))
            return;
            
        _value.Add(id);
        if (_autoSave)
            Save();
    }
    
    public void Remove(T id)
    {
        if (!Contains(id))
            return;
        
        _value.Remove(id);
        if (_autoSave)
            Save();
    }

    public void Clear()
    {
        Get().Clear();
        if (_autoSave)
            Save();
    }
}

public class GameDictionaryPrefs<TKey, TValue>
{
    private bool _loaded;
    
    private readonly string _key;
    private readonly Action _onValueChange;
    private readonly Dictionary<TKey, TValue> _value = new Dictionary<TKey, TValue>();
    private readonly bool _autoSave;
    
    public GameDictionaryPrefs(string key, bool autoSave = false, Action onValueChange = null)
    {
        _key = key;
        _onValueChange = onValueChange;
        _autoSave = autoSave;
    }

    private void Load()
    {
        var stored = PlayerPrefs.GetString(_key, "");
        if (string.IsNullOrEmpty(stored))
            return;
        
        var parsed = stored.Split(',').ToList();
        foreach (var s in parsed)
        {
            var tokens = s.Split('$');
            if (tokens.Length != 2)
                continue;
            
            try
            {
                var key = (TKey)Convert.ChangeType(tokens[0], typeof(TKey));
                var value = (TValue)Convert.ChangeType(tokens[1], typeof(TValue));
                _value[key] = value;
            }
            catch (Exception ex)
            {
                Debug.LogError($"GameDictionaryPrefs: {_key} {stored}");
                Debug.LogException(ex);
            }
        }
    }

    public Dictionary<TKey, TValue> Get()
    {
        if (!_loaded)
        {
            _loaded = true;
            Load();
        }
        
        return _value;
    }

    public void Save()
    {
        var s = "";
        foreach (var kv in Get())
        {
            if (!string.IsNullOrEmpty(s))
                s += ",";
            s += $"{kv.Key}${kv.Value}";
        }
        
        PlayerPrefs.SetString(_key, s);
        PlayerPrefs.Save();
        
        _onValueChange?.Invoke();
    }
    
    public bool Contains(TKey key)
    {
        return Get().ContainsKey(key);
    }

    public int Count => Get().Count;

    public void Add(TKey key, TValue value)
    {
        if (Contains(key))
            return;
            
        _value[key] = value;
        if (_autoSave)
            Save();
    }
    
    public void Remove(TKey key)
    {
        if (!Contains(key))
            return;
        
        _value.Remove(key);
        if (_autoSave)
            Save();
    }

    public void Clear()
    {
        Get().Clear();
        if (_autoSave)
            Save();
    }
}

public class GameHashSetPrefs<T>
{
    private bool _loaded;
    
    private readonly string _key;
    private readonly Action _onValueChange;
    private readonly HashSet<T> _value = new HashSet<T>();
    private readonly bool _autoSave;
    
    public GameHashSetPrefs(string key, bool autoSave = false, Action onValueChange = null)
    {
        _key = key;
        _onValueChange = onValueChange;
        _autoSave = autoSave;
    }

    private void Load()
    {
        var stored = PlayerPrefs.GetString(_key, "");
        if (string.IsNullOrEmpty(stored))
            return;
        
        var parsed = stored.Split(',').ToList();
        foreach (var s in parsed)
        {
            try
            {
                _value.Add((T)Convert.ChangeType(s, typeof(T)));
            }
            catch (Exception ex)
            {
                Debug.LogError($"GameHashSetPrefs: {_key} {stored}");
                Debug.LogException(ex);
            }
        }
    }

    public HashSet<T> Get()
    {
        if (!_loaded)
        {
            _loaded = true;
            Load();
        }
        
        return _value;
    }

    public void Save()
    {
        var s = "";
        foreach (var v in Get())
        {
            if (!string.IsNullOrEmpty(s))
                s += ",";
            s += v.ToString();
        }
        
        PlayerPrefs.SetString(_key, s);
        PlayerPrefs.Save();
        
        _onValueChange?.Invoke();
    }
    
	public bool Contains(T id)
	{
		return Get().Contains(id);
	}

    public int Count => Get().Count;

	public void Add(T id)
    {
        if (Contains(id))
            return;
            
        _value.Add(id);
        if (_autoSave)
            Save();
	}
    
	public void Remove(T id)
    {
        if (!Contains(id))
            return;
        
        _value.Remove(id);
        if (_autoSave)
            Save();
	}

    public void Clear()
    {
        Get().Clear();
        if (_autoSave)
            Save();
    }
}

public class GameManager : EventPublisher
{
    private static readonly GameManager _singleton = new GameManager();
    public static GameManager Get() { return _singleton; }

    //
    private readonly List<UIPopup> popups = new List<UIPopup>();
    private GameObject _loadingPopupPrefab;
    //	private Popup_NPCSystem _popupNPC;

    //
    public IScene scene = null;
    public bool startSceneIsLogin;
    
    private readonly Dictionary<string, TransientGamePrefs> _transientPrefs = new();

    public TransientGamePrefs<T> GetTransientPrefs<T>(string key, T _default = default) where T : struct, IEquatable<T>
    {
        if (_transientPrefs.TryGetValue(key, out var prefs))
            return prefs as TransientGamePrefs<T>;

        var newPrefs = new TransientGamePrefs<T>(_default);
        _transientPrefs[key] = newPrefs;
        return newPrefs;
    }
    
    //
    // private float _sensitivity = 0.5f;
    public readonly GamePrefs<float> bgmVolume = new("VolumeBGM", 1.0f, true, true, onValueChange:v =>
    {
        AudioManager.Get().OnBGMVolumeChanged(v);
    });
    public readonly GamePrefs<float> fxVolume = new("VolumeFX", 1.0f, true, true, onValueChange:v =>
    {
        AudioManager.Get().OnSFXVolumeChanged(v);
    });
    public readonly GamePrefs<bool> hapticEnabled = new("HapticEnabled", true, true, true);

    public readonly GamePrefs<long> prevPlayerID = new("PrevPlayerID", 0, false, true);
    
    public readonly GamePrefs<int> graphicQuality = new(Constants.Key.PLAYER_SETTINGS_GRAPHIC_QUALITY, QualitySettings.GetQualityLevel(), true, true, QualitySettings.SetQualityLevel);

    public bool blockDisplayWeaponFloatingDropdown = false;

    public enum DpadShowType
    {
        ALWAYS_SHOW,
        ALWAYS_HIDE,
        SHOW_WHEN_TOUCHED,
    }
    
    
    public bool keyboardVisible;
    public float keyboardHeight;
    //
    private GameManager()
    {
        MobileInput.OnShowKeyboard += OnShowKeyboard;

    }

    public static void OnCheatingDetected()
    {
    }

    public static void OnCheatingDetected(int appGuardCode)
    {
    }

    public static void OnCheatingDetected(bool appGuardAuthFailed)
    {
    }

    public static void OnInvalidScreenSizeDetected()
    {
    }

    public void ClearAllGamePrefs()
    {
        bgmVolume.Clear();
        fxVolume.Clear();
        prevPlayerID.Clear();
    }
	
    private void OnShowKeyboard(bool visible, int height)
    {
        keyboardVisible = visible;
        keyboardHeight = height;
        if (Screen.orientation == ScreenOrientation.Portrait && keyboardHeight > Screen.height * 0.6666f)
            keyboardHeight /= 2f;
    }
    
    public Vector3 ScreenToWorldPoint(Vector3 pos)
    {
        var camera = scene?.GetCamera() ?? Camera.main;
        pos.x = Mathf.Clamp(pos.x, -99999f, 99999f);
        pos.y = Mathf.Clamp(pos.y, -99999f, 99999f);
        pos.z = -camera.transform.position.z;
        return camera.ScreenToWorldPoint(pos);
    }

    public Vector3 GetMouseWorldPosition()
    {
        var mouseScreenPos = Input.mousePosition;
        return ScreenToWorldPoint(mouseScreenPos);
    }

    private Popup_Loading loadingPopup = null;
    public async UniTask<UIPopup> ShowLoading(string msg = null, bool forced = false)
    {
        if (scene == null && !forced)
            return null;

        if (loadingPopup)
            return loadingPopup;
        
        var parent = scene?.GetToastParent();

        loadingPopup = await GetOrShowPopupAsync<Popup_Loading>(parent);
        await loadingPopup.Initialize(msg ?? "Loading".L());

        return loadingPopup;
    }

    public async UniTask HideLoading()
    {
        if (loadingPopup)
            await loadingPopup.Deactivate();
    }
    
    private bool HandlePredefinedPopup(string id, string[] tokens)
    {
        var bottomButtonType = id switch
        {
            "Page_Shop_New" => ZModeManagerLobby.BottomButtonType.SHOP,
            nameof(Page_Shop) => ZModeManagerLobby.BottomButtonType.SHOP,
            nameof(Page_Ability) => ZModeManagerLobby.BottomButtonType.TRAIN,
            nameof(Page_Equipment) => ZModeManagerLobby.BottomButtonType.UNIT,
            _ => ZModeManagerLobby.BottomButtonType.NONE
        };

        if (bottomButtonType != ZModeManagerLobby.BottomButtonType.NONE)
        {
            var modeManagerLobby = ZModeManagerLobby.Get();
            if (modeManagerLobby != null)
            {
                modeManagerLobby.ClickBottomButton(bottomButtonType);
                modeManagerLobby.currentPage?.InitializeUsingToken(tokens);    
                return true;
            }
        }

        if (GameBoardManager.Get()?.modeManager is ModeManagerMushroom modeManagerMushroom)
            return modeManagerMushroom.TryOpenPredefinedPage(id, tokens);

        return false;
    }
    
    public async UniTask<T> ShowPopupToast<T>(string id) where T : Toast
    {
        return await ShowPopupAsync(id, scene.GetToastParent()) as T;
    }
    
    public T ShowPopup<T>(Transform parent = null) where T : UIPopup
    {
        return ShowPopup(typeof(T).Name, parent) as T;
    }
    
    public UIPopup ShowPopup(string id, Transform parent = null)
    {
        if (string.IsNullOrEmpty(id))
            return null;
        
        var tokens = id.Split(':');
        id = tokens[0];
        if (HandlePredefinedPopup(id, tokens.Length > 1 ? tokens[1..] : Array.Empty<string>()))
            return null;

        if (parent == null)
            parent = scene.GetPopupParent() ? scene.GetPopupParent() : scene.GetToastParent();
        
        scene.GraphicRaycaster.enabled = false;

        GameObject obj = null;
        
        try
        {
            obj = Addressables.InstantiateAsync(id, parent: parent).WaitForCompletion();
        }
        catch (Exception e)
        {
            Debug.LogWarning("Failed to ShowPopup({0})\n{1}".SFormat(id, e));
            return null;
        }
        finally
        {
            scene.GraphicRaycaster.enabled = true;
        }
        
        obj.name = id;
        
        try
        {
            var popup = ShowPopupInternal(obj);
            popup.InitializeUsingToken(tokens.Length > 1 ? tokens[1..] : Array.Empty<string>());

            return popup;
        }
        catch (Exception ex)
        {
            // transaction.Finish(ex);
            return null;
        }
        finally
        {
            // if (!transaction.IsFinished)
            //     transaction.Finish();
        }
    }
    
    public async UniTask<T> ShowPopupAsync<T>(Transform parent = null) where T : UIPopup
    {
        return await ShowPopupAsync(typeof(T).Name, parent) as T;
    }
    
    public async UniTask<UIPopup> ShowPopupAsync(string id, Transform parent = null)
    {
        if (string.IsNullOrEmpty(id))
            return null;
        
        var tokens = id.Split(':');
        id = tokens[0];
        if (HandlePredefinedPopup(id, tokens.Length > 1 ? tokens[1..] : Array.Empty<string>()))
            return null;

        if (parent == null)
            parent = scene.GetPopupParent() ? scene.GetPopupParent() : scene.GetToastParent();
        
        scene.GraphicRaycaster.enabled = false;

        GameObject obj = null;
        
        try
        {
            obj = await Addressables.InstantiateAsync(id, parent: parent);
        }
        catch (Exception e)
        {
            Debug.LogWarning("Failed to ShowPopup({0})\n{1}".SFormat(id, e));
            return null;
        }
        finally
        {
            scene.GraphicRaycaster.enabled = true;
        }
        
        obj.name = id;
        
        try
        {
            var popup = ShowPopupInternal(obj);
            popup.InitializeUsingToken(tokens.Length > 1 ? tokens[1..] : Array.Empty<string>());

            return popup;
        }
        catch (Exception ex)
        {
            // transaction.Finish(ex);
            return null;
        }
        finally
        {
            // if (!transaction.IsFinished)
            //     transaction.Finish();
        }
    }

    private UIPopup ShowPopupInternal(GameObject obj, Transform parent = null)
    {
        if (scene == null)
            return null;

        if (parent == null)
            parent = scene.GetPopupParent() ? scene.GetPopupParent() : scene.GetToastParent();

        //GameObject obj;
        // TODO: add handling for before-scene-lobby popups like toast
        // if (prefabType != null && prefabType != typeof(Popup_Toast))
        //obj = UnityEngine.Object.Instantiate(prefab, parent, false);

        var popup = obj.GetComponent<UIPopup>();

        popups.Add(popup);

        var idx = 0;
        popups.RemoveAll(x => x == null);
        popups.Sort((x, y) => x.priority.CompareTo(y.priority));
        foreach (var p in popups)
        {
            p.transform.SetSiblingIndex(idx++);
        }
        
        HandlePopupSiblingIndexChange();
        DispatchEvent(GameEventType.PopupShown, popup);

        return popup;
    }

    private UIPopup GetPopup(string id)
    {
        var tokens = id.Split(':');
        
        for (var i = 0; i < popups.Count; i++)
        {
            var popup = popups[i];
            if (popup && popup.name == id)
            {
                popup.transform.SetAsLastSibling();
                popup.InitializeUsingToken(tokens.Length > 1 ? tokens[1..] : Array.Empty<string>());
                
                popups.RemoveAt(i);
                popups.Add(popup);
                
                popup.SetActive(true);
                HandlePopupSiblingIndexChange();
                
                return popup;
            }
        }

        return null;
    }
    
    public UIPopup GetOrShowPopup(string id, Transform parent = null)
    {
        return GetPopup(id) ?? ShowPopup(id, parent);
    }
    
    public T GetOrShowPopup<T>(Transform parent = null) where T : UIPopup
    {
        return GetOrShowPopup(typeof(T).Name, parent) as T;
    }
    
    public async UniTask<UIPopup> GetOrShowPopupAsync(string id, Transform parent = null)
    {
        return GetPopup(id) ?? await ShowPopupAsync(id, parent);
    }
    
    public async UniTask<T> GetOrShowPopupAsync<T>(Transform parent = null) where T : UIPopup
    {
        return await GetOrShowPopupAsync(typeof(T).Name, parent) as T;
    }

    public bool ClearAllPopups()
    {
        var found = false;
        foreach (var popup in popups)
        {
            if (popup)
            {
                UnityEngine.Object.Destroy(popup.gameObject);
                found = true;
            }
        }
        
        popups.Clear();

        HandlePopupSiblingIndexChange();
        return found;
    }

    public bool HideAllPopups(string without = "")
    {
        var found = false;
        using var list = PooledList<UIPopup>.Get();
        list.AddRange(popups);
        
        LockHandlePopupSiblingIndexChange();

        foreach (var popup in list)
        {
            if (popup && popup.name != without)
            {
                popup.Hide();
                found = true;
            }
        }
        
        UnlockHandlePopupSiblingIndexChange();
        HandlePopupSiblingIndexChange();

        return found;
    }

    public bool HideAllPopups<T>(UIPopup without = null)
    {
        var found = false;
        using var list = PooledList<UIPopup>.Get();
        list.AddRange(popups);
        
        LockHandlePopupSiblingIndexChange();
        
        foreach (var popup in list)
        {
            if (popup && popup != without && popup is T)
            {
                popup.Hide();
                found = true;
            }
        }
        
        UnlockHandlePopupSiblingIndexChange();
        HandlePopupSiblingIndexChange();

        return found;
    }

    public bool BackPopup()
    {
        using var popups = PooledList<UIPopup>.Get();
        popups.AddRange(this.popups);
        foreach (var popup in popups)
        {
            if (popup)
            {
                if (popup.cancelable == false || popup.blockHide)
                    return true;

                popup.OnCancel();
                return true;
            }
        }

        return false;
    }

    public bool HasAnyPopup()
    {
        return HasPopup() || HasToastPopup();
    }

    public bool HasPopup()
    {
        return popups.Count > 0;
    }

    public bool HasToastPopup()
    {
        return scene.GetToastParent().childCount > 0;
    }

    public T GetPopup<T>() where T : UIPopup
    {
        for (var i = 0; i < popups.Count; ++i)
        {
            if ((popups[i] as T) != null)
                return popups[i] as T;
        }

        return null;
    }

    public PooledList<T> GetPopups<T>() where T : UIPopup
    {
        var foundPopups = PooledList<T>.Get();
        for (var i = 0; i < popups.Count; ++i)
        {
            if (popups[i] as T != null)
                foundPopups.Add(popups[i] as T);
        }

        if (foundPopups.Count == 0)
        {
            foundPopups.Dispose();
            return null;
        }
        
        return foundPopups;
    }
    //	public Popup_NPCSystem ShowNPCSystem() {
    //		if(_popupNPC)
    //			return _popupNPC;
    //
    //		_popupNPC = ShowPopup("Popup_NPCSystem") as Popup_NPCSystem;
    //		return _popupNPC;
    //	}
    //
    //	public void HideNPCSystem() {
    //		if(!_popupNPC)
    //			return;
    //
    //		_popupNPC.Hide ();
    //		_popupNPC = null;
    //	}

    public void HandlePopupRemoved(UIPopup popup)
    {
        popups.Remove(popup);
    }

    public bool HidePopup()
    {
        foreach (var popup in popups)
        {
            if (popup != null && popup.cancelable)
            {
                popup.Hide();
                return true;
            }
        }

        return false;
    }

    public int GetActivationChildPopupCount(Transform parent)
    {
        return m_ActivationChildPopupCount.GetValueOrDefault(parent);
    }

    private bool m_LockHandlePopupSiblingIndexChange = false;
    
    public void LockHandlePopupSiblingIndexChange()
    {
        m_LockHandlePopupSiblingIndexChange = true;
    }
    
    public void UnlockHandlePopupSiblingIndexChange()
    {
        m_LockHandlePopupSiblingIndexChange = false;
    }
    
    private readonly Dictionary<Transform, int> m_ActivationChildPopupCount = new();
    public void HandlePopupSiblingIndexChange()
    {
        if (m_LockHandlePopupSiblingIndexChange)
            return;
        
        popups.RemoveAll(x => x == null);
        m_ActivationChildPopupCount.Clear();

        using var _ = HashSetPool<Transform>.Get(out var parentSet);
        
        foreach (var popup in popups)
        {
            if (popup.backgroundDimTransform == null || popup.transform.parent == null)
                continue;
            
            parentSet.Add(popup.transform.parent);
        }
        
        foreach (var parentTransform in parentSet)
        {
            var childCount = parentTransform.childCount;
            for (var i = 0; i < childCount; i++)
            {
                var child = parentTransform.GetChild(i);
                if (child.gameObject.activeSelf == false)
                    continue;
                
                var popup = child.GetComponent<UIPopup>();
                if (popup == null)
                    continue;

                if (popup.backgroundDimTransform == null)
                    continue;

                var before = m_ActivationChildPopupCount.GetValueOrDefault(parentTransform, 0);
                popup.activationSiblingIndex = before;
                m_ActivationChildPopupCount[parentTransform] = before + 1;
            }
        }
        
        foreach (var popup in popups)
        {
            popup.OnSiblingIndexChanged();
        }
    }
    
    public void HandleSceneAwake(IScene scene)
    {
        if (scene is LoginScene)
            startSceneIsLogin = true;
        this.scene = scene;

        _loadedFXs.Clear();
        LazyLoad.UnloadAll();
        Resources.UnloadUnusedAssets();
        GC.Collect();
        GC.WaitForPendingFinalizers();
    }
    
    public void HandleSceneStart(IScene scene)
    {
        bgmVolume.InvokeOnValueChanged();
        fxVolume.InvokeOnValueChanged();
    }
    
    public void HandleSceneLeft(IScene scene)
    {
        if (this.scene == scene)
        {
            this.scene = null;
        }
    }
    
    public static bool HandleCommonStatus(StatusCode status, string message = null, bool showCenterLabel = true, bool verbose = true)
    {
        if (string.IsNullOrEmpty(message) && !status.IsSuccess())
            message = ResourceString.Get(status, ResourceEntity.Language);

        if (!string.IsNullOrEmpty(message))
        {
            if (verbose)
            {
                if (showCenterLabel)
                {
                    message.ToToastFromRaw();
                }
                else
                {
                    Popup_Alert.Show()
                        .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                        .SetDesc(message);    
                }
            }
        }

        return status.IsSuccess();
    }

    public string GetSNSID()
    {
        return PlayerPrefs.GetString(Constants.Key.SNS_ID);
    }

    public string GetLoginToken()
    {
        return PlayerPrefs.GetString("LOGIN_TOKEN"); // Constants.Keys.LOGIN_TOKEN);
    }

    public void SavePushToken(string token)
    {
        if (string.IsNullOrEmpty(token))
            return;

        PlayerPrefs.SetString(Constants.Key.PUSH_TOKEN, token);
        PlayerPrefs.Save();
    }
    
    public ResourceItem GetSeasonItem()
    {
        return ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Ranking)!.First(x => x.ContainsTag(Tag.Main));
    }

    public int GetSeasonDate()
    {
        return GetSeasonItem().GetRankingDate();
    }
    
    public void PlayMusic(string name)
    {
    //     if (AudioController.DoesInstanceExist() == false)
    //         return;
    //
    //     if (string.IsNullOrEmpty(name))
    //     {
    //         AudioController.StopMusic();
    //         return;
    //     }
    //
    //     var currentMusic = AudioController.GetCurrentMusic();
    //     var currentMusicName = currentMusic ? currentMusic.audioID : null;
    //     if (currentMusic == null || currentMusicName != name)
    //     {
    //         var obj = AudioController.PlayMusic(name);
    //         if (!obj)
    //         {
    //             AudioClip o;
    //             if (name.Contains("/"))
    //                 o = Utility.LoadResource<AudioClip>(name);
    //             else
    //                 o = Resources.Load<AudioClip>("Sounds/" + Path.GetFileNameWithoutExtension(name));
    //
    //             if (o)
    //             {
    //                 var item = AudioController.AddToCategory(AudioController.GetCategory("BGM"), o, name);
    //                 item.Loop = AudioItem.LoopMode.LoopSubitem;
    //                 var resAudio = ResourceAudio.Get(name);
    //                 if (resAudio != null)
    //                 {
    //                     item.Volume = resAudio.volume;
    //                     item.Delay = resAudio.delay;
    //                 }
    //
    //                 var path = resAudio?.path ?? name;
    //                 AudioController.PlayMusic(path);
    //             }
    //         }
    //
    //         if (!string.IsNullOrEmpty(currentMusicName) && currentMusicName.Contains("/"))
    //             AudioController.RemoveAudioItem(currentMusicName);
    //     }
    }

    private readonly HashSet<string> _loadedFXs = new HashSet<string>();

    internal void PlayFX(string name, Transform parent = null, Vector3? position = null)
    {
        AudioManager.Get().PlayFX(name, parent);
        // if (string.IsNullOrEmpty(name))
        //     return;
        //
        // //
        // var obj = parent ? AudioController.Play(name, parent, position) : AudioController.Play(name);
        //
        // if (!obj)
        // {
        //     if (_loadedFXs.Contains(name))
        //         return;
        //
        //     //
        //     _loadedFXs.Add(name);
        //     AudioClip o;
        //     if (name.Contains("/"))
        //         o = Utility.LoadResource<AudioClip>(name);
        //     else
        //         o = Resources.Load<AudioClip>("Sounds/" + Path.GetFileNameWithoutExtension(name));
        //
        //     if (o)
        //     {
        //         var item = AudioController.AddToCategory(AudioController.GetCategory("FX"), o, name);
        //         var resAudio = ResourceAudio.Get(name);
        //         if (resAudio != null)
        //         {
        //             if (resAudio.ContainsTag(Tag.LOOP))
        //                 item.Loop = AudioItem.LoopMode.LoopSubitem;
        //             item.Volume = resAudio.volume;
        //             item.Delay = resAudio.delay;
        //             item.MinTimeBetweenPlayCalls = resAudio.minTimeBetweenPlay;
        //             item.MaxInstanceCount = resAudio.maxInstantCount;
        //         }
        //         else
        //         {
        //             item.Volume = 1f;
        //             item.Delay = 0f;
        //             item.MinTimeBetweenPlayCalls = 0.1f;
        //             item.MaxInstanceCount = 4;
        //         }
        //
        //         var path = resAudio?.path ?? name;
        //         obj = parent ? AudioController.Play(path, parent, position) : AudioController.Play(path);
        //         Debug.Log($"Audio loaded: {name}");
        //     }
        // }
        //
        // if (!obj)
        //     Debug.LogError($"Unknown Audio: {name}");
    }

    public void PlayClick()
    {
        PlayFX("click");
    }
}
