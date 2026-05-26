using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEditor.U2D;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

public class SpriteAtlasFitter : OdinEditorWindow
{
    [SerializeField] private Sprite m_sprite;
    
    [SerializeField, ReadOnly, ListDrawerSettings(IsReadOnly = true, ShowFoldout = false, ShowPaging = false)]
    private List<SpriteAtlas> m_Result = new();
    
    [MenuItem("Tools/Sprite Atlas Fitter")]
    private static void OpenWindow()
    {
        GetWindow<SpriteAtlasFitter>().Show();
    }

    [Button]
    private void Fit()
    {
        m_Result.Clear();
        
        //load all sprite atlas using assetDataBase
        var spriteAtlasGuids = AssetDatabase.FindAssets("t:SpriteAtlas");
        foreach (var guid in spriteAtlasGuids)
        {
            var path = AssetDatabase.GUIDToAssetPath(guid);
            var spriteAtlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(path);
            if (spriteAtlas == null)
                continue;
            
            //find all sprite in sprite atlas
            if (spriteAtlas.CanBindTo(m_sprite))
            {
                m_Result.Add(spriteAtlas);
            }
        }
        
    }
}
