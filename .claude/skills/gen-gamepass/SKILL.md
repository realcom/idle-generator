---
name: gen-gamepass
description: "시즌 패스 1개를 완성형으로 제작 (Item.Type=GamePass). 무료/유료 트랙 단계별 보상 — 보통 시즌당 1개. 단일이 표준."
argument-hint: "[게임 id] [패스 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 시즌 패스 생성 (Type=GamePass)

GamePass는 보통 시즌당 **단일** — 무료/유료 트랙 + 단계별 보상 + 시즌 기간.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: GamePass` + `season: <id>` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — GamePass 필드, addItemGroups의 단계별 처리 또는 부속 Achievement 트리
- `harness/engine-contract/schema/achievement.md` — EventPass type 업적이 패스 단계 카운트 가능
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 시즌 id, 기간(startAt/untilAt), 무료/유료 트랙 분리, 단계 수(보통 30/50/100), 단계당 보상 라인업, 유료 가격.
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: GamePass
   - iapIdentifier, priceUsd (유료 트랙 가격)
   - startAt / untilAt
   - addItemGroups (단계별 보상 — 또는 부속 Achievement.EventPass 트리에 위임)
   - spriteGroups (시즌 테마)
4. **단계 보상 설계**(economy-balancer):
   - 곡선 (단계가 올라갈수록 가치 증가)
   - 무료/유료 차등 (유료가 약 2~5배)
5. **부속 Achievement 묶음**(권장): `gen-achievements`로 EventPass type 단계 업적 일괄 생성 + parent-child로 패스 단계 카운트.
6. **에셋**(asset-producer): 시즌 배너 + 패스 UI sprite.
7. **_index 등록**: `season`, `type: GamePass` 태그.
8. **검수/승인**.

## 원칙
- **시즌당 단일** — 벌크 스킬 없음.
- 단계 보상은 부속 Achievement(EventPass) 트리로 관리하는 게 깔끔.
- startAt/untilAt 필수.
- 유료/무료 트랙 차등 곡선 일관.

## 협업
- 단계 업적 묶음 → `/gen-achievements` (EventPass type)
- 보상 아이템 → 미리 카테고리별 스킬로 생성
