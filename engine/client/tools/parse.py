import functions
import argparse
import importlib
import re
import json
import os
import sys
import threading
from datetime import datetime


sys.stdout.reconfigure(encoding='utf-8')


def error(message):
  sys.stderr.write('[Parser] 오류: ' + message + '\n')
  exit(1)


def warning(message):
  sys.stderr.write('[Parser] 주의: ' + message + '\n')


try:
  from google.protobuf import json_format
except ImportError:
  error('콘솔에서 다음 명령어를 실행해 Protobuf를 설치해주세요: python -m pip install protobuf==5.26.0rc3')

protobuf_dir = '../Client/Assets/Scripts/Commons'

# all used protocol buffers
def find_proto_files(base_dir):
    proto_files = []
    resources_dir = os.path.join(base_dir, 'Resources')
    types_dir = os.path.join(base_dir, 'Types')
    
    for dir_path in [resources_dir, types_dir]:
        if os.path.exists(dir_path):
            for root, _, files in os.walk(dir_path):
                for file in files:
                    if file.endswith('.proto'):
                        # Get relative path from protobuf_dir
                        rel_path = os.path.relpath(os.path.join(root, file), base_dir)
                        proto_files.append(rel_path)
    return sorted(proto_files)

used_protobufs = find_proto_files(protobuf_dir)

# the directory where protoc binary is located
compiler_dir = '../Client/Assets/Scripts/Commons/build'
output_dir = './protobuf'
result_dir = '../Client/Assets/PatchResources/'
encodings = ['utf-8', 'cp949', 'latin1']

# Properties
UNUSED = 'NotUsed'
PROP_NOT_PARSED = 'PropNotParsed'
IGNORE = 'Ignore'
REPEATED = 'CommaSeparated'
FORCE_PARSE = 'ForceParse'

# Parsing different types
PARSE_VARIABLES = 'Variables'
INVENTORY_SHAPE = 'InventoryShape'
INVENTORY_SKILL_COMMANDS = 'InventorySkillCommands'
ADDBUFF = 'AddBuff'
INVENTORY_CELLS = 'InventoryCells'
STAT_TYPES = 'StatTypes'
ARRAY_2D = 'Array2D'

REF = 'Ref'
GROUPREF = 'GroupRef'
GROUPREF_GROUPID = 'GroupId'
REF_ID = 'RefId'

GLOBAL_VALUES = 'Global'


def import_proto(resource_type):
  module = importlib.import_module(f'protobuf.{resource_type}_pb2')
  return module



def parse_args():
  parser = argparse.ArgumentParser(description='Parse Google Sheets')
  parser.add_argument('type', type=str, help='Resource type', nargs='?')

  # parser.add_argument('keys', type=str, help='Google Sheets key', nargs='*', default=spreadsheet_keys)

  parser.add_argument('--compile', action='store_true', help='Compile the .proto file')
  parser.add_argument('--all', action='store_true', help='Compile all protocol buffer files')

  return parser.parse_args()


def iterate_protobuf(descriptor):
  for field in descriptor.fields:
    field_name = field.name
    field_type = field.type
    if field.message_type is not None:
      iterate_protobuf(field.message_type)
    print(f'{field_name} - {field_type}')
    if field.enum_type is not None:
      for value in field.enum_type.values:
        print(value.name)


def get_field_case_map(descriptor):
  field_case_map = {}
  for field in descriptor.fields:
    field_name = field.name
    field_case_map[field_name.lower()] = field_name
  return field_case_map


def preprocess_sheet(sheet, lower_headers=True):
  sheet_header = sheet[0]
  sheet_header = list(map(lambda x: x.replace(' ', '').lower() if lower_headers else x.replace(' ', ''), sheet_header))
  sheet_metadata = sheet[1]
  sheet_metadata = list(map(lambda x: split_and_parse(x, True), sheet_metadata))
  sheet_data = sheet[2:]
  sheet_data_filtered = []

  ignore_index = -1
  for i in range(len(sheet_metadata)):
    if IGNORE.lower() in sheet_metadata[i]:
      ignore_index = i

  for i in range(len(sheet_data)):
    row = []
    if ignore_index != -1 and convert_type(sheet_data[i][ignore_index].strip(), functions.protobuf.TYPE_BOOL):
      continue
    for j in range(len(sheet_data[i])):
      if j == ignore_index:
        continue
      if UNUSED.lower() not in sheet_metadata[j]:
        row.append(sheet_data[i][j].strip())
    sheet_data_filtered.append(row)

  sheet_header_filtered = []
  sheet_metadata_filtered = []

  for i in range(len(sheet_metadata)):
    if UNUSED.lower() not in sheet_metadata[i] and i != ignore_index:
      sheet_header_filtered.append(sheet_header[i])
      sheet_metadata_filtered.append(sheet_metadata[i])

  return sheet_header_filtered, sheet_metadata_filtered, sheet_data_filtered


def search_sheets(sheets, name):
  result = []
  for sheet_name, sheet in sheets.items():
    if '(' + name.lower() + ')' in sheet_name.lower():
      result.append(sheet)
  return result


def search_sheets_names(sheets, name):
  result = []
  for sheet_name, sheet in sheets.items():
    if '(' + name.lower() + ')' in sheet_name.lower():
      result.append(sheet_name)
  return result


def parse_datetime(value):
  known_formats = [
    "%Y-%m-%dT%H:%M:%S%z",
    "%Y-%m-%dT%H:%M:%S",
    "%Y-%m-%d %H:%M:%S",
    "%Y/%m/%d %H:%M:%S",
    "%Y-%m-%d",
    "%d-%m-%Y",
    "%d/%m/%Y",
    "%d %b %Y",
    "%d %B %Y",
    "%B %d, %Y",
    "%b %d, %Y",
    "%m/%d/%Y",
    "%m-%d-%Y",
    "%Y%m%d",
    "%H:%M:%S",
    "%H:%M",
    "%I:%M %p",
    "%I:%M%p",
    "%H%M",
    "%I%M%p",
  ]
  for format in known_formats:
    try:
      return int(datetime.timestamp(datetime.strptime(value, format)))
    except ValueError:
      continue
  error(f'날짜 및 시간 포맷을 읽지 못했습니다: \'{value}\'')


