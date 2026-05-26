using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UIElements;

public class AutoClickInvoker : UIBehaviour, IPointerDownHandler, IPointerMoveHandler, IPointerUpHandler, IPointerExitHandler, IPointerClickHandler
{
    [SerializeField] private float m_Interval = 0.1f;

    private double m_InvokeBlockedUntilAt = double.MaxValue;
    private bool m_IsPointerDown = false;
    
    private PointerEventData m_PointerEventData = null;
    
    private void Update()
    {
        if (m_IsPointerDown && m_InvokeBlockedUntilAt <= TimeSystem.time)
        {
            ExecuteEvents.Execute(gameObject, m_PointerEventData, ExecuteEvents.pointerClickHandler);
        }
    }
    
    public void OnPointerDown(PointerEventData eventData)
    {
        m_PointerEventData = eventData;
        m_IsPointerDown = true;
        
        m_InvokeBlockedUntilAt = TimeSystem.time + m_Interval;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        m_PointerEventData = eventData;
        m_IsPointerDown = false;

        //의도치 않은 연속 클릭 방지
        m_PointerEventData.eligibleForClick = false;

        //Interval 내에 Up 이벤트가 발생하면 Click 이벤트 직접 호출. (위 eligibleForClick = false 로 인해 기존 모듈에서 Click 이벤트가 발생하지 않음)
        if (m_InvokeBlockedUntilAt > TimeSystem.time)
            ExecuteEvents.Execute(gameObject, m_PointerEventData, ExecuteEvents.pointerClickHandler);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        m_PointerEventData = eventData;
        m_IsPointerDown = false;
    }

    public void OnPointerMove(PointerEventData eventData)
    {
        m_PointerEventData = eventData;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        m_PointerEventData = eventData;
        m_InvokeBlockedUntilAt = TimeSystem.time + m_Interval;
    }
}
