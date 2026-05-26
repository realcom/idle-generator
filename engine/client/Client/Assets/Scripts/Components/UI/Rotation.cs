//----------------------------------------------
//      UnitZ : FPS Sandbox Starter Kit
//    Copyright © Hardworker studio 2015 
// by Rachan Neamprasert www.hardworkerstudio.com
//----------------------------------------------

using System;
using UnityEngine;
using System.Collections;

public class Rotation : MonoBehaviour {

	public Transform[] TargetTransforms = new Transform[0];
	
	public Vector3 Axis = Vector3.forward;
	public float speed = 1;

	private Vector3 euler = Vector3.zero;

	private void Start()
	{
		if (TargetTransforms is { Length: 0 })
		{
			TargetTransforms = new[] { transform };
		}
	}

	void Update ()
	{
		euler += Axis * (speed * Time.deltaTime);
		euler = new Vector3(euler.x % 360, euler.y % 360, euler.z % 360);
		
		foreach (var transform in TargetTransforms)
		{
			transform.rotation = Quaternion.Euler(euler);
		}
	}
}
