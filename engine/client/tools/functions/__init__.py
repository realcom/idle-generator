from . import protobuf
from . import gsheets


def is_int(attr):
  if attr.lower() in ['int', 'integer', 'long', 'int32', 'uint32', 'int64', 'uint64']:
    return True
  return False


def is_float(attr):
  if attr.lower() in ['float', 'double', 'single', 'float32', 'float64']:
    return True
  return False


def is_bool(attr):
  if attr.lower() in ['bool', 'boolean']:
    return True
  return False


def contains_int_type(fields):
  for field in fields:
    if is_int(field):
      return True
  return False


def contains_float_type(fields):
  for field in fields:
    if is_float(field):
      return True
  return False


def contains_bool_type(fields):
  for field in fields:
    if is_bool(field):
      return True
  return False
