using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using DG.Tweening;
using Sirenix.Serialization;
using UnityEngine.Serialization;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using Spine.Unity;
using UnityEngine.Rendering;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
using Sirenix.OdinInspector.Editor;
#endif

public class AnimNames
{
    public const string Idle = nameof(Idle);
    public const string Run = nameof(Run);
    public const string Knockback = nameof(Knockback);
    public const string KnockDown = nameof(KnockDown);
    public const string Dead = nameof(Dead);
    public const string Attack = nameof(Attack);
    public const string Select = nameof(Select);
}

public partial class UnitSkin : ZMonoBehaviour
{
    private static readonly int _tintID = Shader.PropertyToID("_Color");
    private static readonly int _darkID = Shader.PropertyToID("_Black");
    private static readonly int _shineLocation = Shader.PropertyToID("_ShineLocation");
    private static readonly int _shineGlow = Shader.PropertyToID("_ShineGlow");
    private static readonly int _HitEffectBlend = Shader.PropertyToID("_HitEffectBlend");
    private static readonly int _HitEffectColor = Shader.PropertyToID("_HitEffectColor");
    private static readonly int _OutlineBaseAlpha = Shader.PropertyToID("_OutlineAlpha");
    
    private static MaterialPropertyBlock _propertyBlock;

    public Transform trPanelStatus;
    public Transform trPanelBubble; //Optional
    public Transform trPanelFloatingText; //Optional
    
    [NonSerialized] public SkeletonAnimation[] spineAnimations;
    [NonSerialized] public MeshRenderer[] spineRenderers;
    [NonSerialized] public SortingGroup sortingGroup;

    [NonSerialized] public BuffAttachmentTarget[] buffAttachmentTargets = Array.Empty<BuffAttachmentTarget>();
    
    [NonSerialized] public Vector3 size;
    [NonSerialized] public GameUnitObject unit;
    
    private Vector3 _originalSize;
    private float _originalMoveSpeed;
    
    protected override void Awake()
    {
        base.Awake();

        if (!trPanelBubble)
            trPanelBubble = trPanelStatus;

        if (!trPanelFloatingText)
            trPanelFloatingText = trPanelStatus;
        
        _propertyBlock ??= new MaterialPropertyBlock();
        
        sortingGroup = GetComponent<SortingGroup>();
        
        spineAnimations = GetComponentsInChildren<SkeletonAnimation>() ?? Array.Empty<SkeletonAnimation>();
        var list = UnityEngine.Pool.ListPool<MeshRenderer>.Get();
        foreach (var spine in spineAnimations)
            list.Add(spine.GetComponent<MeshRenderer>());
        spineRenderers = list.ToArray();

        buffAttachmentTargets = GetComponentsInChildren<BuffAttachmentTarget>() ?? buffAttachmentTargets;
    }

    protected override void Start()
    {
        base.Start();
        
        if (unit == null)
            return;
        
        _originalSize = transform.localScale;

        _originalMoveSpeed = unit.ResUnit.AddStats.FirstOrDefault(x => x.Type == UnitStatType.MoveSpeed)
            ?.Value.GetClamped(unit.gameUnit?.Level - 1 ?? 0) ?? 1;
    }

    private void OnBecameVisible()
    {
        foreach (var skeletonAnimation in spineAnimations)
            skeletonAnimation.enabled = true;
    }
    
    //private void OnBecameInvisible()
    //{
    //    foreach (var skeletonAnimation in spineAnimations)
    //        skeletonAnimation.enabled = false;
    //}

    public void UpdateDirection(Vector3 dir)
    {
        foreach (var skeletonAnimation in spineAnimations)
        {
            var updateDirection = Math.Abs(dir.x) > 0.15f;
            if (updateDirection)
            {
                var localScale = skeletonAnimation.skeleton.ScaleX;
                var sign = -Math.Sign(dir.x);
                if (Math.Sign(localScale) != sign)
                {
                    localScale = sign * Mathf.Abs(localScale);
                    skeletonAnimation.skeleton.ScaleX = localScale;
                }
            }
        }
    }
    
