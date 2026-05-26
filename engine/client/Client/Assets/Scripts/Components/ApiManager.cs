using UnityEngine;
using System;
using System.Net.Http;
using Commons;
using Cysharp.Threading.Tasks;
using SimpleJSON;

public class ApiManager
{
    private const string BOOTSTRAP_URL = "api/client/servers/bootstrap";
    private static ApiManager _singleton;
    private static readonly HttpClient httpClient = new HttpClient();

    public static ApiManager Get()
    {
        if (_singleton == null)
        {
            _singleton = new ApiManager();
        }

        return _singleton;
    }
    
    public string ApiHost
    {
        get
        {
            var host = Constants.WEB_HOST;
            if (Application.isEditor || Constants.DEVELOPMENT_MODE || Config.IsDebug)
            {
                if (!string.IsNullOrEmpty(Config.fixWebHost))
                    host = Config.fixWebHost;
            }

            return host;
        }
    }
    

    public async UniTask<(string host, string patchsetHost)> FetchBootstrap()
    {
#if UNITY_EDITOR || DEVELOPMENT_BUILD
        return (host: "", patchsetHost: "");
#else
        try
        {
            var url = $"{ApiHost}/{BOOTSTRAP_URL}?clientVersion={Utility.GetVersionInt(Application.version)}";
            var response = await httpClient.GetAsync(url);
            var responseString = await response.Content.ReadAsStringAsync();
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(responseString);
            }
            var json = JSON.Parse(responseString);
            var host = json["host"].AsString;
            var patchsetHost = json["patchsetHost"].AsString;
            return (host, patchsetHost);
        }
        catch (Exception e)
        {
            Debug.LogError($"[AssetBundleManager] Failed to fetch server bootstrap: {e}");
            throw;
        }
#endif
    }
}
