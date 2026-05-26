using System;
using UnityEngine;

public class ZToggle : ZButton
{
	public GameObject[] objOnList;
	public GameObject[] objOffList;
	public bool isOn
	{
		get => _isOn;
		set
		{
			_isOn = value;
			RefreshToggleObjects();
		}
	}
	
	private GamePrefs<bool> _isOnPrefs;
	
	[SerializeField]
	private bool _isOn;

	private Action<bool> _actionOnClick;
	

	protected override void Start()
	{
		base.Start();
		
		if (isStorable)
		{
			_isOnPrefs = new(GetGamePrefsKey("IsOn"), _isOn, autoSave: true);
			isOn = _isOnPrefs.Get();	
		}
		else
			RefreshToggleObjects();
	}

	public override void OnPointerClick()
	{
		base.OnPointerClick();
		isOn = !isOn;
		_actionOnClick?.Invoke(isOn);
	}

	private void RefreshToggleObjects()
	{
		foreach(var objOn in objOnList)
			objOn.SetActive(_isOn);
		
		foreach(var objOff in objOffList)
			objOff.SetActive(_isOn == false);
	}

	protected override void OnDestroy()
	{
		base.OnDestroy();
		
		if (isStorable && _isOnPrefs != null)
			_isOnPrefs.Set(isOn);
	}

	public void SetToggle(Action<bool> action)
	{
		_actionOnClick = action;
	}
}