from flask import Flask, request, jsonify
import compiler
import subprocess
import sys
import os
import threading
import json
import re
import time
from urllib.request import urlopen, Request

trigger_path = 'Client/Assets/PatchResources/Triggers.json'
string_path = 'Client/Assets/PatchResources/Strings.json'
workspace_path = '../data/'

def find_path(path: str) -> str:
  if os.path.exists('/'.join(path.split('/')[:-1])):
    return path
  else:
    for i in range(20):
      path = os.path.join('..', path)
      if os.path.exists('/'.join(path.split('/')[:-1])):
        return path
  return None

trigger_path = find_path(trigger_path)
string_path = find_path(string_path)
workspace_path = find_path(workspace_path)

HEARTBEAT_TIMEOUT = 5

app = Flask(__name__)

last_heartbeat = time.time()


def killer_function() -> None:
  global last_heartbeat
  #sys.stderr.write('Checking heartbeat: ' + str(time.time() - last_heartbeat) + '\n')
  if time.time() - last_heartbeat > HEARTBEAT_TIMEOUT:
    sys.stderr.write('Heartbeat timeout, exiting\n')
    request = Request('http://localhost:8090/kill', method='POST')
    try:
      urlopen(request)
    except:
      pass
    os._exit(0)


class Killer(threading.Thread):
  def __init__(self, interval: int):
    threading.Thread.__init__(self)
    self.interval = interval

  def run(self) -> None:
    while True:
      time.sleep(self.interval)
      killer_function()


@app.route('/compile', methods=['OPTIONS'])
@app.route('/compile_batch', methods=['OPTIONS'])
@app.route('/upload/<string:endpoint>', methods=['OPTIONS'])
@app.route('/variables/<string:operation>', methods=['OPTIONS'])
@app.route('/heartbeat', methods=['OPTIONS'])
@app.route('/kill', methods=['OPTIONS'])
def options_handler(endpoint: None = None, operation: None = None) -> None:
  response = jsonify({'success': True})
  response.headers.add('Access-Control-Allow-Origin', '*')
  response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
  response.headers.add('Access-Control-Allow-Methods', 'POST')
  return response


@app.route('/compile_batch', methods=['POST'])
def compile_batch_handler() -> None:
  
  codes = request.json['codes']
  result = []
  for code in codes:
    try:
      code = compiler.to_json(code)
      result.append(code)
    except Exception as e:
      print(code[0:1000])
      print(e)
      response = jsonify({'success': False, 'error': str(e)})
      response.headers.add('Access-Control-Allow-Origin', '*')
      return response


  response = jsonify({'success': True, 'codes': result})
  response.headers.add('Access-Control-Allow-Origin', '*')
  return response


@app.route('/compile', methods=['POST'])
def compile_handler() -> None:
  # try:
  code = request.json['code']
  try:
    print('Compiling code...')
    print(code[0:100])
    code = compiler.to_json(code)
    response = jsonify({'success': True, 'code': code})
  except Exception as e:
    print(code[0:1000])
    print(e)
    response = jsonify({'success': False, 'error': str(e)})
  # except:
  #  response = jsonify({'success': False, 'error': 'No code provided'})
  response.headers.add('Access-Control-Allow-Origin', '*')

  return response

