# Trigger Runtime Semantics (AI authoring contract)

> 목적: `*.behavior.yaml`을 쓰는 AI가 idlez 트리거 VM의 실제 의미를 오해하지 않도록 고정한 계약.
> 출처는 `engine/commons/Resources/ResourceTrigger.*`, `GameUnit.*`, `GameSkill.*` 리뷰와 서버 테스트다.
> 마지막 동기화: 2026-05-26.

## 작성 계층

AI가 작성하는 소스는 `content/<game>/<domain>/*.behavior.yaml`이다.
컴파일러는 이를 engine AST인 `Triggers.json`으로 바꾼다.

| 계층 | 파일 | 역할 |
| --- | --- | --- |
| 저작 DSL | `*.behavior.yaml` | 사람이 읽고 AI가 쓰는 행동 소스 |
| 액션 어휘 | `action-vocabulary.md` | 엔진 method/event/variable의 닫힌 목록 |
| 런타임 의미 | 이 문서 | caller/slot, 숫자, no-op, 위험 edge |
| 엔진 AST | `Triggers.json` | `ResourceTrigger` proto JSON |

## 이벤트와 caller/slot

`domain`은 trigger owner를 정한다. 실제 method receiver는 `call.caller`와 현재 slot에 따라 달라진다.

| owner event | caller | 기본 slot | 메모 |
| --- | --- | --- | --- |
| map `start/update` | 없음 | 없음 | `boardMethod` 중심 |
| unit `start/update` | self unit | 없음 | `unitMethod` 기본 slot이 없으면 no-op이므로 DSL은 owner 호출을 명시해야 한다 |
| skill `start/update` | sender unit + skill | 없음 | sender 없는 skill timeline도 있을 수 있다 |
| buff `start/update` | owner unit + buff | attacker slot 가능 | buff source에 따라 slot unit이 attacker가 될 수 있다 |
| attack/heal 계열 | source/target에 따라 설정 | target 또는 source | `Damage`, `ValidDamage`, `Heal`, `Return` predefined 사용 |

엔진 규칙:

- `boardMethod`는 slot 없이 항상 board를 대상으로 실행된다.
- `unitMethod`, `skillMethod`, `buffMethod`는 receiver가 없으면 예외가 아니라 no-op이다.
- `call.caller = true`면 caller object를, false면 slot object를 receiver로 쓴다.
- 하네스 compiler는 `domain: unit/skill/buff`의 owner 대상 method alias에 `call.caller = true`를 자동으로 붙인다.
- object slot assignment는 고급 기능이다. AI DSL에서는 필요한 action alias로 감싸고 raw AST를 직접 쓰지 않는다.

## 변수 스코프

| 변수 | 수명 | 용도 |
| --- | --- | --- |
| `boardKey` | board 전체 | 웨이브 번호, 전역 플래그 |
| `callerKey` | trigger owner object | unit/skill/buff의 persistent local 변수 |
| `stateKey` | trigger 실행 1회 | 임시 계산 |
| `parameter` | method call 1회 | call assignments가 쓰고 method가 read-once로 소비 |
| `predefinedVariable` | state/board 특수값 | `Return`, `Random`, `Level`, `Damage`, `ValidDamage`, `Heal`, `Tick`, `Timer` 등 |

주의:

- method parameter는 `GetAndClear` 방식이다. 같은 parameter를 한 call 안에서 여러 번 읽는 method는 읽은 뒤 사라진다.
- `runTrigger`는 같은 state와 cost budget을 공유한다.
- 없는 `runTrigger` 이름은 런타임 예외 후보이므로 하네스 검증에서 error로 잡는다.

## 숫자 계약

엔진은 두 숫자 층을 같이 쓴다.

| 값 | 권장 타입 | 이유 |
| --- | --- | --- |
| HP, damage, heal, currency처럼 크게 커지는 절대값 | `long` | idle-game 대형 수치 보존 |
| percent, ratio, probability, duration, position | `FixedFloat` | 소수/배율 표현 |
| trigger VM 변수와 expression 결과 | `FixedFloat` | 기존 AST 계약 |

최신 엔진 보강:

- damage/heal 본체는 long-safe helper를 사용한다.
- attack/heal trigger가 `Return`을 설정하지 않으면 원본 long damage/heal이 유지된다.
- trigger가 `Damage`, `ValidDamage`, `Heal`을 읽거나 `Return`으로 값을 되돌리면 그 값은 `FixedFloat` 범위로 clamp될 수 있다.

AI 작성 규칙:

- 대형 damage/heal을 관찰만 할 때는 `Return`을 쓰지 않는다.
- 대형 수치를 trigger expression 안에서 곱셈/나눗셈하지 않는다.
- 저작 DSL은 `ratio`와 `percent`를 구분해야 한다. 엔진 필드명에 `Percent`가 있어도 단위가 항상 percent는 아니다.

