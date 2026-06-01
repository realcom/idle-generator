---
name: gen-traits
description: "특성 여러 개를 한 번에 제작 (빌드 트리, 컨셉별 묶음, Category=Trait). 공격/방어/유틸 빌드 트리, 등급별 특성 풀. 단일은 gen-trait."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 특성 벌크 (빌드 트리)

## 사용 시나리오
- 빌드 트리 한 가지(공격형) 10~20 특성
- 컨셉별 풀 (공격/방어/유틸/스피드)
- 등급 시리즈 (일반/희귀/영웅 특성)

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(컨셉/등급), N개, 트리 구조 여부.
2. **변동 표**: `| id | name | concept | effect_summary | buff_id | exclusives | unlock_ach |`
3. **ID 일괄 할당**.
4. **연결 Buff 묶음**: 패시브 buff 시리즈를 buffs/_drafts에 일괄.
5. **정의 N개 병렬**: buff 페어 + 배타 그룹 매핑.
6. **트리 구조**(있다면): parentTrait/childTrait 관계 표현 (필드 확인 — Achievement처럼 트리 가능한지).
7. **에셋 일괄**.
8. **_index 일괄**: `series`, `concept`.
9. **묶음 검수**: 컨셉 일관, 배타 그룹 무결.
10. **승인**.

## 원칙
- 빌드 트리는 컨셉 일관성 핵심 — 한 트리 안 effect 시너지.
- 상호 배타 그룹은 같은 슬롯의 선택지로 — 신중 설계.

## 협업
- 단일은 `/gen-trait`
- 효과 buff 시리즈 → buff _drafts 일괄
