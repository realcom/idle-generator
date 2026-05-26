using System;
using System.IO;
using UnityEngine;
using Debug = UnityEngine.Debug;
using System.Diagnostics;
using System.Text;

namespace Commons.Resources
{
    public class ResourceEditToolParser
    {
        private const string scriptName = "parse.py";


        public static bool Parse<T>()
        {
            return RunPythonParser(typeof(T).Name);
        }

        public static bool Parse(string type)
        {
            return RunPythonParser(type);
        }

        public static bool ParseAll()
        {
            return RunPythonParser("--all");
        }

        static bool IsCommandAvailable(string command)
        {
            try
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = command,
                        Arguments = "--version",
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        CreateNoWindow = true,
                    }
                };
                process.Start();
                process.WaitForExit();

                var output = process.StandardOutput.ReadToEnd();
                var error = process.StandardError.ReadToEnd();
                if (process.ExitCode == 0)
                {
                    var version = string.IsNullOrEmpty(output) ? error : output;
                    Debug.Log($"설치된 Python/{command} 버전: {version.Trim()}");
                    return true;
                }
                else
                {
                    //Debug.Log(output);
                    //Debug.Log($"Cannot find {command}.");
                    return false;
                }
            }
            catch (Exception e)
            {
                //Debug.Log($"{command}의 버전을 확인하는 도중 오류가 발생했습니다.");
                return false;
            }
        }

        private static bool IsUnixBasedOS()
        {
            var platform = (int) Environment.OSVersion.Platform;
            return platform == 4 || platform == 6 || platform == 128; // Unix-based systems
        }


        private static bool RunPythonParser(string resourceType, string addArgs = null)
        {
            if (Application.isPlaying)
            {
                throw new InvalidOperationException("플레이 모드에서는 사용할 수 없습니다.");
            }
            var assetsDir = new DirectoryInfo(Application.dataPath);
            var projectRootDir = assetsDir.Parent.Parent;

            var scriptDir = Path.Combine(projectRootDir.FullName, "tools");
            var venvPath = Path.Combine(projectRootDir.FullName, "../venv");

            var pythonExecutable = "python";
            if (!IsCommandAvailable(pythonExecutable))
            {
                pythonExecutable = "python3";
                if (!IsCommandAvailable(pythonExecutable))
                {
                    pythonExecutable = "py";
                    if (!IsCommandAvailable(pythonExecutable))
                    {
						Debug.LogError("Python이 설치되어 있지 않습니다.");
						return false;
					}
                }
            }

            var start = new ProcessStartInfo();

            start.FileName = pythonExecutable;
            start.WorkingDirectory = scriptDir;
            start.Arguments = $"\"{scriptName}\" \"{resourceType}\"";
            start.UseShellExecute = false;
            start.RedirectStandardOutput = true;
            start.RedirectStandardError = true;
            start.CreateNoWindow = false;

            // Set environment variables to activate virtual environment if on Linux or macOS
            if (IsUnixBasedOS())
            {
                string activateScript = Path.Combine(venvPath, "bin", "activate");
                if (File.Exists(activateScript))
                {
                    Debug.Log("Using virtual environment...");
                    start.EnvironmentVariables["VIRTUAL_ENV"] = venvPath;
                    start.EnvironmentVariables["PATH"] = $"{Path.Combine(venvPath, "bin")}:{Environment.GetEnvironmentVariable("PATH")}";
                    start.FileName = "/bin/bash";
                    string command = $"source {Path.Combine(venvPath, "bin", "activate")} && cd \"{scriptDir}\" && {pythonExecutable} \"{scriptName}\" \"{resourceType}\"";
                    start.Arguments = $"-c \"{command}\"";
                }
                else
                {
                    Debug.Log("Warning: virtual environment is not set.");
                }
                start.StandardErrorEncoding = Encoding.GetEncoding("UTF-8");
            }
            else
            {
                // set encoding for Korean Windows
                start.StandardErrorEncoding = Encoding.GetEncoding("ks_c_5601-1987");
            }

            Debug.Log("파싱 시작");

            using (var process = Process.Start(start))
            {
                using (var reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    Debug.Log(result);
                }
                
                process.WaitForExit(20000);

                var errorReader = process.StandardError;
                var errorResult = errorReader.ReadToEnd();

                if (process.ExitCode == 0)
                {
                    Debug.Log("파싱이 완료되었습니다.");
                    if (!string.IsNullOrEmpty(errorResult))
                    {
                        Debug.LogError(errorResult);
                    }
                    return true;
                }
                else
                {
                    Debug.LogError("파싱 중 오류가 발생했습니다.");
                    if (!string.IsNullOrEmpty(errorResult))
                    {
                        Debug.LogError(errorResult);
                    }
                    return false;
                }
            }
        }
    }
}