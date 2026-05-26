---
name: gen-trait
description: "특성 1종을 완성형으로 제작 (Item.Category=Trait). 캐릭터에 부여되는 영구 특성 — 패시브 효과, 빌드 다양성. 단일은 여기, 시리즈는 gen-traits."
argument-hint: "[게임 id] [특성 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 특성 생성 (Category=Trait)

Trait는 **캐릭터에 부여되는 영구 패시브** — 빌드 시스템의 핵심. Buff 또는 stat 보너스 연결.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Trait` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Trait 필드, equipAddBuffs / addStats
- `harness/engine-contract/schema/buff.md` — 패시브 buff 정의
- `harness/engine-contract/stat-catalog.md`
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 특성 효과(buff/stat), 강도, 빌드 컨셉(공격형/방어형/유틸형), 슬롯 제약(있다면), 상호 배타 특성.
2. **ID 할당**: `profile.id_ranges.item`.
3. **연결 Buff 정의**(있다면): `buffs/_drafts/`에 패시브 buff.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Trait
   - grade, rarity
   - addStats (영구 보너스) 또는 equipAddBuffs(→Buff.id)
   - exclusiveItemTags / exclusiveItemDataIds (상호 배타)
   - requiredAchievementDataIds (해금 조건)
   - spriteGroups (Icon)
5. **에셋**(asset-producer): Icon (특성 트리 UI용).
6. **_index 등록**: `category: Trait`, `concept: 공격/방어/유틸` 태그.
7. **검수/승인**.

## 원칙
- 영구 효과라 신중 — 빌드 균형이 게임 깊이 결정.
- 상호 배타 특성은 exclusiveItemTags 활용.
- 해금 조건은 reserved_ids.achievement 또는 신규 업적과 페어.

## 협업
- 시리즈/빌드 트리는 `/gen-traits`
- 효과 buff → buff _drafts
- 해금 업적 → `/gen-achievement`
