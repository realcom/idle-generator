using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEditor.Callbacks;
using System.Xml;
using SimpleJSON;
using System.Text.RegularExpressions;
using System.Linq;
using Assets.Scripts.Core;
using Commons;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using Google.Protobuf;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NUnit.Framework.Internal;
using Unity.AI.Navigation;
using UnityEditor.Animations;
using UnityEditor.AssetImporters;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;
using Resources = Commons.Resources.Resources;

#if UNITY_IOS
using UnityEditor.iOS.Xcode;
using AppleAuth.Editor;
#endif

public static class Market {
	public const string GOOGLE = "google";
	public const string APPLE = "apple";
	public const string ONE_STORE = "one_store";
	public const string UNKNOWN = "unknown";
}

public class Extensions {

	private const string KEYSTORE_PASS = "2O79okf1tchClqIvuzK6MNb9cG0";

	private static void SetupBuild (string market) {
		string className = "CurrentBundleMarket";
		using (StreamWriter writer = new StreamWriter ("Assets/Scripts/" + className + ".cs", false)) {
			try {

				string code = "public static class " + className + "\n{\n";
				code += string.Format ("#if UNITY_ANDROID\n"
					+ "\tpublic const string market = \"{0}\";\n"
					+ "#elif UNITY_IPHONE\n"
					+ "\tpublic const string market = Market.APPLE;\n"
					+ "#else\n"
					+ "\tpublic const string market = Market.GOOGLE;\n"
					+ "#endif\n", market);
				code += "\n}\n";
				writer.WriteLine ("{0}", code);
			} catch (System.Exception ex) {
				string msg = " threw:\n" + ex.ToString ();
				Debug.LogError (msg);
				EditorUtility.DisplayDialog ("Error when trying to regenerate class", msg, "OK");
			}
		}
		
		#if UNITY_5_4_OR_NEWER
		PlayerSettings.stripEngineCode = false;
		#endif
		BundleVersionChecker.Check ();

		//
		PlayerSettings.SplashScreen.show = false;
		PlayerSettings.SplashScreen.showUnityLogo = false;
		
		//
		if (market == Market.APPLE)
			PlayerSettings.defaultInterfaceOrientation = UIOrientation.AutoRotation;
		else
			PlayerSettings.defaultInterfaceOrientation = UIOrientation.Portrait;

		//
#if !UNITY_CLOUD_BUILD
		EditorSceneManager.OpenScene(EditorBuildSettings.scenes[0].path);
#endif
	}

	private static string[] GetScenes() {
		return EditorBuildSettings.scenes.Select (x => x.path).Where(
			x => !x.Contains("Error") && !x.Contains("PatchResources/")
		).ToArray ();
	}

	[PostProcessScene]
	static void PostSceneBuild() {
		#if UNITY_ANDROID
		if (Application.loadedLevelName == "Error"
			|| EditorApplication.currentScene.Contains("Error")) {
			PlayerSettings.Android.keyaliasPass = "";
			throw new Exception("Normal build not supported.");
			return;
		}
		#endif
	}

	public static void PerformBuild()
	{
		BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
		// load all used scenes
		buildPlayerOptions.scenes = EditorBuildSettings.scenes.Select(x => x.path).ToArray();
		buildPlayerOptions.locationPathName = "../Build";
		buildPlayerOptions.target = BuildTarget.WebGL;

		BuildPipeline.BuildPlayer(buildPlayerOptions);
	}

    // public const string PACKAGE_NAME = "net.puzzlemonsters.saga";
	public const string APK_NAME = "Hamster";




	[MenuItem("Build/Bump Bundle Minor Version")]
	private static void BumpBundleMinorVersion()
	{
#if !UNITY_CLOUD_BUILD
		var previousVersion = PlayerSettings.bundleVersion;
		int versionInt = Utility.GetVersionInt(previousVersion);

		versionInt += 1; // Minor만 증가
		ApplyBundleVersionChange(previousVersion, versionInt);
#endif
	}

	[MenuItem("Build/Bump Bundle Major Version")]
	private static void BumpBundleMajorVersion()
	{
#if !UNITY_CLOUD_BUILD
		var previousVersion = PlayerSettings.bundleVersion;
		var versionInt = Utility.GetVersionInt(PlayerSettings.bundleVersion);

		int epoch = versionInt / 1_000_000;
        int major = (versionInt / 1_000) % 1_000;
        major += 1;

        int versionNew = epoch * 1_000_000 + major * 1_000;
        ApplyBundleVersionChange(previousVersion, versionNew);
		// BundleVersionChecker.Check(true);
#endif
	}
	
	private static void ApplyBundleVersionChange(string previousVersion, int versionInt)
    {
        string newVersion = Utility.GetVersionString(versionInt);

        PlayerSettings.bundleVersion = newVersion;
        PlayerSettings.Android.bundleVersionCode = versionInt;
        PlayerSettings.iOS.buildNumber = newVersion;

        AssetDatabase.SaveAssets();
        EditorUtility.DisplayDialog("Version Bumped", $"Previous version: {previousVersion}\nNew version: {newVersion}", "OK");
    }
	
	
#if UNITY_ANDROID
	[MenuItem("Build/Android - Prod(AAB)")]
	static void Build_AndroidGoogle()
	{
		var buildOptions = BuildOptions.None;
		BuildAndroidProduction(buildOptions, true);
	}

	[MenuItem("Build/Android - Prod(APK)")]
	static void Build_AndroidGoogleAPK()
	{
		var buildOptions = BuildOptions.None;
		BuildAndroidProduction(buildOptions, false);
	}
	
