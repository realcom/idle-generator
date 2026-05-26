---
name: gen-pet
description: "펫 1종을 완성형으로 제작 (Item.Category=Pet, Unit과 페어). 펫 아이템 정의 + 연결 Unit + 성장식 + 스킬. Pet은 인벤토리 표상(Item)과 전투 개체(Unit) 양쪽 필요."
argument-hint: "[게임 id] [펫 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 펫 생성 (Category=Pet + Unit 페어)

Pet은 **Item(인벤토리) + Unit(전투) 페어**. 두 카테고리 모두 생성 필요.

## 저장 규칙
- Item: `harness/content/<game>/items/_drafts/{id}_{name}_pet_v#.yaml`
- Unit: `harness/content/<game>/units/_drafts/{unit_id}_{name}_v#.yaml`
- 두 _index 모두 등록 (`category: Pet`, `type: Pet`)

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Pet 필드(unitDataId, addStats)
- `harness/engine-contract/schema/unit.md` — type=Pet, addStats, triggers
- `harness/engine-contract/reference-graph.md` — Item.Pet ↔ Unit 양방향
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item, id_ranges.unit
- `harness/content/<game>/items/_index.yaml`, `units/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): 펫 종, 속성(damageType 비례), 등급, 스킬(있다면), 외형.
2. **ID 할당**: Item id(items 대역) + Unit id(units 대역) — 페어 명시.
3. **Unit 정의**(content-designer): `units/_drafts/{unit_id}_{name}_v1.yaml`
   - type: Pet
   - addStats (Hp/Attack/Defense)
   - triggers (펫 AI — 따라옴, 자동 공격 등)
   - sprite/animations
4. **Item 정의**(content-designer): `items/_drafts/{item_id}_{name}_pet_v1.yaml`
   - category: Pet, type: Pet
   - **unitDataId: <unit_id>** (Unit과 연결)
   - addStats (보유 시 효과 — 옵션)
   - levelUpMaterialItemGroups, requiredExps
   - spriteGroups (Icon)
5. **성장**(economy-balancer): Unit의 addStats[].value[], Item의 requiredExps[].
6. **펫 AI 트리거**(behavior-author): "따라옴", "주기적 공격" 등 — `units/_drafts/`에 behavior YAML.
7. **에셋**(asset-producer): Unit sprite/anim, Item Icon.
8. **_index 일괄**: Item·Unit 모두 등록, refs로 양방향 ID 명시.
9. **검수**: Item.unitDataId ↔ Unit.id 양방향 일치.
10. **승인**: Item·Unit 동시 approved 이동.

## 원칙
- **Item + Unit 페어 필수** — 한쪽만 만들면 댕글링.
- ID 할당은 페어로 결정 (예: Item 230101 ↔ Unit 110301).
- 스킬은 Unit의 triggers 또는 equipSkillDataIds(Item.equipSkillDataIds — pet도 가능)로.

## 협업
- 시리즈/4속성은 `/gen-pets`
- 펫 스킬 → `/gen-skill`
- 펫 AI → `/gen-trigger`
