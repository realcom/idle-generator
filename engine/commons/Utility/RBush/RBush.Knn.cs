using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

namespace RBush
{

	/// <summary>
	/// Extension methods for the <see cref="RBush{T}"/> object.
	/// </summary>
	public static class RBushExtensions
	{
		[StructLayout(LayoutKind.Sequential)]
		private struct ItemDistance<T>
		{
			public T Item { get; }
			public float Distance { get; }

			public ItemDistance(T item, float distance)
			{
				Item = item;
				Distance = distance;
			}

			// Implementing Equals and GetHashCode is a good practice for structs to provide proper value-based comparison
			public override bool Equals(object? obj)
			{
				if (obj is ItemDistance<T> other)
				{
					return EqualityComparer<T>.Default.Equals(Item, other.Item) && Distance == other.Distance;
				}
				return false;
			}

			public override int GetHashCode()
			{
				int hash = 17;
				hash = hash * 31 + Item!.GetHashCode();
				hash = hash * 31 + Distance.GetHashCode();
				return hash;
			}
		}

		// /// <summary>
		// /// Get the <paramref name="k"/> nearest neighbors to a specific point.
		// /// </summary>
		// /// <typeparam name="T">The type of elements in the index.</typeparam>
		// /// <param name="tree">An index of points.</param>
		// /// <param name="k">The number of points to retrieve.</param>
		// /// <param name="x">The x-coordinate of the center point.</param>
		// /// <param name="y">The y-coordinate of the center point.</param>
		// /// <param name="maxDistance">The maximum distance of points to be considered "near"; optional.</param>
		// /// <param name="predicate">A function to test each element for a condition; optional.</param>
		// /// <returns>The list of up to <paramref name="k"/> elements nearest to the given point.</returns>
		// public static IReadOnlyList<T> Knn<T>(
		// 	this ISpatialIndex<T> tree,
		// 	int k,
		// 	float x,
		// 	float y,
		// 	float? maxDistance = null,
		// 	Func<T, bool>? predicate = null)
		// 	where T : ISpatialData
		// {
		// 	var items = maxDistance == null
		// 		? tree.Search()
		// 		: tree.Search(
		// 			new Envelope(
		// 				MinX: x - maxDistance.Value,
		// 				MinY: y - maxDistance.Value,
		// 				MaxX: x + maxDistance.Value,
		// 				MaxY: y + maxDistance.Value));
		//
		// 	var distances = items
		// 		.Select(i => new ItemDistance<T>(i, i.Envelope.DistanceTo(x, y)))
		// 		.OrderBy(i => i.Distance)
		// 		.AsEnumerable();
		//
		// 	if (maxDistance.HasValue)
		// 		distances = distances.TakeWhile(i => i.Distance <= maxDistance.Value);
		//
		// 	if (predicate != null)
		// 		distances = distances.Where(i => predicate(i.Item));
		//
		// 	if (k > 0)
		// 		distances = distances.Take(k);
		//
		// 	return distances
		// 		.Select(i => i.Item)
		// 		.ToList();
		// }

		/// <summary>
		/// Calculates the distance from the borders of an <see cref="Envelope"/>
		/// to a given point.
		/// </summary>
		/// <param name="envelope">The <see cref="Envelope"/> from which to find the distance</param>
		/// <param name="x">The x-coordinate of the given point</param>
		/// <param name="y">The y-coordinate of the given point</param>
		/// <returns>The calculated Euclidean shortest distance from the <paramref name="envelope"/> to a given point.</returns>
		public static float DistanceTo(this in Envelope envelope, float x, float y)
		{
			var dX = AxisDistance(x, envelope.MinX, envelope.MaxX);
			var dY = AxisDistance(y, envelope.MinY, envelope.MaxY);
			return (float)Math.Sqrt((dX * dX) + (dY * dY));

			static float AxisDistance(float p, float min, float max) =>
				p < min ? min - p :
				p > max ? p - max :
				0;
		}
	}
}