    public void ClearAnimation(int trackIndex = -1)
    {
        foreach (var spine in spineAnimations)
        {
            if (!spine || spine.AnimationState == null)
                continue;
            //if (!spine.isActiveAndEnabled)
            //    continue;

            if (trackIndex == -1)
            {
                spine.state.ClearTracks();
                spine.state.SetEmptyAnimations(0f);
                spine.Skeleton.SetToSetupPose();
            }
            else
            {
                spine.state.ClearTrack(trackIndex);
                spine.state.SetEmptyAnimation(trackIndex, 0.0f);
                spine.Skeleton.SetToSetupPose();
            }
        }
    }
    
    public bool SetAnimation(int trackIndex, string animationName, bool loop, bool resetAfterAnimation = true, bool setAnimationName = false, float timeScale = 1f)
    {
        animationName = unit.ResUnit.Animations.GetValueOrDefault(animationName, animationName);
        if (string.IsNullOrEmpty(animationName))
            return false;
        
        var found = false;
        foreach (var spine in spineAnimations)
        {
            if (!spine || spine.AnimationState == null)
                continue;
            //if (!spine.isActiveAndEnabled)
            //    continue;
            if (spine.AnimationName == animationName && Mathf.Abs(spine.AnimationState.TimeScale - timeScale) < 0.1f)
                continue;
            var animation = spine.AnimationState.Data.SkeletonData.FindAnimation(animationName);
            if (animation == null)
            {
#if UNITY_EDITOR
                Debug.LogWarning($"Unknown Spine Animation: {animationName} ({gameObject.name})");
#endif
                continue;
            }
            found = true;
            var mixDuration = spine.skeletonDataAsset.defaultMix;
            if (setAnimationName)
				spine.AnimationName = animationName;
            // spine.state.SetEmptyAnimation(trackIndex, mixDuration);
            // var entry = spine.state.AddAnimation(trackIndex, animation, loop, 0f);
            
            spine.state.SetEmptyAnimation(trackIndex, 0f);
            var entry = spine.state.SetAnimation(trackIndex, animation, loop);

            if (pausedTrackTimeScales.ContainsKey(trackIndex))
            {
                pausedTrackTimeScales[trackIndex] = timeScale;
            }
            else
            {
                entry.TimeScale = timeScale;
            }
            
            if (!loop && resetAfterAnimation)
                spine.state.AddEmptyAnimation(trackIndex, mixDuration, animation.Duration);
        }

        return found;
    }
    
    public bool AddAnimation(int trackIndex, string animationName, bool loop, float delay)
    {
        if (string.IsNullOrEmpty(animationName))
            return false;
        var found = false;
        foreach (var spine in spineAnimations)
        {
            if (!spine || spine.AnimationState == null)
                continue;
            if (!spine.isActiveAndEnabled)
                continue;
            var animation = spine.AnimationState.Data.SkeletonData.FindAnimation(animationName);
            if (animation == null)
            {
                Debug.LogWarning($"Unknown Spine Animation: {animationName} ({gameObject.name})");
                continue;
            }
            found = true;
            spine.state.AddAnimation(trackIndex, animation, loop, delay);
            if (!loop)
                spine.state.AddEmptyAnimation(trackIndex, 0f, 0f);
        }

        return found;
    }

    public void StopAnimation(int trackIndex, string animationName, float mixDuration = 0f)
    {
        foreach (var spine in spineAnimations)
        {
            if (!spine || spine.AnimationState == null)
                continue;
            if (!spine.isActiveAndEnabled)
                continue;
            if (spine.state.Tracks.Items.GetSafe(trackIndex)?.Animation?.Name != animationName)
                continue;
            spine.state.ClearTrack(trackIndex);
            spine.state.SetEmptyAnimation(trackIndex, mixDuration);
        }
    }

    private readonly Dictionary<int, float> pausedTrackTimeScales = new();
    public void PauseAnimation()
    {
        foreach (var spineAnimation in spineAnimations)
        {
            if (!spineAnimation || spineAnimation.AnimationState == null)
                continue;
            
            foreach (var trackEntry in spineAnimation.AnimationState.Tracks)
            {
                if (trackEntry != null)
                {
                    if (pausedTrackTimeScales.ContainsKey(trackEntry.TrackIndex))
                        return;
                    
                    pausedTrackTimeScales[trackEntry.TrackIndex] = trackEntry.TimeScale;
                    trackEntry.TimeScale = 0f;
                }                
            }
        }
    }
    
