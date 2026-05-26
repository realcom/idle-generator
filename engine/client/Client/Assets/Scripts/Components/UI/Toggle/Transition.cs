using System;
using DG.Tweening;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Components.UI.Toggle
{

    public interface ITransition
    {
        public void Start();
        public void OnValidate(CustomToggle toggle);
        public void DoTransitionOn();
        public void DoTransitionOff();
        public void DoTransitionInstantlyOn();
        public void DoTransitionInstantlyOff();
    }

    [Serializable, HideReferenceObjectPicker]
    public abstract class BaseTransition : ITransition
    {
        public abstract void Start();
        public abstract void OnValidate(CustomToggle toggle);
        public abstract void DoTransitionOn();
        public abstract void DoTransitionOff();
        public abstract void DoTransitionInstantlyOn();
        public abstract void DoTransitionInstantlyOff();
    }

    [Serializable]
    public abstract class GraphicTransition : BaseTransition
    {
        [SerializeField] protected Graphic m_TargetGraphic;

        public override void OnValidate(CustomToggle toggle)
        {
            if (m_TargetGraphic == null)
                m_TargetGraphic = toggle.GetComponent<Graphic>();
        }
    }
    
    [Serializable]
    public class ColorTransition : GraphicTransition
    {
        [SerializeField] private Color m_OnColor = Color.white;
        [SerializeField] private Color m_OffColor = Color.gray;

        public override void Start()
        {
        }
        
        public override void DoTransitionOn()
        {
            m_TargetGraphic.canvasRenderer.SetColor(m_OnColor);
        }

        public override void DoTransitionOff()
        {
            m_TargetGraphic.canvasRenderer.SetColor(m_OffColor);
        }

        public override void DoTransitionInstantlyOn()
        {
            DoTransitionOn();
        }

        public override void DoTransitionInstantlyOff()
        {
            DoTransitionOff();
        }
    }

    [Serializable]
    public class SpriteOverrideTransition : GraphicTransition
    {
        [SerializeField] private Sprite m_OverrideSprite;

        public Sprite overrideSprite
        {
            get => m_OverrideSprite;
            set => m_OverrideSprite = value;
        }

        protected Image m_Image
        {
            get => m_TargetGraphic as Image;
            set => m_TargetGraphic = value;
        }

        public override void Start()
        {
        }
        
        public override void DoTransitionOn()
        {
            m_Image.overrideSprite = m_OverrideSprite;
        }

        public override void DoTransitionOff()
        {
            if (m_Image.overrideSprite == m_OverrideSprite)
                m_Image.overrideSprite = null;
        }

        public override void DoTransitionInstantlyOn()
        {
            DoTransitionOn();
        }

        public override void DoTransitionInstantlyOff()
        {
            DoTransitionOff();
        }
    }

    [Serializable]
    public class GraphicVisibilityTransition : GraphicTransition
    {
        public override void Start()
        {
        }

        public override void DoTransitionOn()
        {
            SetVisibility(true);
        }

        public override void DoTransitionOff()
        {
            SetVisibility(false);
        }

        public override void DoTransitionInstantlyOn()
        {
            SetVisibility(true, true);
        }

        public override void DoTransitionInstantlyOff()
        {
            SetVisibility(false, true);
        }

        private void SetVisibility(bool bVisible, bool instantly = false)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
                m_TargetGraphic.canvasRenderer.SetAlpha(bVisible ? 1f : 0f);
            else
#endif
                m_TargetGraphic.CrossFadeAlpha(bVisible ? 1f : 0f, instantly ? 0f : 0.1f, true);
        }

    }

    [Serializable]
    public class CanvasGroupVisibilityTransition : BaseTransition
    {
        [SerializeField] private CanvasGroup m_TargetCanvasGroup;

        public override void Start()
        {
        }

        public override void OnValidate(CustomToggle toggle)
        {
            if (m_TargetCanvasGroup == null)
                m_TargetCanvasGroup = toggle.GetComponent<CanvasGroup>();
        }

        public override void DoTransitionOn()
        {
            SetVisibility(true);
        }

        public override void DoTransitionOff()
        {
            SetVisibility(false);
        }

        public override void DoTransitionInstantlyOn()
        {
            SetVisibility(true, true);
        }

        public override void DoTransitionInstantlyOff()
        {
            SetVisibility(false, true);
        }

        private void SetVisibility(bool bVisible, bool instantly = false)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
                m_TargetCanvasGroup.alpha = bVisible ? 1f : 0f;
            else
#endif
                m_TargetCanvasGroup.DOFade(bVisible ? 1f : 0f, instantly ? 0f : 0.1f);                
        }
    }

    [Serializable]
    public class CanvasGroupTransition : BaseTransition
    {
        [SerializeField] private CanvasGroup m_TargetCanvasGroup;

        [Serializable]
        public struct CanvasGroupBlock
        {
            [SerializeField]
            private float m_Alpha;
            [SerializeField]
            private bool m_Interactable;
            [SerializeField]
            private bool m_BlockRaycasts;
            
            public float Alpha => m_Alpha;
            public bool Interactable => m_Interactable;
            public bool BlockRaycasts => m_BlockRaycasts;
            
            public static CanvasGroupBlock defaultBlock => new()
            {
                m_Alpha = 1f,
                m_Interactable = true,
                m_BlockRaycasts = true
            };
        }
        
        [SerializeField] private CanvasGroupBlock m_OnBlock = CanvasGroupBlock.defaultBlock;
        [SerializeField] private CanvasGroupBlock m_OffBlock = CanvasGroupBlock.defaultBlock;
        
        public override void Start()
        {
        }
        
        public override void OnValidate(CustomToggle toggle)
        {
            if (m_TargetCanvasGroup == null)
                m_TargetCanvasGroup = toggle.GetComponent<CanvasGroup>();
        }
        
        public override void DoTransitionOn()
        {
            SetCanvasGroupBlock(m_OnBlock);
        }
        
        public override void DoTransitionOff()
        {
            SetCanvasGroupBlock(m_OffBlock);
        }
        
        public override void DoTransitionInstantlyOn()
        {
            DoTransitionOn();
        }
        
        public override void DoTransitionInstantlyOff()
        {
            DoTransitionOff();
        }

        private void SetCanvasGroupBlock(CanvasGroupBlock block)
        {
            if (m_TargetCanvasGroup == null)
                return;
            
            m_TargetCanvasGroup.alpha = block.Alpha;
            m_TargetCanvasGroup.interactable = block.Interactable;
            m_TargetCanvasGroup.blocksRaycasts = block.BlockRaycasts;
        }

    }
    
    [Serializable]
    public class FlexibleSizeTransition : BaseTransition
    {
        [SerializeField] private LayoutElement m_TargetLayoutElement;
        [SerializeField] private Vector2 m_OnSize = new(-1f, -1f);
        [SerializeField] private Vector2 m_OffSize = new(-1f, -1f);
        [SerializeField] private float m_Duration = 0.1f;

        public override void Start()
        {
        }

        public override void OnValidate(CustomToggle toggle)
        {
            if (m_TargetLayoutElement == null)
                m_TargetLayoutElement = toggle.GetComponent<LayoutElement>();
        }

        public override void DoTransitionOn()
        {
            SetSize(m_OnSize);
        }

        public override void DoTransitionOff()
        {
            SetSize(m_OffSize);
        }

        public override void DoTransitionInstantlyOn()
        {
            SetSize(m_OnSize, true);
        }

        public override void DoTransitionInstantlyOff()
        {
            SetSize(m_OffSize, true);
        }

        private void SetSize(Vector2 size, bool instantly = false)
        {
            m_TargetLayoutElement.DOFlexibleSize(size, instantly ? 0f : m_Duration);
        }
    }

    [Serializable]
    public class TextKeyTransition : BaseTransition
    {
        [SerializeField] private TextMeshProUGUI m_Text;
        [SerializeField] private string m_OnStringKey;
        [SerializeField] private string m_OffStringKey;
        
        private string m_ParsedOnString;
        private string m_ParsedOffString;
        
        public override void Start()
        {
            if (!string.IsNullOrEmpty(m_OnStringKey))
                m_ParsedOnString = m_OnStringKey.L();
            if (!string.IsNullOrEmpty(m_OffStringKey))
                m_ParsedOffString = m_OffStringKey.L();
        }

        public override void OnValidate(CustomToggle toggle)
        {
            if (m_Text == null)
                m_Text = toggle.GetComponentInChildren<TextMeshProUGUI>();
        }

        public override void DoTransitionOn()
        {
            if (string.IsNullOrEmpty(m_OnStringKey))
                return;

            m_Text.text = string.IsNullOrEmpty(m_ParsedOnString) ? m_OnStringKey : m_ParsedOnString;
        }

        public override void DoTransitionOff()
        {
            if (string.IsNullOrEmpty(m_OffStringKey))
                return;
            
            m_Text.text = string.IsNullOrEmpty(m_ParsedOffString) ? m_OffStringKey : m_ParsedOffString;
        }

        public override void DoTransitionInstantlyOn()
        {
            DoTransitionOn();
        }

        public override void DoTransitionInstantlyOff()
        {
            DoTransitionOff();
        }
    }
    
    [Serializable]
    public class GameObjectVisibilityTransition : BaseTransition
    {
        [SerializeField] private GameObject m_TargetGameObject;
        [SerializeField] private bool m_OnActive = true;
        [SerializeField] private bool m_OffActive = false;

        public override void Start()
        {
        }

        public override void OnValidate(CustomToggle toggle)
        {
            if (m_TargetGameObject == null)
                m_TargetGameObject = toggle.gameObject;
        }

        public override void DoTransitionOn()
        {
            SetVisibility(m_OnActive);
        }

        public override void DoTransitionOff()
        {
            SetVisibility(m_OffActive);
        }

        public override void DoTransitionInstantlyOn()
        {
            SetVisibility(m_OnActive, true);
        }

        public override void DoTransitionInstantlyOff()
        {
            SetVisibility(m_OffActive, true);
        }

        private void SetVisibility(bool bVisible, bool instantly = false)
        {
            m_TargetGameObject.SetActive(bVisible);
        }
    }
    
    
}
