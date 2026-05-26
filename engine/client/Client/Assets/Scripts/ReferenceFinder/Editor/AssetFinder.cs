using System.Collections.Generic;
using System.IO;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace ReferenceFinder.Editor
{
    public class AssetFinder
    {
        // Path에는 Assets가 포함되지 않아야한다. ex) Art/UI/OutGame/Skin
        // https://forum.unity.com/threads/how-to-get-list-of-assets-at-asset-path.18898/
        // ext = png, jpg
        public static IEnumerable<(string fileName, T asset)> FindAllByPath<T>(string path, string ext = "*", bool recursive = true)
            where T : Object
        {
#if UNITY_EDITOR
            var filePaths = Directory.GetFiles(Path.Combine(Application.dataPath, path));
            foreach (var filePath in filePaths)
            {
                var extension = Path.GetExtension(filePath);
                if (ext != "*" && extension != "." + ext)
                    continue;

                string temp = filePath.Replace("\\", "/");
                int index = temp.LastIndexOf("/");
                string localPath = "Assets/" + path;
                if (index > 0)
                    localPath += temp.Substring(index);
                var asset = AssetDatabase.LoadAssetAtPath<T>(localPath);
                if (asset == null)
                    continue;
                var fileName = Path.GetFileName(filePath);
                fileName = Path.ChangeExtension(fileName, null);
                yield return (fileName, asset);
            }

            if (!recursive)
                yield break;

            var directoryPaths = Directory.GetDirectories(Path.Combine(Application.dataPath, path));
            foreach (var dirPath in directoryPaths)
            {
                string temp = dirPath.Replace("\\", "/");
                int index = temp.LastIndexOf("/");
                string localPath = path;
                if (index > 0)
                    localPath += temp.Substring(index);

                foreach (var item in FindAllByPath<T>(localPath, ext, recursive))
                {
                    yield return item;
                }
            }

#endif
            yield break;
        }

        public static IEnumerable<T> FindAll<T>() where T : Object
        {
#if UNITY_EDITOR
            string filter = $"t: {typeof(T).Name}";
            string[] guids = AssetDatabase.FindAssets(filter);
            foreach (var guid in guids)
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);
                var asset = AssetDatabase.LoadAssetAtPath<T>(path);
                yield return asset;
            }
#endif
            yield break;
        }

        public static T FindOneByName<T>(string name) where T : Object
        {
#if UNITY_EDITOR
            var ty = typeof(T).Name;
            string filter = $"t: {ty}";
            string[] guids = AssetDatabase.FindAssets(filter);

            var list = new List<T>();
            foreach (var guid in guids)
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);
                var asset = AssetDatabase.LoadAssetAtPath<T>(path);
                if (asset == null)
                {
                    Debug.LogError($"에셋 {name}이(가) {ty} 타입이 아님");
                    continue;
                }

                if (asset.name != name)
                    continue;

                list.Add(asset);
            }

            if (list.Count == 0)
            {
                Debug.LogError("에셋을 찾지 못함. " + name);
                return default;
            }

            if (list.Count == 1)
                return list[0];

            if (2 <= list.Count)
            {
                Debug.LogError("같은 이름의 에셋이 많음. " + name);
                return list[0];
            }
#endif
            return default;
        }
    }
}
