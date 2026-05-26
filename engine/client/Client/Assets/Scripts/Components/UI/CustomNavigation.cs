using System;
using Components.UI;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;

#if UNITY_EDITOR
using UnityEditor.UIElements;
#endif

namespace Components.UI
{
    [Serializable]
    /// <summary>
    /// Structure storing details related to navigation.
    /// </summary>
    public struct CustomNavigation : IEquatable<CustomNavigation>
    {
        /*
         * This looks like it's not flags, but it is flags,
         * the reason is that Automatic is considered horizontal
         * and verical mode combined
         */
        [Flags]
        /// <summary>
        /// Navigation mode enumeration.
        /// </summary>
        /// <remarks>
        /// This looks like it's not flags, but it is flags, the reason is that Automatic is considered horizontal and vertical mode combined
        /// </remarks>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI; // Required when Using UI elements.
        ///
        /// public class ExampleClass : MonoBehaviour
        /// {
        ///     public Button button;
        ///
        ///     void Start()
        ///     {
        ///         //Set the navigation to the mode "Vertical".
        ///         if (button.navigation.mode == Navigation.Mode.Vertical)
        ///         {
        ///             Debug.Log("The button's navigation mode is Vertical");
        ///         }
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public enum Mode
        {
            /// <summary>
            /// No navigation is allowed from this object.
            /// </summary>
            None        = 0,

            /// <summary>
            /// Horizontal Navigation.
            /// </summary>
            /// <remarks>
            /// Navigation should only be allowed when left / right move events happen.
            /// </remarks>
            Horizontal  = 1,

            /// <summary>
            /// Vertical navigation.
            /// </summary>
            /// <remarks>
            /// Navigation should only be allowed when up / down move events happen.
            /// </remarks>
            Vertical    = 2,

            /// <summary>
            /// Automatic navigation.
            /// </summary>
            /// <remarks>
            /// Attempt to find the 'best' next object to select. This should be based on a sensible heuristic.
            /// </remarks>
            Automatic   = 3,

            /// <summary>
            /// Explicit navigation.
            /// </summary>
            /// <remarks>
            /// User should explicitly specify what is selected by each move event.
            /// </remarks>
            Explicit    = 4,
        }

        // Which method of navigation will be used.
        [SerializeField]
        private Mode m_Mode;

        [Tooltip("Enables navigation to wrap around from last to first or first to last element. Does not work for automatic grid navigation")]
        [SerializeField]
        private bool m_WrapAround;

        // Game object selected when the joystick moves up. Used when navigation is set to "Explicit".
        [SerializeField]
        private CustomSelectable m_SelectOnUp;

        // Game object selected when the joystick moves down. Used when navigation is set to "Explicit".
        [SerializeField]
        private CustomSelectable m_SelectOnDown;

        // Game object selected when the joystick moves left. Used when navigation is set to "Explicit".
        [SerializeField]
        private CustomSelectable m_SelectOnLeft;

        // Game object selected when the joystick moves right. Used when navigation is set to "Explicit".
        [SerializeField]
        private CustomSelectable m_SelectOnRight;

        /// <summary>
        /// Navigation mode.
        /// </summary>
        public Mode       mode           { get { return m_Mode; } set { m_Mode = value; } }

        /// <summary>
        /// Enables navigation to wrap around from last to first or first to last element.
        /// Will find the furthest element from the current element in the opposite direction of movement.
        /// </summary>
        /// <example>
        /// Note: If you have a grid of elements and you are on the last element in a row it will not wrap over to the next row it will pick the furthest element in the opposite direction.
        /// </example>
        public bool wrapAround { get { return m_WrapAround; } set { m_WrapAround = value; } }

        /// <summary>
        /// Specify a Selectable UI GameObject to highlight when the Up arrow key is pressed.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI;  // Required when Using UI elements.
        ///
        /// public class HighlightOnKey : MonoBehaviour
        /// {
        ///     public Button btnSave;
        ///     public Button btnLoad;
        ///
        ///     public void Start()
        ///     {
        ///         // get the Navigation data
        ///         Navigation navigation = btnLoad.navigation;
        ///
        ///         // switch mode to Explicit to allow for custom assigned behavior
        ///         navigation.mode = Navigation.Mode.Explicit;
        ///
        ///         // highlight the Save button if the up arrow key is pressed
        ///         navigation.selectOnUp = btnSave;
        ///
        ///         // reassign the struct data to the button
        ///         btnLoad.navigation = navigation;
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public CustomSelectable selectOnUp     { get { return m_SelectOnUp; } set { m_SelectOnUp = value; } }

