using System;
using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Units;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;
using Sirenix.OdinInspector;


public class InventoryItemImage : MonoBehaviour
{
    public BoardWeaponImage imgItem;
    public RectTransform rectTransform;
    public Image imgCoolTimeMask;
    public Image imgCoolTimeFill;

    public DragDropObject_Inventory dragDropObject;
    
    private ResourceItem m_ResourceItem;
    
    public Sequence DoMoveToPath(params Vector3[] paths)
    {
        if (_currentPosition == Vector3.zero)
            InitPosition(paths.First());
        
        Sequence seq = DOTween.Sequence();
        if (_currentPosition != paths.Last())
        {
            const float moveDuration = 0.8f;
            transform.DOKill();
            if (paths.Length > 2)
            {
                seq.Append(transform.DOPath(paths, moveDuration, PathType.CatmullRom)
                    .SetEase(Ease.OutCubic)
                    .OnComplete(() => transform.position = paths.Last()));
            }
            else
            {
                seq.Append(transform.DOMove(paths.Last(), moveDuration * 0.25f)
                    .SetEase(Ease.OutCubic));
            }
            
            _currentPosition = paths.Last();
        }

        seq.Play();
        return seq;
    }
    
    private Vector3 _currentPosition;

    public void Refresh(ResourceItem resItem, Vector2 size, bool hideThis)
    {
        if (m_ResourceItem == null || m_ResourceItem.Id != resItem.Id)
        {
            OnInitialize();
        }
        
        m_ResourceItem = resItem;
        
        rectTransform.sizeDelta = size;
        imgItem.Refresh(resItem);
        imgCoolTimeMask.sprite = resItem.ClientSpriteIcon;
        
        if (!hideThis)
            this.SetActive(true);
    }

    public void LimitScale(Vector2 baseSize, float maxScaleRatio = 2f)
    {
        var limitSize = baseSize.y * maxScaleRatio;
        if (rectTransform.sizeDelta.y > limitSize)
            rectTransform.localScale = Vector3.one * (limitSize / rectTransform.sizeDelta.y);
    }

    public void ClearTransform()
    {
        rectTransform.localScale = Vector3.one;
        imgItem.transform.localRotation = Quaternion.identity;
    }
    
    public void InitPosition(Vector3 position)
    {
        if (position != Vector3.zero && _currentPosition == position)
            return;
        transform.position = _currentPosition = position;
    }

    public void Clear()
    {
        ClearLocation();
        ClearTransform();
        imgCoolTimeFill.fillAmount = 0;
    }
    
    public void ClearLocation()
    {
        _currentPosition = Vector3.zero;
        transform.localPosition = Vector3.zero;
    }

    public void OnInitialize()
    {
        transform.localScale = Vector3.one;
    }
    
    private Sequence _fxSequence;
    private Coroutine _fxCoroutine;
    
    public void SetSequence(Action<Sequence> sequenceSetter, Action onComplete = null)
    {
        if (_fxCoroutine != null)
            return;
        
        this.SetActive(true);
        
        transform.SetAsLastSibling();
        
        //ShowBackground(false, false);
        
        _fxSequence = DOTween.Sequence();
        
        sequenceSetter?.Invoke(_fxSequence);
        
        _fxSequence.onComplete += () =>
        {
            _fxSequence = null;
            _fxCoroutine = null;
            onComplete?.Invoke();
        };
        
        _fxCoroutine = StartCoroutine(PlaySequence());
    }
    
    private IEnumerator PlaySequence()
    {
        yield return _fxSequence.WaitForCompletion();
        //ShowBackground(true, false);
    }
    
    public Tweener Stamp(Vector3 scale, float duration)
    {
        return DOTween.To(() => scale * 1.3f, x => transform.localScale = x, scale, duration)
            .SetEase(Ease.OutBack);
    }

    public Tweener Fly(Vector3 position, float duration, Ease ease = Ease.InBack)
    {
        return transform.DOLocalMove(position, duration).SetEase(ease);
    }

    private Sequence disappearSequence = null; 
    public Tween Disappear(float duration, bool isSell)
    {
        disappearSequence.Kill();
        disappearSequence  = DOTween.Sequence();

        transform.localScale = Vector3.one;
            
        //sequence.Join(transform.DOMoveXY(worldPoint, duration));
        disappearSequence.Join(transform.DOScale(Vector3.zero, duration));
        disappearSequence.SetEase(Ease.InBack);
        disappearSequence.Play();

        if (isSell)
        {
            var sequence = DOTween.Sequence();
            var inText = m_ResourceItem.GetLocalizedString("SellEffect");
            if (!string.IsNullOrEmpty(inText))
            {
                var text = TransientTextCanvas.Show(Vector3.zero, inText);
                text.transform.position = transform.position + Vector3.up;
                text.color = Color.white;
                sequence.SetTarget(text);
                sequence.Join(text.transform.DOMove(transform.position + Vector3.up * 2f, 1f));
                sequence.Join(text.DOFade(0f, 1f));
                sequence.OnComplete(() =>
                {
                    TransientTextCanvas.Return(text);
                });   
            }   
        }

        return disappearSequence;
    }
    
    private bool _shouldShake;
    private bool _shouldShakeInited;
    private Quaternion _originalRotation;

    private void Start()
    {
        _originalRotation = imgItem.transform.localRotation;
    }

    private void Update()
    {
        if (_shouldShake)
        {
            var speed = Math.Max(m_ResourceItem.InventoryShakeSpeed, 1f);
            var magnitude = Math.Max(m_ResourceItem.InventoryShakeMagnitude, 1f);
            var offsetZ = (Mathf.PerlinNoise(0, Time.time * speed) - 0.5f) * magnitude * 2f;

            imgItem.transform.localRotation = _originalRotation * Quaternion.Euler(0, 0, offsetZ);
            _shouldShake = false;
        }
        else if (_shouldShakeInited)
            imgItem.transform.localRotation = _originalRotation;
    }
    
    public void DoShake()
    {
        _shouldShake = true;
        _shouldShakeInited = true;
    }

    public void EnableDragDrop()
    {
        imgItem.raycastTarget = true;
        enabled = true;
    }

    public void DisableDragDrop()
    {
        imgItem.raycastTarget = false;
        enabled = false;

        dragDropObject.parent = null;
        dragDropObject.index = 0;
        dragDropObject.dropOnly = false;
        dragDropObject.originCell = null;
        dragDropObject.dragThreshHold = 0f;
        dragDropObject.canDrag = null;
    }
    
    
}
