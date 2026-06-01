---
name: gen-iaps
description: "IAP 상품 여러 개를 한 번에 제작 (가격대 라인업, 시즌 묶음, 가챠 시리즈, Category=Product). 초/중/고 패키지 3종, 한정 번들 라인업 등. 단일은 gen-iap."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# IAP 벌크 (Product 시리즈)

가격대 N개 또는 시즌 묶음 라인업.

## 사용 시나리오
- 초/중/고급 패키지 3종 (가격 곡선)
- 시즌 한정 번들 5종 (테마 일관)
- 가챠 라인업 (등급별 천장 차등)

## 저장 규칙
- `_index.yaml`에 N행, `series: <family-key>` + `category: Product`

## 항상 먼저 읽는다
- gen-iap 동일

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(가격대/테마/등급), N개.
2. **변동 표 작성**: `| price_usd | name | iap_id | contents (item:count×N) | start | until |`
3. **ID 일괄 할당**.
4. **가격 곡선 검토**: priceUsd vs 구성품 가치 일관.
5. **정의 N개 병렬**: iapIdentifier 중복 검증.
6. **참조 일괄 검증**: 모든 itemDataId 무결.
7. **에셋 일괄**: 시리즈 테마 배너.
8. **_index 일괄**: `series`, `price_tier`.
9. **묶음 검수**: 가격당 가치 곡선, 구성품 중복 회피.
10. **사용자 검수**: 표 + 샘플.
11. **일괄 승인**.

## 원칙
- 가격대 곡선은 **가치 곡선과 일관** (소액=저가치, 대액=고가치 + 보너스).
- iapIdentifier 시리즈 네이밍 규칙 (예: `idlez.product.starterpack01~03`).
- 한정 묶음은 startAt/untilAt 공통.

## 협업
- 단일은 `/gen-iap`
- 구성품 아이템 미리 → `/gen-items` 또는 카테고리별 스킬