	[MenuItem("Build/Android - Prod run")]
	static void Build_AndroidGoogleRun()
	{
		var buildOptions = BuildOptions.AutoRunPlayer|BuildOptions.Development|BuildOptions.EnableDeepProfilingSupport;
		BuildAndroidProduction(buildOptions, false);
	}
	
	
	private static void BuildAndroidProduction(BuildOptions buildOptions, bool buildAppBundle)
	{
		PlayerSettings.Android.keystoreName = Path.Combine(Application.dataPath, "..", "androidkey.keystore");
		PlayerSettings.Android.keystorePass = PlayerSettings.Android.keyaliasPass = KEYSTORE_PASS;
		// BumpBundleVersion();
		SetupBuild (Market.GOOGLE);

		// PlayerSettings.applicationIdentifier = PACKAGE_NAME;
		//
		PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.IL2CPP);
		// PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64 | AndroidArchitecture.ARMv7 | AndroidArchitecture.X86;
		EditorUserBuildSettings.androidCreateSymbolsZip = true; 
		EditorUserBuildSettings.buildAppBundle = buildAppBundle;

#if !UNITY_CLOUD_BUILD
		BuildPipeline.BuildPlayer (GetScenes(),
			APK_NAME + "_{0}.{1}".SFormat (Market.GOOGLE,buildAppBundle ? "aab" : "apk"), BuildTarget.Android, buildOptions);
#endif
	}
	
	[MenuItem("Build/Android - Dev")]
	static void Build_AndroidDev()
    {
        PlayerSettings.Android.keystoreName = Path.Combine(Application.dataPath, "..", "androidkey.keystore");
        PlayerSettings.Android.keystorePass = PlayerSettings.Android.keyaliasPass = KEYSTORE_PASS;
        SetupBuild (Market.GOOGLE);

        //
        PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.Mono2x);
		EditorUserBuildSettings.buildAppBundle = false;  
		// PlayerSettings.Android.targetArchitectures = AndroidArchitecture.All;
		BuildPipeline.BuildPlayer (GetScenes(),
                                   APK_NAME + "_dev.apk".SFormat (Market.GOOGLE),
		                           BuildTarget.Android,
		                           BuildOptions.Development|BuildOptions.EnableDeepProfilingSupport);
	}
	
	[MenuItem("Build/Android - Dev Run")]
	static void Build_AndroidDevRun()
    {
        PlayerSettings.Android.keystoreName = Path.Combine(Application.dataPath, "..", "androidkey.keystore");
        PlayerSettings.Android.keystorePass = PlayerSettings.Android.keyaliasPass = KEYSTORE_PASS;
        SetupBuild (Market.GOOGLE);

        //
        PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.Mono2x);

		BuildPipeline.BuildPlayer (GetScenes(),
                                   APK_NAME + "_dev.apk".SFormat (Market.GOOGLE),
		                           BuildTarget.Android,
		                           BuildOptions.AutoRunPlayer|BuildOptions.Development|BuildOptions.EnableDeepProfilingSupport);
	}

#endif

#if UNITY_IOS
	[MenuItem("Build/iOS - Prod")]
	static void Build_IOS()
	{
		SetupBuild (Market.APPLE);

#if !UNITY_CLOUD_BUILD
		BuildPipeline.BuildPlayer (GetScenes(),
			"Build_ios".SFormat (Market.APPLE), BuildTarget.iOS, BuildOptions.AutoRunPlayer);
#endif
	}

	[MenuItem("Build/iOS - Dev")]
	static void Build_IOSDev()
	{
		SetupBuild (Market.APPLE);

		BuildPipeline.BuildPlayer (GetScenes(),
			"Build_ios".SFormat (Market.APPLE), BuildTarget.iOS, BuildOptions.AutoRunPlayer|BuildOptions.Development);
	}
#endif

#if UNITY_WEBGL

	private enum CodeOptimization
	{
		BuildTimes,
		RuntimeSpeed,
		RuntimeSpeedLTO,
		DiskSize,
		DiskSizeLTO,
	}

	[MenuItem("Build/WebGL - Prod")]
	static void Build_WebGL()
	{
		EditorUserBuildSettings.SetPlatformSettings(BuildPipeline.GetBuildTargetName(BuildTarget.WebGL),
			"CodeOptimization", CodeOptimization.RuntimeSpeed.ToString());
		PlayerSettings.WebGL.template = "PROJECT:nsquad";
    
		var report = BuildPipeline.BuildPlayer(GetScenes(),
			"../Build",
			BuildTarget.WebGL,
			BuildOptions.None);

		if (report.summary.result == BuildResult.Succeeded)
		{
			var option = EditorUtility.DisplayDialogComplex("Build Successful",
				"Do you want to bump the version?",
				"Bump Major Version",
				"No",
				"Bump Minor Version"
				);

			switch (option)
			{
				case 0:
					BumpBundleMajorVersion();
					break;
				case 1:
					break;
				case 2:
					BumpBundleMinorVersion();
					break;
			}
		}
		else
			Debug.LogError("Build failed: " + report.summary.result);
	}

	[MenuItem("Build/WebGL - Dev")]
	static void Build_WebGLDev()
	{
		EditorUserBuildSettings.SetPlatformSettings(BuildPipeline.GetBuildTargetName(BuildTarget.WebGL),
			"CodeOptimization", CodeOptimization.BuildTimes.ToString());
		PlayerSettings.WebGL.template = "PROJECT:nsquad-dev";
		BuildPipeline.BuildPlayer (GetScenes(),
			"WebGL",
			BuildTarget.WebGL,
			BuildOptions.Development);
	}