        /// <summary>
        /// Specify a Selectable UI GameObject to highlight when the down arrow key is pressed.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI;  // Required when Using UI elements.
        ///
        /// public class HighlightOnKey : MonoBehaviour
        /// {
        ///     public Button btnSave;
        ///     public Button btnLoad;
        ///
        ///     public void Start()
        ///     {
        ///         // get the Navigation data
        ///         Navigation navigation = btnLoad.navigation;
        ///
        ///         // switch mode to Explicit to allow for custom assigned behavior
        ///         navigation.mode = Navigation.Mode.Explicit;
        ///
        ///         // highlight the Save button if the down arrow key is pressed
        ///         navigation.selectOnDown = btnSave;
        ///
        ///         // reassign the struct data to the button
        ///         btnLoad.navigation = navigation;
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public CustomSelectable selectOnDown   { get { return m_SelectOnDown; } set { m_SelectOnDown = value; } }

        /// <summary>
        /// Specify a Selectable UI GameObject to highlight when the left arrow key is pressed.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI;  // Required when Using UI elements.
        ///
        /// public class HighlightOnKey : MonoBehaviour
        /// {
        ///     public Button btnSave;
        ///     public Button btnLoad;
        ///
        ///     public void Start()
        ///     {
        ///         // get the Navigation data
        ///         Navigation navigation = btnLoad.navigation;
        ///
        ///         // switch mode to Explicit to allow for custom assigned behavior
        ///         navigation.mode = Navigation.Mode.Explicit;
        ///
        ///         // highlight the Save button if the left arrow key is pressed
        ///         navigation.selectOnLeft = btnSave;
        ///
        ///         // reassign the struct data to the button
        ///         btnLoad.navigation = navigation;
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public CustomSelectable selectOnLeft   { get { return m_SelectOnLeft; } set { m_SelectOnLeft = value; } }

        /// <summary>
        /// Specify a Selectable UI GameObject to highlight when the right arrow key is pressed.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI;  // Required when Using UI elements.
        ///
        /// public class HighlightOnKey : MonoBehaviour
        /// {
        ///     public Button btnSave;
        ///     public Button btnLoad;
        ///
        ///     public void Start()
        ///     {
        ///         // get the Navigation data
        ///         Navigation navigation = btnLoad.navigation;
        ///
        ///         // switch mode to Explicit to allow for custom assigned behavior
        ///         navigation.mode = Navigation.Mode.Explicit;
        ///
        ///         // highlight the Save button if the right arrow key is pressed
        ///         navigation.selectOnRight = btnSave;
        ///
        ///         // reassign the struct data to the button
        ///         btnLoad.navigation = navigation;
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        public CustomSelectable selectOnRight  { get { return m_SelectOnRight; } set { m_SelectOnRight = value; } }

        /// <summary>
        /// Return a Navigation with sensible default values.
        /// </summary>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// using UnityEngine;
        /// using System.Collections;
        /// using UnityEngine.UI; // Required when Using UI elements.
        ///
        /// public class ExampleClass : MonoBehaviour
        /// {
        ///     public Button button;
        ///
        ///     void Start()
        ///     {
        ///         //Set the navigation to the default value. ("Automatic" is the default value).
        ///         button.navigation = Navigation.defaultNavigation;
        ///     }
        /// }
        /// ]]>
        ///</code>
        /// </example>
        static public CustomNavigation defaultNavigation
        {
            get
            {
                var defaultNav = new CustomNavigation();
                defaultNav.m_Mode = Mode.Automatic;
                defaultNav.m_WrapAround = false;
                return defaultNav;
            }
        }

        public bool Equals(CustomNavigation other)
        {
            return mode == other.mode &&
                selectOnUp == other.selectOnUp &&
                selectOnDown == other.selectOnDown &&
                selectOnLeft == other.selectOnLeft &&
                selectOnRight == other.selectOnRight;
        }
    }
}

#if UNITY_EDITOR
namespace PM.Editor.UI
{
     [CustomPropertyDrawer(typeof(CustomNavigation), true)]
    /// <summary>
    /// This is a PropertyDrawer for Navigation. It is implemented using the standard Unity PropertyDrawer framework.
    /// </summary>
    public class CustomNavigationDrawer : PropertyDrawer
    {
        const string kNavigation = "Navigation";

        const string kModeProp = "m_Mode";
        const string kWrapAroundProp = "m_WrapAround";
        const string kSelectOnUpProp = "m_SelectOnUp";
        const string kSelectOnDownProp = "m_SelectOnDown";
        const string kSelectOnLeftProp = "m_SelectOnLeft";
        const string kSelectOnRightProp = "m_SelectOnRight";

        const string kHiddenClass = "unity-ui-navigation-hidden";

        private class Styles
        {
            readonly public GUIContent navigationContent;

            public Styles()
            {
                navigationContent = EditorGUIUtility.TrTextContent(kNavigation);
            }
        }

        private static Styles s_Styles = null;