    public void ResumeAnimation()
    {
        foreach (var (trackIndex, timeScale) in pausedTrackTimeScales)
        {
            foreach (var skeletonAnimation in spineAnimations)
            {
                if (!skeletonAnimation || skeletonAnimation.AnimationState == null)
                    continue;
                var entry = skeletonAnimation.AnimationState.GetCurrent(trackIndex);
                if (entry != null)
                    entry.TimeScale = timeScale;
            }
        }
        
        pausedTrackTimeScales.Clear();
    }

    private uint _cachedState;
    public static bool HasState(uint state, uint flags)
    {
        return (state & flags) != 0;
    }
    
    private bool HasNewState(uint state, uint flags)
    {
        return (state & flags) != 0 && (_cachedState & flags) == 0;
    }
    
    private bool HasStateRemoved(uint state, uint flags)
    {
        return (state & flags) == 0 && (_cachedState & flags) != 0;
    }
    
    public void HandleState(uint state)
    {
        if (_cachedState == state)
            return;

        HandleStateInternal(state);
        
        _cachedState = state;
    }

    protected virtual void HandleStateInternal(uint state)
    {
        if (HasStateRemoved(state, GameUnit.StateFlag.Alive))
        {
            //뒤짐
        }
        else if (HasNewState(state, GameUnit.StateFlag.Alive))
        {
            // 살아났음
            ClearAnimation();
        }
        
        if (!HasState(state, GameUnit.StateFlag.Alive))
            return;
        
        var isRunning = HasState(state, GameUnit.StateFlag.Running);
        if (isRunning)
        {
            var unitBaseMoveSpeed = unit.ResUnit.AddStats.Sum(x => x.Type == UnitStatType.MoveSpeed ? x.Value.GetClamped(1) : 0f);
            
            if (unitBaseMoveSpeed <= 0f)
                unitBaseMoveSpeed = 1f;
            
            var moveSpeed = (float)(unit.gameUnit?.MoveSpeed / unitBaseMoveSpeed ?? FixedFloat.One);
            
            if (unit.ResUnit.Type == ResourceUnit.Types.Type.Pet)
            {
                var ownerUnit = unit.gameUnit?.Owner;
                unitBaseMoveSpeed = ownerUnit?.ResUnit.AddStats.Sum(x => x.Type == UnitStatType.MoveSpeed ? x.Value.GetClamped(1) : 0f) ?? 1f;
                moveSpeed = (float)(ownerUnit?.MoveSpeed / unitBaseMoveSpeed ?? FixedFloat.One);
            }

            if (moveSpeed <= 0f)
                moveSpeed = 1f;
            
            SetAnimation(0, AnimNames.Run, true, timeScale: moveSpeed);
        }
        else
        {
            SetAnimation(0, AnimNames.Idle, true);
        }
        
        if (HasNewState(state, GameUnit.StateFlag.Knockback))
            SetAnimation(0, AnimNames.Knockback, false);
        
        if (unit.isLocalPlayer)
        {
            if (isRunning)
            {
                _footstepAudioCoroutine ??= StartCoroutine(PlayFootstepWithMoveSpeed());
            }
            else
            {
                if (_footstepAudioCoroutine != null)
                {
                    StopCoroutine(_footstepAudioCoroutine);
                    _footstepAudioCoroutine = null;
                }
            }
        }
    }
    
    private Coroutine _footstepAudioCoroutine;
    private const float FootStepDelay = 0.41f; // set according to RUN animation
    private IEnumerator PlayFootstepWithMoveSpeed()
    {
        while (true)
        {
            var moveSpeed = (float)MyPlayer.GameUnit.MoveSpeed;
            //animator.SetFloat(AnimatorHash.MoveSpeed,  moveSpeed / _originalMoveSpeed);
            var delay = FootStepDelay / moveSpeed;
            // AudioManager.Get().PlayFX("footstep", transform);
            yield return Utility.GetWaitForSeconds(delay);
        }
    }
    
    private bool _isRendererActive = true;
    public void SetRendererActive(bool renderEnabled)
    {
        if (_isRendererActive == renderEnabled)
            return;
        _isRendererActive = renderEnabled;

        foreach (var skeletonAnimation in spineAnimations)
            skeletonAnimation.enabled = renderEnabled;
        foreach (var spineRenderer in spineRenderers)
            spineRenderer.enabled = renderEnabled;
    }

