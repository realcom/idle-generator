using System;
using System.Collections.Generic;
using Components.UI.Toggle;
using DG.Tweening;
using Sirenix.OdinInspector;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

#if UNITY_EDITOR
using UnityEditor.Animations;
#endif

namespace Components.UI.Selectable
{
    [Serializable]
    public struct FlagBlock
    {
        [SerializeField]
        private bool m_Normal;
        
        [SerializeField]
        private bool m_Highlighted;
        
        [SerializeField]
        private bool m_Pressed;
        
        [SerializeField]
        private bool m_Selected;
        
        [SerializeField]
        private bool m_Disabled;
        
        public bool normal => m_Normal;
        public bool highlighted => m_Highlighted;
        public bool pressed => m_Pressed;
        public bool selected => m_Selected;
        public bool disabled => m_Disabled;
        
        public static FlagBlock defaultFlagBlock;
        
        static FlagBlock()
        {
            defaultFlagBlock = new FlagBlock
            {
                m_Normal = true,
                m_Highlighted = true,
                m_Pressed = true,
                m_Selected = true,
                m_Disabled = false
            };
        }
    }
    
    [Serializable]
    public struct AlphaBlock
    {
        [SerializeField]
        private float m_NormalAlpha;
            
        [SerializeField]
        private float m_HighlightedAlpha;
            
        [SerializeField]
        private float m_PressedAlpha;
            
        [SerializeField]
        private float m_SelectedAlpha;
            
        [SerializeField]
        private float m_DisabledAlpha;
            
        public float normalAlpha => m_NormalAlpha;
        public float highlightedAlpha => m_HighlightedAlpha;
        public float pressedAlpha => m_PressedAlpha;
        public float selectedAlpha => m_SelectedAlpha;
        public float disabledAlpha => m_DisabledAlpha;
        
        public static AlphaBlock defaultAlphaBlock;
        
        static AlphaBlock()
        {
            defaultAlphaBlock = new AlphaBlock
            {
                m_NormalAlpha = 1f,
                m_HighlightedAlpha = 1f,
                m_PressedAlpha = 1f,
                m_SelectedAlpha = 1f,
                m_DisabledAlpha = 0.5f
            };
        }
    }
    
    public interface ITransition
    {
        public void Start();
        public void OnValidate(CustomSelectable selectable);
        
        public void DoTransition(CustomSelectable.SelectionState state);

        public void DoTransitionInstantly(CustomSelectable.SelectionState state);   
    }
    
    [Serializable, HideReferenceObjectPicker]
    public abstract class BaseTransition : ITransition
    {
        public abstract void Start();
        public abstract void OnValidate(CustomSelectable selectable);
        public abstract void DoTransition(CustomSelectable.SelectionState state);
        public abstract void DoTransitionInstantly(CustomSelectable.SelectionState state);
    }

    [Serializable]
    public class CanvasGroupTransition : BaseTransition
    {
        [SerializeField] private CanvasGroup m_CanvasGroup;
        
        [SerializeField] private AlphaBlock m_AlphaBlock = AlphaBlock.defaultAlphaBlock;
        [SerializeField] private FlagBlock m_InteractableBlock = FlagBlock.defaultFlagBlock;
        [SerializeField] private FlagBlock m_BlockRaycastBlock = FlagBlock.defaultFlagBlock;
        
        public override void Start()
        {
            
        }

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_CanvasGroup == null)
                m_CanvasGroup = selectable.GetComponent<CanvasGroup>();
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            if (m_CanvasGroup == null)
                return;
            
