using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace ReferenceFinder.Editor
{
    public enum FileOrFolderType
    {
        Folder,
        File
    }

    public struct FileOrFolderPath
    {
        [HorizontalGroup("Group", Width = 150)]
        [EnumToggleButtons]
        [HideLabel]
        public FileOrFolderType Type;

        [FolderPath]
        [HideLabel]
        [HorizontalGroup("Group")]
        [ShowIf(nameof(Type), FileOrFolderType.Folder)]
        public string FolderPath;

        [HideLabel]
        [HorizontalGroup("Group")]
        [ShowIf(nameof(Type), FileOrFolderType.File)]
        public Object File;

        public static FileOrFolderPath ByFile(Object file)
        {
            return new FileOrFolderPath
            {
                Type = FileOrFolderType.File,
                File = file
            };
        }

        public static FileOrFolderPath ByFolder(string path)
        {
            return new FileOrFolderPath
            {
                Type = FileOrFolderType.Folder,
                FolderPath = path
            };
        }
    }


    [Serializable]
    public struct ReferenceFindResult
    {
        [ShowInInspector]
        [PropertyOrder(-1)]
        public string 걸린시간 => $"{Elapsed.TotalSeconds}초 ({fileCount}개)";

        public TimeSpan Elapsed;

        [HideInInspector]
        public int fileCount;

        [LabelText("레퍼런스 없음")]
        [TableList(AlwaysExpanded = true, IsReadOnly = true)]
        public ReferenceNoResult[] NoReferences;

        [LabelText("에셋번들에 쓰이는 중")]
        [ListDrawerSettings(HideRemoveButton = true, IsReadOnly = true, DefaultExpandedState = true, ShowPaging = false)]
        public Object[] Bundled;

        [LabelText("레퍼런스 목록")]
        [TableList(AlwaysExpanded = true, IsReadOnly = true)]
        [ListDrawerSettings(HideRemoveButton = true, IsReadOnly = true, DefaultExpandedState = true, ShowPaging = false)]
        public ReferenceInfo[] References;
    }

    [Serializable]
    public struct ReferenceInfo
    {
        [PropertyOrder(-1)]
        [ShowInInspector]
        public string 이름 => 에셋.name;

        [TableColumnWidth(60, false)]
        [PreviewField(Height = 60)]
        public Object 에셋;

        public Object 쓰는곳;
    }

    [Serializable]
    public struct ReferenceNoResult
    {
        [TableColumnWidth(18, false)]
        public bool X;
        public Object Object;

        [TableColumnWidth(80, false)]
        [Button]
        public void Single()
        {
            ReferenceHelper.Find(
                "Assets",
                Object,
                ReferenceHelperMultiple.option
            );
        }

        public static ReferenceNoResult ByObject(Object obj)
        {
            return new ReferenceNoResult
            {
                X = true,
                Object = obj
            };
        }
    }

    [Serializable]
    public class ReferenceHelperMultiple
    {
        private static Type[] ignoreTypes =
        {
            typeof(DefaultAsset),
            typeof(UnityEngine.U2D.SpriteAtlas)
        };

        public static AssetFindOption option;

        // TargetPath = 어떤 오브젝트들을 검색할지
        // sourceRootPath = 어디에 있는 애들이 레퍼런스가 있는지
        public ReferenceFindResult Find(
            FileOrFolderPath fileOrFolder,
            string[] sourceRootPath,
            string[] sourceIgnorePath,
            AssetFindOption option
        )
        {
            var startsAt = DateTime.Now;

            ReferenceHelperMultiple.option = option;

            Object[] targets;
            if (fileOrFolder.Type == FileOrFolderType.Folder)
                targets = FindAllChildrenByPath(fileOrFolder.FolderPath);
            else
                targets = new[] { fileOrFolder.File };

            var targetGUIds = new Dictionary<string, Object>();
            foreach (var target in targets)
            {
                var guid = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(target));
                if (string.IsNullOrEmpty(guid))
                    continue;
                targetGUIds.Add(guid, target);
            }
            string[] guids = targetGUIds.Keys.ToArray();

            var allAssetPath = FindAllPath(sourceRootPath, sourceIgnorePath, option);
            var results = new List<ReferenceInfo>();
            try
            {
                for (var i = 1; i <= allAssetPath.Length; i++)
                {
                    var path = allAssetPath[i - 1];

                    if (path.EndsWith(".fbx") || path.EndsWith(".FBX"))
                        path = $"{path}.meta";

                    if (EditorUtility.DisplayCancelableProgressBar(
                        $"{i}/{allAssetPath.Length}",
                        path,
                        (float)i / allAssetPath.Length
                    ))
                        break;

                    var file = File.ReadAllText(path);

                    for (var j = 0; j < guids.Length; j++)
                    {
                        var guid = guids[j];
                        if (!file.Contains(guid))
                            continue;
                        ReferenceInfo reference;
                        reference.쓰는곳 = AssetDatabase.LoadMainAssetAtPath(path);
                        reference.에셋 = targetGUIds[guid];
                        results.Add(reference);
                    }
                }
            }

            catch (Exception e)
            {
                Debug.LogException(e);
            }

            finally
            {
                EditorUtility.ClearProgressBar();
            }

            var references = results.OrderBy(x => x.에셋.name).ToArray();
            var founds = references.Select(x => x.에셋).Distinct();
            var noRefs = targets.Except(founds).ToArray();
            var bundled = noRefs.Where(IsBundledAsset).ToArray();
            noRefs = noRefs.Except(bundled).ToArray();

            ReferenceFindResult result;
            result.Elapsed = DateTime.Now - startsAt;
            result.References = references;
            result.NoReferences =
                noRefs.Select(ReferenceNoResult.ByObject).ToArray();
            result.Bundled = bundled.ToArray();
            result.fileCount = allAssetPath.Length;
            return result;
        }

        private bool IsBundledAsset(Object obj)
        {
            var path = AssetDatabase.GetAssetPath(obj);
            var importer = AssetImporter.GetAtPath(path);
            return !string.IsNullOrEmpty(importer.assetBundleName);
        }

        private Object[] FindAllChildrenByPath(string path)
        {
            var assets = new List<Object>();
            var guids = AssetDatabase.FindAssets("", new[] { path });
            foreach (var guid in guids.Distinct())
            {
                var assetPath = AssetDatabase.GUIDToAssetPath(guid);
                var asset = AssetDatabase.LoadAssetAtPath<Object>(assetPath);
                if (ignoreTypes.Contains(asset.GetType()))
                    continue;
                assets.Add(asset);
            }

            return assets.ToArray();
        }

        private static string[] FindAllPath(
            string[] rootPaths,
            string[] ignorePaths,
            AssetFindOption option
        )
        {
            return rootPaths.SelectMany(x => ReferenceHelper.FindAllPath(x, option, ignorePaths)).ToArray();
        }

    }
}
