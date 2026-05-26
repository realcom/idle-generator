import sys
try:
  from oauth2client.service_account import ServiceAccountCredentials
except ImportError:
  sys.stderr.write('[Parser] 오류: 콘솔에서 다음 명령어를 실행해 oauth2client를 설치해주세요: python -m pip install oauth2client\n')
try:
  import gspread
except ImportError:
  sys.stderr.write('[Parser] 오류: 콘솔에서 다음 명령어를 실행해 gspread를 설치해주세요: python -m pip install gspread\n')
import os
import threading
import json
import random
import re


def init_docs(spreadsheet_key):
  scope = ['https://spreadsheets.google.com/feeds']
  keys = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'drive_keys.json'), 'r'))['keys']
  if os.path.exists('next_account.json'):
    next_account_key = json.load(open('next_account.json', 'r'))['keys']
  else:
    next_account_key = 0
  next_account_key += 1
  next_account_key %= len(keys)
  key = keys[next_account_key]
  json.dump({'keys': next_account_key}, open('next_account.json', 'w'))
  print(f'사용자 계정: {key["client_email"]}')
  credentials = ServiceAccountCredentials.from_json_keyfile_dict(key, scope)
  gc = gspread.authorize(credentials)
  docs = gc.open_by_key(spreadsheet_key)
  return docs


class SheetFetcherException(Exception):
  def __init__(self, message):
    self.message = message


exceptions = []


class GSheetsFetcher(threading.Thread):
  def __init__(self, worksheet, sheet_name, callback):
    threading.Thread.__init__(self)
    self.worksheet = worksheet
    self.sheet_name = sheet_name
    self.callback = callback

  def run(self):
    try:
      self.callback(self.sheet_name, self.worksheet.get_all_values())
    except Exception as e:
      exceptions.append(str(e))


def fetch_all_sheets(sheet_key):
  docs = init_docs(sheet_key)
  worksheets = {}
  spreadsheet_fetched = docs.worksheets()

  def callback(sheet_name, sheet_data):
    worksheets[sheet_name] = sheet_data

  fetcher_threads = []
  for sheet in spreadsheet_fetched:
    # ignore sheets without parentheses in their name
    if not re.search(r'\(.*\)', sheet.title):
      continue
    print(f'{sheet.title} 시트 데이터 로드 중...')
    fetcher = GSheetsFetcher(sheet, sheet.title, callback)
    fetcher.start()
    fetcher_threads.append(fetcher)

  for fetcher in fetcher_threads:
    fetcher.join()
  if len(exceptions) > 0:
    exception_text = '\n'.join(exceptions)
    raise SheetFetcherException('시트 데이터를 불러오지 못했습니다: ' + exception_text)
  print('시트 데이터 로드 완료')
  return worksheets
