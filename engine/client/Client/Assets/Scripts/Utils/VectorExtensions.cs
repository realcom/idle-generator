using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class VectorExtensions
{
    public static bool Approximately(this Vector3 a, Vector3 b)
    {
        return Vector3.SqrMagnitude(a - b) < float.Epsilon;
    }
    
    public static bool Approximately(this Vector2 a, Vector2 b)
    {
        return Vector2.SqrMagnitude(a - b) < float.Epsilon;
    }
    
}
