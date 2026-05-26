using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IUILayoutOptionHolder
{
    public bool holdLayoutEnabled { get; }
}

public class UILayoutOptionHolder : MonoBehaviour, IUILayoutOptionHolder
{
    [SerializeField] private bool m_holdLayoutEnabled = true;
    public bool holdLayoutEnabled => m_holdLayoutEnabled;
}
