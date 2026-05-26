using System;using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Spine;
using TMPro;
using UnityEngine;

public struct ToastMessageData : IEquatable<ToastMessageData>
{
	public readonly bool ShowForce;
	public readonly float Duration;
	public readonly string Message;

	public ToastMessageData(bool showForce, float duration, string message)
	{
		ShowForce = showForce;
		Duration = duration;
		Message = message;
	}

	public bool IsValid()
	{
		if (string.IsNullOrEmpty(Message))
			return false;

		return true;
	}

	public bool Equals(ToastMessageData other)
	{
		if (string.IsNullOrEmpty(Message) || string.IsNullOrEmpty(other.Message))
			return false;
		
		return string.CompareOrdinal(Message, other.Message) == 0;
	}
}

public struct ToastData :  IEquatable<ToastData>
{
	public readonly ToastMessageData MessageData;
	public readonly string ToastDerivedClassName;
	public readonly string SFXKey;

	public ToastData(ToastMessageData messageData, string toastDerivedClassName, string sfxKey)
	{
		MessageData = messageData;
		ToastDerivedClassName = toastDerivedClassName;

		SFXKey = string.IsNullOrEmpty(sfxKey) ? "CARTOON_MOTION_SFX_002" : sfxKey;
	}
	
	public bool Equals(ToastData other)
	{
		return MessageData.Equals(other.MessageData);
	}
}

public class ToastDataComparer : IEqualityComparer<ToastData>
{
	public static readonly ToastDataComparer Comparer = new();
	
	public bool Equals(ToastData x, ToastData y)
	{
		return x.Equals(y);
	}

	public int GetHashCode(ToastData obj)
	{
		return obj.MessageData.Message.GetHashCode();
	}
}

public abstract class Toast : UIPopup
{
	private const int c_ToastMaxCount = 10;
	private static readonly Queue<ToastData> _datas = new(c_ToastMaxCount);
	private static readonly HashSet<ToastData> _dataSet = new(c_ToastMaxCount, ToastDataComparer.Comparer);

	public TextMeshProUGUI Text;

	public static Toast Show<T>(ToastMessageData messageData, string sfxKey = null) where T : Toast
	{
		if (messageData.IsValid() == false)
			return null;

		var data = new ToastData(messageData, typeof(T).Name, sfxKey);
		return Show_Internal<T>(data);
	}

	public static T Show<T>(string text, float duration = 1f, bool showForce = true, string sfxKey = null) where T : Toast
	{
		var messageData = new ToastMessageData(showForce, duration, text);
		if (messageData.IsValid() == false)
			return null;

		var data = new ToastData(messageData, typeof(T).Name, sfxKey);
		return Show_Internal<T>(data);
	}

	private static T Show_Internal<T>(ToastData data) where T : Toast
	{
		if (!_dataSet.Add(data))
			return null;

		if (data.MessageData.ShowForce)
		{
			return CreateToast<T>(data);
		}
		else
		{
			_datas.Enqueue(data);
			return Show_Internal<T>();
		}
	}

	private static Toast Show_Internal()
	{
		return Show_Internal<Toast>();
	}
	
	private static T Show_Internal<T>() where T : Toast
	{
		while (_datas.Count > c_ToastMaxCount)
		{
			_datas.Dequeue();
		}

		return _datas.TryDequeue(out var data) ? CreateToast<T>(data) : null;
	}

	private static T CreateToast<T>(ToastData data) where T : Toast
	{
		if (GameManager.Get().ShowPopup(data.ToastDerivedClassName, GameManager.Get().scene.GetToastParent()) is not T toastPopup)
			return null;
		
		GameManager.Get().PlayFX(data.SFXKey);
			
		toastPopup.Initialize(data);
		return toastPopup;
	}

	private void Initialize(ToastData data)
	{
		Text.text = data.MessageData.Message;

		Initialize_Internal(data.MessageData);

		ReleaseAfterDelay(data, data.MessageData.Duration).Forget();
	}
	
	private async UniTask ReleaseAfterDelay(ToastData data, float delay)
	{
		await UniTask.Delay(TimeSpan.FromSeconds(delay), cancellationToken: this.GetCancellationTokenOnDestroy(), ignoreTimeScale: true);
		Release(data);
	}

	protected abstract void Initialize_Internal(ToastMessageData messageData);

	private void Release(ToastData data)
	{
		_dataSet.Remove(data);
		Release_Internal(data);
	}

	protected abstract void Release_Internal(ToastData data);
	
	internal sealed override void Hide()
	{
		Show_Internal();
		
		base.Hide();
	}

}
