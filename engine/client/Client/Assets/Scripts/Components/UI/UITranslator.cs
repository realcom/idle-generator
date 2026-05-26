using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UITranslator : MonoBehaviour
{
    [SerializeField] private string m_Key = string.Empty;

    private void Start()
    {
        if (string.IsNullOrEmpty(m_Key))
            return;

        if (TryGetComponent<TextMeshProUGUI>(out var textMeshProUGUI))
        {
            textMeshProUGUI.text = m_Key.L();
        }
    }
}