def convert_type(value, field_type, message_descriptor=None):
  if message_descriptor is not None and message_descriptor.name == 'Timestamp': # internal timestamp type
    if value.isdigit() or (value.replace('.', '', 1).isdigit() and value.count('.') == 1):
      return int(value)
    if value.strip() == '':
      return None
    return parse_datetime(value)
  if isinstance(value, list):
    if field_type in functions.protobuf.protobuf_type_map:
      for i in range(len(value)):
        try:
          value[i] = functions.protobuf.protobuf_type_map[field_type](value[i])
        except ValueError:
          value[i] = None
      value = list(filter(lambda x: x is not None, value))
      return value
    else:
      raise ValueError('Unknown field type')
  if field_type in functions.protobuf.protobuf_type_map:
    try:
      return functions.protobuf.protobuf_type_map[field_type](value)
    except ValueError:
      return 0
    return value
  else:
    raise ValueError('Unknown field type')


def split_and_parse(value, lower=False, delimiter=','):
  return list(map(lambda x: x.strip().lower() if lower else x.strip(), value.split(delimiter)))


def find_variable_key(variable_name):
  with open(os.path.join(result_dir, 'Strings.json'), 'rb') as f:
    data = json.load(f)
  for i in data['strings']:
    if 'english' in i and i['english'] == '@' + variable_name:
      return i['id']
  return None


def parse_values(value, repeated_field=False, parse_props=True, delimiter=','):
  if repeated_field:
    if parse_props:
      values = re.findall(r'(\[.*?\])', value)
      props = []
      for each_value in values:
        match = re.match(r'\[(.*)\]', each_value)
        if match:
          if len(match.group(1).split('=')) > 2:
            warning('필드에 =이 여러 개 존재합니다: ' + each_value)
            props.append({})
          else:
            props.append(dict(map(lambda x: split_and_parse(x, delimiter='='), match.group(1).split(delimiter))))
        else:
          props.append({})
      return props
    values = value.split(delimiter)
    values = list(filter(lambda x: x.strip() != '', values))
    values = list(map(lambda x: x.strip(), values))
    return values
  else:
    if parse_props:
      match = re.match(r'\[(.*)\]', value)
      if match:
        value = dict(map(lambda x: split_and_parse(x, delimiter='='), match.group(1).split(delimiter)))
      else:
        value = {}
      return value
    return value


def handle_repeated_message_ref(message_instance, field_name, field_descriptor, referenced_data):
    repeated_message = getattr(message_instance, field_name)
    # Assuming the first field is key by default
    repeated_ref_key = field_descriptor.message_type.fields_by_number[1].name
    repeated_ref_value = field_descriptor.message_type.fields_by_number[2].name

    for key, value in referenced_data.items():
      if key == '' or value == '':
        continue
      
      # Check if an instance with the same key already exists
      existing_message = None
      for msg in repeated_message:
        if getattr(msg, repeated_ref_key) == key:
          existing_message = msg
          break

      if existing_message is None:
        # Create a new message if no existing instance is found
        try:
          existing_message = repeated_message.add()
          setattr(existing_message, repeated_ref_key, key)
        except (TypeError, ValueError) as e:
          error(f"Failed to add or set key '{key}' for '{field_name}': {e}")
          continue

      # Handle repeated or single fields based on is_repeated
      try:
        field = field_descriptor.message_type.fields_by_name[repeated_ref_value]
      except KeyError as e:
        error(f"Field '{repeated_ref_value}' not found in '{field_name}': {e}")
        continue

      field_type = field.type
      field_label = field.label

      is_repeated = field_label == functions.protobuf.LABEL_REPEATED

      try:
        if is_repeated:
          field_value_parsed = parse_values(value, repeated_field=is_repeated, parse_props=False)
          field_value_parsed = convert_type(field_value_parsed, field_type)

          existing_field = getattr(existing_message, repeated_ref_value)
          existing_field.extend(field_value_parsed)
        else:
          field_value_parsed = parse_values(value, repeated_field=False, parse_props=False)
          field_value_parsed = convert_type(field_value_parsed, field_type)

          setattr(existing_message, repeated_ref_value, field_value_parsed)
      except (TypeError, ValueError) as e:
        error(f"Failed to process or set value for field '{repeated_ref_value}' in '{field_name}': {e}")


def handle_stat_types(message_instance, field_name, field_descriptor, referenced_data):
    repeated_message = getattr(message_instance, field_name)
    fields = field_descriptor.message_type.fields_by_name

    # Lowercased key-value map for referenced data
    referenced_data_with_lowered_key = {k.lower(): v for k, v in referenced_data.items()}

    # Add single message and populate all fields
    nested_message = repeated_message.add()

    for key, value in fields.items():
        field_key = key.lower()  # Lowercased for consistency
        if field_key in referenced_data_with_lowered_key:
            if value.label == functions.protobuf.LABEL_REPEATED:
                # Handle repeated fields (e.g., value)
                parsed_values = parse_values(referenced_data_with_lowered_key[field_key], repeated_field=True, parse_props=False)
                for parsed_value in parsed_values:
                    try:
                        converted_value = convert_type(parsed_value, value.type)
                        getattr(nested_message, key).append(converted_value)
                    except ValueError:
                        warning(f"'{field_name}' 필드에는 '{parsed_value}' 값이 잘못된 타입입니다.")
                    except TypeError:
                        warning(f"'{field_name}' 필드에서 '{parsed_value}'를 변환하는 동안 타입 오류가 발생했습니다.")
            else:
                # Handle single fields (e.g., itemGroup)
                try:
                    converted_value = convert_type(referenced_data_with_lowered_key[field_key], value.type)
                    setattr(nested_message, key, converted_value)
                except ValueError:
                    warning(f"'{field_name}' 필드에는 '{referenced_data_with_lowered_key[field_key]}' 값이 잘못된 타입입니다.")
                except TypeError:
                    warning(f"'{field_name}' 필드에서 '{referenced_data_with_lowered_key[field_key]}'를 변환하는 동안 타입 오류가 발생했습니다.")
                except KeyError:
                    warning(f"'{field_key}'는 프로토콜 버퍼 필드에 존재하지 않습니다.")
        else:
            warning(f"'{field_key}' 필드는 참조 데이터에 존재하지 않습니다.")


def handle_repeated_message_variables(message_instance, field_name, field_value):
  repeated_message = getattr(message_instance, field_name)

  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False)
  field_value_parsed = dict(map(lambda x: [x.split('=')[0].strip(), float(x.split('=')[1].strip())], field_value_parsed))

  for key, value in field_value_parsed.items():
    variable_key = find_variable_key(key)
    if variable_key is None:
      continue
    nested_message = repeated_message.add()
    setattr(nested_message, 'callerKey', find_variable_key(key))
    setattr(nested_message, 'value', value)


