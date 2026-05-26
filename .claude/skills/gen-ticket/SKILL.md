---
name: gen-ticket
description: "티켓 1종을 완성형으로 제작 (Item.Type=Ticket). 입장권/소비 티켓 — 던전/이벤트 진입권. 단일은 여기, 시리즈는 gen-tickets."
argument-hint: "[게임 id] [티켓 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 티켓 생성 (Type=Ticket)

티켓은 던전/이벤트 입장권. **소비형** — count로 보유, 사용 시 차감.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Ticket` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Ticket 필드, useAction(있다면)
- `harness/engine-contract/reference-graph.md` — 어떤 Map 진입에 쓰이는지 — Map의 requiredItemDataIds (있다면)
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 티켓 용도(특정 던전/일일 횟수/이벤트), 획득 경로(드롭/구매/보상), 사용 대상(Map.id), 최대 소지/일일 충전.
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Ticket
   - sellPrice(상점 판매 시) / iapIdentifier(IAP면)
   - maxStamina/staminaRegenPerSecond (일일 충전형이면)
   - sellAddItemGroups(분해)
   - spriteGroups (Icon)
4. **참조 연결**: 사용 대상 Map의 진입 조건에 이 티켓 id 추가 (별도 _v# draft).
5. **에셋**(asset-producer): Icon (티켓 모양).
6. **_index 등록**: `type: Ticket`, `use_target: map/event` 태그.
7. **검수/승인**.

## 원칙
- 입장 차감 로직은 엔진 처리 — 콘텐츠는 id 참조만.
- 일일 충전형은 stamina 시스템 활용 가능.
- 사용 대상이 명확해야 — 댕글링 방지.

## 협업
- 시리즈는 `/gen-tickets`
- 사용 대상 Map → `/gen-map(s)` 페어 작업
