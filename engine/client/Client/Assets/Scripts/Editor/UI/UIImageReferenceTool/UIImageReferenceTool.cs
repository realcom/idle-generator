// Assets/Editor/UIImageReferenceToolManager.cs
#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;

public class UIImageReferenceTool : OdinEditorWindow
{
    [MenuItem("Tools/UI/Image Reference Tool")]
    public static void Open()
    {
        var w = GetWindow<UIImageReferenceTool>();
        w.titleContent = new GUIContent("UI Image Ref Tool");
        w.Show();
    }

    // -------- Targets --------
    [BoxGroup("Targets")]
    [InfoBox("프리팹 에셋(GameObject) 1개만 지정하세요. (씬 인스턴스 X)", InfoMessageType.Info)]
    [AssetsOnly, Required, LabelText("Prefab Asset")]
    public GameObject prefabAsset;

    [BoxGroup("Targets")]
    [InlineEditor(InlineEditorObjectFieldModes.Boxed)]
    [Required, LabelText("Reference Set (ScriptableObject)")]
    public UIImageReferenceSet referenceSet;

    // -------- Selected Images (Odin 기본 리스트) --------
    [BoxGroup("Selected Images")]
    [ShowInInspector, ListDrawerSettings(Expanded = true)]
    [OnValueChanged(nameof(SanitizeSelectedImages), InvokeOnUndoRedo = true)]
    [OnCollectionChanged(nameof(SanitizeSelectedImages))]
    private List<Image> selectedImages = new List<Image>();

    // ================= Actions =================

    [BoxGroup("Actions"), HorizontalGroup("Actions/Row1")]
    [Button("Save Selected → Set", ButtonSizes.Large), GUIColor(0.65f, 1f, 0.65f)]
    [EnableIf("@referenceSet != null && selectedImages.Count > 0")]
    public void SaveSelectedToSet()
    {
        SanitizeSelectedImages();
        if (referenceSet == null) { Debug.LogError("ReferenceSet 없음"); return; }
        if (prefabAsset == null)  { Debug.LogError("Prefab 없음"); return; }

        string prefabPath = AssetDatabase.GetAssetPath(prefabAsset);
        var entries = new List<UIImageReferenceSet.Entry>();
        int saved = 0, skipped = 0;

        foreach (var img in selectedImages)
        {
            if (!TryResolvePrefabPathAndRelPath(img, out var resolvedPath, out var relPath))
            { skipped++; continue; }
            if (resolvedPath != prefabPath) { skipped++; continue; }

            // 에셋 측 Image를 찾아 localFileID 확보
            var assetImage = FindAssetSideImageByRelPath(prefabPath, relPath);
            long localId = 0;
            if (assetImage != null &&
                AssetDatabase.TryGetGUIDAndLocalFileIdentifier(assetImage, out _, out long lid))
            {
                localId = lid;
            }

            entries.Add(new UIImageReferenceSet.Entry
            {
                transformPath = relPath,
                localFileId   = localId,   // 0이면 경로 폴백만 사용
                objectName    = img.gameObject.name,
                sprite        = img.sprite
            });
            saved++;
        }

        referenceSet.entries = entries;
        EditorUtility.SetDirty(referenceSet);
        AssetDatabase.SaveAssets();
        Debug.Log($"[UI Image Ref Tool] 저장 완료: {saved}개 (스킵 {skipped})");
    }

    [HorizontalGroup("Actions/Row1")]
    [Button("Clear Selected", ButtonSizes.Large), GUIColor(1f, 0.6f, 0.6f)]
    [EnableIf("@selectedImages.Count > 0")]
    public void ClearSelected()
    {
        SanitizeSelectedImages();
        if (prefabAsset == null) { Debug.LogError("Prefab 없음"); return; }

        var rootT = GetPrefabRootTransformForEditing();
        if (!rootT) { Debug.LogError("프리팹 루트를 찾지 못했습니다."); return; }

        // 현재(스테이지/에셋) 트리 기준: 경로 → Image 맵
        var path2Target = new Dictionary<string, Image>();
        foreach (var img in rootT.GetComponentsInChildren<Image>(true))
        {
            var rel = GetRelativePathToRoot(img.transform, rootT);
            path2Target[rel ?? string.Empty] = img;
        }

        var prefabPath = AssetDatabase.GetAssetPath(prefabAsset);
        int cleared = 0;

        foreach (var sel in selectedImages)
        {
            if (sel == null) continue;

            // 선택 항목의 현재 프리팹 상대경로를 계산
            if (!TryResolvePrefabPathAndRelPath(sel, out var resolvedPath, out var relPath)) continue;
            if (resolvedPath != prefabPath) continue;

            if (!string.IsNullOrEmpty(relPath) && path2Target.TryGetValue(relPath, out var target) && target)
            {
                Undo.RecordObject(target, "Clear Image sprite");
                target.sprite = null;
                target.SetAllDirty();
                EditorUtility.SetDirty(target);
                cleared++;
            }
        }

        CommitAndRepaint(rootT, cleared > 0);
        Debug.Log($"[UI Image Ref Tool] Clear 완료: {cleared}개");
    }