def handle_repeated_message(message_instance, field_name, field_value, metadata_single):
  repeated_message = getattr(message_instance, field_name)
  parse_props = PROP_NOT_PARSED.lower() not in metadata_single and re.match(r'\[(.*)\]', field_value)
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=parse_props)
  try:
    for value_map in field_value_parsed:
      for key, value in value_map.items():
        key = key.strip()
        value = value.strip()
        if key == '':
          continue
        key_type = message_instance.DESCRIPTOR.fields_by_name[field_name].message_type.fields_by_name['key'].type
        value_type = message_instance.DESCRIPTOR.fields_by_name[field_name].message_type.fields_by_name['value'].type
        key = convert_type(key, key_type)
        value = convert_type(value, value_type)
        repeated_message[key] = value
  except AttributeError:
    print(f'뭔가 ㅈ같은 데이터 발견. \'{field_value_parsed}\'')

def handle_message(message_instance, field_name, field_value, metadata_single):
  nested_message = getattr(message_instance, field_name)
  nested_field_map = nested_message.DESCRIPTOR.fields_by_name
  for j, nested_field_value in enumerate(field_value.split(',')):
    nested_field_name = nested_field_map[nested_field_map.keys()[j]].name
    nested_field_type = nested_field_map[nested_field_name].type
    parse_props = PROP_NOT_PARSED.lower() not in metadata_single and re.match(r'\[(.*)\]', field_value)
    nested_field_value = parse_values(nested_field_value, parse_props=parse_props)
    if field_value.strip() == '':
      continue
    if parse_props:
      # TODO: implement full prop parser
      for prop_name, prop_value in nested_field_value.items():
        each_name = prop_name
        each_value = convert_type(prop_value, nested_field_type, nested_message.DESCRIPTOR)
        setattr(nested_message, each_name, each_value)
    else:
      try:
        nested_field_value = convert_type(nested_field_value, nested_field_type, nested_message.DESCRIPTOR)
      except ValueError:
        warning(f'필드에 알 수 없는 타입이 있습니다: \'{nested_field_name}\'')
        continue
      if nested_field_value is not None:
        setattr(nested_message, nested_field_name, nested_field_value)


def handle_message_ref(sheets, message_instance, field_name, field_value, metadata_single):
  referenced_table_name = metadata_single[0].split('=')[1]
  referenced_tables = search_sheets(sheets, referenced_table_name)
  referenced_tables_names = search_sheets_names(sheets, referenced_table_name)

  if len(referenced_tables) == 0:
    error(f'\'{field_name}\' 필드에서 참조하는 시트 \'{referenced_tables}\'를 찾지 못했습니다.')

  inner_instance = getattr(message_instance, field_name)

  message_fields = inner_instance.DESCRIPTOR.fields_by_name
  message_field_case_map = get_field_case_map(inner_instance.DESCRIPTOR)

  found = False
  for index, table in enumerate(referenced_tables):
    header, metadata, data = preprocess_sheet(table, lower_headers=False)
    ref_id_column = None
    for column in metadata:
      if REF_ID.lower() in column:
        if ref_id_column is not None:
          error(f'\'{referenced_tables_names[index]}\' 시트의 열 \'{REF_ID}\'이(가) 중복되었습니다.')
        ref_id_column = metadata.index(column)
    if ref_id_column is None:
      warning(f'필드 \'{field_name}\가 참조하는 테이블 \'{referenced_tables_names[index]}\' 에 RefId로 지정된 열이 없습니다. 첫 번째 열을 Id로 사용합니다.')
      ref_id_column = 0
    for row in data:
      if row[ref_id_column] == field_value:
        if found:
          error(f'\'{field_name}\' 필드의 Id \'{field_value}\'이(가) 중복되었습니다.')
        found = True
        for i in range(0, len(header)):
          if i == ref_id_column:
            continue
          message_field_name = header[i]
          message_field_value = row[i]
          try:
            message_field_type = message_fields[message_field_case_map[message_field_name.lower()]].type
            message_field_label = message_fields[message_field_case_map[message_field_name.lower()]].label
            if message_field_label == functions.protobuf.LABEL_REPEATED:
              handle_repeated(inner_instance, message_field_case_map[message_field_name.lower()], message_field_value, message_field_type)
            elif message_field_type == functions.protobuf.TYPE_MESSAGE:
              # TODO: handle the case where only a single value is provided
              handle_message_ref(sheets, inner_instance, message_field_case_map[message_field_name.lower()], message_field_value, metadata[i])
            else:
              handle_value(inner_instance, message_field_case_map[message_field_name.lower()], message_field_value, message_field_type)
          except KeyError:
            error(f'\'{field_name}\' 구조에는 \'{message_field_name}\' 필드가 없습니다.')


def handle_repeated(message_instance, field_name, field_value, field_type):
  repeated_field = getattr(message_instance, field_name)
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False)
  for value in field_value_parsed:
    value = value.strip()
    if value == '':
      continue
    value = convert_type(value, field_type)
    try:
      repeated_field.append(value)
    except ValueError:
      warning(f'\'{field_name}\' 필드에는 \'{value}\' 타입이 없습니다.')


def handle_value(message_instance, field_name, field_value, field_type):
  field_value = convert_type(field_value, field_type)
  # handle empty enum type
  if field_type == functions.protobuf.TYPE_ENUM and field_value == '':
    field_value = 0
  try:
    setattr(message_instance, field_name, field_value)
  except ValueError as e:
    if 'unknown enum label' in str(e):
      error(f'\'{field_name}\' 필드에는 \'{field_value}\' 타입이 없습니다.')


# a special handler for the inventory shape
def handle_inventory_shape(message_instance, field_name, field_value):
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False, delimiter='\n')
  message = getattr(message_instance, field_name)
  # Note: hardcoded names
  message_row = getattr(message, 'rows')
  for value in field_value_parsed:
    value = value.strip()
    if value == '':
      continue
    new_row = message_row.add()
    # Note: hardcoded names
    new_cells = getattr(new_row, 'cells')
    for cell in value:
      new_cells.append(convert_type(cell, functions.protobuf.TYPE_BOOL))