## AddDamage / AddHeal 단위

하네스 저작 단위는 사람이 읽는 의미를 우선한다.

| 저작 의미 | 엔진 필드 | 변환 |
| --- | --- | --- |
| 공격력의 `p%` 피해 | `AddDamage.attackPercentDamages` | `p / 100` raw ratio |
| 현재/최대 HP의 `p%` 피해 | `hpPercentDamages`, `maxHpPercentDamages` | `p / 100` raw ratio |
| 공격력의 `p%` 회복 | `AddHeal.attackPercentHeals` | `p / 100` raw ratio |
| 최대 HP의 `p%` 회복/실드 | `maxHpPercentHeals`, `maxHpPercentShieldHeals` | `p` 그대로 |

`ValidDamage`는 HP가 실제로 감소한 양이 아니라 guard/shield를 지난 뒤 HP에 적용하려 한 유효 타격량이다.
오버킬에서는 현재 HP보다 클 수 있다.

## BoardMethod.AddUnit 계약

`AddUnit`은 존재하며, 하네스의 `AddUnit`/`spawnUnit` action은 `boardMethod:AddUnit`으로 컴파일된다.

| parameter | 필수 | 기본/의미 |
| --- | --- | --- |
| `UnitDataId` | 필수 | 스폰할 `ResourceUnit.id` |
| `Count` | 선택 | 기본 1. 1 이상이어야 한다 |
| `Team` | 선택 | 기본 enemy |
| `LocationId` | 선택 | 0 또는 누락이면 `PositionX/Y` 사용 |
| `PositionX/Y` | 선택 | `LocationId == 0`일 때 스폰 좌표 |
| `Angle` | 선택 | 누락 시 random direction |
| `Offset` | 선택 | unit count by offset 등에 사용 |

런타임 의미:

- `LocationId == 0`: 좌표 파라미터로 `Count`개를 큐잉한다.
- 존재하지 않는 `LocationId`: 빈 선택으로 no-op이다.
- location은 있으나 `geometries`가 비어 있으면 `PickOne(...)!` 경로에서 예외가 날 수 있다.
- `UnitDataId`가 없는 resource를 가리키면 queued unit init 단계에서 실패할 수 있다.

하네스 검증:

- `AddUnit`에 `UnitDataId`가 없으면 error.
- 상수 `UnitDataId`가 `Units`에 없으면 error.
- 상수 `Count <= 0`이면 error.
- 맵에 연결된 trigger가 `LocationId`를 쓰면 해당 map location과 geometry를 검증한다.
- 모든 map location은 geometry를 1개 이상 가져야 한다.

## Method safety 정책

최근 엔진 보강으로 다음은 no-op 또는 `Return = 0`으로 안전화됐다.

- `UnitMethod.GetWeaponType`: player avatar/weapon/resource가 없으면 `Return = 0`.
- `UnitMethod.GetCurrentHpPercent`: `MaxHp <= 0`이면 `Return = 0`.
- `BoardMethod.GetMainPlayerUnitVariable`: main player unit이 없으면 `Return = 0`.
- `BoardMethod.ShowSelectTrait`: main player가 없으면 no-op.
- skill timeline의 sender/owner 의존 action은 sender/owner가 없으면 해당 action만 skip하고 같은 tick의 나머지 action은 계속 실행한다.

아직 하네스가 사전 검증해야 하는 후보:

- inventory 계열 unit method는 player/inventory fixture 전제가 섞여 있다.
- required parameter와 receiver domain 검증은 MethodMetadata 기반으로 더 강화할 수 있다.
- unknown action은 컴파일 단계 error다. unknown trigger name은 검증 단계 error다.

## AI 작성 체크리스트

1. `action-vocabulary.md`에 있는 action만 쓴다.
2. `UnitDataId`, `SkillDataId`, `BuffDataId`, `ItemDataId`, `LocationId` 참조는 실제 정의를 확인한다.
3. `AddUnit`에 `locationId`를 쓰면 맵 `locations[].geometries[]`도 같이 만든다.
4. 대형 damage/heal을 trigger에서 수정하지 않는다면 `Return`을 설정하지 않는다.
5. `boardKey`는 프로필/문서에 예약된 키만 쓴다. 임의 키는 충돌 가능성이 있으므로 주석과 상수를 남긴다.
6. `every`는 초 단위(`1s`, `3s`)를 우선 사용한다. 컴파일러는 30 ticks/sec로 변환한다.
7. 작성 후 `python3 harness/tools/idlez_compile.py <game>`와 `python3 -m unittest harness.tools.tests.test_idlez_compile`을 돌린다.
