# ResourceTrigger 리뷰 노트

목표: 하네스 연동 전에 engine 트리거 VM을 사람이 읽고, AI가 안전하게 수정하고, 테스트로 보호할 수 있는 단위로 나눈다.

## 현재 구조

| 영역 | 책임 | 핵심 파일 |
| --- | --- | --- |
| AST/계약 | 트리거, 식, 변수, 메서드, 이벤트 타입 정의 | `ResourceTrigger.proto` |
| 로딩/조회 | `Triggers.json/.bytes` 로드, 이름 기반 조회, 기본 period 초기화 | `ResourceTrigger.Manager.cs`, `ResourceManager.cs` |
| VM 실행 | postfix 식 평가, assignment, call dispatch, condition/loop, cost guard | `ResourceTrigger.Logic.cs` |
| 액션 구현 | board/unit/skill/buff method 실제 동작 | `ResourceTrigger.*Method.cs` |
| 발화 지점 | map/unit/skill/buff 이벤트에서 trigger 실행 | `GameBoard.*`, `GameUnit.*`, `GameSkill.*`, `GameBuff.*` |
| 클라/서버 로드 | 클라 `LoginScene`, 서버 `Program.cs`, reload path | `engine/client`, `engine/server` |

## 기능별 리뷰

### 1. Expression 평가

- 입력은 `Expression.postfix` RPN 배열이다.
- 상수와 변수만 operand로 인정한다. 하네스 참조 런타임의 `operand.call` 확장은 엔진 proto에는 없다.
- 산술 연산은 전역 `FixedFloat` operator 의미를 그대로 따른다.
- `Equal`/`NotEqual`은 둘 다 정수면 엄밀 비교, 하나라도 비정수면 `Epsilon.Raw` 기준 근사 비교를 사용한다.
- `>`, `<`, `>=`, `<=`도 같은 근사 비교 helper를 사용한다. epsilon 안쪽 값은 동치로 보므로 `>`/`<`는 false, `>=`/`<=`는 true가 된다.
- `And`/`Or`/`Not`, `Condition`, `Loop`는 모두 같은 truthiness 규칙을 쓴다. 0과 epsilon 안에서 같으면 false, 그 밖은 true이다.

리스크:

- expression 파서/생성기가 infix를 직접 만들면 안 된다. 엔진은 최종 postfix만 실행한다.
- `FixedFloat` 자체는 Q48.16 fixed point라 큰 값 산술에서 overflow 가능성이 있다. 특히 곱셈은 raw 곱 중간값 때문에 idle-game 대형 데미지/배율 계산에서 먼저 터질 수 있다. 세부 정책은 `engine/commons/Types/FixedFloat.REVIEW.md`에 분리했다.
- epsilon 안쪽 값을 동치로 보는 부등식 정책은 콘텐츠 조건에 영향을 준다. 하네스 DSL/검증기에도 같은 규칙을 명시해야 한다.

테스트 상태:

- `Expression_evaluate_handles_postfix_arithmetic_and_comparison` 추가.
- `Expression_evaluate_handles_fractional_equality_tolerance` 추가.
- `Expression_evaluate_handles_unary_and_boolean_operators` 추가.
- `Expression_evaluate_rejects_binary_operator_without_two_operands` 추가.
- `Expression_evaluate_handles_extreme_value_comparison_without_raw_overflow` 추가.
- `Expression_evaluate_treats_values_inside_epsilon_as_equal_for_ordering` 추가.
- `Expression_evaluate_uses_epsilon_consistent_truthiness_for_logical_operators` 추가.

수정 상태:

- `Expression.Evaluate`를 operand 평가, unary/binary operator 평가, stack 적용 helper로 분리했다.
- fractional equality tolerance가 의도와 달리 raw 차이를 값 단위로 잘못 비교하던 버그를 `Epsilon.Raw` 비교로 수정했다.
- raw 차이를 `a.Raw - b.Raw`로 직접 빼면 overflow로 동치 판정이 뒤집힐 수 있어, overflow-safe raw distance helper로 교체했다.
- 비교 연산은 `CompareWithTolerance`, 논리/조건 판정은 `IsTruthy`로 모아 트리거 VM 내부 정책을 한 곳에서 읽을 수 있게 했다.

### 2. 변수 스코프

