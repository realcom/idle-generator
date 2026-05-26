using System;
using System.Collections.Generic;
using Components.UI.Selectable;
using UnityEngine;
using UnityEngine.EventSystems;

#if UNITY_EDITOR
#endif

namespace Components.UI
{
    [AddComponentMenu("UI/Selectable", 35)]
    [ExecuteAlways]
    [SelectionBase]
    /// <summary>
    /// Simple selectable object - derived from to create a selectable control.
    /// </summary>
    public class CustomSelectable
        :
        UIBehaviour,
        IMoveHandler,
        IPointerDownHandler, IPointerUpHandler,
        IPointerEnterHandler, IPointerExitHandler,
        ISelectHandler, IDeselectHandler
    {
        protected static CustomSelectable[] s_Selectables = new CustomSelectable[10];
        protected static int s_SelectableCount = 0;
        private bool m_EnableCalled = false;

        /// <summary>
        /// Copy of the array of all the selectable objects currently active in the scene.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI; // required when using UI elements in scripts
        ///
        /// public class Example : MonoBehaviour
        /// {
        ///     //Displays the names of all selectable elements in the scene
        ///     public void GetNames()
        ///     {
        ///         foreach (Selectable selectableUI in Selectable.allSelectablesArray)
        ///         {
        ///             Debug.Log(selectableUI.name);
        ///         }
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public static CustomSelectable[] allSelectablesArray
        {
            get
            {
                CustomSelectable[] temp = new CustomSelectable[s_SelectableCount];
                Array.Copy(s_Selectables, temp, s_SelectableCount);
                return temp;
            }
        }

        /// <summary>
        /// How many selectable elements are currently active.
        /// </summary>
        public static int allSelectableCount { get { return s_SelectableCount; } }

        /// <summary>
        /// A List instance of the allSelectablesArray to maintain API compatibility.
        /// </summary>

        [Obsolete("Replaced with allSelectablesArray to have better performance when disabling a element", false)]
        public static List<CustomSelectable> allSelectables
        {
            get
            {
                return new List<CustomSelectable>(allSelectablesArray);
            }
        }


        /// <summary>
        /// Non allocating version for getting the all selectables.
        /// If selectables.Length is less then s_SelectableCount only selectables.Length elments will be copied which
        /// could result in a incomplete list of elements.
        /// </summary>
        /// <param name="selectables">The array to be filled with current selectable objects</param>
        /// <returns>The number of element copied.</returns>
        public static int AllSelectablesNoAlloc(CustomSelectable[] selectables)
        {
            int copyCount = selectables.Length < s_SelectableCount ? selectables.Length : s_SelectableCount;

            Array.Copy(s_Selectables, selectables, copyCount);

            return copyCount;
        }
        
        [Tooltip("Can the Selectable be interacted with?")]
        [SerializeField]
        private bool m_Interactable = true;

        [SerializeField] 
        private bool m_CanTransitionToSelf = true;

        [SerializeReference] 
        private List<ITransition> m_Transitions = new();
        public IList<ITransition> transitions => m_Transitions;

        // Navigation information.
        [SerializeField]
        private CustomNavigation m_Navigation = CustomNavigation.defaultNavigation;
        
        private bool m_GroupsAllowInteraction = true;
        protected int m_CurrentIndex = -1;

        /// <summary>
        /// The Navigation setting for this selectable object.
        /// </summary>
        public CustomNavigation        navigation        { get { return m_Navigation; } set { if (SetPropertyUtility.SetStruct(ref m_Navigation, value))        OnSetProperty(); } }

        /// <summary>
        /// Is this object interactable.
        /// </summary>
        public bool interactable
        {
            get { return m_Interactable; }
            set
            {
                if (SetPropertyUtility.SetStruct(ref m_Interactable, value))
                {
                    if (!m_Interactable && EventSystem.current != null && EventSystem.current.currentSelectedGameObject == gameObject)
                        EventSystem.current.SetSelectedGameObject(null);
                    OnSetProperty();
                }
            }
        }

        private bool             isPointerInside   { get; set; }
        private bool             isPointerDown     { get; set; }
        private bool             hasSelection      { get; set; }

        protected CustomSelectable()
        {}

        private readonly List<CanvasGroup> m_CanvasGroupCache = new List<CanvasGroup>();
        protected override void OnCanvasGroupChanged()
        {
            var parentGroupAllowsInteraction = ParentGroupAllowsInteraction();

            if (parentGroupAllowsInteraction != m_GroupsAllowInteraction)
            {
                m_GroupsAllowInteraction = parentGroupAllowsInteraction;
                OnSetProperty();
            }
        }

        bool ParentGroupAllowsInteraction()
        {
            Transform t = transform;
            while (t != null)
            {
                t.GetComponents(m_CanvasGroupCache);
                for (var i = 0; i < m_CanvasGroupCache.Count; i++)
                {
                    if (m_CanvasGroupCache[i].enabled && !m_CanvasGroupCache[i].interactable)
                        return false;

                    if (m_CanvasGroupCache[i].ignoreParentGroups)
                        return true;
                }

                t = t.parent;
            }

            return true;
        }

        /// <summary>
        /// Is the object interactable.
        /// </summary>
        public virtual bool IsInteractable()
        {
            return m_GroupsAllowInteraction && m_Interactable;
        }

        // Call from unity if animation properties have changed
        protected override void OnDidApplyAnimationProperties()
        {
            OnSetProperty();
        }

        protected override void Start()
        {
            base.Start();
            
            if (m_Transitions != null)
            {
                foreach (var transition in m_Transitions)
                {
                    transition?.Start();
                }   
            }
        }

        // Select on enable and add to the list.
        protected override void OnEnable()
        {
            //Check to avoid multiple OnEnable() calls for each selectable
            if (m_EnableCalled)
                return;

            base.OnEnable();

            if (s_SelectableCount == s_Selectables.Length)
            {
                CustomSelectable[] temp = new CustomSelectable[s_Selectables.Length * 2];
                Array.Copy(s_Selectables, temp, s_Selectables.Length);
                s_Selectables = temp;
            }

            if (EventSystem.current && EventSystem.current.currentSelectedGameObject == gameObject)
            {
                hasSelection = true;
            }

            m_CurrentIndex = s_SelectableCount;
            s_Selectables[m_CurrentIndex] = this;
            s_SelectableCount++;
            isPointerDown = false;
            m_GroupsAllowInteraction = ParentGroupAllowsInteraction();
            DoStateTransition(currentSelectionState, true);

            m_EnableCalled = true;
        }

        protected override void OnTransformParentChanged()
        {
            base.OnTransformParentChanged();

            // If our parenting changes figure out if we are under a new CanvasGroup.
            OnCanvasGroupChanged();
        }

        private void OnSetProperty()
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
                DoStateTransition(currentSelectionState, true);
            else
#endif
            DoStateTransition(currentSelectionState, false);
        }

