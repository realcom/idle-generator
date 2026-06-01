---
name: new-content
description: "신규 콘텐츠 제작 일반 진입점. 자연어 요청을 받아 필요한 콘텐츠 타입(아이템·스탯·유닛·맵·스킬·트리거)을 판별해 직접 만들거나 전용 스킬로 라우팅하고, 기획→생성→바인딩→검증을 오케스트레이션."
argument-hint: "[게임 id] [만들 콘텐츠 자연어 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 신규 콘텐츠 제작 (일반 진입점 / 오케스트레이터)

`harness/pipeline/README.md`의 7단계를 끝까지 진행한다. 한 요청에 여러 타입이 섞여도 처리(발산). 인자 없으면 사용법 출력 후 정지.

## 콘텐츠 저장 규칙 (필수)

**모든 산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.**

- **파일명**: `{id}_{name}.yaml`
- **draft**: `harness/content/<game>/<category>/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/<category>/approved/{id}_{name}.yaml`
- **_index.yaml**: 카테고리(`units/items/skills/maps/buffs/rewards`)별로 한 개. AI 생성마다 행 추가/갱신.
- AI는 `_drafts/`에만 쓴다. `approved/`로의 이동은 사용자 승인 액션.

## Phase 0: 컨텍스트 로드
`harness/game-profiles/<game>.profile.yaml`, `harness/engine-contract/`(schema·reference-graph·stat-catalog·growth·behavior·json-serialization), `harness/pipeline/content-organization.md`, 각 카테고리의 `harness/content/<game>/<category>/_index.yaml`.

## Phase 1: 타입 판별 + 기획(Spec)
요청을 콘텐츠 타입으로 분해하고 `AskUserQuestion`으로 핵심 결정 확정. 타입별 처리:

**먼저 단일 vs 벌크 판별** — 요청에 "시리즈/세트/패키지/티어/4속성/N개/챕터/일일N종" 같은 키워드가 있거나 N≥2개 같은 카테고리 일괄 생성이면 **복수형 스킬**로 위임.

### A. 콘텐츠 대분류

| 대분류 | 단일 (1개) | 벌크 (N개, 시리즈/패밀리) |
| --- | --- | --- |
| **아이템** ⓘ Category 다양 — 아래 B 표 참조 | `/gen-item` (라우터) | `/gen-items` (벌크 라우터) |
| **유닛** | `/gen-unit` | `/gen-units` (생태계/티어/속성 패밀리) |
| **맵 / 던전** | `/gen-map` | `/gen-maps` (챕터/시즌/랭크 시리즈) |
| **스킬** (ResourceSkill) | `/gen-skill` | `/gen-skills` (티어/속성/직업/연계) |
| **유닛 트리거(AI/행동)** | `/gen-trigger` | `/gen-triggers` (보스 페이즈 묶음, 종족 공통 AI) |
| **업적** | `/gen-achievement` | `/gen-achievements` (일일 미션, 누적 단계 트리, 부모-자식) |
| **버프 / 보상(단독)** | 여기서 직접 (Task content-designer + economy-balancer) — `buffs/_drafts/` 또는 `rewards/_drafts/`에 `{id}_{name}_v1.yaml` | — (시리즈 보상은 해당 시리즈 스킬이 일괄 처리) |

### B. 아이템 Category 세분 (라우터를 거치지 않고 직접 호출 가능)

아이템 카테고리가 명확하면 `/gen-item` 라우터를 건너뛰고 바로 호출:

