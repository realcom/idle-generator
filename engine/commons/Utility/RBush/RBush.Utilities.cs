using System;
using System.Buffers;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace RBush
{

	public partial class RBush<T>
	{
		#region Sort Functions

		private static readonly IComparer<ISpatialData> s_compareMinX =
			Comparer<ISpatialData>.Create((x, y) => Comparer<float>.Default.Compare(x.Envelope.MinX, y.Envelope.MinX));

		private static readonly IComparer<ISpatialData> s_compareMinY =
			Comparer<ISpatialData>.Create((x, y) => Comparer<float>.Default.Compare(x.Envelope.MinY, y.Envelope.MinY));
		
		private static readonly IComparer<T> compareMinX =
			Comparer<T>.Create((x, y) => Comparer<float>.Default.Compare(x.Envelope.MinX, y.Envelope.MinX));
		
		private static readonly IComparer<T> compareMinY =
			Comparer<T>.Create((x, y) => Comparer<float>.Default.Compare(x.Envelope.MinY, y.Envelope.MinY));

		#endregion
		
		private readonly Stack<Node> _cachedNodes = new();
		private readonly ConcurrentObjectPool<PooledQueue<Node>> _retrievalQueuePool = new(2 * Environment.ProcessorCount);

		private void PushNode(Node node)
		{
			node.Items.Clear();
			_cachedNodes.Push(node);
		}

		private Node PopNode(int height)
		{
			if (!_cachedNodes.TryPop(out var node))
				node = new Node();
			node.Init(height);
			return node;
		}

		private Node PopNode(ISpatialData item, int height)
		{
			if (!_cachedNodes.TryPop(out var node))
				node = new Node();
			node.Init(item, height);
			return node;
		}

		private Node PopNode(IEnumerable<ISpatialData> items, int height)
		{
			if (!_cachedNodes.TryPop(out var node))
				node = new Node();
			node.Init(items, height);
			return node;
		}

		#region Search

		private void DoSearchNonAlloc(in Envelope boundingBox, List<T> intersections)
		{
			intersections.Clear();
			if (!Root.Envelope.Intersects(boundingBox))
				return;

			using var queue = _retrievalQueuePool.Pop();
			queue.Enqueue(Root);
			while (queue.TryDequeue(out var node))
			{
				if (node.IsLeaf)
				{
					foreach (var i in node.Items)
					{
						if (i.Envelope.Intersects(boundingBox))
							intersections.Add((T)i);
					}
				}
				else
				{
					foreach (var i in node.Items)
					{
						if (i.Envelope.Intersects(boundingBox))
							queue.Enqueue((Node)i);
					}
				}
			}
		}

		#endregion

		#region Insert

		private void FindCoveringArea(in Envelope area, int depth, List<Node> path)
		{
			var node = this.Root;

			while (true)
			{
				path.Add(node);
				if (node.IsLeaf || path.Count == depth) return;

				var next = node.Items[0];
				var nextArea = next.Envelope.Extend(area).Area;

				foreach (var i in node.Items)
				{
					var newArea = i.Envelope.Extend(area).Area;
					if (newArea > nextArea)
						continue;

					if (newArea == nextArea
					    && i.Envelope.Area >= next.Envelope.Area)
						continue;

					next = i;
					nextArea = newArea;
				}

				node = (next as Node)!;
			}
		}

		private void Insert(ISpatialData data, int depth)
		{
			using var path = ConcurrentObjectPool<PooledList<Node>>.StaticPool.Pop();
			FindCoveringArea(data.Envelope, depth, path);

			var insertNode = path[^1];
			insertNode.Add(data);

			while (--depth >= 0)
			{
				if (path[depth].Items.Count > _maxEntries)
				{
					var newNode = SplitNode(path[depth]);
					if (depth == 0)
						SplitRoot(newNode);
					else
						path[depth - 1].Add(newNode);
				}
				else
					path[depth].ResetEnvelope();
			}
		}

		#region SplitNode

		private void SplitRoot(Node newNode) =>
			Root = PopNode(new[]{ Root, newNode }, Root.Height + 1);

		private Node SplitNode(Node node)
		{
			SortChildren(node);

			var splitPoint = GetBestSplitIndex(node.Items);
			var newNode = PopNode(node.Items.Skip(splitPoint), node.Height);
			node.RemoveRange(splitPoint, node.Items.Count - splitPoint);
			return newNode;
		}

		#region SortChildren

		private void SortChildren(Node node)
		{
			node.Items.Sort(s_compareMinX);
			var splitsByX = GetPotentialSplitMargins(node.Items);
			node.Items.Sort(s_compareMinY);
			var splitsByY = GetPotentialSplitMargins(node.Items);

			if (splitsByX < splitsByY)
				node.Items.Sort(s_compareMinX);
		}

		private float GetPotentialSplitMargins(List<ISpatialData> children) =>
			GetPotentialEnclosingMargins(children) +
			GetPotentialEnclosingMargins(children.AsEnumerable().Reverse().ToList());

		private float GetPotentialEnclosingMargins(List<ISpatialData> children)
		{
			var envelope = Envelope.EmptyBounds;
			var i = 0;
			for (; i < _minEntries; i++)
			{
				envelope = envelope.Extend(children[i].Envelope);
			}

			var totalMargin = envelope.Margin;
			for (; i < children.Count - _minEntries; i++)
			{
				envelope = envelope.Extend(children[i].Envelope);
				totalMargin += envelope.Margin;
			}

			return totalMargin;
		}

		#endregion

		private int GetBestSplitIndex(List<ISpatialData> children)
		{
			return Enumerable.Range(_minEntries, children.Count - _minEntries)
				.Select(i =>
				{
					var leftEnvelope = GetEnclosingEnvelope(children, 0, i);
					var rightEnvelope = GetEnclosingEnvelope(children, i, children.Count);

					var overlap = leftEnvelope.Intersection(rightEnvelope).Area;
					var totalArea = leftEnvelope.Area + rightEnvelope.Area;
					return new { i, overlap, totalArea };
				})
				.OrderBy(x => x.overlap)
				.ThenBy(x => x.totalArea)
				.Select(x => x.i)
				.First();
		}

		#endregion

		#endregion

		#region BuildTree

		private Node BuildTree(IReadOnlyList<T> data)
		{
			var treeHeight = GetDepth(data.Count);
			var rootMaxEntries = (int)Math.Ceiling(data.Count / Math.Pow(_maxEntries, treeHeight - 1));
			var array = ArrayPool<T>.Shared.Rent(data.Count);
			try
			{
				for (var i = 0; i < data.Count; i++)
					array[i] = data[i];
				return BuildNodes(new ArraySegment<T>(array, 0, data.Count), treeHeight, rootMaxEntries);
			}
			finally
			{
				ArrayPool<T>.Shared.Return(array);
			}
		}

		private int GetDepth(int numNodes) =>
			(int)Math.Ceiling(Math.Log(numNodes) / Math.Log(_maxEntries));

		private Node BuildNodes(ArraySegment<T> data, int height, int maxEntries)
		{
			if (data.Count <= maxEntries)
			{
				return height == 1
					? PopNode(data.Cast<ISpatialData>(), height)
					: PopNode(BuildNodes(data, height - 1, _maxEntries), height);
			}

			Array.Sort(data.Array!, data.Offset, data.Count, compareMinX);

			var nodeSize = (data.Count + (maxEntries - 1)) / maxEntries;
			var subSortLength = nodeSize * (int)Math.Ceiling(Math.Sqrt(maxEntries));

			var children = new List<ISpatialData>(maxEntries);
			foreach (var subData in Chunk(data, subSortLength))
			{
				Array.Sort(subData.Array!, subData.Offset, subData.Count, compareMinY);

				foreach (var nodeData in Chunk(subData, nodeSize))
				{
					children.Add(BuildNodes(nodeData, height - 1, _maxEntries));
				}
			}

			return PopNode(children, height);
		}

		private static IEnumerable<ArraySegment<T>> Chunk(ArraySegment<T> values, int chunkSize)
		{
			var start = 0;
			while (start < values.Count)
			{
				var len = Math.Min(values.Count - start, chunkSize);
				yield return new ArraySegment<T>(values.Array!, values.Offset + start, len);
				start += chunkSize;
			}
		}

		#endregion

		private static Envelope GetEnclosingEnvelope(List<ISpatialData> items, int start, int end)
		{
			var envelope = Envelope.EmptyBounds;
			for (var i = start; i < end; i++)
			{
				envelope = envelope.Extend(items[i].Envelope);
			}

			return envelope;
		}

		private IEnumerable<T> GetAllChildren()
		{
			using var queue = _retrievalQueuePool.Pop();
			queue.Enqueue(Root);
			while (queue.TryDequeue(out var node))
			{
				if (node.IsLeaf)
				{
					foreach (var item in node.Items)
						yield return (T)item;
				}
				else
				{
					foreach (var i in node.Items)
						queue.Enqueue((Node)i);
				}
			}
		}

	}
}