    // 프리팹 전체 복원: ID 우선 → 경로 폴백, Prefab Mode 즉시 반영
    [BoxGroup("Actions")]
    [Button("Restore From Set (Whole Prefab)", ButtonSizes.Large), GUIColor(1f, 0.9f, 0.6f)]
    [EnableIf("@referenceSet != null && prefabAsset != null")]
    public void RestoreFromSet_WholePrefab()
    {
        if (referenceSet == null || prefabAsset == null)
        {
            Debug.LogError("Prefab/ReferenceSet이 비어있습니다.");
            return;
        }

        var prefabPath = AssetDatabase.GetAssetPath(prefabAsset);

        // Prefab Mode면 스테이지 루트, 아니면 에셋 루트(즉시/비즉시 반영 차이)
        var rootT = GetPrefabRootTransformForEditing();
        if (!rootT)
        {
            Debug.LogError("프리팹 루트를 찾지 못했습니다.");
            return;
        }

        // 현재(스테이지/에셋) 트리 기준: 경로 → Image 맵
        var path2Target = new Dictionary<string, Image>();
        foreach (var img in rootT.GetComponentsInChildren<Image>(true))
        {
            var rel = GetRelativePathToRoot(img.transform, rootT);
            path2Target[rel ?? string.Empty] = img;
        }

        // 에셋(.prefab) 기준: localID → 최신 상대경로 맵
        var id2RelPathInAsset = BuildAssetLocalIdToRelPathMap(prefabPath);

        int hit = 0, miss = 0, refreshedPath = 0;

        foreach (var e in referenceSet.entries)
        {
            // 1) 항상 최신 경로로 자동 갱신: localID 있으면 에셋에서 최신 경로로 덮어씀
            string rel = e.transformPath;
            if (e.localFileId != 0 && id2RelPathInAsset.TryGetValue(e.localFileId, out var relNow))
            {
                if (e.transformPath != relNow)
                {
                    e.transformPath = relNow; // 자동 갱신
                    refreshedPath++;
                    EditorUtility.SetDirty(referenceSet);
                }

                rel = relNow;
            }

            // 2) 스테이지/에셋 트리에서 경로 매칭 후 즉시 적용
            if (!string.IsNullOrEmpty(rel) && path2Target.TryGetValue(rel, out var target) && target)
            {
                Undo.RecordObject(target, "Restore Image sprite");
                target.sprite = e.sprite;
                target.SetAllDirty();
                EditorUtility.SetDirty(target);
                hit++;
            }
            else
            {
                miss++;
                // 필요시: Debug.LogWarning($"Restore miss: id={e.localFileId}, rel='{e.transformPath}'");
            }
        }

        // 저장/리페인트
        if (refreshedPath > 0) AssetDatabase.SaveAssets();
        CommitAndRepaint(rootT, hit > 0);

        Debug.Log($"[UI Image Ref Tool] Restore → 성공 {hit}, 실패 {miss}, 경로 자동 갱신 {refreshedPath}");
    }

