using System.Collections;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.UI;
#endif
using UnityEngine;
using UnityEngine.UI;

[AddComponentMenu("Custom Grid Layout Group")]
public class CustomGridLayoutGroup : GridLayoutGroup
{
    [SerializeField] private Vector2 m_CellScale = Vector2.one;
    public Vector2 cellScale => m_CellScale;

    public Vector2 preferredCellSize => cellSize * m_CellScale;

    public override void CalculateLayoutInputHorizontal()
    {
        base.CalculateLayoutInputHorizontal();

        int minColumns = 0;
        int preferredColumns = 0;
        if (m_Constraint == Constraint.FixedColumnCount)
        {
            minColumns = preferredColumns = m_ConstraintCount;
        }
        else if (m_Constraint == Constraint.FixedRowCount)
        {
            minColumns = preferredColumns = Mathf.CeilToInt(rectChildren.Count / (float)m_ConstraintCount - 0.001f);
        }
        else
        {
            minColumns = 1;
            preferredColumns = Mathf.CeilToInt(Mathf.Sqrt(rectChildren.Count));
        }

        SetLayoutInputForAxis(
            padding.horizontal + (preferredCellSize.x + spacing.x) * minColumns - spacing.x,
            padding.horizontal + (preferredCellSize.x + spacing.x) * preferredColumns - spacing.x,
            -1, 0);
    }

    public override void CalculateLayoutInputVertical()
    {
        int minRows = 0;
        if (m_Constraint == Constraint.FixedColumnCount)
        {
            minRows = Mathf.CeilToInt(rectChildren.Count / (float)m_ConstraintCount - 0.001f);
        }
        else if (m_Constraint == Constraint.FixedRowCount)
        {
            minRows = m_ConstraintCount;
        }
        else
        {
            float width = rectTransform.rect.width;
            int cellCountX = Mathf.Max(1, Mathf.FloorToInt((width - padding.horizontal + spacing.x + 0.001f) / (preferredCellSize.x + spacing.x)));
            minRows = Mathf.CeilToInt(rectChildren.Count / (float)cellCountX);
        }

        float minSpace = padding.vertical + (preferredCellSize.y + spacing.y) * minRows - spacing.y;
        SetLayoutInputForAxis(minSpace, minSpace, -1, 1);
    }

    public override void SetLayoutHorizontal()
    {
        SetCellsAlongAxis(0);
    }

    public override void SetLayoutVertical()
    {
        SetCellsAlongAxis(1);
    }