#endif

	[MenuItem("Tools/Take screenshot")]
    static void Screenshot()
    {
        var path = Environment.GetFolderPath(Environment.SpecialFolder.MyPictures);
        ScreenCapture.CaptureScreenshot(Path.Combine(path, "screenshot_{0}.png".SFormat((long)Utility.GetTime())));
    }

    private static JSONNode DumpBounds(string name, Transform tr)
    {
		var d = new JSONClass();
		d["name"] = new JSONData(name);
		if (tr is RectTransform rectTransform)
		{
			var rect = rectTransform.rect;
			d["xmin"] = new JSONData(tr.position.x + rect.xMin);
			d["xmax"] = new JSONData(tr.position.x + rect.xMax);
			d["ymin"] = new JSONData(tr.position.y + rect.yMin);
			d["ymax"] = new JSONData(tr.position.y + rect.yMax);
		}
		else
		{
			d["xmin"] = new JSONData(tr.position.x - tr.localScale.x/2f);
			d["xmax"] = new JSONData(tr.position.x + tr.localScale.x/2f);
			d["ymin"] = new JSONData(tr.position.z - tr.localScale.z/2f);
			d["ymax"] = new JSONData(tr.position.z + tr.localScale.z/2f);
		}
		d["dir"] = new JSONData(tr.rotation.eulerAngles.y);
		return d;
	}

    private static JSONNode DumpBounds(Vector3 center, Vector3 size)
    {
		var d = new JSONClass();
		d["xmin"] = new JSONData(center.x - size.x / 2f);
		d["xmax"] = new JSONData(center.x + size.x / 2f);
		d["ymin"] = new JSONData(center.y - size.y / 2f);
		d["ymax"] = new JSONData(center.y + size.y / 2f);
		return d;
	}

	[MenuItem("Tools/PostProcess iOS")]
	static void PostProcessIos() {
		OnPostProcessBuild (EditorUserBuildSettings.activeBuildTarget, Path.Combine(Application.dataPath, "../Build_ios"));
	}
	
	private static void DirectoryCopy(string sourceDirName, string destDirName, bool copySubDirs)
	{
		// Get the subdirectories for the specified directory.
		DirectoryInfo dir = new DirectoryInfo(sourceDirName);
		
		if (!dir.Exists)
		{
			throw new DirectoryNotFoundException(
				"Source directory does not exist or could not be found: "
				+ sourceDirName);
		}
		
		DirectoryInfo[] dirs = dir.GetDirectories();
		// If the destination directory doesn't exist, create it.
		if (!Directory.Exists(destDirName))
		{
			Directory.CreateDirectory(destDirName);
		}
		
		// Get the files in the directory and copy them to the new location.
		FileInfo[] files = dir.GetFiles();
		foreach (FileInfo file in files)
		{
			string temppath = Path.Combine(destDirName, file.Name);
			file.CopyTo(temppath, false);
		}
		
		// If copying subdirectories, copy them and their contents to new location.
		if (copySubDirs)
		{
			foreach (DirectoryInfo subdir in dirs)
			{
				string temppath = Path.Combine(destDirName, subdir.Name);
				DirectoryCopy(subdir.FullName, temppath, copySubDirs);
			}
		}
	}

	[MenuItem("Tools/Clear PlayerPrefs")]
	static void ClearPlayerPrefs() {
		PlayerPrefs.DeleteAll();
		PlayerPrefs.Save();
	}
	
	[PostProcessBuild(500)]
	public static void OnPostProcessBuild(BuildTarget target, string path)
	{
#if UNITY_IOS
		if (target == BuildTarget.iOS)
		{

#if UNITY_CLOUD_BUILD
			FileUtil.DeleteFileOrDirectory(Path.Combine(path, "Pods"));
			FileUtil.DeleteFileOrDirectory(Path.Combine(path, "Podfile.lock"));
#endif 
			var projectPath = PBXProject.GetPBXProjectPath(path);

			var plistPath = path + "/Info.plist";
			var plistDoc = new PlistDocument();
			plistDoc.ReadFromFile(plistPath);
			
			var appTransportSecurity = plistDoc.root.CreateDict("NSAppTransportSecurity");
			appTransportSecurity["NSAllowsArbitraryLoads"] = new PlistElementBoolean(true);
			
			var exceptionDomains = appTransportSecurity.CreateDict("NSExceptionDomains");
			var domainSettings = appTransportSecurity.CreateDict("puzzlemonsters.io");
			domainSettings["NSExceptionAllowsInsecureHTTPLoads"] = new PlistElementBoolean(true);
			domainSettings["NSIncludesSubdomains"] = new PlistElementBoolean(true);
			exceptionDomains["puzzlemonsters.io"] = domainSettings; 
			appTransportSecurity["NSExceptionDomains"] = exceptionDomains;
			plistDoc.root.SetBoolean("ITSAppUsesNonExemptEncryption", false);
			plistDoc.WriteToFile(plistPath);



		
			//
			string unityTargetName;
			string xcodeProjectPath;
			string xcodeProjectText;
#if UNITY_2019_3_OR_NEWER
			unityTargetName = "Unity-iPhone";
			xcodeProjectPath = path + "/" + unityTargetName + ".xcodeproj/project.pbxproj";
			xcodeProjectText = File.ReadAllText(xcodeProjectPath);
#else
			unityTargetName = PBXProject.GetUnityTargetName();
			xcodeProjectPath = path + "/" + unityTargetName + ".xcodeproj/project.pbxproj";
			xcodeProjectText = File.ReadAllText(xcodeProjectPath);
#endif

			//
			Regex codeSignEntitlements = new Regex(@"CODE_SIGN_ENTITLEMENTS\s*=\s*\""(.+)\""");
			Match match = codeSignEntitlements.Match(xcodeProjectText);
			string entitlementsFileName;
			if (match.Success)
			{
				entitlementsFileName = match.Groups[1].Value;
			}
			else
			{
				string productName = Regex.Match(xcodeProjectText, @"PRODUCT_NAME\s*=\s*(.+);").Groups[1].Value;
				entitlementsFileName = string.Format("{0}/{1}.entitlements", unityTargetName, productName);
			}
			string entitlementsFullFileName = path + "/" + entitlementsFileName;

			//
			ProjectCapabilityManager manager;
			
			PBXProject project;
#if UNITY_2019_3_OR_NEWER
			project = new PBXProject();
			project.ReadFromString(File.ReadAllText(projectPath));
			manager = new ProjectCapabilityManager(projectPath, "Entitlements.entitlements", null, project.GetUnityMainTargetGuid());
			manager.AddSignInWithAppleWithCompatibility();
			// manager.AddSignInWithAppleWithCompatibility(project.GetUnityFrameworkTargetGuid());
#else
			manager = new ProjectCapabilityManager(projectPath, entitlementsFullFileName, PBXProject.GetUnityTargetName());
			manager.AddSignInWithAppleWithCompatibility();
#endif
			manager.AddPushNotifications(false);
			manager.AddBackgroundModes(BackgroundModesOptions.RemoteNotifications);
			manager.AddGameCenter();
			manager.AddInAppPurchase();
			manager.WriteToFile();

			

		
			



			
			//
			// project = new PBXProject();
			// project.ReadFromString(File.ReadAllText(projectPath));
   //
   //          var projectGuid = project.ProjectGuid();
   //          project.AddBuildProperty(projectGuid, "OTHER_LDFLAGS", "-lz");
   //
			// var targetGuid = project.TargetGuidByName(unityTargetName);
			// var resources = new List<string>
			// {
			// 	"Plugins/iOS/Resources/AppGuard/appguard",
			// 	"Plugins/iOS/Resources/AppGuard/appguard.crt",
			// 	"Plugins/iOS/Resources/AppGuard/appguard.mf",
			// 	"Plugins/iOS/Resources/AppGuard/appguard106000",
			// };
			// foreach (var resource in resources)
			// {
			// 	var resourcePath = Path.Combine(Application.dataPath, resource);
			// 	var resourcesBuildPhase = project.GetResourcesBuildPhaseByTarget(targetGuid);
			// 	var resourcesFilesGuid = project.AddFile(resourcePath, resourcePath, PBXSourceTree.Source);
			// 	project.AddFileToBuildSection(targetGuid, resourcesBuildPhase, resourcesFilesGuid);
			// }
			// File.WriteAllText(projectPath, project.WriteToString());
		}
#endif
	}

	protected static string Load(string fullPath)
	{
		string data;
		FileInfo projectFileInfo = new FileInfo(fullPath);
		StreamReader fs = projectFileInfo.OpenText();
		data = fs.ReadToEnd();
		fs.Close();
		
		return data;
	}
	
	protected static void Save(string fullPath, string data)
	{
		System.IO.StreamWriter writer = new System.IO.StreamWriter(fullPath, false);
		writer.Write(data);
		writer.Close();
	}



    [MenuItem("Tools/Set landscape &9")]
    public static void SetLandscape()
    {
        //Resolution.SetScreenWidthAndHeightFromEditorGameViewViaReflection(800, 480);
        /*
        var canvas = GameObject.Find("Canvas");
        if (canvas != null)
        {
            canvas.SetActive(false);
            canvas.SetActive(true);
        }

        SuperLayoutElement.RefreshAll();
        */
    }

    [MenuItem("Tools/Set portrait &0")]
    public static void SetPortrait()
    {
        //Resolution.SetScreenWidthAndHeightFromEditorGameViewViaReflection(480, 800);
        /*
        var canvas = GameObject.Find("Canvas");
        if (canvas != null)
        {
            canvas.SetActive(false);
            canvas.SetActive(true);
        }

        SuperLayoutElement.RefreshAll();
        */
    }

	//
	[MenuItem("Assets/Clone Unit", true)]
	static bool CloneUnitValidation()
	{
		return Selection.activeObject && Selection.activeObject is GameObject;
	}

	[MenuItem("Assets/Clone Unit")]
	static void CloneUnit()
	{
		var obj = Selection.activeGameObject;
		//string basePath = "Assets/PatchResources/Units/" + obj.name + "/";

		string newPath = EditorUtility.SaveFilePanelInProject("Clone Unit",
																   "unit_",
																   "prefab", "Please select file name to save prefab to:",
																			 Path.Combine(Application.dataPath, "Resources/units"));
		if (!string.IsNullOrEmpty(newPath))
		{
			string baseNewPath = Path.Combine(Path.GetDirectoryName(newPath), Path.GetFileNameWithoutExtension(newPath));
			string path = AssetDatabase.GetAssetPath(obj);
			if (string.IsNullOrEmpty(path) || File.Exists(newPath))
				return;

			AssetDatabase.CopyAsset(path, newPath);
			AssetDatabase.ImportAsset(newPath);
			var newObj = AssetDatabase.LoadAssetAtPath<GameObject>(newPath);

			//
			var animator = newObj.Get<Animator>();
			var controllerPath = AssetDatabase.GetAssetPath(animator.runtimeAnimatorController);
			var controllerNewPath = baseNewPath + ".controller";
			AssetDatabase.CopyAsset(controllerPath, controllerNewPath);
			AssetDatabase.ImportAsset(controllerNewPath);

			//
			var newController = AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(controllerNewPath);
			if (newController)
				animator.runtimeAnimatorController = newController;

			//
			var allAnimClips = AssetDatabase.LoadAllAssetRepresentationsAtPath(newPath).OfType<AnimationClip>().ToList();
			foreach (var clip in allAnimClips)
				UnityEngine.Object.DestroyImmediate(clip, true);
			AssetDatabase.SaveAssets();

			var aniDict = new Dictionary<string, AnimationClip>();
			foreach (var clip in newController.animationClips)
			{

				if (aniDict.ContainsKey(clip.name))
					continue;

				AssetDatabase.CopyAsset(AssetDatabase.GetAssetPath(clip), baseNewPath + "_" + clip.name.Split('_').LastOrDefault() + ".anim");
				AssetDatabase.ImportAsset(baseNewPath + "_" + clip.name.Split('_').LastOrDefault() + ".anim");
				var newClip = AssetDatabase.LoadAssetAtPath<AnimationClip>(baseNewPath + "_" + clip.name.Split('_').LastOrDefault() + ".anim");

				aniDict[newClip.name.Split('_').LastOrDefault()] = newClip;
				Debug.Log("1 " + newClip.name);
			}
			
			//
			if (newController is AnimatorController)
			{
				foreach (var layer in (newController as AnimatorController).layers)
				{
					var machine = layer.stateMachine;
					if (machine != null)
					{
						for (int i = 0; i < machine.states.Length; ++i)
						{
							var state = machine.states[i];
							AnimationClip clip;

							var ss = state.state;
							if (aniDict.TryGetValue(state.state.motion.name, out clip))
							{
								ss.motion = clip;
								machine.states[i].state = ss;
							}
							else
							{
								ss.motion = null;
							}
						}
					}
				}
			} else if(newController is AnimatorOverrideController) {
				var aoc = (newController as AnimatorOverrideController);
				var overrides = new List<KeyValuePair<AnimationClip, AnimationClip>>();

				//
				aoc.GetOverrides(overrides);
				foreach (var c in overrides)
				{
					Debug.Log("2 " + c.Key.name);
					if (aniDict.TryGetValue(c.Key.name.Split('_').LastOrDefault(), out var clip))
						aoc[c.Key.name] = clip;
				}
			}
			//
			AssetDatabase.SaveAssets();
		}
	}

	private static string deletedFolders;

	[MenuItem("Tools/Editor Extensions/Clean Empty Folders")]
	private static void Cleanup()
	{
		deletedFolders = string.Empty;

		var directoryInfo = new DirectoryInfo(Application.dataPath);
		foreach (var subDirectory in directoryInfo.GetDirectories("*.*", SearchOption.AllDirectories))
		{
			if (subDirectory.Exists)
			{
				ScanDirectory(subDirectory);
			}
		}
		Debug.Log("Deleted Folders:\n" + (deletedFolders.Length > 0 ? deletedFolders : "NONE"));
	}

	private static string ScanDirectory(DirectoryInfo subDirectory)
	{
		Debug.Log("Scanning Directory: " + subDirectory.FullName);

		var filesInSubDirectory = subDirectory.GetFiles("*.*", SearchOption.AllDirectories);

		if (filesInSubDirectory.Length == 0 || !filesInSubDirectory.Any(t => t.FullName.EndsWith(".meta") == false))
		{
			deletedFolders += subDirectory.FullName + "\n";
			subDirectory.Delete(true);
		}

		return deletedFolders;
	}
	
	[MenuItem("Tools/IdleZ/Export All Minimaps")]
	public static void ExportAllSceneMinimaps()
	{
		return;
		
		var originalScenePath = EditorSceneManager.GetActiveScene().path;

		var allScenePaths = Directory.GetFiles("Assets/PatchResources/Maps", "*.unity", SearchOption.AllDirectories)
			.Where(path => Path.GetFileName(path).StartsWith("Map_", StringComparison.InvariantCultureIgnoreCase))
			.ToArray();
		
		foreach (var scenePath in allScenePaths)
		{
			try
			{
				EditorSceneManager.OpenScene(scenePath);
				ScreenCaptureMap();
			}
			catch (Exception e)
			{
				Debug.LogError(e);
			}
		}

		EditorSceneManager.OpenScene(originalScenePath);
	}
	
	[MenuItem("Tools/IdleZ/Export Current Minimap")]
	public static void ExportCurrentSceneMinimap()
	{
		ScreenCaptureMap();
	}
	
	public static void ExportSceneTerrainLocationWithPath(string scenePath)
	{
		var originalScenePath = EditorSceneManager.GetActiveScene().path;
		
		try
		{
			EditorSceneManager.OpenScene(scenePath);
			var mapRoots = Utility.FindObjectsOfTypeAll<MapRoot>();
			if (mapRoots.Count == 0)
			{
				Debug.LogError($"No MapDataGenerator found in scene {scenePath}");
				return;
			}
			
			foreach (var mapRoot in mapRoots)
				mapRoot.ExportMap();
		}
		catch (Exception e)
		{
			Debug.LogError(e);
		}
		
		EditorSceneManager.OpenScene(originalScenePath);
	}
	
	[MenuItem("Tools/IdleZ/Export All Terrains and Locations")]
	public static void ExportAllSceneTerrainLocation()
	{
		return;
		
		var originalScenePath = EditorSceneManager.GetActiveScene().path;

		var allScenePaths = Directory.GetFiles("Assets/Resources/Maps", "*.unity", SearchOption.AllDirectories)
			.Where(path => Path.GetFileName(path).StartsWith("Map_", StringComparison.InvariantCultureIgnoreCase))
			.ToArray();
		
		foreach (var scenePath in allScenePaths)
		{
			try
			{
				EditorSceneManager.OpenScene(scenePath);
				ExportCurrentSceneTerrainLocation();
			}
			catch (Exception e)
			{
				Debug.LogError(e);
			}
		}

		EditorSceneManager.OpenScene(originalScenePath);
	}

	[MenuItem("Tools/IdleZ/Export Current Terrain and Location")]
	public static void ExportCurrentSceneTerrainLocation()
	{
		var currentScene = EditorSceneManager.GetActiveScene();
		var sceneName = Path.GetFileNameWithoutExtension(currentScene.path);
		var mapRoots = Utility.FindObjectsOfTypeAll<MapRoot_Old>();

		if (mapRoots.Count > 0) // not necessary, but just for validation
		{
			var mapRoot = mapRoots[0];

			//var safeGrids = mapRoot.GetSafeGrids();
			
			var safeMesh = mapRoot.GetSafeMesh();
			var quadMesh = mapRoot.GetQuadMesh();
			
			var unitTerrain = GetTerrainFormMesh(safeMesh);
			var skillTerrain = GetTerrainFormMesh(quadMesh);
			
			// Form terrains data
			var terrainTypeCnt = Enum.GetValues(typeof(ResourceMap.Types.Terrain.Types.Type)).Length;
			var terrains = new List<ResourceMap.Types.Terrain>();
			for (var i = 0; i < terrainTypeCnt; i++)
			{
				var terrainType = (ResourceMap.Types.Terrain.Types.Type)i;
				if (terrainType == ResourceMap.Types.Terrain.Types.Type.Skill)
				{
					var terrainCopied = skillTerrain.Clone();
					terrainCopied.Type = terrainType;
					terrains.Add(terrainCopied);
				}
				else if (terrainType == ResourceMap.Types.Terrain.Types.Type.Unit)
				{
					var terrainCopied = unitTerrain.Clone();
					terrainCopied.Type = terrainType;
					terrains.Add(terrainCopied);
				}
				else
				{
					var terrainCopied = unitTerrain.Clone();
					terrainCopied.Type = terrainType;
					terrains.Add(terrainCopied);
				}
			}

			// Form location data
			var locations = Utility.FindObjectsOfTypeAll<SpawnerLocation>().Where(x => x.gameObject.activeInHierarchy && x.IsValidSpawnLocation()).Select(x => x.GetLocation());
			
			// Check if location id is not duplicated
			// var locationIds = new HashSet<int>();
			// foreach (var location in locations)
			// {
			// 	if (locationIds.Contains(location.Id))
			// 	{
			// 		EditorUtility.DisplayDialog("Error", $"Location ID {location.Id} is duplicated in scene {sceneName}!\nTerrain and Location saving failed.", "OK");
			// 		return;
			// 	}
			//
			// 	locationIds.Add(location.Id);
			// }
			
			// Apply data to map
			var jsonResource = File.ReadAllText(Path.Combine(Application.dataPath, "PatchResources/Maps.json"));
			var resources = JsonParser.Default.Parse<Resources>(jsonResource);
			
			var matchedMaps = resources.Maps.Where(x => Path.GetFileNameWithoutExtension(x.Scene) == sceneName);
			foreach (var matchedMap in matchedMaps)
			{
				// Dump terrain data
				matchedMap.Terrains.Clear();
				matchedMap.Terrains.AddRange(terrains);
				
				// Dump spawner data
				matchedMap.Locations.Clear();
				matchedMap.Locations.AddRange(locations);
				
				// Save to file
				var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
				var json = formatter.Format(resources);
				
				File.WriteAllText("Assets/PatchResources/Maps.json", json);
				Debug.Log($"Saved {sceneName} terrain and location data to Maps.json");
			}
			
		}
	}

	private static ResourceMap.Types.Terrain GetTerrainFormMesh(Mesh safeMesh)
	{
		var terrain = new ResourceMap.Types.Terrain();
		
		// var groundMesh = groundMeshFilter.sharedMesh;
		// var derivedTerrainMesh = new Mesh();
		// derivedTerrainMesh.vertices = groundMesh.vertices;
		// derivedTerrainMesh.triangles = groundMesh.triangles;

		// vertices
		// var rotation = groundMeshFilter.gameObject.transform.rotation;
		// var pos = groundMeshFilter.gameObject.transform.position;
		// var rotation = groundMeshFilter.gameObject.transform.rotation;
		var rotation = Quaternion.identity;
		var pos = safeMesh.bounds.center;

		var translation = new Vector3(pos.x, pos.y, pos.z);

		var originalVertices = safeMesh.vertices;
		var vertexMapping = new uint[originalVertices.Length];
		var transformedVertices = new List<Vector3>();

		for (var i = 0; i < originalVertices.Length; i++)
		{
			int j;
			for (j = 0; j < i; ++j)
			{
				if ((originalVertices[i] - originalVertices[j]).sqrMagnitude < 0.0025f)
				{
					vertexMapping[i] = vertexMapping[j];
					break;
				}
			}

			if (i != j)
				continue;

			var adjustedVertex = RoundVector3(rotation * originalVertices[i] + translation, 6);
			transformedVertices.Add(adjustedVertex);
			vertexMapping[i] = (uint)transformedVertices.Count - 1;
		}

		// triangles
		var terrainMeshTriangles = new List<ResourceMap.Types.Terrain.Types.Triangle>();
		for (var i = 0; i < safeMesh.triangles.Length; i += 3)
		{
			var triangle = new ResourceMap.Types.Terrain.Types.Triangle
			{
				V1 = vertexMapping[safeMesh.triangles[i]],
				V2 = vertexMapping[safeMesh.triangles[i + 1]],
				V3 = vertexMapping[safeMesh.triangles[i + 2]],
			};
			terrainMeshTriangles.Add(triangle);
		}

		var terrainMeshVertices = transformedVertices.Select(x =>
		{
			var vertex = new ResourceMap.Types.Terrain.Types.Vertex
			{
				Position = new Vector2Message(),
			};
			vertex.Position.Set(x.XZ());
			return vertex;
		});

		terrain.Triangles.AddRange(terrainMeshTriangles);
		terrain.Vertices.AddRange(terrainMeshVertices);

		return terrain;
	}
	
	private static Vector3 RoundVector3(Vector3 vector, int decimalPlaces)
	{
		float x = (float)Math.Round(vector.x, decimalPlaces);
		float y = (float)Math.Round(vector.y, decimalPlaces);
		float z = (float)Math.Round(vector.z, decimalPlaces);
		return new Vector3(x, y, z);
	}

	private static void ScreenCaptureMap()
	{
		Camera camera = null;
		var originalPosition = Vector3.zero;
		var originalOrthographicSize = 0f;
		var originalCullingMask = 1;
		var originalBackgroundColor = Color.black;
		
		RenderTexture rt = null;
		Texture2D minimapTexture = null;
		GameObject tempMeshObject = null;
		Mesh tempMesh = null;

		try
		{
			var currentScene = SceneManager.GetActiveScene();
			var sceneName = Path.GetFileNameWithoutExtension(currentScene.path);
			
			var mapRoots = Utility.FindObjectsOfTypeAll<MapRoot_Old>();
			if (mapRoots.Count > 0)
			{
				//
				tempMeshObject = new GameObject("TempMeshObject");
				var minimapLayer = LayerMask.NameToLayer("Minimap");
				tempMeshObject.layer = minimapLayer;
				var tempMeshFilter = tempMeshObject.AddComponent<MeshFilter>();
				var tempMeshRenderer = tempMeshObject.AddComponent<MeshRenderer>();
				var tempMaterial = new Material(Shader.Find("Unlit/Texture"));
				tempMeshRenderer.material = tempMaterial;

				var groundMeshFilters = Utility.FindObjectsOfTypeAndLayerAll<MeshFilter>(LayerMask.NameToLayer("Ground"));
				if (groundMeshFilters.Count == 0)
					throw new InvalidOperationException($"No Ground Mesh at scene {sceneName}! Add Ground Mesh object first!");
				
				var combine = new CombineInstance[groundMeshFilters.Count];
				var combinedBounds = new Bounds(Vector3.zero, Vector3.zero);
				var boundsInitialized = false;

				for (var i = 0; i < groundMeshFilters.Count; i++)
				{
					combine[i].mesh = groundMeshFilters[i].sharedMesh;
					combine[i].transform = groundMeshFilters[i].transform.localToWorldMatrix;

					// Update the combined bounds
					if (!boundsInitialized)
					{
						combinedBounds = groundMeshFilters[i].sharedMesh.bounds;
						boundsInitialized = true;
					}
					else
					{
						combinedBounds.Encapsulate(groundMeshFilters[i].sharedMesh.bounds);
					}
				}

				tempMesh = new Mesh();
				tempMesh.CombineMeshes(combine);
				tempMeshFilter.sharedMesh = tempMesh;
				
				tempMeshObject.transform.position = Vector3.zero;
				// tempMeshObject.transform.position = combinedBounds.center;
				tempMeshObject.transform.rotation = Quaternion.identity;

				// var groundMeshFilter = groundMeshFilters[0];
				// tempMeshObject.transform.position = groundMeshFilter.gameObject.transform.position;
				// tempMeshObject.transform.rotation = groundMeshFilter.gameObject.transform.rotation;
				
				// var terrainMesh = groundMeshFilter.sharedMesh;
				// tempMesh = new Mesh();
				// tempMesh.vertices = terrainMesh.vertices;
				// tempMesh.triangles = terrainMesh.triangles;
				// tempMeshFilter.mesh = tempMesh;

				var cameras = Utility.FindObjectsOfTypeAll<Camera>();
				foreach (var cam in cameras)
				{
					if (cam.gameObject.name == "MinimapCamera")
					{
						camera = cam;
						camera.gameObject.SetActive(true);
						break;
					}
				}

				if (camera == null)
					throw new InvalidOperationException("MinimapCamera not found!");

				// Store original camera settings
				originalPosition = camera.transform.position;
				originalOrthographicSize = camera.orthographicSize;
				originalCullingMask = camera.cullingMask;
				originalBackgroundColor = camera.backgroundColor;

				// Setup camera for minimap capture
				var mapRoot = mapRoots[0];
				var width = MakeMultipleOfFour((int)(mapRoot.boundsSize.x * mapRoot.minimapMagnifier));
				var height = MakeMultipleOfFour((int)(mapRoot.boundsSize.y * mapRoot.minimapMagnifier));
				rt = new RenderTexture(width, height, 16);
				camera.targetTexture = rt;
				camera.orthographicSize = Mathf.Min(mapRoot.boundsSize.x, mapRoot.boundsSize.y) / 2;
				camera.cullingMask = 1 << minimapLayer;
				camera.backgroundColor = Color.black;

				// Adjust camera position
				var center = mapRoot.boundsOffset;
				var parentPos = camera.gameObject.transform.parent.transform.position;
				camera.transform.localPosition = new Vector3(center.x - parentPos.x, 100, center.y - parentPos.z);

				// Capture the minimap
				minimapTexture = new Texture2D(width, height, TextureFormat.RGBA32, false);
				camera.Render();
				RenderTexture.active = rt;
				minimapTexture.ReadPixels(new Rect(0, 0, width, height), 0, 0);
				var pixels = minimapTexture.GetPixels();
				for (var i = 0; i < pixels.Length; i++)
				{
					if (pixels[i].r < 0.1f && pixels[i].g < 0.1f && pixels[i].b < 0.1f)
						pixels[i].a = 0;
				}
				minimapTexture.SetPixels(pixels);
				minimapTexture.Apply();

				// Save the texture
				var bytes = minimapTexture.EncodeToPNG();
				var directoryPath = "Assets/Resources/Items/Minimaps/";
				Directory.CreateDirectory(directoryPath);
				var filePath = directoryPath + sceneName + "_Minimap.png";
				File.WriteAllBytes(filePath, bytes);
				AssetDatabase.ImportAsset(filePath);
				var importer = AssetImporter.GetAtPath(filePath)as TextureImporter;
				importer.textureType = TextureImporterType.Sprite;
				AssetDatabase.WriteImportSettingsIfDirty(filePath);
				AssetDatabase.Refresh();

				Debug.Log("Captured Map for scene: " + sceneName);
			}
			else
			{
				Debug.Log($"No MapRoot found in scene: {sceneName}");
			}
		}
		catch (Exception ex)
		{
			Debug.LogError($"Error capturing minimap: {ex.Message}");
		}
		finally
		{
			// Cleanup: Reset camera settings, destroy temporary objects
			if (camera != null)
			{
				camera.transform.position = originalPosition;
				camera.orthographicSize = originalOrthographicSize;
				camera.cullingMask = originalCullingMask;
				camera.backgroundColor = originalBackgroundColor; 
				camera.targetTexture = null;
				camera.gameObject.SetActive(false);
			}

			if (rt != null)
			{
				RenderTexture.active = null;
				Object.DestroyImmediate(rt);
			}

			if (minimapTexture != null)
			{
				Object.DestroyImmediate(minimapTexture);
			}

			if (tempMesh != null)
			{
				Object.DestroyImmediate(tempMesh);
			}

			if (tempMeshObject != null)
			{
				Object.DestroyImmediate(tempMeshObject);
			}

			AssetDatabase.Refresh();
		}

		int MakeMultipleOfFour(int value)
		{
			return (value + 3) & ~3;
		}
	}
	
	[MenuItem("Tools/Editor Extensions/Refresh All Prefabs")]
	public static void RefreshAllPrefabs()
	{
		var dir = new DirectoryInfo(Application.dataPath);
		var files = new List<FileInfo>();
		files.AddRange(dir.GetFiles("*.prefab", SearchOption.AllDirectories));
		AssetDatabase.ForceReserializeAssets(
			files.Select(f => "Assets" + f.ToString().Substring(Application.dataPath.Length)));
	}
	
	[MenuItem("Tools/Editor Extensions/Refresh All Images")]
	public static void RefreshAllImages()
	{
		var dir = new DirectoryInfo(Application.dataPath);
		var files = new List<FileInfo>();
		files.AddRange(dir.GetFiles("*.png", SearchOption.AllDirectories));
		files.AddRange(dir.GetFiles("*.jpg", SearchOption.AllDirectories));
		files.AddRange(dir.GetFiles("*.jpeg", SearchOption.AllDirectories));
		AssetDatabase.ForceReserializeAssets(
			files.Select(f => "Assets" + f.ToString().Substring(Application.dataPath.Length)));
	}
	
	[MenuItem("Tools/Editor Extensions/Refresh All Scenes")]
	public static void RefreshAllScenes()
	{
		var dir = new DirectoryInfo(Application.dataPath);
		var files = new List<FileInfo>();
		files.AddRange(dir.GetFiles("*.unity", SearchOption.AllDirectories));
		AssetDatabase.ForceReserializeAssets(
			files.Select(f => "Assets" + f.ToString().Substring(Application.dataPath.Length)));
	}
	
	
	[MenuItem("GameObject/Editor Extensions/Remove Missing Scripts")]
	private static void FindAndRemoveMissingInSelected()
	{
		var allObjects = GetAllChildren(Selection.gameObjects);
		var count = RemoveMissingScriptsFrom(allObjects);
		if (count == 0) return;
		EditorUtility.DisplayDialog("Remove Missing Scripts",
			$"Removed {count} missing scripts.\n\nCheck console for details", "ok");
	}

	[MenuItem("Assets/Editor Extensions/Remove Missing Scripts")]
	private static void FindAndRemoveMissingInSelectedAssets()
	{
		FindAndRemoveMissingInSelected();
	}

	[MenuItem("Assets/Editor Extensions/Remove Missing Scripts", true)]
	private static bool FindAndRemoveMissingInSelectedAssetsValidate()
	{
		return Selection.objects.OfType<GameObject>().Any();
	}

	[MenuItem("Tools/Editor Extensions/Remove Missing Scripts From Prefabs")]
	private static void RemoveFromPrefabs()
	{
		var allPrefabGuids = AssetDatabase.FindAssets("t:Prefab");
		var allPrefabsPath = allPrefabGuids.Select(AssetDatabase.GUIDToAssetPath);
		var allPrefabsObjects = allPrefabsPath.Select(AssetDatabase.LoadAssetAtPath<GameObject>);
		RemoveMissingScriptsFrom(allPrefabsObjects.ToArray());
		Debug.Log($"Removed All Missing Scripts from Prefabs");
	}

	private static int RemoveMissingScriptsFrom(params GameObject[] objects)
	{
		List<GameObject> forceSave = new();
		var removedCounter = 0;
		foreach (var current in objects)
		{
			if (current == null) continue;

			var missingCount = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(current);
			if (missingCount == 0) continue;

			GameObjectUtility.RemoveMonoBehavioursWithMissingScript(current);
			EditorUtility.SetDirty(current);

			if (EditorUtility.IsPersistent(current) && PrefabUtility.IsAnyPrefabInstanceRoot(current))
				forceSave.Add(current);

			Debug.Log($"Removed {missingCount} Missing Scripts from {current.gameObject.name}", current);
			removedCounter += missingCount;
		}

		foreach (var o in forceSave) PrefabUtility.SavePrefabAsset(o);

		return removedCounter;
	}

	private static GameObject[] GetAllChildren(GameObject[] selection)
	{
		List<Transform> t = new();

		foreach (var o in selection)
		{
			t.AddRange(o.GetComponentsInChildren<Transform>(true));
		}

		return t.Distinct().Select(x => x.gameObject).ToArray();
	}
	
	
	[MenuItem("Tools/IdleZ/Remove Unused FxSettings")]
	public static void DeleteUnusedFxSettings()
	{
		var searchFolder = ResourceSkillTimelineInjector.SKILL_TIMELINE_FXSETTINGS_PATH;
		var dependencyFolder = ResourceSkillTimelineInjector.SKILL_TIMELINE_PATH;
		var allAssets = AssetDatabase.GetAllAssetPaths();
		var dependencyAssets = allAssets.Where(a => a.StartsWith(dependencyFolder));
		var referencedAssets = new HashSet<string>();

		// Collect all unique dependencies from the dependency folder
		foreach (var assetPath in dependencyAssets)
		{
			var dependencies = AssetDatabase.GetDependencies(assetPath, true);
			foreach (var dependency in dependencies)
			{
				referencedAssets.Add(dependency);
			}
		}

		// Loop through all assets in the search folder and delete if not referenced
		var searchFolderAssets = allAssets.Where(a => a.StartsWith(searchFolder)).ToList();
		foreach (var assetPath in searchFolderAssets)
		{
			var asset = AssetDatabase.LoadAssetAtPath<Object>(assetPath);
			if (asset is not FxSettings or AudioFxSettings || !assetPath.Contains("@"))
				continue;
			if (!referencedAssets.Contains(assetPath))
			{
				Debug.Log($"Deleting unused FxSettings: {assetPath}");
				AssetDatabase.DeleteAsset(assetPath);
			}
		}
		
		foreach (var directory in Directory.GetDirectories(searchFolder, "*", SearchOption.AllDirectories))
		{
			if (Directory.GetFiles(directory).Length == 0 && Directory.GetDirectories(directory).Length == 0)
			{
				Debug.Log($"Deleting empty directory: {directory}");
				Directory.Delete(directory, false);
				AssetDatabase.DeleteAsset(directory.Replace("\\", "/"));
			}
		}

		AssetDatabase.Refresh();
	}
    [MenuItem("Build/Update Patchset Version")]
    public static void UpdatePatchsetVersion()
    {
        // Step 2: Update the ResourceGameConfig.json file
        try
        {									
            GameConfig.UpdatePatchsetVersion();
            EditorUtility.DisplayDialog("Success", "GameConfig.json updated to: " + GameConfig.Config.patchsetVersion, "OK");
        }
        catch (Exception e)
        {
            EditorUtility.DisplayDialog("Error", "Failed to update GameConfig.json file.\n" + e.Message, "OK");
        }
    }

}


class MyTexturePostprocessor : AssetPostprocessor {

	void OnPreprocessTexture () {

		var textureImporter = (TextureImporter)assetImporter;
		if(textureImporter != null) {
//			textureImporter.wrapMode = TextureWrapMode.Clamp;
//			textureImporter.npotScale = TextureImporterNPOTScale.None;
//			textureImporter.generateCubemap = TextureImporterGenerateCubemap.None;
//			textureImporter.mipmapEnabled = false;
//			textureImporter.generateMipsInLinearSpace = false;
//			textureImporter.textureFormat = TextureImporterFormat.ARGB32;
//			if (path.IndexOf ("/Resources/Images/") != -1) {
//				textureImporter.spritePixelsPerUnit = 1;
//			} else {
//				textureImporter.spritePixelsPerUnit = 1;
//			}
//			textureImporter.SetPlatformTextureSettings("iPhone", 2048,
//			                                           TextureImporterFormat.RGBA32, 
//			                                           (int)TextureCompressionQuality.Best);
		}
	}

	void OnPreprocessAudio() {
		
		string path = assetPath.Replace ("\\", "/");
		if (path.IndexOf ("/Sounds/") != -1) {
			var audioImporter = (AudioImporter)assetImporter;
			if (audioImporter != null) {
				audioImporter.threeD = false;
			}
		}
	}


	public class MyAssetModificationProcessor : AssetModificationProcessor
	{
		// public static string[] OnWillSaveAssets(string[] paths)
		// {
		// 	foreach (string path in paths)
		// 	{
		// 		if (path.Contains(".unity") && path.Contains("/PatchResources/Maps/"))
		// 		{
		// 			if (Path.GetFullPath(EditorApplication.currentScene) == Path.GetFullPath(path))
		// 			{
		// 				Extensions.ExportMapJSON();
		// 			}
		// 		}
		// 	}
		//
		// 	return paths;
		// }
	}
}

public class BuildProcessor : IPreprocessBuildWithReport, IPostprocessBuildWithReport
{
	public int callbackOrder { get { return 0; } }

	public enum ResourceType
	{
		Triggers,
		GameConfig,
		Strings,
		Achievements,
		Audios,
		Buffs,
		Items,
		Maps,
		Skills,
		Units,
		Globals,
	}
	
	public const string ResourceDataPath = "Assets/PatchResources/";
	public const string PatchResourceDataPath = "Assets/PatchResources/";

	public void OnPreprocessBuild(BuildReport report)
	{
		// TODO: for Player build. should add for AssetBundle build as well
		// -> only for AssetBundle build
		// Debug.Log("Preprocessing build");
		// SerializeJsonData(PatchResourceDataPath, ResourceDataPath);
	}

	public void OnPostprocessBuild(BuildReport report)
	{
		// Debug.Log("Postprocessing build");
		// RevertJsonData(ResourceSourceDataPath, ResourceTargetDataPath);
		// 패치리소스/리소스 분리되면서 revert할 필요가 없어짐
	}

	[MenuItem("Tools/IdleZ/Serialize All Json Data")]
	public static void Test()
	{
		SerializeJsonData(PatchResourceDataPath, ResourceDataPath);
	}
	public static void SerializeJsonData(string resourcePath, string targetPath)
	{
		var resourceJsons = new List<string>();
		resourceJsons.AddRange(Directory.GetFiles(resourcePath , "*.json", SearchOption.TopDirectoryOnly));

		foreach (var resJsonFile in resourceJsons)
		{
			var fname = Path.GetFileNameWithoutExtension(resJsonFile);
			if (fname == "ResourceGlobals")
				fname = "Globals";
			if (!Enum.TryParse<ResourceType>(fname, out var resourceType))
				continue;
			Debug.Log($"Serializing {resourceType} from {resJsonFile}");
			var json = File.ReadAllText(resJsonFile);
			var serializedResource = SerializeResourceToBinary(resourceType, json);
			
			if (serializedResource != null)
			{
				var resourcePathBinary = resJsonFile.Replace(".json", ".bytes");
				// var targetResourcePath = resourcePathBinary.Replace("PatchResources", "PatchResources");
				File.WriteAllBytes(resourcePathBinary, serializedResource);
				// AssetDatabase.DeleteAsset(resJsonFile);
			}
		}
		AssetDatabase.Refresh();
	}
	
	public static void RevertJsonData(string resourcePath, string targetPath)
	{
		var resourceJsons = new List<string>();
		resourceJsons.AddRange(Directory.GetFiles(resourcePath , "*.bytes", SearchOption.TopDirectoryOnly));

		foreach (var resBinaryFile in resourceJsons)
		{
			if (!Enum.TryParse<ResourceType>(Path.GetFileNameWithoutExtension(resBinaryFile), out var resourceType))
				continue;
			Debug.Log($"Deserializing {resourceType} from {resBinaryFile}");
			var bytes = File.ReadAllBytes(resBinaryFile);
			var jsonString = DeserializeResourceFromBinary(resourceType, bytes);
			
			if (jsonString != null)
			{
				var resourcePathBinary = resBinaryFile.Replace(".bytes", ".json");
				File.WriteAllText(resourcePathBinary, jsonString);
				File.Delete(resBinaryFile);
			}
		}
		AssetDatabase.Refresh();
	}

	private static byte[] SerializeResourceToBinary(ResourceType type, string jsonString)
	{
		switch (type)
		{
			case ResourceType.Triggers:
			{
				ResourceTrigger.ReloadJson(jsonString);
				var bytes = ResourceTrigger.FormatBinary();
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Strings:
			{
				ResourceString.ReloadJson(jsonString);
				var bytes = ResourceString.FormatBinary();
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Achievements:
			{
				var bytes = ResourceAchievement.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Audios:
			{
				var bytes = ResourceAudio.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Buffs:
			{
				var bytes = ResourceBuff.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Items:
			{
				var bytes = ResourceItem.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Maps:
			{
				var bytes = ResourceMap.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Skills:
			{
				var bytes = ResourceSkill.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Units:
			{
				var bytes = ResourceUnit.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
			case ResourceType.Globals:
			{
				var bytes = Resources.ReloadJsonToBinarySerialize(jsonString);
				return bytes.EncryptAes(ResourceManager.EncryptKey);
			}
		}
		return null;
	}

	private static string DeserializeResourceFromBinary(ResourceType type, byte[] byteData)
	{
		switch (type)
		{
			case ResourceType.Triggers:
			{
				ResourceTrigger.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceTrigger.FormatJson();
				return json;
			}
			
			case ResourceType.Strings:
			{
				ResourceString.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceString.FormatJson();
				return json;
			}
			case ResourceType.Achievements:
			{
				ResourceAchievement.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceAchievement.FormatJson();
				return json;
			}
			case ResourceType.Audios:
			{
				ResourceAudio.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceAudio.FormatJson();
				return json;
			}
			case ResourceType.Buffs:
			{
				ResourceBuff.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceBuff.FormatJson();
				return json;
			}
			case ResourceType.Items:
			{
				ResourceItem.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceItem.FormatJson();
				return json;
			}
			case ResourceType.Maps:
			{
				ResourceMap.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceMap.FormatJson();
				return json;
			}
			case ResourceType.Skills:
			{
				ResourceSkill.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceSkill.FormatJson();
				return json;
			}
			case ResourceType.Units:
			{
				ResourceUnit.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = ResourceUnit.FormatJson();
				return json;
			}
			case ResourceType.Globals:
			{
				Resources.ReloadBinary(byteData.DecryptAes(ResourceManager.EncryptKey));
				var json = Resources.FormatJson();
				return json;
			}
		}
		return null;
	}
}
