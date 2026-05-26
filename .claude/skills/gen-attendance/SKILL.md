---
name: gen-attendance
description: "출석 보상 1세트를 완성형으로 제작 (Item.Type=Attendance). 7/14/30일 출석판 + 일자별 보상 라인업. 보통 1세트 안에 N일 묶음."
argument-hint: "[게임 id] [출석판 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 출석 보상 생성 (Type=Attendance)

Attendance는 **1세트 안에 N일 보상 묶음**. 시즌/이벤트 단위로 새 출석판 생성.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Attendance` + `period: 7/14/30/...` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Attendance 필드, popupArgs(Popup_Attendance + 시즌 코드)
- `harness/engine-contract/schema/achievement.md` — Daily/Login 업적과 연동
- `harness/game-profiles/<game>.profile.yaml`

## 단계
1. **결정**(AskUserQuestion): 기간(7/14/30일), 무료/유료, 일자별 보상 라인업, 시즌 id, 마일스톤(7일/14일 보너스).
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Attendance
   - startAt / untilAt
   - popupArgs: `{Popup_Attendance: "<season_code>"}`
   - addItemGroups: 일자별 N개 (인덱스로 매핑) 또는 부속 Achievement
   - spriteGroups (출석판 UI)
4. **보상 곡선**(economy-balancer): 일자별 보상 가치 곡선 + 마일스톤 보너스.
5. **부속 Achievement**(권장): `gen-achievements`로 Daily type 또는 Login condition 출석 업적 N개 생성.
6. **에셋**(asset-producer): 시즌 테마 배너, 일자별 sprite (있다면).
7. **_index 등록**: `type: Attendance`, `period`, `season` 태그.
8. **검수/승인**.

## 원칙
- 출석판은 **시즌 단위로 새로** — 영구 출석판 X.
- 일자별 보상 가치는 후반 마일스톤(7/14일) 점프 — 출석 동기 유지.
- Daily/Login 업적과 함께 — 출석 카운트는 condition으로 자동.

## 협업
- 일자별 업적 묶음 → `/gen-achievements` (Daily/Login condition)
- 보상 아이템 미리 → 카테고리별 스킬