- `boardKey`: 보드 전체 변수.
- `callerKey`: 호출 주체의 persistent variables.
- `stateKey`: 트리거 실행 1회 안에서만 유지되는 state-local variables.
- `parameter`: call 인자로 쓰이며, 읽으면 제거된다.
- `predefinedVariable`: `Return`, `Random`, `Damage`, `Level` 등 state 또는 board 기반 특수 변수.
- object slot: `slotUnit`, `slotSkill`, `slotBuff`는 트리거 실행 중 receiver를 바꾸기 위한 임시 객체 포인터다.

리스크:

- `parameter`는 read-once다. 같은 parameter를 식에서 두 번 읽으면 두 번째 값은 기본값이다.
- `callerKey`와 `stateKey`의 수명 차이가 코드만 봐서는 잘 드러나지 않는다.
- object variable assignment 규칙은 복잡하고 에러 메시지가 일반적이다.
- `Damage`, `ValidDamage`, `Heal`, `Return`은 VM 안에서는 여전히 `FixedFloat`로 보인다.
  전투 본체의 `long` 값은 trigger가 `Return`을 명시적으로 설정하지 않는 경우에만 원본을 보존한다.
  trigger에서 큰 damage/heal을 읽거나 계산해 `Return`에 다시 쓰면 `FixedFloat` 범위로 clamp될 수 있다.

테스트 상태:

- `Expression_parameters_are_consumed_after_the_first_read` 추가.
- `Trigger_run_writes_board_caller_and_state_variables_in_separate_scopes` 추가.

### 3. Call dispatch

- call 실행 전에 `assignments`가 먼저 실행되어 `state` parameter에 값을 넣는다.
- `boardMethod`, `unitMethod`, `skillMethod`, `buffMethod`, `debugMethod`, `runTrigger` 중 하나로 dispatch한다.
- `unit/skill/buff` receiver가 null이면 조용히 skip한다.
- `runTrigger`는 `ResourceTrigger.Get(name)`으로 이름을 해석하고 같은 `state`를 넘겨 실행한다.

리스크:

- receiver null skip은 콘텐츠 오류를 조용히 숨길 수 있다.
- `runTrigger`가 없는 이름을 참조하면 null-forgiving 이후 런타임 예외로 터질 수 있다.
- `MethodMetadata`는 편집기 보조 정보에 가까워 런타임 검증에 거의 쓰이지 않는다.
- 일부 method는 player/unit/avatar/resource가 없을 때 crash될 수 있었다. 자연스럽게 null이 될 수 있는 조회성 method는 no-op 또는 `Return = 0`으로 방어한다.

테스트 상태:

- `Reload_initializes_default_period_and_run_trigger_resolves_by_name` 추가.
- `Unit_method_get_weapon_type_returns_zero_without_player_avatar` 추가.
- `Unit_method_get_current_hp_percent_returns_zero_when_max_hp_is_zero` 추가.
- `Board_method_get_main_player_unit_variable_returns_zero_without_main_unit` 추가.
- `Board_method_show_select_trait_is_noop_without_main_player` 추가.

수정 상태:

- `UnitMethod.GetWeaponType`은 player avatar가 없거나 weapon slot/resource가 없으면 `Return = 0`으로 종료한다.
- `UnitMethod.GetCurrentHpPercent`는 `MaxHp <= 0`이면 divide-by-zero 대신 `Return = 0`을 반환한다.
- `BoardMethod.GetMainPlayerUnitVariable`은 main player unit이 없으면 `Return = 0`을 반환한다.
- `BoardMethod.ShowSelectTrait`는 main player가 없으면 no-op 처리한다.

### 4. Statement 실행과 cost guard

- statement마다 `state.cost`를 1씩 차감한다.
- 기본 최대 cost는 `ResourceTrigger.MaxRuntimeCost = 1024`.
- `return`, `break`, `continue`는 statement 결과로 전파된다.
- 최상위 trigger가 `break/continue`로 끝나면 runtime exception이다.

리스크:

- loop 무한 실행은 cost guard로 막지만, 어떤 trigger가 비용을 얼마나 쓰는지 사전 검증은 없다.
- nested `runTrigger`도 같은 `state.cost`를 공유한다. 이는 안전하지만 문서화가 필요하다.

테스트 상태:

- `Trigger_run_stops_when_runtime_cost_is_exhausted` 추가.

### 5. 이벤트 발화

- map: `OnStart`, `OnUpdate`.
- unit: `OnStart`, `OnUpdate`, `OnAttack`, `OnAttacked`, `OnAttackedPost`, `OnHeal`, `OnHealed`, `OnBuffApply`, `OnKill`, `OnOwnerKill`, `OnDead`, `OnDestroy`.
- skill: `OnStart`, `OnUpdate`, `OnAttack`, `OnHeal`, `OnDestroy`, `OnKill`, `OnOwnerKill`, timeline `RunTrigger`.
- buff: `OnStart`, `OnUpdate`, `OnAttack`, `OnAttacked`, `OnAttackedPost`, `OnHeal`, `OnDestroy`, `OnKill`, `OnOwnerKill`, `OnBuffApply`.

