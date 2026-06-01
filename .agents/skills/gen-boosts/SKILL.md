---
name: gen-boosts
description: "부스터 여러 개를 한 번에 제작 (효과별/지속시간별 시리즈, Type=Boost). XP/Gold/Drop 부스터 풀세트, 등급별 부스터 라인업. 단일은 gen-boost."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 부스터 벌크 (Boost 시리즈)

## 사용 시나리오
- 효과별 풀세트: XP/Gold/Drop/AtkSpeed 4종
- 등급별: 일반/희귀/영웅 부스터
- 시간별: 30분/1시간/4시간 동일 효과

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(효과/등급/지속시간), N개.
2. **변동 표**: `| id | name | effect_stat | effect_value | duration_sec | source |`
3. **ID 일괄 할당**.
4. **연결 Buff 묶음**: 시리즈마다 1개 또는 멤버별 — `buffs/_drafts/`에 일괄.
5. **정의 N개 병렬**(content-designer): Boost 필드 + buff id 페어.
6. **에셋 일괄**: 효과별 아이콘 (XP=책, Gold=동전, Drop=상자).
7. **_index 일괄**: `series`, `effect`, `duration`.
8. **묶음 검수**: 효과량 곡선 + buff 페어 무결.
9. **승인**.

## 원칙
- 효과별 + 등급별 매트릭스 (4효과 × 3등급 = 12종)는 분할 호출 권장.
- buff 페어 일관성 — 멤버 수만큼 buff id 확보.

## 협업
- 단일은 `/gen-boost`
- 연결 Buff 시리즈 → buff _drafts 일괄
