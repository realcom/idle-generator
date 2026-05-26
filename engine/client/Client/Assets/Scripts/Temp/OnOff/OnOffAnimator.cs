using Sirenix.OdinInspector;
using System.Linq;
using UnityEngine;

namespace Share.OnOff
{
    [Required]
    public class OnOffAnimator : OnOffBase
    {
        [SerializeField] [Required] private Animator animator;

        [HorizontalGroup("bool")]
        [SerializeField]
        [LabelText("bool")]
        private bool useBoolParameter;

        [HorizontalGroup("bool")]
        [SerializeField]
        [HideLabel]
        [ShowIf(nameof(useBoolParameter))]
        [ValidateInput(nameof(ValidateBool), "없는 bool 파라미터입니다.")]
        private string boolParameter;

        protected override void _OnOff(bool isOn)
        {
            if (useBoolParameter)
                animator.SetBool(boolParameter, isOn);
        }

        private bool ValidateBool(string parameter)
        {
            if (!useBoolParameter || animator == null || animator.runtimeAnimatorController == null)
                return true;
            var parms = SafeEditor.GetParameters(animator.runtimeAnimatorController);
            return parms.Any(x => x.type == AnimatorControllerParameterType.Bool && x.name == parameter);
        }
    }
}