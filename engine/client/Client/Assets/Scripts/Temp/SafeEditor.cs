using System;
using System.Linq;
using TMPro;
using UnityEngine;
using AnimatorControllerParameter = UnityEngine.AnimatorControllerParameter;
using Object = UnityEngine.Object;

#if UNITY_EDITOR
using AnimatorController = UnityEditor.Animations.AnimatorController;
using UnityEditor;
using UnityEditorInternal;
#endif

namespace Share
{
    // UnityEditor코드를 가져다가 쓰고 싶은데, 네임스페이스 때문에 가져다쓰기 겁날 때 쓰는 코드
    // 이 코드만 쓰면, #if UNITY_EDITOR 안 해도 된다!
    public class SafeEditor
    {
        // 인스펙터에서 컴포넌트를 제일 위로 올림
        public static void MoveComponentTop<T>(T t) where T : Component
        {
            while (MoveComponentUp(t)) ;
        }

        // 인스펙터에서 컴포넌트를 한칸 위로 올림
        public static bool MoveComponentUp<T>(T t) where T : Component
        {
#if UNITY_EDITOR
            return ComponentUtility.MoveComponentUp(t);
#else
            return false;
#endif
        }

        public static AnimatorControllerParameter[] GetParameters(RuntimeAnimatorController animator)
        {
#if UNITY_EDITOR
            var path = AssetDatabase.GetAssetPath(animator);
            var ty = typeof(AnimatorController);
            var controller = (AnimatorController)AssetDatabase.LoadAssetAtPath(path, ty);
            return controller.parameters;
#else
            return new UnityEngine.AnimatorControllerParameter[0];
#endif
        }

        public static Material[] GetMaterialPresets(TMP_Text text)
        {
            if (text == null || text.font == null)
                return Array.Empty<Material>();

#if UNITY_EDITOR
            return new Material[0];
            //return TMP_EditorUtility.FindMaterialReferences(text.font);
#else
            return new Material[0];
#endif
        }

        public static string[] GetStateNames(RuntimeAnimatorController animator, int layer = 0)
        {
#if UNITY_EDITOR
            var path = AssetDatabase.GetAssetPath(animator);
            var ty = typeof(AnimatorController);
            var controller = (AnimatorController)AssetDatabase.LoadAssetAtPath(path, ty);
            return controller.layers[layer].stateMachine.states.Select(childState => childState.state.name).ToArray();
#else
            return new string[0];
#endif
        }

        public static void SetDirty(Object target)
        {
#if UNITY_EDITOR
            EditorUtility.SetDirty(target);
            HandleUtility.Repaint();
#endif
        }
    }
}