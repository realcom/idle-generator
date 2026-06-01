---
name: gen-skill
description: "스킬 1개를 완성형으로 제작 (ResourceSkill: 발사체·타임라인·타격/버프·쿨다운·상성). 액티브/패시브 스킬, 무기 스킬을 만들 때 사용."
argument-hint: "[게임 id] [스킬 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스킬 제작 (수직 슬라이스)

ResourceSkill 정의(타임라인 중심)를 끝까지 만든다. 인자 없으면 사용법 출력 후 정지.

## 콘텐츠 저장 규칙 (필수)

산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.

- **파일명**: `{id}_{name}.yaml`
- **draft**: `harness/content/<game>/skills/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/skills/approved/{id}_{name}.yaml`
- **_index.yaml**: `harness/content/<game>/skills/_index.yaml`에 행 등록/갱신.

## 항상 먼저 읽는다
- `harness/engine-contract/schema/skill.md` — projectileType, targetRefreshType, cooldown, damageType, **timelines[]**(Hit/Charge/Knockback/UseSkill/AddBuff/PlayFx/RunTrigger/Destroy)
- `harness/engine-contract/reference-graph.md` — addBuffs(→Buff.id), consecutiveUseSkill(→Skill.id), damageType↔armorType 상성
- `harness/engine-contract/json-serialization.md` — enum 표기/기본값 생략/float
- `harness/game-profiles/<game>.profile.yaml` — ID 대역, 사용 스탯, 가드레일
- `harness/pipeline/content-organization.md` — 저장 레이아웃·_index 형식
- `harness/content/<game>/skills/_index.yaml`, `harness/content/<game>/buffs/_index.yaml` — 참조 대상 확인

## 단계
1. **결정**(AskUserQuestion): 발사체 타입(직선/유도/포물선/타겟), 타게팅(최근접/최저HP 등), 쿨다운, 피해 타입, 타격 효과(피해/회복/버프), 연출.
2. **ID 할당**: `profile.id_ranges.skill` 대역에서 `_index.yaml` 스캔 후 다음 빈 id 결정.
3. **정의**(Task content-designer): `harness/content/<game>/skills/_drafts/{id}_{name}_v1.yaml` — id, projectileType, cooldown, damageType, **timelines**(시점별 Hit/효과/연출), hitAddBuffs/selfAddBuffs(→Buff.id, `buffs/_index.yaml`의 approved 확인).
4. **수치/스케일링**(Task economy-balancer): 피해 계수·레벨 스케일이 필요하면 `growth/{id}_{name}.growth.md` 식 → value[] (gameplay 스탯 비례).
5. **복잡 로직**(Task behavior-author): 단순 타임라인으로 안 되는 조건 로직은 triggers + behavior YAML(RunTrigger) — `skills/_drafts/{id}_{name}_behavior_v1.yaml` 또는 짝지어 보관.
6. **_index 등록**: `skills/_index.yaml`에 `{id, name, file, status: draft, created_at, created_by: gen-skill, tags}` 행 추가.
7. **검증**(Task content-reviewer): Buff/Skill ID 무결성, 상성, 가드레일.
8. **사용자 검수**: draft 파일 제시. 피드백이면 `_v2`로 재생성. 승인이면 `approved/`로 이동, `_index` 상태 갱신.

## 주의
- 단순 효과(주기 골드, 버프 부여)는 timelines보다 triggers(behavior)가 적합 — gen-trigger와 협업.
- damageType ↔ 대상 armorType 상성은 unitGlobal.DamageCoefficient를 따름.
- AI는 `_drafts/`에만 쓴다. `approved/` 이동은 승인 액션.
