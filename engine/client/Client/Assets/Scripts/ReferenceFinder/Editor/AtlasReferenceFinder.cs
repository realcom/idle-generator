
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEditor.U2D;
using UnityEngine;
using UnityEngine.UI;

namespace ReferenceFinder.Editor
{
    public class AtlasReferenceFinder : OdinEditorWindow
    {
        [MenuItem("UI/SpriteAtlas Reference 찾기")]
        public static AtlasReferenceFinder ShowWindow()
        {
            var window = GetWindow<AtlasReferenceFinder>();
            window.Show();
            return window;
        }

        private bool enabled => IsPrefabMode();
        private Color color => enabled ? Color.green : Color.white;
        private string buttonName => enabled ? "찾기" : "[프리팹] 모드에서 사용하는 걸 추천합니다.";

        // 첨엔 이걸로 하다가 아래 규격이 더 예뻐서 변경
        [LabelText("결과")]
        [HideInInspector]
        [TableList(AlwaysExpanded = true)]
        [SerializeField] List<Result> results;

        [LabelText("결과")]
        [TableList(AlwaysExpanded = true)]
        [SerializeField] private List<AtlasToSprite> result2;

        [Button("@buttonName", 40)]
        [GUIColor(nameof(color))]
        private void Find()
        {
            var empty = new UnityEngine.U2D.SpriteAtlas();
            empty.name = "아틀라스 없음";

            var atlases = AssetFinder.FindAll<UnityEngine.U2D.SpriteAtlas>();
            var spriteToAtlas = new Dictionary<Sprite, UnityEngine.U2D.SpriteAtlas>();

            foreach (var atlas in atlases)
            {
                foreach (var package in atlas.GetPackables())
                {
                    if (package is DefaultAsset asset)
                    {
                        var path = FindReferenceWindowMultiple.GetLocalPath(asset);
                        path = SumAsString(path.Skip("Assets/".Length), "");
                        var assets = AssetFinder.FindAllByPath<Sprite>(path);
                        foreach (var (_, sprite) in assets)
                        {
                            if (spriteToAtlas.ContainsKey(sprite))
                            {
                                Debug.LogError("------------------");
                                Debug.LogError("이미 추가되어 있는 Sprite " + sprite, sprite);
                                Debug.LogError("기존 Atlas " + spriteToAtlas[sprite], spriteToAtlas[sprite]);
                                Debug.LogError("새 Atlas " + atlas, atlas);
                                continue;
                            }
                            spriteToAtlas.Add(sprite, atlas);
                        }
                    }
                }
            }

            var all = HierarchyReferenceFinder.GetAllGameObjectPrefabOrScene();
            var images = all.SelectMany(x => x.GetComponents<Image>());
            results = new List<Result>();
            // 이미지마다 아틀라스를 구한다.
            foreach (var image in images)
            {
                if (image.sprite == null)
                {
                    Result r = Result.ByImage(empty, image);
                    results.Add(r);
                    continue;
                }

                var atlas = GetOrDefault(spriteToAtlas, image.sprite, empty);
                Result result = Result.ByImage(atlas, image);
                results.Add(result);
            }

            // 아틀라스를 쓰는 이미지 수를 구한다.
            var atlasResults = new List<Result>();
            atlasResults = new List<Result>();
            foreach (var gr in results.GroupBy(x => x.Atlas))
            {
                Result result = Result.ByAtlas(gr.Key, gr.Count());
                atlasResults.Add(result);
            }

            // 이미지 + 아틀라스 합쳐서 아틀라스 쓰는 이미지 수 순으로 정렬한다.
            atlasResults = atlasResults.OrderBy(x => x.Count).ToList();
            var index = atlasResults.Select(x => x.Atlas).ToArray();
            var atlasToIndex = index.ToDictionary(x => x, x => IndexOf(index, x));
            results.AddRange(atlasResults);
            results = (from x in results
                       orderby (atlasToIndex[x.Atlas], !x.IsAtlas(), x.SpriteName)
                       select x).ToList();

            // 보기에 예쁜 형태로 바꿈.
            result2?.Clear();
            result2 ??= new List<AtlasToSprite>();
            foreach (var gr in results.GroupBy(x => x.Atlas))
            {
                var elements = new List<Element>();
                foreach (var item in gr)
                {
                    if (item.Image == null)
                        continue;
                    Element element;
                    element.Image = item.Image;
                    element.Sprite = item.Sprite;
                    elements.Add(element);
                }

                AtlasToSprite result;
                result.Atlas = gr.Key;
                result.Elements = elements.ToArray();
                result.Count = elements.Count;
                result2.Add(result);
            }
        }