def handle_array_2d_shape(message_instance, field_name, field_value):
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False, delimiter='\n')
  message = getattr(message_instance, field_name)
  # Note: hardcoded names
  message_row = getattr(message, 'rows')
  for value in field_value_parsed:
    value = value.strip()
    if value == '':
      continue
    new_row = message_row.add()
    # Note: hardcoded names
    new_cells = getattr(new_row, 'cells')
    for cell in value.split(','):
      new_cells.append(convert_type(cell, functions.protobuf.TYPE_FLOAT))

# a special handler for the inventory skill commands
def handle_inventory_skill_commands(message_instance, field_name, field_value, all_sheets):
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False)
  message = getattr(message_instance, field_name)

  # Note: hardcoded names
  inventory_skill_commands_sheets = search_sheets(all_sheets, 'InventorySkillCommands')
  command_items_sheets = search_sheets(all_sheets, 'CommandItems')

  inventory_skill_commands_hashmap = {}
  for sheet in inventory_skill_commands_sheets:
    header, metadata, data = preprocess_sheet(sheet, lower_headers=False)
    for row in data:
      if row[0] in inventory_skill_commands_hashmap:
        inventory_skill_commands_hashmap[row[0]].append(row[1:])
      else:
        inventory_skill_commands_hashmap[row[0]] = [row[1:]]

  command_items_hashmap = {}
  for sheet in command_items_sheets:
    header, metadata, data = preprocess_sheet(sheet, lower_headers=False)
    for row in data:
      if row[0] in command_items_hashmap:
        command_items_hashmap[row[0]].append(row[1:])
      else:
        command_items_hashmap[row[0]] = [row[1:]]

  for value in field_value_parsed:
    value = value.strip()
    if value == '':
      continue

    if value in inventory_skill_commands_hashmap:
      for inventory_skill_command in inventory_skill_commands_hashmap[value]:
        new_command = message.add()
        # Note: fetching value by columnal index
        command_items = parse_values(inventory_skill_command[0], repeated_field=True, parse_props=False)
        for command_item in command_items:
          if command_item in command_items_hashmap:
            # Note: hardcoded names
            for item in command_items_hashmap[command_item]:
              new_command_item = getattr(new_command, 'items').add()
              # Note: hardcoded columns
              dx = item[0]
              dy = item[1]
              item_group = item[2]
              item_grade = item[3]
              handle_value(new_command_item, 'dx', dx, functions.protobuf.TYPE_INT32)
              handle_value(new_command_item, 'dy', dy, functions.protobuf.TYPE_INT32)
              handle_value(new_command_item, 'itemGroup', item_group, functions.protobuf.TYPE_INT32)
              handle_value(new_command_item, 'itemGrade', item_grade, functions.protobuf.TYPE_INT32)

        # Note: fetching value by columnal index
        buff_data_id = inventory_skill_command[1]
        field_type = functions.protobuf.TYPE_INT32
        handle_value(new_command, 'buffDataId', buff_data_id, field_type)


# a special handler for the addbuffs
def handle_addbuff(message_instance, field_name, field_value, all_sheets):
  field_value_parsed = parse_values(field_value, repeated_field=True, parse_props=False)
  message = getattr(message_instance, field_name)

  # Note: hardcoded names
  addbuff_sheets = search_sheets(all_sheets, 'AddBuff')

  addbuff_hashmap = {}
  addbuff_columns_hashmap = {}
  for sheet in addbuff_sheets:
    header, metadata, data = preprocess_sheet(sheet, lower_headers=False)
    for row in data:
      # assume the first column is the key
      if row[0] in addbuff_hashmap:
        addbuff_hashmap[row[0]].append(row)
      else:
        addbuff_hashmap[row[0]] = [row]
        addbuff_columns_hashmap[row[0]] = list(map(lambda x: x.lower(), header))

  for value in field_value_parsed:
    value = value.strip()
    if value == '':
      continue

    if value in addbuff_hashmap:
      for key, addbuff in enumerate(addbuff_hashmap[value]):
        addbuff_message = message.add()
        column_map = addbuff_columns_hashmap[value]

        # Note: hardcoded names
        index_buff_data_id = column_map.index('buffdataid')
        buff_data_id = addbuff[index_buff_data_id]
        setattr(addbuff_message, 'buffDataId', convert_type(buff_data_id, functions.protobuf.TYPE_INT32))

        # Note: hardcoded names
        index_duration = column_map.index('duration')
        duration = addbuff[index_duration]
        setattr(addbuff_message, 'duration', convert_type(duration, functions.protobuf.TYPE_FLOAT))

        # Note: hardcoded names
        index_level = column_map.index('level')
        level = addbuff[index_level]
        setattr(addbuff_message, 'level', convert_type(level, functions.protobuf.TYPE_INT32))

        
        # Note: hardcoded names
        
        apply_target_id = column_map.index('applytarget')
        apply_target = addbuff[apply_target_id]

        handle_value(addbuff_message, 'applyTarget', apply_target, functions.protobuf.TYPE_ENUM)
        

        # Note: hardcoded names
        try:
          index_consecutiveapplyaddbuffs = column_map.index('consecutiveapplyaddbuffs')
          consecutiveapplyaddbuffs = addbuff[index_consecutiveapplyaddbuffs]
          handle_addbuff(addbuff_message, 'consecutiveApplyAddBuffs', consecutiveapplyaddbuffs, all_sheets)
        except:
          pass


    if value not in addbuff_hashmap:
      warning(f'Id가 일치하는 AddBuff를 찾을 수 없습니다: \'{value}\'')


def handle_inventory_cells(message_instance, field_name, field_value):
  field_value_parsed = parse_values(field_value, repeated_field=False, parse_props=False)
  inventory_cells = re.findall(r'\((.*?)\)', field_value)
  message = getattr(message_instance, field_name)
  for value in inventory_cells:
    value = re.sub(r'\s+', '', value)
    if value == '':
      continue
    try:
      new_cell = message.add()
      cell_coords = value.split(',')
      setattr(new_cell, 'dx', convert_type(cell_coords[0], functions.protobuf.TYPE_INT32))
      setattr(new_cell, 'dy', convert_type(cell_coords[1], functions.protobuf.TYPE_INT32))
    except:
      warning(f'InventoryCells에 잘못된 값이 있습니다: \'{value}\'')


