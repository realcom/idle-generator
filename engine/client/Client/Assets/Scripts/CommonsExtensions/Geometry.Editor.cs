#if UNITY_EDITOR
using System;
using Commons.Utility;
using Sirenix.OdinInspector.Editor;
using Sirenix.Utilities.Editor;
using UnityEditor;
using UnityEngine;

namespace Commons.Types.Geometry
{

    public static class GeometryUtility
    {
        public static void DrawGizmo(this IGeometry geometry, Vector3 position, Quaternion rotation, Vector3 scale, Color? color = null, float thickness = 1f)
        {
            if (geometry == null)
            {
                Debug.LogError($"Cannot draw gizmo for null geometry.");
                return;
            }

            if (color == null) color = Color.cyan;
            var matrix = Matrix4x4.TRS(position, rotation, scale);
            var scope = new Handles.DrawingScope(color.Value, matrix);
            _DrawGizmo(scope, geometry, thickness);
        }
        
        public static void DrawGeometryGizmo(this Transform matrixBase, IGeometry geometry, float matrixHeightOffset = 0f, bool followMatrixScale = false, Color? color = null, float thickness = 1f)
        {
            if (geometry == null)
            {
                Debug.LogError($"Cannot draw gizmo for null geometry.");
                return;
            }

            if (color == null) color = Color.cyan;
            var position = matrixBase.position + Vector3.up * matrixHeightOffset;
            var scale = followMatrixScale ? matrixBase.localScale : Vector3.one;
            var matrix = Matrix4x4.TRS(position, matrixBase.rotation, scale);
            var scope = new Handles.DrawingScope(color.Value, matrix);

            _DrawGizmo(scope, geometry, thickness);
        }

        private static void _DrawGizmo(Handles.DrawingScope scope, IGeometry geometry, float thickness = 1f)
        {
            using (scope)
            {
                switch (geometry)
                {
                    case Line line:
                        DrawLine(line, thickness);
                        break;
                    case Circle circle:
                        DrawCircle(circle, thickness);
                        break;
                    case Triangle triangle:
                        DrawTriangle(triangle, thickness);
                        break;
                    case BoundingBox boundingBox:
                        DrawBoundingBox(boundingBox, thickness);
                        break;
                    case CircleSector sector:
                        DrawCircleSector(sector, thickness);
                        break;
                    case Rectangle rectangle:
                        DrawRectangle(rectangle, thickness);
                        break;
                    default:
                        break;
                }
            }
        }

        private static void DrawLine(Line line, float thickness = 1f)
        {
            Handles.DrawLine(line.P1.X0Z(), line.P2.X0Z(), thickness);
        }

        private static void DrawCircle(Circle circle, float thickness = 1f)
        {
            Handles.DrawWireDisc(circle.Center.X0Z(), Vector3.forward, (float)circle.Radius, thickness);
        }
        
        private static void DrawCircleSector(CircleSector sector, float thickness = 1f)
        {
            // Sector angle range is from 0 to 180 degrees
            var leftRotation = Quaternion.AngleAxis(-(float)sector.AngleOffset - (float)sector.Angle, Vector3.up);
            var rightRotation = Quaternion.AngleAxis(-(float)sector.AngleOffset + (float)sector.Angle, Vector3.up);

            var leftDirection = leftRotation * Vector3.right; // right: direction which unit is facing
            var rightDirection = rightRotation  * Vector3.right;
            var initPos = sector.Center.X0Z();

            Handles.DrawLine(initPos, initPos + leftDirection * (float)sector.Radius, thickness);
            Handles.DrawLine(initPos, initPos + rightDirection * (float)sector.Radius, thickness);

            Handles.DrawWireArc(initPos, Vector3.forward, leftDirection, (float)sector.Angle * 2, (float)sector.Radius, thickness);
        }

        private static void DrawTriangle(Triangle triangle, float thickness = 1f)
        {
            Handles.DrawLine(triangle.P1.X0Z(), triangle.P2.X0Z(),thickness);
            Handles.DrawLine(triangle.P2.X0Z(), triangle.P3.X0Z(),thickness);
            Handles.DrawLine(triangle.P3.X0Z(), triangle.P1.X0Z(),thickness);
        }

        private static void DrawBoundingBox(BoundingBox box, float thickness = 1f)
        {
            var corners = new Vector3[5];
            corners[0] = new Vector3((float)box.Min.x, 0f, (float)box.Min.y);
            corners[1] = new Vector3((float)box.Max.x, 0f, (float)box.Min.y);
            corners[2] = new Vector3((float)box.Max.x, 0f, (float)box.Max.y);
            corners[3] = new Vector3((float)box.Min.x, 0f, (float)box.Max.y);
            corners[4] = new Vector3((float)box.Min.x, 0f, (float)box.Min.y); // duplicated
            Handles.DrawPolyLine(corners);
        }

        private static void DrawRectangle(Rectangle rectangle, float thickness = 1f)
        {
            var cos = Mathf.Cos((float)rectangle.Angle * Mathf.Deg2Rad);
            var sin = Mathf.Sin((float)rectangle.Angle * Mathf.Deg2Rad);
            var widthVec = new Vector3(-(float)rectangle.HalfWidth * sin, (float)rectangle.HalfWidth * cos, 0f);
            var heightVec = new Vector3((float)rectangle.Height * cos, (float)rectangle.Height * sin, 0f);
            var corners = new Vector3[5];
            corners[0] = rectangle.Pivot.X0Z() + widthVec;
            corners[1] = rectangle.Pivot.X0Z() - widthVec;
            corners[2] = rectangle.Pivot.X0Z() - widthVec + heightVec;
            corners[3] = rectangle.Pivot.X0Z() + widthVec + heightVec;
            corners[4] = rectangle.Pivot.X0Z() + widthVec;// duplicated
            
            Handles.DrawPolyLine(corners);
        }

        public static IGeometry GetConvertedGeometry(this IGeometry geometry, float conversionFloat)
        {
            switch (geometry.GeometryType)
            {
                case IGeometry.Type.CircleSector:
                {
                    var circleSector = (CircleSector)geometry;
                    var angle = circleSector.Angle * conversionFloat;
                    var angleOffset = circleSector.AngleOffset * conversionFloat;
                    return new CircleSector(circleSector.Center, circleSector.Radius, angle, angleOffset);
                }
                case IGeometry.Type.Rectangle:
                {
                    var rectangle = (Rectangle)geometry;
                    var rectAngle = rectangle.Angle * conversionFloat;
                    return new Rectangle(rectangle.Pivot, rectAngle, rectangle.HalfWidth, rectangle.Height);
                }
                default:
                    return geometry;
            }
        }


    }
    
    public class FixedFloatDrawerAttribute : Attribute
    {
    }

    public class FixedVector2DrawerAttribute : Attribute
    {
    }
    
    public class FixedFloatDrawer : OdinAttributeDrawer<FixedFloatDrawerAttribute, FixedFloat>
    {
        protected override void DrawPropertyLayout(GUIContent label)
        {
            var value = ValueEntry.SmartValue;
            value = EditorGUILayout.FloatField(label, (float)value);

            ValueEntry.SmartValue = (float)value;
        }
    }
    
    public class FixedVector2Drawer : OdinAttributeDrawer<FixedVector2DrawerAttribute, FixedVector2>
    {
        protected override void DrawPropertyLayout(GUIContent label)
        {
            var value = ValueEntry.SmartValue;
            value = EditorGUILayout.Vector2Field(label, (Vector2)value);

            ValueEntry.SmartValue = value;
        }
    }
}
#endif