        // Remove from the list.
        protected override void OnDisable()
        {
            //Check to avoid multiple OnDisable() calls for each selectable
            if (!m_EnableCalled)
                return;

            s_SelectableCount--;

            // Update the last elements index to be this index
            s_Selectables[s_SelectableCount].m_CurrentIndex = m_CurrentIndex;

            // Swap the last element and this element
            s_Selectables[m_CurrentIndex] = s_Selectables[s_SelectableCount];

            // null out last element.
            s_Selectables[s_SelectableCount] = null;

            InstantClearState();
            base.OnDisable();

            m_EnableCalled = false;
        }

        void OnApplicationFocus(bool hasFocus)
        {
            if (!hasFocus && IsPressed())
            {
                InstantClearState();
            }
        }

#if UNITY_EDITOR
        protected override void OnValidate()
        {
            base.OnValidate();

            if (m_Transitions != null)
            {
                foreach (var transition in m_Transitions)
                {
                    transition?.OnValidate(this);
                }   
            }

            // OnValidate can be called before OnEnable, this makes it unsafe to access other components
            // since they might not have been initialized yet.
            // OnSetProperty potentially access Animator or Graphics. (case 618186)
            if (isActiveAndEnabled)
            {
                if (!interactable && EventSystem.current != null && EventSystem.current.currentSelectedGameObject == gameObject)
                    EventSystem.current.SetSelectedGameObject(null);

                ClearTransitions();
                // And now go to the right state.
                DoStateTransition(currentSelectionState, true);
            }
        }

#endif // if UNITY_EDITOR

        protected SelectionState currentSelectionState
        {
            get
            {
                if (!IsInteractable())
                    return SelectionState.Disabled;
                if (isPointerDown)
                    return SelectionState.Pressed;
                if (hasSelection)
                    return SelectionState.Selected;
                if (isPointerInside)
                    return SelectionState.Highlighted;
                return SelectionState.Normal;
            }
        }

        /// <summary>
        /// Clear any internal state from the Selectable (used when disabling).
        /// </summary>
        protected virtual void InstantClearState()
        {
            isPointerInside = false;
            isPointerDown = false;
            hasSelection = false;
            
            ClearTransitions();
        }
        
        protected virtual void ClearTransitions()
        {
            foreach (var transition in m_Transitions)
            {
                transition?.DoTransitionInstantly(SelectionState.Normal);
            }
        }
        
