# Action Vocabulary (engine-contract · ⚠ ENGINE-BOUND)

> **이 문서는 idlez 엔진 런타임 API의 미러다.** 트리거/행동(behavior)이 컴파일되어 호출하는 실제 메서드·이벤트·변수 목록.
> 손으로 발명한 게 아니라 **idlez 코드에서 추출**했다 — 출처: `Commons/Resources/ResourceTrigger.{Unit,Skill,Buff,Board}Method.cs`, `ResourceTrigger.proto`. 엔진이 메서드를 추가/변경하면 이 문서도 재추출해 갱신해야 한다(엔진 버전 고정).
> portable 레이어(스탯·데이터·성장)와 달리 **여기 있는 건 idlez 종속**이다. 다른 엔진으로 가면 전부 다시 정의해야 한다.

추출 시점: 2026-05-26 (`engine/commons`).
실행 의미 보강: [`trigger-runtime-semantics.md`](./trigger-runtime-semantics.md).

---

## 이벤트 (trigger event type)

`ResourceTrigger.proto` enum. 트리거 하나당 이벤트 1개. `OnUpdate`는 `period`(주기) 지정.

| 이벤트 | 적용 도메인 | behavior `event` 토큰 |
| --- | --- | --- |
| `OnStart` | Board, Unit, Skill, Buff | `start` |
| `OnUpdate` | Board, Unit, Skill, Buff | `update` (+ `every`) |
| `OnAttack` | Unit, Skill, Buff | `attack` |
| `OnAttacked` | Unit, Buff | `attacked` |
| `OnAttackedPost` | Unit, Buff | `attacked_post` |
| `OnHeal` | Unit, Skill, Buff | `heal` |
| `OnHealed` | Unit | `healed` |
| `OnBuffApply` | Unit, Buff | `buff_apply` |
| `OnKill` | Unit, Skill, Buff | `kill` |
| `OnOwnerKill` | Unit, Skill, Buff | `owner_kill` |
| `OnDead` | Unit | `dead` |
| `OnDestroy` | Unit, Skill, Buff | `destroy` |

---

## unitMethod (유닛 대상 액션) — `UnitMethod.Types.Type`

**이동/방향**: `SetDirection` · `SetMoveDirection` · `SetMoveDestination` · `SetMoveRandomDestination` · `LookAt` · `LookAtTarget` · `RunawayFromTarget` · `TeleportToPosition` · `Stop`

**스킬**: `UseSkill` · `UseSkillToTarget` · `IsUsingSkill` · `IsUsingSkillBySkillDataId` · `GetSkillCooldown`

**버프**: `AddBuff` · `RemoveBuff` · `GetBuffByDataId` · `IsBuffApplied`

**재화/성장**: `IncreaseGold` · `IncreaseExp` · `IncreaseLevel` · `GetGoldCount` · `GetLevel` · `GetKillCount` · `GetCurrentHpPercent`

**인벤토리/아이템**: `AcquireItem` · `AddInventoryItem2` · `AddInventoryItemByItemDataId` · `ChangeRandomInventoryItem` · `RemoveRandomInventoryItem` · `HasDuplicateInventoryItem` · `GetInventoryEmptySlotCount` · `GetInventoryItemCountByTag` · `GetWeaponType`

**특성/기타**: `IncreaseRerollLevelUpSelectTrait` · `PlayFxEvent` · `SetRespawnDelay` · `Suicide`

## skillMethod — `SkillMethod.Types.Type`
`GetSkillCooldown` · `ReduceSkillCooldownByPercent` · `ReduceSkillCooldownBySeconds`

## buffMethod — `BuffMethod.Types.Type`
`AddBuffToOwner` · `AddBuffToSender` · `IncreaseStack`

## boardMethod (보드/맵 전역 액션) — `BoardMethod.Types.Type`

**유닛 스폰/제어**: `AddUnit` · `GetUnitByDataId` · `GetMainPlayerUnit` · `GetMainPlayerUnitVariable` · `GetUnitCount` · `GetUnitCountByOffset` · `GetUnitCountByTeam` · `KillAllUnits` · `KillAllNormalUnits` · `KillUnitsByDataId` · `UseSkill`

