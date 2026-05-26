#!/bin/bash

# Determine the system type
if [[ "$OSTYPE" == "darwin"* ]]; then
  PROTOC="build/protoc-mac"
  FLATC="build/flatc-mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PROTOC="build/protoc-lin"
  FLATC="build/flatc-lin"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# Types
$PROTOC -I=Types --csharp_out=Types Curve.proto AddItem.proto MaterialItem.proto Notice.proto Chat.proto World.proto
$PROTOC -I=Types/Geometry --csharp_out=Types/Geometry GeometryMessage.proto
$PROTOC -I=Types -I=Types/Geometry -I=Types/Units --csharp_out=Types/Units AddHeal.proto AddDamage.proto AddBuff.proto UseSkill.proto UnitStatType.proto ArmorType.proto DamageType.proto
$PROTOC -I=Types/Units -I=Types/Units/ArmorTypeStat --csharp_out=Types/Units/ArmorTypeStat ArmorTypeStatType.proto
$PROTOC -I=Types/Units -I=Types/Units/DamageTypeStat --csharp_out=Types/Units/DamageTypeStat DamageTypeStatType.proto
$PROTOC -I=Types/Units/ItemGroupStat --csharp_out=Types/Units/ItemGroupStat ItemGroupStatType.proto
$PROTOC -I=Types/Units/SlotStat --csharp_out=Types/Units/SlotStat SlotStatType.proto
$PROTOC -I=Types/Players --csharp_out=Types/Players Player.proto PlayerAchievement.proto PlayerAvatar.proto PlayerItem.proto PlayerRanking.proto PlayerTelegram.proto PlayerMail.proto PlayerInventory.proto

# Requests
$PROTOC -I=Resources -I=Types -I=Types/Geometry -I=Types/Units -I=Game -I=Packets/Requests -I=Types -I=Types/Players --csharp_out=Packets/Requests Requests.proto

# Updates
$PROTOC -I=Packets/Requests -I=Packets/Updates -I=Types -I=Types/Players --csharp_out=Packets/Updates Updates.proto

# Game
$FLATC --csharp --gen-mutable -o ../ Game/Actions/Actions.fbs
$PROTOC -I=Game -I=Resources -I=Types/Geometry -I=Types -I=Types/Players -I=Types/Units -I=Types/Units/ArmorTypeStat -I=Types/Units/DamageTypeStat -I=Types/Units/ItemGroupStat -I=Types/Units/SlotStat --csharp_out=Game GameBoard.proto GameUnit.proto GameSkill.proto GameBuff.proto GameDropItem.proto

# Resources
$PROTOC -I=Resources -I=Types -I=Types/Geometry -I=Types/Units -I=Types/Units/ArmorTypeStat -I=Types/Units/DamageTypeStat -I=Types/Units/ItemGroupStat -I=Types/Units/SlotStat --csharp_out=Resources Tags.proto Resources.proto ResourceAchievement.proto ResourceAudio.proto ResourceBuff.proto ResourceItem.proto ResourceMap.proto ResourceSkill.proto ResourceString.proto ResourceUnit.proto ResourceTrigger.proto