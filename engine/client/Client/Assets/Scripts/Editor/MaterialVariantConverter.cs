using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class MaterialVariantConverter : EditorWindow
{
    private Material baseMaterial;

    [MenuItem("Tools/Material Variant Converter")]
    public static void ShowWindow()
    {
        GetWindow<MaterialVariantConverter>("Material Variant Converter");
    }

    private void OnGUI()
    {
        GUILayout.Label("Convert Existing Materials to Variants", EditorStyles.boldLabel);

        // Select the base material
        baseMaterial = (Material)EditorGUILayout.ObjectField("Base Material", baseMaterial, typeof(Material), false);

        // Display the number of selected materials
        int selectedMaterialCount = GetSelectedMaterials().Count;
        GUILayout.Label($"Selected Materials: {selectedMaterialCount}", EditorStyles.label);

        // Button to execute the conversion
        if (GUILayout.Button("Convert Selected Materials to Variants"))
        {
            ConvertMaterialsToVariants();
        }
    }

    private List<Material> GetSelectedMaterials()
    {
        List<Material> materials = new List<Material>();
        foreach (Object obj in Selection.objects)
        {
            if (obj is Material material)
            {
                materials.Add(material);
            }
        }
        return materials;
    }

    private void ConvertMaterialsToVariants()
    {
        if (baseMaterial == null)
        {
            EditorUtility.DisplayDialog("Error", "Please select a base material.", "OK");
            return;
        }

        List<Material> existingMaterials = GetSelectedMaterials();

        if (existingMaterials.Count == 0)
        {
            EditorUtility.DisplayDialog("Error", "Please select at least one material in the Project window.", "OK");
            return;
        }

        // Check Unity version compatibility
        string[] versionParts = Application.unityVersion.Split('.');
        int majorVersion = int.Parse(versionParts[0]);
        int minorVersion = int.Parse(versionParts[1]);

        if (majorVersion < 2021 || (majorVersion == 2021 && minorVersion < 2))
        {
            EditorUtility.DisplayDialog("Error", "Material Variants are supported in Unity 2021.2 or newer.", "OK");
            return;
        }

        int materialsConverted = 0;

        foreach (Material existingMaterial in existingMaterials)
        {
            // Get the path of the existing material
            var existingMaterialPath = AssetDatabase.GetAssetPath(existingMaterial);

            // Material variantMaterial = Material.CreateMaterialVariant(baseMaterial, existingMaterialPath);
            //
            // if (variantMaterial == null)
            // {
            //     Debug.LogError($"Failed to create material variant for {existingMaterial.name}.");
            //     continue;
            // }
            //
            // // Copy overridden properties from the existing material to the new variant
            var name = existingMaterial.name;
            var texture = existingMaterial.mainTexture;
            
            EditorUtility.CopySerializedIfDifferent(baseMaterial, existingMaterial);
            
            if (existingMaterial.shader.name == baseMaterial.shader.name)
                existingMaterial.parent = baseMaterial;

            existingMaterial.name = name;
            existingMaterial.mainTexture = texture;

            materialsConverted++;
        }

        // Save the changes
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        // Inform the user
        EditorUtility.DisplayDialog("Success", $"Converted {materialsConverted} material(s) to variants.", "OK");
    }
}
