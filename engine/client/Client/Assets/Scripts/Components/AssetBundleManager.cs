using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SimpleJSON;
using System.Linq;
using Commons;
using UnityEngine.Networking;

public class AssetBundleRef
{
	public Constants.AssetBundleType assetBundleType;
	
	public string name => assetBundleType.ToString().ToCamelCase();
	public string fileName;
	public string md5;
    public ulong size;
    public bool required;
	public bool preload;
	
	//
	public AssetBundle assetBundle;

	public string path {
		get {
			return Path.Combine (AssetBundleManager.persistentDataPath, fileName);
		}
	}

	public void Unload() {
		if(assetBundle != null)
			assetBundle.Unload (true);
	}
	
	public string GetLocalMD5 ()
	{
		return PlayerPrefs.GetString(
			string.Format("AssetHash_{0}", Path.GetFileNameWithoutExtension(fileName)), "");
	}
	
	public void SetLocalMD5 (string md5)
	{
		PlayerPrefs.SetString(
			string.Format("AssetHash_{0}", Path.GetFileNameWithoutExtension(fileName)), md5);
	}
}

public class AssetBundleManager : MonoBehaviour
{
	private static AssetBundleManager _singleton;

	public delegate void Callback(bool success, string error);
	
	public delegate void PrepareDownloadCallback(ulong downloadRequiredBundleSize);

	public delegate void ProgressCallback(float progress, Constants.AssetBundleType assetBundleType, float downloadedSize = 0, float size = 0);
	private string _patchsetHost;

	public string PatchsetHost
    {
        get => !string.IsNullOrEmpty(_patchsetHost) ? _patchsetHost : Constants.PATCHSET_UPDATE_ORIGIN_URL;
        set => _patchsetHost = value;
    }
	//
	public static AssetBundleManager Get() {
		if(!_singleton) {
			var obj = new GameObject("[AssetBundleManager]");
			DontDestroyOnLoad(obj);
			_singleton = obj.AddComponent<AssetBundleManager>();
		}
		return _singleton;
	}

	private long _version;
	private Dictionary<Constants.AssetBundleType, AssetBundleRef> assetBundles = new Dictionary<Constants.AssetBundleType, AssetBundleRef>();
	public bool loadedAll = false;
	
	private AssetBundleManager ()
	{
		_version = (long)Utility.GetTime ();
	}

	// returns best persistent data path
	public static string persistentDataPath {
		get { return Application.persistentDataPath; }
	}
	
	private void Clear() {
		//
		foreach(var abref in assetBundles.Values.ToArray()) {
			abref.Unload();
			abref.SetLocalMD5("");
		}
		assetBundles.Clear ();
		PlayerPrefs.Save();
	}

	public void FetchStatus(Callback onFinish) {
		//
		if(Constants.IGNORE_ASSETBUNDLE) {
			if(onFinish != null)
				onFinish(true, null);
			
			return;
		}
		StartCoroutine (_FetchStatus (onFinish));
	}

	private IEnumerator _FetchStatus(Callback onFinish)
	{
		var url = $"{PatchsetHost}/status.json?t={UnityEngine.Random.value}";
		using (var request = UnityWebRequest.Get(url)) {
			yield return request.SendWebRequest();

			try {
				var json = JSON.Parse (request.downloadHandler.text);
				_version = json["version"].AsLong;
			} catch(Exception) {

			}
		}

		if (onFinish != null)
			onFinish (true, null);
	}
	
	public void LoadAll(ProgressCallback onProgress, Callback onFinish) {	
		//
		if(Constants.IGNORE_ASSETBUNDLE) {
			if(onFinish != null)
				onFinish(true, null);
			
			return;
		}

		StartCoroutine(
			Load(assetBundles.Values.ToList()
		     .FindAll (x => x.preload).ToArray(), onProgress, onFinish)
			);
	}
	
	private IEnumerator Load(AssetBundleRef []abrefs, ProgressCallback onProgress, Callback onFinish) {
		yield return null;

		bool success = true;
		foreach (var _abref in abrefs) {
			var abref = _abref;
			var e = _LoadAssetBundle(abref, 
			delegate(float progress, Constants.AssetBundleType assetBundleType, float downloadedSize, float size)
				{
					onProgress(progress, assetBundleType);
				},
			delegate(bool success2, string error) {
				if (!success2) {
					Clear();
					Debug.LogWarning(string.Format("Failed to load {0}", abref.fileName));
					success = false;
					return;
				}
			});
			
			while(e.MoveNext())
			{
				if (!success)
					break;
				yield return e.Current;
			}
		}
		
		if(success)
			loadedAll = true;
		
		PlayerPrefs.Save();
		onFinish(success, null);
	}
	
	public void DownloadAll(ProgressCallback onProgress, Callback onFinish) {
		
		//
		if(Constants.IGNORE_ASSETBUNDLE) {
			if(onFinish != null)
				onFinish(true, null);
			
			return;
		}

		StartCoroutine(
			Download(onProgress, onFinish)
			);		
	}

