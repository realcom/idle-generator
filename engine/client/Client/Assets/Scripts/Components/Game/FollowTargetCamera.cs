using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using Random = UnityEngine.Random;

[RequireComponent(typeof(Camera))]
public class FollowTargetCamera : ZEventBehaviour
{
    public bool fixedUpdate = true;
    
    public Transform target;
    public Vector2 targetTransformPivot;
    
    private Camera m_Camera = null;

    private float m_FOV = 0.0f;
    public float FOV
    {
        get => m_FOV;
        set
        {
            m_FOV = value;
            _dirtyOrthographicSize = true;
        }
    }

    private Rect _viewRect = new(0, 0, 1, 1);
    public Rect viewRect
    {
        get => _viewRect;
        set
        {
            _viewRect = value;
            _dirtyOrthographicSize = true;
        }
    }
    
    private bool _dirtyOrthographicSize = false;

    public override void Start()
    {
        base.Start();

        m_Camera = GetComponent<Camera>();

        if (m_FOV <= 0.0f)
            m_FOV = m_Camera.orthographicSize;
        
        if (GameBoardManager.Get().modeManager == null)
            enabled = false;
    }

    [Button]
    private void FitViewRect()
    {
        var viewTargetPixelDelta = Vector2Int.zero;

        switch (GameBoardManager.Get().gameBoard.ResMap.Type)
        {
            case ResourceMap.Types.Type.Dungeon:
            case ResourceMap.Types.Type.BackpackDungeon:
            {
                viewTargetPixelDelta = new Vector2Int(0, 1432);
                break;
            }
        }

        var deltaRatio = (float)Screen.height / Screen.width / (2220f / 1080f);
        deltaRatio = MathF.Max(1f, deltaRatio);
        var ratio = new Vector2(0f, (viewTargetPixelDelta.y / 2220f) / deltaRatio);
        viewRect = new Rect(0, ratio.y, 1, 1);
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            {
                FitViewRect();
                enabled = true;
                break;
            }
            case GameEventType.MAP_RELEASED:
            {
                enabled = false;
                break;
            }
        }
    }

    public void UpdatePosition(float dt)
    {
        if (!target)
            return;

        var worldCamHeight = m_Camera.orthographicSize * 2f;
        var worldCamWidth = worldCamHeight * m_Camera.aspect;

        var targetPosition = target.position;
        targetPosition.x += (0.5f - targetTransformPivot.x) * worldCamWidth;
        targetPosition.y += (0.5f - targetTransformPivot.y) * worldCamHeight;
        
        // Clamp to map bounds
        var pos = targetPosition;
        pos.z = transform.position.z;
        pos.x = Mathf.Clamp(pos.x, -100000f, 100000f);
        pos.y = Mathf.Clamp(pos.y, -100000f, 100000f);

        // Shake logic
        var shakeOffset = Vector3.zero;
        if (shakeTimeElapsed < shakeDuration)
        {
            shakeTimeElapsed += dt;
            var shakeProgress = 1f - (shakeTimeElapsed / shakeDuration);
            shakeOffset = new Vector3(
                Random.Range(-1f, 1f) * shakeMagnitude * shakeProgress,
                Random.Range(-1f, 1f) * shakeMagnitude * shakeProgress,
                0f
            );
        }

        transform.position = pos + shakeOffset;
    }

    protected void LateUpdate()
    {
        if (!fixedUpdate)
            UpdatePosition(Time.deltaTime);

        if (_dirtyOrthographicSize)
        {
            _dirtyOrthographicSize = false;
            
            if (m_Camera)
            {
                var baseRatio = 2220f / 1080f; // todo: temp
                var aspectRatio = (float)Screen.height / Screen.width;
                var deltaRatio = aspectRatio / baseRatio;

                var rect = m_Camera.rect = _viewRect;
                m_Camera.orthographicSize = Mathf.Max(m_FOV, m_FOV * deltaRatio) * (rect.height - rect.y);
            }
        }
    }

    protected void FixedUpdate()
    {
        if (fixedUpdate)
            UpdatePosition(Time.fixedDeltaTime);
    }

    [Button]
    public void Follow(Transform targetTr)
    {
        target = targetTr;
    }
    
    private float shakeMagnitude = 0f;
    private float shakeDuration = 0f;
    private float shakeTimeElapsed = 0f;
    
    [Button]
    public void Shake(float magnitude, float duration = 0.33f)
    {
        shakeMagnitude = magnitude;
        shakeDuration = duration;
        shakeTimeElapsed = 0f;
    }
    
}
