---
name: gen-equipments
description: "장비 여러 개를 한 번에 제작 (슬롯 풀세트, 티어 시리즈, 세트 효과 묶음, Category=Equipment). 6슬롯 풀세트, 등급별 시리즈 등. 단일은 gen-equipment."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 장비 벌크 생성 (Equipment 시리즈)

같은 등급/세트의 장비 N개를 **슬롯 풀세트** 또는 **티어 곡선**으로 양산.

## 사용 시나리오
- **풀세트**: 1등급 풀세트 6슬롯 (Head/Chest/Gloves/Boots/Necklace/Ring)
- **티어 시리즈**: 1~5등급 같은 슬롯
- **세트 효과**: "용사의 갑옷 세트" 6슬롯 (세트 보너스)

## 저장 규칙
- `_index.yaml`에 N행, `series: <set-key>` + `category: Equipment` + `slot` 태그

## 항상 먼저 읽는다
- gen-equipment 참조 문서 동일
- 시리즈 관점: 슬롯별 표준 스탯 일관, 세트 보너스(있다면)

## 단계
1. **시리즈 정의**(AskUserQuestion): **풀세트 모드(6슬롯)** vs **티어 모드(N등급)** vs **세트 효과 모드**.
2. **변동 표 작성**:
   - 풀세트: `| slot | name | base_stat | base_value | option_pool |`
   - 티어: `| tier | name | base_stat | base_value | material_for_levelup |`
3. **ID 일괄 할당**.
4. **공통 growth 패밀리**: 슬롯별 또는 티어별 곡선 식.
5. **정의 N개 병렬**: 슬롯별 표준 스탯 자동 반영.
6. **세트 효과**(있다면): 등록 위치는 별도 buff/passive 또는 equipAddBuffs 시리즈 — 미리 합의.
7. **잠금 백참조**: 6슬롯 풀세트면 각 슬롯의 reserved_ids.achievement.equipmentSlotUnlock<Slot>.
8. **에셋 일괄**: 풀세트는 일관된 아트 톤.
9. **_index 일괄**: `series`, `slot`, `tier`.
10. **묶음 검수**: 슬롯별 표준 스탯 누락 없음, 곡선 monotonic.
11. **사용자 검수**: 표 + 샘플.
12. **일괄 승인**.

## 원칙
- **풀세트는 6슬롯 빠짐 없이** — Head/Chest/Gloves/Boots/Necklace/Ring.
- 세트 보너스는 별도 buff/passive로 — schema 확정 필요.
- 슬롯별 표준 스탯 일관성 (Head=Hp, Chest=Defense 등).

## 협업
- 단일은 `/gen-equipment`
- 세트 보너스 buff → buff _drafts 먼저
- 강화 재료 → `/gen-materials`
