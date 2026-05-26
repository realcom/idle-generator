---
name: gen-triggers
description: "유닛/맵/스킬 트리거 여러 개를 한 번에 제작 (보스 페이즈 묶음, 종족 공통 AI 세트, 일괄 이벤트 핸들러). 행동 패턴이 비슷한 트리거 N개를 일관되게 양산. 단일은 gen-trigger."
argument-hint: "[게임 id] [시리즈 설명: 예: '보스 3페이즈 행동 묶음', '슬라임 가족 공통 AI 4종']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
agent: behavior-author
---

# 트리거 벌크 생성 (행동 패턴 묶음)

같은 owner 또는 같은 패턴의 트리거 N개를 **이벤트×액션 어휘**로 양산한다. 트리거는 단독 카테고리 없음 — 항상 **소속 정의(유닛/맵/스킬)에 종속**.

## 사용 시나리오
- **보스 페이즈 묶음**: 1페이즈/2페이즈/3페이즈 트리거 (동일 owner, 다른 이벤트/조건)
- **종족 공통 AI**: 슬라임 가족 4종이 공유하는 onUpdate/onDead 행동 세트
- **이벤트 핸들러 패키지**: 한 유닛의 onStart/onUpdate/onAttacked/onDead 4종 트리거 묶음
- **맵 웨이브 시리즈**: 같은 던전의 웨이브 1/2/3 스폰 트리거
- **AI 패턴 베리에이션**: 같은 베이스 AI에 공격/도주/광폭 변종

## 콘텐츠 저장 규칙

- **draft**: 소속 카테고리의 `_drafts/`에 (`units/_drafts/{owner_id}_{name}_behavior_v#.yaml` 또는 `maps/_drafts/`, `skills/_drafts/`)
- **approved**: 소속 정의가 승인될 때 함께 이동.
- **_index.yaml**: 트리거 단독 _index 없음 — 소속 유닛/맵/스킬 _index 항목의 `triggers: []`에 이름 등록.

## 항상 먼저 읽는다
- **`harness/engine-contract/action-vocabulary.md` ⭐** — 액션·이벤트·변수 정본(engine-bound). do[] 액션은 여기 있는 것만.
- `harness/engine-contract/behavior-format.md` — behavior YAML 구조, expression DSL, 네이밍
- `harness/engine-contract/reference-graph.md` — useSkill(→Skill.id), addBuff(→Buff.id)
- `harness/engine-contract/schema/unit.md` — triggers[]/initVariables 연결
- 대상 owner(유닛/맵/스킬)의 _index 및 현재 정의 파일

## 단계

1. **묶음 정의**(AskUserQuestion):
   - **소속 domain**(unit/map/skill) — 공통
   - **owner_id 패턴**: 단일 owner의 다중 이벤트 / 다수 owner의 공통 패턴
   - **이벤트 매트릭스**: start/update/attacked/dead/destroy 중 어느 것 N개
   - **인스턴스 수**
2. **트리거 표 작성**:
   - 표 (열: trigger_name·domain·owner_id·event·조건·do[] 요약·참조 skill_id/buff_id)
   - 예시:
     ```
     | name                          | domain | owner   | event     | cond              | do summary               | refs       |
     | ----------------------------- | ------ | ------- | --------- | ----------------- | ------------------------ | ---------- |
     | UNIT_ONUPDATE_SLIMEBOUNCE     | unit   | 110201  | update    | every 2s          | move random offset       | -          |
     | UNIT_ONATTACKED_SLIMESPLIT    | unit   | 110201  | attacked  | hp < 30%          | spawnUnit 110202×2       | unit:110202|
     | UNIT_ONDEAD_SLIMEDROP         | unit   | 110201  | dead      | -                | dropReward 700001        | reward:700001|
     | UNIT_ONSTART_SLIMEINTRO       | unit   | 110201  | start     | -                | playFx, addBuff 300101   | buff:300101|
     ```
3. **공통 vs 멤버별 결정**:
   - 동일 owner의 이벤트 매트릭스 → 한 behavior YAML 파일에 on[]로 묶음
   - 다른 owner들의 공통 AI → 각 owner의 _drafts에 같은 트리거 이름 작성 (또는 공유 트리거 1개 + N owner가 동일 이름 참조)
4. **작성**(behavior-author, **병렬**):
   - 단일 owner 묶음: `{domain}/_drafts/{owner_id}_{name}_behavior_v1.yaml` 안에 on[] 여러 개
   - 다중 owner 패턴: 각 owner _drafts에 동일 트리거 이름 (또는 1개 공유)
   - 액션은 `action-vocabulary.md`에 있는 것만
5. **소속 정의 연결**:
   - 각 owner의 정의 파일 _v#로 올려서 `triggers[]`에 새 트리거 이름 추가
   - 정의 파일도 _drafts 새 버전 생성 (이전 v 보존)
6. **검증**(content-reviewer):
   - do[] 액션이 어휘 내 존재
   - $var 선언, ID 참조 무결성
   - 정의 triggers[]과 일치
   - 멤버 간 이름 충돌 없음
7. **사용자 검수**: 표 + 샘플 1~2 trigger 파일 제시. 피드백이면 해당 트리거만 _v2.
8. **승인 동조**: 트리거 단독 승인 X — 소속 정의 승인 시 함께 `approved/`로.

## 원칙
- **트리거 단독 카테고리 없음** — 항상 owner(유닛/맵/스킬)에 종속.
- **action-vocabulary.md 엄격 준수** — 없는 액션은 엔진 추가 작업 플래그 (behavior로 우회 불가).
- 다중 owner 공통 AI는 동일 이름 트리거를 각자 가지게 (또는 1개 공유) — 표 단계에서 결정.
- 정의 파일도 _v# 함께 올림 (triggers[] 변경).
- 자연어는 입력일 뿐 — 커밋되는 소스는 YAML.

## 다른 스킬과의 협업
- 단일 트리거는 `/gen-trigger`
- 트리거 owner인 유닛/맵 시리즈는 먼저 `/gen-units` 또는 `/gen-maps`
- 스킬에서 RunTrigger 호출 → `/gen-skill(s)`에서 연결
- 액션 어휘에 없는 동작 필요 → 엔진 메서드 추가 요청
