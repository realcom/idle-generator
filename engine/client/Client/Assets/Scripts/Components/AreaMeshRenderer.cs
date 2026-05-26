using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using Object = UnityEngine.Object;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class AreaMeshRenderer : ZMonoBehaviour
{
    public enum AreaType
    {
        NONE,
        CIRCLE,
        RECT
    }
    
    [SerializeField] private Transform _transform = null;
    [SerializeField] private MeshRenderer _meshRenderer = null;
    [SerializeField] private MeshFilter _meshFilter = null;

#if UNITY_EDITOR
    [Serializable]
    public struct TestCircleGenerateParam
    {
        public int angle;
        public int innerRadiusPercent;
        public bool useUnionUV;
    }
    
    public AreaType areaType = AreaType.CIRCLE;
    [ShowIf("areaType", AreaType.CIRCLE)]
    public TestCircleGenerateParam circleGenerateParam;
    public float fill;
    
    public void GenerateCircleMesh()
    {
        var mesh = MeshUtility.MakeCircleMesh(circleGenerateParam.angle, circleGenerateParam.useUnionUV, circleGenerateParam.innerRadiusPercent);
        _meshFilter.mesh = mesh;

        SetFillValue(fill);
    }
    
    public void GenerateRectMesh()
    {
        var mesh = MeshUtility.MakeRectMesh();
        _meshFilter.mesh = mesh;
        
        SetFillValue(fill);
    }

    [Button("Generate")]
    private void Generate()
    {
        switch (areaType)
        {
            case AreaType.CIRCLE:
                GenerateCircleMesh();
                break;
            case AreaType.RECT:
                GenerateRectMesh();
                break;
            default:
                break;
        }
    }

    [Button("Save")]
    private void Save()
    {
        var path = "Assets/PatchResources/Prefabs/AreaDisplayMeshes";

        if (_meshFilter.sharedMesh is null)
        {
            Debug.LogError("Mesh is null");
            return;
        }

        var assetName = areaType switch
        {
            AreaType.CIRCLE => $"CIRCLE_{circleGenerateParam.angle}_{(circleGenerateParam.useUnionUV ? "U" : "NU")}_{circleGenerateParam.innerRadiusPercent}",
            AreaType.RECT => "RECT_AREA",
            _ => throw new ArgumentOutOfRangeException()
        };

        path = Path.Combine(path, $"{assetName}.asset");

        if (AssetDatabase.LoadAssetAtPath<Mesh>(path) != null)
        {
            Debug.LogError("Mesh Already exists");
            return;
        }

        AssetDatabase.CreateAsset(_meshFilter.sharedMesh, path);
        AssetDatabase.SaveAssets();
    }

#endif
    
    private static MaterialPropertyBlock _propertyBlock = null;

    public void SetSize(float width, float height)
    {
        _transform.localScale = new Vector3(width, 1f, height);
    }

    public void SetFillValue(float fillValue)
    {
        _propertyBlock ??= new();
        _meshRenderer.GetPropertyBlock(_propertyBlock);

        _propertyBlock.SetFloat(ShaderHash.Fill, fillValue);

        _meshRenderer.SetPropertyBlock(_propertyBlock);
    }

    public void SetMesh(Mesh mesh)
    {
        _meshFilter.sharedMesh = mesh;   
    }
    
    public void SetMaterial(Material material)
    {
        _meshRenderer.sharedMaterial = material;
    }
    
}

public static class AreaMeshRendererExtension
{
    private static readonly Dictionary<int, AreaMeshRenderer> _dict = new();

    private const string AREA_MESH_PREFAB_PATH = "Etc/AreaMesh.prefab";

    public static AreaMeshRenderer Get(Mesh mesh, Material material, float width, float height, float fill = 0f)
    {
        var go = Object.Instantiate(Utility.LoadResource<GameObject>(AREA_MESH_PREFAB_PATH));
        var areaMeshRenderer = go.Get<AreaMeshRenderer>();
        areaMeshRenderer.SetMesh(mesh);
        areaMeshRenderer.SetMaterial(material);
        areaMeshRenderer.SetSize(width, height);
        areaMeshRenderer.SetFillValue(fill);

        return areaMeshRenderer;
    }
    
}
