---
name: gen-selectable-box
description: "선택 상자 1종을 완성형으로 제작 (Item.Type=SelectableBox). 사용 시 N개 옵션 중 선택 — 가챠가 아닌 명시적 선택. 단일은 여기, 시리즈는 gen-selectable-boxes."
argument-hint: "[게임 id] [상자 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 선택 상자 생성 (Type=SelectableBox)

SelectableBox는 **사용 시 N개 옵션 제시 → 사용자가 1개(또는 N개) 선택**. 가챠가 아닌 보장형.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: SelectableBox` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — SelectableBox 필드, addItemGroups의 선택 옵션 처리
- `harness/engine-contract/schema/reward.md`
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 선택 옵션 N개, 선택 가능 수(1 또는 K), 획득 경로, 한정 여부.
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: SelectableBox
   - **addItemGroups**: 선택 옵션 풀 — weight 대신 명시 선택 플래그(엔진 처리)
   - **selectableCount(또는 등가)**: 선택 가능 수
   - sellPrice / iapIdentifier
   - spriteGroups (Icon)
4. **참조 검증**: 옵션 itemDataId 무결.
5. **에셋**(asset-producer): Icon.
6. **_index 등록**: `type: SelectableBox`, `option_count` 태그.
7. **검수/승인**.

## 원칙
- 옵션 가치가 비슷해야 — 한 옵션만 압도적이면 사실상 보장형 아님.
- 선택 가능 수는 1이 표준, K개는 특별.

## 협업
- 시리즈는 `/gen-selectable-boxes`
- 옵션 아이템 미리
