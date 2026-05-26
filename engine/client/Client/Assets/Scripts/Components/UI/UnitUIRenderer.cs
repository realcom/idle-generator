using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Spine;
using Spine.Unity;
using UnityEngine;

public class UnitUIRenderer : MonoBehaviour
{
    [SerializeField] private RectTransform rtRoot;
    [SerializeField] private SkeletonGraphic skeletonGraphic;
    
    public SkeletonGraphic SkeletonGraphic => skeletonGraphic;

    public float timeScale => skeletonGraphic.timeScale;

    private Vector3 _initScale = -Vector3.one;
    private Vector3 initScale
    {
        get
        {
            if (_initScale.Approximately(-Vector3.one))
                _initScale = rtRoot.localScale;
            
            return _initScale;
        }
    }

    private Vector2 _initAnchoredPosition = -Vector2.one;
    private Vector2 initAnchoredPosition
    {
        get
        {
            if (_initAnchoredPosition.Approximately(-Vector2.one))
                _initAnchoredPosition = rtRoot.anchoredPosition;
            
            return _initAnchoredPosition;
        }
    }

    public void Hide()
    {
        skeletonGraphic.SetActive(false);
    }

    public void Initialize(ResourceItem resItem, string animationName = "Idle", float animTimeScale = float.NegativeInfinity)
    {
        if (resItem == null)
        {
            Hide();
            return;
        }

        Initialize(ResourceUnit.Get(resItem.UnitDataId), animationName, animTimeScale);
    }

    public void Initialize(ResourceUnit resUnit, string animationName = "Idle", float animTimeScale = float.NegativeInfinity)
    {
        if (resUnit == null)
        {
            Hide();
            return;
        }
        
        rtRoot.localScale = initScale;
        rtRoot.anchoredPosition = initAnchoredPosition;

        SkeletonGraphic appliedSkeletonGraphic = null;

        skeletonGraphic.startingLoop = true;
        skeletonGraphic.freeze = false;
        skeletonGraphic.SetUnitSpineUI(resUnit, animationName, animTimeScale);

        appliedSkeletonGraphic = skeletonGraphic;

        rtRoot.localScale = initScale * resUnit.ClientUIScale;
        rtRoot.anchoredPosition += resUnit.ClientUIOffset;

        foreach (RectTransform child in appliedSkeletonGraphic.transform)
        {
            child.anchoredPosition = Vector2.zero;
        }
    }

    public TrackEntry SetAnimation(string animationName, bool loop = true, int trackIndex = 0, float animTimeScale = float.NegativeInfinity, string afterAnimationName = "")
    {
        skeletonGraphic.AnimationState.ClearTrack(trackIndex);
        skeletonGraphic.Skeleton.SetToSetupPose();
        skeletonGraphic.AnimationState.SetEmptyAnimation(trackIndex, 0.0f);
        return skeletonGraphic.SetAnimation(animationName, loop, trackIndex, animTimeScale, afterAnimationName);
    }
    
}