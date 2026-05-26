using UnityEngine;
using System;
using System.IO;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using SimpleJSON;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using Assets.Scripts.Core;
using Core;
using UnityEngine.Networking;

public class AssetBundleEditor
{
    private static string _folder;
    private static BuildTarget _target;

    public static void Deploy(BuildTarget target, string deployTarget = null)
    {
        _folder = AssetBundleManager.GetFolder();
        //
        var files = new List<string>();
        foreach (Constants.AssetBundleType x in Enum.GetValues(typeof(Constants.AssetBundleType)))
        {
            if (x == Constants.AssetBundleType.ALL)
                continue;
            files.Add(x.ToString().ToCamelCase());
        }
        
        var form = new WWWForm();
        form.AddField("cmd", "deploy");
        form.AddField("prefix", Constants.SUBSET);
        form.AddField("folder", _folder);
        form.AddField("secret", "231eqweqwrtwqr");
        form.AddField("filename", string.Join(", ", files));
        if (!string.IsNullOrEmpty(deployTarget))
            form.AddField("target", deployTarget);
       
        //
        string remoteUrl =  $"{Constants.PATCHSET_UPDATE_ORIGIN_URL}/upload_idlez.php";
        // return;
        //
        using (var req = UnityWebRequest.Post(remoteUrl, form))
        {
            req.timeout = 15; // 타임아웃 (초)

            var op = req.SendWebRequest();
            while (!op.isDone) ; // 동기 대기 (Editor에서는 괜찮지만 런타임에서는 코루틴 권장)

            if (req.result != UnityWebRequest.Result.Success)
                EditorUtility.DisplayDialog("Upload scene", "Upload failed: " + req.error, "ok");
            else
            {
                EditorUtility.DisplayDialog("Upload scene", "Upload result: " + req.downloadHandler.text, "ok");
                
                var builder = new StringBuilder();
                builder.AppendLine($">Info: (v{Utility.GetVersionInt(PlayerSettings.bundleVersion)}) Build Target: {target.ToString()}, Deploy Target: {deployTarget ?? "All"}");
                SlackMessageSender.Send(
                    "햄스터 작업 완료! 프로덕션 서버에 패치셋이 무사히 올라갔어요! 테스트 부탁드려요!",
                    builder);
            }
        }
        // using (var www = new WWW(remoteUrl, form))
        // {
        //     
        //     while (!www.isDone) ;
        //     
        //     if (!string.IsNullOrEmpty(www.error))
        //         EditorUtility.DisplayDialog("Upload scene", "WWW failed: " + www.error, "ok");
        //     else
        //         EditorUtility.DisplayDialog("Upload scene", "WWW result: " + www.text, "ok");
        // }
    }

    public static void UploadFile(List<string> files, StringBuilder message = null, bool verbose = true, bool dev = true)
    {
        _folder = AssetBundleManager.GetFolder();
        //
        string remoteUrl =  $"{Constants.PATCHSET_UPDATE_ORIGIN_URL}/upload_idlez.php";
        var bundlePath = $"Patches/{_folder}";
        using (var http = new HttpClient())
        {
            http.Timeout = TimeSpan.FromMinutes(15);
            
            using (var content = new MultipartFormDataContent
            {
                {new StringContent(_folder), "folder"},
                {new StringContent("231eqweqwrtwqr"), "secret"},
            })
            {
                foreach (var x in files)
                {
                    var path = $"{bundlePath}/{Path.GetFileNameWithoutExtension(x)}.unity3d";
                    content.Add(new StreamContent(new MemoryStream(File.ReadAllBytes(path))), "file[]",
                        Path.GetFileName(path));
                    path = $"{bundlePath}/{Path.GetFileNameWithoutExtension(x)}.json";
                    content.Add(new StreamContent(new MemoryStream(File.ReadAllBytes(path))), "file[]",
                        Path.GetFileName(path));
                    Debug.Log($"upload to _folder {_folder} path: {path}");
                }
                
                var response = http.PostAsync(remoteUrl, content).Result;
                var responseContent = response.Content; 
                var responseString = responseContent.ReadAsStringAsync().Result;
                Debug.Log($"upload response: {responseString}");
                if (!response.IsSuccessStatusCode)
                    EditorUtility.DisplayDialog("Upload scene", "WWW failed: " + responseString, "ok");
                else
                {   if(verbose)
                        EditorUtility.DisplayDialog("Upload scene", "Success", "ok");
                    
                    if (message == null)
                        message = new StringBuilder();
                    message.Insert(0, $">Patch Version: {GameConfig.Config.patchsetVersion}\n");
                    SlackMessageSender.Send(
                        "햄스터 배달 완료! 로컬 기준으로 개발 서버에 패치셋이 업로드 됐습니다!",
                        message);
                    
                }
            }
        }
    }
    
