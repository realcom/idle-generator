using System;
using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace ReferenceFinder.Editor
{
    public class ImageFinderWindow : OdinEditorWindow
    {
        [Serializable]
        private struct Result
        {
            public Image Image;

            public GameObject Prefab;

            [ShowIf(nameof(Prefab))]
            [Button("[프리팹] 들어가기")]
            public void EnterPrefab()
            {
                var path = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(Prefab);
                var prefabAsset = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                var instance = ShowWindow();
                instance.EnterPrefab(prefabAsset);
            }
        }

        [MenuItem("UI/RaycastTarget Image 찾기")]
        public static ImageFinderWindow ShowWindow()
        {
            var window = GetWindow<ImageFinderWindow>();
            window.Show();
            return window;
        }

        [TableList(AlwaysExpanded = true)]
        [SerializeField] private Result[] results;

        [HideInInspector]
        [SerializeField] private Result[] cached;

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
            var all = HierarchyReferenceFinder.GetAllComponentsInPrefabOrScene<Image>();
            var images = all.Where(x => x.raycastTarget);
            var results = new List<Result>();
            Image latest = null;
            foreach (var image in images)
            {
                Result result;
                result.Image = image;
                result.Prefab = MissingReferenceFinder.GetPrefabRoot(image);
                results.Add(result);
                if (result.Prefab == null)
                    latest = image;
            }

            if (latest != null)
                GameObjectPicker.Pick(latest.gameObject);
            this.results = results.ToArray();
        }
    }
}
