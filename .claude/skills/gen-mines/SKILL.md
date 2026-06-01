---
name: gen-mines
description: "광맥 여러 개를 한 번에 제작 (등급 시리즈/종류 묶음, Category=Mine). 방치형 게임의 광맥 라인업 — efficiency 곡선 일관. 단일은 gen-mine."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 광맥 벌크 생성 (Mine 시리즈)

방치형 핵심 — 등급/종류 광맥 N개를 efficiency 곡선으로 양산.

## 사용 시나리오
- **등급 시리즈**: 금광맥 1~5등급 (efficiency 곡선)
- **종류 묶음**: 금/은/구리/철/미스릴 광맥 5종
- **챕터 광맥**: 챕터별 광맥 라인업

## 저장 규칙
- `_index.yaml`에 N행, `series: <family-key>` + `category: Mine`

## 항상 먼저 읽는다
- gen-mine 참조 문서 동일
- 경제 곡선 관점: 시간당 산출 시뮬 필수

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(등급/종류), N개.
2. **변동 표 작성**: `| grade | name | eff_base | max_stamina | regen | sell_output | upgrade_material |`
3. **ID 일괄 할당**.
4. **공통 efficiency 곡선**(economy-balancer): `growth/{family-key}-mine-efficiency.growth.md` (시간당 산출 시뮬 포함).
5. **정의 N개 병렬**: Mine 특화 필드 일괄.
6. **참조 일괄**: 산출 풀 Material id 시리즈 매핑.
7. **에셋 일괄**: 등급별 광맥 sprite 차등.
8. **_index 일괄**: `series`, `grade`.
9. **묶음 검수** + **`/balance-review` 필수**: 등급별 시간당 산출 곡선이 게임 경제와 정합.
10. **사용자 검수**: 표 + 곡선 그래프.
11. **일괄 승인**.

## 원칙
- **곡선 시뮬은 묶음 단위로** — 개별 광맥보다 시리즈 전체가 게임 경제 결정.
- 등급 간 efficiency 점프가 너무 크면 환생 사이클 비합리.

## 협업
- 단일은 `/gen-mine`
- 산출 재료 시리즈 → `/gen-materials` 먼저
- 곡선 검증 → `/balance-review` (필수)
