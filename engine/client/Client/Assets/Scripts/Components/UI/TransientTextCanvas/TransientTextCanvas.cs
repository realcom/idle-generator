using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class TransientTextCanvas : ZUIBehaviour, EventListener
{
    [SerializeField] private TextMeshProUGUI m_TextPrefab;
    private int poolId = -1;

    private static TransientTextCanvas m_Instance = null;

    public static TextMeshProUGUI Show(Vector3 worldPos, string inText, Color? color = null)
    {
        if (m_Instance == null)
            return null;

        var text = BehaviourPool<TextMeshProUGUI>.Get(m_Instance.m_TextPrefab, worldPos, Quaternion.identity, m_Instance.transform);
        text.text = inText;
        text.color = color ?? Color.white;

        return text;
    }

    public static void Return(TextMeshProUGUI textMeshProUGUI)
    {
        if (m_Instance == null)
            return;

        BehaviourPool<TextMeshProUGUI>.Release(textMeshProUGUI, m_Instance.poolId);
    }
    
    protected override void Awake()
    {
        base.Awake();
        
        GameManager.Get().AddListener(this);
        ZWorldClient.Get().AddListener(this);
        
        poolId = m_TextPrefab.GetInstanceID();
        
        m_Instance = this;
    }

    protected override void OnDestroy()
    {
        if (m_Instance == this)
            m_Instance = null;
                
        GameManager.Get().RemoveListener(this);
        ZWorldClient.Get().RemoveListener(this);
        
        base.OnDestroy();
    }

    public async UniTask HandleEvent(GameEvent e)
    {
        
    }
}