            m_CanvasGroup.alpha = GetAlpha(state);
            m_CanvasGroup.interactable = GetInteractable(state);
            m_CanvasGroup.blocksRaycasts = GetBlockRaycast(state);   
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransition(state);
        }
        
        private float GetAlpha(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_AlphaBlock.normalAlpha,
                CustomSelectable.SelectionState.Highlighted => m_AlphaBlock.highlightedAlpha,
                CustomSelectable.SelectionState.Pressed => m_AlphaBlock.pressedAlpha,
                CustomSelectable.SelectionState.Selected => m_AlphaBlock.selectedAlpha,
                CustomSelectable.SelectionState.Disabled => m_AlphaBlock.disabledAlpha,
                _ => 1f
            };
        }
        
        private bool GetInteractable(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_InteractableBlock.normal,
                CustomSelectable.SelectionState.Highlighted => m_InteractableBlock.highlighted,
                CustomSelectable.SelectionState.Pressed => m_InteractableBlock.pressed,
                CustomSelectable.SelectionState.Selected => m_InteractableBlock.selected,
                CustomSelectable.SelectionState.Disabled => m_InteractableBlock.disabled,
                _ => true
            };
        }

        private bool GetBlockRaycast(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_BlockRaycastBlock.normal,
                CustomSelectable.SelectionState.Highlighted => m_BlockRaycastBlock.highlighted,
                CustomSelectable.SelectionState.Pressed => m_BlockRaycastBlock.pressed,
                CustomSelectable.SelectionState.Selected => m_BlockRaycastBlock.selected,
                CustomSelectable.SelectionState.Disabled => m_BlockRaycastBlock.disabled,
                _ => true
            };
        }
    }
    
    [Serializable]
    public abstract class GraphicTransition : BaseTransition
    {
        [SerializeField] protected Graphic m_TargetGraphic;

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_TargetGraphic == null)
                m_TargetGraphic = selectable.GetComponent<Graphic>();
        }
    }

    [Serializable]
    public class ColorBlockTransition : GraphicTransition
    {
        [SerializeField] protected ColorBlock m_Colors = ColorBlock.defaultColorBlock;

        public override void Start()
        {
            
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            CrossFadeColor(GetColor(state), m_Colors.fadeDuration, true, true);
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            CrossFadeColor(GetColor(state), 0f, true, true);
        }

        protected virtual Color GetColor(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_Colors.normalColor,
                CustomSelectable.SelectionState.Highlighted => m_Colors.highlightedColor,
                CustomSelectable.SelectionState.Pressed => m_Colors.pressedColor,
                CustomSelectable.SelectionState.Selected => m_Colors.selectedColor,
                CustomSelectable.SelectionState.Disabled => m_Colors.disabledColor,
                _ => Color.black
            } * m_Colors.colorMultiplier;
        }
        
        protected virtual void CrossFadeColor(Color targetColor, float duration, bool ignoreTimeScale, bool useAlpha)
        {
            if (m_TargetGraphic == null)
                return;
            
            m_TargetGraphic.CrossFadeColor(targetColor, duration, ignoreTimeScale, useAlpha);
        }
        
    }
    
    [Serializable]
    public class DisabledSpriteSwapTransition : GraphicTransition
    {
        [SerializeField] private Sprite m_DisabledSprite;
        
        public Sprite disabledSprite
        {
            get => m_DisabledSprite;
            set => m_DisabledSprite = value;
        }
        
        protected Image m_Image 
        {
            get => m_TargetGraphic as Image;
            set => m_TargetGraphic = value;
        }

        public override void Start()
        {
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            if (m_Image == null)
                return;

            m_Image.overrideSprite = state switch
            {
                CustomSelectable.SelectionState.Disabled => m_DisabledSprite,
                CustomSelectable.SelectionState.Normal => m_Image.overrideSprite == m_DisabledSprite ? null : m_Image.overrideSprite,
                _ => m_Image.overrideSprite
            };
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransition(state);
        }
    }
    
    [Serializable]
    public class SpriteSwapTransition : GraphicTransition
    {
        [SerializeField] protected SpriteState m_SpriteState;

        public SpriteState spriteState
        {
            get => m_SpriteState; 
            set => m_SpriteState = value;
        }
        
        protected Image m_Image 
        {
            get => m_TargetGraphic as Image;
            set => m_TargetGraphic = value;
        }

        public override void Start()
        {
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            if (m_Image == null)
                return;
            
            m_Image.overrideSprite = state switch
            {
                CustomSelectable.SelectionState.Normal => null,
                CustomSelectable.SelectionState.Highlighted => m_SpriteState.highlightedSprite,
                CustomSelectable.SelectionState.Pressed => m_SpriteState.pressedSprite,
                CustomSelectable.SelectionState.Selected => m_SpriteState.selectedSprite,
                CustomSelectable.SelectionState.Disabled => m_SpriteState.disabledSprite,
                _ => m_Image.sprite
            };
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransition(state);
        }
        
    }
    
    [Serializable]
    public class AnimationTransition : BaseTransition
    {
        [SerializeField, HorizontalGroup("Animation")] protected Animator m_Animator;
        [SerializeField] protected AnimationTriggers m_AnimationTriggers;

#if UNITY_EDITOR
              [HorizontalGroup("Animation", width: 0.1f), ShowIf("@m_Animator == null"), Button("Gen"), Tooltip("Auto generate animation controller with triggers")]
        public void GenerateAnimation()
        {
            GenerateSelectableAnimatorController(m_AnimationTriggers);
        }
        
        private static AnimatorController GenerateSelectableAnimatorController(AnimationTriggers animationTriggers)
        {
            // Where should we create the controller?
            var path = GetSaveControllerPath();
            if (string.IsNullOrEmpty(path))
                return null;

            // figure out clip names
            var normalName = string.IsNullOrEmpty(animationTriggers.normalTrigger) ? "Normal" : animationTriggers.normalTrigger;
            var highlightedName = string.IsNullOrEmpty(animationTriggers.highlightedTrigger) ? "Highlighted" : animationTriggers.highlightedTrigger;
            var pressedName = string.IsNullOrEmpty(animationTriggers.pressedTrigger) ? "Pressed" : animationTriggers.pressedTrigger;
            var selectedName = string.IsNullOrEmpty(animationTriggers.selectedTrigger) ? "Selected" : animationTriggers.selectedTrigger;
            var disabledName = string.IsNullOrEmpty(animationTriggers.disabledTrigger) ? "Disabled" : animationTriggers.disabledTrigger;

            // Create controller and hook up transitions.
            var controller = AnimatorController.CreateAnimatorControllerAtPath(path);
            GenerateTriggerableTransition(normalName, controller);
            GenerateTriggerableTransition(highlightedName, controller);
            GenerateTriggerableTransition(pressedName, controller);
            GenerateTriggerableTransition(selectedName, controller);
            GenerateTriggerableTransition(disabledName, controller);

            AssetDatabase.ImportAsset(path);

            return controller;
        }
        
        private static string GetSaveControllerPath()
        {
            var message = $"Create a new animator:";
            return EditorUtility.SaveFilePanelInProject("New Animation Controller", "Animation", "controller", message);
        }
        
        private static AnimationClip GenerateTriggerableTransition(string name, AnimatorController controller)
        {
            // Create the clip
            var clip = AnimatorController.AllocateAnimatorClip(name);
            AssetDatabase.AddObjectToAsset(clip, controller);

            // Create a state in the animatior controller for this clip
            var state = controller.AddMotion(clip);

            // Add a transition property
            controller.AddParameter(name, AnimatorControllerParameterType.Trigger);

            // Add an any state transition
            var stateMachine = controller.layers[0].stateMachine;
            var transition = stateMachine.AddAnyStateTransition(state);
            transition.AddCondition(AnimatorConditionMode.If, 0, name);
            return clip;
        }  
#endif

        public override void Start()
        {
            
        }

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_Animator == null)
                m_Animator = selectable.GetComponent<Animator>();
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            if (m_Animator == null || !m_Animator.isActiveAndEnabled || !m_Animator.hasBoundPlayables)
                return;
            
            var trigger = GetTrigger(state);
            if (string.IsNullOrEmpty(trigger))
                return;
            
            m_Animator.ResetTrigger(m_AnimationTriggers.normalTrigger);
            m_Animator.ResetTrigger(m_AnimationTriggers.highlightedTrigger);
            m_Animator.ResetTrigger(m_AnimationTriggers.pressedTrigger);
            m_Animator.ResetTrigger(m_AnimationTriggers.selectedTrigger);
            m_Animator.ResetTrigger(m_AnimationTriggers.disabledTrigger);
            
            m_Animator.SetTrigger(trigger);
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransition(state);
        }

        protected virtual string GetTrigger(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_AnimationTriggers.normalTrigger,
                CustomSelectable.SelectionState.Highlighted => m_AnimationTriggers.highlightedTrigger,
                CustomSelectable.SelectionState.Pressed => m_AnimationTriggers.pressedTrigger,
                CustomSelectable.SelectionState.Selected => m_AnimationTriggers.selectedTrigger,
                CustomSelectable.SelectionState.Disabled => m_AnimationTriggers.disabledTrigger,
                _ => string.Empty
            };
        }
    }
    
    [Serializable]
    public abstract class TransformTransition : BaseTransition
    {
        [SerializeField] protected Transform m_Transform;

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_Transform == null)
            {
                m_Transform = selectable.transform;
            }
        }
    }
    
    [Serializable]
    public abstract class RectTransformTransition : TransformTransition
    {
        protected RectTransform m_RectTransform => m_Transform as RectTransform;
    }

    [Serializable]
    public class TransformScaleTransition : RectTransformTransition
    {
        [Serializable]
        public struct ScaleBlock
        {
            [SerializeField]
            private bool m_UseScaleV3;
            
            [SerializeField, ShowIf("m_UseScaleV3")]
            private Vector3 m_NormalScaleVector;
            
            [SerializeField, HideIf("m_UseScaleV3")]
            private float m_NormalScale;
            
            [SerializeField, ShowIf("m_UseScaleV3")]
            private Vector3 m_HighlightedScaleVector;
            
            [SerializeField, HideIf("m_UseScaleV3")]    
            private float m_HighlightedScale;
            
            [SerializeField, ShowIf("m_UseScaleV3")]
            private Vector3 m_PressedScaleVector;
            
            [SerializeField, HideIf("m_UseScaleV3")]
            private float m_PressedScale;
            
            [SerializeField, ShowIf("m_UseScaleV3")]
            private Vector3 m_SelectedScaleVector;
            
            [SerializeField, HideIf("m_UseScaleV3")]
            private float m_SelectedScale;
            
            [SerializeField, ShowIf("m_UseScaleV3")]
            private Vector3 m_DisabledScaleVector;
            
            [SerializeField, HideIf("m_UseScaleV3")]
            private float m_DisabledScale;
            
            public Vector3 normalScale => m_UseScaleV3 ? m_NormalScaleVector : Vector3.one * m_NormalScale;
            public Vector3 highlightedScale => m_UseScaleV3 ? m_HighlightedScaleVector : Vector3.one * m_HighlightedScale;
            public Vector3 pressedScale => m_UseScaleV3 ? m_PressedScaleVector : Vector3.one * m_PressedScale;
            public Vector3 selectedScale => m_UseScaleV3 ? m_SelectedScaleVector : Vector3.one * m_SelectedScale;
            public Vector3 disabledScale => m_UseScaleV3 ? m_DisabledScaleVector : Vector3.one * m_DisabledScale;

            public static ScaleBlock defaultScaleBlock;
            
            static ScaleBlock()
            {
                defaultScaleBlock = new ScaleBlock
                {
                    m_UseScaleV3 = false,
                    m_NormalScaleVector = Vector3.one,
                    m_NormalScale = 1f,
                    m_HighlightedScaleVector = new Vector3(1.05f, 1.05f, 1.05f),
                    m_HighlightedScale = 1.05f,
                    m_PressedScaleVector = new Vector3(0.9f, 0.9f, 0.9f),
                    m_PressedScale = 0.9f,
                    m_SelectedScaleVector = Vector3.one,
                    m_SelectedScale = 1f,
                    m_DisabledScaleVector = Vector3.one,
                    m_DisabledScale = 1f
                };
            }
            
        }
        
        [SerializeField]
        private ScaleBlock m_ScaleBlock = ScaleBlock.defaultScaleBlock;
        
        [SerializeField, HideInInspector]
        private Vector3 m_DefaultScale = Vector3.one;

        public override void Start()
        {
            
        }

        public override void OnValidate(CustomSelectable selectable)
        {
            base.OnValidate(selectable);

            if (m_RectTransform != null)
                m_DefaultScale = m_RectTransform.localScale;
        }

        protected Tween m_Tween = null;

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            DoTransformScale(GetScale(state));
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransformScale(GetScale(state), true);
        }

        private void DoTransformScale(Vector3 scale, bool instantly = false)
        {
            scale = Vector3.Scale(scale, m_DefaultScale);
            
            m_Tween?.Kill(true);
            
            if (scale == m_Transform.localScale)
                return;
            
            if (instantly)
                m_Transform.localScale = scale;
            else
                m_Tween = m_Transform.DOScale(scale, 0.1f);
        }
        
        private Vector3 GetScale(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_ScaleBlock.normalScale,
                CustomSelectable.SelectionState.Highlighted => m_ScaleBlock.highlightedScale,
                CustomSelectable.SelectionState.Pressed => m_ScaleBlock.pressedScale,
                CustomSelectable.SelectionState.Selected => m_ScaleBlock.selectedScale,
                CustomSelectable.SelectionState.Disabled => m_ScaleBlock.disabledScale,
                _ => Vector3.one
            };
        }
        
    }
    
    [Serializable]
    public class TransformLocalPositionTransition : RectTransformTransition
    {
        [Serializable]
        public struct PositionBlock
        {
            [SerializeField]
            private Vector2 m_NormalPosition;
            
            [SerializeField]
            private Vector2 m_HighlightedPosition;
            
            [SerializeField]
            private Vector2 m_PressedPosition;
            
            [SerializeField]
            private Vector2 m_SelectedPosition;
            
            [SerializeField]
            private Vector2 m_DisabledPosition;
            
            public Vector2 normalPosition => m_NormalPosition;
            public Vector2 highlightedPosition => m_HighlightedPosition;
            public Vector2 pressedPosition => m_PressedPosition;
            public Vector2 selectedPosition => m_SelectedPosition;
            public Vector2 disabledPosition => m_DisabledPosition;

            public static PositionBlock DefaultPositionBlock;
            
            static PositionBlock()
            {
                DefaultPositionBlock = new PositionBlock
                {
                    m_NormalPosition = Vector2.zero,
                    m_HighlightedPosition = Vector2.zero,
                    m_PressedPosition = Vector2.zero,
                    m_SelectedPosition = Vector2.zero,
                    m_DisabledPosition = Vector2.zero
                };
            }
            
        }
        
        [SerializeField]
        private PositionBlock m_PositionBlock = PositionBlock.DefaultPositionBlock;
        
        public override void Start()
        {
            
        }
        
        protected Tween m_Tween = null;

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            DoTransformPosition(GetLocalPosition(state));
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            DoTransformPosition(GetLocalPosition(state), true);
        }

        private void DoTransformPosition(Vector2 position, bool instantly = false)
        {
            m_Tween?.Kill(true);

            if (position == m_RectTransform.anchoredPosition)
                return;
            
            if (instantly)
                m_RectTransform.anchoredPosition = position;
            else
                m_Tween = m_RectTransform.DOAnchorPos(position, 0.1f);
        }
        
        private Vector3 GetLocalPosition(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_PositionBlock.normalPosition,
                CustomSelectable.SelectionState.Highlighted => m_PositionBlock.highlightedPosition,
                CustomSelectable.SelectionState.Pressed => m_PositionBlock.pressedPosition,
                CustomSelectable.SelectionState.Selected => m_PositionBlock.selectedPosition,
                CustomSelectable.SelectionState.Disabled => m_PositionBlock.disabledPosition,
                _ => Vector3.one
            };
        }
        
    }

    [Serializable]
    public class GameObjectVisibilityTransition : BaseTransition
    {
        [SerializeField] private GameObject m_TargetGameObject;
        
        [SerializeField] private bool m_NormalVisible = true;
        [SerializeField] private bool m_HighlightedVisible = true;
        [SerializeField] private bool m_PressedVisible = true;
        [SerializeField] private bool m_SelectedVisible = true;
        [SerializeField] private bool m_DisabledVisible = false;
        
        public override void Start()
        {
        }

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_TargetGameObject == null)
                m_TargetGameObject = selectable.gameObject;
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            DoTransitionInstantly(state);
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            m_TargetGameObject.SetActive(GetVisibility(state));
        }
        
        private bool GetVisibility(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_NormalVisible,
                CustomSelectable.SelectionState.Highlighted => m_HighlightedVisible,
                CustomSelectable.SelectionState.Pressed => m_PressedVisible,
                CustomSelectable.SelectionState.Selected => m_SelectedVisible,
                CustomSelectable.SelectionState.Disabled => m_DisabledVisible,
                _ => false
            };
        }
    }

    [Serializable]
    public class ComponentActiveTransition : BaseTransition
    {
        [SerializeField] private Behaviour m_TargetBehaviour;

        [SerializeField] private bool m_NormalActive = true;
        [SerializeField] private bool m_HighlightedActive = true;
        [SerializeField] private bool m_PressedActive = true;
        [SerializeField] private bool m_SelectedActive = true;
        [SerializeField] private bool m_DisabledActive = false;

        public override void Start()
        {
        }

        public override void OnValidate(CustomSelectable selectable)
        {
            if (m_TargetBehaviour == null)
                m_TargetBehaviour = selectable;
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            DoTransitionInstantly(state);
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            m_TargetBehaviour.enabled = GetVisibility(state);
        }

        private bool GetVisibility(CustomSelectable.SelectionState state)
        {
            return state switch
            {
                CustomSelectable.SelectionState.Normal => m_NormalActive,
                CustomSelectable.SelectionState.Highlighted => m_HighlightedActive,
                CustomSelectable.SelectionState.Pressed => m_PressedActive,
                CustomSelectable.SelectionState.Selected => m_SelectedActive,
                CustomSelectable.SelectionState.Disabled => m_DisabledActive,
                _ => false
            };
        }
    }
    
    [Serializable]
    public class TextKeyTransition : BaseTransition
    {
        [SerializeField] private TextMeshProUGUI m_Text;
        
        [SerializeField] private string m_NormalStringKey;
        [SerializeField] private string m_HighlightedStringKey;
        [SerializeField] private string m_PressedStringKey;
        [SerializeField] private string m_SelectedStringKey;
        [SerializeField] private string m_DisabledStringKey;
        
        private string _normalString;
        private string _highlightedString;
        private string _pressedString;
        private string _selectedString;
        private string _disabledString;
        
        public override void Start()
        {
            if (!string.IsNullOrEmpty(m_NormalStringKey))
                _normalString = m_NormalStringKey.L();
            if (!string.IsNullOrEmpty(m_HighlightedStringKey))
                _highlightedString = m_HighlightedStringKey.L();
            if (!string.IsNullOrEmpty(m_PressedStringKey))
                _pressedString = m_PressedStringKey.L();
            if (!string.IsNullOrEmpty(m_SelectedStringKey))
                _selectedString = m_SelectedStringKey.L();
            if (!string.IsNullOrEmpty(m_DisabledStringKey))
                _disabledString = m_DisabledStringKey.L();
        }

        public override void OnValidate(CustomSelectable selectable)
        {
        }

        public override void DoTransition(CustomSelectable.SelectionState state)
        {
            DoTransitionInstantly(state);
        }

        public override void DoTransitionInstantly(CustomSelectable.SelectionState state)
        {
            var inText = state switch
            {
                CustomSelectable.SelectionState.Normal => _normalString,
                CustomSelectable.SelectionState.Highlighted => string.IsNullOrEmpty(_highlightedString) ? _normalString : _highlightedString,
                CustomSelectable.SelectionState.Pressed => string.IsNullOrEmpty(_pressedString) ? _normalString : _pressedString,
                CustomSelectable.SelectionState.Selected => string.IsNullOrEmpty(_selectedString) ? _normalString : _selectedString,
                CustomSelectable.SelectionState.Disabled => string.IsNullOrEmpty(_disabledString) ? _normalString : _disabledString,
                _ => throw new ArgumentOutOfRangeException(nameof(state), state, null)
            };

            if (m_Text)
                m_Text.text = inText;
        }
    }


}
