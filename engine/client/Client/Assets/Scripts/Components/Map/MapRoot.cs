using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Commons.Resources;
using Commons.Types.Geometry;
using Google.Protobuf;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.SceneManagement;
using Resources = Commons.Resources.Resources;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class MapRoot : ZMonoBehaviour
{
    [Title("Border Settings")]
    public Vector2 boundsSize;

    [HideInInspector]
    public Vector2 boundsMin => -boundsSize / 2f;

    public Vector2 boundsMax => boundsSize / 2f;

    public float groundY;

    public Transform trLocations;
    
    public float width;

    public bool resetScroll = false;
    public bool throwToLogin = true;
    
    [Serializable]
    public class BackgroundData
    {
	    public GameObject backgroundObject;
	    public float defaultScrollSpeed;
	    public float scrollSpeedMultiplier = 1f;
    }
    
    [Title("Background Settings")]
    public BackgroundData[] backgroundData;

    protected override void Awake()
    {
	    if (throwToLogin && GameManager.Get().scene == null)
		    SceneManager.LoadScene(Constants.LOGIN_SCENE);
    }


#if UNITY_EDITOR
	[Button]
    public void ExportMap()
    {
	    ExportCurrentSceneTerrainLocation(gameObject.name);
    }

    private void ExportCurrentSceneTerrainLocation(string sceneName)
    {
	    var quadMesh = GetQuadMesh();

	    var unitTerrain = GetTerrainFromMesh(quadMesh);
	    var skillTerrain = GetTerrainFromMesh(quadMesh);

	    var terrainTypeCnt = Enum.GetValues(typeof(ResourceMap.Types.Terrain.Types.Type)).Length;
	    var terrains = new List<ResourceMap.Types.Terrain>();
	    for (var i = 0; i < terrainTypeCnt; i++)
	    {
		    var terrainType = (ResourceMap.Types.Terrain.Types.Type)i;
		    if (terrainType == ResourceMap.Types.Terrain.Types.Type.Skill)
		    {
			    var terrainCopied = skillTerrain.Clone();
			    terrainCopied.Type = terrainType;
			    terrains.Add(terrainCopied);
		    }
		    else if (terrainType == ResourceMap.Types.Terrain.Types.Type.Unit)
		    {
			    var terrainCopied = unitTerrain.Clone();
			    terrainCopied.Type = terrainType;
			    terrains.Add(terrainCopied);
		    }
		    else
		    {
			    var terrainCopied = unitTerrain.Clone();
			    terrainCopied.Type = terrainType;
			    terrains.Add(terrainCopied);
		    }
	    }
	    
	    var locations = trLocations.GetComponentsInChildren<SpawnerLocation>(true).Where(x => x.gameObject.activeSelf && x.IsValidSpawnLocation()).Select(x => x.GetLocation());

	    // var locations = Utility.FindObjectsOfTypeAll<SpawnerLocation>()
		    // .Where(x => x.gameObject.activeInHierarchy && x.IsValidSpawnLocation()).Select(x => x.GetLocation());

	    // Apply data to map
	    var jsonResource = File.ReadAllText(Path.Combine(Application.dataPath, "PatchResources/Maps.json"));
	    var resources = JsonParser.Default.Parse<Resources>(jsonResource);

	    var matchedMaps = resources.Maps.Where(x => Path.GetFileNameWithoutExtension(x.Scene) == sceneName);
	    foreach (var matchedMap in matchedMaps)
	    {
		    // Dump terrain data
		    matchedMap.Terrains.Clear();
		    matchedMap.Terrains.AddRange(terrains);

		    // Dump spawner data
		    matchedMap.Locations.Clear();
		    matchedMap.Locations.AddRange(locations);

		    // Save to file
		    var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
		    var json = formatter.Format(resources);

		    File.WriteAllText("Assets/PatchResources/Maps.json", json);
		    Debug.Log($"Saved {sceneName} terrain and location for map id: {matchedMap.Id} ({matchedMap.Name})");
	    }
    }

    public Mesh GetQuadMesh()
    {
	    var mesh = new Mesh();

	    Vector3[] vertices = new Vector3[4];
	    int[] triangles = new int[6];

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

    private ResourceMap.Types.Terrain GetTerrainFromMesh(Mesh safeMesh)
    {
	    var terrain = new ResourceMap.Types.Terrain();

	    // var groundMesh = groundMeshFilter.sharedMesh;
	    // var derivedTerrainMesh = new Mesh();
	    // derivedTerrainMesh.vertices = groundMesh.vertices;
	    // derivedTerrainMesh.triangles = groundMesh.triangles;

	    // vertices
	    // var rotation = groundMeshFilter.gameObject.transform.rotation;
	    // var pos = groundMeshFilter.gameObject.transform.position;
	    // var rotation = groundMeshFilter.gameObject.transform.rotation;
	    var rotation = Quaternion.identity;
	    // var pos = safeMesh.bounds.center;
	    var pos = Vector3.zero;

	    var translation = new Vector3(pos.x, pos.y, pos.z);

	    var originalVertices = safeMesh.vertices;
	    var vertexMapping = new uint[originalVertices.Length];
	    var transformedVertices = new List<Vector3>();

	    for (var i = 0; i < originalVertices.Length; i++)
	    {
		    int j;
		    for (j = 0; j < i; ++j)
		    {
			    if ((originalVertices[i] - originalVertices[j]).sqrMagnitude < 0.0025f)
			    {
				    vertexMapping[i] = vertexMapping[j];
				    break;
			    }
		    }

		    if (i != j)
			    continue;

		    var adjustedVertex = RoundVector3(rotation * originalVertices[i] + translation, 6);
		    transformedVertices.Add(adjustedVertex);
		    vertexMapping[i] = (uint)transformedVertices.Count - 1;
	    }

	    // triangles
	    var terrainMeshTriangles = new List<ResourceMap.Types.Terrain.Types.Triangle>();
	    for (var i = 0; i < safeMesh.triangles.Length; i += 3)
	    {
		    var triangle = new ResourceMap.Types.Terrain.Types.Triangle
		    {
			    V1 = vertexMapping[safeMesh.triangles[i]],
			    V2 = vertexMapping[safeMesh.triangles[i + 1]],
			    V3 = vertexMapping[safeMesh.triangles[i + 2]],
		    };
		    terrainMeshTriangles.Add(triangle);
	    }

	    var terrainMeshVertices = transformedVertices.Select(x =>
	    {
		    var vertex = new ResourceMap.Types.Terrain.Types.Vertex
		    {
			    Position = new Vector2Message(),
		    };
		    vertex.Position.Set(x.XZ());
		    return vertex;
	    });

	    terrain.Triangles.AddRange(terrainMeshTriangles);
	    terrain.Vertices.AddRange(terrainMeshVertices);

	    return terrain;
    }

    private static Vector3 RoundVector3(Vector3 vector, int decimalPlaces)
    {
	    float x = (float)Math.Round(vector.x, decimalPlaces);
	    float y = (float)Math.Round(vector.y, decimalPlaces);
	    float z = (float)Math.Round(vector.z, decimalPlaces);
	    return new Vector3(x, y, z);
    }
    

    private void OnDrawGizmos()
    {
	    Gizmos.color = Color.green;
	    var boundsOffset = new Vector3(0f, groundY, 0f);
	    Gizmos.DrawWireCube(boundsOffset, boundsSize.X0Z());

	    var locations = transform.Get<Transform>("Locations");
	    locations.GetComponentsInChildren<SpawnerLocation>().ToList().ForEach(x =>
	    {
		    foreach (var geometry in x.Geometries)
		    {
			    var pos = x.transform.position + Vector3.up * groundY;
			    geometry?.DrawGizmo(pos, transform.rotation, transform.localScale, Color.cyan);

			    var textStyle = new GUIStyle(EditorStyles.textField);
			    textStyle.normal.textColor = Color.white;

			    string index = x.usePredefinedIndex ? x.predefinedIndex : x.spawnerIndex;
			    Handles.Label(pos, $"Spawner {index}", textStyle);
		    }
	    });
	    
	    //var tr = transform.position;
	    //
	    //Gizmos.color = Color.blue;
	    //Gizmos.DrawLine(new Vector3(-width / 2f, groundY, 0f) + tr, new Vector3(width / 2f, groundY, 0f) + tr);
    }


    private void OnDrawGizmosSelected()
    {
	    // draw line for ground
	    var tr = transform.position;
	    // Gizmos.color = Color.red;
	    // Gizmos.DrawLine(new Vector3(boundsMin.x, groundY, 0f) + tr, new Vector3(boundsMax.x, groundY, 0f) + tr);

	    // Gizmos.color = Color.blue;
	    // Gizmos.DrawLine(new Vector3(-width / 2f, groundY, 0f) + tr, new Vector3(width / 2f, groundY, 0f) + tr);
    }
    
#endif
}