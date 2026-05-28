# Trigger Feature Guide

> `*.behavior.yaml`을 작성하는 AI/사람용 기능 가이드.
> 이 문서는 "지금 하네스가 안전하게 지원하는 것"만 적는다.
> 상세 계약은 `behavior-format.md`, `action-vocabulary.md`, `trigger-runtime-semantics.md`가 정본이다.

## 한눈에 보는 흐름

```text
자연어 요청
  -> AI가 behavior YAML 작성
  -> harness/tools/idlez_compile.py
  -> Triggers.json
  -> idlez ResourceTrigger VM 실행
```

커밋되는 원본은 자연어가 아니라 `harness/content/<game>/<domain>/*.behavior.yaml`이다.

## 파일 구조

| 대상 | behavior 위치 | owner 정의 연결 |
| --- | --- | --- |
| 유닛 AI | `content/<game>/units/*.behavior.yaml` | `*.unit.yaml`의 `triggers[]` |
| 맵 웨이브 | `content/<game>/maps/*.behavior.yaml` | `*.map.yaml`의 `triggers[]` |
| 스킬 보조 로직 | `content/<game>/skills/*.behavior.yaml` | `*.skill.yaml`의 `triggers[]` |
| 버프 보조 로직 | `content/<game>/buffs/*.behavior.yaml` | `*.buff.yaml`의 `triggers[]` |

트리거 이름은 컴파일러가 `{DOMAIN}_ON{EVENT}_{NAME}` 대문자 형태로 만든다.
예: `domain: unit`, `name: SporelingAttack`, `event: update` -> `UNIT_ONUPDATE_SPORELINGATTACK`.

## 기본 형태

```yaml
name: SporelingAttack
domain: unit

"on":
  - event: update
    every: 2s
    do:
      - useSkillToTarget:
          skillDataId: 300101
```

`on:`은 YAML 1.1에서 boolean으로 해석될 수 있으므로 새 파일은 `"on":`로 쓰는 편이 안전하다.

## 지원 이벤트

| event | 엔진 이벤트 | owner |
| --- | --- | --- |
| `start` | `OnStart` | map/unit/skill/buff |
| `update` | `OnUpdate` | map/unit/skill/buff |
| `attack` | `OnAttack` | unit/skill/buff |
| `attacked` | `OnAttacked` | unit/buff |
| `attacked_post` | `OnAttackedPost` | unit/buff |
| `heal` | `OnHeal` | unit/skill/buff |
| `healed` | `OnHealed` | unit |
| `buff_apply` | `OnBuffApply` | unit/buff |
| `kill` | `OnKill` | unit/skill/buff |
| `owner_kill` | `OnOwnerKill` | unit/skill/buff |
| `dead` | `OnDead` | unit |
| `destroy` | `OnDestroy` | unit/skill/buff |

`update.every`는 30 ticks/sec로 변환된다. `1s`는 30, `3s`는 90이다.

## 지원 액션

현재 behavior compiler가 직접 지원하는 액션이다. 여기에 없는 액션은 추가 구현 전까지 쓰지 않는다.

### Unit 액션

| action | 인자 | 엔진 method | 메모 |
| --- | --- | --- | --- |
| `increaseGold` | `amount` | `unitMethod.IncreaseGold` | owner/caller unit 대상 |
| `increaseExp` | `amount` | `unitMethod.IncreaseExp` | owner/caller unit 대상 |
| `addBuff` | `buffDataId`, `level`, `duration` | `unitMethod.AddBuff` | owner/caller unit 대상 |
| `useSkill` | `skillDataId` | `unitMethod.UseSkill` | owner/caller unit 대상 |
| `useSkillToTarget` | `skillDataId` | `unitMethod.UseSkillToTarget` | target이 있어야 실제 발동 |
| `moveTo` | `x`, `y` | `unitMethod.SetMoveDestination` | owner/caller unit 대상 |
| `SetMoveDestination` | `x`, `y` | `unitMethod.SetMoveDestination` | `moveTo`와 동일 |
| `moveRandom` | `x`, `y`, `xRange`, `yRange` | `unitMethod.SetMoveRandomDestination` | 인자 생략 가능 |
| `stop` | 없음 | `unitMethod.Stop` | owner/caller unit 대상 |

컴파일러는 `domain: unit/skill/buff`의 owner 대상 method에 `call.caller = true`를 자동으로 붙인다.

### Board / Map 액션

| action | 인자 | 엔진 method | 메모 |
| --- | --- | --- | --- |
| `AddUnit` | `unitDataId`, `count`, `team`, `locationId`, `positionX`, `positionY`, `angle`, `offset` | `boardMethod.AddUnit` | 권장 스폰 액션 |
| `spawnUnit` | `unitDataId`, `count` | `boardMethod.AddUnit` | legacy 최소 alias. 위치/팀이 필요하면 `AddUnit` 사용 |
| `GetUnitCountByTeam` | `team` | `boardMethod.GetUnitCountByTeam` | 결과는 `return` |
| `GetBoardState` | 없음 | `boardMethod.GetBoardState` | 결과는 `return` |
| `SetBoardState` | `value` | `boardMethod.SetBoardState` | `Playing` 같은 alias 지원 |
| `SetWave` | `value` | `boardKey 601` assignment | 하네스 예약 wave key |
| `SetBoardVariable` | `key`, `value` | boardKey assignment | 임의 key는 충돌 주의 |
| `SendWaveStartedEvent` | 없음 | `boardMethod.SendWaveStartedEvent` | 클라 이벤트 |
| `SendWaveQueuedEvent` | `name` | `boardMethod.SendWaveQueuedEvent` + `runTrigger` | 다음 wave trigger 실행 |
| `EndGame` | `result` | `boardMethod.EndGame` | `win`/`lose` alias 지원 |

