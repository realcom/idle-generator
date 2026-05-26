using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace ReferenceFinder.Editor
{
    public static class ReferenceFinder
    {
        private static EditorCoroutine m_Coroutine;
        private static int m_ObjectsToSearchAsync;
        private static int m_ObjectsSearchedAsync;
        private const int MaxAssetsToSearchPerFrame = 400;
        private const int MaxPropsToSearchPerFrame = 600;

        // Extend this list to include asset types which do not include references to other Objects.
        private static readonly string[] ExcludedExtensions =
        {
            ".unity",
            ".mp3",
            ".wav",
            ".fbx",
            ".anim",
            ".asset",
            ".tga",
            ".png",
            ".ttf",
            ".json"
        };

        private static Dictionary<Object, SerializedObject> m_CachedSerializedObjects
            = new Dictionary<Object, SerializedObject>();

        public static bool DoingAsyncWork
        {
            get { return m_Coroutine != null; }
        }

        public static float AsyncProgress
        {
            get { return (float)m_ObjectsSearchedAsync / m_ObjectsToSearchAsync; }
        }

        private static IEnumerator GetSerializedPropsAsync(HashSet<Object> referencedObjects, IEnumerable<Object> searchObjects,
            IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> foundReferences)
        {
            m_ObjectsSearchedAsync = 0;
            m_ObjectsToSearchAsync = searchObjects.Count();
            foreach (var obj in searchObjects.Where(o => o != null))
            {
                if (m_ObjectsSearchedAsync % MaxPropsToSearchPerFrame == 0)
                {
                    // Yield after doing some work so we don't block the main thread too long.
                    yield return null;
                }
                ++m_ObjectsSearchedAsync;
                GetMatchingProps(referencedObjects, obj, foundReferences);
            }
            StopAsyncOperation();
        }

        private static IEnumerator GetSerializedPropsInAssets(HashSet<Object> referencedObjects,
            IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> foundReferences)
        {
            var assets = AssetDatabase.GetAllAssetPaths();
            m_ObjectsSearchedAsync = 0;
            m_ObjectsToSearchAsync = assets.Length;
            int numAssetsSearched = 0;

            foreach (var assetPath in assets)
            {
                if (!ExcludedExtensions.Contains(Path.GetExtension(assetPath)))
                {
                    var assetsAtPath = AssetDatabase.LoadAllAssetsAtPath(assetPath);
                    foreach (var asset in assetsAtPath.Where(a => a != null))
                    {
                        GetMatchingProps(referencedObjects, asset, foundReferences);
                        ++numAssetsSearched;
                        if (numAssetsSearched % MaxAssetsToSearchPerFrame == 0)
                        {
                            // Yield after doing some work so we don't block the main thread too long.
                            yield return null;
                        }
                    }
                }
                ++m_ObjectsSearchedAsync;
            }
            StopAsyncOperation();
        }

        private static void GetMatchingProps(HashSet<Object> referencedObjects, Object objectToSearch,
            IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> propsContainer)
        {
            SerializedObject so;
            if (!m_CachedSerializedObjects.TryGetValue(objectToSearch, out so))
            {
                so = new SerializedObject(objectToSearch);
                m_CachedSerializedObjects.Add(objectToSearch, so);
            }

            so.UpdateIfRequiredOrScript();

            var it = so.GetIterator();
            if (!it.hasChildren) return;
            while (it.NextVisible(true))
            {
                if (it.propertyType == SerializedPropertyType.ObjectReference &&
                    referencedObjects.Contains(it.objectReferenceValue))
                // referencedObjects.Contains(it.objectReferenceValue))
                {
                    List<SerializedProperty> list;
                    if (!propsContainer[it.objectReferenceValue].TryGetValue(objectToSearch, out list))
                    {
                        list = new List<SerializedProperty>();
                        propsContainer[it.objectReferenceValue][objectToSearch] = list;
                    }
                    list.Add(it.Copy());
                }
            }
        }

        public static void FindReferencesAsync(HashSet<Object> referencedObjects, IEnumerable<Object> searchObjects,
            IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> foundReferences, System.Action callback)
        {
            // We can't use threading because the Unity api is not thread-safe.
            // The second best thing here to minimize blocking the main thread too much is using a coroutine implementation.
            StopAsyncOperation();
            CleanCachedSerializedObjects();
            m_Coroutine = new EditorCoroutine(
                GetSerializedPropsAsync(referencedObjects, searchObjects, foundReferences), callback);
        }

        public static void FindReferencesInAssetsAsync(HashSet<Object> referencedObjects,
            IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> foundReferences, System.Action callback)
        {
            StopAsyncOperation();
            CleanCachedSerializedObjects();
            m_Coroutine = new EditorCoroutine(
                GetSerializedPropsInAssets(referencedObjects, foundReferences), callback);
        }

        private static void CleanCachedSerializedObjects()
        {
            m_CachedSerializedObjects = m_CachedSerializedObjects
                .Where(pair => pair.Key != null)
                .ToDictionary(pair => pair.Key, pair => pair.Value);
        }

        public static void StopAsyncOperation()
        {
            if (m_Coroutine != null)
            {
                m_Coroutine.Stop();
                m_Coroutine = null;
            }
        }
    }

}
