using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor.Presets;
#endif

[RequireComponent(typeof(ParticleSystem))]
public class SpriteTrailRenderer : MonoBehaviour
{
    [SerializeField] private SpriteRenderer m_TargetSpriteRenderer;
    [SerializeField] private ParticleSystem m_TrailParticleSystem;

#if UNITY_EDITOR
    [SerializeField] private Material m_Material;
    [SerializeField] private Preset m_ParticlePreset;
#endif

    private ParticleSystem.MainModule m_MainModule;

#if UNITY_EDITOR
    private void OnValidate()
    {
        InitParticleSystem();
    }

    [Button]
    private void InitParticleSystem()
    {
        if (m_TargetSpriteRenderer == null)
            m_TargetSpriteRenderer = GetComponent<SpriteRenderer>() ?? transform.parent.GetComponentInChildren<SpriteRenderer>();

        if (m_TrailParticleSystem == null)
            m_TrailParticleSystem = GetComponent<ParticleSystem>();

        if (m_TargetSpriteRenderer != null && m_TrailParticleSystem != null)
        {
            if (m_Material == null)
                m_Material = m_TargetSpriteRenderer.material;
            
            if (m_ParticlePreset != null)
                m_ParticlePreset.ApplyTo(m_TrailParticleSystem);

            var sprite = m_TargetSpriteRenderer.sprite;
            m_TrailParticleSystem.textureSheetAnimation.SetSprite(0, sprite);
            var main = m_TrailParticleSystem.main;

            var deltaScale = 100 / sprite.pixelsPerUnit;
            
            main.startSize3D = true;
            main.startSizeX = new ParticleSystem.MinMaxCurve(deltaScale);
            main.startSizeY = new ParticleSystem.MinMaxCurve(deltaScale);
            main.startSizeZ = new ParticleSystem.MinMaxCurve(deltaScale);


            if (m_Material != null)
            {
                m_TargetSpriteRenderer.sharedMaterial = m_Material;
                var psRend  = m_TrailParticleSystem.GetComponent<ParticleSystemRenderer>();
                psRend.sharedMaterial = m_Material;

                psRend.sortingLayerID = SortingLayer.NameToID("Skill");
                psRend.sortingOrder = -1;
            }
        }
    }

#endif

    private void Start()
    {
        if (enabled)
        {
            enabled &= m_TargetSpriteRenderer != null &&
                       m_TrailParticleSystem != null;
        }
        
        m_MainModule = m_TrailParticleSystem.main;
    }

    private void Update()
    {
        m_MainModule.startRotationZ = m_TargetSpriteRenderer.transform.localEulerAngles.z * -Mathf.Deg2Rad;
    }
}