def parse_sheet(all_sheets_dict, sheets, message, field_map, field_case_map, resource_type):
  result = []
  result_additional_fields = []
  hashmap = {}
  id_index = -1
  category_index = -1
  key_index = -1
  for sheet in sheets:
    header, metadata, data = preprocess_sheet(sheet, lower_headers=False)
    header_lower = list(map(lambda x: x.lower(), header))

    if resource_type == 'Achievement' or resource_type == 'Audio' or resource_type == 'Buff' or resource_type == 'Item' or resource_type == 'Map' or resource_type == 'Skill' or resource_type == 'Unit':
      if 'id' not in header_lower:
        error(f'\'{resource_type}\' 시트에 \'id\' 열이 없습니다.')
      id_index = header_lower.index('id')
    if resource_type == 'String':
      if 'category' not in header_lower:
        error('\'String\' 시트에 \'category\' 열이 없습니다.')
      if 'key' not in header_lower:
        error('\'String\' 시트에 \'key\' 열이 없습니다.')
      category_index = header_lower.index('category')
      key_index = header_lower.index('key')
      if 'id' in header_lower:
        id_index = header_lower.index('id')

    for row in data:
      # ignore empty rows
      if ''.join(row).strip() == '':
        continue
      
      
      # ignore rows with empty id or not intergable value (but not for String)
      if resource_type != 'String':
        try:
          int(row[id_index].strip())
        except:
          continue
      else:
        if row[id_index].strip() == "" and row[category_index].strip() == "" and  row[key_index].strip() == "":
          continue
      
      if resource_type == 'Achievement' or resource_type == 'Audio' or resource_type == 'Buff' or resource_type == 'Item' or resource_type == 'Map' or resource_type == 'Skill' or resource_type == 'Unit':
        if row[id_index] in hashmap:
          error(f'\'{resource_type}\' 시트에 중복된 id가 있습니다: \'{row[id_index]}\'')
        hashmap[row[id_index]] = True

      if resource_type == 'String':
        if id_index == -1:
          if row[category_index] + row[key_index] in hashmap:
            error(f'\'{resource_type}\' 시트에 category와 key가 모두 중복된 항목이 있습니다: \'{row[category_index]}\' / \'{row[key_index]}\'')
          hashmap[row[category_index] + row[key_index]] = True
        else:
          if row[id_index] + row[category_index] + row[key_index] in hashmap:
            error(f'\'{resource_type}\' 시트에 id, category, key가 모두 중복된 항목이 있습니다: \'{row[id_index]}\' / \'{row[category_index]}\' / \'{row[key_index]}\'')
          hashmap[row[id_index] + row[category_index] + row[key_index]] = True  

      additional_fields = {}

      message_instance = message()
      for i in range(len(header)):
        field_name = header[i]
        if field_name.strip() == '':
          continue
        field_exists_in_protobuf = True
        field_name_camelcase = field_name[0].lower() + field_name[1:]
        field_name_lowercase = field_name.lower()
        try:
          field_type = field_map[field_case_map[field_name_lowercase]].type
          field_label = field_map[field_case_map[field_name_lowercase]].label
        except KeyError:
          if FORCE_PARSE.lower() in metadata[i]:
            # TODO: support more types if required
            if functions.contains_int_type(metadata[i]):
              field_type = functions.protobuf.TYPE_INT32
            elif functions.contains_float_type(metadata[i]):
              field_type = functions.protobuf.TYPE_FLOAT
            elif functions.contains_bool_type(metadata[i]):
              field_type = functions.protobuf.TYPE_BOOL
            else:
              field_type = functions.protobuf.TYPE_STRING
            field_label = functions.protobuf.LABEL_OPTIONAL
            field_exists_in_protobuf = False
          else:
            error(f'protobuf에 \'{field_name}\' 필드가 정의되어 있지 않습니다. 필드를 정의하거나 메타데이터 행에 ForceParse를 추가하세요. {header}')

        field_value = row[i]
        if field_value.strip() == "":
          continue

        ref_other_table = any(j.startswith(REF.lower() + '=') for j in metadata[i])
        groupref_other_table = any(j.startswith(GROUPREF.lower() + '=') for j in metadata[i])
        
        if INVENTORY_SHAPE.lower() in metadata[i]:
          # handle the inventory shape
          handle_inventory_shape(message_instance, field_case_map[field_name_lowercase], field_value)
        elif ARRAY_2D.lower() in metadata[i]:
          # handle the inventory shape
          handle_array_2d_shape(message_instance, field_case_map[field_name_lowercase], field_value)

        elif INVENTORY_SKILL_COMMANDS.lower() in metadata[i]:
          # handle the inventory skill commands
          handle_inventory_skill_commands(message_instance, field_case_map[field_name_lowercase], field_value, all_sheets_dict)
        elif ADDBUFF.lower() in metadata[i]:
          # handle the addbuffs
          handle_addbuff(message_instance, field_case_map[field_name_lowercase], field_value, all_sheets_dict)
        elif INVENTORY_CELLS.lower() in metadata[i]:
          # handle the inventory cells
          handle_inventory_cells(message_instance, field_case_map[field_name_lowercase], field_value)
        # repeated fields with nested messages
        elif field_type == functions.protobuf.TYPE_MESSAGE and field_label == functions.protobuf.LABEL_REPEATED:
          # only handle the case where the explicit reference is provided (addStats)
          # note: ref is only used for repeated message fields.
          if ref_other_table:
            handle_ref_datas(message_instance, metadata[i], field_case_map, field_map, field_name, field_name_lowercase,
                                 field_value, all_sheets_dict)
          elif groupref_other_table:
            # explicit grouped reference to the other table
            groupref_tables = []
            for table in metadata[i]:
              if table.startswith(GROUPREF.lower() + '='):
                groupref = table.split('=')[1]
                groupref_tables = search_sheets(all_sheets_dict, groupref)

            field_value_match = re.findall(r'\[(.*)\]', field_value)

            for group in field_value_match:
              # Phase #1: create a group and set the properties
              group_result = getattr(message_instance, field_case_map[field_name_lowercase]).add()
              group_values = split_and_parse(group)
              # parse each properties: only key is lowercased, value is not
              group_values = dict(
                  (x.split('=')[0].strip().lower(), x.split('=', 1)[1].strip())
                  for x in group_values if '=' in x
              )
              group_id = group_values[GROUPREF_GROUPID.lower()]
              del group_values[GROUPREF_GROUPID.lower()]
              group_properties_case_map = get_field_case_map(field_map[field_case_map[field_name_lowercase]].message_type)
              # assign group properties to the message
              for key, value in group_values.items():
                try:
                  group_property_field_type = field_map[field_case_map[field_name_lowercase]].message_type.fields_by_name[group_properties_case_map[key]].type
                  setattr(group_result, group_properties_case_map[key],  convert_type(value, group_property_field_type))
                except KeyError:
                  error(f'\'{key}\' 필드가 \'{field_case_map[field_name_lowercase]}\' 타입에 정의되어 있지 않습니다.')

              # Phase 2: fill in the repeated properties of the group
              inner_fields = group_result.DESCRIPTOR.fields_by_name
              inner_message = None
              inner_message_type = functions.protobuf.TYPE_FLOAT
              for inner_field_name, inner_field_value in inner_fields.items():
                if inner_field_value.label == functions.protobuf.LABEL_REPEATED:
                  # it is the type where we'd like to add the stats to
                  inner_message = getattr(group_result, inner_field_name)
                  inner_message_type = inner_field_value.type
                  break

              for table in groupref_tables:
                inner_header, inner_metadata, inner_data = preprocess_sheet(table, False)
                for inner_row in inner_data:
                  if inner_row[0] != group_id:
                    continue



                  try:
                    inner_field = inner_message.add()
                    inner_field_map = inner_field.DESCRIPTOR.fields_by_name
                    inner_field_case_map = get_field_case_map(inner_field.DESCRIPTOR)


                    row_dict = {}
                    for k in range(1, len(inner_header)):

                      if UNUSED.lower() in inner_metadata[k]:
                        continue
                      ref_other_table = any(j.startswith(REF.lower() + '=') for j in inner_metadata[k])
                      if ref_other_table:
                        handle_ref_datas(inner_field, inner_metadata[k], inner_field_case_map, inner_field_map, inner_field_case_map[inner_header[k].lower()],
                                         inner_field_case_map[inner_header[k].lower()].lower(),inner_row[k],
                                         all_sheets_dict)
                      else:
                        try:
                          setattr(
                            inner_field,
                            inner_field_case_map[inner_header[k].lower()],
                            convert_type(inner_row[k], inner_field_map[inner_field_case_map[inner_header[k].lower()]].type)
                          )
                        except Exception as e:
                          error(
                            f"[parse_sheet] inner_field에 값을 할당하는 중 오류 발생\n"
                            f"  - id: {row[id_index]}\n"
                            f"  - inner_data: {inner_data}\n"
                            f"  - group_result: {group_result}\n"
                            f"  - inner_field: {inner_field}\n"
                            f"  - field_name: {inner_header[k]}\n"
                            f"  - field_value: {inner_row[k]}\n"
                            f"  - message: {e}"
                          )
                  except AttributeError:
                    # handler for AddStats (handling comma separated values)
                    # note: only one type of stat can be added at once
                    for k in range(1, len(inner_header)):
                      if UNUSED.lower() in inner_metadata[k]:
                        continue
                      values = parse_values(inner_row[k], repeated_field=True, parse_props=False)
                      if len(values) == 0:
                        continue
                      # Note: hardcoded name
                      if hasattr(group_result, 'type') and len(inner_message) > 0:
                        group_result = getattr(message_instance, field_case_map[field_name_lowercase]).add()
                        inner_message = getattr(group_result, inner_field_name)
                        setattr(group_result, 'type', inner_header[k])
                      else:
                        setattr(group_result, 'type', inner_header[k])
                      for value in values:
                        inner_message.append(convert_type(value, inner_message_type))

          elif PARSE_VARIABLES.lower() in metadata[i]:
            handle_repeated_message_variables(message_instance, field_case_map[field_name_lowercase], field_value)
          else: # other repeated messages
            #print(message_instance.DESCRIPTOR.fields)
            handle_repeated_message(message_instance, field_case_map[field_name_lowercase], field_value, metadata[i])
        # messages (Vector2, ...)
        elif field_type == functions.protobuf.TYPE_MESSAGE:
          if ref_other_table:
            handle_message_ref(all_sheets_dict, message_instance, field_case_map[field_name_lowercase], field_value, metadata[i])
            #handle_message_ref(all_sheets_dict, message_instance, field_case_map[field_name_lowercase], field_map[field_case_map[field_name_lowercase]], dict(zip(ref_values, ref_values)), metadata[i])
          else:
            handle_message(message_instance, field_case_map[field_name_lowercase], field_value, metadata[i])
        # repeated fields
        elif field_label == functions.protobuf.LABEL_REPEATED:
          handle_repeated(message_instance, field_case_map[field_name_lowercase], field_value, field_type)
        elif not field_exists_in_protobuf and REPEATED.lower() in metadata[i]:
          additional_fields[field_name_camelcase] = convert_type(parse_values(field_value, repeated_field=True, parse_props=False), field_type)
        elif not field_exists_in_protobuf:
          additional_fields[field_name_camelcase] = convert_type(field_value, field_type)
        else:
          handle_value(message_instance, field_case_map[field_name_lowercase], field_value, field_type)

      result_row = json.loads(json_format.MessageToJson(message_instance))

      for key, value in additional_fields.items():
        result_row[key] = value

      # omit empty values
      if result_row:
        result.append(result_row)

  return result


