using System;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class CameraMixerBehaviour : ZSkillMixerBehaviour
{
    /*
    private Camera _camera;
    private CinemachineBrain _cinemachineBrain;
    private CinemachineVirtualCamera _cinemachineVirtualCamera;
    private CinemachineCameraOffset _cinemachineVirtualCameraOffset;
    private CinemachineFramingTransposer _cinemachineFramingTransposer;

    private Vector3 _offsetCameraInit;
    private float _initCamDistance;
    private bool _wasInitSuccessfully = false;

    protected override bool useGrouping => true;

    protected override void OnCreate()
    {
        base.OnCreate();

        if ((_camera = Camera.main) != null)
        {
            if ((_cinemachineBrain = _camera.gameObject.Get<CinemachineBrain>()) != null)
            {
                if (_cinemachineBrain.ActiveVirtualCamera == null)
                    return;
                _cinemachineVirtualCamera = _cinemachineBrain.ActiveVirtualCamera.VirtualCameraGameObject.Get<CinemachineVirtualCamera>();
                _cinemachineVirtualCameraOffset = _cinemachineBrain.ActiveVirtualCamera.VirtualCameraGameObject.Get<CinemachineCameraOffset>();
                _cinemachineFramingTransposer = _cinemachineVirtualCamera.GetCinemachineComponent<CinemachineFramingTransposer>();
                _offsetCameraInit = _cinemachineVirtualCameraOffset.m_Offset;
                _initCamDistance = _cinemachineFramingTransposer.m_CameraDistance;
                _wasInitSuccessfully = true;
            }
        }
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();

        if (_cinemachineVirtualCamera)
        {
            _cinemachineVirtualCameraOffset.m_Offset = _offsetCameraInit;
        }

        if (_cinemachineFramingTransposer)
        {
            _cinemachineFramingTransposer.m_CameraDistance = _initCamDistance;
        }
        
        _camera = null;
        _cinemachineBrain = null;
        _cinemachineVirtualCamera = null;
        _cinemachineVirtualCameraOffset = null;
    }
    
    protected override void OnProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.OnProcessFrame(playable, info, playerData);

        if (!_wasInitSuccessfully)
            return;
        
        var time = playable.GetTime();

        var offsetCamera = _offsetCameraInit;
        var zoomDistance = _initCamDistance;

        foreach (var playableClip in playableClipsInGroups)
        {
            var clip = playableClip.clip;
            var scriptPlayable = playableClip.playable;
            var t = (float)(scriptPlayable.GetTime() / scriptPlayable.GetDuration());

            var behaviour = scriptPlayable.GetBehaviour() as CameraBaseBehaviour<FxSettings>;
            if (behaviour?.canExecute == false)
                continue;
            
            // switch (behaviour)
            // {
            //     case CameraShakeBehaviour shakeBehaviour:
            //     {
            //         if (clip.start > time || clip.end < time)
            //             t = 0;
            //         else
            //             t = shakeBehaviour.ease.Evaluate(t);
            //
            //         offsetCamera += new Vector3(shakeBehaviour.random, shakeBehaviour.random) * shakeBehaviour.magnitude * t;
            //         break;
            //     }
            //     case CameraZoomBehaviour zoomBehavior:
            //     {
            //         if (clip.start > time)
            //             t = 0;
            //         else if (clip.end < time)
            //             t = 1;
            //         else
            //             t = zoomBehavior.ease.Evaluate(t);
            //
            //         zoomDistance = Mathf.Lerp(zoomDistance, _initCamDistance / zoomBehavior.amount, t);
            //         break;
            //     }
            // }
        }

        if (_cinemachineVirtualCameraOffset)
            _cinemachineVirtualCameraOffset.m_Offset = offsetCamera;

        if (_cinemachineFramingTransposer)
            _cinemachineFramingTransposer.m_CameraDistance = zoomDistance;
    }
    */
}