	public static string GetFolder()
	{
		var folder = Constants.SUBSET;
		if(Utility.isDebugMode || Constants.DEVELOPMENT_MODE) {
			folder += "/dev";
		}
		else
		{
			folder += "/production";
		}
		#if  UNITY_IPHONE
			folder += "/ios";
		#elif UNITY_ANDROID
			folder += "/android";
		#elif UNITY_WEBGL
			folder += "/webgl";
		#endif

		return folder;
    }
	
	public static string GetDownloadFolder()
	{
		var folder = "";
#if UNITY_EDITOR || DEVELOPMENT_BUILD
		folder = GetFolder();
#elif UNITY_IPHONE
		folder += "ios";
#elif UNITY_ANDROID
		folder += "android";
#elif UNITY_WEBGL
		folder += "webgl";
#endif

		return folder;
	}
	
    private void PrepareAssetBundle(Constants.AssetBundleType assetBundleType)
    {
        //
        if (assetBundles.ContainsKey(assetBundleType) == false)
        {
            var r = new AssetBundleRef();
            r.assetBundleType = assetBundleType;
            r.fileName = r.name + ".unity3d";
            r.required = true;
            r.preload = true;
            assetBundles[assetBundleType] = r;
        }
    }

    private IEnumerator Download(ProgressCallback onProgress, Callback onFinish)
    {
        yield return null;

        bool success = true;

        //
        var requiredCount = assetBundles.Values.Count(x => x.required || x.preload);
		int i = 0;
		foreach(var abref in assetBundles.Values.ToArray()) {
			if(!success)
				break;

			if(!abref.required && !abref.preload)
				continue;

			var e = _DownloadAssetBundle(abref, delegate(bool success2, string error) {
				if(!success2) {
					success = false;
					return;
				}

				i++;
				if (onProgress != null)
					onProgress(i / (float) requiredCount, abref.assetBundleType, abref.size, abref.size);
			}, delegate(float progress, Constants.AssetBundleType assetBundleType, float downloadedSize, float size)
			{
				if (onProgress != null)
					onProgress((i + progress) / (float) requiredCount, assetBundleType, downloadedSize, size);
			});
			
			while(e.MoveNext())
				yield return e.Current;

			if(!success)
				break;
		} 
		
		PlayerPrefs.Save();
		if(onFinish != null)
			onFinish(success, null);
	}

	public void DownloadAndLoad(Constants.AssetBundleType assetBundleType, Callback onFinish, ProgressCallback onProgress) {
		//
		if(Constants.IGNORE_ASSETBUNDLE) {
			if(onFinish != null)
				onFinish(true, null);

			return;
		}

		AssetBundleRef abref;
		if(!assetBundles.TryGetValue(assetBundleType, out abref)) {
			assetBundles[assetBundleType] = abref = new AssetBundleRef();
			abref.assetBundleType = assetBundleType;
			abref.fileName = abref.name + ".unity3d";
		}

		if(abref.assetBundle) {
			if(onFinish != null)
				onFinish(true, null);
			return;
		}

		StartCoroutine(_DownloadAssetBundle(abref, delegate(bool success, string error) {
			if(!success) {
				if(onFinish != null)
					onFinish(false, null);
				return;
			}

			StartCoroutine(_LoadAssetBundle(abref, onProgress, onFinish));
		}, onProgress));
	}

	private IEnumerator _LoadAssetBundle(AssetBundleRef abref, ProgressCallback onProgress, Callback onFinish)
	{
		yield return null;

		onProgress?.Invoke(1, abref.assetBundleType);
		
		if (abref.assetBundle)
		{
			Debug.Log(string.Format("Loaded from cache {0}", abref.fileName));
			onFinish?.Invoke(true, null);
			yield break;
		}

#if UNITY_EDITOR
		Caching.ClearAllCachedVersions(abref.name);
#endif
		
		if (abref.assetBundle)
		{
			abref.Unload();
			abref.assetBundle = null;
		}

		var req = AssetBundle.LoadFromFileAsync(abref.path);
		yield return req;

		var ab = req.assetBundle;
		if (!ab)
		{
			abref.SetLocalMD5("");
			Debug.LogError($"Failed to load AssetBundle: {abref.path}");
			onFinish?.Invoke(false, null);
			yield break;
		}
		
		//
		try
		{
			if (ab != null)
			{
				abref.assetBundle = ab;
				Debug.Log(string.Format("Loaded {0}", abref.fileName));

				onFinish?.Invoke(true, null);
				yield break;
			}
			else
			{
				// 로드 실패한, 애셋번들을 Invalid 시키기
				abref.SetLocalMD5("");
			}
		}
		catch (Exception ex)
		{
			// 로드 실패한, 애셋번들을 Invalid 시키기
			abref.SetLocalMD5("");
			Debug.LogWarning(ex);
		}

		//
		onFinish?.Invoke(false, null);
	}

