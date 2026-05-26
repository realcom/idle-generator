using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using Commons.Resources;
using Google.Protobuf.Collections;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
using UnityEngine.Tilemaps;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class MapBounds
{
    public static MapBounds Make(Vector2 center, Vector2 size) => new(center - size / 2f, center + size / 2f);
    
    public static implicit operator MapBounds(Bounds bounds) => new(bounds.min, bounds.max);
    
    public Vector2 min { get; set; }
    public Vector2 max { get; set; }
    
    public Vector2 center => (min + max) / 2f;
    public Vector2 size => max - min;
    
    public MapBounds(Vector2 min, Vector2 max)
    {
        this.min = min;
        this.max = max;
    }

    public bool Intersects(MapBounds other)
    {
        // 두 사각형이 겹치는지 확인
        return !(max.x <= other.min.x || min.x >= other.max.x || max.y <= other.min.y || min.y >= other.max.y);
    }

    public List<MapBounds> Subtract(MapBounds other, [NotNull] int[] indices)
    {
        var result = new List<MapBounds>();

        // 겹치는 경우에만 처리
        if (Intersects(other))
        {
            for (var i = 0; i < indices.Length; i++)
            {
                switch (indices[i])
                {
                    case 0:
                    {
                        if (other.max.y < max.y)
                            result.Add(new (new Vector2(min.x, other.max.y), new Vector2(max.x, max.y)));
                        break;
                    }
                    case 1:
                    {
                        if (other.min.y > min.y)
                            result.Add(new (new Vector2(min.x, min.y), new Vector2(max.x, other.min.y)));
                        break;
                    }
                    case 2:
                    {
                        if (other.min.x > min.x)
                            result.Add(new(new Vector2(min.x, Math.Max(min.y, other.min.y)), new Vector2(other.min.x, Math.Min(max.y, other.max.y))));
                        break;
                    }
                    case 3:
                    {
                        if (other.max.x < max.x)
                            result.Add(new(new Vector2(other.max.x, Math.Max(min.y, other.min.y)), new Vector2(max.x, Math.Min(max.y, other.max.y))));
                        break;
                    }
                }
            }
        }
        else
        {
            // 겹치지 않으면 전체 사각형을 추가
            result.Add(this);
        }

        return result;
    }
}

public class MapRoot_Old : MonoBehaviour
{
    private static MapRoot_Old _instance;
    public static MapRoot_Old Get() => _instance;
    
    public GameObject cameraGroup;
    
    public Vector2 boundsOffset;
    public Vector2 boundsSize;
    
    public Vector2 innerBoundsOffset;
    public Vector2 innerBoundsSize;

    public Vector2 paddingOffset;
    public Vector2 padding = new Vector2(8f, 8f);

    public float mapZoomRatio = 1.0f;
    public float mapAngleOffset = 0.0f;

    [NonSerialized]
    public Vector2 boundsMin;
    [NonSerialized]
    public Vector2 boundsMax;
    [NonSerialized]
    public Vector2 paddedMin;
    [NonSerialized]
    public Vector2 paddedMax;
    [NonSerialized]
    public Texture2D minimapTexture;
    [NonSerialized]
    public int minimapMagnifier = 6;

    public bool throwToLogin = true;

    [Serializable]
    public class MinimapObject
    {
        public GameObject target;
        public MinimapObjectTag minimapObjectTag;
    }
    
    public enum MinimapObjectTag
    {
        PORTAL,
        SPAWNER,
    }
    
    public MinimapObject[] minimapObjects;

    public Transform collidersParent;
    public Transform rootObstacle;
    
    [Button]
    public void GenerateColliders()
    {
        collidersParent.DestroyAllChildren();

        foreach (var result in GetSafeBounds())
        {
            var go = new GameObject("Collider");
            go.transform.SetParent(collidersParent);
            go.transform.position = result.center;
            go.transform.localScale = new Vector3(result.size.x, result.size.y, 1f);
            go.AddComponent<BoxCollider2D>();

            Debug.Log($"Bound: ({result.min.x}, {result.min.y}), ({result.max.x}, {result.max.y})");
        }
    }
    
