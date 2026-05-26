# Schema Card: Buff

엔진 클래스: `ResourceBuff` (`Commons/Resources/ResourceBuff.proto`). 정의 계층.
버프/디버프 = 유닛·스테이지에 부착되는 지속 효과. 스택·기간·주기 효과 + 트리거.

## 핵심 필드

| 필드 (#) | 타입 | 의미 | 참조 |
| --- | --- | --- | --- |
| `id` (100) | int32 | 버프 dataId | — |
| `name` (200) | string | 표시명 | Strings |
| `type` (103) | enum Type | UnitBuff(200)/UnitDebuff(201)/UnitItemBuff(202)/StageBuff(300)/StageDebuff(301)/System(100) | — |
| `tags` (1) | repeated Tag | 분류 | Tags |
| `triggers` (2) | repeated string | 이벤트 로직 | → behavior |
| `addStats` (5) | repeated AddUnitStat | 부여 스탯 (`value[]` = 레벨/스택별) | → stat-catalog |
| `stack`/`maxStack` (101/102) | int32 | 스택 | — |
| `maxLevel` (199) | int32 | 최대 레벨 | — |
| `duration`/`period`/`delay` (300/301/302) | float | 지속/주기/지연 | — |
| `group`/`groupTier` (198/197) | int32 | 버프 그룹/티어 | → Global.buffGroupPolicy |

## 주기/조건 효과 (400대)

| 필드 | 시점 |
| --- | --- |
| `initialAddDamage`/`initialAddHeal` (400/401) | 부여 즉시 |
| `periodicAddDamage`/`periodicAddHeal`/`periodicUseSkill` (402/403/408) | 주기마다 |
| `onAttackedSelfAddDamage`/`onAttackedAttackerAddDamage` (404/405) | 피격 시 |
| `expirationAddDamage`/`expirationAddHeal` (406/407) | 만료 시 |
| `maxStackUseSkill` (409) | 최대 스택 도달 |
| `maxLevelPeriodic*` (410~412) | 최대 레벨 주기 |

→ Damage/Heal은 AddDamage/AddHeal, UseSkill은 Skill.id 참조.

## 전역(Global) 정책

`ResourceBuff.Global` — `buffApplyProbabilities`(버프 그룹별 적용 확률), `buffGroupPolicy`(KeepAll/UseHighestTier/UseLowestTier). 같은 그룹 버프 충돌 처리 규칙.

## 보조 스탯 채널

`addArmorTypeStats`(105)·`addDamageTypeStats`(106)·`addItemGroupStats`(107)·`addSlotStats`(108)·`addBuffGroupStats`(109)·`addSkillGroupStats`(110) — `stat-catalog.md` 보조 채널.

## 작성 규칙

- 단순 스탯 버프는 `addStats`만으로 충분 (예: 공격 +20%). 레벨/스택 성장은 `value[]` 배열 → growth 식으로.
- 주기 피해/회복/스킬은 400대 필드. 복잡한 조건 로직은 `triggers` + `*.behavior.yaml`.
- 같은 효과군은 `group`/`groupTier`로 묶어 중첩 정책을 Global에서 제어.
- `AddDamage`/`AddHeal` source는 skill source와 다르다. buff source 이벤트/FX에는 `BuffDataId`/`BuffId`가 남고 critical 처리는 skill처럼 타지 않는다.
- 대형 periodic damage/heal은 long-safe 경로를 탄다. 다만 trigger에서 `Damage`/`Heal`을 읽고 `Return`을 설정하면 `FixedFloat` 채널로 clamp될 수 있다.
