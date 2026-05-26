import os.path
import subprocess
import platform
import sys


def is_linux():
  return platform.system() == 'Linux'


def is_mac():
  return platform.system() == 'Darwin'

def find_include_dirs(base_dirs):
    include_dirs = set()
    for base_dir in base_dirs:
      for root, dirs, files in os.walk(base_dir):
        include_dirs.add(root)
    return sorted(include_dirs)

def compile_proto(proto_file, protobuf_dir, compiler_dir, output_dir):
  if is_linux():
    protoc = 'protoc-lin'
  elif is_mac():
    protoc = 'protoc-mac'
  else:
    protoc = 'protoc.exe'

  include_dir = protobuf_dir
  base_dirs = [
    os.path.join(include_dir, 'Types'),
    os.path.join(include_dir, 'Resources'),
    os.path.join(include_dir, 'Packets'),
    os.path.join(include_dir, 'Game'),
  ]
  include_dirs = find_include_dirs(base_dirs)

  proto_file_path = os.path.join(protobuf_dir, os.path.dirname(proto_file))
  proto_file_name = os.path.basename(proto_file)

  cmd = [f'{compiler_dir}/{protoc}']
  for inc in include_dirs:
    cmd.append(f'-I={inc}')
  cmd.append(f'--python_out={output_dir}')
  cmd.append(f'--proto_path={proto_file_path}')
  cmd.append(proto_file_name)

  result = subprocess.run(
    cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE
  )
  if result.returncode != 0:
    print(f'{proto_file_name} 컴파일 실패')
    if result.stderr:
      err = result.stderr.decode().split('\n')
      for line in err:
        if line.endswith('warning: directory does not exist.'):
          continue
        sys.stderr.write(line + '\n')
    return False
  else:
    print(f'{proto_file_name} 컴파일됨')
    return True


TYPE_BOOL = 8
TYPE_BYTES = 12
TYPE_DOUBLE = 1
TYPE_ENUM = 14
TYPE_FIXED32 = 7
TYPE_FIXED64 = 6
TYPE_FLOAT = 2
TYPE_INT32 = 5
TYPE_INT64 = 3
TYPE_MESSAGE = 11
TYPE_SFIXED32 = 15
TYPE_SFIXED64 = 16
TYPE_SINT32 = 17
TYPE_SINT64 = 18
TYPE_STRING = 9
TYPE_UINT32 = 13
TYPE_UINT64 = 4

epsilon = 1e-6


def tobool(value):
  if isinstance(value, bool):
    return value
  if isinstance(value, str):
    return value.lower() in ['true', '1']
  if isinstance(value, int):
    return value != 0
  if isinstance(value, float):
    return abs(value) > epsilon
  return False


protobuf_type_map = {
  TYPE_INT32: int,
  TYPE_INT64: int,
  TYPE_SINT32: int,
  TYPE_SINT64: int,
  TYPE_UINT32: int,
  TYPE_UINT64: int,
  TYPE_BYTES: bytes,
  TYPE_FLOAT: float,
  TYPE_DOUBLE: float,
  TYPE_FIXED32: float,
  TYPE_FIXED64: float,
  TYPE_SFIXED32: float,
  TYPE_SFIXED64: float,
  TYPE_ENUM: str,
  TYPE_BOOL: tobool,
  TYPE_STRING: str,
}

LABEL_OPTIONAL = 1
LABEL_REPEATED = 3
LABEL_REQUIRED = 2
