using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using System.IO;
using UnityEditor.VersionControl;

public class GradientTextureMaker : OdinEditorWindow
{

    [System.Serializable]
    struct GradientData
    {
        public Gradient Gradient;
        public Material TargetMat;
        public TextureWrapMode WrapMode;
        public string RefName;

        GradientData(Gradient gradient = null, Material material = null, TextureWrapMode wrapMode = TextureWrapMode.Clamp, string refName = "_RempTex" )
        {
            if(gradient == null )
            {
                Gradient = new Gradient();
            }
            else
            {
                Gradient = gradient;
            }
            TargetMat = null;
            WrapMode = wrapMode;
            RefName = refName;
        }
    }

    [SerializeField]
    private bool usePreview = false; // if use Preview, _RefName get null (get temp texture ref);

    [SerializeField]
    List <GradientData> m_gradientDatas = new();
    private const int resolution = 256;

    [MenuItem("Tools/GradientTextureMaker")]
    public static void OpenWindow() =>
        GetWindow<GradientTextureMaker>();


    private void UpdatePreview()
    {
        foreach(GradientData data in m_gradientDatas)
        {
            if(data.Gradient == null || data.TargetMat == null || data.RefName == "")
            {
                continue;
            }

            data.TargetMat.SetTexture(data.RefName, GetGraidentTex(data.Gradient, data.WrapMode));
        }
    }

    [Button]
    private void RenderAndSetGradientTexture()
    {
        foreach(GradientData data in m_gradientDatas)
        {
            if (data.Gradient == null || data.TargetMat == null || data.RefName == "")
            {
                Debug.LogError("Data has null value!");
                continue;
            }

            Texture2D textureData = GetGraidentTex(data.Gradient, data.WrapMode);
            byte[] pngData = textureData.EncodeToPNG();

            if(pngData == null || pngData.Length == 0 )
            {
                Debug.LogError("Can't Save PNG Data. PNG Data is null or 0.");
                return;
            }

            string matPath = System.IO.Path.GetDirectoryName(AssetDatabase.GetAssetPath(data.TargetMat));
            string filePath = Path.Combine(matPath, "GradientTexture", "T_" + data.TargetMat.name + data.RefName + ".png");
            string directoryPath = Path.GetDirectoryName(filePath);

            try
            {
                if(!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(filePath));
                }

                File.WriteAllBytes(filePath, pngData);
                Debug.Log("PNG Saved: " + filePath);
            }
            catch
            {
                Debug.LogError("Can't Save PNG.");
                Debug.Log(filePath);
                return;
            }

            AssetDatabase.ImportAsset(filePath);

            Texture2D newTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(filePath);
            newTexture.filterMode = FilterMode.Bilinear;
            newTexture.wrapMode = data.WrapMode;
            data.TargetMat.SetTexture(data.RefName, newTexture);
        }

        usePreview = false;
    }

    Texture2D GetGraidentTex(Gradient gradient, TextureWrapMode wrapmode = TextureWrapMode.Clamp)
    {
        Texture2D texture = new Texture2D(resolution, 1, TextureFormat.RGBA32, false);
        texture.wrapMode = wrapmode;

        for (int y = 0; y < resolution; y++)
        {
            float t = (float) y / (resolution - 1);
            Color color = gradient.Evaluate(t);
            texture.SetPixel(y, 0, color);
        }

        texture.Apply();
        return texture;
    }

    [Button]
    private void ClearData()
    {
        m_gradientDatas.Clear();
    }


    [ExecuteAlways]
    public void Update()
    {
        if (usePreview)
        {
            UpdatePreview();
        }
    }

}
