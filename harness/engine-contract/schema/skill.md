# Schema Card: Skill

엔진 클래스: `ResourceSkill` (`Commons/Resources/ResourceSkill.proto`). 정의 계층.
스킬 = 발사체/타격/효과의 묶음. 핵심은 **timelines[]** (시간축 액션 시퀀스)와 **triggers[]** (이벤트 로직).

## 핵심 필드

| 필드 (#) | 타입 | 의미 | 참조 |
| --- | --- | --- | --- |
| `id` (100) | int32 | 스킬 dataId | — |
| `name` (200) | string | 표시명 | Strings |
| `tags` (1) | repeated Tag | 분류 | Tags |
| `triggers` (2) | repeated string | 이벤트 로직 트리거 | → behavior |
| `projectileType` (101) | enum | None/Straight/Target/Relative/Parabolic | — |
| `targetRefreshType` (107) | enum | NoRefresh/Random/Nearest/Furthest/LowestHp/HighestHp | — |
| `cooldown`/`initCooldown` (105/104) | float | 쿨다운 | — |
| `damageType` (106) | enum DamageType | 피해 타입(상성) | → Unit.armorType |
| `maxHit`/`maxHitByUnit` (103/309) | int32 | 최대 타격 | — |
| `timelines` (303) | repeated Timeline | ★ 시간축 액션 시퀀스 | (아래) |
| `hitAddBuffs`/`selfAddBuffs` (504/503) | repeated AddBuff | 타격/자신 버프 | → Buff.id |
| `selfAddItemGroups` (506) | repeated AddItemGroup | 자신 보상 | → reward |
| `consecutiveUseSkill` (502) | UseSkill | 연계 스킬 | → Skill.id |

## Timeline (스킬의 심장)

`Timeline { float time; oneof action }` — `time`(초) 시점에 하나의 액션 실행. 액션 종류:

| action | 의미 |
| --- | --- |
| `Hit` | 피해/회복/버프 (geometries로 판정 영역, addDamage/addHeal/addBuffs[], maxHit, repeat) |
| `UnitCharge` / `UnitKnockback` | 돌진 / 넉백 (angle, duration, distance) |
| `UnitDisableMove` / `UnitDisableAction` | 이동/행동 봉인 |
| `UnitUseSkill` / `OwnerUseSkill` / `AddSkill` | 스킬 연계 (UseSkill) |
| `SelfAddBuff` | 자기 버프 |
| `UnitLookAt` / `UnitPlayAnimation` / `PlayFx` | 연출 |
| `ShowDialog` | 대사/연출 (portraits, message, 선택지) |
| `SetUpdateSpeed` | 보드 속도 조절(슬로우모션 등) |
| `RunTrigger` | 트리거 실행 (name + initVariables) → behavior |
| `Destroy` | 종료 |

발사체 물리: `initPosition`(400), `initSpeed`(402), `initAcceleration`(403), `targetHeight`(405), `targetArrivalTime`(406).

## 작성 규칙

- 쿨다운 저작 기본선은 **짧고 자주 발동되는 자동 스킬**이다. `cooldown`을 생략하면 컴파일러가 1.0초를 넣는다.
- 권장 구간: 기본/초기 단일타 0.8~1.2초, 초반 광역/보스 스킬 2.0~3.2초, 중반 핵심 스킬 3.0~5.0초, 버프 스킬은 `duration` 이하 또는 `duration + 1`초 이내, 궁극기/대형 연출은 5.5~8.0초. 8초 초과는 보스 원샷급 연출처럼 명확한 이유가 있을 때만 쓴다.
- 단순 효과(주기 골드, 버프 부여 등)는 `triggers` + `*.behavior.yaml`로.
- 타격형 스킬은 `timelines`로 시점별 Hit/연출을 구성. Hit.addDamage/addBuffs는 ID 참조 무결성 검증 대상.
- `damageType` ↔ 대상 `armorType` 상성은 `ResourceUnit.Global.StatConstants.DamageCoefficient`를 따른다.
- `AddDamage`/`AddHeal`의 percent 이름 필드는 엔진 단위가 섞여 있다. 저작 DSL은 `ratio`와 `percent`를 분리하고, 컴파일 시 `trigger-runtime-semantics.md`의 변환표를 따른다.
- sender/owner가 없는 timeline action은 최신 엔진에서 해당 action만 skip하고 같은 tick의 나머지 action을 계속 실행한다. AI는 sender 의존 action과 순수 연출 action을 같은 tick에 둘 수 있지만, sender가 반드시 필요하면 별도 검증/조건을 둔다.
