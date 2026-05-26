---
name: gen-tickets
description: "티켓 여러 개를 한 번에 제작 (던전별/등급별 시리즈, Type=Ticket). 챕터별 입장권 라인업, 등급별 이벤트 티켓 등. 단일은 gen-ticket."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 티켓 벌크 (Ticket 시리즈)

## 사용 시나리오
- 챕터별 입장권 (1장~10장)
- 등급별 이벤트 티켓 (브론즈/실버/골드)
- 일일/주간/월간 충전 티켓 세트

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(챕터/등급/주기), N개.
2. **변동 표**: `| id | name | use_target_map | max_stamina | regen | source |`
3. **ID 일괄 할당**.
4. **정의 N개 병렬**(content-designer): Ticket 필드.
5. **사용 대상 Map 페어 갱신**: 각 Map의 진입 조건에 해당 ticket id.
6. **에셋 일괄**: 등급별 색 차등.
7. **_index 일괄**: `series`, `use_target`.
8. **묶음 검수**: 사용 대상 댕글링 없음.
9. **승인**.

## 원칙
- 사용 대상 Map 시리즈와 페어 작업.
- 등급별 충전 차이 일관.

## 협업
- 단일은 `/gen-ticket`
- 사용 대상 Map 시리즈 → `/gen-maps`
