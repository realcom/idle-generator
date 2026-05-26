---
name: gen-selectable-boxes
description: "선택 상자 여러 개를 한 번에 제작 (등급별/테마별 시리즈, Type=SelectableBox). 등급 상자 라인업, 시즌 선택 상자 등. 단일은 gen-selectable-box."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 선택 상자 벌크

## 사용 시나리오
- 등급별 무기 선택 상자 (일반/희귀/영웅)
- 시즌별 테마 상자
- 슬롯별 장비 선택권

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(등급/슬롯/테마), N개.
2. **변동 표**: `| id | name | options(item_ids) | select_k | source |`
3. **ID 일괄 할당**.
4. **정의 N개 병렬**: 옵션 풀 매핑.
5. **참조 일괄 검증**.
6. **에셋 일괄**: 등급/테마별.
7. **_index 일괄**: `series`, `grade`.
8. **검수/승인**.

## 원칙
- 옵션 풀이 같은 카테고리(무기/장비)면 자동 검증 쉬움.
- 등급별 옵션 가치 곡선 일관.

## 협업
- 단일은 `/gen-selectable-box`
- 옵션 아이템 시리즈 → 해당 카테고리 스킬
