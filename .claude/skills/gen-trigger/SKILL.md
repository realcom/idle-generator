---
name: gen-trigger
description: "AI 유닛 트리거(행동 로직)를 제작 — 유닛/몬스터/보스의 이벤트 기반 행동을 behavior YAML로 작성해 Triggers로 컴파일. '몬스터 AI', '유닛 행동', '스폰/사망 시 동작' 만들 때 사용."
argument-hint: "[게임 id] [유닛/트리거 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
agent: behavior-author
---

# AI 유닛 트리거 제작

유닛의 이벤트 기반 행동(AI/로직)을 behavior YAML로 작성한다. Blockly/.ws 대체. 인자 없으면 사용법 출력 후 정지.

## 콘텐츠 저장 규칙 (필수)

산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.

- **파일명**: `{id}_{name}.behavior.yaml`
- **draft**: behavior YAML은 소속 카테고리의 `_drafts/`에. (유닛 행동 → `units/_drafts/`, 맵 웨이브 → `maps/_drafts/`, 스킬 보조 로직 → `skills/_drafts/`)
- **approved**: 대상 정의가 승인될 때 함께 `approved/`로 이동.
- **_index.yaml**: 트리거 단독 카테고리는 없음 — 소속 유닛/맵/스킬의 _index 항목에 `triggers: [이름]`이 명시되면 추적됨.

## 항상 먼저 읽는다
- `harness/engine-contract/action-vocabulary.md` — ★ 액션·이벤트·변수 **정본**(idlez 추출, 🔴 engine-bound). do[] 액션은 여기 있는 것만.
- `harness/engine-contract/behavior-format.md` — behavior YAML 구조, expression DSL, 트리거 네이밍(자유 문자열·혼합; 하네스는 `{DOMAIN}_ON{EVENT}_{NAME}` 채택)
- `harness/engine-contract/reference-graph.md` — useSkill(→Skill.id), addBuff(→Buff.id) 참조 무결성
- `harness/engine-contract/schema/unit.md` — 유닛의 triggers[]/initVariables 연결
- `harness/pipeline/content-organization.md` — 저장 레이아웃
- 대상 유닛/맵/스킬의 `_index.yaml` 및 해당 draft/approved 파일

## 단계
1. **결정**(AskUserQuestion): 어떤 유닛/맵/스킬({id} 기준), 이벤트(스폰=start/주기=update/피격=attacked/사망=dead/소멸=destroy), 동작(이동 패턴·스킬 사용·버프·스폰·연출), 주기(every), 조건.
2. **작성**(Task behavior-author): `harness/content/<game>/<domain>/_drafts/{owner_id}_{name}_behavior_v1.yaml` — name+domain, vars, on[](event×do[]). 액션은 어휘에 있는 것만.
   - 예: 유닛 110201의 슬라임 점프 → `units/_drafts/110201_초록슬라임_behavior_v1.yaml`
3. **연결**: 컴파일된 트리거 이름(예 `UNIT_ONUPDATE_SLIMEBOUNCE`)을 해당 정의 파일의 `triggers[]`에 추가. 정의 파일도 `_v#`을 올린다.
4. **검증**(Task content-reviewer): do[] 액션이 어휘에 존재, $var 선언, ID 참조 무결성, 정의 triggers[] 일치.
5. **승인 동조**: 트리거는 단독 승인하지 않고, 소속 정의가 `approved/`로 이동할 때 함께 이동.

## 주의
- 액션 어휘 정본은 `action-vocabulary.md`(engine-bound). 거기 없는 동작 요청 시 "엔진 메서드 추가 필요(ResourceTrigger.*Method.cs)"로 플래그하고 대안 제시 — behavior로 우회 불가.
- 자연어는 입력일 뿐 — 커밋되는 소스는 YAML(diff·리뷰 가능).
- 런타임 트리거 엔진은 변경하지 않는다(프론트엔드만).
- AI는 `_drafts/`에만 쓴다.
