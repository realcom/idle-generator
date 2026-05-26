using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

public static partial class Utility
{
    public static Coroutine PlayForward(this Animator animator, MonoBehaviour behaviour, string stateName, float speed = 1f, RunCallback OnEnd = null)
    {
        return behaviour.StartCoroutine(PlayAnimation_Internal(animator, Animator.StringToHash(stateName), speed, OnEnd));
    } 
    
    public static Coroutine PlayForward(this Animator animator, MonoBehaviour behaviour, int stateNameHash, float speed = 1f, RunCallback OnEnd = null)
    {
        return behaviour.StartCoroutine(PlayAnimation_Internal(animator, stateNameHash, speed, OnEnd));
    }

    public static void PlayBackward(this Animator animator, MonoBehaviour behaviour, int stateNameHash, float speed = 1f, RunCallback OnEnd = null)
    {
        behaviour.StartCoroutine(PlayAnimation_Internal(animator, stateNameHash, -speed, OnEnd));
    }

    private static readonly int _speedParamHash = Animator.StringToHash("Speed");
    private static IEnumerator PlayAnimation_Internal(Animator animator, int stateNameHash, float speed, RunCallback onEnd)
    {
        if (float.IsNaN(speed) || speed == 0.0f)
            yield break;
        
        var isForward = speed > 0f;

        if (!animator.HasState(0, stateNameHash))
        {
            onEnd?.Invoke();
            yield break;
        }
		
        animator.SetFloat(_speedParamHash, speed);
        animator.Play(stateNameHash, -1, isForward ? 0f : 1f);

        yield return null;

        AnimatorStateInfo info;
        do
        {
            yield return null;
            info = animator.GetCurrentAnimatorStateInfo(0);
        } while (info.CompareName(stateNameHash) && (isForward ? info.normalizedTime < 1f : info.normalizedTime > 0f));
		
        onEnd?.Invoke();
    }
	
    public static bool CompareName(this AnimatorStateInfo info, int stateNameHash)
    {
        return stateNameHash == info.fullPathHash || stateNameHash == info.shortNameHash;
    }
    
    public static async UniTask WaitForStateEndAsync(
        this Animator animator, 
        int stateNameHash, 
        int layer = 0, 
        float normalizedTime = 0f,
        float speed = 1f,
        CancellationToken cancellationToken = default)
    {
        var isForward = speed > 0f;
        
        if (!animator.HasState(layer, stateNameHash))
            return;
        
        animator.SetFloat(_speedParamHash, speed);
        animator.Play(stateNameHash, layer, isForward ? normalizedTime : 1f - normalizedTime);
        await UniTask.Yield(PlayerLoopTiming.LastPostLateUpdate, cancellationToken: cancellationToken);

        // 현재 재생 중인 스테이트를 확인
        var info = animator.GetCurrentAnimatorStateInfo(layer);
        if (!info.CompareName(stateNameHash))
            return;

        // 스테이트가 끝날 때까지 대기
        do
        {
            await UniTask.Yield(PlayerLoopTiming.LastPostLateUpdate, cancellationToken: cancellationToken);
            info = animator.GetCurrentAnimatorStateInfo(layer);
        } while (info.CompareName(stateNameHash) && (isForward ? info.normalizedTime < 1f : info.normalizedTime > 0f));
    }
    
}
