---
name: gen-unit-item
description: "유닛 아이템 1종을 완성형으로 제작 (Item.Category=Unit). 유닛을 인벤토리에서 표상하는 아이템 — 영웅 카드/소환서 등. Pet과 달리 전투 페어가 아닌 보유/소환 표상."
argument-hint: "[게임 id] [유닛 아이템 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 유닛 아이템 생성 (Category=Unit, Pet과 구분)

Unit 카테고리 아이템은 **유닛 보유 표상** — 영웅 카드, 소환서, 유닛 조각 등. Pet과 달리 즉시 전투 참여 아닌 보유/소환.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Unit` 태그 (Pet과 구분 주의)

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Unit Category(300) vs Pet Category(302) 차이
- `harness/engine-contract/schema/unit.md`
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 표상 종(카드/소환서/조각), 연결 Unit, 소환 비용/조건, 조각형이면 합성 수.
2. **연결 Unit 확인/생성**: 없으면 `/gen-unit`으로 먼저.
3. **ID 할당**: `profile.id_ranges.item`.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Unit
   - **unitDataId**: → Unit.id (연결)
   - grade, rarity
   - levelUpMaterialItemGroups (조각 합성 시)
   - useAction(소환 처리, 엔진 어휘)
   - spriteGroups (Icon)
5. **참조 검증**: unitDataId가 units/_index의 approved에 실재.
6. **에셋**(asset-producer): Icon (카드/조각 모양).
7. **_index 등록**: `category: Unit`, `target_unit: <unit_id>` 태그.
8. **검수/승인**.

## 원칙
- **Category=Unit ≠ Category=Pet** — Pet은 즉시 전투, Unit은 보유/소환 표상. 헷갈리지 말 것.
- 조각형이면 합성 수만큼 levelUpMaterialItemGroups에 자기 자신 반복(또는 별도 fragment 아이템).

## 협업
- 연결 Unit → `/gen-unit` 페어
- 벌크 가능하지만 흔치 않음 — 필요 시 패턴 따라 추가
