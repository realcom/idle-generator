import os
import subprocess
import time
from ci import build

REPO_PATH = os.path.join(os.getcwd(), "..")
BRANCH_NAME = 'master'
POLL_INTERVAL = 60


def is_branch_updated():
  os.chdir(REPO_PATH)

  subprocess.run(["git", "fetch"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)

  local_commit = subprocess.check_output(["git", "rev-parse", BRANCH_NAME]).strip().decode("utf-8")
  remote_commit = subprocess.check_output(["git", "rev-parse", f"origin/{BRANCH_NAME}"]).strip().decode("utf-8")

  if local_commit != remote_commit:
    return True
  return False


def update_local_branch():
  os.chdir(REPO_PATH)
  subprocess.run(["git", "checkout", BRANCH_NAME], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
  subprocess.run(["git", "pull", "origin", BRANCH_NAME], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
  print(f"Branch {BRANCH_NAME} updated.")


def commit_changes():
  try:
    os.chdir(REPO_PATH)
    subprocess.run(["git", "pull", "origin", BRANCH_NAME], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    subprocess.run(["git", "add", "Build"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    subprocess.run(["git", "commit", "-m", "[개발]📦️ Build"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    push = subprocess.run(["git", "push", "origin", BRANCH_NAME], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    print("Changes committed and pushed.")
  except subprocess.CalledProcessError as e:
    print(f"Error: {e}")
    try:
      print(push.stderr.decode("utf-8"))
    except:
      pass
    print("Discarding changes...")
    print("reset to the last commit from origin")
    subprocess.run(["git", "reset", "--hard", f"origin/{BRANCH_NAME}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)


def run_monitor():
  print(f"Monitoring {REPO_PATH} for updates to branch {BRANCH_NAME}...")
  old_time = 0
  while True:
    if time.time() - old_time > POLL_INTERVAL:
      print("Checking for updates...")
      old_time = time.time()
      if is_branch_updated():
        print(f"Detected updates on branch {BRANCH_NAME}, triggering build...")
        update_local_branch()
        build()
        commit_changes()
    else:
      time.sleep(1)


if __name__ == "__main__":
  run_monitor()