    private void GetObstacleBoundsRecursively(Transform parent, List<MapBounds> bounds)
    {
        foreach (Transform child in parent)
        {
            if (child.TryGetComponent<IMapObstacleElement>(out var mapObstacleElement))
            {
                if (mapObstacleElement.ignoreChildSearch)
                    continue;
            }
            
            if (child.TryGetComponent(out Collider2D collider2D))
            {
                bounds.Add(MapBounds.Make(collider2D.bounds.center, collider2D.bounds.size));
            }
            else if (child.TryGetComponent(out Tilemap tilemap))
            {
                var cellBounds = tilemap.cellBounds;
                
                //iterate all tile & cast sprite to get world bounds
                for (var x = cellBounds.xMin; x < cellBounds.xMax; x++)
                {
                    for (var y = cellBounds.yMin; y < cellBounds.yMax; y++)
                    {
                        var tileBase = tilemap.GetTile(new Vector3Int(x, y, 0));
                        if (tileBase == null || tileBase is not Tile tile)
                            continue;

                        var go = new GameObject("@TempTileBound");
                        go.transform.SetParent(collidersParent, false);

                        var sprite = tile.sprite;
                        
                        // Sprite의 보더(Border) 가져오기
                        var border = sprite.border;

                        // Add Border to Sprite Size
                        Vector2 spriteSize = sprite.bounds.size;
                        var borderDelta = new Vector2((border.x + border.z) / sprite.pixelsPerUnit, (border.y + border.w) / sprite.pixelsPerUnit);
                        spriteSize -= borderDelta;
                        
                        // Get World Position
                        var worldPosition = tilemap.GetCellCenterWorld(new Vector3Int(x, y, 0));

                        // Get border pivot
                        var rect = sprite.rect;
                        var borderX = ((border.x / rect.width) + ((rect.width - border.z) / rect.width)) / 2f;
                        var borderY = ((border.y / rect.height) + ((rect.height - border.w) / rect.height)) / 2f;
                        var borderPivot = new Vector2(borderX, borderY);
                        var spritePivot = sprite.pivot / sprite.rect.size;
                        var offset = (borderPivot - spritePivot) * tilemap.transform.lossyScale;

                        //set position to pivot of tile
                        go.transform.position = worldPosition;
                        go.transform.localScale = tilemap.transform.lossyScale;
                        var boxCollider2D = go.AddComponent<BoxCollider2D>();
                        boxCollider2D.offset = offset;
                        boxCollider2D.size = spriteSize;
                        go.AddComponent<SpriteRenderer>().sprite = sprite;
                        bounds.Add(boxCollider2D.bounds);

                        DestroyImmediate(go, true);
                    }
                }
            }
            else if (child.TryGetComponent(out SpriteRenderer spriteRenderer))
            {
                var sprite = spriteRenderer.sprite;
                //get sprite border to world bounds
                var border = sprite.border;
                var rect = sprite.rect;
                var borderX = ((border.x / rect.width) + ((rect.width - border.z) / rect.width)) / 2f;
                var borderY = ((border.y / rect.height) + ((rect.height - border.w) / rect.height)) / 2f;
                var borderPivot = new Vector2(borderX, borderY);
                var spritePivot = sprite.pivot / sprite.rect.size;
                var offset = (borderPivot - spritePivot) * spriteRenderer.transform.lossyScale;

                var borderWorldSize = new Vector2((border.x + border.z) / sprite.pixelsPerUnit, (border.y + border.w) / sprite.pixelsPerUnit) * spriteRenderer.transform.lossyScale;

                bounds.Add(MapBounds.Make((Vector2)spriteRenderer.transform.position + offset, borderWorldSize));
            }

            GetObstacleBoundsRecursively(child, bounds);
        }
    }

