using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using System;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace ReferenceFinder.Editor
{
    [Serializable]
    public struct FindReferenceWindowOption
    {
        public string[] RootPaths;
        public string[] IgnorePaths;
    }

    public class FindReferenceWindowMultiple : OdinEditorWindow
    {
        private static FindReferenceWindowOption referenceOption = GetDefaultOption();

        public static void SetOption(FindReferenceWindowOption option)
        {
            referenceOption = option;
        }

        [Title("경로")]
        [ListDrawerSettings(DefaultExpandedState = true)]
        [FolderPath]
        public string[] RootPaths =
        {
            "Assets/",
        };

        [ListDrawerSettings(DefaultExpandedState = true)]
        [FolderPath]
        public string[] IgnorePaths =
        {
        };

        [Header("Find Path")]
        [HideLabel]
        public FileOrFolderPath Path;

        [Title("검색")]
        public AssetFindOption option;

        [Title("결과")]
        [ShowIf(nameof(existResult))]
        [PropertyOrder(999)][HideLabel][InlineProperty] public ReferenceFindResult result;
        private bool existNoReferences => existResult && result.NoReferences != null && 0 < result.NoReferences.Length;

        private Color colorResult => existResult ? Color.white : Color.green;
        private Color colorRemove => existNoReferences ? Color.red : Color.white;

        private bool existResult;

        private static FindReferenceWindowOption GetDefaultOption()
        {
            FindReferenceWindowOption option;
            option.RootPaths = new[] {
                "Assets/"
            };
            option.IgnorePaths = new string[0];
            return option;
        }

        [MenuItem("Window/Tools/Asset Reference/Find All References - Multiple")]
        public static void ShowWindow()
        {
            var window = GetWindow<FindReferenceWindowMultiple>();
            window.Show();
            window.Clear();
            window.option = new AssetFindOption();
        }

        [MenuItem("Assets/레퍼런스 찾기 (Projects)", false, 1)]
        public static void FindReferencesToAsset()
        {
            var selected = Selection.activeObject;
            if (!selected)
            {
                Debug.LogError("선택된 게임오브젝트가 없음.");
                return;
            }

            FileOrFolderPath path;

            if (selected is DefaultAsset folder)
                path = FileOrFolderPath.ByFolder(GetLocalPath(folder));
            else
                path = FileOrFolderPath.ByFile(selected);

            var window = GetWindow<FindReferenceWindowMultiple>();
            window.Show();
            window.Clear();
            window.Path = path;
            window.option = new AssetFindOption();
        }

        [GUIColor(nameof(colorResult))]
        [HorizontalGroup("Button", MaxWidth = 1)]
        [Button(ButtonHeight = 40)]
        public void Find()
        {
            var instance = new ReferenceHelperMultiple();
            result = instance.Find(Path, RootPaths, IgnorePaths, option);
            existResult = true;
        }

        private void Clear()
        {
            existResult = false;
            result = default;

            if (referenceOption.RootPaths != null && referenceOption.RootPaths.Length > 0)
                RootPaths = referenceOption.RootPaths;

            IgnorePaths = referenceOption.IgnorePaths;
        }

        [GUIColor(nameof(colorRemove))]
        [HorizontalGroup("Button", MaxWidth = 0, Width = 60)]
        [Button(ButtonHeight = 40)]
        [EnableIf(nameof(existNoReferences))]
        public void Remove()
        {
            var removes = result.NoReferences.Where(x => x.X);
            var paths = removes.Select(x => AssetDatabase.GetAssetPath(x.Object)).ToArray();
            if (!EditorUtility.DisplayDialog("경고", $"{paths.Length}개의 파일을 지우시나요?", "네", "아니요"))
                return;
            foreach (var path in paths)
                AssetDatabase.DeleteAsset(path);
            AssetDatabase.Refresh();
            AssetDatabase.SaveAssets();
            result.NoReferences = new ReferenceNoResult[0];
        }

        /// <summary> 폴더 애셋으로부터 Assets로 시작하는 로컬 경로 얻기 </summary>
        public static string GetLocalPath(DefaultAsset folder)
        {
            bool success =
                AssetDatabase.TryGetGUIDAndLocalFileIdentifier(folder, out string guid, out long _);

            if (success)
                return AssetDatabase.GUIDToAssetPath(guid);
            else
                return null;
        }

        [Button(ButtonSizes.Small, Name = "새 창")]
        [PropertyOrder(-1)]
        [HorizontalGroup("Option", width: 60)]
        private void 새창으로열기()
        {
            var window = CreateWindow<FindReferenceWindowMultiple>();
            window.Show();
            window.Clear();
        }

    }
}