        private SelectionState m_PrevSelectionState = SelectionState.Normal;

        /// <summary>
        /// Transition the Selectable to the entered state.
        /// </summary>
        /// <param name="state">State to transition to</param>
        /// <param name="instant">Should the transition occur instantly.</param>
        protected virtual void DoStateTransition(SelectionState state, bool instant)
        {
            if (!gameObject.activeInHierarchy)
                return;

            if (instant)
            {
                foreach (var transition in m_Transitions)
                {
                    transition?.DoTransitionInstantly(state);
                }
            }
            else if (m_CanTransitionToSelf || m_PrevSelectionState != state)
            {
                foreach (var transition in m_Transitions)
                {
                    transition?.DoTransition(state);
                }
            }
            
            m_PrevSelectionState = state;
        }

        /// <summary>
        /// An enumeration of selected states of objects
        /// </summary>
        public enum SelectionState
        {
            /// <summary>
            /// The UI object can be selected.
            /// </summary>
            Normal,

            /// <summary>
            /// The UI object is highlighted.
            /// </summary>
            Highlighted,

            /// <summary>
            /// The UI object is pressed.
            /// </summary>
            Pressed,

            /// <summary>
            /// The UI object is selected
            /// </summary>
            Selected,

            /// <summary>
            /// The UI object cannot be selected.
            /// </summary>
            Disabled,
        }

        // Selection logic

        /// <summary>
        /// Finds the selectable object next to this one.
        /// </summary>
        /// <remarks>
        /// The direction is determined by a Vector3 variable.
        /// </remarks>
        public CustomSelectable FindSelectable(Vector3 dir)
        {
            dir = dir.normalized;
            Vector3 localDir = Quaternion.Inverse(transform.rotation) * dir;
            Vector3 pos = transform.TransformPoint(GetPointOnRectEdge(transform as RectTransform, localDir));
            float maxScore = Mathf.NegativeInfinity;
            float maxFurthestScore = Mathf.NegativeInfinity;
            float score = 0;

            bool wantsWrapAround = navigation.wrapAround && (m_Navigation.mode == CustomNavigation.Mode.Vertical || m_Navigation.mode == CustomNavigation.Mode.Horizontal);

            CustomSelectable bestPick = null;
            CustomSelectable bestFurthestPick = null;

            for (int i = 0; i < s_SelectableCount; ++i)
            {
                CustomSelectable sel = s_Selectables[i];

                if (sel == this)
                    continue;

                if (!sel.IsInteractable() || sel.navigation.mode == CustomNavigation.Mode.None)
                    continue;

#if UNITY_EDITOR
                // Apart from runtime use, FindSelectable is used by custom editors to
                // draw arrows between different selectables. For scene view cameras,
                // only selectables in the same stage should be considered.
                if (Camera.current != null && !UnityEditor.SceneManagement.StageUtility.IsGameObjectRenderedByCamera(sel.gameObject, Camera.current))
                    continue;
#endif

                var selRect = sel.transform as RectTransform;
                Vector3 selCenter = selRect != null ? (Vector3)selRect.rect.center : Vector3.zero;
                Vector3 myVector = sel.transform.TransformPoint(selCenter) - pos;

                // Value that is the distance out along the direction.
                float dot = Vector3.Dot(dir, myVector);

                // If element is in wrong direction and we have wrapAround enabled check and cache it if furthest away.
                if (wantsWrapAround && dot < 0)
                {
                    score = -dot * myVector.sqrMagnitude;

                    if (score > maxFurthestScore)
                    {
                        maxFurthestScore = score;
                        bestFurthestPick = sel;
                    }

                    continue;
                }

                // Skip elements that are in the wrong direction or which have zero distance.
                // This also ensures that the scoring formula below will not have a division by zero error.
                if (dot <= 0)
                    continue;

                // This scoring function has two priorities:
                // - Score higher for positions that are closer.
                // - Score higher for positions that are located in the right direction.
                // This scoring function combines both of these criteria.
                // It can be seen as this:
                //   Dot (dir, myVector.normalized) / myVector.magnitude
                // The first part equals 1 if the direction of myVector is the same as dir, and 0 if it's orthogonal.
                // The second part scores lower the greater the distance is by dividing by the distance.
                // The formula below is equivalent but more optimized.
                //
                // If a given score is chosen, the positions that evaluate to that score will form a circle
                // that touches pos and whose center is located along dir. A way to visualize the resulting functionality is this:
                // From the position pos, blow up a circular balloon so it grows in the direction of dir.
                // The first Selectable whose center the circular balloon touches is the one that's chosen.
                score = dot / myVector.sqrMagnitude;

                if (score > maxScore)
                {
                    maxScore = score;
                    bestPick = sel;
                }
            }

            if (wantsWrapAround && null == bestPick) return bestFurthestPick;

            return bestPick;
        }

