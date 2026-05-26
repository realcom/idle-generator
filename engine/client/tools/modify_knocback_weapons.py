import shutil
import os
import re

def modify_knockback_information(id, duration, distance):

    # 파일 경로 설정
    timeline_file = "../Client/Assets/PatchResources/TimelineAssets/Timeline_" + str(id) + ".playable"
    
    updated_content = ''
    try:
        with open(timeline_file, 'r') as file:
            text = file.read()
            text = re.sub(r'(knockbackDistance:\s*)\d+\.?\d*', lambda m: f'{m.group(1)}{distance}', text)
            text = re.sub(r'(-\s*Name:\s*knockbackDistance\s*\n\s*Entry:\s*4\s*\n\s*Data:\s*)\d+',lambda m: f'{m.group(1)}{distance}', text)

            text = re.sub(r'(knockbackDuration:\s*)\d+\.?\d*', lambda m: f'{m.group(1)}{duration}', text)
            text = re.sub(r'(-\s*Name:\s*knockbackDuration\s*\n\s*Entry:\s*4\s*\n\s*Data:\s*)\d+',lambda m: f'{m.group(1)}{duration}', text)

            # updated_content = re.sub(r'(knockbackDuration:\s*)(\d+\.?\d*)', lambda m: f'{m.group(1)}{duration}', updated_content)
            # updated_content = re.sub(r'(knockbackDistance:\s*)(\d+\.?\d*)', lambda m: f'{m.group(1)}{distance}', updated_content)

            # updated_content = re.sub(r'(knockbackDuration:\s*)(\d+\.?\d*)', lambda m: f'{m.group(1)}{duration}', updated_content)

        with open(timeline_file, 'w') as file:
            file.write(text)
        
        print(f"update {id} timeline")
    except FileNotFoundError:
        print(f"not found {id} timeline")
    
    

if __name__ == "__main__":
    ids = [1111001, 1111101,1112001,1112101,1113001,1113101,1111002,1111102,1112002,1112102,1113002,1113102,1211001,1211101,1212001,1212101,1213001,1213101,1211002,1211102,1212002,1212102,1213002,1213102,1221001,1221101,1222001,1222101,1223001,1223101,1311001,1311101,1312001,1312101,1313001,1313101,1121001,1121101,1122001,1122101,1123001,1123101,1411001,1411101,1412001,1412101,1413001,1413101,1311002,1311102,1312002,1312102,1313002,1313102,1111003,1111103,1111203,1112003,1112103,1112203,1113003,1113103,1113203,1121002,1121102,1121202,1122002,1122102,1122202,1123002,1123102,1123202,1431001,1431101,1432001,1432101,1433001,1433101,1211003,1211103,1212003,1212103,1213003,1213103,1121003,1121103,1121203,1122003,1122103,1122203,1123003,1123103,1123203,1111005,1111105,1112005,1112105,1113005,1113105,1331001,1331101,1332001,1332101,1333001,1333101]
    for id in ids:
      modify_knockback_information(id, 0.3, 1)