    public IReadOnlyList<MapBounds> GetSafeBounds()
    {
        CalculatePostData();
        var largeBound = new MapBounds(boundsMin, boundsMax);

        var bounds = new List<MapBounds>();

        if (rootObstacle != null)
            GetObstacleBoundsRecursively(rootObstacle, bounds);

        var options = new List<MapBounds> { largeBound };
        
        foreach (var smallRect in bounds)
        {
            List<MapBounds> newRemainingRects = new ();

            foreach (var rect in options)
            {
                var subtractedRects = rect.Subtract(smallRect, new[] { 0, 1, 2, 3 });

                // Filter out any subtracted bounds that are too small
                foreach (var subRect in subtractedRects)
                {
                    if (subRect.size is { x: >= 0.25f, y: >= 0.25f })
                    {
                        newRemainingRects.Add(subRect);
                    }
                    else
                    {
                        ExpandNeighboringBounds(newRemainingRects, subRect);
                    }
                }
            }

            options = newRemainingRects;
        }

        return options;
    }
    
    private void ExpandNeighboringBounds(List<MapBounds> boundsList, MapBounds smallRect)
    {
        // 작은 영역을 메우기 위해 확장할 수 있는 바운드가 있는지 확인
        foreach (var bound in boundsList)
        {
            // 수평으로 확장할 수 있는 경우 (높이가 같고 작은 영역이 인접해 있을 때)
            if (Mathf.Approximately(bound.min.y, smallRect.min.y) && Mathf.Approximately(bound.max.y, smallRect.max.y))
            {
                if (Mathf.Approximately(bound.max.x, smallRect.min.x))
                {
                    // 오른쪽으로 확장
                    bound.max = new Vector2(smallRect.max.x, bound.max.y);
                    return;
                }
                else if (Mathf.Approximately(bound.min.x, smallRect.max.x))
                {
                    // 왼쪽으로 확장
                    bound.min = new Vector2(smallRect.min.x, bound.min.y);
                    return;
                }
            }

            // 수직으로 확장할 수 있는 경우 (너비가 같고 작은 영역이 인접해 있을 때)
            if (Mathf.Approximately(bound.min.x, smallRect.min.x) && Mathf.Approximately(bound.max.x, smallRect.max.x))
            {
                if (Mathf.Approximately(bound.max.y, smallRect.min.y))
                {
                    // 위쪽으로 확장
                    bound.max = new Vector2(bound.max.x, smallRect.max.y);
                    return;
                }
                else if (Mathf.Approximately(bound.min.y, smallRect.max.y))
                {
                    // 아래쪽으로 확장
                    bound.min = new Vector2(bound.min.x, smallRect.min.y);
                    return;
                }
            }
        }
        
    }

    public Mesh GetQuadMesh()
    {
        Mesh mesh = new Mesh();

        Vector3[] vertices = new Vector3[4];
        int[] triangles = new int[6];

        CalculatePostData();
        
        // 사각형 꼭지점 좌표 설정
        vertices[0] = new Vector3(boundsMin.x, boundsMin.y);
        vertices[1] = new Vector3(boundsMin.x, boundsMax.y);
        vertices[2] = new Vector3(boundsMax.x, boundsMax.y);
        vertices[3] = new Vector3(boundsMax.x, boundsMin.y);

        // 삼각형 인덱스 설정
        triangles[0] = 0;
        triangles[1] = 1;
        triangles[2] = 2;

        triangles[3] = 2;
        triangles[4] = 3;
        triangles[5] = 0;

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();

        return mesh;
    }

