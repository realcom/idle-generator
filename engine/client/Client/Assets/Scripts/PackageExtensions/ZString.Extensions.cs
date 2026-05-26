using System;
using System.Collections;
using System.Collections.Generic;
using Cysharp.Text;
using TMPro;
using UnityEditor;
using UnityEngine;

public static class Utf16StringBuilderCustomFormatter
{
    [RuntimeInitializeOnLoadMethod]
    public static void Register()
    {
        Utf16ValueStringBuilder.RegisterTryFormat((Utf16ValueStringBuilder value, Span<char> dest, out int written, ReadOnlySpan<char> format) =>
        {
            var s = value.AsSpan();
            written = s.Length;

            if (s.Length > dest.Length)
                return false;

            s.CopyTo(dest);
            return true;
        });
    }
    
    
}


public static class ZStringForTextMeshProExtensions
{
    public static void SetTextWithDispose(this TMP_Text text, Utf16ValueStringBuilder stringBuilder)
    {
        var array = stringBuilder.AsArraySegment();
        text.SetCharArray(array.Array, array.Offset, array.Count);
        
        stringBuilder.Dispose();
    }
}