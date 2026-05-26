# Behavior Format (engine-contract)

> 결정: 런타임 트리거 엔진은 **유지**, Blockly/`.ws` 프론트엔드만 **AI-friendly 텍스트로 교체**.
> 소스 = 선언형 YAML + 작은 expression DSL. 자연어는 *입력*으로만(AI가 YAML로 변환). 산출 = 엔진 `Triggers.json`.
> 런타임 의미의 정본은 [`trigger-runtime-semantics.md`](./trigger-runtime-semantics.md)와 [`action-vocabulary.md`](./action-vocabulary.md)다.

## 왜 이 형태

idlez의 행동 로직은 `Resource{Unit,Skill,Buff,Map}`의 `triggers : repeated string`가 **트리거 이름**으로 물어오고, 트리거는 **이벤트 × 액션 어휘**로 실행된다. 실제 `.ws`(Blockly 직렬화) 한 조각:

```json
{ "fields": { "NAME": "unitMethod:IncreaseGold", "THIS": true },
  "metadata": { "name": "Skill_IncreaseGold_Update", "period": "30", "triggerType": "1" } }
```

여기서 변하지 않는 **의미 코어**는 ① 트리거 이름 규칙, ② 이벤트(`triggerType`/`period`), ③ 액션 어휘(`unitMethod:*` 등), ④ 변수다. Blockly의 난잡한 직렬화는 *문법*일 뿐 → AI·기획자가 읽기 쉬운 YAML로 교체한다.

> ⚠ 실측(2026-05-21): **트리거 이름은 자유 문자열이고, idlez는 한 가지로 통일돼 있지 않다(혼합).**
> - UPPER_SNAKE `{DOMAIN}_ON{EVENT}_{NAME}` — 예: `UNIT_ONUPDATE_MYPLAYER`, `UNIT_ONDEAD_MYPLAYER` (Units.json 참조).
> - PascalCase `{Domain}_{Name}_{Event}` — 예: `Skill_IncreaseGold_Update`, `Map_Default3_Wave3` (.ws 파일).
>
> 엔진이 강제하는 건 "정의의 `triggers[]` 문자열이 정의된 트리거 이름과 **정확히 일치**"하는 것뿐. 그래서 우리 하네스는 **한 가지 컨벤션을 택해 일관되게 생성**하고(아래에선 `{DOMAIN}_ON{EVENT}_{NAME}` 채택), 정의의 `triggers[]`가 그 컴파일된 이름을 가리키게 한다. 이벤트 집합은 Start/Update/Destroy/Kill보다 넓다(ONSTART/ONUPDATE/ONDEAD/ONATTACKED/ONATTACKEDPOST/ONDESTROY).

## 소스 포맷 (`content/<game>/<domain>/*.behavior.yaml`)

```yaml
# increase_gold.behavior.yaml
name: IncreaseGold              # 도메인+이름. 컴파일: SKILL_ON{EVENT}_INCREASEGOLD
domain: skill                  # skill | buff | unit | map
vars:
  count: { type: int, default: 1, comment: "Gold Count" }   # 트리거 변수(InitVariable)
on:
  - event: update               # start | update | dead | attacked | attacked_post | destroy
    every: 30s                  # update 전용 주기 (= .ws period). 생략 시 매 틱
    do:
      - increaseGold: { amount: $count }
```

> ⚠ YAML 함정: `on:` 키는 YAML 1.1에서 boolean `True`로 파싱된다. 컴파일러(`tools/idlez_compile.py`)는 이를 자동 처리하지만, 손으로 다른 도구로 로드할 땐 `"on":`로 따옴표 처리하거나 인지할 것.

규칙:
- `name`은 도메인+이름. 이벤트는 `on[].event`. **컴파일 시 하네스 채택 컨벤션 `{DOMAIN}_ON{EVENT}_{NAME}`으로 트리거 이름 생성** — 예: domain=skill, name=IncreaseGold, event=update → `SKILL_ONUPDATE_INCREASEGOLD`. (트리거 이름은 자유 문자열 — 위 ⚠ 참조. 일관성을 위해 한 컨벤션을 고정.)
- `$var`는 `vars`에 선언한 트리거 변수 참조다. 현재 컴파일러는 `$var`를 기본값 상수로 풀어 engine AST에 넣는다.
- 한 파일에 여러 이벤트(`on[]`)를 둘 수 있다. 각 이벤트는 별도 트리거로 컴파일.
- 정의(unit/skill/buff/map)의 `triggers[]`에는 이 **컴파일된 이름**을 정확히 일치시켜 넣는다.

## 이벤트 모델

