using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Debug = System.Diagnostics.Debug;

public static class MeshUtility
{
    private const int SEGMENTS_WHEN_360_ANGLE = 36;
    private const int FULL_ANGLE = 360;

    public static Mesh MakeCircleMesh(int angle, bool useUnionUV, int innerRadiusPercent = 0)
    {
        innerRadiusPercent = Math.Clamp(innerRadiusPercent, 0, 99);
        return innerRadiusPercent == 0 ? MakeCircleMesh_Internal(angle, useUnionUV) : MakeCircleMeshHasInner(angle, useUnionUV, innerRadiusPercent);
    }
    
    private static Mesh MakeCircleMeshHasInner(int angle, bool useUnionUV, int innerRadiusPercent)
    {
        angle = Math.Clamp(angle, 0, FULL_ANGLE);
        if (angle == 0)
            return null;

        var radius = 1f;
        var innerRadius = radius * (innerRadiusPercent / 100f);

        var segments = SEGMENTS_WHEN_360_ANGLE * (angle / FULL_ANGLE);

        var meshData = new Mesh();

        var count = segments * 6;

        // 정점 계산
        var vertices = new Vector3[count];
        var uvs = new Vector2[count];

        var angleStep = ((float)angle / segments) * Mathf.Deg2Rad;
        var startAngle = (-angle / 2f) * Mathf.Deg2Rad; // 시작 각도 조정

        for (var i = 0; i < segments; i++)
        {
            var idx = i * 6;
            var currentAngle = startAngle + i * angleStep;
            var nextAngle = startAngle + (i + 1) * angleStep;

            //inner vertices
            vertices[idx] = new Vector3(Mathf.Sin(currentAngle) * innerRadius, 0f, Mathf.Cos(currentAngle) * innerRadius);
            vertices[idx + 1] = new Vector3(Mathf.Sin(currentAngle) * radius, 0f, Mathf.Cos(currentAngle) * radius);
            vertices[idx + 2] = new Vector3(Mathf.Sin(nextAngle) * innerRadius, 0f, Mathf.Cos(nextAngle) * innerRadius);

            //out vertices
            vertices[idx + 3] = new Vector3(Mathf.Sin(nextAngle) * innerRadius, 0f, Mathf.Cos(nextAngle) * innerRadius);
            vertices[idx + 4] = new Vector3(Mathf.Sin(currentAngle) * radius, 0f, Mathf.Cos(currentAngle) * radius);
            vertices[idx + 5] = new Vector3(Mathf.Sin(nextAngle) * radius, 0f, Mathf.Cos(nextAngle) * radius);

            //uvs
            if (useUnionUV)
            {
                for (var j = idx; j < idx + 6; j++)
                {
                    uvs[j] = (new Vector2(vertices[j].x, vertices[j].z) / 2) + new Vector2(0.5f, 0.5f);
                }
            }
            else
            {
                //inner uvs
                uvs[idx] = new Vector2(0f, 0f);
                uvs[idx + 1] = new Vector2(0f, 1f);
                uvs[idx + 2] = new Vector2(1f, 0f);
                //out uvs
                uvs[idx + 3] = new Vector2(1f, 0f);
                uvs[idx + 4] = new Vector2(0f, 1f);
                uvs[idx + 5] = new Vector2(1f, 1f);
            }
        }

        meshData.vertices = vertices;
        meshData.triangles = Enumerable.Range(0, count).ToArray();
        meshData.uv = uvs;
        meshData.RecalculateNormals();
        meshData.RecalculateBounds();

        return meshData;
    }

    private static Mesh MakeCircleMesh_Internal(int angle, bool useUnionUV)
    {
        angle = Math.Clamp(angle, 0, FULL_ANGLE);
        if (angle == 0)
            return null;

        var radius = 1f;

        var segments = Mathf.CeilToInt(SEGMENTS_WHEN_360_ANGLE * ((float)angle / FULL_ANGLE));

        var meshData = new Mesh();

        var count = segments * 3;

        // 정점 계산
        var vertices = new Vector3[count];
        var uvs = new Vector2[count];

        var angleStep = (float)angle / segments * Mathf.Deg2Rad;
        var startAngle = (-angle / 2f) * Mathf.Deg2Rad; // 시작 각도 조정

        for (var i = 0; i < segments; i++)
        {
            var idx = i * 3;
            var currentAngle = startAngle + i * angleStep;
            var nextAngle = startAngle + (i + 1) * angleStep;

            //inner vertices
            vertices[idx] = new Vector3(0f, 0f, 0f);
            vertices[idx + 1] = new Vector3(Mathf.Sin(currentAngle) * radius, 0f, Mathf.Cos(currentAngle) * radius);
            vertices[idx + 2] = new Vector3(Mathf.Sin(nextAngle) * radius, 0f, Mathf.Cos(nextAngle) * radius);
            
            //uvs
            if (useUnionUV)
            {
                for (var j = idx; j < idx + 3; j++)
                {
                    uvs[j] = (new Vector2(vertices[j].x, vertices[j].z) / 2) + new Vector2(0.5f, 0.5f);
                }
            }
            else
            {
                uvs[idx] = new Vector2(0.5f, 0f);
                uvs[idx + 1] = new Vector2(0f, 1f);
                uvs[idx + 2] = new Vector2(1f, 1f);
            }
        }

        meshData.vertices = vertices;
        meshData.triangles = Enumerable.Range(0, count).ToArray();
        meshData.uv = uvs;
        meshData.RecalculateNormals();
        meshData.RecalculateBounds();

        return meshData;
    }

    private static Mesh rectMesh = null;
    public static Mesh MakeRectMesh()
    {
        if (rectMesh != null)
            return rectMesh;

        rectMesh = new()
        {
            vertices = new Vector3[]
            {
                new(-0.5f, 0f, 0.5f), //left top
                new(0.5f, 0f, 0.5f), //right top
                new(0.5f, 0f, -0.5f), //right bottom
                new(-0.5f, 0f, -0.5f) //left bottom
            },
            uv = new Vector2[]
            {
                new(0, 1),
                new(1, 1),
                new(1, 0),
                new(0, 0)
            },
            triangles = new[]
            {
                0, 1, 2,
                2, 3, 0
            }
        };

        // 법선 벡터 재계산
        rectMesh.RecalculateNormals();
        rectMesh.RecalculateBounds();

        return rectMesh;
    }
    
}