    private const float gridUnit = 0.125f;
    //public List<ResourceMap.Types.Terrain.Types.Grid> GetSafeGrids()
    //{
    //    CalculatePostData();
    //    var grids = new List<ResourceMap.Types.Terrain.Types.Grid>();
    //    var gridSize = new Vector2Int(ToGridUnit(boundsSize.x), ToGridUnit(boundsSize.y));
    //    for (var y = 0; y < gridSize.y; y++)
    //    {
    //        for (var x = 0; x < gridSize.x; x++)
    //        {
    //            grids.Add(new ResourceMap.Types.Terrain.Types.Grid()
    //            {
    //                GridX = x,
    //                GridY = y
    //            });
    //        }
    //    }
    //    
    //    var bounds = new List<MapBounds>();
    //    if (rootObstacle != null)
    //        GetObstacleBoundsRecursively(rootObstacle, bounds);
    //
    //    var log = new StringBuilder();
    //    
    //    foreach (var bound in bounds)
    //    {
    //        var min = Vector2.Max(bound.min, boundsMin);
    //        var max = Vector2.Min(bound.max, boundsMax);
    //        min -= boundsMin;
    //        max -= boundsMin;
    //
    //        log.AppendLine($"Remove Grid from {min} to {max}");
    //        for (var y = ToGridUnit(min.y); y < ToGridUnit(max.y); y++)
    //        {
    //            for (var x = ToGridUnit(min.x); x < ToGridUnit(max.x); x++)
    //            {
    //                grids[x + y * gridSize.x] = null;
    //                
    //                //GameObject meshObj = new GameObject("MeshPart");
    //                //meshObj.transform.parent = collidersParent;
    //                //
    //                //MeshFilter meshFilter = meshObj.AddComponent<MeshFilter>();
    //                //meshObj.AddComponent<MeshRenderer>().material = new Material(Shader.Find("Sprites/Default")); // 기본 셰이더
    //                //
    //                //var unityMin = new Vector2(ToUnityUnit(x) + boundsMin.x, ToUnityUnit(y) + boundsMin.y);
    //                //var unityMax = new Vector2(unityMin.x + gridUnit, unityMin.y + gridUnit);
    //                //
    //                //meshFilter.mesh = CreateMesh(unityMin, unityMax);
    //            }
    //        }
    //    }
    //
    //    Debug.Log(log);
    //
    //    grids.RemoveAll(x => x == null);
    //
    //    return grids;
    //}

    public int ToGridUnit(float unityUnit)
    {
        return Mathf.RoundToInt(unityUnit / gridUnit);
    }
    
    public float ToUnityUnit(int gridIndex)
    {
        return gridIndex * gridUnit;
    }

    public Mesh safeMesh;
    public Mesh GetSafeMesh(bool destroy = true)
    {
        return safeMesh != null ? safeMesh : GetQuadMesh();
    }
    
    Mesh CreateMesh(Vector2 min, Vector2 max)
    {
        Mesh mesh = new Mesh();

        Vector3[] vertices = new Vector3[4];
        int[] triangles = new int[6];

        // 사각형 꼭지점 좌표 설정
        vertices[0] = new Vector3(min.x, min.y);
        vertices[1] = new Vector3(min.x, max.y);
        vertices[2] = new Vector3(max.x, max.y);
        vertices[3] = new Vector3(max.x, min.y);

        // 삼각형 인덱스 설정
        triangles[0] = 0;
        triangles[1] = 1;
        triangles[2] = 2;

        triangles[3] = 2;
        triangles[4] = 3;
        triangles[5] = 0;

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();

        return mesh;
    }

    public float quailty = 1f;
    Mesh CombineMeshes(List<MeshFilter> meshFilters)
    {
        var combine = new CombineInstance[meshFilters.Count];
        var combinedBounds = new Bounds(Vector3.zero, Vector3.zero);
        var boundsInitialized = false;

        for (var i = 0; i < meshFilters.Count; i++)
        {
            var groundMesh = meshFilters[i].sharedMesh;
            combine[i].mesh = groundMesh;
            combine[i].transform = meshFilters[i].transform.localToWorldMatrix;

            // Update the combined bounds
            if (!boundsInitialized)
            {
                combinedBounds = meshFilters[i].sharedMesh.bounds;
                boundsInitialized = true;
            }
            else
            {
                combinedBounds.Encapsulate(meshFilters[i].sharedMesh.bounds);
            }
        }

        var combineMeshes = new Mesh();
        combineMeshes.CombineMeshes(combine);
        //combineMeshes.Optimize();

        return combineMeshes;

        //var simplifier = new MeshSimplifier();
        //simplifier.Initialize(combineMeshes);
        //simplifier.SimplifyMesh(quailty);
        //
        //return simplifier.ToMesh();
    }

