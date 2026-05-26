---
name: gen-materials
description: "재료 여러 개를 한 번에 제작 (등급 시리즈, 종류별 세트, Category=Material). 가죽 3등급·광물 5등급·종류별 재료 풀 — 가장 자주 양산. 단일은 gen-material."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 재료 벌크 생성 (Material 시리즈)

가장 흔한 벌크 — 재료는 등급별/종류별로 묶어 한 번에 양산.

## 사용 시나리오
- **등급 시리즈**: 가죽 낡은/일반/빛나는 (3등급)
- **종류 세트**: 광물 5종 (구리/철/은/금/미스릴)
- **챕터별**: 1장 재료 / 2장 재료 (출처 unit과 페어)
- **분해 산출 묶음**: 무기 분해로 나오는 재료 4종

## 저장 규칙
- `_index.yaml`에 N행, `series: <family-key>` + `category: Material`

## 항상 먼저 읽는다
- gen-material 참조 문서 동일
- 시리즈 관점: 등급 곡선 (sellPrice·decompose 보상)

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(등급/종류/챕터), N개.
2. **변동 표**: `| grade | name | sell_price | drop_from | decompose_output | icon_key |`
3. **ID 일괄 할당**: 연속.
4. **공통 sellPrice 곡선**(economy-balancer): 등급별 가격 곡선 (식 1개).
5. **정의 N개 병렬**: 단순 — category/grade/sellPrice/spriteGroups.
6. **참조 백채움 일괄**:
   - 출처 Unit들의 dropAddItemGroups에 이 시리즈 id 분배
   - 사용처 무기·장비의 levelUpMaterialItemGroups에 시리즈 id
7. **에셋 일괄**: 같은 베이스 + tint (가죽 색 변화 등).
8. **_index 일괄**: `series`, `grade`.
9. **묶음 검수**: 가격 곡선 monotonic, 등급 누락 없음.
10. **사용자 검수**: 표 + 샘플 1~2.
11. **일괄 승인**.

## 원칙
- 재료 벌크는 **가장 빈도 높음** — 무기/장비 시리즈마다 같이 생성됨.
- 출처/사용처 양방향 참조 중요 (시리즈 단위로 일괄 갱신).
- 색/사이즈 베리에이션은 베이스 1개 + tint 권장.

## 협업
- 단일은 `/gen-material`
- 출처 Unit 시리즈 → `/gen-units` 먼저
- 사용처 무기 시리즈 → `/gen-weapons`와 페어 작업