    private void SetCellsAlongAxis(int axis)
    {
        // Normally a Layout Controller should only set horizontal values when invoked for the horizontal axis
        // and only vertical values when invoked for the vertical axis.
        // However, in this case we set both the horizontal and vertical position when invoked for the vertical axis.
        // Since we only set the horizontal position and not the size, it shouldn't affect children's layout,
        // and thus shouldn't break the rule that all horizontal layout must be calculated before all vertical layout.
        var rectChildrenCount = rectChildren.Count;
        if (axis == 0)
        {
            // Only set the sizes when invoked for horizontal axis, not the positions.

            for (int i = 0; i < rectChildrenCount; i++)
            {
                RectTransform rect = rectChildren[i];

                m_Tracker.Add(this, rect,
                    DrivenTransformProperties.Anchors |
                    DrivenTransformProperties.AnchoredPosition |
                    DrivenTransformProperties.SizeDelta | 
                    DrivenTransformProperties.Scale);

                rect.anchorMin = Vector2.up;
                rect.anchorMax = Vector2.up;
                rect.sizeDelta = cellSize;
                rect.localScale = cellScale;
            }

            return;
        }

        float width = rectTransform.rect.size.x;
        float height = rectTransform.rect.size.y;

        int cellCountX = 1;
        int cellCountY = 1;
        if (m_Constraint == Constraint.FixedColumnCount)
        {
            cellCountX = m_ConstraintCount;

            if (rectChildrenCount > cellCountX)
                cellCountY = rectChildrenCount / cellCountX + (rectChildrenCount % cellCountX > 0 ? 1 : 0);
        }
        else if (m_Constraint == Constraint.FixedRowCount)
        {
            cellCountY = m_ConstraintCount;

            if (rectChildrenCount > cellCountY)
                cellCountX = rectChildrenCount / cellCountY + (rectChildrenCount % cellCountY > 0 ? 1 : 0);
        }
        else
        {
            if (preferredCellSize.x + spacing.x <= 0)
                cellCountX = int.MaxValue;
            else
                cellCountX = Mathf.Max(1, Mathf.FloorToInt((width - padding.horizontal + spacing.x + 0.001f) / (preferredCellSize.x + spacing.x)));

            if (preferredCellSize.y + spacing.y <= 0)
                cellCountY = int.MaxValue;
            else
                cellCountY = Mathf.Max(1, Mathf.FloorToInt((height - padding.vertical + spacing.y + 0.001f) / (preferredCellSize.y + spacing.y)));
        }

        int cornerX = (int)startCorner % 2;
        int cornerY = (int)startCorner / 2;

        int cellsPerMainAxis, actualCellCountX, actualCellCountY;
        if (startAxis == Axis.Horizontal)
        {
            cellsPerMainAxis = cellCountX;
            actualCellCountX = Mathf.Clamp(cellCountX, 1, rectChildrenCount);

            if (m_Constraint == Constraint.FixedRowCount)
                actualCellCountY = Mathf.Min(cellCountY, rectChildrenCount);
            else
                actualCellCountY = Mathf.Clamp(cellCountY, 1, Mathf.CeilToInt(rectChildrenCount / (float)cellsPerMainAxis));
        }
        else
        {
            cellsPerMainAxis = cellCountY;
            actualCellCountY = Mathf.Clamp(cellCountY, 1, rectChildrenCount);

            if (m_Constraint == Constraint.FixedColumnCount)
                actualCellCountX = Mathf.Min(cellCountX, rectChildrenCount);
            else
                actualCellCountX = Mathf.Clamp(cellCountX, 1, Mathf.CeilToInt(rectChildrenCount / (float)cellsPerMainAxis));
        }

        Vector2 requiredSpace = new Vector2(
            actualCellCountX * preferredCellSize.x + (actualCellCountX - 1) * spacing.x,
            actualCellCountY * preferredCellSize.y + (actualCellCountY - 1) * spacing.y
        );
        Vector2 startOffset = new Vector2(
            GetStartOffset(0, requiredSpace.x),
            GetStartOffset(1, requiredSpace.y)
        );

        // Fixes case 1345471 - Makes sure the constraint column / row amount is always respected
        int childrenToMove = 0;
        if (rectChildrenCount > m_ConstraintCount && Mathf.CeilToInt((float)rectChildrenCount / (float)cellsPerMainAxis) < m_ConstraintCount)
        {
            childrenToMove = m_ConstraintCount - Mathf.CeilToInt((float)rectChildrenCount / (float)cellsPerMainAxis);
            childrenToMove += Mathf.FloorToInt((float)childrenToMove / ((float)cellsPerMainAxis - 1));
            if (rectChildrenCount % cellsPerMainAxis == 1)
                childrenToMove += 1;
        }

        for (int i = 0; i < rectChildrenCount; i++)
        {
            int positionX;
            int positionY;
            if (startAxis == Axis.Horizontal)
            {
                if (m_Constraint == Constraint.FixedRowCount && rectChildrenCount - i <= childrenToMove)
                {
                    positionX = 0;
                    positionY = m_ConstraintCount - (rectChildrenCount - i);
                }
                else
                {
                    positionX = i % cellsPerMainAxis;
                    positionY = i / cellsPerMainAxis;
                }
            }
            else
            {
                if (m_Constraint == Constraint.FixedColumnCount && rectChildrenCount - i <= childrenToMove)
                {
                    positionX = m_ConstraintCount - (rectChildrenCount - i);
                    positionY = 0;
                }
                else
                {
                    positionX = i / cellsPerMainAxis;
                    positionY = i % cellsPerMainAxis;
                }
            }

            if (cornerX == 1)
                positionX = actualCellCountX - 1 - positionX;
            if (cornerY == 1)
                positionY = actualCellCountY - 1 - positionY;
            
            var rect = rectChildren[i];
            if (rect)
            {
                SetChildAlongAxisWithScale(rectChildren[i], 0, startOffset.x + (preferredCellSize[0] + spacing[0]) * positionX, cellSize[0], m_CellScale[0]);
                SetChildAlongAxisWithScale(rectChildren[i], 1, startOffset.y + (preferredCellSize[1] + spacing[1]) * positionY, cellSize[1], m_CellScale[1]);
            }
        }
    }
}

#if UNITY_EDITOR
[CustomEditor(typeof(CustomGridLayoutGroup), true)]
public class CustomGridLayoutGroupEditor : GridLayoutGroupEditor
{
    SerializedProperty m_CellScale;
    
    protected override void OnEnable()
    {
        base.OnEnable();
        m_CellScale = serializedObject.FindProperty("m_CellScale");
    }
    
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUILayout.PropertyField(m_CellScale);
        serializedObject.ApplyModifiedProperties();
        base.OnInspectorGUI();
    }
}
#endif


