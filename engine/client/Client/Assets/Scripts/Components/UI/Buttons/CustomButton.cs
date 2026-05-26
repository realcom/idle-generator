using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Components.UI;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.UI;
using TMPro;
using UnityEngine.Serialization;
using UnityEngine.SocialPlatforms.Impl;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.UI;
#endif

public ref struct ButtonInteractor
{
    private CustomButton m_Button;
    private TextMeshProUGUI m_TextReference;

    private bool m_Interactable;
    private string m_NotInteractableMessage;
    private Action m_NotInteractableAction;

    public string notInteractableMessage => m_NotInteractableMessage;
    public Action notInteractableAction => m_NotInteractableAction;

    public ButtonInteractor(CustomButton button, TextMeshProUGUI txtRef = null)
    {
        m_Button = button;
        m_TextReference = txtRef;
        
        m_Interactable = true;
        m_NotInteractableMessage = null;
        m_NotInteractableAction = null;
    }
    
    public void Update(bool interactable, string inNotInteractableMessage = null)
    {
        m_Interactable &= interactable;
        if (!interactable)
        {
            m_NotInteractableMessage = inNotInteractableMessage;
            m_NotInteractableAction = null;
        }
    }
    
    public void Update(bool interactable, Action inNotInteractableAction)
    {
        m_Interactable &= interactable;
        if (!interactable && inNotInteractableAction != null)
        {
            m_NotInteractableAction = inNotInteractableAction;
            m_NotInteractableMessage = null;
        }
    }
    
    private void Apply()
    {
        if (m_TextReference != null)
        {
            m_TextReference.text = !string.IsNullOrEmpty(m_NotInteractableMessage) ? m_NotInteractableMessage : "";
        }

        if (m_Button != null)
        {
            m_Button.interactable = m_Interactable;
            m_Button.Apply(this);
        }

        Clear();
    }

    private void Clear()
    {
        m_Button = null;
        m_TextReference = null;
        
        m_Interactable = true;
        m_NotInteractableMessage = null;
        m_NotInteractableAction = null;
    }
    
    public void Dispose()
    {
        Apply();
    }
}

[AddComponentMenu("UI/CustomButton", 30)]
public class CustomButton : CustomSelectable, IPointerClickHandler, ISubmitHandler
{
    
    [Serializable]
    /// <summary>
    /// Function definition for a button click event.
    /// </summary>
    public class ButtonClickedEvent : UnityEvent {}
    
    [FormerlySerializedAs("m_Group")] [SerializeField] private ButtonGroup m_ButtonGroup;
    
    public ButtonGroup buttonGroup
    {
        get => m_ButtonGroup;
        set => m_ButtonGroup = value;
    }
    
    [SerializeField, HideIf("@m_ButtonGroup != null")] private float m_ClickDelay = 1 / 30f;
    
    [SerializeField] private DOTweenAnimation m_DisabledClickFeedback;
    
    [SerializeField] private ButtonClickedEvent m_OnClick = new();
    [SerializeField] private ButtonClickedEvent m_OnClickDisabled = new();
    
    public ButtonClickedEvent onClick
    {
        get => m_OnClick;
        set => m_OnClick = value;
    }
    
    public ButtonClickedEvent onClickDisabled
    {
        get => m_OnClickDisabled;
        set => m_OnClickDisabled = value;
    }

    private double m_ClickAvailableAt;
    public double clickAvailableAt
    {
        get => buttonGroup != null ? buttonGroup.clickAvailableAt : m_ClickAvailableAt;
        set
        {
            if (buttonGroup != null)
                buttonGroup.clickAvailableAt = value;
            else
                m_ClickAvailableAt = Math.Max(m_ClickAvailableAt, value + m_ClickDelay);
        }
    }

    protected virtual void Press()
    {
        if (!IsActive())
            return;
        
        GameManager.Get().PlayClick();
        
        if (IsInteractable())
        {
            var time = TimeSystem.time;
            if (clickAvailableAt > time)
                return;
            clickAvailableAt = time;
            
            UISystemProfilerApi.AddMarker("ButtonEx.onClick", this);
            m_OnClick?.Invoke();
        }
        else
        {
            UISystemProfilerApi.AddMarker("ButtonEx.onClickDisabled", this);
            m_DisabledClickFeedback?.DORestart();
            m_OnClickDisabled?.Invoke();

            HandleNotInteractable();
        }
    }
    
    public virtual void OnPointerClick(PointerEventData eventData)
    {
        if (eventData.button != PointerEventData.InputButton.Left)
            return;

        Press();
    }

    public virtual void OnSubmit(BaseEventData eventData)
    {
        Press();
        
        if (!IsActive() || !IsInteractable())
            return;
        
        DoStateTransition(SelectionState.Pressed, false);
    }
    
    private string m_NotInteractableMessage;
    private Action m_NotInteractableAction;

    public void Apply(ButtonInteractor interactObject)
    {
        m_NotInteractableMessage = interactObject.notInteractableMessage;
        m_NotInteractableAction = interactObject.notInteractableAction;
    }
    
    private void HandleNotInteractable()
    {
        if (!string.IsNullOrEmpty(m_NotInteractableMessage))
            m_NotInteractableMessage.ToToastFromRaw();

        m_NotInteractableAction?.Invoke();
    }
    
    public virtual CustomButton SetOnClick(UnityAction action)
    {
        onClick.RemoveAllListeners();
        onClick.AddListener(action);
        return this;
    }
    
    public virtual CustomButton SetOnClickAsync(Func<UniTask> func)
    {
        onClick.RemoveAllListeners();
        onClick.AddListener(() => func().Forget());
        return this;
    }
    
    public virtual CustomButton SetOnClickDisabled(UnityAction action)
    {
        onClickDisabled.RemoveAllListeners();
        onClickDisabled.AddListener(action);
        return this;
    }

    public void InvokeClick()
    {
        Press();
    }
    
#if UNITY_EDITOR
    
    [MenuItem("GameObject/UI/CustomButton", false, 2032)]
    public static void AddButton(MenuCommand menuCommand)
    {
        GameObject go;
        using (new Utility.FactorySwapToEditor())
        {
            go = TMP_DefaultControls.CreateButton(default);
            DestroyImmediate(go.GetComponent<Button>());
        }
        Utility.PlaceUIElementRoot(go, menuCommand);
    }
    
#endif
}

public static class ButtonExHelper
{
    public static UniTask OnClickAsync(this CustomButton button)
    {
        return new AsyncUnityEventHandler(button.onClick, button.GetCancellationTokenOnDestroy(), true).OnInvokeAsync();
    }

    public static UniTask OnClickAsync(this CustomButton button, CancellationToken cancellationToken)
    {
        return new AsyncUnityEventHandler(button.onClick, cancellationToken, true).OnInvokeAsync();
    }
}
