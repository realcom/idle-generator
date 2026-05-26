---
name: gen-utilities
description: "유틸리티 여러 개를 한 번에 제작 (기능별 묶음, Type=Utility). 리셋권 세트, 슬롯확장권 라인업 등. 단일은 gen-utility."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 유틸리티 벌크 (Utility 시리즈)

## 사용 시나리오
- 슬롯확장권 1/3/5칸 (등급별)
- 능력 리셋권 종류별 (장비/펫/스탯)
- 부활권 등급별

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(기능/등급/효과량), N개.
2. **변동 표**: `| id | name | useAction | effect_size | source |`
3. **ID 일괄 할당**.
4. **정의 N개 병렬**: useAction 페어.
5. **참조 검증 일괄**: 모든 useAction이 어휘 존재.
6. **에셋 일괄**.
7. **_index 일괄**: `series`, `function`.
8. **묶음 검수**.
9. **승인**.

## 원칙
- 같은 useAction에 effect_size만 다른 시리즈가 가장 흔함.
- 새 useAction 필요 시 엔진팀 합의.

## 협업
- 단일은 `/gen-utility`
