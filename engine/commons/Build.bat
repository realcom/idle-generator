@echo off
cd /d "%~dp0"

echo Start build proto buffers

:::: Server ::::
:: Types
build\protoc.exe -I=Types -I=Types/Players --csharp_out=Types Curve.proto AddItem.proto MaterialItem.proto Notice.proto Chat.proto World.proto
build\protoc.exe -I=Types/Geometry --csharp_out=Types/Geometry GeometryMessage.proto
build\protoc.exe -I=Types -I=Types/Geometry -I=Types/Units --csharp_out=Types/Units AddHeal.proto AddDamage.proto AddBuff.proto UseSkill.proto UnitStatType.proto ArmorType.proto DamageType.proto
build\protoc.exe -I=Types -I=Types/Units --csharp_out=Types ItemOption.proto
build\protoc.exe -I=Types/Units -I=Types/Units/ArmorTypeStat --csharp_out=Types/Units/ArmorTypeStat ArmorTypeStatType.proto
build\protoc.exe -I=Types/Units -I=Types/Units/DamageTypeStat --csharp_out=Types/Units/DamageTypeStat DamageTypeStatType.proto
build\protoc.exe -I=Types/Units/ItemGroupStat --csharp_out=Types/Units/ItemGroupStat ItemGroupStatType.proto
build\protoc.exe -I=Types/Units/SlotStat --csharp_out=Types/Units/SlotStat SlotStatType.proto
build\protoc.exe -I=Types/Units/BuffGroupStat --csharp_out=Types/Units/BuffGroupStat BuffGroupStatType.proto
build\protoc.exe -I=Types/Units/SkillGroupStat --csharp_out=Types/Units/SkillGroupStat SkillGroupStatType.proto
build\protoc.exe -I=Types/Players -I=Types --csharp_out=Types/Players Player.proto PlayerAchievement.proto PlayerAvatar.proto PlayerItem.proto PlayerRanking.proto PlayerTelegram.proto PlayerMail.proto PlayerInventory.proto PlayerInfo.proto 



:: Requests
build\protoc.exe -I=Resources -I=Types -I=Types/Geometry -I=Types/Units -I=Game -I=Packets/Requests -I=Types -I=Types/Players --csharp_out=Packets/Requests Requests.proto

:: Updates
build\protoc.exe -I=Packets/Requests -I=Packets/Updates -I=Types -I=Types/Players --csharp_out=Packets/Updates Updates.proto

:: Game
build\flatc.exe --csharp --gen-mutable -o ../ Game/Actions/Actions.fbs
build\protoc.exe -I=Game -I=Resources -I=Types/Geometry -I=Types -I=Types/Players -I=Types/Units  -I=Types/Units/ArmorTypeStat -I=Types/Units/DamageTypeStat -I=Types/Units/ItemGroupStat -I=Types/Units/SlotStat -I=Types/Units/BuffGroupStat -I=Types/Units/SkillGroupStat --csharp_out=Game GameBoard.proto GameUnit.proto GameSkill.proto GameBuff.proto GameDropItem.proto

:: Resources
build\protoc.exe -I=Resources -I=Types -I=Types/Geometry -I=Types/Units -I=Types/Units/ArmorTypeStat -I=Types/Units/DamageTypeStat -I=Types/Units/ItemGroupStat -I=Types/Units/SlotStat -I=Types/Units/BuffGroupStat -I=Types/Units/SkillGroupStat --csharp_out=Resources Tags.proto Resources.proto ResourceAchievement.proto ResourceAudio.proto ResourceBuff.proto ResourceItem.proto ResourceMap.proto ResourceSkill.proto ResourceString.proto ResourceUnit.proto ResourceTrigger.proto

:::: Trgger Editor ::::
:: Resources

echo Finish build proto buffers

:: Auto-Generation
call Generators\\RunGenerators.bat