        private bool IsPrefabMode()
        {
            return UnityEditor.SceneManagement.PrefabStageUtility.GetCurrentPrefabStage() != null;
        }


        // from extensions
        public static string SumAsString<T>(IEnumerable<T> en, string sep = ", ")
        {
            var array = en as T[] ?? en.ToArray();
            if (array.Length == 0)
                return "";

            var builder = new StringBuilder();
            for (int i = 0; i < array.Length; i++)
            {
                var item = array[i];
                builder.Append(item);
                if (i != array.Length - 1)
                    builder.Append(sep);
            }

            return builder.ToString();
        }


        public static TValue GetOrDefault<TKey, TValue>(IReadOnlyDictionary<TKey, TValue> dict, TKey key, TValue defaultValue)
        {
            if (dict.ContainsKey(key))
                return dict[key];
            return defaultValue;
        }

        // IEnumerable용 IndexOf. 성능은 안 좋음
        public static int IndexOf<T>(IEnumerable<T> source, T value)
        {
            if (source == null)
            {
                Debug.LogError("source가 null이면 안 됨. value = " + value);
                return -1;
            }

            int index = 0;
            var comparer = EqualityComparer<T>.Default; // or pass in as a parameter
            foreach (T item in source.ToArray())
            {
                if (comparer.Equals(item, value))
                    return index;
                index++;
            }

            return -1;
        }
    }

    [Serializable]
    struct AtlasToSprite
    {
        public UnityEngine.U2D.SpriteAtlas Atlas;
        [TableColumnWidth(40, false)]
        public int Count;
        [TableList]
        public Element[] Elements;
    }

    [Serializable]
    public struct Element
    {
        public Image Image;

        [PreviewField(40)]
        [TableColumnWidth(40, false)]
        public Sprite Sprite;
    }

    [Serializable]
    struct Result
    {
        [GUIColor(nameof(color))]
        public UnityEngine.U2D.SpriteAtlas Atlas;

        [ShowIf(nameof(IsAtlas))]
        [GUIColor(nameof(color))]
        [TableColumnWidth(40, false)]
        public int Count;

        [GUIColor(nameof(color))]
        [HideIf(nameof(IsAtlas))]
        public Image Image;
        [GUIColor(nameof(color))]

        [PreviewField(40)]
        [TableColumnWidth(40, false)]
        [HideIf(nameof(IsAtlas))]
        public Sprite Sprite;

        public string SpriteName => Sprite == null ? "" : Sprite.name;

        private Color color => IsAtlas() ? new Color(1, 0.64f, 0) : Color.white;

        public static Result ByAtlas(UnityEngine.U2D.SpriteAtlas atlas, int count)
        {
            Result result = default;
            result.Atlas = atlas;
            result.Count = count;
            result.Sprite = null;
            return result;
        }

        public static Result ByImage(UnityEngine.U2D.SpriteAtlas atlas, Image image)
        {
            Result result = default;
            result.Atlas = atlas;
            result.Image = image;
            result.Sprite = image?.sprite;
            return result;
        }

        public bool IsAtlas() => Count != 0;
    }

}