    public static List<string> Build(BuildTarget target, uint selectedTypes)
    {

        _target = target;
        _folder = AssetBundleManager.GetFolder();

        var files = new List<string>();

        //
        Directory.CreateDirectory(String.Format("Patches/{0}", _folder));

        if ((selectedTypes & (int)Constants.AssetBundleType.MAPS) != 0)
        {
            // string[] levels = Directory.GetFiles(@"Assets/PatchResources/Maps/", "*.unity", SearchOption.AllDirectories)
                // .Where(x => Path.GetFileName(x).StartsWith("_") == false).ToArray();
                
            // Debug.Log(string.Join(", ", levels));
            
            ExportSelected("Maps", "Maps/Prefabs", new[] { "*.prefab" }, SearchOption.AllDirectories);
            
            //
            // string path = String.Format("Patches/{0}/Maps.unity3d", _folder);
            // BuildPipeline.BuildPlayer(levels, path, _target, BuildOptions.BuildAdditionalStreamedScenes);
            // WriteMeta(path);

            //
            files.Add("Maps.unity3d");
        }

        if ((selectedTypes & (uint)Constants.AssetBundleType.COMMONS) != 0)
        {
            BuildProcessor.SerializeJsonData(BuildProcessor.PatchResourceDataPath, BuildProcessor.ResourceDataPath);
            // ExportSelected("Commons", "", new[] { "*.json", "*.xml", "*.txt" }, SearchOption.TopDirectoryOnly);
            ExportSelected("Commons", "", new[] { "*.bytes", "*.asset", "*.txt" }, SearchOption.TopDirectoryOnly);
            files.Add("Commons.unity3d");
        }
        
        if ((selectedTypes & (uint)Constants.AssetBundleType.ETC) != 0)
        {
            var name = nameof(Constants.AssetBundleType.ETC).ToCamelCase();
            ExportSelected(name, new[] { "TextSpriteAssets", "UIAssets", "FXPrefabs" }, new[] { "*.asset", "*.png", "*.prefab", "*.spriteatlas", "*.spriteatlasv2", "*.jpg" }, SearchOption.AllDirectories);
            files.Add($"{name}.unity3d");
        }

        foreach (Constants.AssetBundleType x in Enum.GetValues(typeof(Constants.AssetBundleType)))
        {
            if (x is Constants.AssetBundleType.ALL or Constants.AssetBundleType.MAPS or Constants.AssetBundleType.COMMONS or Constants.AssetBundleType.ETC)
                continue;
            if ((selectedTypes & (uint)x) != 0)
            {
                var name = x.ToString().ToCamelCase();
                ExportSelected(name, name, new[] { "*.prefab", "*.spriteatlas", "*.spriteatlasv2", "*.png", "*.jpg", "*.wav", "*.mp3", "*.asset", "*.overrideController" }, SearchOption.AllDirectories);
                files.Add($"{name}.unity3d");
            }
        }

        return files;
    }