현재 engine characterization:

| 영역 | 발화 시점 | caller | 기본 slot | 특이점 |
| --- | --- | --- | --- | --- |
| map `OnStart` | `GameBoard.Update()` 중 `Tick == 1`일 때 | 없음 | 없음 | 현재 첫 `board.Update()`에서는 `OnUpdate`만 실행되고, 두 번째 update에서 `OnStart`가 실행된다. |
| map `OnUpdate` | `Tick += 1` 뒤 `Tick % Period == 0` | 없음 | 없음 | period 기본값은 reload 시 15, 테스트에서는 period 1로 고정했다. |
| unit `OnStart` | unit 첫 `RunLogic`, `tick_ == 0` | `callerUnit = self` | 없음 | `CallerKey`는 unit variables를 가리킨다. |
| unit `OnUpdate` | unit `tick_ += 1` 뒤 `(tick_ + tickOffset_) % Period == 0` | `callerUnit = self` | 없음 | 첫 tick offset은 update trigger가 있으면 random으로 설정된다. |
| skill `OnStart` | skill 첫 `RunLogic`, `Tick == 0` | `callerUnit = Sender`, `callerSkill = self` | 없음 | `CallerKey`는 skill variables를 가리키며 sender unit variables가 아니다. |
| skill `OnUpdate` | skill `Tick += 1` 뒤 `(Tick - 1) % Period == 0` | `callerUnit = Sender`, `callerSkill = self` | 없음 | sender가 없으면 `callerUnit`은 null이지만 `callerSkill`은 유지된다. |
| buff `OnStart` | buff 첫 `RunLogic`, `tick_ == 0` | `callerUnit = owner`, `callerBuff = self` | `slotUnit = attacker` | attacker가 없으면 `slotUnit`은 null이다. |
| buff `OnUpdate` | buff `tick_ += 1` 뒤 `(Tick - 1) % Period == 0` | `callerUnit = owner`, `callerBuff = self` | `slotUnit = attacker` | `CallerKey`는 buff variables를 가리킨다. |
| unit `OnKill` | attacker unit이 target kill 처리 후 | `callerUnit = attacker` | `slotUnit = killed target`, `slotSkill/slotBuff = attackSource` | skill/buff kill source를 slot으로 판별한다. |
| skill `OnKill` | attackSource skill이 target kill 처리 후 | `callerUnit = Sender`, `callerSkill = source skill` | `slotUnit = killed target` | skill 자신의 variables는 `callerSkill` 또는 `CallerKey`로 접근한다. |

리스크:

- 이벤트별 `slotUnit/slotSkill/slotBuff` 의미가 파일마다 흩어져 있다.
- update period는 map은 `Tick % Period`, unit은 random `tickOffset_`, skill/buff는 `(Tick - 1) % Period`라 기준이 다르다.
- unit/skill/buff의 `CallerKey`는 `callerUnit`의 variables가 아니라 trigger owner의 persistent variables다.
  즉 skill trigger의 `CallerKey`는 skill variables, buff trigger의 `CallerKey`는 buff variables를 가리킨다.
- skill timeline의 sender-dependent action은 sender가 없을 수 있다. board-level skill이나 sender가 사라진 skill에서 이 액션 하나가 뒤 timeline 전체를 막으면 안 된다.

테스트 상태:

- `Map_update_fires_on_first_board_update_and_start_fires_on_second_board_update` 추가.
- `Unit_start_and_update_fire_during_first_unit_logic_tick` 추가.
- `Unit_start_exposes_unit_as_caller_without_default_slot_unit` 추가.
- `Skill_start_and_update_fire_during_first_skill_logic_tick` 추가.
- `Skill_start_exposes_sender_as_caller_unit_and_skill_as_caller_skill` 추가.
- `Skill_timeline_continues_after_missing_sender_dependent_action` 추가.
- `Buff_start_and_update_fire_during_first_buff_logic_tick` 추가.
- `Buff_start_exposes_owner_as_caller_unit_buff_as_caller_buff_and_attacker_as_slot_unit` 추가.
- `Unit_kill_exposes_killed_unit_as_slot_unit_and_attack_source_as_slot_skill` 추가.
- `Skill_kill_exposes_skill_as_caller_skill_and_killed_unit_as_slot_unit` 추가.
- `Unit_attacked_post_exposes_valid_damage_to_trigger` 추가.
- `Skill/Unit/Buff` attack/attacked trigger가 `Return`을 설정하지 않으면 대형 damage를 줄이지 않는지 검증한다.
- `Skill/Unit` heal/healed trigger가 `Return`을 설정하지 않으면 대형 heal을 줄이지 않는지 검증한다.
- attack/heal trigger가 `Return`을 명시하면 기존처럼 값을 override하는지 검증한다.