    [Button]
    public void GenerateSafeMesh()
    {
        collidersParent.DestroyAllChildren();

        //GetSafeGrids();

        //GameObject combinedObj = new GameObject("CombinedMesh");
        //combinedObj.transform.parent = collidersParent;
        //MeshFilter filter = combinedObj.AddComponent<MeshFilter>();
        //filter.mesh = GetSafeMesh();
        //combinedObj.AddComponent<MeshRenderer>().material = new Material(Shader.Find("Sprites/Default"));
    }

    public Vector2 PickPositionInBounds()
    {
        return boundsSize.PickRandom() + boundsOffset;
    }

    public void Awake()
    {
        _instance = this;

        if (throwToLogin && GameManager.Get().scene == null)
            SceneManager.LoadScene(Constants.LOGIN_SCENE);
        
        minimapTexture = new LazyLoad<Texture2D>( $"Items/Minimaps/{gameObject.scene.name}_Minimap.png");

        // if (PlayerCamera.Get())
        // {
        //     PlayerCamera.Get().SetZoomWithNormalizedTime(mapZoomRatio, Vector2.zero, 1f);
        //     PlayerCamera.Get().transform.rotation *= Quaternion.Euler(mapAngleOffset, 0, 0);
        // }

        if (cameraGroup)
            Destroy(cameraGroup);
        
        CalculatePostData();
    }

    public void CalculatePostData()
    {
        boundsMin = boundsOffset - boundsSize / 2f;
        boundsMax = boundsOffset + boundsSize / 2f;
        paddedMin = paddingOffset - boundsSize / 2f - padding;
        paddedMax = paddingOffset + boundsSize / 2f + padding;
    }

    private void OnDestroy()
    {
        _instance = null;
        // if (PlayerCamera.Get())
        // {
        //     PlayerCamera.Get().SetZoomWithNormalizedTime(1/mapZoomRatio, Vector2.zero, 1f);
        //     PlayerCamera.Get().transform.rotation *= Quaternion.Euler(-mapAngleOffset, 0, 0);
        // }
    }

#if UNITY_EDITOR
    public void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(boundsOffset.X0Z(), boundsSize.X0Z());
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(paddingOffset.X0Z(), (boundsSize + padding * 2).X0Z());
        
        var textStyle = new GUIStyle(EditorStyles.textField) { normal = { textColor = Color.white }, alignment = TextAnchor.MiddleCenter};
        const float PointSize = 0.01f;
        const float FillGap = 0.01f;

