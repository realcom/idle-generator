using System;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Object = UnityEngine.Object;

namespace ReferenceFinder.Editor
{
    [Required]
    public class GameObjectPicker : MonoBehaviour
    {
        private readonly List<RaycastResult> raycastResults = new List<RaycastResult>();

        public void Awake()
        {
            // 에디터 환경에서만 돌아가야한다
            if (!Application.isEditor)
            {
                enabled = false;
            }
        }

        public void Update()
        {
            var BUTTON_MIDDLE = 2;
            if (!Input.GetMouseButtonDown(BUTTON_MIDDLE)) { return; }

            var result = RaycastUI();
            if (!result.HasValue) { return; }

            var raycastResult = result.Value;
            var gameObj = raycastResult.gameObject;
            Pick(gameObj);
        }

        private bool IsInteractableGameObject(GameObject gameObj)
        {
            return gameObj.GetComponent<Selectable>() != null;
        }

        private RaycastResult? RaycastUI()
        {
            var pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = Input.mousePosition;

            raycastResults.Clear();
            var raycasters = FindObjectsOfType<GraphicRaycaster>();
            foreach (var raycaster in raycasters)
            {
                raycaster.Raycast(pointerEventData, raycastResults);
            }

            foreach (var result in raycastResults)
            {
                var gameObj = result.gameObject;
                var interactable = IsInteractableGameObject(gameObj);
                if (!interactable) { continue; }

                return result;
            }
            return null;
        }

        public static void Pick(GameObject obj)
        {
#if UNITY_EDITOR
            // 선택한 객체를 inspector에 띄우기
            UnityEditor.Selection.activeGameObject = obj;

            // hierarchy로 객체 표시
            UnityEditor.EditorGUIUtility.PingObject(obj);
#endif
        }

        public static void Pick(Object obj)
        {
#if UNITY_EDITOR
            // 선택한 객체를 inspector에 띄우기
            UnityEditor.Selection.activeObject = obj;
            // hierarchy로 객체 표시
            UnityEditor.EditorGUIUtility.PingObject(obj);
#endif
        }

        private static void CopyToClipboard(string text)
        {
            GUIUtility.systemCopyBuffer = text;
        }

        private static string GetTransformPath(Transform tr)
        {
            var elems = GetTransformPathElements(tr);
            return string.Join("/", elems);
        }

        private static List<string> GetTransformPathElements(Transform tr)
        {
            var list = new List<string>();
            var current = tr;
            while (current)
            {
                list.Add(current.name);
                current = current.parent;
            }
            list.Reverse();
            return list;
        }

    }
}
