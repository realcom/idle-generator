---
name: gen-skills
description: "스킬 여러 개를 한 번에 제작 (티어/속성/직업/연계 시리즈 단위). 무기 스킬 트리, 4속성 스킬, 직업별 스킬 세트, 단계별 진화 스킬 등 같은 패턴·다른 파라미터의 스킬 N개를 일관되게 양산. 단일은 gen-skill."
argument-hint: "[게임 id] [시리즈 설명: 예: '검 스킬 트리 (티어 1~5, 데미지·쿨다운 곡선)']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스킬 벌크 생성 (티어/속성/직업)

같은 발사체·타임라인 패턴의 스킬 N개를 **데미지·쿨다운 곡선**으로 양산한다. 공통 timeline + 변동 차원(티어/속성/연계) + 묶음 검수.

## 사용 시나리오
- **티어 스킬 트리**: 검 스킬 Tier 1~5 (데미지 곡선, 쿨다운 단축)
- **속성 시리즈**: 화/수/풍/지 4속성 스킬 (데미지 타입만 다름)
- **직업 세트**: 전사/마법사/궁수 각자 3~5스킬
- **연계 체인**: 1차 → 2차 → 3차 진화 스킬 (consecutiveUseSkill)
- **무기 스킬 라인업**: Katana/Gun/Dagger/Hammer — 무기별 1개씩

## 콘텐츠 저장 규칙

- **draft**: `harness/content/<game>/skills/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/skills/approved/{id}_{name}.yaml`
- **_index.yaml**: 시리즈 일괄 등록

## 항상 먼저 읽는다
- `harness/engine-contract/schema/skill.md` — projectileType, timelines, damageType, cooldown
- `harness/engine-contract/reference-graph.md` — addBuffs, consecutiveUseSkill, 상성
- `harness/engine-contract/json-serialization.md`
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.skill, 가드레일
- `harness/content/<game>/skills/_index.yaml`

## 단계

1. **시리즈 정의**(AskUserQuestion):
   - **공통 projectileType**(직선/유도/포물선/타겟)
   - **공통 timeline 패턴**(Hit/Charge/AddBuff 순서)
   - **변동 차원**: 티어 / 속성(damageType) / 직업 / 연계 단계
   - **인스턴스 수** (3~10)
2. **변동 표 작성**:
   - 표 (열: id·name·tier·damageType·base_damage·cooldown·hit_buff_id·연계 다음 skill_id·sprite_key)
   - 예시:
     ```
     | tier | name       | damage_type | base_dmg | cooldown | hit_buff | next_skill |
     | ---- | ---------- | ----------- | -------- | -------- | -------- | ---------- |
     | 1    | 베기       | Physical    | 50       | 2.0      | -        | -          |
     | 2    | 강한 베기  | Physical    | 120      | 1.8      | -        | -          |
     | 3    | 회전 베기  | Physical    | 280      | 1.5      | 300101   | -          |
     | ...  | ...        | ...         | ...      | ...      | ...      | ...        |
     ```
3. **ID 일괄 할당**: `profile.id_ranges.skill` 대역 → 연속.
4. **데미지/쿨다운 곡선**(economy-balancer): **식 1개**로 티어별 곡선 → `harness/content/<game>/growth/{family-key}-skill-scale.growth.md`. damageType ↔ armorType 상성 검증.
5. **정의 N개 생성**(content-designer, **병렬**):
   - 각 인스턴스: `harness/content/<game>/skills/_drafts/{id}_{name}_v1.yaml`
   - 공통: projectileType, timelines 구조
   - 변동: damageType, value[], cooldown, hitAddBuffs(→Buff.id)
6. **연계 체인 결정**:
   - consecutiveUseSkill로 다음 단계 연결 시 표 단계에서 미리 확정
   - 순환 참조 방지
7. **참조 일괄 검증**:
   - addBuffs(→Buff.id), consecutiveUseSkill(→Skill.id) 무결성
   - hit_buff 시리즈가 있으면 `gen-buff` 먼저 또는 같은 라운드 _drafts
8. **에셋 일괄**(asset-producer): sprite/effect 키. 시리즈 단계별 색/사이즈 변화.
9. **_index 일괄 등록**: `skills/_index.yaml`에 N행 (`series`, `tier` 태그).
10. **묶음 검수**(content-reviewer):
    - 데미지 곡선 monotonic, 쿨다운 단축 단계 합리
    - 상성·참조 무결성 일괄
11. **사용자 검수**: 표 + 샘플 2개. 데미지 시뮬레이션 권장.
12. **일괄 승인**: `_drafts/*_vN.yaml` → `approved/*.yaml`.

## 원칙
- **공통 timeline 1회, 곡선 식 1회**.
- 연계 체인은 표 단계에서 ID 사전 합의.
- damageType ↔ 대상 armorType 상성은 unitGlobal.DamageCoefficient 따름.
- 단순 효과(주기 골드 등)는 skill보다 trigger — `gen-triggers` 추천.

## 다른 스킬과의 협업
- 단일 스킬은 `/gen-skill`
- 시리즈에 쓸 버프 → 미리 buff _drafts에
- 복잡 로직 → `/gen-triggers`
- 스킬 장착할 아이템 → `/gen-items`에서 equipSkillDataIds 참조
