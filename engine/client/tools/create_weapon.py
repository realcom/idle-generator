import shutil
import os
import re

def copy_files(id, name):
    # # 사용자로부터 id와 Name 입력 받기
    # try:
    #     id = int(input("Enter ID: "))
    #     name = input("Enter Name: ")
    # except ValueError:
    #     print("Invalid input. ID must be an integer.")
    #     return

    # 파일 경로 설정
    source_file_1111001 = "../Client/Assets/PatchResources/TimelineAssets/Timeline_1111001.playable"
    source_file_1111101 = "../Client/Assets/PatchResources/TimelineAssets/Timeline_1111101.playable"
    source_skill_file = "../Client/Assets/PatchResources/Skills/Skill_1111101.prefab"


    # 복사 대상 파일 경로 (원본 파일 경로 기준)
    target_files = [
        (id, source_file_1111001),
        (id + 1000, source_file_1111001),
        (id + 2000, source_file_1111001),
        (id + 100, source_file_1111101),
        (f"Skill_{id + 100}.prefab", source_skill_file),
        (f"Skill_{id + 1100}.prefab", source_skill_file),
        (f"Skill_{id + 2100}.prefab", source_skill_file),

    ]

    # 복사 작업 수행
    for _id, source in target_files:
        try:
            if isinstance(_id, int):
              target = f"Timeline_{_id}.playable"
            else:
                target = _id
            # 대상 파일 경로를 원본 파일과 동일한 디렉토리에 생성
            target_path = os.path.join(os.path.dirname(source), target)

            shutil.copy(source, target_path)
            if source == source_file_1111001:
              with open(target_path, 'r') as file:
                  content = file.read()
                  updated_content = content.replace("1111101", str(_id + 100))
                  updated_content = updated_content.replace("Timeline_1111001", "Timeline_" + str(_id))
              
              with open(target_path, 'w') as file:
                  file.write(updated_content)
              
            else:
              _id = re.findall("\d+", str(_id))[0]
              with open(target_path, 'r') as file:
                  content = file.read()
                  updated_content = content.replace("Timeline_1111101", "Timeline_" + str(_id))
                  updated_content = updated_content.replace("Skill_1111101", "Skill_" + str(_id))
              
              with open(target_path, 'w') as file:
                  file.write(updated_content)
            print(f"Updated content in {target_path}")

            print(f"Copied {source} to {target_path}")
        except FileNotFoundError:
            print(f"Source file not found: {source}")
        except Exception as e:
            print(f"Failed to copy {source} to {target_path}: {e}")

if __name__ == "__main__":
    ids = [1211004,
1212004,
1213004,
1321001,
1322001,
1323001]
    for id in ids:
      copy_files(id, '')