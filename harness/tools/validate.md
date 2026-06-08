# Validator / Compiler (구현 진행 중)

> 🟢 **툴체인 v0.3: `tools/idlez_compile.py`** — `content/<game>/` 소스를 idlez proto-JSON으로 컴파일 + 검증.
> - **8개 타입 컴파일**: unit / item / skill / buff / map / string / achievement / audio (제네릭 엔트리 컴파일러 + 타입 스펙)
> - **`when` 조건** → Condition statement (infix→postfix RPN 파서, 연산자 > < == and/or + - * /, 사전정의 변수 level/random/damage/isCritical/return…)
> - 직렬화 쿽(json-serialization.md): int64→문자열, enum 기본값 생략, float
> - 성장식 → 스탯 value[] 배열 확장 (유닛 addStats, 장비 equipAddStats; growth-pipeline.md)
> - **behavior → Triggers.json** (call statement / postfix expression / method+parameter — 실제 idlez AST, action-vocabulary.md 시그니처)
> - 드롭/보상 $ref → AddItemGroup, 참조무결성(drop itemDataId ∈ items)
> - AddItemGroup 정규화: `addItems` 정본, `adds` legacy alias 허용. 맵 보상은 `rewardAddItemGroups` 정본, `clearAddItemGroups` legacy alias 허용.
> - 검증: 스탯 가드레일, 트리거 참조, 드롭 ID, 타입별 구조 대조, `AddUnit` 참조/geometry, unknown `runTrigger`, unknown action args, **ID 대역/중복(§6)**, **보상 weight·probPercent(§7)**
> - 실행: `python3 tools/idlez_compile.py <game> <실제 PatchResources 디렉토리>` → `build/<game>/*.json` 생성 + 6/6 구조 PASS
> - 확장 지점: when 조건/변수 로컬키, timelines/boardConstants 중첩 전용 처리, Strings/Achievements/Audios 타입.
>
> (`tools/compile_unit.py` — 초기 유닛 단독 회귀 검사. idlez_compile.py가 상위호환.)

---


콘텐츠 소스(`content/<game>/`)가 `engine-contract`(스키마·스탯·참조그래프)와 `game-profiles/<game>.profile.yaml`(가드레일)을 지키는지 검사한다. **"발산 = 버그 양산"을 막는 게이트.**

> 상태: 명세만 존재. 실제 구현(Python/Node 등)은 후속. 입력=소스 트리, 출력=위반 리포트 + (성공 시) 컴파일된 엔진 JSON.

## 검사 항목

### 1. 스키마 적합성
- 각 `*.unit.yaml`/`*.behavior.yaml`/`*.reward.yaml`이 해당 schema 카드의 필드/타입을 지키는가
- 필수 필드 존재, enum 값 유효 (`type`, `category`, `event` 등)

### 2. 참조 무결성 (reference-graph.md)
- 모든 `dataId` 참조가 실재하는가: `itemDataId`→Item, `unitDataId`→Unit, `skillDataId`→Skill, `buffDataId`→Buff, `triggers[]`→컴파일된 트리거 이름
- `$ref` (예: reward anchor)가 실제 대상에 해석되는가
- 댕글링 참조 = 에러

### 3. 스탯 가드레일 (stat-catalog.md + profile.stats)
- 콘텐츠가 쓰는 스탯이 `profile.stats.use`에 있는가 (없으면 경고/에러)
- `profile.stats.guardrails` 범위 초과 값 경고

### 4. 성장 식 (growth-pipeline.md)
- 식이 파싱되고 허용 함수만 쓰는가
- 산출 배열 길이 = `levels` 범위
- 단조성 위반 경고 (`balance.required_exp.monotonic: increasing` 위반 시)
- `bind`가 실제 정의를 매칭하는가

### 5. 행동 (behavior-format.md)
- `do[]` 액션이 액션 어휘에 존재하는가 (+ `profile.behavior.disallow_actions` 위반)
- action 인자가 해당 액션에 허용된 키인가
- `$var`가 `vars`에 선언됐는가, expression 파싱
- `name`이 `{Domain}_{Name}` 규칙 준수
- `runTrigger.name`이 정의된 trigger인가
- `AddUnit.UnitDataId`가 실재하는 Unit.id인가, `Count >= 1`인가
- `AddUnit.LocationId`가 map trigger에 쓰이면 해당 map location과 geometry가 존재하는가

### 6. ID 대역 (profile.id_ranges) — ✅ 구현됨
- 새 콘텐츠 id가 타입별 대역 안에 있는가(WARN), 타입 내 중복 없는가(ERROR)
- `reserved_ids`/`currencies` id 는 의도적 예외(예: defaultCharacter)로 대역 검사 제외

### 7. 보상/확률 검산 (reward.md) — 🟡 부분 구현
- ✅ AddItemGroup `probPercent` 0~100 범위(ERROR), `weight` 혼재 경고(WARN)·합>0(ERROR)
- ⬜ `itemDataId` 무결성은 §2 참조무결성에서 처리
- ⬜ 기대 획득률·pity 천장 시뮬 (밸런스 리포트) — `/balance-review` 스킬 영역, 미구현

### 8. UI Component Blueprint — ✅ 별도 구현
- `harness/design/<game>/component-blueprints.yaml`이 선택된 UI 시안의 의미 컴포넌트, 박스 모델, skin 계약, ornament layer, asset dependency matrix를 갖는가
- 9-slice skin의 `slice_hints`와 텍스트/아이콘 배치용 `content_insets`가 분리되어 있는가
- non-stretch-safe 테두리 장식(crest/corner/vine/badge 등)이 fixed ornament sprite layer로 추출되어 있는가
- blueprint가 참조하는 asset key가 `asset-plan.yaml`에 존재하는가
- 런타임 CSS/Phaser/Unity 값이 blueprint token mapping으로 추적 가능한가

실행:

```bash
python3 harness/tools/design_blueprint_validate.py <game>
python3 harness/tools/design_blueprint_validate.py <game> --strict
```

## 출력

```
PASS: 23 files
WARN: content/idlez/units/slime_green.unit.yaml — Attack 1레벨값 12 < profile.guardrails.Attack.min 권장?
ERROR: content/idlez/rewards/meadow_slime_drops.reward.yaml — itemDataId 200103 not found in Items
ERROR: design/ninja2/component-blueprints.yaml — rectangular skin missing content_insets_by_slot
```

위반 0이면 → 컴파일 단계(소스→엔진 proto-JSON) 진행 가능.

## 컴파일 파이프라인 (validate 통과 후)

1. `growth/*.growth.md` → 레벨 배열 → 정의에 머지
2. `*.behavior.yaml` → `Triggers.json`
3. `*.unit/item/skill/buff/map` + 머지된 배열 → `Units.json`/`Items.json`/… (proto3-JSON, camelCase)
4. (idlez) CDN 패치 채널로 배포 (`Patches/<channel>/...` 매니페스트 갱신)