| Category | 단일 | 벌크 |
| --- | --- | --- |
| Weapon (무기 — 검/총/단검/해머) | `/gen-weapon` | `/gen-weapons` |
| Equipment (장비 — 머리/가슴/링…) | `/gen-equipment` | `/gen-equipments` |
| Material (재료) ★자주 양산 | `/gen-material` | `/gen-materials` |
| Pet (펫 — Unit 페어) | `/gen-pet` | `/gen-pets` |
| Mine (광맥 — 방치형 핵심) | `/gen-mine` | `/gen-mines` |
| Product/IAP (일반 결제) | `/gen-iap` | `/gen-iaps` |
| Product/GamePass (시즌 패스) | `/gen-gamepass` | — |
| Product/Attendance (출석 보상) | `/gen-attendance` | — |
| Product/Ticket (티켓) | `/gen-ticket` | `/gen-tickets` |
| Product/Boost (시간제 부스터) | `/gen-boost` | `/gen-boosts` |
| Product/Utility (리셋권/이름변경) | `/gen-utility` | `/gen-utilities` |
| Product/SelectableBox (선택 상자) | `/gen-selectable-box` | `/gen-selectable-boxes` |
| Product/Premium (VIP/멤버십) | `/gen-premium` | — |
| Product/Recipe (제작 레시피) | `/gen-recipe` | `/gen-recipes` |
| Stat (스탯 강화) | `/gen-stat-item` | `/gen-stat-items` |
| Skill (스킬 아이템 ≠ ResourceSkill) | `/gen-skill-item` | `/gen-skill-items` |
| Trait (특성/패시브) | `/gen-trait` | `/gen-traits` |
| System (통화 — reserved_ids) | `/gen-currency` | — |
| Character (플레이어 본체 — Unit 페어) | `/gen-character` | — |
| Ranking (랭킹 점수 통화) | `/gen-ranking-item` | — |
| Unit (영웅 카드/소환서 ≠ Pet) | `/gen-unit-item` | — |

> 복합 요청(예: "신규 보스 맵 한 챕터 + 전용 보스 + 보상 + 클리어 업적")은 **카테고리별로 단일/벌크 판별 후** 맵→유닛→스킬→트리거→보상→업적 순으로 전용 스킬을 엮어 진행. 예: "1장 던전 10개 + 보스 1마리 + 클리어 업적 5종" → `gen-maps` + `gen-unit` + `gen-achievements`. 각 스킬은 자기 카테고리의 `_drafts/`에 작성.

## Phase 2: 생성 (병렬 가능)
- 직접 타입: Task content-designer(정의) + economy-balancer(성장식/드롭) → 해당 카테고리의 `_drafts/{id}_{name}_v1.yaml`
- 위임 타입: 해당 전용 스킬 실행 (스킬 내부에서 _drafts에 작성)
- 각 카테고리의 `_index.yaml`에 행 추가 (`status: draft`, `created_by`, `created_at`, 관련 `refs`).
- 각 산출을 사용자에게 보여주고 승인받아 진행.

## Phase 3: 바인딩
정의 ↔ 성장(bind) ↔ 행동(triggers[]) ↔ 에셋 키(asset-producer) 연결. asset-registry 갱신.
- 교차 참조 시 대상이 `approved/` 또는 같은 라운드의 `_drafts/`에 실재하는지 확인 (`_index.yaml`로 빠르게 검색).

## Phase 4: 검증
Task content-reviewer — 스키마·참조무결성·가드레일·성장·행동어휘·에셋·밸런스. ERROR면 담당 에이전트로 되돌려 `_v2`로 재생성 (이전 v는 보존). (가능하면 `harness/tools/compile_unit.py` 등으로 회귀 확인.)

## Phase 5: 승인 및 보고
- 사용자 OK시: `_drafts/{id}_{name}_vN.yaml` → `approved/{id}_{name}.yaml` 이동(버전 접미사 제거). 각 _index의 `status: approved`, `reviewer`, `reviewed_at` 갱신.
- 보고: 생성/승인된 파일 목록 + _index 변경 요약 + 컴파일/배포 다음 단계 안내.

## 원칙
- 사용자가 각 결정의 최종 결정권자. AI는 소스를 만들고 사람이 승인.
- engine-contract는 불변. 엔진 JSON 직접 편집 금지(소스→컴파일).
- 아이템/스탯의 id는 `profile.id_ranges` 대역 + 해당 카테고리 `_index.yaml` 중복 확인 후 할당. 통화는 `reserved_ids` 일치.
- 한 콘텐츠당 `approved/`에는 최종 1개. 히스토리는 `_drafts/`의 `_v#` 보존으로.
