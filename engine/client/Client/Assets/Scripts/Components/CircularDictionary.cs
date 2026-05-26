using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircularDictionary<TKey, TValue> : IDictionary<TKey, TValue>
{
    private class LinkedNode
    {
        public LinkedNode next;
        public LinkedNode prev;

        public readonly TKey item;

        public LinkedNode(TKey item)
        {
            this.item = item;
        }

        internal void Invalidate()
        {
            next = null;
            prev = null;
        }
    }

    private readonly IDictionary<TKey, TValue> _dict = new Dictionary<TKey, TValue>();
    private readonly IDictionary<TKey, LinkedNode> _keys = new Dictionary<TKey, LinkedNode>();

    private LinkedNode _head = null;
    private LinkedNode _tail = null;

    public readonly int capacity;

    public ICollection<TKey> Keys => _dict.Keys;
    public ICollection<TValue> Values => _dict.Values;

    public int Count => _dict.Count;
    public bool IsReadOnly => false;

    public TValue this[TKey key]
    {
        get => _dict[key];
        set => Add(key, value);
    }

    public CircularDictionary(int capacity)
    {
        this.capacity = capacity;
    }

    public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
    {
        return _dict.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Add(KeyValuePair<TKey, TValue> item)
    {
        Add(item.Key, item.Value);
    }

    public void Clear()
    {
        _dict.Clear();
        _keys.Clear();
    }

    public bool Contains(KeyValuePair<TKey, TValue> item)
    {
        return _dict.Contains(item);
    }

    public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex)
    {
        _dict.CopyTo(array, arrayIndex);
    }

    public bool Remove(KeyValuePair<TKey, TValue> item)
    {
        return Remove(item.Key);
    }

    public void Add(TKey key, TValue value)
    {
        if (_dict.ContainsKey(key))
            Remove(key);

        if (_dict.Count >= capacity)
        {
            _dict.Remove(_head.item);
            Remove(_head);
        }

        _dict.Add(key, value);
        Add(key);
    }

    public bool ContainsKey(TKey key)
    {
        return _dict.ContainsKey(key);
    }

    public bool Remove(TKey key)
    {
        if (_keys.TryGetValue(key, out var node))
            Remove(node);
        return _dict.Remove(key);
    }

    public bool TryGetValue(TKey key, out TValue value)
    {
        return _dict.TryGetValue(key, out value);
    }

    private void Add(TKey key)
    {
        if (_keys.ContainsKey(key))
            throw new Exception("Key already exists in the dictionary.");

        var node = new LinkedNode(key);

        if (_head is null)
        {
            _head = node;
            _tail = node;
        }
        else
        {
            _tail.next = node;
            node.prev = _tail;
            _tail = node;
        }

        _keys[key] = node;
    }

    private bool Remove(LinkedNode node)
    {
        if (node is null)
            return false;

        if (node == _head)
            _head = node.next;
        if (node == _tail)
            _tail = node.prev;
        if (node.next is not null)
            node.next.prev = node.prev;
        if (node.prev is not null)
            node.prev.next = node.next;

        node.Invalidate();
        return _keys.Remove(node.item);
    }
}