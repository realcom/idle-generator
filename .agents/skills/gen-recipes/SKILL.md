---
name: gen-recipes
description: "제작 레시피 여러 개를 한 번에 제작 (등급별/대상별 시리즈, Type=Recipe). 무기 등급 제작 라인업, 분야별 레시피 풀. 단일은 gen-recipe."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 레시피 벌크 (Recipe 시리즈)

## 사용 시나리오
- 무기 등급 제작 레시피 (1~5등급 검 레시피)
- 분야별 풀 (무기/장비/소비템 제작)
- 시즌 한정 레시피

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(등급/대상/분야), N개.
2. **변동 표**: `| id | name | output_item | materials({id:count}) | cost_gold | success% |`
3. **ID 일괄 할당**.
4. **사전 확인**: 모든 산출/재료 id 무결.
5. **정의 N개 병렬**.
6. **곡선 검토**(economy-balancer): 등급별 재료 비용 곡선 일관.
7. **에셋 일괄**.
8. **_index 일괄**: `series`, `output_category`.
9. **묶음 검수**: 재료-산출 가치 균형, 댕글링 없음.
10. **승인**.

## 원칙
- 등급별 곡선은 무기/장비 시리즈와 페어 — 함께 만들면 일관.
- 가치 곡선은 balance-review로 검증 권장.

## 협업
- 단일은 `/gen-recipe`
- 산출 무기 시리즈 → `/gen-weapons`
- 재료 시리즈 → `/gen-materials`
