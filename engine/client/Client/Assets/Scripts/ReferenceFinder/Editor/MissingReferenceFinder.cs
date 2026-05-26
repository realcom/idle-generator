using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace ReferenceFinder.Editor
{
    public class MissingReferenceFinder : OdinEditorWindow
    {
        [MenuItem("UI/Missing Reference 찾기")]
        public static MissingReferenceFinder ShowWindow()
        {
            var window = GetWindow<MissingReferenceFinder>();
            window.Show();
            return window;
        }

        [EnumToggleButtons]
        [SerializeField]
        private FindType type;

        [Header("바꿀 Sprite")]
        [SerializeField]
        private Sprite sprite;

        [TableList(AlwaysExpanded = true)]
        [SerializeField] public MissingReferenceResult[] results;

        [HideInInspector]
        [SerializeField] private MissingReferenceResult[] cached;

        private bool existResult => results != null && results.Length != 0;
        private HashSet<Sprite> defaultSprites;
        private bool existNone;

        private bool IsPrefabMode()
        {
            return PrefabStageUtility.GetCurrentPrefabStage() != null;
        }

        private string GetButtonName()
        {
            if (IsPrefabMode())
                return "현재 프리팹에서 찾기";
            return "현재 씬에서 찾기";
        }

        public void EnterPrefab(GameObject asset)
        {
            AssetDatabase.OpenAsset(asset);
            cached = results;
            Find();
        }

        [Button("[씬] 돌아가기")]
        [ShowIf(nameof(IsPrefabMode))]
        private void BackScene()
        {
            results = cached;
            cached = null;
            StageUtility.GoBackToPreviousStage();
        }

        [GUIColor(0, 1, 0)]
        [Button("@GetButtonName()", 40)]
        public void Find()
        {
            existNone = defaultSprites.Any(x => x == null);
            var all = HierarchyReferenceFinder.GetAllComponentsInPrefabOrScene<Image>();
            var missings = all.Where(IsMissing);
            var results = new List<MissingReferenceResult>();
            Image latest = null;
            foreach (var missing in missings)
            {
                MissingReferenceResult result;
                result.Prefab = GetPrefabRoot(missing);
                result.Image = missing;
                result.Sprite = missing?.sprite;
                results.Add(result);
                if (result.Prefab == null)
                    latest = missing;
            }

            if (latest != null)
                GameObjectPicker.Pick(latest.gameObject);
            this.results = results.ToArray();
        }


        public static bool IsPrefabInstance(GameObject obj)
        {
            return PrefabUtility.GetPrefabInstanceStatus(obj) != PrefabInstanceStatus.NotAPrefab;
            // https://answers.unity.com/questions/218429/how-to-know-if-a-gameobject-is-a-prefab.html
            // return PrefabUtility.GetPrefabParent(obj) != null &&
            //        PrefabUtility.GetPrefabObject(obj) != null;
        }

        public static GameObject GetPrefabRoot(Component component)
        {
            var transform = component.transform;
            if (IsPrefabInstance(transform.gameObject))
                return PrefabUtility.GetNearestPrefabInstanceRoot(transform.gameObject);
            return null;
        }

        private bool IsMissing(Image image)
        {
            try
            {
                if (type == FindType.Custom)
                {
                    if (existNone && image.sprite == null)
                        return true;
                    return defaultSprites.Contains(image.sprite);
                }

                var _ = image.sprite.name;
            }
            catch (MissingReferenceException) // General Object like GameObject/Sprite etc
            {
                return type == FindType.Missing;
            }
            catch (MissingComponentException) // Specific for objects of type Component
            {
                return type == FindType.Missing;
            }
            catch
            {
                // ignored
            }

            return false;
        }

        [GUIColor(1, 0, 0)]
        [ShowIf(nameof(existResult))]
        [Button("전부 바꾸기", 20)]
        public void UpdateAll()
        {
            if (!EditorUtility.DisplayDialog(
                    "경고",
                    $"진짜로 모든 이미지를 {sprite.name}으로 바꾸나요?",
                    "네",
                    "ㄴㄴ"
                ))
                return;

            EditorUtility.ClearProgressBar();
            for (var i = 0; i < results.Length; i++)
            {
                var result = results[i];
                if (EditorUtility.DisplayCancelableProgressBar(
                        "바꾸는 중",
                        $"{i}/{results.Length}",
                        (float)i / results.Length
                    ))
                    break;
                if (result.Prefab != null)
                    UpdateSprite(result.Prefab);
            }

            EditorUtility.ClearProgressBar();
            Find();
        }

        private void UpdateSprite(GameObject prefab)
        {
            var path = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(prefab);
            var contentRoot = PrefabUtility.LoadPrefabContents(path);
            var images = contentRoot.GetComponentsInChildren<Image>(true);
            foreach (var image in images)
                if (IsMissing(image))
                    image.sprite = sprite;

            PrefabUtility.SaveAsPrefabAsset(contentRoot, path);
            PrefabUtility.UnloadPrefabContents(contentRoot);
        }
    }

    internal enum FindType
    {
        Missing,
        Custom
    }

    [Serializable]
    public struct MissingReferenceResult
    {
        public Image Image;

        public Sprite Sprite;

        [ShowIf("Prefab")]
        public GameObject Prefab; // 씬에 있는 오브젝트

        [TableColumnWidth(120, false)]
        [ShowIf(nameof(Prefab))]
        [Button("[프리팹] 들어가기")]
        public void EnterPrefab()
        {
            var path = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(Prefab);
            var prefabAsset = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            var instance = MissingReferenceFinder.ShowWindow();
            instance.EnterPrefab(prefabAsset);
        }
    }
}