    // 세트에서 "이 프리팹 것만" Selected로 로드: ID 우선 → 경로 폴백
    [BoxGroup("Actions")]
    [Button("Load Selected From Set (이 프리팹 것만)", ButtonSizes.Medium)]
    [EnableIf("@referenceSet != null && prefabAsset != null")]
    public void LoadSelectedFromSetOnly()
    {
        if (referenceSet == null || prefabAsset == null)
        {
            Debug.LogError("Prefab/Set 없음");
            return;
        }

        var prefabPath = AssetDatabase.GetAssetPath(prefabAsset);

        // (A) Prefab Mode가 열려 있으면 스테이지 루트, 아니면 에셋 루트
        var rootT = GetPrefabRootTransformForEditing();
        if (!rootT)
        {
            Debug.LogError("프리팹 루트를 찾지 못했습니다.");
            return;
        }

        // (B) 현재 루트 기준 경로 → Image 맵 (스테이지에 바로 선택 추가하려고)
        var path2Target = new Dictionary<string, Image>();
        foreach (var img in rootT.GetComponentsInChildren<Image>(true))
        {
            var rel = GetRelativePathToRoot(img.transform, rootT);
            path2Target[rel ?? string.Empty] = img;
        }

        // (C) 에셋(.prefab)에서 localFileID → 최신 상대경로 맵 구성
        var id2RelPathInAsset = BuildAssetLocalIdToRelPathMap(prefabPath);

        int added = 0, refreshedPath = 0;

        foreach (var e in referenceSet.entries)
        {
            // 1) localID가 있으면 에셋에서 "현재 경로"를 우선 얻는다
            string rel = null;
            if (e.localFileId != 0 && id2RelPathInAsset.TryGetValue(e.localFileId, out var relNow))
            {
                rel = relNow;

                // 세트에 저장된 경로가 오래되었으면 최신 경로로 갱신 (옵션이지만 강추)
                if (e.transformPath != relNow)
                {
                    e.transformPath = relNow;
                    refreshedPath++;
                    EditorUtility.SetDirty(referenceSet);
                }
            }

            // 2) localID가 없거나(구버전) 못 찾았으면, 기존 transformPath로 폴백
            if (rel == null) rel = e.transformPath;

            // 3) 스테이지/에셋 트리에서 경로 매칭
            if (!string.IsNullOrEmpty(rel) &&
                path2Target.TryGetValue(rel, out var img) &&
                img != null &&
                !selectedImages.Contains(img))
            {
                selectedImages.Add(img);
                added++;
            }
        }

        // 리스트 한 번 정리(경로 중복/유효성)
        SanitizeSelectedImages();

        // 경로 최신화가 있었으면 세트 저장
        if (refreshedPath > 0) AssetDatabase.SaveAssets();

        Debug.Log($"[UI Image Ref Tool] Set→Selected 로드: 추가 {added}개, 경로 최신화 {refreshedPath}개 (Prefab: {prefabAsset.name})");
    }

    // ================= Helpers =================

    //프리팹 에셋 경로(prefabPath)에서 Image 컴포넌트들을 스캔해
    //localFileID -> "Child/Sub" (루트 제외 상대경로) 맵을 만든다.
    private Dictionary<long, string> BuildAssetLocalIdToRelPathMap(string prefabPath)
    {
        var map = new Dictionary<long, string>();
        if (string.IsNullOrEmpty(prefabPath)) return map;

        // 프리팹 내부의 모든 서브에셋(Object)을 로드 (GameObject/Component 포함)
        var all = AssetDatabase.LoadAllAssetsAtPath(prefabPath);
        if (all == null || all.Length == 0) return map;

        foreach (var obj in all)
        {
            if (obj is Image img)
            {
                // 에셋 측 컴포넌트의 localFileID 추출
                if (AssetDatabase.TryGetGUIDAndLocalFileIdentifier(img, out _, out long lid) && lid != 0)
                {
                    // 에셋 트리에서 루트 Transform 계산 (부모가 null인 Transform까지 올라감)
                    var leaf = img.transform;
                    var top = leaf;
                    while (top && top.parent != null) top = top.parent;

                    // 루트 기준 상대경로 ("Child/Sub"), 루트 자신이면 ""
                    var rel = GetRelativePathToRoot(leaf, top);
                    map[lid] = rel ?? string.Empty;
                }
            }
        }
        return map;
    }
    
    private Transform GetPrefabRootTransformForEditing()
    {
        if (prefabAsset == null) return null;

        var assetPath = AssetDatabase.GetAssetPath(prefabAsset);
        var stage = PrefabStageUtility.GetCurrentPrefabStage();

        if (stage != null && stage.assetPath == assetPath && stage.prefabContentsRoot != null)
        {
            // Prefab Mode에서 편집 중: 스테이지 루트 반환 (즉시 반영 경로)
            return stage.prefabContentsRoot.transform;
        }

        // Prefab Mode가 아니면 에셋 루트 반환 (씬에는 즉시 안 보이지만 에셋은 변경됨)
        var assetGO = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
        return assetGO != null ? assetGO.transform : null;
    }
    

