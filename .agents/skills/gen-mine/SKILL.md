---
name: gen-mine
description: "광맥 1종을 완성형으로 제작 (Item.Category=Mine). 방치형 핵심 — efficiencyPercents(채굴 효율)·maxStamina·staminaRegenPerSecond. 단일은 여기, 시리즈는 gen-mines."
argument-hint: "[게임 id] [광맥 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 광맥 생성 (Category=Mine, 방치형 특화)

Mine은 idle/방치 핵심 자원. **efficiency·stamina** 곡선이 본질.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Mine` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Mine 특화 필드: efficiencyPercents/maxStamina/staminaRegenPerSecond/sellPrice/sellAddItemGroups
- `harness/engine-contract/reference-graph.md` — Mine sellAddItemGroups → Item.id (산출 재료/통화)
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item, balance.idle (offline_cap_hours)
- `harness/content/<game>/items/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): 광맥 종(금/은/광물), grade, 채굴 효율 base, stamina 시스템 사용 여부, 산출(sellAddItemGroups — gold/material/exp 중).
2. **ID 할당**: `profile.id_ranges.item` 대역.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Mine, type: Mine, grade
   - **efficiencyPercents** (레벨별 채굴 효율 배열, value[] 자리)
   - **maxStamina**, **staminaRegenPerSecond**
   - sellPrice (1회 채굴 가격)
   - sellAddItemGroups (1회 채굴 산출 — gold/material/exp 등)
   - requiredExps (레벨업)
   - levelUpMaterialItemGroups (강화 재료)
   - spriteGroups (Icon + 광맥 sprite)
4. **성장**(economy-balancer): efficiency 곡선 + requiredExps + maxStamina 곡선. `/balance-review`로 시간당 산출 시뮬 권장.
5. **참조**: 산출 보상 Material/Currency가 items _index의 approved에 실재.
6. **에셋**(asset-producer): Icon + 광맥 sprite (방치 화면에 표시되는 큰 이미지).
7. **_index 등록**: `category: Mine`, `grade` 태그.
8. **검수/승인**.

## 원칙
- **시간당 산출 시뮬 필수** — `/balance-review`로 offline_cap_hours 내 합리적인 산출.
- efficiency 곡선이 곧 게임 경제 — 너무 빡세면 환생 사이클 깨짐.
- stamina 시스템 미사용이면 maxStamina=0, regen=0.

## 협업
- 시리즈는 `/gen-mines`
- 강화 재료 → `/gen-material(s)` 먼저
- 곡선 검증 → `/balance-review`
