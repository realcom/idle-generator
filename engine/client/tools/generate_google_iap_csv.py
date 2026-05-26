import json
import csv

# items.json 파일 읽기
with open('../Client/Assets/PatchResources/items.json', 'r', encoding='utf-8') as json_file:
    data = json.load(json_file)


with open('../Client/Assets/PatchResources/strings.json', 'r', encoding='utf-8') as f:
    strings_data = json.load(f)

strings_entries = strings_data.get('strings')

item_string_map = {}
for entry in strings_entries:
    if entry.get('category') == 'Item' and entry.get("key") in ['ShortName', 'Name']:
        id_val = entry.get('id')
        # title = entry.get('korean', '')  # 또는 entry.get('english', '')를 사용할 수 있음
        item_string_map[id_val] = entry

# 전체 항목 중 type이 MaterialRealPrice인 항목만 필터링
items = data.get('items', [])
iap_items = [item for item in items if item.get('type') == 'MaterialRealPrice']

# CSV에 저장할 헤더 정의 (필요한 컬럼에 맞게 수정 가능)
headers = ['Product ID','Published State','Purchase Type',  'Auto Translate', 'Locale; Title; Description','Auto Fill Prices','Price','Pricing Template ID']

# CSV 파일 생성 및 데이터 쓰기
with open('./iap_products.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    for item in iap_items:
        string_info = item_string_map[item.get('id')]
        row = {
            'Product ID': item.get('iapIdentifier'),
            'Published State': 'published',
            'Purchase Type': 'managed_by_android',
            'Auto Translate': 'false',
            'Locale; Title; Description': f'en-US; {string_info.get('english')}; {string_info.get('english')}; ko-KR; {string_info.get('korean')}; {string_info.get('korean')}',
            'Auto Fill Prices': 'true',
            'Price': str(item.get('priceWon')) + '000000', 
            'Pricing Template ID': ''
        }
        writer.writerow(row)


        # writer.writerow([android_id, 'published','managed_by_android','false',f'en-US; {name}; {name}; ko-KR; {name_ko}; {name_ko}', 'true', price,''])

print("CSV 파일 'iap_products.csv' 가 생성되었습니다.")
