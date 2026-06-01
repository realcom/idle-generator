---
name: gen-currency
description: "통화 1종을 완성형으로 제작 (Item.Category=System, reserved_ids). 골드/루비/크레딧 등 게임 통화 — 예약 id 사용. 거의 만들지 않으며, 새 통화 도입 시에만."
argument-hint: "[게임 id] [통화 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 통화 생성 (Category=System, reserved_ids)

통화는 **시스템 아이템** — 엔진 코드가 직접 id를 참조하므로 `game-profile.reserved_ids` 또는 `currencies`와 엄격히 일치해야 함.

## 주의
- **이미 정의된 통화(gold, ruby, exp 등)는 새로 만들지 않음** — game-profile의 currencies/reserved_ids에서 id 확인만.
- 새 통화 도입은 엔진팀 합의 필수 — 클라/서버 양쪽 코드가 알아야.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: System`, `currency` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — System Category 필드
- `harness/game-profiles/<game>.profile.yaml` — currencies, reserved_ids
- `harness/content/<game>/items/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): 통화 용도(soft/premium/exp/event), 엔진팀 합의됐는가, 이름.
2. **ID 할당**: **반드시** game-profile의 currencies 또는 reserved_ids에 새 항목 추가하고 거기서 id 가져옴. profile에 없으면 stop — 엔진팀에 등록 요청.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: System
   - id: profile에서 가져온 예약 id
   - name
   - spriteGroups (Icon)
4. **에셋**(asset-producer): Icon만 (통화 UI 아이콘).
5. **_index 등록**: `category: System`, `currency`, `reserved: true` 태그.
6. **검수/승인**.

## 원칙
- **id는 절대 임의 할당 X** — game-profile의 currencies/reserved_ids 매핑이 정본.
- 컴파일된 Items.json에서 currency id가 정확해야 — 다른 아이템들의 itemDataId 참조와 일치.
- 새 통화는 엔진/서버 양쪽 인지 필요.

## 협업
- 벌크 없음 (통화는 1~2개만 추가됨).
- 새 통화 도입 전에 엔진팀 합의.
