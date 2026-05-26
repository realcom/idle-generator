import json
import re
#import numpy as np
import os
import argparse
import math


path_server = 'HashDump-Server_log.txt'
path_client = 'HashDump-Client_log.txt'
file_server = open(path_server, 'r', encoding='utf-8').read().split('\n\n')
file_client = open(path_client, 'r', encoding='utf-8').read().split('\n\n')

dict_server_hash = {}
dict_server_value = {}
dict_client_hash = {}
dict_client_value = {}


def compare_float(server, client, nested, tick, ignore_float_error=False, epsilon=1e-3):
  #server_fp32 = np.float32(server)
  #client_fp32 = np.float32(client)
  server_fp = float(server)
  client_fp = float(client)
  if ignore_float_error==True:
    if math.fabs((server_fp+1) / (client_fp+1)) > (1+epsilon):
      print(f'\033[0m[FP error] Tick {tick}\nServer: \033[91m{nested}: {server_fp}\n\033[0mClient: \033[94m{nested}: {client_fp}\033[0m\n')
  elif server_fp != client_fp:
    print(f'\033[0mTick {tick}\nServer: \033[91m{nested}: {server_fp}\n\033[0mClient: \033[94m{nested}: {client_fp}\033[0m\n')


def compare_json(server, client, nested, tick, ignore_float_error=False):
  for key, value in server.items():
    if key not in client:
      print(f'\033[0mTick {tick}\nServer: \033[91m{nested}: {key}\n\033[30m\033[44mMatching key not found in client\033[0m\n')
    elif isinstance(value, dict):
      compare_json(value, client[key], nested + '/' + key, tick, ignore_float_error)
    elif isinstance(value, list):
      for key_inner, v in enumerate(value):
        if isinstance(v, dict):
          try:
            compare_json(v, client[key][key_inner], nested + '/' + key + '[' + str(key_inner) + ']', tick, ignore_float_error)
          except IndexError:
            print(f'\033[0mTick {tick}\nServer: \033[91m{nested}: {key}/{key_inner}\n\033[30m\033[44mMatching key not found in client\033[0m\n')
        elif isinstance(v, float):
          compare_float(v, client[key][key_inner], nested + '/' + key + '[' + str(key_inner) + ']', tick, ignore_float_error)
    elif isinstance(value, float):
      compare_float(value, client[key], nested + '/' + key, tick, ignore_float_error)
  for key, value in client.items():
    if key not in server:
      print(f'\033[0mTick {tick}\nClient: \033[94m{nested}: {key}\n\033[30m\033[41mMatching key not found in server\033[0m\n')


def print_diff(server, client, tick, ignore_float_error=False):
  client_units = next(filter(lambda x: x.startswith('Units'), client))
  client_resmap = next(filter(lambda x: x.startswith('ResMap'), client))
  for number, line in enumerate(server):
    if line.startswith('Units'):
      server_json = json.loads(line.split('Units: ')[1])
      client_json = json.loads(client_units.split('Units: ')[1])
      for k, v in server_json.items():
        if k in client_json:
          compare_json(server_json[k], client_json[k], f'Unit_{k}', tick, ignore_float_error)
        else:
          print(f'\033[0mTick {tick}\nServer: \033[91mUnit_{k}\n\033[30m\033[44mMatching key not found in client\033[0m\n')
      for k, v in client_json.items():
        if k in server_json:
          compare_json(server_json[k], client_json[k], f'Unit_{k}', tick, ignore_float_error)
        else:
          print(f'\033[0mTick {tick}\nClient: \033[94mUnit_{k}\n\033[30m\033[41mMatching key not found in server\033[0m\n')
    elif line.startswith('ResMap'):
      server_json = json.loads(line.split('ResMap: ')[1])
      client_json = json.loads(client_resmap.split('ResMap: ')[1])
      compare_json(server_json, client_json, 'ResMap', tick, ignore_float_error)
    elif line.startswith('Destroyed'):
      continue
    elif line.startswith('TimerRemaining'):
      continue
    elif line.startswith('Skills'):
      continue
    else:
      if line not in client:
        print(f'\033[0mTick {tick}\nServer: \033[91m{line}\n\033[30m\033[44mMatching line not found in client\033[0m\n')


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--server', type=str, help='Path to server log file', default=path_server)
  parser.add_argument('--client', type=str, help='Path to client log file', default=path_client)
  parser.add_argument('--ignore_float_error', action='store_true', help='Ignore float error')
  args = parser.parse_args()

  if args.server:
    path_server = args.server
  if args.client:
    path_client = args.client

  for i in file_server:
    match_hash = re.search(r'Hash: ([0-9\-]+)', i)
    match_tick = re.search(r'Tick: ([0-9\-]+)', i)
    if match_hash and match_tick:
      hash_board = match_hash.group(1)
      tick_board = match_tick.group(1)

      values = i.split('\n')[1:]
      dict_server_hash[tick_board] = hash_board
      dict_server_value[hash_board] = values

  for i in file_client:
    match_hash = re.search(r'Hash: ([0-9\-]+)', i)
    match_tick = re.search(r'Tick: ([0-9\-]+)', i)
    if match_hash and match_tick:
      hash_board = match_hash.group(1)
      tick_board = match_tick.group(1)

      values = i.split('\n')[1:]
      dict_client_hash[tick_board] = hash_board
      dict_client_value[hash_board] = values

  for i in range(80):
    print('\033[45m' + ' '*80)
  print('\033[0m')

  for tick, server_hash in dict_server_hash.items():
    if tick in dict_client_hash:
      if server_hash != dict_client_hash[tick]:
        print(f'\n\033[0mTick {tick}\nServer: \033[91m{server_hash}\n\033[0mClient: \033[94m{dict_client_hash[tick]}\033[0m\n')
        print_diff(dict_server_value[server_hash], dict_client_value[dict_client_hash[tick]], tick, args.ignore_float_error)
        print('-' * 80)
      else:
        print_diff(dict_server_value[server_hash], dict_client_value[dict_client_hash[tick]], tick, args.ignore_float_error)