| event | 컴파일 토큰 | 의미 | 부가 |
| --- | --- | --- | --- |
| `start` | `ONSTART` | 부착/스폰 시 1회 | board/unit/skill/buff |
| `update` | `ONUPDATE` | 주기 실행 | board/unit/skill/buff, `every: <시간>` |
| `attack` | `ONATTACK` | 공격/타격 source 훅 | unit/skill/buff |
| `attacked` | `ONATTACKED` | 피격 전/중 처리 | unit/buff |
| `attacked_post` | `ONATTACKEDPOST` | 피격 후처리 | unit/buff |
| `heal` | `ONHEAL` | 회복 source 훅 | unit/skill/buff |
| `healed` | `ONHEALED` | 회복받은 unit 훅 | unit |
| `buff_apply` | `ONBUFFAPPLY` | 버프 적용 시 | unit/buff |
| `kill` | `ONKILL` | 처치 source 훅 | unit/skill/buff |
| `owner_kill` | `ONOWNERKILL` | owner가 처치했을 때 | unit/skill/buff |
| `dead` | `ONDEAD` | 사망 시 | unit |
| `destroy` | `ONDESTROY` | 소멸/해제 시 | unit/skill/buff |

> idlez 실측 이벤트 토큰. 엔진의 `triggerType` 정수에도 매핑된다. 매핑표(이벤트→토큰/정수)는 컴파일러가 보유하며, 정본은 idlez 트리거 데이터에서 추출해 확정한다. (게임 프로필에서 오버라이드 가능.)

## 액션 어휘 (action vocabulary)

소스의 `do[]` 액션은 엔진 메서드(`unitMethod:` / `skillMethod:` / `buffMethod:` / `boardMethod:`)로 컴파일된다. **이 어휘는 엔진이 제공하는 닫힌 집합**이며, 검증기가 미등록 액션을 잡는다.

> ✅ **정본은 [`action-vocabulary.md`](./action-vocabulary.md)** (idlez `ResourceTrigger.*Method.cs`·`ResourceTrigger.proto`에서 추출, 🔴 engine-bound). 이벤트 12종 + unitMethod ~38 + boardMethod ~39 + skill/buffMethod + 사전정의 변수 전체가 거기 있다. 여기선 개념만; 실제 작성·검증은 그 문서를 참조.

`domain`은 trigger owner와 이름 prefix를 정한다. method receiver는 action alias가 정한다.
예를 들어 `domain: unit`에서도 `AddUnit`은 `boardMethod:AddUnit`으로 컴파일되어 스폰을 수행할 수 있다.
`unitMethod`/`skillMethod`/`buffMethod` alias는 owner domain에 맞춰 `call.caller = true`를 자동으로 붙인다.
caller/slot과 no-op 규칙은 [`trigger-runtime-semantics.md`](./trigger-runtime-semantics.md)의 "이벤트와 caller/slot"을 따른다.
타임라인 액션(Hit/Charge/Knockback/PlayFx/RunTrigger/Destroy 등)은 `schema/skill.md`의 Timeline 참조.

## Expression DSL (조건·수식)

현재 컴파일러의 expression DSL은 의도적으로 작다.
`$count * 2`, `level >= 10`, `return == 0`, `board.GetBoardState() == 2001` 같은 식을 engine postfix expression으로 바꾼다.

지원:
- 산술 `+ - * / %`
- 비교 `== != < <= > >=`
- 논리 `and/or`, `&&/||`
- `$vars` 기본값 상수
- predefined: `level`, `random`, `damage`, `validDamage`, `isCritical`, `return`, `tick`, `timer`
- 예약 board key alias: `wave`, `waveTransitionPending`
- 제한된 method expression: `board.GetBoardState()`, `board.GetUnitCountByTeam(team)` 등 compiler에 등록된 method call

미지원:
- `target.hp`, `caller.attack` 같은 dotted property
- `min/max/clamp/floor/ceil/round` 함수
- trigger 안 대형 long 산술 보존

조건부 액션:

```yaml
do:
  - when: "$count > 5"
    increaseGold: { amount: "$count * 10" }
```

## 컴파일 산출물

`*.behavior.yaml` → `Triggers.json`의 한 트리거 항목(`name`, `type`, `period`, `statements`). 정의(`Unit/Skill/Buff/Map`)는 `triggers[]`에 이 `name`을 넣어 물어온다. **런타임은 기존 그대로** — 새 포맷은 컴파일러만 추가한다.

## 자연어 입력 (NL은 소스가 아니다)

기획자가 "30초마다 골드 1 더 줘" 라고 말하면 AI가 위 YAML로 변환한다. **커밋되는 소스는 YAML**(diff·리뷰·재현 가능). 자연어는 작성 보조일 뿐, 진실의 원본이 아니다.

## 검증 (tools/validate)

- `do[]`의 모든 액션이 액션 어휘에 존재하는가
- `$var`가 `vars`에 선언됐는가, expression이 파싱되는가
- `name` 규칙 `{Domain}_{Name}` 준수, 정의의 `triggers[]`가 실제 컴파일된 트리거를 가리키는가
- `addBuff.buffDataId` / `useSkill.skillDataId` 등 ID 참조 무결성
- `AddUnit.UnitDataId`가 정의된 Unit인지, `Count`가 1 이상인지
- `AddUnit.LocationId`가 map trigger에 쓰이면 해당 map location과 geometry가 존재하는지
- `runTrigger.name`이 정의된 trigger인지