        public override void OnGUI(Rect pos, SerializedProperty prop, GUIContent label)
        {
            if (s_Styles == null)
                s_Styles = new Styles();

            Rect drawRect = pos;
            drawRect.height = EditorGUIUtility.singleLineHeight;

            SerializedProperty navigation = prop.FindPropertyRelative(kModeProp);
            SerializedProperty wrapAround = prop.FindPropertyRelative(kWrapAroundProp);
            CustomNavigation.Mode navMode = GetNavigationMode(navigation);

            EditorGUI.PropertyField(drawRect, navigation, s_Styles.navigationContent);

            ++EditorGUI.indentLevel;

            drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;

            switch (navMode)
            {
                case CustomNavigation.Mode.Horizontal:
                case CustomNavigation.Mode.Vertical:
                {
                    EditorGUI.PropertyField(drawRect, wrapAround);
                    drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                }
                break;
                case CustomNavigation.Mode.Explicit:
                {
                    SerializedProperty selectOnUp = prop.FindPropertyRelative(kSelectOnUpProp);
                    SerializedProperty selectOnDown = prop.FindPropertyRelative(kSelectOnDownProp);
                    SerializedProperty selectOnLeft = prop.FindPropertyRelative(kSelectOnLeftProp);
                    SerializedProperty selectOnRight = prop.FindPropertyRelative(kSelectOnRightProp);

                    EditorGUI.PropertyField(drawRect, selectOnUp);
                    drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                    EditorGUI.PropertyField(drawRect, selectOnDown);
                    drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                    EditorGUI.PropertyField(drawRect, selectOnLeft);
                    drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                    EditorGUI.PropertyField(drawRect, selectOnRight);
                    drawRect.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                }
                break;
            }

            --EditorGUI.indentLevel;
        }

        static CustomNavigation.Mode GetNavigationMode(SerializedProperty navigation)
        {
            return (CustomNavigation.Mode)navigation.enumValueIndex;
        }

        public override float GetPropertyHeight(SerializedProperty prop, GUIContent label)
        {
            SerializedProperty navigation = prop.FindPropertyRelative(kModeProp);
            if (navigation == null)
                return EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;

            CustomNavigation.Mode navMode = GetNavigationMode(navigation);

            switch (navMode)
            {
                case CustomNavigation.Mode.None:
                    return EditorGUIUtility.singleLineHeight;
                case CustomNavigation.Mode.Horizontal:
                case CustomNavigation.Mode.Vertical:
                    return 2 * EditorGUIUtility.singleLineHeight + 2 * EditorGUIUtility.standardVerticalSpacing;
                case CustomNavigation.Mode.Explicit:
                    return 5 * EditorGUIUtility.singleLineHeight + 5 * EditorGUIUtility.standardVerticalSpacing;
                default:
                    return EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
            }
        }

        PropertyField PrepareField(VisualElement parent, string propertyPath, bool hideable = true, string label = null)
        {
            var field = new PropertyField(null, label) { bindingPath = propertyPath };
            if (hideable) field.AddToClassList(kHiddenClass);
            parent.Add(field);
            return field;
        }

        public override VisualElement CreatePropertyGUI(SerializedProperty property)
        {
            var container = new VisualElement() { name = kNavigation };
            var indented = new VisualElement() { name = "Indent" };

            indented.AddToClassList("unity-ui-navigation-indent");

            var navigation = PrepareField(container, kModeProp, false, kNavigation);
            var wrapAround = PrepareField(indented, kWrapAroundProp);
            var selectOnUp = PrepareField(indented, kSelectOnUpProp);
            var selectOnDown = PrepareField(indented, kSelectOnDownProp);
            var selectOnLeft = PrepareField(indented, kSelectOnLeftProp);
            var selectOnRight = PrepareField(indented, kSelectOnRightProp);

            Action<CustomNavigation.Mode> callback = (value) =>
            {
                wrapAround.EnableInClassList(kHiddenClass, value != CustomNavigation.Mode.Vertical && value != CustomNavigation.Mode.Horizontal);
                selectOnUp.EnableInClassList(kHiddenClass, value != CustomNavigation.Mode.Explicit);
                selectOnDown.EnableInClassList(kHiddenClass, value != CustomNavigation.Mode.Explicit);
                selectOnLeft.EnableInClassList(kHiddenClass, value != CustomNavigation.Mode.Explicit);
                selectOnRight.EnableInClassList(kHiddenClass, value != CustomNavigation.Mode.Explicit);
            };

            navigation.RegisterValueChangeCallback((e) => callback.Invoke((CustomNavigation.Mode)e.changedProperty.enumValueIndex));
            callback.Invoke((CustomNavigation.Mode)property.FindPropertyRelative(kModeProp).enumValueFlag);

            container.Add(indented);
            return container;
        }
    }
}
#endif