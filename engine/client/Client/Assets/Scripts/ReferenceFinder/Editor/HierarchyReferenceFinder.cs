using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace ReferenceFinder.Editor
{
    public class HierarchyReferenceFinder
    {
        [MenuItem("GameObject/레퍼런스 찾기", false, 0)]
        public static void FindReferencesToAsset()
        {
            var selected = Selection.activeGameObject;
            if (!selected)
            {
                Debug.LogError("선택된 게임오브젝트가 없음.");
                return;
            }

            EditorUtility.ClearProgressBar();
            try
            {
                var referencedBy = FindReferencesTo(selected, GetAllGameObjectPrefabOrScene());
                if (0 < referencedBy.Count)
                {
                    foreach (var (obj, reference) in referencedBy)
                    {
                        EditorGUIUtility.PingObject(reference);
                        Debug.Log($"[레퍼런스] <color=white>{reference.name}</color> -> {obj.name}", reference);
                    }
                }
                else
                    Debug.Log("확인된 레퍼런스 없음.");
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

        // https://answers.unity.com/questions/321615/code-to-mimic-find-references-in-scene.html
        private static List<(Object obj, Object referenced)> FindReferencesTo(GameObject rootTarget, Object[] allObjects)
        {
            EditorUtility.ClearProgressBar();

            var references = new List<(Object obj, Object referenced)>();
            var targetTransforms = rootTarget.GetComponentsInChildren<Transform>(true);
            var targetComponents = targetTransforms.SelectMany(x => x.GetComponentsInChildren<Component>(true));
            var targetGameObjects = targetTransforms.Select(x => x.gameObject).ToArray();

            var targetObjects = targetComponents
                .Cast<Object>()
                .Concat(targetGameObjects)
                .ToArray();

            for (var i = 0; i < allObjects.Length; i++)
            {
                var obj = allObjects[i];

                if (EditorUtility.DisplayCancelableProgressBar($"{i}/{allObjects.Length}", obj.name,
                        (float)i / allObjects.Length))
                    break;

                // 자식끼리의 참조는 막는다. 외부에서의 의존성이 중요함
                if (targetGameObjects.Contains(obj))
                    continue;

                bool isPrefab = PrefabUtility.GetPrefabInstanceStatus(obj) != PrefabInstanceStatus.NotAPrefab;
                if (isPrefab && PrefabUtility.GetCorrespondingObjectFromSource(obj) == rootTarget)
                    references.Add((obj, obj));

                if (obj is GameObject go)
                {
                    var components = go.GetComponents<Component>();
                    foreach (var component in components)
                    {
                        // 놀랍지만 미싱 레퍼런스 일 때 이렇게 된다.
                        if (component == null)
                            continue;

                        if (component.gameObject == rootTarget)
                            continue;

                        var so = new SerializedObject(component);
                        var sp = so.GetIterator();
                        while (sp.NextVisible(true))
                        {
                            if (sp.propertyType != SerializedPropertyType.ObjectReference)
                                continue;
                            foreach (var target in targetObjects)
                            {
                                if (sp.objectReferenceValue == target)
                                {
                                    references.Add((target, component.gameObject));
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            return references;
        }

        public static GameObject[] GetAllGameObjectPrefabOrScene()
        {
            var components = GetAllComponentsInPrefabOrScene<Transform>();
            return components.Select(x => x.gameObject).ToArray();
        }

        public static T[] GetAllComponentsInPrefabOrScene<T>() where T : Component
        {
            UnityEditor.SceneManagement.PrefabStage stage = UnityEditor.SceneManagement.PrefabStageUtility.GetCurrentPrefabStage();
            if (stage != null)
            {
                var root = stage.prefabContentsRoot.transform;
                var transforms = root.GetComponentsInChildren<Transform>(true);
                return transforms.SelectMany(x => x.GetComponents<T>()).Where(x => x != null).ToArray();
            }

            return Object.FindObjectsOfType<T>(true);
        }
    }
}