    private static void WriteMeta(string path)
    {
        //
        var md5 = Utility.MD5FromFile(path);

        //
        var data = new JSONClass();
        data["md5"] = md5;
        data["size"] = new JSONData(new System.IO.FileInfo(path).Length.ToString());
        File.WriteAllText(Path.ChangeExtension(path, ".json"), data.ToString());
    }

    private static void ExportSelected(string category, string path, string[] patterns, SearchOption searchOption)
    {
        ExportSelected(category, new string[] { path } , patterns, searchOption);
    }
    private static void ExportSelected(string category, string[] paths, string[] patterns, SearchOption searchOption)
    {
        var entries = new List<string>();
        var assetNames = new List<string>();

        //
        foreach (var pattern in patterns)
        foreach (var path in paths)
        {
            var searchPath = Application.dataPath + "/PatchResources/" + path;
            if (!Directory.Exists(searchPath))
                continue;
            
            entries.AddRange(Directory.GetFiles(searchPath, pattern, searchOption));
        }
            

        var objects = new List<(UnityEngine.Object, float)>();
        var originals = new Dictionary<string, string>();
        foreach (var file in entries)
        {
            var relPath = file.Substring((Application.dataPath + "/").Length);
            relPath = Path.Combine("Assets", relPath);
            assetNames.Add(relPath);

            var t = AssetDatabase.LoadAssetAtPath(relPath, typeof(UnityEngine.Object));
            var tex = t as Texture2D;
            if (tex != null)
            {

            }

            if (t is TextAsset)
            {
                // var text = File.ReadAllText(relPath);
                // if (text.StartsWith("GN+") || text.StartsWith("GNF+"))
                //     throw new Exception("Commons 빌드가 중복되어 진행 중입니다!");
                // originals.Add(relPath, text);
                // text = text.Replace("\ufeff", "");
                // File.WriteAllText(relPath, "GN+" + Utility.Encrypt(text));
                // File.WriteAllText(relPath, "GNF+" + Utility.FastEncrypt(text));
                // AssetDatabase.Refresh();
                t = AssetDatabase.LoadAssetAtPath(relPath, typeof(UnityEngine.Object));
            }

            if (t != null)
            {
                var size = new FileInfo(relPath).Length / 1000000f;
                objects.Add((t, size));
            }
        }

        var totalSize = 0f;
        foreach (var obj in objects.OrderByDescending(o => o.Item2))
        {
            totalSize += obj.Item2;
            Debug.Log($"{obj.Item2:0.00}MB {obj.Item1.name} ({obj.Item1.GetType()})");
        }
        Debug.Log($"Total: {totalSize:0.00}MB");

        var outputPath = "Patches/";
        var bundlePath = outputPath + _folder + "/" + category + ".unity3d";
        var lowerCaseBundlePath = outputPath + _folder + "/" + category.ToLower() + ".unity3d";
        BuildPipeline.BuildAssetBundles(outputPath + _folder,
            new[] { new AssetBundleBuild
            {
                assetBundleName = category,
                assetBundleVariant = "unity3d",
                assetNames = assetNames.ToArray(),
            } },
            BuildAssetBundleOptions.ChunkBasedCompression, _target);
        
        File.Move(lowerCaseBundlePath, bundlePath);
        
        // BuildPipeline.BuildAssetBundle(objects[0].Item1,
        //     objects.Select(o => o.Item1).ToArray(),
        //     bundlePath,
        //     BuildAssetBundleOptions.CompleteAssets 
        //     | BuildAssetBundleOptions.CollectDependencies 
        //     | BuildAssetBundleOptions.ChunkBasedCompression,
        //     _target);

        //
        WriteMeta(bundlePath);

        foreach (var entity in originals)
        {
            File.WriteAllText(entity.Key, entity.Value);
            AssetDatabase.LoadAssetAtPath(entity.Key, typeof(UnityEngine.Object));
        }
        AssetDatabase.Refresh();
    }

}