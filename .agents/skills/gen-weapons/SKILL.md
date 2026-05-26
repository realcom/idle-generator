---
name: gen-weapons
description: "무기 여러 개를 한 번에 제작 (티어/속성/직업 시리즈 단위, Category=Weapon). 검 Tier 1~5, 4직업 무기 세트, 무기군 라인업 등. 단일은 gen-weapon."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 무기 벌크 생성 (Weapon 시리즈)

같은 Type의 무기 N개를 **티어 곡선**으로 양산. 공통 Type + 변동(tier/속성/등급) + 묶음.

## 사용 시나리오
- 검 Tier 1~5 (낡은검→영웅검) — Attack 곡선
- 4속성 무기 (Type 같음, damageType 다름)
- 직업별 무기 라인업

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml` (개별)
- `_index.yaml`에 N행, `series: <family-key>` + `category: Weapon`

## 항상 먼저 읽는다
- gen-weapon 참조 문서 동일
- 시리즈 관점: 곡선 monotonic, 강화 재료 시리즈 페어

## 단계
1. **시리즈 정의**(AskUserQuestion): 공통 Type, 변동 차원(tier/속성/등급), N개.
2. **변동 표 작성**: `| tier | name | grade | atk seed | option_weight | material_for_levelup |`
3. **ID 일괄 할당**: 연속.
4. **공통 growth 패밀리**(economy-balancer): `growth/{family-key}-weapon-scale.growth.md` (식 1개로 tier별 base 다름).
5. **정의 N개 병렬**(content-designer): equipAddStats(공통 stat 종류, base 다름), spriteGroups.
6. **강화 재료 체인**: 표 단계에서 tier N의 levelUpMaterialItemGroups → 어떤 Material id 미리 확정.
7. **에셋 일괄**: 같은 베이스 + tint/scale.
8. **_index 일괄**: `series`, `tier` 태그.
9. **묶음 검수**: Attack 곡선 monotonic, 강화 재료 댕글링 0.
10. **사용자 검수**: 표 + 샘플 2개.
11. **일괄 승인**.

## 원칙
- 공통 Type 1회, 곡선 식 1회.
- 강화 재료 시리즈는 미리 또는 같은 라운드 `_drafts/`.
- 옵션 affix는 시리즈 공유 풀 또는 등급별 풀.

## 협업
- 단일은 `/gen-weapon`
- 강화 재료 시리즈 → `/gen-materials` 먼저
- 무기 장착 스킬 시리즈 → `/gen-skills`
