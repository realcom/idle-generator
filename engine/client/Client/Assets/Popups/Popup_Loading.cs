using System;
using System.Collections;
using Cysharp.Threading.Tasks;
using UnityEngine;
using TMPro;

public class Popup_Loading : UIPopup {
	public CanvasGroup cg;
	public TextMeshProUGUI txt;

	private float _fakeLoadingDuration;
	
	public async UniTask Initialize(string message = null, float fakeLoadingDuration = 0f)
	{
		if (!string.IsNullOrEmpty(message))
			txt.text = message;
		_fakeLoadingDuration = Mathf.Max(fakeLoadingDuration, 0.2f);
		await Activate();
	}

	private async UniTask Activate()
	{
		cg.alpha = 0f;
		await UniTask.Delay(TimeSpan.FromSeconds(_fakeLoadingDuration));
		cg.alpha = 1f;
	}

	public async UniTask Deactivate()
	{
		cg.alpha = 1f;
		await UniTask.Delay(TimeSpan.FromSeconds(0.1f));
		cg.alpha = 0f;
	}

	protected override void Awake()
	{
		base.Awake ();
		
		Debug.Log("Popup_Loading");
	}

	protected override void RefreshByFlag()
	{
		
	}

	public void Reset() {
		// txtProgress.SetActive (false);
	}

	public void SetText(string text)
	{
		txt.text = text;
	}

	public override void LogEvent()
	{
	}


	public override void LogEventEnd()
	{
	}
}
