using System;
using System.Collections.Generic;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using RBush;

namespace Commons.Algorithm.AStar
{
    public class AStar
    {
        public class Map
        {
            public class TriangleEnvelope : BoundingBoxEnvelope
            {
                public readonly int Id;

                public TriangleEnvelope(int id, Triangle triangle) : base(triangle.GetBoundingBox())
                {
                    Id = id;
                }
            }

            public static readonly FixedFloat Margin = FixedFloat.One;
            
            public FixedFloat MinX;
            public FixedFloat MinY;
            public FixedFloat MaxX;
            public FixedFloat MaxY;
            public FixedFloat MinXWithMargin;
            public FixedFloat MinYWithMargin;
            public FixedFloat MaxXWithMargin;
            public FixedFloat MaxYWithMargin;
            public int Width;
            public int Height;
            public bool[,] Tiles;
            public int[,] TriangleIds;
            public AStar AStar;
            public List<Triangle> Triangles;
            public RBush<TriangleEnvelope> TriangleTree;
            public int[,] TrianglePath;

            public FixedVector2 ToFixedVector2(int nodeX, int nodeY)
            {
                return new FixedVector2(nodeX * GridSize + MinX, nodeY * GridSize + MinY);
            }
        }
        
        public class Node
        {
            public readonly int X;
            public readonly int Y;
            public FixedFloat GCost; // Cost from start node
            public FixedFloat HCost; // Heuristic cost to end node
            public FixedFloat FCost; // Total cost
            public bool Closed;
            public Node? Parent;

            public Node(int x, int y)
            {
                X = x;
                Y = y;
            }

            public void Clear()
            {
                GCost = FixedFloat.Zero;
                HCost = FixedFloat.Zero;
                FCost = FixedFloat.Zero;
                Closed = false;
                Parent = null;
            }

            public void SetCost(FixedFloat gCost, FixedFloat hCost)
            {
                GCost = gCost;
                HCost = hCost;
                FCost = GCost + HCost;
            }
            
            public void SetGCost(FixedFloat gCost)
            {
                GCost = gCost;
                FCost = GCost + HCost;
            }

            public void SetParent(Node parent)
            {
                Parent = parent;
            }
        }

        public class PooledNodes : PooledObject<PooledNodes>
        {
            public Node[,] Nodes = null!;
            private int _width;
            private int _height;
            public readonly List<Node> Path = new();

            public void Initialize(int width, int height)
            {
                _width = width;
                _height = height;
                Nodes = new Node[width, height];
                for (var x = 0; x < width; ++x)
                {
                    for (var y = 0; y < height; ++y)
                    {
                        Nodes[x, y] = new Node(x, y);
                    }
                }
            }

            protected override void Clear()
            {
                Path.Clear();
                for (var x = 0; x < _width; ++x)
                {
                    for (var y = 0; y < _height; ++y)
                    {
                        Nodes[x, y].Clear();
                    }
                }
            }
        }

        
        private static readonly ConcurrentObjectPool<PooledPriorityQueue<Node, FixedFloat>> NodePriorityQueuePool = new(2 * Environment.ProcessorCount);
        
        public static readonly FixedFloat GridSize = 0.125f;
        private const int MaxCost = 4096;
        private static readonly int[] Dx = {-1, 0, 1, -1, 1, -1, 0, 1};
        private static readonly int[] Dy = {-1, -1, -1, 0, 0, 1, 1, 1};
        private static readonly int DCount = Dx.Length;

        public readonly ConcurrentObjectPool<PooledNodes> PooledNodesPool;
        
        private readonly Map _map;
        
        public AStar(Map map)
        {
            _map = map;
            PooledNodesPool = new ConcurrentObjectPool<PooledNodes>(2 * Environment.ProcessorCount,
                nodes => nodes.Initialize(map.Width, map.Height));
        }

        public void FindPath(PooledNodes pooledNodes, Node startNode, Node endNode, out bool interrupted, int maxCost = MaxCost)
        {
            using var openSet = NodePriorityQueuePool.Pop();

            interrupted = false;
            
            startNode.SetCost(FixedFloat.Zero, ComputeHeuristic(startNode, endNode));
            openSet.Enqueue(startNode, startNode.FCost);
            var direction = 0;
            var cost = maxCost;
            var lastNode = startNode;
            while (openSet.TryDequeue(out var current, out _))
            {
                if (ReferenceEquals(current, endNode))
                {
                    ReconstructPath(pooledNodes, endNode);
                    return;
                }
                
                if (current.Closed)
                    continue;
                current.Closed = true;
                lastNode = current;
                
                if (--cost <= 0)
                {
                    interrupted = true;
                    break;
                }
                
                var currentTriangleId = _map.TriangleIds[current.X, current.Y];
                direction += 3;
                for (var i = 0; i < DCount; i++)
                {
                    var idx = (direction + i) % DCount;
                    var nx = current.X + Dx[idx];
                    var ny = current.Y + Dy[idx];
                    if (nx >= 0 && nx < _map.Width && ny >= 0 && ny < _map.Height)
                    {
                        var neighbor = pooledNodes.Nodes[nx, ny];
                        var neighborTriangleId = _map.TriangleIds[nx, ny];
                        if (neighborTriangleId < 0)
                            continue;
                        if (!neighbor.Closed && _map.TrianglePath[currentTriangleId, neighborTriangleId] >= 0)
                        {
                            var tentativeGCost = current.GCost + GetDistance(current, neighbor);
                            if (neighbor.GCost == FixedFloat.Zero || tentativeGCost < neighbor.GCost)
                            {
                                if (neighbor.Parent == null)
                                {
                                    neighbor.SetParent(current);
                                    neighbor.SetCost(tentativeGCost, ComputeHeuristic(neighbor, endNode));
                                }
                                else
                                    neighbor.SetGCost(tentativeGCost);
                                openSet.Enqueue(neighbor, neighbor.FCost);
                            }
                        }
                    }
                }
            }

            // No path found
            ReconstructPath(pooledNodes, lastNode);
        }

        private void ReconstructPath(PooledNodes pooledNodes, Node endNode)
        {
            var path = pooledNodes.Path;
            var current = endNode;
            while (true)
            {
                path.Add(current);
                if (current.Parent is null)
                    break;
                current = current.Parent;
            }
            path.Reverse();
        }
        
        private FixedFloat ComputeHeuristic(Node a, Node b)
        {
            // Euclidean distance (suitable for diagonal movement)
            return FixedFloatMath.Sqrt((a.X - b.X) * (a.X - b.X) + (a.Y - b.Y) * (a.Y - b.Y));
        }

        private FixedFloat GetDistance(Node a, Node b)
        {
            if (a.X == b.X || a.Y == b.Y)
                return FixedFloat.One;
            return FixedFloat.Sqrt2;
        }
    }
}