`team` alias: `enemy`, `normal` -> 4, `boss` -> 6, `player` -> 1.
`SetBoardState.value` alias: `Playing` -> 2001.

## AddUnit 작성 규칙

```yaml
- AddUnit:
    unitDataId: 110201
    count: 5
    team: enemy
    locationId: 1
```

검증기가 잡는 것:

- `unitDataId` 누락
- 상수 `unitDataId`가 `Units`에 없음
- 상수 `count <= 0`
- map trigger에 연결된 `locationId`가 map `locations[]`에 없음
- location은 있으나 `geometries[]`가 없음

엔진 의미:

- `locationId`가 없거나 0이면 `positionX/positionY` 좌표로 스폰한다.
- 없는 `locationId`는 엔진에서 no-op이지만, 하네스에서는 작성 실수로 보고 error 처리한다.
- location에 geometry가 없으면 런타임 예외가 날 수 있다.

## 조건식

지원 예:

```yaml
- GetUnitCountByTeam: { team: enemy }
- when: "waveTransitionPending == 0 and wave == 1 and return == 0"
  SetWave: { value: 2 }
  SendWaveQueuedEvent: { name: MAP_ONSTART_MUSHROOMFIELDWAVE2 }
```

지원:

- 산술: `+ - * / %`
- 비교: `== != < <= > >=`
- 논리: `and`, `or`, `&&`, `||`
- predefined: `level`, `random`, `damage`, `validDamage`, `isCritical`, `return`, `tick`, `timer`
- board key alias: `wave`, `waveTransitionPending`, `waveSpawned`
- caller unit variable alias: `hasTarget`, `targetDistance`, `targetPositionX`, `targetPositionY`, `positionX`, `positionY`, `hp`, `maxHp`, `hpRatio`
- 제한된 method expression: `board.GetBoardState()`, `board.GetUnitCountByTeam(team)` 등

미지원:

- `target.hp`, `caller.attack` 같은 property 접근
- `min/max/clamp/floor/ceil/round` 함수
- 대형 long damage/heal을 trigger expression 안에서 온전히 보존하는 산술

## Damage / Heal 주의

damage/heal 본체는 엔진에서 long-safe로 보강되어 있다.
하지만 trigger VM의 `Damage`, `ValidDamage`, `Heal`, `Return`은 `FixedFloat` 채널을 통과한다.

규칙:

- 대형 damage/heal을 관찰만 하면 `Return`을 쓰지 않는다.
- `Return`을 설정하면 그 값이 실제 damage/heal override가 된다.
- `Return`으로 대형 값을 되돌리면 clamp될 수 있다.
- `AddDamage`/`AddHeal`의 `Percent` 필드명은 단위가 섞여 있으므로 `trigger-runtime-semantics.md`의 변환표를 따른다.

## 대표 패턴

### 맵 웨이브 스폰

```yaml
name: MushroomFieldWave1
domain: map

vars:
  enemy_unit: { type: int, default: 110201 }
  enemy_spawn: { type: int, default: 1 }

"on":
  - event: start
    do:
      - SetBoardState: { value: Playing }
      - SetWave: { value: 1 }
      - SendWaveStartedEvent: {}
      - AddUnit:
          unitDataId: $enemy_unit
          count: 5
          team: enemy
          locationId: $enemy_spawn
```

### 유닛 자동 공격

```yaml
name: SporelingAttack
domain: unit

"on":
  - event: update
    every: 2s
    do:
      - useSkillToTarget:
          skillDataId: 300101
```

### 주기 보상 스킬

```yaml
name: IncreaseGold
domain: skill

vars:
  count: { type: int, default: 1 }

"on":
  - event: update
    every: 30s
    do:
      - increaseGold: { amount: $count }
```

## 검증 명령

```bash
python3 harness/tools/idlez_compile.py idlez
python3 harness/tools/idlez_compile.py mushroomer
python3 -m unittest harness.tools.tests.test_idlez_compile
```

검증 통과 기준은 `harness/tools/validate.md`에 정리되어 있다.

## 아직 제한된 영역

- raw `ResourceTrigger` AST 직접 작성은 권장하지 않는다.
- inventory 계열 unit method는 player/inventory fixture 전제가 있어 별도 검증이 더 필요하다.
- `MethodMetadata` 기반 required parameter 검증은 아직 확장 후보로 남아 있다.
- 새로운 액션이 필요하면 `action-vocabulary.md`에 있는 엔진 method인지 먼저 확인하고, compiler alias와 테스트를 같이 추가한다.
