import shutil
import os
import re

def update_framerate(id):
    timeline_file = "../Client/Assets/PatchResources/TimelineAssets/" + id + ".playable"
    try:
        with open(timeline_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except:
        print('no file'  + timeline_file)
        return

    # 패턴: m_EditorSettings: 이후에 나오는 m_Framerate: 30을 100으로 바꾸기
    updated_content = content.replace("m_Duration: 1", "m_Duration: 5")

    with open(timeline_file, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    

if __name__ == "__main__":
    ids = ["Timeline_1111001","Timeline_1111101","Timeline_1112001","Timeline_1111101","Timeline_1113001","Timeline_1111101","Timeline_1111002","Timeline_1111102","Timeline_1112002","Timeline_1111102","Timeline_1113002","Timeline_1111102","Timeline_1211001","Timeline_1211101","Timeline_1212001","Timeline_1211101","Timeline_1213001","Timeline_1211101","Timeline_1211002","Timeline_1211102","Timeline_1212002","Timeline_1211102","Timeline_1213002","Timeline_1211102","Timeline_1221001","Timeline_1221101","Timeline_1222001","Timeline_1221101","Timeline_1223001","Timeline_1221101","Timeline_1311001","Timeline_1311101","Timeline_1312001","Timeline_1311101","Timeline_1313001","Timeline_1311101","Timeline_1121001","Timeline_1121101","Timeline_1122001","Timeline_1121101","Timeline_1123001","Timeline_1121101","Timeline_1211004","Timeline_1211104","Timeline_1212004","Timeline_1211104","Timeline_1213004","Timeline_1211104","Timeline_1321001","Timeline_1321101","Timeline_1322001","Timeline_1321101","Timeline_1323001","Timeline_1321101","Timeline_1111003","Timeline_3","Timeline_3","Timeline_1112003","Timeline_3","Timeline_3","Timeline_1113003","Timeline_3","Timeline_3","Timeline_1121002","Timeline_3","Timeline_3","Timeline_1122002","Timeline_3","Timeline_3","Timeline_1123002","Timeline_3","Timeline_3","Timeline_1431001","Timeline_1431101","Timeline_1432001","Timeline_1431101","Timeline_1433001","Timeline_1431101","Timeline_1211003","Timeline_1211103","Timeline_1212003","Timeline_1211103","Timeline_1213003","Timeline_1211103","Timeline_1131001","Timeline_3","Timeline_3","Timeline_1132001","Timeline_3","Timeline_3","Timeline_1133001","Timeline_3","Timeline_3","Timeline_1111005","Timeline_1111105","Timeline_1112005","Timeline_1111105","Timeline_1113005","Timeline_1111105","Timeline_1331001","Timeline_1331101","Timeline_1332001","Timeline_1331101","Timeline_1333001","Timeline_1331101","Timeline_1321002","Timeline_1321102","Timeline_1322002","Timeline_1321102","Timeline_1323002","Timeline_1321102","Timeline_1211005","Timeline_1211105","Timeline_1212005","Timeline_1211105","Timeline_1213005","Timeline_1211105","Timeline_1121004","Timeline_1121104","Timeline_1122004","Timeline_1121104","Timeline_1123004","Timeline_1121104","Timeline_1331002","Timeline_1331102","Timeline_1332002","Timeline_1331102","Timeline_1333002","Timeline_1331102","Timeline_1121003","Timeline_1121103","Timeline_3","Timeline_1122003","Timeline_1121103","Timeline_3","Timeline_1123003","Timeline_1121103","Timeline_3","Timeline_1221002","Timeline_1221102","Timeline_3","Timeline_1222002","Timeline_1221102","Timeline_3","Timeline_1223002","Timeline_1221102","Timeline_3","Timeline_1331003","Timeline_1331103","Timeline_3","Timeline_1332003","Timeline_1331103","Timeline_3","Timeline_1333003","Timeline_1331103","Timeline_3"
]
    for id in ids:
      (a,b) = id.split("_")
      print(b)
      print((int(b) // 100) % 10 )
      print('------')
      if  (int(b) // 100) % 10 == 1:
        update_framerate(id)