using UnityEngine;
using UnityEditor;
using System.IO;

[InitializeOnLoad]
public class BundleVersionChecker
{
    /// <summary>
    /// Class name to use when referencing from code.
    /// </summary>
    const string ClassName = "CurrentBundleVersion";

    const string TargetCodeFile = "Assets/Scripts/" + ClassName + ".cs";

    static BundleVersionChecker () {
		Check ();
    }

	public static void Check(bool forced = false) {
        
	}

    static string CreateNewBuildVersionClassFile (string bundleVersion) {
        using (StreamWriter writer = new StreamWriter (TargetCodeFile, false)) {
            try {
                string code = GenerateCode (bundleVersion);
                writer.WriteLine ("{0}", code);
            } catch (System.Exception ex) {
                string msg = " threw:\n" + ex.ToString ();
                Debug.LogError (msg);
                EditorUtility.DisplayDialog ("Error when trying to regenerate class", msg, "OK");
            }
        }
        return TargetCodeFile;
    }

    /// <summary>
    /// Regenerates (and replaces) the code for ClassName with new bundle version id.
    /// </summary>
    /// <returns>
    /// Code to write to file.
    /// </returns>
    /// <param name='bundleVersion'>
    /// New bundle version.
    /// </param>
    static string GenerateCode (string bundleVersion) {
        string code = "public static class " + ClassName + "\n{\n";
        code += System.String.Format ("\tpublic static readonly string version = \"{0}\";", bundleVersion);
        code += "\n}\n";
        return code;
    }
}