using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using Commons.Resources;
using UnityEngine;
using Object = UnityEngine.Object;
using Resources = UnityEngine.Resources;

public class AudioManager : MonoBehaviour
{
	private static readonly AudioManager _singleton = new GameObject("[AudioManager]").AddComponent<AudioManager>().Initialize();

	public static AudioManager Get()
	{
		return _singleton;
	}
	
	public bool wasInitialized => _sfxPool.Count == C_SFXPoolCapacity;

	private const int C_SFXPoolCapacity = 100;
	private GameObject _audioPrefabSFX = null;
	private readonly Queue<AudioComponent> _sfxPool = new(C_SFXPoolCapacity);
	private readonly AudioComponent[] _sfxContainer = new AudioComponent[C_SFXPoolCapacity];
	private readonly Dictionary<string, int> _sfxClipInstanceCount = new ();
	private readonly Dictionary<string, List<AudioComponent>> _playingFxMap = new();
	
	private FieldToggle<AudioComponent> _BGMAudioComponents = null;
	private AudioComponent _currentBGM = null;
	
	private const string C_CurrentBGM = "Current BGM";
	private const string C_QueuedBGM = "Queued BGM";
	
	private AudioManager Initialize()
	{
		_BGMAudioComponents = new(
			Instantiate(Resources.Load<GameObject>("Prefabs/AudioPrefab_BGM"), transform).GetComponent<AudioComponent>(),
			Instantiate(Resources.Load<GameObject>("Prefabs/AudioPrefab_BGM"), transform).GetComponent<AudioComponent>());
		_BGMAudioComponents[0].name = C_CurrentBGM;
		_BGMAudioComponents[1].name = C_QueuedBGM;
		_currentBGM = _BGMAudioComponents.Current;

		_audioPrefabSFX = Resources.Load<GameObject>("Prefabs/AudioPrefab_SFX");
		StartCoroutine(PreloadSFXPool());
		
		DontDestroyOnLoad(gameObject);

		return this;
	}
	
	private IEnumerator PreloadSFXPool()
	{
		for (var i = 0; i < C_SFXPoolCapacity; i++)
		{
			var go = Instantiate(_audioPrefabSFX, transform);
			var audioComponent = go.GetComponent<AudioComponent>();
			audioComponent.cachedTransform.position = Vector3.zero;
			audioComponent.Clear();
			
			go.SetActive(false);
			
			_sfxPool.Enqueue(audioComponent);
			_sfxContainer[i] = audioComponent;

			if (i % 10 == 0)
				yield return null;
		}
	}

	public void Clear()
	{
		for (var i = 0; i < _sfxContainer.Length; i++)
		{
			_sfxContainer[i].Clear();
		}
	}

	public void PlayFX(int audioID, Transform parent = null)
	{
		if (ResourceAudio.Get(audioID) is { } resourceAudio)
		{
			PlayFX(resourceAudio.GetAudioClip(), parent: parent, volume: resourceAudio.Volume);
			HapticSystem.Haptic(resourceAudio);
		}
	}
	
	public void PlayFX(string audioName, Transform parent = null)
	{
		if (ResourceAudio.Get(audioName) is { } resourceAudio)
		{
			PlayFX(resourceAudio.GetAudioClip(), audioName: audioName, parent: parent, volume: resourceAudio.Volume);
			HapticSystem.Haptic(resourceAudio);
		}
	}

	public void StopFx(string audioName)
	{
		if (_playingFxMap.TryGetValue(audioName, out var acList))
		{
			var componentsToStop = new List<AudioComponent>(acList);
			foreach (var ac in componentsToStop)
			{
				if (ac != null && ac.myAudioSource.isPlaying)
				{
					ac.myAudioSource.Stop();
            
					if (ac.onPlayEnded != null)
					{
						var cb = ac.onPlayEnded;
						ac.onPlayEnded = null;
						cb(ac);
					}
					else
					{
						ReturnAudio(ac);
						acList.Remove(ac);
					}
				}
			}
		}
	}
	