def handle_ref_datas(message_instance,metadata, field_case_map, field_map, field_name, field_name_lowercase, field_value,
                     all_sheets_dict):
  # explicit reference to the other table (for each value)
  ref_tables = []
  ref_tables_names = []
  for table in metadata:
    if table.startswith(REF.lower() + '='):
      ref = table.split('=')[1].strip()
      ref_tables.extend(search_sheets(all_sheets_dict, ref))
      ref_tables_names.extend(search_sheets_names(all_sheets_dict, ref))
  if len(ref_tables) == 0:
    error(f'\'{field_name}\' 열에 대한 참조 시트를 찾을 수 없습니다.')
  ref_values = split_and_parse(field_value)
  # iterate through the reference tables
  for index, table in enumerate(ref_tables):
    inner_header, inner_metadata, inner_data = preprocess_sheet(table, False)
    ref_id_column = None
    for column in inner_metadata:
      if REF_ID.lower() in column:
        if ref_id_column is not None:
          error(f'\'{ref_tables_names[index]}\' 테이블에 중복된 열이 있습니다: \'{REF_ID}\'')
        ref_id_column = inner_metadata.index(column)
    if ref_id_column is None:
      warning(f'필드 \'{field_name}\가 참조하는 테이블 \'{ref_tables_names[index]}\' 에 RefId로 지정된 열이 없습니다. 첫 번째 열을 Id로 사용합니다.')
      ref_id_column = 0
    # iterate through the rows
    for inner_row in inner_data:
      if inner_row[0] in ref_values:
        row_dict = {}
        for k in range(1, len(inner_header)):
          if UNUSED.lower() not in inner_metadata[k]:
            row_dict[inner_header[k]] = inner_row[k]
        if STAT_TYPES.lower() in metadata:
          handle_stat_types(message_instance, field_case_map[field_name_lowercase],
                            field_map[field_case_map[field_name_lowercase]], row_dict)
        else:
          handle_repeated_message_ref(message_instance, field_case_map[field_name_lowercase],
                                      field_map[field_case_map[field_name_lowercase]], row_dict)


