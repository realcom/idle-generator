using System;
using System.Collections;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class AudioComponent : ZMonoBehaviour
{
	[HideInInspector] public int audioID = 0;

	[field: SerializeField] public AudioSource myAudioSource { get; private set; }
	[field: SerializeField] public Transform cachedTransform { get; private set; }
	[field: SerializeField] public GameObject cachedGameObject { get; private set; }

	private double _clipTimeOverAt = 0.0f;
	private float _systemVolume = 1.0f;
	private float _personalVolume = 1.0f;
	
	private float volume => _systemVolume * _personalVolume;

	public Action<AudioComponent> onPlayEnded { get; set; }
	public Action<AudioComponent> onPlayPaused { get; set; }

	public void InitAudioData(AudioClip audioClip, float personalVolume = 1.0f, float systemVolume = 1.0f)
	{
		_systemVolume = systemVolume;
		_personalVolume = personalVolume;
		cachedGameObject.SetActive(true);
		
		audioID = audioClip.GetInstanceID();
		myAudioSource.clip = audioClip;
		myAudioSource.volume = volume;
		name = $"FX_{audioClip.name}_{GetInstanceID()}";
	}

	public void OnUserSettingVolumeChanged(float changedVolume)
	{
		_systemVolume = changedVolume;
		myAudioSource.volume = volume;
	}

	public void Play(float delay = 0.0f)
	{
		myAudioSource.PlayDelayed(delay);

		_clipTimeOverAt = Utility.GetTime() + GetClipLength() + delay;
		
		OnLeaveUnplayable();
	}

	private Coroutine _changeVolumeCoroutine = null;
	
	public void PlayWithFadeIn(float fadeInTime, Action<AudioComponent> endCallback = null)
	{
		Play();

		if (_changeVolumeCoroutine != null)
		{
			StopCoroutine(_changeVolumeCoroutine);
			_changeVolumeCoroutine = null;
		}
		
		_changeVolumeCoroutine ??= StartCoroutine(IChangeAudioVolume_Internal(0, volume, fadeInTime, endCallback));
	}

	public void StopWithFadeOut(float fadeOutTime, Action<AudioComponent> endCallback = null)
	{
		if (_changeVolumeCoroutine != null)
		{
			StopCoroutine(_changeVolumeCoroutine);
			_changeVolumeCoroutine = null;
		}
		
		_changeVolumeCoroutine ??= StartCoroutine(IChangeAudioVolume_Internal(volume, 0, fadeOutTime, (ac) =>
		{
			Stop();
			endCallback?.Invoke(ac);
		}));
	}
	
	private IEnumerator IChangeAudioVolume_Internal(float start, float end, float time, Action<AudioComponent> endCallback = null)
	{
		var deltaTime = 0.0f;
		var percentage = 0.0f;

		while (percentage < 1.0f)
		{
			myAudioSource.volume = Mathf.Lerp(start, end, percentage);
			deltaTime += Time.deltaTime;
			percentage = deltaTime / time;

			yield return null;
		}
		
		myAudioSource.volume = end;
		
		endCallback?.Invoke(this);
	}

	public void Stop()
	{
		if (!myAudioSource.isPlaying) 
			return;
		
		myAudioSource.Stop();
		OnPlayEnded();
	}

	public void Pause(float pauseSec = -1.0f)
	{
		if (!myAudioSource.isPlaying) 
			return;
		
		myAudioSource.Pause();
		OnEnterUnplayable();
		onPlayPaused?.Invoke(this);

		if (pauseSec > 0.0f)
		{
			StartCoroutine(IUnPause(pauseSec));
		}
	}

	public void Resume(float delay = -1.0f)
	{
		if (myAudioSource.isPlaying)
			return;

		StartCoroutine(IUnPause(delay));
	}

	private IEnumerator IUnPause(float delay)
	{
		if (delay <= 0.0f)
		{
			UnPause();
			yield break;
		}

		yield return Utility.GetWaitForSeconds(delay);
		
		UnPause();
	}

	public void UnPause()
	{
		myAudioSource.UnPause();
		OnLeaveUnplayable();
	}

	private bool IsPlayTimeOver()
	{
		return _clipTimeOverAt > 0 && _clipTimeOverAt <= Utility.GetTime();
	}

	private float GetClipLength()
	{
		return myAudioSource.clip?.length ?? 0.0f;
	}

	private void OnEnterUnplayable()
	{
		enabled = false;
	}

	private void OnLeaveUnplayable()
	{
		enabled = true;
	}

	public void Clear()
	{
		name = "==EMPTY-SFX==";
		myAudioSource.clip = null;
		_clipTimeOverAt = 0f;
	}

	protected override void Update()
	{
		if (IsPlayTimeOver() && myAudioSource.isPlaying == false)
		{
			OnPlayEnded();
		}

		myAudioSource.pitch = TimeSystem.timeScale;
	}

	private void OnPlayEnded()
	{
		OnEnterUnplayable();
		cachedGameObject.SetActive(false);
		
		onPlayEnded?.Invoke(this);

		Clear();
	}
	
}