	public AudioComponent PlayFX(AudioClip audioClip, string audioName = null, float delay = 0f, Transform parent = null, Vector3? pos = null, float volume = 1.0f)
	{
		if (audioClip == null)
			return null;

		var count = _sfxClipInstanceCount.GetValueOrDefault(audioClip.name, 0);
		
		if (count >= 5) // todo: make this settable
			return null;

		var ac = GetAudio();
		if (ac == null)
			return null;
		
		ac.onPlayEnded = ReturnAudio;
		if (audioName == null)
			audioName = audioClip.name;
		
		if (!_playingFxMap.ContainsKey(audioName))
		{
			_playingFxMap[audioName] = new List<AudioComponent>();
		}
		_playingFxMap[audioName].Add(ac);

		var originalCallback = ac.onPlayEnded;
		ac.onPlayEnded = (component) =>
		{
			if (_playingFxMap.TryGetValue(audioName, out var list))
			{
				list.Remove(component);
			}
			originalCallback?.Invoke(component);
		};
		
		parent ??= transform;
		Transform tr;
		(tr = ac.transform).SetParent(parent);
		if (pos.HasValue)
			tr.position = pos.Value;

		ac.InitAudioData(audioClip, volume, GameManager.Get().fxVolume.Get());
		ac.Play(delay);
		
		_sfxClipInstanceCount[audioClip.name] = count + 1;
		
		return ac;
	}

	public AudioComponent GetAudio()
	{
		if (!_sfxPool.TryDequeue(out var ac))
			return null;
		
		return ac;
	}
	
	public void ReturnAudio(AudioComponent audioComponent)
	{
		audioComponent.transform.SetParent(transform);
		_sfxPool.Enqueue(audioComponent);
		
		_sfxClipInstanceCount[audioComponent.myAudioSource.clip.name] -= 1;
	}

	public void PlayBGM(int audioID)
	{
		if (ResourceAudio.Get(audioID) is { } resourceAudio)
			PlayBGM(resourceAudio.GetAudioClip(), resourceAudio.Volume);
	}

	public void PauseBGM()
	{
		if (_currentBGM != null)
			_currentBGM.Pause();
	}
	
	public void ResumeBGM()
	{
		if (_currentBGM != null)
			_currentBGM.Resume();
	}
	
	public void PlayBGM(string audioName)
	{
		if (ResourceAudio.Get(audioName) is { } resourceAudio)
			PlayBGM(resourceAudio.GetAudioClip(), resourceAudio.Volume);
		else
		{
			var fallbackClip = Resources.Load<AudioClip>("Sounds/" + audioName);
			if (fallbackClip != null)
			{
				PlayBGM(fallbackClip);
			}
		}
	}

	public void PlayBGM(AudioClip clip, float volume = 1f, float fadeDuration = C_BGMChangeTime)
	{
		if (clip == null)
			return;
		
		if (_BGMAudioComponents.Current.myAudioSource.clip == null)
		{
			_BGMAudioComponents.Current.myAudioSource.clip = clip;
			_BGMAudioComponents.Current.PlayWithFadeIn(fadeDuration);
		}
		else
		{
			ChangeBGM(clip, volume, fadeDuration);
		}
	}

	public void OnSFXVolumeChanged(float changedVolume)
	{
		for (var i = 0; i < _sfxContainer.Length; i++)
		{
			var audioComponent = _sfxContainer[i];
			if (audioComponent != null)
			{
				audioComponent.OnUserSettingVolumeChanged(changedVolume);
			}
		}
	}

	public void OnBGMVolumeChanged(float changedVolume)
	{
		foreach (var ac in _BGMAudioComponents)
		{
			if (ac)
				ac.OnUserSettingVolumeChanged(changedVolume);
		}
	}
	
	private const float C_BGMChangeTime = 1.0f;

	private void ChangeBGM(AudioClip audioClip, float volume, float fadeDuration)
	{
		if (_BGMAudioComponents.Any(ac => ac.myAudioSource.clip == audioClip))
		{
			return;
		}

		_currentBGM.StopWithFadeOut(fadeDuration, (ac) => ac.myAudioSource.clip = null);
		
		_BGMAudioComponents.Current.name = C_QueuedBGM;
		_BGMAudioComponents.Toggle();
		_BGMAudioComponents.Current.name = C_CurrentBGM;

		_BGMAudioComponents.Current.InitAudioData(audioClip, volume, GameManager.Get().bgmVolume.Get());
		_currentBGM = _BGMAudioComponents.Current;
		_BGMAudioComponents.Current.PlayWithFadeIn(fadeDuration);
	}

}