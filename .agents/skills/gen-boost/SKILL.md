---
name: gen-boost
description: "부스터 1종을 완성형으로 제작 (Item.Type=Boost). 시간제 효과 — XP/Gold/Drop 증가, 광고 보상. 단일은 여기, 시리즈는 gen-boosts."
argument-hint: "[게임 id] [부스터 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 부스터 생성 (Type=Boost)

Boost는 **시간제 효과 아이템** — 사용 시 X분간 ExpPercent/ItemDropPercent 등 buff 적용.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Boost` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Boost 필드, useAction과 연결되는 Buff
- `harness/engine-contract/schema/buff.md` — 시간제 buff 정의
- `harness/engine-contract/stat-catalog.md` — ExpPercent/ItemDropPercent/GoldEfficiencyPercent 등

## 단계
1. **결정**(AskUserQuestion): 효과 종류(XP/Gold/Drop/AtkSpeed 등), 효과량(% +50 등), 지속시간(분), 획득 경로(광고/구매/보상).
2. **ID 할당**: `profile.id_ranges.item`.
3. **연결 Buff 정의**: `harness/content/<game>/buffs/_drafts/{buff_id}_{name}_v1.yaml` — 시간제 stat 보너스.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Boost
   - **applyBuffOnUse(또는 동등 필드)**: → Buff.id (사용 시 부여)
   - **applyDurationSeconds**
   - sellPrice / iapIdentifier (광고면 비움)
   - spriteGroups (Icon)
5. **참조 연결**: useAction → Buff.id 무결.
6. **에셋**(asset-producer): Icon (효과 아이콘).
7. **_index 등록**: `type: Boost`, `effect: XP/Gold/Drop` 태그.
8. **검수/승인**.

## 원칙
- 효과는 별도 Buff로 — Boost 아이템 자체는 buff 트리거.
- 광고 부스터는 priceUsd=0, 별도 ad placement 연결 (엔진).
- 동시 중첩 정책은 buff 정책 따름 (엔진).

## 협업
- 시리즈는 `/gen-boosts`
- 연결 Buff → buff _drafts 동시 작업
