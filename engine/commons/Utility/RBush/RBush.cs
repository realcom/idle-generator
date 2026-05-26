using System;
using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace RBush
{

	/// <summary>
	/// An implementation of the R-tree data structure for 2-d spatial indexing.
	/// </summary>
	/// <typeparam name="T">The type of elements in the index.</typeparam>
	public partial class RBush<T> : ISpatialDatabase<T> where T : ISpatialData
	{
		private const int DefaultMaxEntries = 9;
		private const int MinimumMaxEntries = 4;
		private const int MinimumMinEntries = 2;
		private const float DefaultFillFactor = 0.4f;
		private const int DefaultRetrievalQueueSize = 16;

		private readonly IEqualityComparer<T> _comparer;
		private readonly int _maxEntries;
		private readonly int _minEntries;

		/// <summary>
		/// The root of the R-tree.
		/// </summary>
		public Node Root { get; private set; }

		/// <summary>
		/// The bounding box of all elements currently in the data structure.
		/// </summary>
		public ref readonly Envelope Envelope => ref Root.Envelope;
		
		private readonly ConcurrentObjectPool<PooledList<T>> _searchResultPool = new(2 * Environment.ProcessorCount);

		/// <summary>
		/// Initializes a new instance of the <see cref="RBush{T}"/> that is
		/// empty and has the default tree width and default <see cref="IEqualityComparer{T}"/>.
		/// </summary>
		public RBush()
			: this(DefaultMaxEntries, EqualityComparer<T>.Default)
		{
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="RBush{T}"/> that is
		/// empty and has a custom max number of elements per tree node
		/// and default <see cref="IEqualityComparer{T}"/>.
		/// </summary>
		/// <param name="maxEntries"></param>
		public RBush(int maxEntries)
			: this(maxEntries, EqualityComparer<T>.Default)
		{
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="RBush{T}"/> that is
		/// empty and has a custom max number of elements per tree node
		/// and a custom <see cref="IEqualityComparer{T}"/>.
		/// </summary>
		/// <param name="maxEntries"></param>
		/// <param name="comparer"></param>
		public RBush(int maxEntries, IEqualityComparer<T> comparer)
		{
			this._comparer = comparer;
			this._maxEntries = Math.Max(MinimumMaxEntries, maxEntries);
			this._minEntries = Math.Max(MinimumMinEntries, (int)Math.Ceiling(this._maxEntries * DefaultFillFactor));

			this.Clear();
		}

		/// <summary>
		/// Gets the number of items currently stored in the <see cref="RBush{T}"/>
		/// </summary>
		public int Count { get; private set; }

		/// <summary>
		/// Removes all elements from the <see cref="RBush{T}"/>.
		/// </summary>
		// [MemberNotNull(nameof(Root))]
		public void Clear()
		{
			if (Root != null)
				ClearRoot();
			Root = PopNode(1);
			Count = 0;
		}

		private void ClearRoot()
		{
			using var queue = ConcurrentObjectPool<PooledQueue<Node>>.StaticPool.Pop();
			queue.Enqueue(Root);
			while (queue.TryDequeue(out var node))
			{
				if (!node.IsLeaf)
				{
					foreach (var child in node.Items)
						queue.Enqueue((Node)child);
				}

				PushNode(node);
			}
		}

		/// <summary>
		/// Get all of the elements within the current <see cref="RBush{T}"/>.
		/// </summary>
		/// <returns>
		/// A list of every element contained in the <see cref="RBush{T}"/>.
		/// </returns>
		public IEnumerable<T> Search()
		{
			foreach (var child in GetAllChildren())
				yield return child;
		}

		/// <summary>
		/// Get all of the elements from this <see cref="RBush{T}"/>
		/// within the <paramref name="boundingBox"/> bounding box.
		/// </summary>
		/// <param name="boundingBox">The area for which to find elements.</param>
		/// <returns>
		/// A list of the points that are within the bounding box
		/// from this <see cref="RBush{T}"/>.
		/// </returns>
		public IEnumerable<T> Search(in Envelope boundingBox)
		{
			var intersections = new List<T>();
			DoSearchNonAlloc(boundingBox, intersections);
			return intersections;
		}

		/// <summary>
		/// Get all of the elements from this <see cref="RBush{T}"/>
		/// within the <paramref name="boundingBox"/> bounding box
		/// without allocation.
		/// </summary>
		/// <param name="boundingBox">The area for which to find elements.</param>
		/// <param name="intersections">A list to store results.</param>
		/// <returns>
		/// A list of the points that are within the bounding box
		/// from this <see cref="RBush{T}"/>.
		/// </returns>
		public PooledList<T> SearchNonAlloc(in Envelope boundingBox)
		{
			var searchResult = _searchResultPool.Pop();
			DoSearchNonAlloc(boundingBox, searchResult);
			return searchResult;
		}

		/// <summary>
		/// Adds an object to the <see cref="RBush{T}"/>
		/// </summary>
		/// <param name="item">
		/// The object to be added to <see cref="RBush{T}"/>.
		/// </param>
		public void Insert(T item)
		{
			Insert(item, this.Root.Height);
			this.Count++;
		}

		/// <summary>
		/// Adds all of the elements from the collection to the <see cref="RBush{T}"/>.
		/// </summary>
		/// <param name="items">
		/// A collection of items to add to the <see cref="RBush{T}"/>.
		/// </param>
		/// <remarks>
		/// For multiple items, this method is more performant than 
		/// adding items individually via <see cref="Insert(T)"/>.
		/// </remarks>
		public void BulkLoad(IReadOnlyList<T> items)
		{
			if (items.Count == 0)
				return;
			
			if (this.Root.IsLeaf &&
			    this.Root.Items.Count + items.Count < _maxEntries)
			{
				foreach (var i in items)
					Insert(i);
				return;
			}

			if (items.Count < this._minEntries)
			{
				foreach (var i in items)
					Insert(i);
				return;
			}

			var dataRoot = BuildTree(items);
			this.Count += items.Count;

			if (this.Root.Items.Count == 0)
				this.Root = dataRoot;
			else if (this.Root.Height == dataRoot.Height)
			{
				if (this.Root.Items.Count + dataRoot.Items.Count <= this._maxEntries)
				{
					foreach (var isd in dataRoot.Items)
						this.Root.Add(isd);
				}
				else
					SplitRoot(dataRoot);
			}
			else
			{
				if (this.Root.Height < dataRoot.Height)
				{
#pragma warning disable IDE0180 // netstandard 1.2 doesn't support tuple
					var tmp = this.Root;
					this.Root = dataRoot;
					dataRoot = tmp;
#pragma warning restore IDE0180
				}

				this.Insert(dataRoot, this.Root.Height - dataRoot.Height);
			}
		}

		/// <summary>
		/// Removes an object from the <see cref="RBush{T}"/>.
		/// </summary>
		/// <param name="item">
		/// The object to be removed from the <see cref="RBush{T}"/>.
		/// </param>
		/// <returns><see langword="bool" /> indicating whether the item was deleted.</returns>
		public bool Delete(T item) =>
			DoDelete(Root, item);

		private bool DoDelete(Node node, T item)
		{
			if (!node.Envelope.Contains(item.Envelope))
				return false;

			if (node.IsLeaf)
			{
				var cnt = node.Items.RemoveAll(i => _comparer.Equals((T)i, item));
				if (cnt != 0)
				{
					Count -= cnt;
					node.ResetEnvelope();
					return true;
				}
				else
					return false;
			}

			var flag = false;
			foreach (Node n in node.Items)
			{
				flag |= DoDelete(n, item);
			}

			if (flag)
				node.ResetEnvelope();
			return flag;
		}
	}
}