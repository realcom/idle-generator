using System;
using System.Collections;
using System.Collections.Generic;
using Components.UI;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Components.UI.Toggle
{
    [RequireComponent(typeof(RectTransform))]
    public class CustomToggle : CustomButton, IPointerClickHandler, ISubmitHandler, ICanvasElement
    {
        /// <summary>
        /// UnityEvent callback for when a toggle is toggled.
        /// </summary>
        [Serializable]
        public class ToggleEvent : UnityEvent<bool>
        {
        }
        
        [SerializeReference]
        private List<ITransition> m_ToggleTransitions = new();
        public IList<ITransition> toggleTransitions => m_ToggleTransitions;

        [SerializeField, HideInInspector] 
        private CustomToggleGroup m_Group;

        /// <summary>
        /// Group the toggle belongs to.
        /// </summary>
        public CustomToggleGroup group
        {
            get => m_Group;
            set
            {
                SetToggleGroup(value, true);
                DoTransition(true);
            }
        }

        [HideInInspector] 
        public ToggleEvent onValueChanged = new ToggleEvent();
        
        public delegate void ToggleEventDelegate(bool isOn);

        public ToggleEventDelegate onChanged;

        // Whether the toggle is on
        [Tooltip("Is the toggle currently on or off?")] 
        [SerializeField, HideInInspector]
        private bool m_IsOn;

        public bool isOn
        {
            get => m_IsOn;
            set => Set(value);
        }


#if UNITY_EDITOR
        protected override void OnValidate()
        {
            base.OnValidate();

            if (m_ToggleTransitions != null)
            {
                foreach (var transition in m_ToggleTransitions)
                {
                    transition.OnValidate(this);
                }
            }
            
            if (!UnityEditor.PrefabUtility.IsPartOfPrefabAsset(this) && !Application.isPlaying)
                CanvasUpdateRegistry.RegisterCanvasElementForLayoutRebuild(this);
        }

#endif // if UNITY_EDITOR

        public virtual void Rebuild(CanvasUpdate executing)
        {
#if UNITY_EDITOR
            if (executing == CanvasUpdate.Prelayout)
            {
                onValueChanged.Invoke(m_IsOn);
                onChanged?.Invoke(m_IsOn);
            }
#endif
        }

        public void LayoutComplete()
        {
        }

        public void GraphicUpdateComplete()
        {
        }

        protected override void OnDestroy()
        {
            if (m_Group != null)
                m_Group.EnsureValidState();
            base.OnDestroy();
        }

        protected override void OnEnable()
        {
            SetToggleGroup(m_Group, false);
            base.OnEnable();
        }

        protected override void OnDisable()
        {
            SetToggleGroup(null, false);
            base.OnDisable();
        }

        protected override void OnDidApplyAnimationProperties()
        {
            //If, change isOn property, then we need to update graphic.
            
            base.OnDidApplyAnimationProperties();
        }

        private void SetToggleGroup(CustomToggleGroup newGroup, bool setMemberValue)
        {
            // Sometimes IsActive returns false in OnDisable so don't check for it.
            // Rather remove the toggle too often than too little.
            if (m_Group != null)
                m_Group.UnregisterToggle(this);

            // At runtime the group variable should be set but not when calling this method from OnEnable or OnDisable.
            // That's why we use the setMemberValue parameter.
            if (setMemberValue)
                m_Group = newGroup;

            // Only register to the new group if this Toggle is active.
            if (newGroup != null && IsActive())
                newGroup.RegisterToggle(this);

            // If we are in a new group, and this toggle is on, notify group.
            // Note: Don't refer to m_Group here as it's not guaranteed to have been set.
            if (newGroup != null && isOn)
                newGroup.NotifyToggleOn(this);
        }

        /// <summary>
        /// Set isOn without invoking onValueChanged callback.
        /// </summary>
        /// <param name="value">New Value for isOn.</param>
        public void SetIsOnWithoutNotify(bool value)
        {
            Set(value, false);
        }

        public void Set(bool value, bool sendCallback = true)
        {
            if (m_IsOn == value)
                return;

            // if we are in a group and set to true, do group logic
            m_IsOn = value;
            if (m_Group != null && m_Group.isActiveAndEnabled && IsActive())
            {
                if (m_IsOn || (!m_Group.AnyTogglesOn() && !m_Group.allowSwitchOff))
                {
                    m_IsOn = true;
                    m_Group.NotifyToggleOn(this, sendCallback);
                }
            }

            // Always send event when toggle is clicked, even if value didn't change
            // due to already active toggle in a toggle group being clicked.
            // Controls like Dropdown rely on this.
            // It's up to the user to ignore a selection being set to the same value it already was, if desired.
            DoTransition(false);
            if (sendCallback)
            {
                UISystemProfilerApi.AddMarker("Toggle.value", this);
                onValueChanged.Invoke(m_IsOn);
                onChanged?.Invoke(m_IsOn);
            }
        }

        protected override void DoStateTransition(SelectionState state, bool instant)
        {
            DoTransition(instant);
            
            base.DoStateTransition(state, instant);
        }

        /// <summary>
        /// Play the appropriate effect.
        /// </summary>
        private void DoTransition(bool instantly)
        {
            if (m_IsOn)
            {
                foreach (var transition in m_ToggleTransitions)
                {
                    if (instantly)
                        transition.DoTransitionInstantlyOn();
                    else
                        transition.DoTransitionOn();
                }
            }
            else
            {
                foreach (var transition in m_ToggleTransitions)
                {
                    if (instantly)
                        transition.DoTransitionInstantlyOff();
                    else
                        transition.DoTransitionOff();
                }
            }
        }

        /// <summary>
        /// Assume the correct visual state.
        /// </summary>
        protected override void Start()
        {
            base.Start();

            if (m_ToggleTransitions != null)
            {
                foreach (var toggleTransition in m_ToggleTransitions)
                {
                    toggleTransition?.Start();
                }
            }
            
            DoTransition(true);
        }

        private void InternalToggle()
        {
            if (!IsActive() || !IsInteractable())
                return;

            isOn = !isOn;
        }

        /// <summary>
        /// React to clicks.
        /// </summary>
        public override void OnPointerClick(PointerEventData eventData)
        {
            base.OnPointerClick(eventData);
            
            if (eventData.button != PointerEventData.InputButton.Left)
                return;

            InternalToggle();
        }

        public override void OnSubmit(BaseEventData eventData)
        {
            base.OnSubmit(eventData);
            
            InternalToggle();
        }
        
    }
}