using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace ReferenceFinder.Editor
{
    [Serializable]
    struct ProjectToHierarchyReferenceResult
    {
        public Object 에셋;
        public Object 쓰는곳;
    }

    public class ProjectToHierarchyReferenceFinder : OdinEditorWindow
    {
        [MenuItem("UI/Hierarchy에서 Project의 Reference 찾기")]
        public static ProjectToHierarchyReferenceFinder ShowWindow()
        {
            var window = GetWindow<ProjectToHierarchyReferenceFinder>();
            window.Show();
            return window;
        }

        [Title("검색")]
        [AssetsOnly]
        [LabelText("대상")]
        [GUIColor(nameof(targetColor))]
        [SerializeField]
        private Object target;

        [Title("결과")]
        [HideLabel]
        [TableList(AlwaysExpanded = true)]
        [PropertyOrder(2)]
        [SerializeField] private ProjectToHierarchyReferenceResult[] results;

        [ShowIf(nameof(completed))]
        [ShowInInspector]
        [ReadOnly]
        [PropertyOrder(1)]
        private string 걸린시간;
        private bool completed;
        private Color targetColor => target == null ? Color.green : Color.white;
        private Color buttonColor => target == null ? Color.white : Color.green;

        private readonly ElapseTimer timer = new ElapseTimer();

        [Button(ButtonHeight = 40)]
        [GUIColor(nameof(buttonColor))]
        [EnableIf(nameof(target))]
        public void Find()
        {
            completed = false;
            timer.Start();
            EditorUtility.ClearProgressBar();
            try
            {
                var all = GetAllGameObjectPrefabOrScene();
                results = FindReferencesTo(target, all).ToArray();
                completed = true;
                걸린시간 = $"{timer.GetElapsed().TotalSeconds}초 ({all.Length}개)";
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

            return FindObjectsOfType<T>(true);
        }

        [Button("선택")]
        public void Grep()
        {
            var objects = results.Select(x => x.쓰는곳).ToArray();
            Selection.objects = objects;
        }

        [MenuItem("Assets/레퍼런스 찾기 (Hierarchy)", false, 0)]
        public static void FindReferencesToAsset()
        {
            var selected = Selection.activeObject;
            if (!selected)
            {
                Debug.LogError("선택된 오브젝트가 없음.");
                return;
            }

            var window = ShowWindow();
            window.target = selected;
            window.completed = false;
            window.results = new ProjectToHierarchyReferenceResult[0];
        }

        private static Object[] GetTargetObjects(Object rootTarget)
        {
            // 프리팹이라서 프리팹 하나만 검사한다.
            if (rootTarget is GameObject go)
                return new Object[] { go };

            // 나머지는 에셋이라 서브에셋들을 검사합ㄴ다.
            string path = AssetDatabase.GetAssetPath(rootTarget);
            return AssetDatabase.LoadAllAssetsAtPath(path);
        }

        // https://answers.unity.com/questions/321615/code-to-mimic-find-references-in-scene.html
        private static List<ProjectToHierarchyReferenceResult> FindReferencesTo(Object rootTarget, GameObject[] allObjects)
        {
            EditorUtility.ClearProgressBar();

            var references = new List<ProjectToHierarchyReferenceResult>();
            var targetObjects = GetTargetObjects(rootTarget).ToHashSet();

            for (var i = 0; i < allObjects.Length; i++)
            {
                var go = allObjects[i];

                if (EditorUtility.DisplayCancelableProgressBar($"{i}/{allObjects.Length}", go.name,
                    (float)i / allObjects.Length))
                    break;

                if (PrefabUtility.IsAnyPrefabInstanceRoot(go))
                {
                    var prefabSource = PrefabUtility.GetCorrespondingObjectFromOriginalSource(go);

                    if (targetObjects.Contains(prefabSource.gameObject))
                    {
                        ProjectToHierarchyReferenceResult result;
                        result.쓰는곳 = go;
                        result.에셋 = rootTarget;
                        references.Add(result);
                    }
                }

                var components = go.GetComponents<Component>();
                foreach (var component in components)
                {
                    // 놀랍지만 미싱 레퍼런스 일 때 이렇게 된다.
                    if (component == null)
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
                                ProjectToHierarchyReferenceResult result;
                                result.에셋 = target;
                                result.쓰는곳 = component.gameObject;
                                references.Add(result);
                                break;
                            }
                        }
                    }
                }
            }

            return references;
        }

    }
}
