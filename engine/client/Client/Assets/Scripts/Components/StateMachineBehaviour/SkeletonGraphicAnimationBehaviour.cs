using System;
using System.Collections;
using System.Collections.Generic;
using Spine;
using Spine.Unity;
using UnityEngine;
using AnimationState = Spine.AnimationState;

public class SkeletonGraphicAnimationBehaviour : StateMachineBehaviour
{
    [SerializeField]
    private string m_AnimationClip;

    [SerializeField]
    private int m_Layer = 0;

    [SerializeField]
    private float m_TimeScale = 1f;

    [SerializeField]
    private bool m_Loop;

    private float m_NormalizedTime;
    
    private SkeletonGraphic m_SkeletonGraphic;
    private AnimationState m_SpineAnimationState;
    private TrackEntry m_TrackEntry;

    public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (m_SkeletonGraphic == null)
        {
            m_SkeletonGraphic = animator.GetComponentInChildren<SkeletonGraphic>();
            m_SpineAnimationState = m_SkeletonGraphic.AnimationState;
        }

        m_TrackEntry = m_SpineAnimationState.SetAnimation(m_Layer, m_AnimationClip, m_Loop);
        m_TrackEntry.TimeScale = m_TimeScale;

        if (!Mathf.Approximately(stateInfo.speed, 1f))
            m_TrackEntry.TimeScale = stateInfo.speed;
        
        m_NormalizedTime = 0f;
    }

    public override void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        m_NormalizedTime = m_TrackEntry.AnimationLast / m_TrackEntry.AnimationEnd;
    }
    
    // 스테이트 종료시 발생할것  없다면 지워도되는부분
    public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
	    
    }
}