    private Sequence shineSequence;
    private Coroutine shineDurationCoroutine;
    [Button]
    public void SetShineActive(bool bActive, float duration = float.PositiveInfinity)
    {
        if (bActive)
        {
            if (shineDurationCoroutine != null)
                StopCoroutine(shineDurationCoroutine);
            
            if (!float.IsPositiveInfinity(duration))
            {
                shineDurationCoroutine = this.Run(() =>
                {
                    if (this)
                        SetShineActive(false);
                }, duration);
            }
        }
        
        if (shineSequence != null == bActive)
            return;
        
        if (bActive)
        {
            shineSequence?.Kill();
            shineSequence = DOTween.Sequence();
            shineSequence
                .SetDelay(0.7f)
                .Append(DOTween.To(v =>
                {
                    foreach (var spineRenderer in spineRenderers)
                    {
                        spineRenderer.GetPropertyBlock(_propertyBlock);
                        _propertyBlock.SetFloat(_shineLocation, v);
                        _propertyBlock.SetFloat(_shineGlow, 1f);
                        spineRenderer.SetPropertyBlock(_propertyBlock);
                    }
                }, 0f, 1f, 0.5f))
                .AppendInterval(0.7f)
                .SetLoops(-1, LoopType.Yoyo)
                .Play();
        }
        else
        {
            shineSequence?.Kill();
            shineSequence = null;
            
            foreach (var spineRenderer in spineRenderers)
            {
                spineRenderer.GetPropertyBlock(_propertyBlock);
                _propertyBlock.SetFloat(_shineLocation, 0f);
                _propertyBlock.SetFloat(_shineGlow, 0f);
                spineRenderer.SetPropertyBlock(_propertyBlock);
            }
        }
    }

    [Button]
    public void FlushHitEffect(Color effectColor)
    {
        foreach (var spineRenderer in spineRenderers)
        {
            spineRenderer.DOKill();
            {
                spineRenderer.GetPropertyBlock(_propertyBlock);
                _propertyBlock.SetFloat(_HitEffectBlend, CRC.Get().globalParameters.hitEffectIntensity);
                _propertyBlock.SetColor(_HitEffectColor, effectColor);
                spineRenderer.SetPropertyBlock(_propertyBlock);
                DOTween.To(f =>
                    {
                        spineRenderer.GetPropertyBlock(_propertyBlock);
                        _propertyBlock.SetFloat(_HitEffectBlend, f);
                        spineRenderer.SetPropertyBlock(_propertyBlock);
                    }, CRC.Get().globalParameters.hitEffectIntensity, 0f, 0f)
                    .SetDelay(CRC.Get().globalParameters.hitEffectDuration)
                    .SetTarget(spineRenderer);
            }
            //DOTween.To(f =>
            //    {
            //        spineRenderer.GetPropertyBlock(_propertyBlock);
            //        _propertyBlock.SetFloat(_HiteffectBlend, f);
            //        spineRenderer.SetPropertyBlock(_propertyBlock);
            //    }, 0f, CRC.Get().globalParameters.hitEffectIntensity, CRC.Get().globalParameters.hitEffectDuration)
            //    .SetLoops(2, LoopType.Yoyo)
            //    .SetTarget(spineRenderer);
        }
        
        transform.DOKill();
        transform.localScale = _originalSize;
        transform.DOPunchScale(Vector3.one * 0.12f, 0.5f, 2, 0.1f);
    }
    
    [Button]
    public void ShowEnemyOutline(float value)
    {
        foreach (var spineRenderer in spineRenderers)
        {
            spineRenderer.GetPropertyBlock(_propertyBlock);
            _propertyBlock.SetFloat(_OutlineBaseAlpha, value);
            spineRenderer.SetPropertyBlock(_propertyBlock);
        }
    }
    
    public void SetSoringLayer(int sortingLayerID)
    {
        sortingGroup.sortingLayerID = sortingLayerID;
    }
    
    public void SetOrderInLayer(int orderInLayer)
    {
        sortingGroup.sortingOrder = orderInLayer;
    }
    
}
