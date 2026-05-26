using System.Collections.Generic;
using System.IO;
using Commons.Resources;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEngine;

public class AudioTool : ResourceParseTool<ResourceAudio>
{
    public override void PostRetrievalProcess()
    {
    }
}


// namespace Commons.Resources
// {
//     public class AudioTool : OdinEditorWindow
//     {
//         private string _audioFolderPath = Path.Combine(Application.dataPath, "PatchResources/Sounds/");
//         [MenuItem("Tools/Resource Data Parser Tool/Audio Tool")]
//         private static void OpenWindow()
//         {
//             var audioTool = GetWindow<AudioTool>();
//             audioTool.Show();
//
//             audioTool.minSize = new Vector2(800, 400);
//         }
//
//         [TableList] public List<ResourceAudio> AudioResources;
//
//         [HorizontalGroup("Buttons", Width = 100, PaddingLeft = 10)]
//         [Button("자동생성", ButtonHeight = 50)]
//         public void Autogenerate()
//         {
//             AudioResources = new List<ResourceAudio>();
//             
//             string[] audioFiles = Directory.GetFiles(_audioFolderPath, "*.*", SearchOption.AllDirectories);
//             
//             foreach (string file in audioFiles)
//             {
//                 if (file.EndsWith(".mp3") || file.EndsWith(".wav") || file.EndsWith(".ogg") || file.EndsWith(".aiff"))
//                 {
//                     string relativePath = "Assets" + file.Substring(Application.dataPath.Length).Replace("\\", "/");
//                     Debug.Log(relativePath);
//                     
//                     AudioResources.Add(new ResourceAudio
//                     {
//                         Id = AudioResources.Count + 1,
//                         Name = Path.GetFileNameWithoutExtension(file),
//                         FilePath = relativePath
//                     });
//                 }
//             }
//         }
//
//         [HorizontalGroup("Buttons", Width = 100, PaddingLeft = 10)]
//         [Button("저장", ButtonHeight = 50)]
//         public void Save()
//         {
//             string json = JsonUtility.ToJson(new AudioResourcesWrapper { audios = AudioResources }, true);
//             string jsonPath = Path.Combine(Application.dataPath, "PatchResources/Audios.json");
//
//             File.WriteAllText(jsonPath, json);
//         }
//         
//         [System.Serializable]
//         public class AudioResourcesWrapper
//         {
//             public List<ResourceAudio> audios;
//         }
//     }
// }