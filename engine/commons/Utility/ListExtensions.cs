using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Types;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using Google.Protobuf.Collections;

namespace Commons.Utility
{
    public static class ListExtensions
    {
        public static T? GetSafe<T>(this IReadOnlyList<T> list, int index, T? @default = default)
        {
            if (index < 0 || index >= list.Count)
                return @default;
            return list[index];
        }
        
        public static void SetSafe<T>(this IList<T> list, int index, T value)
        {
            if (index < 0 || index >= list.Count)
                return;
            list[index] = value;
        }
        
        public static T? GetClamped<T>(this IReadOnlyList<T> list, int index)
        {
            if (list.Count == 0)
                return default;
            if (index < 0)
                return list[0];
            if (index >= list.Count)
                return list[^1];
            return list[index];
        }
        
        public static T? PickOne<T>(this IReadOnlyList<T> list)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            return list[StaticRandom.Next(list.Count)];
        }
        
        public static T? PickOne<T>(this IReadOnlyList<T> list, IRng rng)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            return list[rng.Random(list.Count)];
        }
        
        public static T PickOne<T>(this IEnumerable<T> items, IRng rng, Func<T, bool> predicate = null, T _default = default)
        {
            using var list = ConcurrentObjectPool<PooledList<T>>.StaticPool.Pop();
		
            foreach (var item in items)
            {
                if (predicate?.Invoke(item) != false)
                    list.Add(item);
            }
		
            var count = list.Count;

            if (count == 0)
                return _default;
            
            return list[rng.Random(list.Count)];
        }
        
        public static T? PickOne<T>(this HashSet<T> set)
        {
            var count = set.Count;
            if (count == 0)
                return default;

            var index = StaticRandom.Next(count);
            var current = 0;
            foreach (var item in set)
            {
                if (current == index)
                    return item;
                current++;
            }
            return default;
        }
        
        public static T? PickOne<T>(this HashSet<T> set, IRng rng)
        {
            var count = set.Count;
            if (count == 0)
                return default;

            var index = rng.Random(count);
            var current = 0;
            foreach (var item in set)
            {
                if (current == index)
                    return item;
                current++;
            }
            return default;
        }
        
        
        public static T? CryptoPickOne<T>(this IReadOnlyList<T> list)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            return list[StaticRandom.CryptoNext(list.Count)];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
                return list[StaticRandom.Next(list.Count)];
            var value = StaticRandom.NextFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, float totalWeight, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            if (totalWeight <= 0)
                return list[StaticRandom.Next(list.Count)];
            var value = StaticRandom.NextFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, IList<float> weightList)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = weightList.Sum();
            if (totalWeight <= 0)
                return list[StaticRandom.Next(list.Count)];
            var value = StaticRandom.NextFloat() * totalWeight;
            for (var i = 0; i < list.Count; ++i)
            {
                var weight = weightList[i];
                if (value < weight)
                    return list[i];
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, IRng rng, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
                return list[rng.Random(list.Count)];
            var value = rng.RandomFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, IRng rng, float totalWeight, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            if (totalWeight <= 0)
                return list[rng.Random(list.Count)];
            var value = rng.RandomFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? PickWeighted<T>(this IReadOnlyList<T> list, IRng rng, IList<float> weightList)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = weightList.Sum();
            if (totalWeight <= 0)
                return list[rng.Random(list.Count)];
            var value = rng.RandomFloat() * totalWeight;
            for (var i = 0; i < list.Count; ++i)
            {
                var weight = weightList[i];
                if (value < weight)
                    return list[i];
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? CryptoPickWeighted<T>(this IReadOnlyList<T> list, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
                return list[StaticRandom.CryptoNext(list.Count)];
            var value = StaticRandom.CryptoNextFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? CryptoPickWeighted<T>(this IReadOnlyList<T> list, float totalWeight, Func<T, float> weightFunc)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            if (totalWeight <= 0)
                return list[StaticRandom.CryptoNext(list.Count)];
            var value = StaticRandom.CryptoNextFloat() * totalWeight;
            foreach (var item in list)
            {
                var weight = weightFunc(item);
                if (value < weight)
                    return item;
                value -= weight;
            }
            return list[^1];
        }
        
        public static T? CryptoPickWeighted<T>(this IReadOnlyList<T> list, IList<float> weightList)
        {
            if (list.Count == 0)
                return default;
            if (list.Count == 1)
                return list[0];
            var totalWeight = weightList.Sum();
            if (totalWeight <= 0)
                return list[StaticRandom.CryptoNext(list.Count)];
            var value = StaticRandom.CryptoNextFloat() * totalWeight;
            for (var i = 0; i < list.Count; ++i)
            {
                var weight = weightList[i];
                if (value < weight)
                    return list[i];
                value -= weight;
            }
            return list[^1];
        }
        
        public static IEnumerable<T> PickMany<T>(this IReadOnlyList<T> items, int count)
        {
            if (count <= 0 || items.Count == 0)
                return Enumerable.Empty<T>();
            if (count == 1)
                return new[] { items[StaticRandom.Next(items.Count)] };
            
            var list = new List<T>(items);
            list.Shuffle();
            return list.Take(count);
        }
        
        public static IEnumerable<T> PickMany<T>(this IReadOnlyList<T> items, int count, IRng rng)
        {
            if (count <= 0 || items.Count == 0)
                return Enumerable.Empty<T>();
            if (count == 1)
                return new[] { items[rng.Random(items.Count)] };
            
            var list = new List<T>(items);
            list.Shuffle(rng);
            return list.Take(count);
        }

        public static IEnumerable<T> CryptoPickMany<T>(this IReadOnlyList<T> items, int count)
        {
            if (count <= 0 || items.Count == 0)
                return Enumerable.Empty<T>();
            if (count == 1)
                return new[] { items[StaticRandom.CryptoNext(items.Count)] };
            
            var list = new List<T>(items);
            list.CryptoShuffle();
            return list.Take(count);
        }
        
        public static IEnumerable<T> PickManyBalanced<T>(this IReadOnlyList<T> items, int count)
        {
            if (count <= 0 || items.Count == 0)
                yield break;
            if (count == 1)
            {
                yield return items[StaticRandom.Next(items.Count)];
                yield break;
            }
            
            var list = new List<T>(items);
            var fullCount = count / list.Count;
            for (var i = 0; i < fullCount; ++i)
            {
                foreach (var item in list)
                    yield return item;
            }
            
            var remainingCount = count % list.Count;
            if (remainingCount > 0)
            {
                list.Shuffle();
                foreach (var item in list.Take(remainingCount))
                    yield return item;
            }
        }
        
        public static IEnumerable<T> PickManyBalanced<T>(this IReadOnlyList<T> items, int count, IRng rng)
        {
            if (count <= 0 || items.Count == 0)
                yield break;
            if (count == 1)
            {
                yield return items[rng.Random(items.Count)];
                yield break;
            }
            
            var list = new List<T>(items);
            var fullCount = count / list.Count;
            for (var i = 0; i < fullCount; ++i)
            {
                foreach (var item in list)
                    yield return item;
            }
            
            var remainingCount = count % list.Count;
            if (remainingCount > 0)
            {
                list.Shuffle(rng);
                foreach (var item in list.Take(remainingCount))
                    yield return item;
            }
        }

        public static IEnumerable<T> CryptoPickManyBalanced<T>(this IReadOnlyList<T> items, int count)
        {
            if (count <= 0 || items.Count == 0)
                yield break;
            if (count == 1)
            {
                yield return items[StaticRandom.CryptoNext(items.Count)];
                yield break;
            }
            
            var list = new List<T>(items);
            var fullCount = count / list.Count;
            for (var i = 0; i < fullCount; ++i)
            {
                foreach (var item in list)
                    yield return item;
            }
            
            var remainingCount = count % list.Count;
            if (remainingCount > 0)
            {
                list.CryptoShuffle();
                foreach (var item in list.Take(remainingCount))
                    yield return item;
            }
        }
        
        public static IEnumerable<T> PickManyWeighted<T>(this IReadOnlyList<T> list, int count, Func<T, float> weightFunc)
        {
            if (list.Count == 0 || count <= 0)
                yield break;
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
            {
                for (var i = 0; i < count; ++i)
                    yield return list[StaticRandom.Next(list.Count)];
                yield break;
            }
            
            for (var i = 0; i < count; ++i)
            {
                var value = StaticRandom.NextFloat() * totalWeight;
                foreach (var item in list)
                {
                    var weight = weightFunc(item);
                    if (value < weight)
                    {
                        yield return item;
                        break;
                    }
                    value -= weight;
                }
            }
        }
        
        public static IEnumerable<T> PickManyWeighted<T>(this IReadOnlyList<T> list, int count, IRng rng, Func<T, float> weightFunc)
        {
            if (list.Count == 0 || count <= 0)
                yield break;
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
            {
                for (var i = 0; i < count; ++i)
                    yield return list[rng.Random(list.Count)];
                yield break;
            }
            
            for (var i = 0; i < count; ++i)
            {
                var value = rng.RandomFloat() * totalWeight;
                foreach (var item in list)
                {
                    var weight = weightFunc(item);
                    if (value < weight)
                    {
                        yield return item;
                        break;
                    }
                    value -= weight;
                }
            }
        }
        
        public static IEnumerable<T> CrpytoPickManyWeighted<T>(this IReadOnlyList<T> list, int count, Func<T, float> weightFunc)
        {
            if (list.Count == 0 || count <= 0)
                yield break;
            var totalWeight = list.Sum(weightFunc);
            if (totalWeight <= 0)
            {
                for (var i = 0; i < count; ++i)
                    yield return list[StaticRandom.CryptoNext(list.Count)];
                yield break;
            }
            
            for (var i = 0; i < count; ++i)
            {
                var value = StaticRandom.CryptoNextFloat() * totalWeight;
                foreach (var item in list)
                {
                    var weight = weightFunc(item);
                    if (value < weight)
                    {
                        yield return item;
                        break;
                    }
                    value -= weight;
                }
            }
        }
        
        // Note: this function breaks if the sum of weights is negative
        public static IEnumerable<T> PickManyWeightedUnique<T>(
            this IReadOnlyList<T> list,
            int count,
            IRng rng,
            Func<T, float> weightFunc)
        {
            if (list.Count == 0 || count <= 0)
                yield break;
            if (count > list.Count)
                yield break;

            var items = new List<T>(list);
            var weights = items.Select(weightFunc).ToList();

            for (var i = 0; i < count; i++)
            {
                var totalWeight = 0f;
                foreach (var weight in weights)
                {
                    totalWeight += weight;
                }

                if (totalWeight <= 0)
                    yield break;

                var value = rng.RandomFloat() * totalWeight;
                for (var j = 0; j < items.Count; j++)
                {
                    var weight = weights[j];
                    if (value < weight)
                    {
                        yield return items[j];

                        items.RemoveAt(j);
                        weights.RemoveAt(j);
                        break;
                    }
                    value -= weight;
                }
            }
        }
        
        // Note: this function breaks if the sum of weights is negative
        public static IEnumerable<T> CryptoPickManyWeightedUnique<T>(
            this IReadOnlyList<T> list,
            int count,
            Func<T, float> weightFunc)
        {
            if (list.Count == 0 || count <= 0)
                yield break;
            if (count > list.Count)
                yield break;

            var items = new List<T>(list);
            var weights = items.Select(weightFunc).ToList();
            
            for (var i = 0; i < count; i++)
            {
                var totalWeight = 0f;
                foreach (var weight in weights)
                {
                    totalWeight += weight;
                }

                if (totalWeight <= 0)
                    yield break;

                var value = StaticRandom.CryptoNextFloat() * totalWeight;
                for (var j = 0; j < items.Count; j++)
                {
                    var weight = weights[j];
                    if (value < weight)
                    {
                        yield return items[j];

                        items.RemoveAt(j);
                        weights.RemoveAt(j);
                        break;
                    }
                    value -= weight;
                }
            }
        }
        
        public static void Shuffle<T>(this IList<T> list)
        {
            for (var i = list.Count - 1; i > 0; --i)
            {
                var j = StaticRandom.Next(i + 1);
                (list[i], list[j]) = (list[j], list[i]);
            }
        }

        public static void Shuffle<T>(this IList<T> list, IRng rng)
        {
            for (var i = list.Count - 1; i > 0; --i)
            {
                var j = rng.Random(i + 1);
                (list[i], list[j]) = (list[j], list[i]);
            }
        }
        
        public static void CryptoShuffle<T>(this IList<T> list)
        {
            for (var i = list.Count - 1; i > 0; --i)
            {
                var j = StaticRandom.CryptoNext(i + 1);
                (list[i], list[j]) = (list[j], list[i]);
            }
        }
        
        public static T?[] Fill<T>(this T?[] list, T? value = default)
        {
            for (var i = 0; i < list.Length; ++i)
                list[i] = value;
            return list;
        }
        
        public static T[] Fill<T>(this T[] list, Func<T> valueFunc)
        {
            for (var i = 0; i < list.Length; ++i)
                list[i] = valueFunc();
            return list;
        }
        
        public static T[] FillNew<T>(this T[] list) where T : new()
        {
            for (var i = 0; i < list.Length; ++i)
                list[i] = new T();
            return list;
        }
        
        public static IList<T?> Fill<T>(this IList<T?> list, T? value = default)
        {
            for (var i = 0; i < list.Count; ++i)
                list[i] = value;
            return list;
        }
        
        public static IList<T> Fill<T>(this IList<T> list, Func<T> valueFunc)
        {
            for (var i = 0; i < list.Count; ++i)
                list[i] = valueFunc();
            return list;
        }
        
        public static IList<T> FillNew<T>(this IList<T> list) where T : new()
        {
            for (var i = 0; i < list.Count; ++i)
                list[i] = new T();
            return list;
        }
        
        public static void Resize<T>(this IList<T?> list, int size, T? @default = default)
        {
            if (list.Count < size)
            {
                for (var i = list.Count; i < size; ++i)
                    list.Add(@default);
            }
            else if (list.Count > size)
            {
                while (list.Count > size)
                    list.RemoveAt(list.Count - 1);
            }
        }
        
        public static void ResizeAndFillNew<T>(this IList<T> list, int size) where T : new()
        {
            if (list.Count < size)
            {
                for (var i = list.Count; i < size; ++i)
                    list.Add(new T());
            }
            else if (list.Count > size)
            {
                while (list.Count > size)
                    list.RemoveAt(list.Count - 1);
            }
        }
        
        public static int BinarySearch<T>(this IList<T> list, T value)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = Comparer<T>.Default.Compare(list[mid], value);
                if (cmp == 0)
                    return mid;
                if (cmp < 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return ~left;
        }
        
        public static int BinarySearch<T>(this IList<T> list, T value, IComparer<T> comparer)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = comparer.Compare(list[mid], value);
                if (cmp == 0)
                    return mid;
                if (cmp < 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return ~left;
        }
        
        // Returns the index of the first element that is greater or equal to the value
        // If the value is greater than the last element, returns list.Count
        public static int BinarySearchLeft<T>(this IList<T> list, T value)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = Comparer<T>.Default.Compare(list[mid], value);
                if (cmp < 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return left;
        }
        
        public static int BinarySearchLeft<T>(this IList<T> list, T value, IComparer<T> comparer)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = comparer.Compare(list[mid], value);
                if (cmp < 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return left;
        }
        
        // Returns the index of the last element that is less or equal to the value
        // If the value is less than the first element, returns -1
        public static int BinarySearchRight<T>(this IList<T> list, T value)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = Comparer<T>.Default.Compare(list[mid], value);
                if (cmp <= 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return right;
        }
        
        public static int BinarySearchRight<T>(this IList<T> list, T value, IComparer<T> comparer)
        {
            var left = 0;
            var right = list.Count - 1;
            while (left <= right)
            {
                var mid = left + (right - left) / 2;
                var cmp = comparer.Compare(list[mid], value);
                if (cmp <= 0)
                    left = mid + 1;
                else
                    right = mid - 1;
            }
            return right;
        }

        public static void RemoveAll<T>(this RepeatedField<T> source, Func<T, bool> predicate)
        {
            using var validElements = ConcurrentObjectPool<PooledList<T>>.StaticPool.Pop();

            foreach (var x in source)
            {
                if (predicate(x))
                    continue;
                
                validElements.Add(x);
            }
            
            source.Clear();
            source.AddRange(validElements);
        }

        public static int FindIndex<T>(this RepeatedField<T> source, Func<T, bool> predicate)
        {
            for (var i = 0; i < source.Count; i++)
            {
                if (predicate(source[i]))
                    return i;
            }

            return -1;
        }
        
        public static int FindLastIndex<T>(this RepeatedField<T> source, Func<T, bool> predicate)
        {
            for (var i = source.Count - 1; i >= 0; i--)
            {
                if (predicate(source[i]))
                    return i;
            }

            return -1;
        }
        
    }
}
