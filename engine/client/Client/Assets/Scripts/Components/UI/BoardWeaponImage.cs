using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;
using UnityEngine.Sprites;
using UnityEngine.UI;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.UI;
#endif

public class BoardWeaponImage : Image
{
    public const float FIT_SCALE_MAX = 2f;
    
    [SerializeField] private Vector2 m_ShinyCenterPivot = new(0.5f, 0.5f);
    public Vector2 shinyCenterPivot
    {
        get => m_ShinyCenterPivot;
        set
        {
            if (m_ShinyCenterPivot == value)
                return;
            m_ShinyCenterPivot = value;
            SetVerticesDirty();
        }
    }

    public void Refresh(ResourceItem resItem)
    {
        if (resItem is not { Type: ResourceItem.Types.Type.InventorySkill })
            return;
        
        sprite = resItem.ClientSpriteIcon;
        material = CRC.Get().GetBoardWeaponImageMaterial(resItem.Rarity);
        if (resItem.WeaponGraphicCenterPivot != null)
            shinyCenterPivot = resItem.WeaponGraphicCenterPivot;
    }
    
    public void FitScaleByRatio(float maxScale = FIT_SCALE_MAX, int baseSize = 128)
    {
        if (overrideSprite == null)
            return;
        
        var size = overrideSprite.rect.size;
        
        var xScale = size.x / baseSize;
        var yScale = size.y / baseSize;

        if (xScale > maxScale)
        {
            yScale *= maxScale / xScale;
            xScale = maxScale;
        }
            
        if (yScale > maxScale)
        {
            xScale *= maxScale / yScale;
            yScale = maxScale;
        }
        
        rectTransform.localScale =
            new Vector3(
                xScale,
                yScale,
                1f);
    }
    
    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        if (overrideSprite == null)
        {
            base.OnPopulateMesh(toFill);
            return;
        }

        if (type == Type.Simple && !useSpriteMesh)
        {
            GenerateBoardWeaponSprite(toFill, preserveAspect);
        }
        else
        {
            base.OnPopulateMesh(toFill);
        }
    }

    protected void GenerateBoardWeaponSprite(VertexHelper vh, bool lPreserveAspect)
    {
        Vector4 v = GetDrawingDimensions(lPreserveAspect);
        var uv = (overrideSprite != null) ? DataUtility.GetOuterUV(overrideSprite) : Vector4.zero;

        var w = uv.z - uv.x;
        var h = uv.w - uv.y;

        var newPivot = new Vector2(uv.x + w * m_ShinyCenterPivot.x, uv.y + h * m_ShinyCenterPivot.y);
        
        var color32 = color;
        vh.Clear();
        vh.AddVert(new Vector3(v.x, v.y), color32, new Vector4(uv.x, uv.y, newPivot.x, newPivot.y));
        vh.AddVert(new Vector3(v.x, v.w), color32, new Vector4(uv.x, uv.w, newPivot.x, newPivot.y));
        vh.AddVert(new Vector3(v.z, v.w), color32, new Vector4(uv.z, uv.w, newPivot.x, newPivot.y));
        vh.AddVert(new Vector3(v.z, v.y), color32, new Vector4(uv.z, uv.y, newPivot.x, newPivot.y));

        vh.AddTriangle(0, 1, 2);
        vh.AddTriangle(2, 3, 0);
    }
    
    private Vector4 GetDrawingDimensions(bool shouldPreserveAspect)
    {
        var padding = overrideSprite == null ? Vector4.zero : DataUtility.GetPadding(overrideSprite);
        var size = overrideSprite == null ? Vector2.zero : new Vector2(overrideSprite.rect.width, overrideSprite.rect.height);

        Rect r = GetPixelAdjustedRect();
        // Debug.Log(string.Format("r:{2}, size:{0}, padding:{1}", size, padding, r));

        int spriteW = Mathf.RoundToInt(size.x);
        int spriteH = Mathf.RoundToInt(size.y);

        var v = new Vector4(
            padding.x / spriteW,
            padding.y / spriteH,
            (spriteW - padding.z) / spriteW,
            (spriteH - padding.w) / spriteH);

        if (shouldPreserveAspect && size.sqrMagnitude > 0.0f)
        {
            PreserveSpriteAspectRatio(ref r, size);
        }

        v = new Vector4(
            r.x + r.width * v.x,
            r.y + r.height * v.y,
            r.x + r.width * v.z,
            r.y + r.height * v.w
        );

        return v;
    }
    
    private void PreserveSpriteAspectRatio(ref Rect rect, Vector2 spriteSize)
    {
        var spriteRatio = spriteSize.x / spriteSize.y;
        var rectRatio = rect.width / rect.height;

        if (spriteRatio > rectRatio)
        {
            var oldHeight = rect.height;
            rect.height = rect.width * (1.0f / spriteRatio);
            rect.y += (oldHeight - rect.height) * rectTransform.pivot.y;
        }
        else
        {
            var oldWidth = rect.width;
            rect.width = rect.height * spriteRatio;
            rect.x += (oldWidth - rect.width) * rectTransform.pivot.x;
        }
    }
    
}


#if UNITY_EDITOR
[CustomEditor(typeof(BoardWeaponImage))]
public class BoardWeaponImageEditor : ImageEditor
{
    SerializedProperty shinyCenterPivot;

    protected override void OnEnable()
    {
        base.OnEnable();
        
        shinyCenterPivot = serializedObject.FindProperty("m_ShinyCenterPivot");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        
        EditorGUILayout.PropertyField(shinyCenterPivot);
        
        serializedObject.ApplyModifiedProperties();
        
        base.OnInspectorGUI();
    }
}
#endif