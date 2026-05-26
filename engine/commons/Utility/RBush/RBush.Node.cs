using System.Collections.Generic;

namespace RBush
{


	public partial class RBush<T>
	{
		/// <summary>
		/// A node in an R-tree data structure containing other nodes
		/// or elements of type <typeparamref name="T"/>.
		/// </summary>
		public class Node : ISpatialData
		{
			private Envelope _envelope;

			internal void Init(int height)
			{
				Height = height;
				ResetEnvelope();
			}

			internal void Init(ISpatialData item, int height)
			{
				Height = height;
				Items.Add(item);
				ResetEnvelope();
			}

			internal void Init(IEnumerable<ISpatialData> items, int height)
			{
				Height = height;
				Items.AddRange(items);
				ResetEnvelope();
			}

			internal void Add(ISpatialData node)
			{
				Items.Add(node);
				_envelope = Envelope.Extend(node.Envelope);
			}

			internal void Remove(ISpatialData node)
			{
				Items.Remove(node);
				ResetEnvelope();
			}

			internal void RemoveRange(int index, int count)
			{
				Items.RemoveRange(index, count);
				ResetEnvelope();
			}

			internal void ResetEnvelope()
			{
				_envelope = GetEnclosingEnvelope(Items, 0, Items.Count);
			}

			internal readonly List<ISpatialData> Items = new();

			/// <summary>
			/// The descendent nodes or elements of a <see cref="Node"/>
			/// </summary>
			public IReadOnlyList<ISpatialData> Children => Items;

			/// <summary>
			/// The current height of a <see cref="Node"/>. 
			/// </summary>
			/// <remarks>
			/// A node containing individual elements has a <see cref="Height"/> of 1.
			/// </remarks>
			public int Height { get; private set; }

			/// <summary>
			/// Determines whether the current <see cref="Node"/> is a leaf node.
			/// </summary>
			public bool IsLeaf => Height == 1;

			/// <summary>
			/// Gets the bounding box of all of the descendents of the 
			/// current <see cref="Node"/>.
			/// </summary>
			public ref readonly Envelope Envelope => ref _envelope;
		}
	}
}