def parse_global(sheets, message, resource_type):
  results = {}
  global_types = message.DESCRIPTOR.nested_types_by_name[GLOBAL_VALUES].nested_types_by_name
  global_key_map = get_field_case_map(message.DESCRIPTOR.nested_types_by_name[GLOBAL_VALUES])
  for global_key, _ in global_types.items():
    result = {}
    try:
      global_fields = message.DESCRIPTOR.nested_types_by_name[GLOBAL_VALUES].nested_types_by_name[global_key]
    except KeyError:
      warning('Protobuf에서 global 메시지를 찾지 못했습니다.')
      return results
    global_fields_name_map = get_field_case_map(message.DESCRIPTOR.nested_types_by_name[GLOBAL_VALUES].nested_types_by_name[global_key])
    for sheet in sheets:
      header, metadata, data = preprocess_sheet(sheet)
      type_index = 1
      for index, field in enumerate(metadata):
        if 'type' in field:
          type_index = index
      data_index = 2
      for index, field in enumerate(metadata):
        if 'data' in field:
          data_index = index
      value_index = 3
      for index, field in enumerate(metadata):
        if 'value' in field:
          value_index = index
      for row in data:
        # note: this function reads each field by the order.
        if row[0].strip().lower() == resource_type.lower() and row[type_index].strip().lower() == global_key.lower() and global_key.lower() == 'statconstants':
          # handle the stat constants specially
          key = row[data_index].strip().lower()
          if 'statConstants' in results:
            result = results['statConstants']
          if key == 'usepercentdefense':
            result['usePercentDefense'] = convert_type(row[value_index].strip(), functions.protobuf.TYPE_BOOL)
          elif key == 'damagecoefficients':
            if 'damageCoefficients' not in result:
              result['damageCoefficients'] = []
            value = row[value_index].strip()
            value_dict = dict(map(lambda x: tuple(map(lambda y: y.strip().lower(), x.strip().split('='))), value.split(',')))
            armor_type_enum_map = {
              'normalarmor': 0,
              'light': 1,
              'heavy': 2,
            }
            damage_type_enum_map = {
              'normaldamage': 0,
              'pierce': 1,
              'explosive': 2,
              'spell': 3,
            }
            try:
              new_data = {
                'damagePercent': convert_type(value_dict['damagepercent'].strip(), functions.protobuf.TYPE_FLOAT),
                'armorType': armor_type_enum_map[value_dict['armortype'].strip().lower()],
                'damageType': damage_type_enum_map[value_dict['damagetype'].strip().lower()],
              }
              result['damageCoefficients'].append(new_data)
            except KeyError:
              warning('damageCoefficients에 알 수 없는 값이 있습니다.')
          results[global_key_map[global_key.lower()]] = result
        elif row[0].strip().lower() == resource_type.lower() and row[type_index].strip().lower() == global_key.lower():
          key = row[data_index].strip().lower()
          if key in global_fields_name_map:
            key = global_fields_name_map[key]
            if key == 'defaultPlayerInventoryShapes':
              result[key] = []
              shape_blocks = row[value_index].strip().split('---')
              for block in shape_blocks:
                shape_message = {'rows': []}
                inventory_rows = block.strip().split('\n')
                for inventory_row in inventory_rows:
                  row_message = {'cells': []}
                  for cell in inventory_row.strip():
                    row_message['cells'].append(convert_type(cell, functions.protobuf.TYPE_BOOL))
                  shape_message['rows'].append(row_message)
                result[key].append(shape_message)
            elif global_fields.fields_by_name[key].label == functions.protobuf.LABEL_REPEATED:
              if key not in result:
                result[key] = []
              values = row[value_index].strip().split(',')
              for value_each in values:
                result[key].append(convert_type(value_each.strip(), global_fields.fields_by_name[key].type))
            else:
              value = convert_type(row[value_index].strip(), global_fields.fields_by_name[key].type)
              result[key] = value
          results[global_key_map[global_key.lower()]] = result
  return results


def update_json(resource_type, result):
  data = {}
  for encoding in encodings:
    try:
      with open(os.path.join(result_dir, resource_type + 's.json'), 'r', encoding=encoding) as f:
        data = json.load(f)
        break
    except UnicodeDecodeError:
      error(f'JSON 파일을 읽는 중 오류가 발생했습니다. 인코딩을 확인하세요. (현재 인코딩: {encoding})')
    except FileNotFoundError:
      data = {}
      break

  result = sorted(result, key=lambda x: x['id'] if 'id' in x else 0)

  resource_type_lower = resource_type.lower()
  
  # 기존 Global 값 유지
  existing_global_key = resource_type_lower + GLOBAL_VALUES
  preserved_global = data.get(existing_global_key, None)

  # 데이터 갱신
  data[resource_type_lower + 's'] = result
  data[existing_global_key] = preserved_global if (preserved_global is not None) == True else {}

  def sort_dict_recursively(obj):
      """dict는 알파벳순으로 정렬, list는 내부 원소를 재귀적으로 처리"""
      if isinstance(obj, dict):
          # 키를 알파벳순으로 정렬된 새로운 dict 생성
          return {k: sort_dict_recursively(v) for k, v in sorted(obj.items())}
      elif isinstance(obj, list):
          # 리스트 내부 요소도 재귀적으로 처리
          return [sort_dict_recursively(elem) for elem in obj]
      else:
          # 기본 자료형은 그대로 반환
          return obj

  data = sort_dict_recursively(data)
  

  try:
    with open(os.path.join(result_dir, resource_type + 's.json'), 'w', encoding='utf-8') as f:
      json.dump(data, f, indent=2, ensure_ascii=False)
  except Exception as e:
    error(f'\'{resource_type}s.json\' 파일을 쓰는 중 오류가 발생했습니다.\n{e}')