        private static Vector3 GetPointOnRectEdge(RectTransform rect, Vector2 dir)
        {
            if (rect == null)
                return Vector3.zero;
            if (dir != Vector2.zero)
                dir /= Mathf.Max(Mathf.Abs(dir.x), Mathf.Abs(dir.y));
            dir = rect.rect.center + Vector2.Scale(rect.rect.size, dir * 0.5f);
            return dir;
        }

        // Convenience function -- change the selection to the specified object if it's not null and happens to be active.
        void Navigate(AxisEventData eventData, CustomSelectable sel)
        {
            if (sel != null && sel.IsActive())
                eventData.selectedObject = sel.gameObject;
        }
        
        public virtual CustomSelectable FindSelectableOnLeft()
        {
            if (m_Navigation.mode == CustomNavigation.Mode.Explicit)
            {
                return m_Navigation.selectOnLeft;
            }
            if ((m_Navigation.mode & CustomNavigation.Mode.Horizontal) != 0)
            {
                return FindSelectable(transform.rotation * Vector3.left);
            }
            return null;
        }
        
        public virtual CustomSelectable FindSelectableOnRight()
        {
            if (m_Navigation.mode == CustomNavigation.Mode.Explicit)
            {
                return m_Navigation.selectOnRight;
            }
            if ((m_Navigation.mode & CustomNavigation.Mode.Horizontal) != 0)
            {
                return FindSelectable(transform.rotation * Vector3.right);
            }
            return null;
        }
        
        public virtual CustomSelectable FindSelectableOnUp()
        {
            if (m_Navigation.mode == CustomNavigation.Mode.Explicit)
            {
                return m_Navigation.selectOnUp;
            }
            if ((m_Navigation.mode & CustomNavigation.Mode.Vertical) != 0)
            {
                return FindSelectable(transform.rotation * Vector3.up);
            }
            return null;
        }
        
        public virtual CustomSelectable FindSelectableOnDown()
        {
            if (m_Navigation.mode == CustomNavigation.Mode.Explicit)
            {
                return m_Navigation.selectOnDown;
            }
            if ((m_Navigation.mode & CustomNavigation.Mode.Vertical) != 0)
            {
                return FindSelectable(transform.rotation * Vector3.down);
            }
            return null;
        }
        
        public virtual void OnMove(AxisEventData eventData)
        {
            switch (eventData.moveDir)
            {
                case MoveDirection.Right:
                    Navigate(eventData, FindSelectableOnRight());
                    break;

                case MoveDirection.Up:
                    Navigate(eventData, FindSelectableOnUp());
                    break;

                case MoveDirection.Left:
                    Navigate(eventData, FindSelectableOnLeft());
                    break;

                case MoveDirection.Down:
                    Navigate(eventData, FindSelectableOnDown());
                    break;
            }
        }
        
        protected bool IsHighlighted()
        {
            if (!IsActive() || !IsInteractable())
                return false;
            return isPointerInside && !isPointerDown && !hasSelection;
        }

        /// <summary>
        /// Whether the current selectable is being pressed.
        /// </summary>
        protected bool IsPressed()
        {
            if (!IsActive() || !IsInteractable())
                return false;
            return isPointerDown;
        }

        // Change the button to the correct state
        private void EvaluateAndTransitionToSelectionState()
        {
            if (!IsActive() || !IsInteractable())
                return;

            DoStateTransition(currentSelectionState, false);
        }
        
        public virtual void OnPointerDown(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
                return;

            // Selection tracking
            if (IsInteractable() && navigation.mode != CustomNavigation.Mode.None && EventSystem.current != null)
                EventSystem.current.SetSelectedGameObject(gameObject, eventData);

            isPointerDown = true;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void OnPointerUp(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
                return;

            isPointerDown = false;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void OnPointerEnter(PointerEventData eventData)
        {
            isPointerInside = true;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void OnPointerExit(PointerEventData eventData)
        {
            isPointerInside = false;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void OnSelect(BaseEventData eventData)
        {
            hasSelection = true;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void OnDeselect(BaseEventData eventData)
        {
            hasSelection = false;
            EvaluateAndTransitionToSelectionState();
        }
        
        public virtual void Select()
        {
            if (EventSystem.current == null || EventSystem.current.alreadySelecting)
                return;

            EventSystem.current.SetSelectedGameObject(gameObject);
        }
    }
}