**웨이브/맵**: `SendWaveQueuedEvent` · `SendWaveStartedEvent` · `SendResetMapScrollEvent` · `MoveBoard` · `SetNavigability` · `EndGame`

**타이머**: `AddTimer` · `StartTimer` · `StopTimer` · `PauseTimer` · `ResumeTimer`

**액션 봉인**: `BlockMoveAction` · `UnBlockMoveAction` · `BlockSkillAction` · `UnBlockSkillAction`

**선택지/UI**: `ShowPopup` · `ShowSelectTrait` · `StartLevelUpSelectTrait` · `StartWaveEndSelectTrait` · `ToastMessage`

**상태/업적/랜덤**: `GetBoardState` · `SetBoardState` · `GetAchievementProgress` · `GetAchievementState` · `IncreaseAchievementProgress` · `IsAchievementCompleted` · `IsAchievementRewarded` · `RandomBetween` · `RandomIntBetween`

### `AddUnit` authoring contract

`AddUnit`은 map trigger 전용이 아니다. 어떤 domain trigger에서도 `boardMethod:AddUnit`으로 컴파일되면 board에 스폰을 큐잉할 수 있다.

| parameter | 의미 |
| --- | --- |
| `UnitDataId` | 필수. 스폰할 `ResourceUnit.id` |
| `Count` | 선택, 기본 1. 하네스에서는 1 이상이어야 한다 |
| `Team` | 선택, 기본 enemy |
| `LocationId` | 선택. 0/누락이면 `PositionX/Y` 좌표 스폰 |
| `PositionX`, `PositionY` | `LocationId == 0`일 때 사용 |
| `Angle` | 선택. 누락 시 random direction |
| `Offset` | 선택. count-by-offset 등에 쓰이는 분류값 |

런타임: 없는 `LocationId`는 no-op이지만, location이 있고 `geometries`가 비어 있으면 예외 가능.
하네스 검증기는 `UnitDataId`, `Count`, map location geometry, unknown `runTrigger`를 error로 잡는다.

---

## 사전정의 변수 (expression DSL 컨텍스트) — `PredefinedVariable`

**공통/반환**: `Return` · `Random` · `Level` · `Damage` · `ValidDamage` · `IsCritical`

**유닛 컨텍스트**: `Caller` · `DataId` · `PositionX/Y` · `DirectionX/Y` · `VelocityX/Y` · `HasMoveDirection` · `MoveDirectionX/Y` · `HasMoveDestination` · `MoveDestinationX/Y`

**보드 컨텍스트**: `Tick` · `Timer` · `MapType` · `SpawnItemCount`

**선택지/상호작용**: `selectTraitUnitDataId` · `selectTraitShouldAddAll` · `selectTraitType` · `PlayerInteraction1..5`

---

## behavior 작성 시 규칙 (behavior-format.md와 함께)

- `do[]`의 액션 키는 위 메서드(domain별)에 **존재하는 것만**. 검증기(content-reviewer)가 미등록 액션을 ERROR로 잡는다.
- `domain`은 owner/event/caller를 정하고, 실제 method receiver는 action alias가 정한다. 예: unit behavior의 `AddUnit`은 `boardMethod:AddUnit`이다.
- 하네스 compiler는 owner 대상 `unitMethod`/`skillMethod`/`buffMethod` alias에 `call.caller = true`를 자동으로 붙인다.
- `$var` / expression은 사전정의 변수 + 트리거 `vars` 참조.
- 어휘에 없는 동작이 필요하면 = **엔진에 메서드 추가가 필요**하다는 뜻. behavior로 우회하지 말고 "엔진 작업 필요"로 플래그(엔진-종속 경계).
- damage/heal trigger에서 대형 값을 관찰만 할 때는 `Return`을 설정하지 않는다. `Return`을 쓰면 engine VM의 `FixedFloat` 채널을 통해 값이 clamp될 수 있다.