	public void PrepareDownload(PrepareDownloadCallback callback)
	{
		if (Constants.IGNORE_ASSETBUNDLE) {
			callback(0);
			return;
		}

		StartCoroutine(_PrepareDownload(callback));
	}
	
	private IEnumerator _PrepareDownload(PrepareDownloadCallback callback)
	{
		yield return null;

		//
		foreach (var abref in assetBundles.Values)
			abref.Unload();
		assetBundles.Clear();

		//
		
		foreach (Constants.AssetBundleType x in Enum.GetValues(typeof(Constants.AssetBundleType)))
		{
			if (x == Constants.AssetBundleType.ALL)
				continue;
			PrepareAssetBundle(x);
		}

		//
		var downloadRequiredBundleSize = 0ul; 
		foreach(var abref in assetBundles.Values.ToArray()) {
			if(!abref.required && !abref.preload)
				continue;

			var e = _FetchAssetBundleInfo(abref);
			while(e.MoveNext())
				yield return e.Current;

			if (abref.GetLocalMD5() != abref.md5)
				downloadRequiredBundleSize += abref.size;
		}

		callback(downloadRequiredBundleSize);
	}

	private IEnumerator _FetchAssetBundleInfo(AssetBundleRef abref)
	{
		var folder = GetDownloadFolder();
		var url = $"{PatchsetHost}/{folder}/{Path.GetFileNameWithoutExtension(abref.fileName)}.json?t={(long)Utility.GetTime()}";

		if (Utility.isDebugMode)
			Debug.Log(url);

		using (var request = UnityWebRequest.Get(url))
		{
			yield return request.SendWebRequest();

			if (request.error == null)
			{
				try
				{
					var data = JSON.Parse(request.downloadHandler.text);
					abref.md5 = data["md5"].AsString;
					abref.size = (ulong)double.Parse(data["size"]);
				}
				catch (Exception ex)
				{
					Debug.LogError(ex);
					Debug.LogError($"Request URL: {url}, Response: {request.downloadHandler.text}");
				}
			}
		}
	}

	private IEnumerator _DownloadAssetBundle(AssetBundleRef abref, Callback onFinish, ProgressCallback onProgress) {
		yield return null;

		var folder = GetDownloadFolder();

        //
        if (abref.GetLocalMD5() == abref.md5)
        {
			Debug.Log(string.Format("Skipping {0} = {1}", abref.fileName, abref.GetLocalMD5()));

			if(onFinish != null)
				onFinish(true, null);
			yield break;
        }

        var url = $"{PatchsetHost}/{folder}/{abref.fileName}?t={abref.md5}";

        if (Utility.isDebugMode)
			Debug.Log(url);

        var path = Path.Combine(persistentDataPath, abref.fileName);
        using (var request = UnityWebRequest.Get(url))
        {

            //
            request.downloadHandler = new DownloadHandlerFile(path) { removeFileOnAbort = true };

            //
            request.SendWebRequest();
            while (!request.isDone)
            {
                //
                if (onProgress != null)
                {
                    if (request.downloadProgress <= 0f)
                        onProgress(Mathf.Clamp01(request.downloadedBytes / (float) abref.size), abref.assetBundleType,
	                        request.downloadedBytes, abref.size);
                    else
                        onProgress(request.downloadProgress, abref.assetBundleType, request.downloadedBytes, abref.size);
                }

                yield return null;
            }

            if (request.result != UnityWebRequest.Result.Success)
            {
                Debug.LogWarning($"Failed to download {abref.fileName}.unity3d");
                Debug.LogWarning($"{request.error} ({request.result.ToString()})");
                
                abref.SetLocalMD5("");
                if (onFinish != null)
                    onFinish(false, null);
                yield break;
            }

#if UNITY_IPHONE
					UnityEngine.iOS.Device.SetNoBackupFlag(path);
#endif

            var localMD5 = Utility.MD5FromFile(path);

            if (string.IsNullOrEmpty(abref.md5) || abref.md5.CompareTo(localMD5) != 0)
            {
                Debug.Log("local md5 = " + localMD5);
                Debug.Log("origin md5 = " + abref.md5);
                Debug.Log("url = " + request.url);

                Debug.LogWarning(string.Format("Failed to download {0}", abref.fileName));

                abref.SetLocalMD5("");
                if (onFinish != null)
                    onFinish(false, null);
                yield break;
            }

            abref.SetLocalMD5(abref.md5);

            //
            Debug.Log(string.Format("Downloaded {0}", abref.fileName));

            if (onFinish != null)
                onFinish(true, null);
            yield break;
        }

        if (onFinish != null)
			onFinish(false, null);
	}
	
	public UnityEngine.Object GetAsset(string name, Type type)
	{
		foreach(var ab in assetBundles.Values) {
			if(!ab.assetBundle)
				continue;

			#if UNITY_5_3_OR_NEWER
			if (ab.assetBundle.isStreamedSceneAssetBundle)
				continue;
			#endif

			var obj = ab.assetBundle.LoadAsset(name, type);
			if(obj != null)
				return obj;
		}
		
		return null;
	}

	
}
