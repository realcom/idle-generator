---
name: gen-equipment
description: "장비 1종을 완성형으로 제작 (Item.Category=Equipment). Head/Chest/Gloves/Boots/Necklace/Ring 등 슬롯별 장비 — 옵션 affix·강화·세트 효과. 단일은 여기, 시리즈는 gen-equipments."
argument-hint: "[게임 id] [장비 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 장비 생성 (Category=Equipment)

ResourceItem(Category=Equipment)의 수직 슬라이스. **슬롯(Type)** + 옵션 affix + 강화 재료 + 잠금(Achievement)을 끝까지.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Equipment`, `type: <slot>` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Equipment 슬롯 enum, options/optionCounts(랜덤 affix 풀), requiredAchievementDataIds(슬롯 해금)
- `harness/engine-contract/stat-catalog.md` — Defense/Hp/CriticalPercent 등
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item, reserved_ids.achievement.equipmentSlotUnlock* (슬롯별 해금 업적)
- `harness/content/<game>/items/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): 슬롯(Head/Chest/Gloves/Boots/Necklace/Ring), grade/tier, 기본 스탯, 옵션 affix 풀, 세트 효과 여부.
2. **ID 할당**: `profile.id_ranges.item` + `_index.yaml`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Equipment, type: <slot>, grade, rarity
   - equipAddStats (Defense/Hp 위주)
   - options/optionCounts (등급별 weight 풀)
   - levelUpMaterialItemGroups, requiredExps
   - **requiredAchievementDataIds** (슬롯 해금 업적, reserved_ids 참조)
   - spriteGroups (Icon 필수)
4. **성장**(economy-balancer): Defense/Hp 곡선, requiredExps[].
5. **옵션 풀 설계**: 등급별 affix 후보 + weight.
6. **잠금 백참조**: 슬롯 해금 업적 reserved_ids.achievement.equipmentSlotUnlock<Slot>.
7. **에셋**(asset-producer): Icon (필수), 장착 표시용 sprite.
8. **_index 등록**: `category: Equipment`, `type: <slot>` 태그.
9. **검수/승인**.

## 원칙
- 슬롯별 표준 스탯이 다름 (Head: Hp, Chest: Defense, Necklace: CriticalPercent 등) — schema 카드 참조.
- 옵션 affix는 등급별 차등 — 등급 곡선 일관.
- 슬롯 해금은 reserved_ids 사용 (재할당 금지).

## 협업
- 시리즈/세트는 `/gen-equipments`
- 강화 재료 → `/gen-material(s)`
- 슬롯 해금 업적 → `/gen-achievement` (보통 reserved_ids로 이미 있음)
