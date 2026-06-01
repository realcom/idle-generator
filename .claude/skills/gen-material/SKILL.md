---
name: gen-material
description: "재료 1종을 완성형으로 제작 (Item.Category=Material). 가죽/광물/파편 등 강화·제작 재료. 단순 — 등급·드롭 출처·분해 보상. 단일은 여기, 시리즈는 gen-materials (자주 양산)."
argument-hint: "[게임 id] [재료 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 재료 생성 (Category=Material)

ResourceItem(Category=Material)의 수직 슬라이스. 가장 단순한 아이템 — 등급·획득 경로·분해 보상만.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Material` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Material 필드 (단순 — category + grade + spriteGroups 위주)
- `harness/engine-contract/reference-graph.md` — Material은 어떤 무기/장비의 levelUpMaterialItemGroups에 참조됨, dropAddItemGroups의 출처 등록
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item

## 단계
1. **결정**(AskUserQuestion): 이름·grade(등급)·획득 경로(drop_from unit / 상점 / 분해)·분해 보상 유무.
2. **ID 할당**: `profile.id_ranges.item` 대역.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Material
   - grade
   - sellPrice / sellAddItemGroups (판매가)
   - decomposeAddItemGroups (분해 시 산출, 옵션)
   - spriteGroups (Icon 필수)
4. **참조 백채움**: 이 재료를 쓰는 무기/장비의 levelUpMaterialItemGroups에 추가 (별도 _v# draft) 또는 출처 Unit의 dropAddItemGroups.
5. **에셋**(asset-producer): Icon만 (가장 단순).
6. **_index 등록**: `category: Material`, `grade` 태그.
7. **검수/승인**.

## 원칙
- 재료는 **가장 단순** — 보통 5필드 미만.
- 획득/소비 양쪽 백참조 중요 (드롭원 unit, 사용처 무기/장비).
- 분해 보상은 옵션 — 없으면 생략.

## 협업
- 시리즈는 `/gen-materials` (가장 자주)
- 드롭 출처 → `/gen-unit`에서 dropAddItemGroups에 이 id
- 사용처 → `/gen-weapon` 등에서 levelUpMaterialItemGroups에 이 id
