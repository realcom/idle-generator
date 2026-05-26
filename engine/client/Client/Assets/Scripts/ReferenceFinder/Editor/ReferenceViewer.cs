using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace ReferenceFinder.Editor
{
    public class ReferenceViewer : EditorWindow
    {
        [SerializeField]
        private Texture2D m_SearchIcon;
        [SerializeField]
        private Texture2D m_SearchIconPro;

        private static ReferenceViewer m_Window;

        private static List<Object> m_ReferencedObjects = new List<Object>();
        private static IDictionary<Object, IDictionary<Object, List<SerializedProperty>>> m_ReferencesList;

        private static bool m_TargetingAsset;
        private static int m_ReferenceFindType; // 0 for scene, 1 for assets
        private static Vector2 m_ScrollPosition;

        private static GUIStyle m_ReferenceButtonStyle;
        private static GUIStyle m_RowStyle;
        private static GUIStyle m_PropertyLabelStyle;

        private static Texture2D SearchIcon
        {
            get { return EditorGUIUtility.isProSkin ? m_Window.m_SearchIconPro : m_Window.m_SearchIcon; }
        }

        private static void CreateWindow()
        {
            m_Window = GetWindow<ReferenceViewer>(false, "References", true);
        }

        private void OnGUI()
        {
            if (m_ReferenceButtonStyle == null)
                CreateStyles();

            m_ScrollPosition = EditorGUILayout.BeginScrollView(m_ScrollPosition);

            var changed = false;
            GUILayout.Label("Find references to:");
            for (int i = 0; i < m_ReferencedObjects.Count; i++)
            {
                var newObj = EditorGUILayout.ObjectField(m_ReferencedObjects[i], typeof(Object), true);
                if (newObj != m_ReferencedObjects[i])
                {
                    changed = true;
                    m_ReferencedObjects[i] = newObj;
                }
            }

            if (changed)
                SetReferencedObjects(m_ReferencedObjects.ToArray());


            // var referenced = EditorGUILayout.ObjectField(m_ReferencedObject, typeof(Object), true);
            // if (referenced != m_ReferencedObject)
            // {
            // 	SetReferencedObject(referenced);
            // }

            if (m_TargetingAsset)
            {
                GUILayout.Space(5);
                int oldFindType = m_ReferenceFindType;
                m_ReferenceFindType = GUILayout.SelectionGrid(m_ReferenceFindType,
                    new[] { "Find in scene", "Find in assets" }, 2, GUILayout.Height(20));
                if (oldFindType != m_ReferenceFindType)
                    FindReferences();
            }

            if (ReferenceFinder.DoingAsyncWork)
                DrawProgressBar();

            if (m_ReferencesList != null && !ReferenceFinder.DoingAsyncWork)
            {
                GUILayout.Label("No references List : ");
                foreach (var obj in m_ReferencedObjects)
                {
                    if (m_ReferencesList[obj].Count == 0)
                        GUILayout.Label(obj.name);
                }
                EditorGUILayout.Separator();
            }

            if (m_ReferencesList != null && m_ReferencesList.Any())
                DrawReferences();

            EditorGUILayout.EndScrollView();
        }

        private static void CreateStyles()
        {
            m_ReferenceButtonStyle = new GUIStyle(GUI.skin.button);
            m_ReferenceButtonStyle.alignment = TextAnchor.MiddleLeft;
            const int paddingSize = 5;
            var padding = new RectOffset(paddingSize, paddingSize, paddingSize, paddingSize);
            m_ReferenceButtonStyle.padding = padding;
            m_ReferenceButtonStyle.margin = padding;
            m_ReferenceButtonStyle.richText = true;

            m_RowStyle = new GUIStyle(GUI.skin.box);
            m_RowStyle.padding = padding;
            m_RowStyle.margin = padding;
            m_RowStyle.margin.top = 0;

            m_PropertyLabelStyle = new GUIStyle(GUI.skin.label);
            m_PropertyLabelStyle.richText = true;
        }

        private void DrawReferences()
        {
            GUILayout.Space(5);
            GUILayout.Label("References :");



            foreach (var obj in m_ReferencedObjects)
            {
                EditorGUILayout.LabelField(obj.name);
                var references = m_ReferencesList[obj];

                var filtered = references.Where(FilterProperties);
                var groups = filtered.GroupBy(e =>
                    {
                        var component = e.Key as Component;
                        return component != null ? component.gameObject : e.Key;
                    })
                    .Select(g => new { Parent = g.Key, Children = g.Select(p => p) })
                    .ToArray();

                foreach (var group in groups)
                {
                    EditorGUILayout.BeginVertical(m_RowStyle);

                    var parent = group.Parent;
                    var children = group.Children;

                    EditorGUILayout.BeginHorizontal();
                    var buttonContent = EditorGUIUtility.ObjectContent(parent, parent.GetType());
                    if (GUILayout.Button(buttonContent, m_ReferenceButtonStyle, GUILayout.Height(24)))
                        SelectObject(parent);

                    if (GUILayout.Button(SearchIcon, m_ReferenceButtonStyle, GUILayout.Height(24), GUILayout.Width(25)))
                    {
                        SetReferencedObjects(new[] { parent });
                        // SetReferencedObject(parent);
                    }

                    EditorGUILayout.EndHorizontal();

                    foreach (var child in children)
                        DrawReferenceGroup(child, parent);

                    EditorGUI.indentLevel = 0;
                    EditorGUILayout.EndVertical();
                }
            }
        }

        private static void DrawReferenceGroup(KeyValuePair<Object, List<SerializedProperty>> group, Object parent)
        {
            EditorGUI.indentLevel = 1;
            var objectWithReference = group.Key;
            if (objectWithReference != parent)
            {
                var componentType = objectWithReference.GetType();
                var componentContent = EditorGUIUtility.ObjectContent(objectWithReference, componentType);
                componentContent.text = componentType.Name;
                EditorGUILayout.LabelField(componentContent, GUILayout.Height(18));
                EditorGUI.indentLevel = 3;
            }

            foreach (var serializedProp in group.Value)
            {
                const string textTemplate = "<color=#{0}>{1}</color>";
                const string proColor = "89baec";
                const string personalColor = "214BE0";
                var text = string.Format(textTemplate, EditorGUIUtility.isProSkin ?
                    proColor : personalColor, GetPropertyDisplayName(serializedProp));
                EditorGUILayout.LabelField(text, m_PropertyLabelStyle);
            }
        }

        private static void SelectObject(Object obj)
        {
            var objectToSelect = obj;
            if (PrefabUtility.IsPartOfPrefabAsset(obj))
            {
                // If the component is nested more than 1 level deep, it will not show up in the
                // asset browser. So we select the root of the prefab.
                var objectParent = ((GameObject)obj).transform.parent;
                if (objectParent != null)
                    objectToSelect = objectParent.root.gameObject;
            }

            EditorGUIUtility.PingObject(objectToSelect);
            Selection.activeObject = objectToSelect;
        }

        private static string GetPropertyDisplayName(SerializedProperty property)
        {
            const string arrayElementName = "data";
            if (property.depth > 0 && property.name == arrayElementName)
            {
                var arrayName = property.propertyPath.Substring(0, property.propertyPath.IndexOf(".", System.StringComparison.Ordinal));
                return string.Format("{0} - {1}", arrayName, property.displayName);
            }
            return property.displayName;
        }

        private bool FilterProperties(KeyValuePair<Object, List<SerializedProperty>> kvp)
        {
            if (kvp.Key == null) return false;
            kvp.Value.RemoveAll(prop => prop == null || prop.objectReferenceValue == null);
            return kvp.Value.Count > 0;
        }

        private void DrawProgressBar()
        {
            var lastRect = GUILayoutUtility.GetLastRect();
            const float padding = 5;
            const float cancelButtonWidth = 50;
            GUILayout.Space(padding);
            var progressRect = new Rect(lastRect.x, lastRect.yMax + padding,
                lastRect.width - cancelButtonWidth - padding, 20);
            const string findingReferencesText = "Finding references...";
            EditorGUI.ProgressBar(progressRect, ReferenceFinder.AsyncProgress, findingReferencesText);
            var cancelRect = new Rect(progressRect.x + progressRect.width + padding, progressRect.y,
                cancelButtonWidth, 20);
            if (GUI.Button(cancelRect, "Stop"))
                ReferenceFinder.StopAsyncOperation();

            GUILayout.Space(progressRect.height);
        }

        [MenuItem("Assets/Reference Viewer", false)]
        private static void FindReferencesToAsset()
        {
            CreateWindow();
            SetReferencedObjects(Selection.objects);
        }

        [MenuItem("Assets/Reference Viewer", true)]
        private static bool FindReferencesToAssetValidation()
        {
            return Selection.activeObject != null && !(Selection.activeObject is DefaultAsset);
        }

        [MenuItem("CONTEXT/Component/Reference Viewer", false, -1)]
        private static void FindReferencesToComponent(MenuCommand data)
        {
            CreateWindow();
            SetReferencedObjects(new[] { data.context });
        }

        [MenuItem("GameObject/Reference Viewer", false, -1)]
        private static void FindReferencesToGameObject(MenuCommand data)
        {
            CreateWindow();
            SetReferencedObjects(new[] { data.context });
        }

        [MenuItem("GameObject/Reference Viewer", true, -1)]
        private static bool FindReferencesToGameObjectValidation(MenuCommand data)
        {
            // The context menu item is not greyed out properly for the GameObject context menu.
            if (data.context == null)
            {
                // Debug.LogWarning("Please select a valid Object to search for references.");
                return false;
            }
            return true;
        }

        private static void SetReferencedObjects(Object[] objs)
        {
            if (objs.Length == 0) return;
            m_TargetingAsset = AssetDatabase.Contains(objs[0]);

            m_ReferenceFindType = m_TargetingAsset ? m_ReferenceFindType : 0;
            m_ReferencedObjects = objs.ToList();
            FindReferences();
        }

        private static void FindReferences()
        {
            m_ReferencesList = new Dictionary<Object, IDictionary<Object, List<SerializedProperty>>>();
            foreach (var obj in m_ReferencedObjects)
                m_ReferencesList.Add(obj, new Dictionary<Object, List<SerializedProperty>>());

            if (m_ReferenceFindType == 0)
                FindReferencesInScene(m_ReferencedObjects);
            else
                FindReferencesInAssets(m_ReferencedObjects);

            EditorApplication.update += UpdateProgressGUI;
        }

        private static void UpdateProgressGUI()
        {
            if (ReferenceFinder.DoingAsyncWork)
                m_Window.Repaint();
            else
                EditorApplication.update -= UpdateProgressGUI;
        }

        private static void FindReferencesInScene(List<Object> objs)
        {
            // FindObjectsOfType does not return inactive objects.
            // We search through all Components in the scene this way.
            var componentsInScene = Resources.FindObjectsOfTypeAll<Component>()
                .Where(component => !AssetDatabase.Contains(component));
            HashSet<Object> objSet = new HashSet<Object>(objs);
            var objects = componentsInScene.Cast<Object>().ToList();
            ReferenceFinder.FindReferencesAsync(objSet, objects, m_ReferencesList, ReferencesFound);
        }

        private static void FindReferencesInAssets(List<Object> objs)
        {
            HashSet<Object> objSet = new HashSet<Object>(objs);
            ReferenceFinder.FindReferencesInAssetsAsync(objSet, m_ReferencesList, ReferencesFound);
        }

        private static void ReferencesFound()
        {
            m_Window.Repaint();
        }
    }
}
