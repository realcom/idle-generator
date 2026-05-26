using System;
using System.Collections.Generic;

namespace Commons.Algorithm.Fenwick
{
    public sealed class Fenwick
    {
        private readonly List<int> _tree = new() { 0 }; // 1-based
        public int Count => _tree.Count - 1;

        public void Ensure(int n)
        {
            while (Count < n) _tree.Add(0);
        }

        public void Clear()
        {
            _tree.Clear();
            _tree.Add(0);
        }

        public void Add(int i1, int delta)
        {
            for (var i = i1; i < _tree.Count; i += i & -i) _tree[i] += delta;
        }

        public int Sum(int i1)
        {
            var s = 0;
            for (var i = i1; i > 0; i -= i & -i) s += _tree[i];
            return s;
        }

        public int Total() => Sum(Count);

        public int LowerBound(int target)
        {
            int idx = 0, bit = 1;
            while ((bit << 1) < _tree.Count) bit <<= 1;
            for (var k = bit; k > 0; k >>= 1)
            {
                var next = idx + k;
                if (next < _tree.Count && _tree[next] < target)
                {
                    target -= _tree[next];
                    idx = next;
                }
            }

            return Math.Min(idx + 1, Count);
        }
    }
}