    // Prefab Mode면 스테이지 더럽힘, 아니면 에셋 저장 + 전 뷰 리페인트
    private void CommitAndRepaint(Transform editedRoot, bool anyChanged)
    {
        if (!anyChanged) return;

        var stage = PrefabStageUtility.GetCurrentPrefabStage();
        if (stage != null && editedRoot != null && stage.prefabContentsRoot == editedRoot.gameObject)
        {
            EditorSceneManager.MarkSceneDirty(stage.scene);
        }
        else
        {
            AssetDatabase.SaveAssets();
        }

        // 레이아웃/그래픽 강제 업데이트
        Canvas.ForceUpdateCanvases();
        UnityEditorInternal.InternalEditorUtility.RepaintAllViews();
        SceneView.RepaintAll();
    }

    // 리스트 유효성/중복 정리 (prefab 경로 일치 + '상대경로' 기반 유니크)
    private void SanitizeSelectedImages()
    {
        if (selectedImages == null) return;

        if (prefabAsset == null)
        {
            for (int i = selectedImages.Count - 1; i >= 0; i--)
                if (!TryResolvePrefabPathAndRelPath(selectedImages[i], out _, out _))
                    selectedImages.RemoveAt(i);
            return;
        }

        var prefabPath = AssetDatabase.GetAssetPath(prefabAsset);
        var seenPath = new HashSet<string>();

        for (int i = selectedImages.Count - 1; i >= 0; i--)
        {
            var img = selectedImages[i];
            if (!TryResolvePrefabPathAndRelPath(img, out var resolvedPath, out var relPath)
                || resolvedPath != prefabPath)
            {
                selectedImages.RemoveAt(i);
                continue;
            }

            var key = relPath ?? string.Empty;
            if (!seenPath.Add(key))
                selectedImages.RemoveAt(i);
        }
    }

    // 선택된 Image가 현재 지정 프리팹에 속하는지 확인하고 "루트 제외 상대경로"를 구함
    private bool TryResolvePrefabPathAndRelPath(Image img, out string prefabPath, out string relPath)
    {
        prefabPath = null; relPath = null;
        if (img == null || prefabAsset == null) return false;

        prefabPath = AssetDatabase.GetAssetPath(prefabAsset);
        if (string.IsNullOrEmpty(prefabPath)) return false;

        // Prefab Stage (열려 있을 때)
        var stage = PrefabStageUtility.GetPrefabStage(img.gameObject);
        if (stage != null && stage.assetPath == prefabPath)
        {
            relPath = GetRelativePathToRoot(img.transform, stage.prefabContentsRoot.transform);
            return relPath != null;
        }

        // 씬의 프리팹 인스턴스
        var instRoot = PrefabUtility.GetNearestPrefabInstanceRoot(img.gameObject);
        if (instRoot != null)
        {
            var instPath = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(img.gameObject);
            if (!string.IsNullOrEmpty(instPath) && instPath == prefabPath)
            {
                relPath = GetRelativePathToRoot(img.transform, instRoot.transform);
                return relPath != null;
            }
        }

        // 에셋에서 직접 드래그
        var objPath = AssetDatabase.GetAssetPath(img);
        if (!string.IsNullOrEmpty(objPath) && objPath == prefabPath)
        {
            // 최상위 루트(부모 null)를 루트로
            var top = img.transform;
            while (top.parent != null) top = top.parent;
            relPath = GetRelativePathToRoot(img.transform, top);
            return relPath != null;
        }

        return false;
    }

    // 프리팹 에셋에서 상대경로로 Image 찾기 (Save 때 에셋 localID 확보용)
    private Image FindAssetSideImageByRelPath(string prefabPath, string relPath)
    {
        var rootGO = AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        if (rootGO == null) return null;

        var rootT = rootGO.transform;
        if (string.IsNullOrEmpty(relPath)) // 루트 자신
            return rootT.GetComponent<Image>();

        var t = rootT.Find(relPath);
        return t ? t.GetComponent<Image>() : null;
    }

    // 루트 기준 상대경로("Child/Sub") 계산
    private static string GetRelativePathToRoot(Transform leaf, Transform prefabRoot)
    {
        if (leaf == null || prefabRoot == null) return null;
        var stack = new Stack<string>();
        var cur = leaf;

        while (cur != null && cur != prefabRoot)
        {
            stack.Push(cur.name);
            cur = cur.parent;
        }
        if (cur != prefabRoot) return null; // 루트 밖

        return stack.Count == 0 ? string.Empty : string.Join("/", stack);
    }
}
#endif
