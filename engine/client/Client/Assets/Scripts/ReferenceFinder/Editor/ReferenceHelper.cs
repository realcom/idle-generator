using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace ReferenceFinder.Editor
{
    public class AssetFindOption
    {
        public bool CheckPrefab = true;
        public bool CheckScene = true;
        public bool CheckScriptableObject = true;
        public bool CheckAnimationClip = false;
        public bool CheckAnimatorController = false;
        public bool CheckMaterial = false;
        public bool CheckModel = false;
        public string[] CheckAdditional = { };
    }


    public class ReferenceHelper
    {
        public static string[] FindAllPath(string rootPath, AssetFindOption option, params string[] ignorePaths)
        {
            string findKeyword = "";
            if (option.CheckPrefab) findKeyword += "t:Prefab ";
            if (option.CheckScene) findKeyword += "t:Scene ";
            if (option.CheckScriptableObject) findKeyword += "t:ScriptableObject ";
            if (option.CheckMaterial) findKeyword += "t:Material ";
            if (option.CheckModel) findKeyword += "t:Model ";
            if (option.CheckAnimatorController) findKeyword += "t:AnimatorController ";
            if (option.CheckAnimationClip) findKeyword += "t:AnimationClip ";

            foreach (var additional in option.CheckAdditional)
                findKeyword += $"t:{additional.Replace(" ", "").Trim()} ";

            var paths = AssetDatabase.FindAssets(findKeyword, new[] { rootPath })
                .Select(AssetDatabase.GUIDToAssetPath)
                .Where(NotIgnored)
                .ToArray();

            bool NotIgnored(string path)
            {
                var directory = Path.GetDirectoryName(path).Replace("\\", "/");
                return !ignorePaths.Any(x => directory.StartsWith(x));
            }

            return paths;
        }

        public static void ForeachPathWithProgressBar(
            string rootPath,
            AssetFindOption option,
            Action<string> pathAction,
            Action onComplete = null
        )
        {
            try
            {
                var paths = FindAllPath(rootPath, option);
                for (var i = 0; i < paths.Length; i++)
                {
                    var path = paths[i];
                    if (path.EndsWith(".fbx") || path.EndsWith(".FBX"))
                        path = $"{path}.meta";

                    if (EditorUtility.DisplayCancelableProgressBar($"{i}/{paths.Length}", path,
                        (float)i / paths.Length))
                        break;

                    pathAction(path);
                }
                onComplete?.Invoke();
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
            finally
            {
                EditorUtility.ClearProgressBar();
            }
        }


        public static void Find(string rootPath, Object obj, AssetFindOption option)
        {
            var startsAt = DateTime.Now;
            bool found = false;

            var guid = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(obj));
            if (string.IsNullOrEmpty(guid))
                throw new ArgumentException("null guid");

            ForeachPathWithProgressBar(rootPath, option, path =>
            {
                var s = File.ReadAllText(path);
                if (s.Contains(guid))
                {
                    found = true;
                    Debug.Log(path, AssetDatabase.LoadAssetAtPath<Object>(path));
                }
            }, () =>
            {
                var elapsed = DateTime.Now - startsAt;

                Debug.Log("걸린 시간: " + elapsed.TotalSeconds + "초");
                if (!found)
                    Debug.Log($"검색된 레퍼런스가 없습니다. ({obj})", obj);
            });


        }
    }
}
