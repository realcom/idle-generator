using System;
using System.Text;
using Core;
using UnityEditor;
using UnityEngine;

public class AssetBundleUploader: EditorWindow
{
    private static int _platform;
    private static uint _selectedTypes;
    
    private BuildTarget BuildTarget => _platform switch
    {
        0 => BuildTarget.Android,
        1 => BuildTarget.iOS,
        _ => BuildTarget.WebGL,
    };
    
#if !UNITY_WEBGL
    [MenuItem("Build/PatchResource Uploader")]
    public static void ShowWindow()
    {
        GetWindow<AssetBundleUploader>("PatchResource Uploader");
    }
#endif

    private void DrawLine()
    {
        var rect = EditorGUILayout.BeginHorizontal();
        Handles.color = Color.gray;
        Handles.DrawLine(new Vector2(rect.x, rect.y), new Vector2(rect.width, rect.y));
        EditorGUILayout.EndHorizontal();
    }
    
    private void OnGUI()
    {
        _platform = GUILayout.Toolbar(_platform, new []{ "Android", "iOS", "WebGL" }, GUILayout.Height(40));
        var incorrectPlatform = false;
#if UNITY_ANDROID
        incorrectPlatform = BuildTarget != BuildTarget.Android;
#elif UNITY_IOS
        incorrectPlatform = BuildTarget != BuildTarget.iOS;
#else 
        incorrectPlatform = BuildTarget != BuildTarget.WebGL;
#endif
        if (incorrectPlatform)
            EditorGUILayout.HelpBox("Change editor build platform before build", MessageType.Error);
        GUILayout.Space(15);
        
        //
        DrawLine();
        GUILayout.Space(15);
        
        //
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Select All", EditorStyles.miniButtonLeft))
            _selectedTypes = (uint)Constants.AssetBundleType.ALL;
        if (GUILayout.Button("Reset All", EditorStyles.miniButtonLeft))
            _selectedTypes = 0;
        GUILayout.EndHorizontal();
        
        foreach (Constants.AssetBundleType x in Enum.GetValues(typeof(Constants.AssetBundleType)))
        {
            if (x == Constants.AssetBundleType.ALL)
                continue;
            var prevValue = (_selectedTypes & (uint)x) != 0;
            var value = GUILayout.Toggle(prevValue, x.ToString().ToCamelCase(), GUILayout.Height(30));
            if (prevValue != value)
            {
                if (value)
                    _selectedTypes += (uint)x;
                else
                    _selectedTypes -= (uint)x;
            }
        }
        
        //
        GUILayout.Space(15);
        DrawLine();
        GUILayout.Space(15);
        
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Deploy (Prod)", GUILayout.Height(40)))
        {
            Deploy();
        }
        if (GUILayout.Button("Deploy Commons Only (Prod)", GUILayout.Height(40)))
        {
            DeployCommons();
        }
        if (GUILayout.Button("Build & Upload (Dev)", GUILayout.Height(40)))
        {
            if (!incorrectPlatform)
                BuildAndUpload();
        }
        GUILayout.EndHorizontal();
    }

    private void Deploy()
    {
        if (EditorUtility.DisplayDialog("주의", "이 작업은 되돌릴 수 없습니다.", "배포", "취소"))
            AssetBundleEditor.Deploy(BuildTarget);
    }

    private void DeployCommons()
    {
        if (EditorUtility.DisplayDialog("주의", "이 작업은 되돌릴 수 없습니다.", "배포", "취소"))
            AssetBundleEditor.Deploy(BuildTarget, "Commons");
    }

    private void BuildAndUpload()
    {
        var builder = new StringBuilder();
        builder.AppendLine($">Info: {BuildTarget.ToString()} (v{Utility.GetVersionInt(PlayerSettings.bundleVersion)})");
        builder.AppendLine($">Commit: {SlackMessageSender.GetLocalHeadCommit()}");
        builder.AppendLine($">Selected Bundle Type: {SelectedTypeToString(_selectedTypes)}");
        
        AssetBundleEditor.UploadFile(AssetBundleEditor.Build(BuildTarget, _selectedTypes), builder);
    }
    
    private static string SelectedTypeToString(uint selectedType)
    {
        var sb = new StringBuilder();
        var flag = (Constants.AssetBundleType)selectedType;
        if (flag is Constants.AssetBundleType.ALL)
        {
            sb.Append($"{flag.ToString()}");
            return sb.ToString();
        }
        
        foreach (Constants.AssetBundleType x in Enum.GetValues(typeof(Constants.AssetBundleType)))
        {
            if (x is Constants.AssetBundleType.ALL)
                continue;
            
            if ((flag & x) != 0)
            {
                sb.Append($"{x.ToString()}, ");
            }
        }

        var str = sb.ToString();
        return str[..str.LastIndexOf(',')];
    }
    
}
