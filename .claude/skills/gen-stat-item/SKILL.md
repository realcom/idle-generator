---
name: gen-stat-item
description: "스탯 강화 아이템 1종을 완성형으로 제작 (Item.Category=Stat). 영구 스탯 보너스 아이템 — 능력서/룬/문장 등. 단일은 여기, 시리즈는 gen-stat-items."
argument-hint: "[게임 id] [스탯 아이템 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스탯 강화 아이템 생성 (Category=Stat)

Stat 카테고리는 **사용/장착 시 영구 스탯 보너스를 주는 아이템** — 능력서/룬/문장/스탯 알약.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Stat` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Stat 필드, addStats(영구)/equipAddStats(장착 시)
- `harness/engine-contract/stat-catalog.md` — 어떤 스탯이 강화 가능한지
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 강화 스탯(Attack/Hp/Crit 등), 효과량, 등급, 영구 vs 장착, 강화 가능 여부(levelUp).
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Stat
   - grade, rarity
   - addStats (영구 보유 시 보너스) 또는 equipAddStats (장착 시)
   - requiredExps, levelUpMaterialItemGroups (강화 가능 시)
   - spriteGroups
4. **성장**(economy-balancer): 강화 시 스탯 곡선.
5. **에셋**.
6. **_index 등록**: `category: Stat`, `stat: Attack/Hp/...` 태그.
7. **검수/승인**.

## 원칙
- 영구 보너스라 신중 — 게임 경제에 큰 영향.
- 강화 가능 시 요구 재료 곡선 일관.

## 협업
- 시리즈는 `/gen-stat-items`
- 강화 재료 → `/gen-material(s)`