class ProtobufCompiler(threading.Thread):
  def __init__(self, used_protobuf, protobuf_dir, compiler_dir, output_dir):
    threading.Thread.__init__(self)
    self.used_protobuf = used_protobuf
    self.protobuf_dir = protobuf_dir
    self.compiler_dir = compiler_dir
    self.output_dir = output_dir
    self.result = False

  def run(self):
    self.result = functions.protobuf.compile_proto(self.used_protobuf, self.protobuf_dir, self.compiler_dir, self.output_dir)


def compile_all(used_protobuf, protobuf_dir, compiler_dir, output_dir):
  compilers = []
  for used_protobuf in used_protobufs:
    compiler = ProtobufCompiler(used_protobuf, protobuf_dir, compiler_dir, output_dir)
    compiler.start()
    compilers.append(compiler)
  for compiler in compilers:
    compiler.join()
  for compiler in compilers:
    if not compiler.result:
      warning(f'\'{compiler.used_protobuf}\' 컴파일 실패')
      return False
  return True


# 최소 검증 절차 추가
def validate_result(resource_type, result):
  errors = []
  if not result:
    errors.append('결과가 비어 있습니다.')
  # 각 타입별 검증
  if resource_type == 'Achievement':
    pass
  elif resource_type == 'Audio':
    pass
  elif resource_type == 'Buff':
    pass
  elif resource_type == 'Item':
    pass
  elif resource_type == 'Map':
    pass
  elif resource_type == 'Skill':
    pass
  elif resource_type == 'Unit':
    for row in result:
      if 'addStats' not in row:
        errors.append(f'Unit id={row.get('id', '?')} name={row.get('name', '?')}에 addStats 필드가 없습니다.')
  elif resource_type == 'String':
    pass


    if errors:
        print('[검증 실패]')
        for err in errors:
            print('  -', err)
    else:
        print('[검증 성공]')



class ResourceParser(threading.Thread):
  def __init__(self, resource_type, all_sheets_dict):
    threading.Thread.__init__(self)
    self.resource_type = resource_type
    self.all_sheets_dict = all_sheets_dict

  def run(self):
    resource = import_proto(self.resource_type)

    # fetch the class
    message = getattr(resource, self.resource_type)

    # generate lower case to camel case map
    field_case_map = get_field_case_map(message.DESCRIPTOR)
    field_map = message().DESCRIPTOR.fields_by_name

    resource_type = re.sub(r'^Resource', '', self.resource_type)

    # Filter the targeted sheets
    sheets_filtered = search_sheets(self.all_sheets_dict, resource_type)
    #sheets_global = search_sheets(self.all_sheets_dict, GLOBAL_VALUES.lower())

    result = parse_sheet(self.all_sheets_dict, sheets_filtered, message, field_map, field_case_map, resource_type)
    print(f'{resource_type} 파싱 완료')
    #result_global = parse_global(sheets_global, message, resource_type)
    #print(f'{resource_type}의 Global 데이터를 업데이트했습니다.')
    print(f'{resource_type} 데이터 검증 중')
    validate_result(resource_type, result)
    update_json(resource_type, result)
    print(f'{resource_type}s.json을 성공적으로 저장했습니다.')

def main():
  # Parse arguments
  args = parse_args()
  resource_type = args.type

  type_int_map = {
    1: 'ResourceAchievement',
    2: 'ResourceAudio',
    3: 'ResourceBuff',
    4: 'ResourceItem',
    5: 'ResourceMap',
    6: 'ResourceSkill',
    7: 'ResourceString',
    8: 'ResourceUnit'
  }

  if not args.all and resource_type is None:
    while True:
      for key, value in type_int_map.items():
        print(f'{key}: {value}')
      type_int = input(f'리소스 타입을 선택하세요 (1-{len(type_int_map.keys())}): ')
      try:
        resource_type = type_int_map[int(type_int)]
        break
      except KeyError:
        print('존재하지 않는 번호입니다. 다시 입력하세요.')
      except ValueError:
        print('입력이 잘못되었습니다. 다시 입력하세요.')

    print(f'{resource_type} 불러오는 중...')
  else:
    print('전체 리소스 불러오는 중...')

  if args.compile:
    if args.all:
      if not compile_all(used_protobufs, protobuf_dir, compiler_dir, output_dir):
        error('protocol buffer 파일을 컴파일하는 중 오류가 발생했습니다.')
        exit(1)
    elif resource_type is not None:
      result = functions.protobuf.compile_proto(resource_type, protobuf_dir, compiler_dir, output_dir)
      if result == False:
        error(f'\'{resource_type}\' 파일을 컴파일하는 중 오류가 발생했습니다.')
        exit(1)
      else:
        print(f'\'{resource_type}\' 파일을 성공적으로 컴파일했습니다.')
        # compile all protobuf files
    exit(0)

  compile_all(used_protobufs, protobuf_dir, compiler_dir, output_dir)

  # load the modules from ./protobuf
  import sys
  sys.path.append('./protobuf')

  # Initialize the docs
  print('구글 시트 불러오는 중...')

  all_sheets_dict = {}
  spreadsheet_keys = []
  try:
    with open('spreadsheet_key.json', 'r', encoding='utf-8') as f:
      data = json.load(f)
      print(data)
      spreadsheet_keys = data['spreadsheet_keys']
  except e:
    print(e)
    spreadsheet_keys = []
  print(spreadsheet_keys)
  for sheet_data in spreadsheet_keys:
    print(resource_type)
    print(sheet_data['type'])
    if not args.all and resource_type not in sheet_data['type']:
      continue
        
    print('시트 주소: ' + sheet_data["key"])
    try:
      fetched_sheet = functions.gsheets.fetch_all_sheets(sheet_data["key"])
      all_sheets_dict.update(fetched_sheet)
    except Exception as e:
      error(f'{e}\n')

  if args.all:
    parsers = []
    for _, resource_type in type_int_map.items():
      parser = ResourceParser(resource_type, all_sheets_dict)
      parser.start()
      parsers.append(parser)
    for parser in parsers:
      parser.join()
    return

  if resource_type is not None:
    parser = ResourceParser(resource_type, all_sheets_dict)
    parser.start()
    parser.join()
    return


if __name__ == '__main__':
  main()
