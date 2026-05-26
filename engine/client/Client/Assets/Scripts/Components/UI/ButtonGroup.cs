using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class ButtonGroup : UIBehaviour
{
    [SerializeField] private float m_ClickDelay = 0.5f;
    
    private double m_ClickAvailableAt = 0f;
    
    public double clickAvailableAt
    {
        get => m_ClickAvailableAt;
        set => m_ClickAvailableAt = Math.Max(m_ClickAvailableAt, value + m_ClickDelay);
    }
}
