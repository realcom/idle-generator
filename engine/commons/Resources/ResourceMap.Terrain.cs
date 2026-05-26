using System;
using System.Collections.Concurrent;
using System.Collections.Generic;   
using System.Linq;
using Commons.Types.Geometry;
using RBush;
using Commons.Algorithm.AStar;
using Commons.Types;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceMap
    {
        public partial class Types
        {
            public partial class Terrain
            {
                private static readonly IReadOnlyDictionary<int, bool> EmptyDisabledTriangles = new Dictionary<int, bool>();

                private static readonly int[] Dx = {-1, 0, 1, -1, 1, -1, 0, 1};
                private static readonly int[] Dy = {-1, -1, -1, 0, 0, 1, 1, 1};
                private static readonly int DCount = Dx.Length;

                private AStar.Map? _aStarMap;

                private void Init()
                {
                    if (_aStarMap != null)
                        return;
                    
                    var absoluteMinX = FixedFloat.MaxValue;
                    var absoluteMinY = FixedFloat.MaxValue;
                    var absoluteMaxX = FixedFloat.MinValue;
                    var absoluteMaxY = FixedFloat.MinValue;

                    for (var i = 0; i < Vertices.Count; i++)
                    {
                        absoluteMinX = FixedFloatMath.Min(absoluteMinX, Vertices[i].Position.X);
                        absoluteMinY = FixedFloatMath.Min(absoluteMinY, Vertices[i].Position.Y);
                        absoluteMaxX = FixedFloatMath.Max(absoluteMaxX, Vertices[i].Position.X);
                        absoluteMaxY = FixedFloatMath.Max(absoluteMaxY, Vertices[i].Position.Y);
                    }

                    // Initialize the grid
                    // Two ways to initialize the grid:
                    // 1. To sequentially check each point in the grid, if the point is inside any triangle (Using R-tree)
                    // 2. To sequentially check each triangle, determine bounding box of each triangle and fill the grid
                    // The first way is more efficient if the terrain is sparse and the triangles are large
                    // The second way is more efficient if the terrain is dense and the triangles are small
                    // Implemented the second way for now
                    var width = (int)((absoluteMaxX - absoluteMinX) / AStar.GridSize) + 1;
                    var height = (int)((absoluteMaxY - absoluteMinY) / AStar.GridSize) + 1;

                    var aStarMap = new AStar.Map
                    {
                        MinX = absoluteMinX,
                        MinY = absoluteMinY,
                        MaxX = absoluteMaxX,
                        MaxY = absoluteMaxY,
                        MinXWithMargin = absoluteMinX - AStar.Map.Margin,
                        MinYWithMargin = absoluteMinY - AStar.Map.Margin,
                        MaxXWithMargin = absoluteMaxX + AStar.Map.Margin,
                        MaxYWithMargin = absoluteMaxY + AStar.Map.Margin,
                        Width = width,
                        Height = height,
                        Tiles = new bool[width, height],
                        TriangleIds = new int[width, height],
                        Triangles = new List<Triangle>(),
                        TriangleTree = new RBush<AStar.Map.TriangleEnvelope>(maxEntries: 16),
                        TrianglePath = new int[Triangles.Count, Triangles.Count],
                    };
                    for (var i = 0; i < width; i++)
                    {
                        for (var j = 0; j < height; j++)
                        {
                            aStarMap.TriangleIds[i, j] = -1;
                        }
                    }

                    for (var k = 0; k < Triangles.Count; k++)
                    {
                        var triangle = ToTriangle(Triangles[k]);
                        var envelope = new AStar.Map.TriangleEnvelope(k, triangle);
                        aStarMap.TriangleTree.Insert(envelope);
                        aStarMap.Triangles.Add(triangle);

                        var bound = triangle.GetBoundingBox();

                        var minI = (int)((bound.Min.x - absoluteMinX) / AStar.GridSize);
                        var minJ = (int)((bound.Min.y - absoluteMinY) / AStar.GridSize);
                        var maxI = (int)((bound.Max.x - absoluteMinX) / AStar.GridSize);
                        var maxJ = (int)((bound.Max.y - absoluteMinY) / AStar.GridSize);

                        for (var i = minI; i <= maxI; i++)
                        {
                            for (var j = minJ; j <= maxJ; j++)
                            {
                                var point = aStarMap.ToFixedVector2(i, j);
                                if (triangle.Contains(point))
                                {
                                    aStarMap.Tiles[i, j] = true;
                                    aStarMap.TriangleIds[i, j] = k;
                                }
                            }
                        }
                    }

                    var triangleDistance = new FixedFloat[Triangles.Count, Triangles.Count];
                    var three = (FixedFloat)3;
                    var triangleCenter = aStarMap.Triangles.Select(t => (t.P1 + t.P2 + t.P3) / three).ToArray();
                    for (var i = 0; i < Triangles.Count; i++)
                    {
                        for (var j = 0; j < Triangles.Count; j++)
                        {
                            if (i > j)
                                continue;
                            if (i == j)
                                aStarMap.TrianglePath[i, i] = i;
                            else if (IsTriangleConnected(Triangles[i], Triangles[j]))
                            {
                                aStarMap.TrianglePath[i, j] = j;
                                aStarMap.TrianglePath[j, i] = i;
                                triangleDistance[i, j] = triangleDistance[j, i] =
                                    (triangleCenter[i] - triangleCenter[j]).magnitude;
                            }
                            else
                            {
                                aStarMap.TrianglePath[i, j] = -1;
                                aStarMap.TrianglePath[j, i] = -1;
                            }
                        }
                    }
                    for (var k = 0; k < Triangles.Count; k++)
                    {
                        for (var i = 0; i < Triangles.Count; i++)
                        {
                            for (var j = 0; j < Triangles.Count; j++)
                            {
                                if (i == j || i == k || j == k)
                                    continue;
                                if (aStarMap.TrianglePath[i, j] == j)
                                    continue;
                                if (aStarMap.TrianglePath[i, k] == -1 || aStarMap.TrianglePath[k, j] == -1)
                                    continue;
                                if (aStarMap.TrianglePath[i, j] == -1 || aStarMap.TrianglePath[i, j] != j
                                    && triangleDistance[i, j] > triangleDistance[i, k] + triangleDistance[k, j])
                                {
                                    aStarMap.TrianglePath[i, j] = aStarMap.TrianglePath[i, k];
                                    triangleDistance[i, j] = triangleDistance[i, k] + triangleDistance[k, j];
                                }
                            }
                        }
                    }
                    
                    aStarMap.AStar = new AStar(aStarMap);
                    
                    _aStarMap = aStarMap;
                }

#if UNITY_5_3_OR_NEWER
                public float GetHeight(Vector2 position)
                {
                    Init();

                    // Find the triangle that contains the position
                    // As this code is prone to Data-flow optimizations, compiler will optimize the code for us.

                    // step 1: find the bounding box that contains the position

                    // step 2: check if the position is inside the triangle

                    // Multiple points may be found if the position is near the edge of a triangle.
                    var (triangleId, point) = GetNearbyTriangleAndPositionOnTerrain(position, EmptyDisabledTriangles, out var outOfTerrain);
                    if (outOfTerrain)
                        return float.NaN;

                    // step 3: calculate the height
                    // 3d vectors for the triangle
                    var triangle = Triangles[triangleId];
                    var vertex1 = Vertices[(int)triangle.V1];
                    var vertex2 = Vertices[(int)triangle.V2];
                    var vertex3 = Vertices[(int)triangle.V3];
                    
                    var a1 = vertex2.Position.X - vertex1.Position.X;
                    var b1 = vertex2.Position.Y - vertex1.Position.Y;
                    var c1 = vertex2.Height - vertex1.Height;
                    var a2 = vertex3.Position.X - vertex1.Position.X;
                    var b2 = vertex3.Position.Y - vertex1.Position.Y;
                    var c2 = vertex3.Height - vertex1.Height;
                    // equation of the plane: a*x + b*y + c*z + d = 0
                    var a = b1 * c2 - b2 * c1;
                    var b = a2 * c1 - a1 * c2;
                    var c = a1 * b2 - b1 * a2;
                    var d = -a * vertex1.Position.X - b * vertex1.Position.Y - c * vertex1.Height;
                    // Caution: will divide by zero if three points are on the same line
                    var z = (-a * (float)point.x - b * (float)point.y - d) / c;

                    return z;
                }
#endif

                private (int, FixedVector2) GetNearbyTriangleAndPositionOnTerrain(FixedVector2 position,
                    IReadOnlyDictionary<int, bool> disabledTriangles, out bool outOfTerrain, float range = 3f)
                {
                    Init();
                    
                    // Find the nearest position on the terrain.
                    // May not guaranteed to find the absolute nearest position.
                    outOfTerrain = false;

                    // return outOfTerrain as true if failed to found a position

                    // check for intersecting box first

                    // Multiple points may be found. Find the nearest one.
                    var nearestTriangle = -1;
                    var nearest = FixedFloat.MaxValue;
                    var nearestPosition = position;
                    
                    position.x = FixedFloatMath.Clamp(position.x, _aStarMap!.MinXWithMargin, _aStarMap.MaxXWithMargin);
                    position.y = FixedFloatMath.Clamp(position.y, _aStarMap.MinYWithMargin, _aStarMap.MaxYWithMargin);

                    using var envelopes = _aStarMap!.TriangleTree.SearchNonAlloc(new Envelope(MinX: (float)position.x - range,
                        MinY: (float)position.y - range, MaxX: (float)position.x + range,
                        MaxY: (float)position.y + range));
                    foreach (var envelope in envelopes)
                    {
                        var id = envelope.Id;
                        // If the give position is inside any triangle
                        // return the position and set outOfTerrain as false
                        if (_aStarMap.Triangles[id].Contains(position))
                            return (id, position);

                        var nearestPoint = _aStarMap.Triangles[id].GetClosestPoint(position, out var distance);
                        if (distance < nearest)
                        {
                            nearestTriangle = id;
                            nearest = distance;
                            nearestPosition = nearestPoint;
                        }
                    }

                    // No bounding box overlaps with the position
                    outOfTerrain = true;
                    return (nearestTriangle, nearestPosition);
                }

                public FixedVector2 GetNearbyPositionOnTerrain(FixedVector2 position,
                    IReadOnlyDictionary<int, bool> disabledTriangles, out bool outOfTerrain, float range = 3f)
                {
                    return GetNearbyTriangleAndPositionOnTerrain(position, disabledTriangles, out outOfTerrain, range).Item2;
                }

                public void FindPath(FixedVector2 start, FixedVector2 end,
                    IReadOnlyDictionary<int, bool> disabledTriangles, IList<Vector2Message> path)
                {
                    Init();

                    if (ResourceMap.Global.BoardConstants.FixX)
                    {
                        end.x = start.x;
                        path.Add((Vector2Message)end);
                        return;
                    }
                    if (ResourceMap.Global.BoardConstants.FixY)
                    {
                        end.y = start.y;
                        path.Add((Vector2Message)end);
                        return;
                    }

                    int startTriangleId, endTriangleId;
                    (startTriangleId, start) = GetNearbyTriangleAndPositionOnTerrain(start, disabledTriangles, out _);
                    (endTriangleId, end) = GetNearbyTriangleAndPositionOnTerrain(end, disabledTriangles, out var endOutOfTerrain);

                    if (endOutOfTerrain)
                    {
                        end.x = FixedFloatMath.Clamp(end.x, _aStarMap!.MinX, _aStarMap.MaxX);
                        end.y = FixedFloatMath.Clamp(end.y, _aStarMap.MinY, _aStarMap.MaxY);
                    }

                    // 1st heuristic: if the start and end are the same, return the start
                    if (start == end)
                    {
                        return;
                    }

                    // 2nd heuristic: if the start and end are in the same triangle, return the direct path
                    if (startTriangleId == endTriangleId || _aStarMap!.TrianglePath[startTriangleId, endTriangleId] == endTriangleId)
                    {
                        path.Add((Vector2Message)end);
                        return;
                    }

                    // translate the coordinates
                    using var pooledNodes = _aStarMap.AStar.PooledNodesPool.Pop();
                    var startX = (int)((start.x - _aStarMap.MinX) / AStar.GridSize);
                    var startY = (int)((start.y - _aStarMap.MinY) / AStar.GridSize);
                    var endX = (int)((end.x - _aStarMap.MinX) / AStar.GridSize);
                    var endY = (int)((end.y - _aStarMap.MinY) / AStar.GridSize);
                    var startNode = pooledNodes.Nodes[startX, startY];
                    var endNode = pooledNodes.Nodes[endX, endY];
                    
                    if (!_aStarMap.Tiles[startX, startY])
                    {
                        int i;
                        for (i = 0; i < DCount; i++)
                        {
                            var x = startX + Dx[i];
                            var y = startY + Dy[i];
                            if (x < 0 || x >= _aStarMap.Width || y < 0 || y >= _aStarMap.Height)
                                continue;
                            if (_aStarMap.Tiles[x, y])
                            {
                                startNode = pooledNodes.Nodes[x, y];
                                break;
                            }
                        }
                        if (i == DCount)
                            return;
                    }
                    if (!_aStarMap.Tiles[endX, endY])
                    {
                        int i;
                        for (i = 0; i < DCount; i++)
                        {
                            var x = endX + Dx[i];
                            var y = endY + Dy[i];
                            if (x < 0 || x >= _aStarMap.Width || y < 0 || y >= _aStarMap.Height)
                                continue;
                            if (_aStarMap.Tiles[x, y])
                            {
                                endNode = pooledNodes.Nodes[x, y];
                                break;
                            }
                        }
                        if (i == DCount)
                            return;
                    }

                    // Navigate using A*
                    _aStarMap.AStar.FindPath(pooledNodes, startNode, endNode, out var interrupted);

                    // pathResult will be empty if no path is found
                    var nodePath = pooledNodes.Path;
                    if (nodePath.Count == 0)
                        return;
                    var nodeIdx = 0;
                    if (nodePath.Count >= 2)
                    {
                        var p1 = _aStarMap.ToFixedVector2(nodePath[0].X, nodePath[0].Y);
                        var p2 = _aStarMap.ToFixedVector2(nodePath[1].X, nodePath[1].Y);
                        var d1 = p1 - start;
                        var d2 = p2 - start;
                        if (FixedVector2.Dot(d1, d2) < FixedFloat.Zero)
                            nodeIdx = 1;
                    }

                    var currentTriangleId = startTriangleId;
                    for (; nodeIdx < nodePath.Count; ++nodeIdx)
                    {
                        var node = nodePath[nodeIdx];
                        var nodeTriangleId = _aStarMap.TriangleIds[node.X, node.Y];
                        var nodePosition = _aStarMap.ToFixedVector2(node.X, node.Y);
                        if (currentTriangleId != nodeTriangleId)
                        {
                            path.Add((Vector2Message)nodePosition);
                            currentTriangleId = nodeTriangleId;
                        }
                    }

                    if (interrupted)
                    {
                        var lastNode = nodePath[^1];
                        var lastPosition = _aStarMap.ToFixedVector2(lastNode.X, lastNode.Y);
                        path.Add((Vector2Message)lastPosition);
                    }
                    else
                        path.Add((Vector2Message)end);
                }

                private Triangle ToTriangle(Terrain.Types.Triangle triangle)
                {
                    var vertex1 = Vertices[(int)triangle.V1];
                    var vertex2 = Vertices[(int)triangle.V2];
                    var vertex3 = Vertices[(int)triangle.V3];

                    var p1 = new FixedVector2(vertex1.Position.X, vertex1.Position.Y);
                    var p2 = new FixedVector2(vertex2.Position.X, vertex2.Position.Y);
                    var p3 = new FixedVector2(vertex3.Position.X, vertex3.Position.Y);
                    
                    return new Triangle(p1, p2, p3);
                }

                private bool IsTriangleConnected(Terrain.Types.Triangle triangle1, Terrain.Types.Triangle triangle2)
                {
                    return IsSameEdge(triangle1.V1, triangle1.V2, triangle2.V1, triangle2.V2)
                        || IsSameEdge(triangle1.V1, triangle1.V2, triangle2.V2, triangle2.V3)
                        || IsSameEdge(triangle1.V1, triangle1.V2, triangle2.V3, triangle2.V1)
                        || IsSameEdge(triangle1.V2, triangle1.V3, triangle2.V1, triangle2.V2)
                        || IsSameEdge(triangle1.V2, triangle1.V3, triangle2.V2, triangle2.V3)
                        || IsSameEdge(triangle1.V2, triangle1.V3, triangle2.V3, triangle2.V1)
                        || IsSameEdge(triangle1.V3, triangle1.V1, triangle2.V1, triangle2.V2)
                        || IsSameEdge(triangle1.V3, triangle1.V1, triangle2.V2, triangle2.V3)
                        || IsSameEdge(triangle1.V3, triangle1.V1, triangle2.V3, triangle2.V1);
                }
                
                private bool IsSameEdge(uint v1, uint v2, uint v3, uint v4)
                {
                    return (v1 == v3 && v2 == v4) || (v1 == v4 && v2 == v3);
                }
            }
        }
    }    
}
