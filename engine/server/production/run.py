#!/usr/bin/python3

import os
import subprocess
import time
import socket
import logging
import json
import argparse

args = argparse.ArgumentParser()
args.add_argument('--restart', action='store_true')
args = args.parse_args()

# Setup logging
logging.basicConfig(filename='/home/ubuntu/update-worker.log', level=logging.INFO, format='%(asctime)s %(message)s')

# Constants
AWS_REGION = "ap-northeast-2"
ECR_REPOSITORY_URI = f"246743264504.dkr.ecr.{AWS_REGION}.amazonaws.com/puzzlemonsters/idlez-server"
CONTAINER_NAME = "worker-container"
IMAGE_TAG = "latest"
PREVIOUS_IMAGE_TAG = "previous"
BASE_DIR = "/home/ubuntu"
HOST_MOUNT_POINT = os.path.join(BASE_DIR, "idlez-client/Client/Assets/PatchResources")
CONTAINER_MOUNT_POINT = "/PatchResources"
HOSTNAME = socket.gethostname()
MAX_RESTART_COUNT = 20
CONTAINER_PORT = 11180
SERVER_PORT = 11177
CONFIG_FILE = os.path.join(BASE_DIR, 'idlez-Config.json')
CLIENT_DIR = 'idlez-client'
SERVER_DIR = 'idlez-server'
CLIENT_RESOURCE_BRANCH = 'production-resources'
GOOGLE_SERVICE_CREDENTIALS = os.path.join(BASE_DIR, 'google-service-credentials.json')

SECRETS_FILE = '/home/ubuntu/idlez-server/production/secrets.sh'
SECRETS = {
  'SLACK_TOKEN': '',
  'SLACK_CHANNEL': ''
}

DOCKER_OPTIONS = f'-d --name {CONTAINER_NAME} -p {SERVER_PORT}:{CONTAINER_PORT} -v {CONFIG_FILE}:/app/Config.json -v {GOOGLE_SERVICE_CREDENTIALS}:/app/google-service-credentials.json -v{HOST_MOUNT_POINT}:{CONTAINER_MOUNT_POINT} -v /tmp:/tmp '

CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

with open(SECRETS_FILE, 'r') as f:
  for line in f:
    try:
      key, value = line.strip().split('=')
    except ValueError:
      continue
    SECRETS[key] = value.strip('"')

