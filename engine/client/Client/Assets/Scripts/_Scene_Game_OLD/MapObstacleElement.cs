using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IMapObstacleElement
{
    public bool ignoreChildSearch { get; set; } 
}

public class MapObstacleElement : MonoBehaviour, IMapObstacleElement
{
    [SerializeField] private bool m_IgnoreChildSearch = true;

    public bool ignoreChildSearch
    {
        get => m_IgnoreChildSearch;
        set => m_IgnoreChildSearch = value;
    }
}
