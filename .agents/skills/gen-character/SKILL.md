---
name: gen-character
description: "플레이어 캐릭터 1종을 완성형으로 제작 (Item.Category=Character + Unit 페어). 영웅/직업/플레이어 본체. 거의 단일."
argument-hint: "[게임 id] [캐릭터 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 플레이어 캐릭터 생성 (Category=Character + Unit 페어)

Character는 **플레이어가 조종하는 본체** — Item.Category=Character + Unit(type=Player). Pet과 유사한 페어 구조.

## 저장 규칙
- Item: `harness/content/<game>/items/_drafts/{id}_{name}_character_v#.yaml`
- Unit: `harness/content/<game>/units/_drafts/{unit_id}_{name}_v#.yaml`
- 양쪽 _index 등록 (`category: Character`, `type: Player`)

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Character 필드, unitDataId
- `harness/engine-contract/schema/unit.md` — type=Player
- `harness/game-profiles/<game>.profile.yaml` — reserved_ids.defaultCharacter (예: idlez = 110101)

## 단계
1. **결정**(AskUserQuestion): 캐릭터 종(영웅/직업/스킨), 기본 스탯, 스킬, 외형, 기본 캐릭터 여부.
2. **ID 할당**: 기본 캐릭터면 `reserved_ids.defaultCharacter` 사용, 아니면 신규 id_ranges.
3. **Unit 정의**: type=Player, addStats, triggers, sprite/animations.
4. **Item 정의**: category: Character, unitDataId(→Unit), grade, spriteGroups.
5. **성장**(economy-balancer): Unit 스탯 곡선 + Item requiredExps.
6. **스킬 페어**: 기본 스킬 → ResourceSkill 별도.
7. **에셋**: Unit sprite/anim, Item Icon, 초상화.
8. **_index 일괄**: 양쪽 등록.
9. **검수/승인**: 페어 동시.

## 원칙
- 기본 캐릭터는 `reserved_ids.defaultCharacter` 일치 필수.
- 신규 캐릭터/스킨은 같은 패턴 가능하지만 자주 만들지 않음.
- Pet과 같은 페어 패턴 — 한쪽만 만들면 댕글링.

## 협업
- 벌크 거의 없음 (캐릭터는 단일).
- 기본 스킬 → `/gen-skill`
- AI/행동 → `/gen-trigger`
