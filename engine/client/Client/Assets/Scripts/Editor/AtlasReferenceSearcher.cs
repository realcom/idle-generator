using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEngine;
using UnityEngine.U2D;

public class AtlasReferenceSearcher : OdinEditorWindow
{
    [SerializeField] private Sprite m_spriteToSearch;
    [SerializeField, ReadOnly, ListDrawerSettings(IsReadOnly = true, ShowFoldout = false)]
    private List<SpriteAtlas> m_SearchResult = new();
    
    [MenuItem("Tools/Atlas Reference Searcher")]
    private static void OpenWindow()
    {
        GetWindow<AtlasReferenceSearcher>().Show();
    }

    protected override void OnImGUI()
    {
        base.OnImGUI();

        if (GUILayout.Button("Search"))
        {
            Search();
        }
    }

    private void Search()
    {
        if (m_spriteToSearch == null)
            return;
        
        //get all sprite atlas in project
        string[] guids = AssetDatabase.FindAssets("t:SpriteAtlas");
        
        m_SearchResult.Clear();
        
        foreach (var guid in guids)
        {
            var path = AssetDatabase.GUIDToAssetPath(guid);
            var atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(path);
            
            if (atlas == null)
                continue;
            
            //check if sprite is in atlas
            if (atlas.CanBindTo(m_spriteToSearch))
            {
                m_SearchResult.Add(atlas);
            }
        }
    }
}