수정 상태:

- `GameUnit.HandleAttackedPost`가 `ValidDamage`에 `isCritical`을 넣던 버그를 `validDamage`로 수정했다.
- long damage/heal 경로는 trigger 실행 후 `Return`이 실제로 설정된 경우에만 `FixedFloat` bridge 값을 반영한다.
  관찰만 하는 trigger가 붙어도 원본 long damage/heal은 유지된다.
- `GameSkill` timeline의 `UnitUseSkill`, `AddSkill`, `OwnerUseSkill`, `SelfAddBuff`는 sender/owner가 없으면 해당 action만 skip하고 같은 tick의 나머지 timeline action을 계속 실행한다.

## 남은 정리 후보

- `BoardMethod.AddUnit`은 `locationId == 0`이면 좌표 파라미터를 쓰고, 없는 `locationId`는 no-op으로 끝난다. 남은 edge는 location은 있으나 geometry가 비어 있는 malformed content와 `unitDataId` resource 누락 검증이다.
- inventory 계열 unit method는 player/inventory가 반드시 있다는 전제가 섞여 있다. 이 영역은 player inventory 테스트 fixture가 필요해서 별도 라운드로 분리하는 편이 안전하다.
- `runTrigger`는 unknown name을 여전히 런타임 예외로 처리한다. 이건 no-op으로 바꾸기보다 사전 검증기로 잡는 편이 맞다.
- `MethodMetadata`는 아직 런타임 검증에 쓰이지 않는다. 다음 큰 정리 후보는 required parameter와 receiver domain 검증이다.

## 수정 원칙

1. generated `.cs`와 `.proto`는 계약 변경이 필요할 때만 건드린다.
2. 리팩터링 전에는 characterization test를 먼저 추가한다.
3. 서버/클라 공용 의미는 `engine/commons`에서 고정한다.
4. AI가 생성하기 쉬운 AST helper/test fixture를 먼저 만든다.
5. silent fallback은 즉시 바꾸지 말고 테스트로 고정한 뒤 검증/로그 계층을 별도로 추가한다.

## 추천 리팩터링 순서

1. 완료: 테스트 helper 정리. `ResourceTriggerTestFactory`로 AST 생성 helper를 분리했다.
2. 완료: 기본 이벤트 발화 테스트. map/unit/skill/buff `OnStart/OnUpdate`와 대표 combat event를 검증한다.
3. 완료: Expression 단위 분리. postfix evaluation을 작은 private/static helper로 정리했다.
4. 완료: trigger-local `FixedFloat` 비교 정책 정리. epsilon, 부등식, truthiness, raw overflow edge를 테스트로 고정했다.
5. 완료: long damage/heal trigger bridge의 no-return 보존 규칙을 추가했다.
6. 진행 중: Call dispatch 정리. 조회성 method의 null-safe return/no-op 정책을 일부 적용했다.
7. 다음: State/Variables 문서화. parameter read-once, caller/state/board scope 규칙을 코드 주석 또는 별도 doc으로 고정한다.
8. 다음: MethodMetadata 검증기 추가. 런타임 실행 전에 required parameter 누락, unknown trigger name, domain-method 불일치 검증을 추가한다.
9. 이후: TriggerEditor/AI 입력 포맷 정리. 엔진 AST와 저작용 DSL을 분리하고 변환기를 테스트한다.

## 현재 테스트 발판

- `Server.Tests`에서 `Server` assembly internals에 접근하도록 `InternalsVisibleTo("Server.Tests")`를 추가했다.
- `TestResourceScope`가 trigger/unit/skill/buff resource를 로드/리셋할 수 있게 확장됐다.
- `ResourceTriggerTestFactory`에 AST 생성 helper를 분리했다.
- `ResourceTriggerTests`에 VM/dispatch 핵심 동작 15개를 추가했다.
- `ResourceTriggerEventTests`에 이벤트 발화/전투 훅 동작을 추가했다.
