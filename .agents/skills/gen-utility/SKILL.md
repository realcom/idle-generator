---
name: gen-utility
description: "유틸리티 아이템 1종을 완성형으로 제작 (Item.Type=Utility). 리셋권/이름변경권/슬롯확장 등 기능성 아이템. 단일은 여기, 시리즈는 gen-utilities."
argument-hint: "[게임 id] [유틸 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 유틸리티 생성 (Type=Utility)

Utility는 **즉시성 기능 아이템** — 능력 리셋권/이름변경권/인벤토리 확장권/부활권 등.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Utility` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Utility 필드, useAction
- `harness/engine-contract/action-vocabulary.md` — 어떤 동작이 useAction으로 가능한지
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 용도(리셋/이름변경/슬롯확장/부활/즉시완료), 사용 효과, 획득 경로.
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Utility
   - **useAction(또는 등가 필드)**: 엔진 정의 동작
   - sellPrice / iapIdentifier
   - 사용 제약 (requiredItemDataIds 등)
   - spriteGroups (Icon)
4. **참조 검증**: useAction이 엔진 어휘에 존재.
5. **에셋**(asset-producer): Icon.
6. **_index 등록**: `type: Utility`, `function: <reset/rename/...>` 태그.
7. **검수/승인**.

## 원칙
- useAction은 engine-bound — 없는 동작은 엔진 추가 작업.
- 리셋권 같이 영구적 영향 있는 건 사용 확인 팝업 필수 (엔진 처리).

## 협업
- 시리즈는 `/gen-utilities`
- 새 useAction 필요 시 엔진팀 합의 우선