def send_slack_alert(message, thread=None):
  data = {
    'channel': SECRETS['SLACK_CHANNEL'],
    'text': f':luho_4: *[Idle Z:Hamzzi]* [EC2-{HOSTNAME}] {message}'
  }
  if thread:
    data['thread_ts'] = thread
  data_json = json.dumps(data)
  command = (
    f'curl -L -X POST -H "Content-type: application/json; charset=utf-8" '
    f'-H "Authorization: Bearer {SECRETS['SLACK_TOKEN']}" '
    f'https://slack.com/api/chat.postMessage '
    f'-d \'{data_json}\''
  )
  print('Slack notification:', message)
  result = subprocess.run(command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  result = json.loads(result.stdout.strip().decode())
  if result['ok']:
    return result['ts']
  else:
    return None

def run_command(command):
  result = subprocess.run(command, shell=True, capture_output=True, text=True)
  if result.returncode != 0:
    logging.error(result.stderr.strip())
    return None
  print('Run: ', command)
  return result.stdout.strip()

def read_config(key):
  if not os.path.exists(os.path.join(CURRENT_DIR, 'config.json')):
    return None
  with open(os.path.join(CURRENT_DIR, 'config.json'), 'r') as f:
    try:
      data = json.load(f)
      return data[key]
    except (KeyError, json.decoder.JSONDecodeError):
      return None

def write_config(key, value):
  data = {key: value}
  if os.path.exists(os.path.join(CURRENT_DIR, 'config.json')):
    with open(os.path.join(CURRENT_DIR, 'config.json'), 'r') as f:
      try:
        data = json.load(f)
        data[key] = value
      except json.decoder.JSONDecodeError:
        pass
  with open(os.path.join(CURRENT_DIR, 'config.json'), 'w') as f:
    json.dump(data, f)

def check_git_updates():
  # Pull client repo
  logging.info("Checking for updates in the client repo")
  os.chdir(os.path.join(BASE_DIR, CLIENT_DIR))

  local_commit = run_command('git rev-parse HEAD')
  run_command('git fetch origin')
  remote_commit = run_command('git rev-parse origin/{}'.format(CLIENT_RESOURCE_BRANCH))

  if local_commit != remote_commit:
    logging.info("New updates found in the client repo. Pulling latest changes...")
    run_command('git pull')
    remote_commit_trimmed = remote_commit[:7]
    send_slack_alert(f"서버 데이터가 업데이트되었습니다. ({remote_commit_trimmed})")
    send_slack_alert(f"서버를 재시작하지는 않도록 하겠습니다. ({remote_commit_trimmed})")

  else:
    logging.info("No updates found in the client repo.")

  # Pull server repo
  logging.info("Pulling the latest server repo")
  os.chdir(os.path.join(BASE_DIR, SERVER_DIR))
  run_command('git pull')

def rollback_server():
  last_successful_image = read_config('last_successful_image')
  last_successful_image_timestamp = read_config('last_successful_image_timestamp')

  if not last_successful_image:
    logging.error("No previous successful image found. Exiting.")
    send_slack_alert("저런. 이젠 롤백할 버전도 없네요.")
  else:
    run_command(f'docker rm -f {CONTAINER_NAME}')
    run_command(f'docker run {DOCKER_OPTIONS} {last_successful_image}')
    send_slack_alert(f"서버를 이전 버전으로 롤백했습니다. ({time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(last_successful_image_timestamp))})")

if __name__ == '__main__':
  if args.restart:
    logging.info("Restarting the worker container...")
    run_command(f'docker rm -f {CONTAINER_NAME}')
    run_command(f'docker run {DOCKER_OPTIONS} {ECR_REPOSITORY_URI}:{IMAGE_TAG}')
    logging.info("Worker container stopped.")
    send_slack_alert("서버를 재시작했습니다.")
    exit()

  check_git_updates()

  # Check if the worker container is running
  running_container_id = run_command(f'docker ps --filter "name={CONTAINER_NAME}" --filter "ancestor={ECR_REPOSITORY_URI}:{IMAGE_TAG}" --format "{{{{.ID}}}}"')

  #test for websocket connection
  #result = run_command(f'curl -s http://localhost:{SERVER_PORT}/')

  if not running_container_id: #or result == None:
    thread = send_slack_alert("서버 크래시 :urgent::urgent::urgent:")
    logs = run_command(f'docker logs {CONTAINER_NAME} -n 50')
    if thread:
      send_slack_alert("서버 로그\n" + logs, thread)
    restart_count = read_config('restart_count')
    if restart_count:
      restart_count += 1
    else:
      restart_count = 1
    write_config('restart_count', restart_count)
    if restart_count == MAX_RESTART_COUNT:
      send_slack_alert(f"서버가 {restart_count}회 연속으로 크래시되었습니다. 재시작 시도를 멈춥니다.")
      logging.error(f"Server restarted {restart_count} times. Stopping the server.")
    elif restart_count > MAX_RESTART_COUNT:
      pass
    else:
      logging.info(f"No running container found for the image {ECR_REPOSITORY_URI}:{IMAGE_TAG}. Starting a new container...")
      run_command(f'docker run {DOCKER_OPTIONS} {ECR_REPOSITORY_URI}:{IMAGE_TAG}')
      send_slack_alert(f"서버를 다시 시작했습니다. ({restart_count}/{MAX_RESTART_COUNT})")
      logging.info("Worker container started.")

  # Log in to ECR
  logging.info("Logging into Amazon ECR")
  run_command(f'aws ecr get-login-password --region {AWS_REGION} | docker login --username AWS --password-stdin {ECR_REPOSITORY_URI}')

  # Save the previous image ID
  previous_image_id = run_command(f'docker inspect --format="{{{{.Id}}}}" {ECR_REPOSITORY_URI}:{IMAGE_TAG}')
  logging.info(f"Previous image ID: {previous_image_id}")

  # Pull the latest image from ECR
  logging.info(f"Pulling the latest image: {ECR_REPOSITORY_URI}:{IMAGE_TAG}")
  run_command(f'docker pull {ECR_REPOSITORY_URI}:{IMAGE_TAG}')

  # Get the current image ID
  current_image_id = run_command(f'docker inspect --format="{{{{.Id}}}}" {ECR_REPOSITORY_URI}:{IMAGE_TAG}')
  logging.info(f"Current image ID: {current_image_id}")

  # Check if the container is running
  running_container_id = run_command(f'docker ps --filter "name={CONTAINER_NAME}" --filter "ancestor={ECR_REPOSITORY_URI}:{IMAGE_TAG}" --format "{{{{.ID}}}}"')

  if current_image_id != previous_image_id:
    send_slack_alert("서버 이미지가 업데이트되었습니다.")
    logging.info(f"Tagging the previous image as {ECR_REPOSITORY_URI}:{PREVIOUS_IMAGE_TAG}")
    run_command(f'docker tag {previous_image_id} {ECR_REPOSITORY_URI}:{PREVIOUS_IMAGE_TAG}')

  # If no container is running with the current image, start a new one
  if not running_container_id:
    logging.info(f"No running container found for the image {ECR_REPOSITORY_URI}:{IMAGE_TAG}. Starting a new container...")
    
    old_container_id = run_command(f'docker ps -a --filter "name={CONTAINER_NAME}" --format "{{{{.ID}}}}"')
    if old_container_id:
      logging.info(f"Removing old container: {old_container_id}")
      run_command(f'docker rm -f {CONTAINER_NAME}')

    logging.info("Starting worker container with the new image...")
    send_slack_alert("새 이미지를 로드합니다.")
    
    run_command(f'docker run {DOCKER_OPTIONS} {ECR_REPOSITORY_URI}:{IMAGE_TAG}')

    # Verify container started
    time.sleep(10)
    new_container_id = run_command(f'docker ps --filter "name={CONTAINER_NAME}" --filter "ancestor={ECR_REPOSITORY_URI}:{IMAGE_TAG}" --format "{{{{.ID}}}}"')
    print(new_container_id)

    if not new_container_id:
      logging.error("The new container failed to start. Rolling back to the previous image...")
      thread = send_slack_alert("서버를 시작하지 못했습니다 :urgent::urgent::urgent:")
      logs = run_command(f'docker logs {CONTAINER_NAME} -n 50')
      send_slack_alert("서버 로그\n" + logs, thread)
    else:
      write_config('last_successful_image', current_image_id)
      last_successful_image_timestamp = int(time.time())
      write_config('last_successful_image_timestamp', last_successful_image_timestamp)
      write_config('restart_count', 0)

      logging.info("Worker container started with the new image.")
      send_slack_alert("서버를 시작했습니다. ({time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(last_successful_image_timestamp))})")
  else:
    logging.info(f"A container is already running with the image {ECR_REPOSITORY_URI}:{IMAGE_TAG}. No action needed.")
    