        if (Application.isPlaying)
        {
            var gameBoard = GameBoardManager.Get()?.gameBoard;
            if (gameBoard == null)
                return;
            
            if (GizmoSystem.seeTerrain)
            {
                var resMap = gameBoard.ResMap;
                if (resMap == null)
                    return;

                var unitTerrain = resMap.UnitTerrain;
                if (unitTerrain != null)
                {
                    var vertices = unitTerrain.Vertices;
                    for (var i = 0; i < unitTerrain.Triangles.Count; i++)
                    {
                        var triangle = unitTerrain.Triangles[i];
                        var p1 = vertices[(int)triangle.V1].VertexToVector3();
                        var p2 = vertices[(int)triangle.V2].VertexToVector3();
                        var p3 = vertices[(int)triangle.V3].VertexToVector3();
                        
                        Gizmos.color = GizmoSystem.terrainColor;
                        Gizmos.DrawLine(p1, p2);
                        Gizmos.DrawLine(p2, p3);
                        Gizmos.DrawLine(p3, p1);
                        
                        Gizmos.color = GizmoSystem.terrainColor * 0.5f;
                        Gizmos.DrawSphere(p1, PointSize);
                        Gizmos.DrawSphere(p2, PointSize);
                        Gizmos.DrawSphere(p3, PointSize);
                        
                        if (GizmoSystem.fillEnabledTerrain && !gameBoard.DisabledTerrainTriangles.ContainsKey(i))
                            FillTriangle(p1, p2, p3, GizmoSystem.terrainColor * 0.5f);
                        
                        var center = (p1 + p2 + p3) / 3f;
                        Handles.Label(center + Vector3.up * 0.1f, $"T{i}", textStyle);
                    }
                }
            }
        }
        else
        {
            if (GizmoSystem.seeTerrain)
            {
                // TODO: not tested for multiple ground meshes
                var totalTriangleCount = 0;
                var groundMeshFilters = Utility.FindObjectsOfTypeAndLayerAll<MeshFilter>(LayerMask.NameToLayer("Ground"));
                foreach (var meshFilter in groundMeshFilters)
                {
                    var mesh = meshFilter.sharedMesh;
                    for (var i = 0; i < mesh.triangles.Length; i += 3)
                    {
                        var p1 = mesh.vertices[mesh.triangles[i]];
                        var p2 = mesh.vertices[mesh.triangles[i + 1]];
                        var p3 = mesh.vertices[mesh.triangles[i + 2]];
                        
                        var transformedP1 = meshFilter.transform.TransformPoint(p1);
                        var transformedP2 = meshFilter.transform.TransformPoint(p2);
                        var transformedP3 = meshFilter.transform.TransformPoint(p3);
                        
                        Gizmos.color = GizmoSystem.terrainColor;
                        Gizmos.DrawLine(transformedP1, transformedP2);
                        Gizmos.DrawLine(transformedP2, transformedP3);
                        Gizmos.DrawLine(transformedP3, transformedP1);
                        
                        Gizmos.color = GizmoSystem.terrainColor * 1.5f;
                        Gizmos.DrawSphere(transformedP1, PointSize);
                        Gizmos.DrawSphere(transformedP2, PointSize);
                        Gizmos.DrawSphere(transformedP3, PointSize);

                        var triangleIndex = i / 3;
                        triangleIndex = totalTriangleCount <= triangleIndex ? triangleIndex : totalTriangleCount + triangleIndex;
                        totalTriangleCount = triangleIndex + 1;
                        if (GizmoSystem.fillEnabledTerrain && !GizmoSystem.editorDisabledTriangles.Contains(triangleIndex))
                            FillTriangle(transformedP1, transformedP2, transformedP3, GizmoSystem.terrainColor * 0.5f);
                        
                        var center = (transformedP1 + transformedP2 + transformedP3) / 3f;
                        Handles.Label(center + Vector3.up * 0.1f, $"T{triangleIndex}", textStyle);
                    }
                }
            }
        }

        void FillTriangle(Vector3 v1, Vector3 v2, Vector3 v3, Color color) {
            Gizmos.color = color;
            var v12Length = Vector3.Distance(v1, v2);
            var v13Length = Vector3.Distance(v1, v3);
            var minLength = Mathf.Min(v12Length, v13Length);
            var dynamicLineCount = Mathf.CeilToInt(minLength / FillGap);

            for (var i = 0; i <= dynamicLineCount; i++) {
                var lerpFactor = i / (float)dynamicLineCount;
                var v12 = Vector3.Lerp(v1, v2, lerpFactor);
                var v13 = Vector3.Lerp(v1, v3, lerpFactor);
                Gizmos.DrawLine(v12, v13);
            }
        }
    }
    
#endif
}