@app.route('/variables/<string:operation>', methods=['GET', 'POST'])
def variables_handler(operation) -> None:
  variable_file = []
  with open(string_path, 'rb') as f:
    variable_file = json.loads(f.read().decode('utf-8'))
  if operation == 'list':
    response = jsonify({'success': True, 'variables': variable_file})
  elif operation == 'create':
    new_variable = request.json
    id_max = 1
    for variable in variable_file['strings']:
      if 'english' in variable:
        if variable['english'] == new_variable['name']:
          response = jsonify({'success': False, 'error': 'Variable already exists'})
          response.headers.add('Access-Control-Allow-Origin', '*')
          return response
      else:
        response = jsonify({'success': False, 'error': 'Invalid variable'})
    for variable in variable_file['strings']:
      if 'id' in variable:
        id_max = max(id_max, variable['id'])
    variable_file['strings'].append({
      'id': id_max + 1,
      'english': new_variable['name'],
    })
    with open(string_path, 'wb') as f:
      f.write(json.dumps(variable_file, indent=2, sort_keys=True, ensure_ascii=False).encode('utf-8'))
    response = jsonify({'success': True})
  elif operation == 'rename':
    old_name = request.json['oldName']
    new_name = request.json['newName']
    for variable in variable_file['strings']:
      if variable['english'] == old_name:
        variable['english'] = new_name
    with open(string_path, 'wb') as f:
      f.write(json.dumps(variable_file, indent=2, sort_keys=True, ensure_ascii=False).encode('utf-8'))
    response = jsonify({'success': True})
  else:
    response = jsonify({'success': False, 'error': 'Invalid operation'})
  response.headers.add('Access-Control-Allow-Origin', '*')
  return response

# Triggers.json upload endpoint
@app.route('/upload/<string:endpoint>', methods=['POST'])
def upload_handler(endpoint) -> None:
  new_json = request.json
  if endpoint == 'data':
    path = trigger_path
    trigger_json = {}
    if os.path.exists(path):
      with open(path, 'rb') as f:
        jsonfile = f.read().decode('utf-8')
        trigger_json = json.loads(jsonfile)
    trigger_json['triggers'] = new_json
    with open(path, 'wb') as f:
      f.write(json.dumps(trigger_json, indent=2, sort_keys=True, ensure_ascii=False).encode('utf-8'))

  elif endpoint == 'patchresources':
    safe_chars = re.compile(r'[^a-zA-Z0-9_가-힣\s\-]')
    if not os.path.exists(os.path.dirname(workspace_path)):
      os.makedirs(os.path.dirname(workspace_path))
    path = workspace_path
    import copy
    with open(os.path.join(path, 'workspace.triggerws'), 'wb') as f:
      general_settings = copy.deepcopy(new_json)
      del general_settings['workspaces']
      del general_settings['triggers']
      f.write(json.dumps(general_settings, indent=2, sort_keys=True, ensure_ascii=False).encode('utf-8'))
    for k, item in enumerate(new_json['workspaces']):
      item['metadata'] = new_json['triggers'][k]
      print(item['metadata'])
      if 'id' in item['metadata']:
        del item['metadata']['id']
      filename = safe_chars.sub('', new_json['triggers'][k]['name'])
      with open(os.path.join(path, f'{filename}.ws'), 'wb') as f:
        f.write(json.dumps(item, indent=2, sort_keys=True, ensure_ascii=False).encode('utf-8'))

  else:
    response.headers.add('Access-Control-Allow-Origin', '*')
    return jsonify({'success': False, 'error': 'Invalid endpoint'})

  response = jsonify({'success': True})
  response.headers.add('Access-Control-Allow-Origin', '*')
  return response


@app.route('/heartbeat', methods=['GET'])
def heartbeat_handler() -> None:
  response = jsonify({'success': True})
  response.headers.add('Access-Control-Allow-Origin', '*')
  global last_heartbeat
  last_heartbeat = time.time()
  return response


@app.route('/kill', methods=['POST'])
def kill_handler() -> None:
  response = jsonify({'success': True})
  response.headers.add('Access-Control-Allow-Origin', '*')
  print('Exiting via API')
  func = request.environ.get('werkzeug.server.shutdown')
  if func is None:
    print('Not running with the Werkzeug Server')
  else:
    func()
  os._exit(0)
  return response

if __name__ == '__main__':
  if os.environ.get("WERKZEUG_RUN_MAIN") == "true":
    kill_timer = Killer(1)
    kill_timer.start()
  app.run(host='0.0.0.0', port=8090, debug=False)