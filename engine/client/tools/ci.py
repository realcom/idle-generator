import subprocess
import os

UNITY_PATH = '"C:\\Program Files\\Unity\\Hub\\Editor\\2022.3.15f1\\Editor\\Unity.exe"'
PROJECT_PATH = "./Client"
BUILD_PATH = "./Build"

BUILD_TARGET = "webgl"


def build():
  cmd = [
    UNITY_PATH,
    "-quit",
    "-batchmode",
    f"-projectPath {PROJECT_PATH}",
    f"-executeMethod Extensions.PerformBuild",
    f"-buildTarget {BUILD_TARGET}",
    f"-buildPath {BUILD_PATH}",
    f"-releaseCodeOptimization"
  ]
  try:
    result = subprocess.run(' '.join(cmd), check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    print("Build completed successfully")
    print(result.stdout.decode("utf-8"))
      
  except subprocess.CalledProcessError as e:
    print(f"Error occurred: {e}")
    try:
      print(result.stderr.decode("utf-8"))
    except:
      pass


if __name__ == "__main__":
  build()