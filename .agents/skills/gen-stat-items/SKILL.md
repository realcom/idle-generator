---
name: gen-stat-items
description: "스탯 강화 아이템 여러 개를 한 번에 제작 (스탯별/등급별 시리즈, Category=Stat). Attack/Hp/Crit 풀세트, 등급 시리즈. 단일은 gen-stat-item."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스탯 강화 벌크

## 사용 시나리오
- 스탯별 풀세트: Attack/Hp/Defense/Crit 룬 4종
- 등급 시리즈: 동일 스탯의 일반/희귀/영웅
- 매트릭스: 4스탯 × 3등급 = 12종

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(스탯/등급), N개.
2. **변동 표**: `| id | name | stat_key | base_value | grade | levelup_material |`
3. **ID 일괄 할당**.
4. **공통 강화 곡선**(economy-balancer).
5. **정의 N개 병렬**.
6. **_index 일괄**: `series`, `stat`, `grade`.
7. **묶음 검수**: 스탯별 가드레일 (CriticalPercent ≤100% 등).
8. **승인**.

## 원칙
- 같은 스탯의 등급 시리즈는 직선 곡선, 다른 스탯 풀세트는 가치 균형.

## 협업
- 단일은 `/gen-stat-item`
