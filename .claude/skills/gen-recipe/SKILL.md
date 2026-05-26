---
name: gen-recipe
description: "제작 레시피 1종을 완성형으로 제작 (Item.Type=Recipe). 재료 N개를 소비하여 아이템 1개를 산출하는 크래프팅. 단일은 여기, 시리즈는 gen-recipes."
argument-hint: "[게임 id] [레시피 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 레시피 생성 (Type=Recipe)

Recipe는 **크래프팅 레시피** — productMaterialItemGroups(요구 재료) → addItemGroups(산출물).

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`(또는 schema 확인), `type: Recipe` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Recipe 필드, productMaterialItemGroups(600), addItemGroups(500)
- `harness/engine-contract/reference-graph.md` — Recipe → 재료/산출
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 산출물(아이템 id), 요구 재료(Material id 여러 개), 비용(gold/exp), 제작 시간, 성공률, 해금 조건.
2. **ID 할당**: `profile.id_ranges.item`.
3. **산출 + 재료 사전 확인**: 모두 items/_index approved에 실재.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product(또는 자체), type: Recipe
   - **productMaterialItemGroups**: 요구 재료 [{itemDataId, count}]
   - **addItemGroups**: 산출물 (확률형이면 weight)
   - sellPrice / 제작 비용
   - requiredAchievementDataIds (해금 시)
   - spriteGroups (Icon)
5. **참조 검증**: 재료/산출 itemDataId 무결.
6. **에셋**(asset-producer): Icon (레시피 모양).
7. **_index 등록**: `type: Recipe`, `target_item: <output_id>` 태그.
8. **검수/승인**.

## 원칙
- 재료 비용 vs 산출 가치 균형 — gold sink 효과 고려.
- 성공률(있다면)은 reward.md의 가챠 로직 따름.
- 해금은 reserved_ids 또는 신규 업적과 페어.

## 협업
- 시리즈는 `/gen-recipes`
- 재료 시리즈 → `/gen-materials`
- 산출 아이템 → 해당 카테고리 스킬
