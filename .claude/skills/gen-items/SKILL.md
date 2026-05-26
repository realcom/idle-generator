---
name: gen-items
description: "아이템 벌크 제작 라우터 — Category 결정 후 적합한 복수형 세부 스킬로 위임. 분류 불명확한 시리즈 요청 시 진입점. 분류 명확하면 gen-weapons/gen-equipments/gen-materials/gen-pets/gen-mines/gen-iaps 등 직접 호출이 빠름."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 아이템 벌크 라우터 (Category 결정 → 복수형 스킬 위임)

시리즈/세트/패키지 단위의 아이템 양산 진입점. **공통 Category 결정 후 복수형 세부 스킬**로 위임.

## 사용 시점
- 시리즈 카테고리를 모를 때 ("이번 시즌 신상 5종 만들어줘")
- 복합 시리즈 (예: 무기+장비 풀세트) — 카테고리별로 분리 위임
- 카테고리 명확하면 직접 복수형 스킬 호출이 빠름.

## 항상 먼저 읽는다
- gen-item 동일
- 시리즈 관점: 공통 Category 1회, 벌크 처리는 복수형 스킬에서.

## 단계

### 1. 시리즈 Category 결정 (AskUserQuestion)
시리즈 요청을 듣고 공통 Category 결정. 복합이면 카테고리별 분할.

| Category | 위임 스킬 | 시리즈 예 |
| --- | --- | --- |
| Weapon | `/gen-weapons` | 검 Tier 1~5, 4직업 무기 |
| Equipment | `/gen-equipments` | 6슬롯 풀세트, 등급 시리즈 |
| Material | `/gen-materials` | 가죽 3등급, 광물 5종 (★자주) |
| Pet | `/gen-pets` | 4속성, 등급 시리즈 |
| Mine | `/gen-mines` | 등급 광맥 라인업 |
| Product (IAP) | `/gen-iaps` | 초/중/고 패키지 |
| Product/Ticket | `/gen-tickets` | 챕터별 입장권 |
| Product/Boost | `/gen-boosts` | XP/Gold/Drop 4종 |
| Product/Utility | `/gen-utilities` | 리셋권 세트 |
| Product/SelectableBox | `/gen-selectable-boxes` | 등급 상자 라인업 |
| Product/Recipe | `/gen-recipes` | 무기 등급 레시피 |
| Stat | `/gen-stat-items` | 스탯별 풀세트 |
| Skill (Item) | `/gen-skill-items` | 스킬북 라인업 |
| Trait | `/gen-traits` | 빌드 트리 |

### 2. 위임 실행
복수형 스킬 1개 또는 N개 호출. 복합 시리즈는 카테고리별 분리 위임 (각자 family-key는 별도 또는 공유).

### 3. (벌크 단일은 단일 라우터로)
시리즈 N=1이면 `/gen-item`(단일 라우터)로 폴백.

## 원칙
- **벌크는 카테고리당 1번** — 한 호출 안에서 카테고리 섞지 말 것.
- N>20이면 카테고리/등급 단위로 분할 권장.
- 시리즈 외부 참조(드롭/장착)는 미리 또는 같은 라운드 _drafts.

## 협업
- 단일은 `/gen-item` 라우터
- 직접 카테고리 알면 복수형 스킬 바로
- 복합 시리즈는 `/new-content`로 발산 후 위임도 OK
