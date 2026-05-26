using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections.Generic;
using System;

public class DpadController : MonoBehaviour
{
    public RectTransform rtContainer;
    public RectTransform rtSpace;
    public Canvas parentCanvas;
    public float maxBallDistanceFromTarget;

    public Vector3 direction = Vector3.zero;

    private Vector3 _beginPos = Vector3.zero;
    private Vector3 _initialPos = Vector3.zero;
    private Vector3 _pos = Vector3.zero;
    private InputType _inputType;
    private bool _touched;
    private Touch? _beginTouch = null;
    private int _dpadShowType;
    private bool _dpadPosFixed;

    public GameObject[] goActiveButtons;
    public GameObject goPointer;
    public Image imgDpad;

    private enum InputType {
        NONE,
        TOUCH,
        MOUSE,
        OTHERS,
    }

    private void Start()
    {
        var worldPoint = rtContainer.TransformPoint(rtContainer.rect.center);
        var screenPoint = RectTransformUtility.WorldToScreenPoint(parentCanvas.worldCamera, worldPoint);
        _beginPos = _initialPos = screenPoint;
        RefreshDpadSettings();
        
        imgDpad.SetActive(_dpadShowType == (int)GameManager.DpadShowType.ALWAYS_SHOW);
    }

    public void RefreshDpadSettings()
    {
        // _dpadShowType = HUDManager.Get().gamePad.dpadShowType.Get();
        // _dpadPosFixed = HUDManager.Get().gamePad.dpadPosFixed.Get();

        if (_dpadPosFixed)
        {
            _beginPos = _initialPos;
            RectTransformUtility.ScreenPointToLocalPointInRectangle(rtSpace, _initialPos, parentCanvas.worldCamera, out var initialPos);
            rtContainer.anchoredPosition = initialPos;
        }
        imgDpad.SetActive(_dpadShowType == (int)GameManager.DpadShowType.ALWAYS_SHOW);
    }
    
    private void Reset()
    {
        direction = Vector3.zero;
        _touched = false;
        _inputType = InputType.NONE;
    }

    private void UpdateClick()
    {
        // goActiveButtons[0].SetActive(direction.x > 0);
        // goActiveButtons[1].SetActive(direction.x < 0);
        // goActiveButtons[2].SetActive(direction.y > 0);
        // goActiveButtons[3].SetActive(direction.y < 0);

        // imgDpad.enabled = direction != Vector2.zero;
        
        if (_dpadShowType == (int)GameManager.DpadShowType.SHOW_WHEN_TOUCHED)
            imgDpad.SetActive(direction != Vector3.zero);
        goPointer.SetActive(direction != Vector3.zero && _dpadShowType != (int)GameManager.DpadShowType.ALWAYS_HIDE);
        if (direction != Vector3.zero)
        {
            var directionNormalized = direction.normalized;
            var angle = Vector3.SignedAngle(Vector3.forward, directionNormalized, Vector3.down);
            goPointer.transform.localRotation = Quaternion.Euler(0, 0, angle);
        }
    }

    private void Update()
    {
        if (Input.touchSupported)
        {
            Reset();

            var canceledCount = 0;
            //
            for (var i = 0; i < Input.touchCount; i++)
            {
                var touch = Input.GetTouch(i);
                //if (touch.phase == TouchPhase.Began && !Utility.IsPointerOverUIObject(touch.position, typeof(Popup_SkillIndicator)))
                //{
                //    if (RectTransformUtility.ScreenPointToLocalPointInRectangle(rtSpace, touch.position, null, out var localPoint))
                //    {
                //        if (rtSpace.rect.Contains(localPoint))
                //        {
                //            if (!_dpadPosFixed)
                //                _beginPos = touch.position;
                //            _beginTouch = touch;
                //        }
                //    }
                //}
                //else if (touch.phase is TouchPhase.Ended or TouchPhase.Canceled)
                //{
                //    canceledCount++;
                //}
                //else if (_beginTouch?.fingerId == touch.fingerId)
                //{
                //    _beginTouch = touch;
                //}
            }

            if (canceledCount > 0 && canceledCount == Input.touchCount)
            {
                _beginTouch = null;
            }
            else if (_beginTouch.HasValue)
            {
                var touch = _beginTouch.Value;
                if (touch.phase != TouchPhase.Ended && touch.phase != TouchPhase.Canceled)
                {
                    _touched = true;
                    _inputType = InputType.TOUCH;
                    _pos = touch.position;
                }
                else
                {
                    _beginTouch = null;
                }
            }
        }
        else
        {
            //if (Input.GetMouseButtonDown(0) && !Utility.IsPointerOverUIObject(Input.mousePosition, typeof(Popup_SkillIndicator)))
            //{
            //    if (RectTransformUtility.ScreenPointToLocalPointInRectangle(rtSpace, Input.mousePosition, null, out var localPoint))
            //    {
            //        if (rtSpace.rect.Contains(localPoint))
            //        {
            //            _touched = true;
            //            _inputType = InputType.MOUSE;
            //            if (!_dpadPosFixed)
            //                _beginPos = Input.mousePosition;
            //        }
            //    }
            //}

            if (Input.GetMouseButtonUp(0))
                Reset();

            if (_touched || Input.GetMouseButton(0))
                _pos = Input.mousePosition;
        }

        // 외부 입력 지원
        if (_inputType is InputType.NONE or InputType.OTHERS)
        {
            var dir = Vector3.zero;
            dir += Input.GetAxisRaw("Horizontal") * Vector3.right;
            dir += Input.GetAxisRaw("Vertical") * Vector3.up;
            dir.z = 0;
            if (dir != Vector3.zero)
            {
                direction = dir;
                _inputType = InputType.OTHERS;
            }
            else
                Reset();
        }

        if (!_touched)
        {
        }
        else
        {
            if (!_dpadPosFixed)
            {
                RectTransformUtility.ScreenPointToLocalPointInRectangle(rtSpace, _beginPos, parentCanvas.worldCamera, out var beginPos);
                rtContainer.anchoredPosition = beginPos;
            }

            var magnitude = Vector3.ClampMagnitude(_pos - _beginPos, maxBallDistanceFromTarget);
            direction = new Vector3(magnitude.x, 0, magnitude.y) / maxBallDistanceFromTarget;
        }

        UpdateClick();
    }
}
