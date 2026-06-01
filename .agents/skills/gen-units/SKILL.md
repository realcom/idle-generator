---
name: gen-units
description: "유닛 여러 개를 한 번에 제작 (생태계/티어/속성 패밀리 단위). 슬라임 변종 5종, 4속성 펫, 챕터 보스 시리즈, 종족별 몬스터 묶음 등 같은 카테고리·다른 파라미터의 유닛 N개를 일관되게 양산. 단일은 gen-unit."
argument-hint: "[게임 id] [시리즈 설명: 예: '슬라임 변종 5종 (색깔 다름, 1~5티어)']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 유닛 벌크 생성 (생태계/패밀리)

같은 분류의 유닛 N개를 **일관된 파라미터 표**로 양산한다. 공통 type·armorType + 변동 차원(티어/속성/등급) + 묶음 검수.

## 사용 시나리오
- **티어 시리즈**: 슬라임 1~5티어 (HP/공격력 곡선 monotonic)
- **속성 패밀리**: 화/수/풍/지 4속성 펫 (스탯 같음, 스킬/색만 다름)
- **챕터 보스**: 1~10장 보스 시리즈 (난이도 곡선)
- **종족 묶음**: 고블린 일반/궁수/주술사/대장 — 한 생태계의 다양화
- **변종 세트**: 같은 베이스에 색/크기/속도만 다른 5~10종

## 콘텐츠 저장 규칙

산출물은 `harness/pipeline/content-organization.md`를 따른다.

- **draft**: `harness/content/<game>/units/_drafts/{id}_{name}_v#.yaml` (개별)
- **approved**: `harness/content/<game>/units/approved/{id}_{name}.yaml`
- **_index.yaml**: 시리즈 일괄 등록 (`series: <family-key>` 태그 동일)

## 항상 먼저 읽는다
- `harness/engine-contract/schema/unit.md` — type, armorType, addStats, triggers
- `harness/engine-contract/stat-catalog.md` — hp/atk/def 키
- `harness/engine-contract/reference-graph.md` — 유닛 → 스킬·드롭 참조
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.unit, 가드레일
- `harness/content/<game>/units/_index.yaml`

## 단계

1. **시리즈 정의**(AskUserQuestion):
   - **공통 type**(Monster/Elite/Boss/Hero/Pet), **공통 armorType**
   - **변동 차원**: 티어 / 속성 / 등급 / 생태계 변종
   - **인스턴스 수** (3~15 권장)
2. **변동 표 작성**(공통 사양 + 변동 파라미터):
   - 표 형식 제시 (열: id 자리·name·tier·hp 시드·atk 시드·armorType·skill_id·drop_reward_id·sprite_key)
   - 표 단위로 OK/수정 — Q 반복 대신 한 번에 확정
   - 예시:
     ```
     | tier | name      | hp seed | atk seed | armor | skill_id | drop_reward | sprite       |
     | ---- | --------- | ------- | -------- | ----- | -------- | ----------- | ------------ |
     | 1    | 초록슬라임 | 120     | 10       | Soft  | -        | 700001      | slime_green  |
     | 2    | 파랑슬라임 | 200     | 18       | Soft  | -        | 700002      | slime_blue   |
     | ...  | ...       | ...     | ...      | ...   | ...      | ...         | ...          |
     ```
3. **ID 일괄 할당**: `profile.id_ranges.unit` 대역 → 연속 ID (또는 등급/생태계 코드에 맞춤).
4. **공통 growth 패밀리**(economy-balancer): **식 1개**로 등급/티어별 스케일 차이 → `harness/content/<game>/growth/{family-key}.growth.md` (예: `slime-tier-growth.growth.md`). 멤버는 base만 다름.
5. **정의 N개 생성**(Task content-designer, **병렬**):
   - 각 인스턴스: `harness/content/<game>/units/_drafts/{id}_{name}_v1.yaml`
   - 공통 필드(type/armorType)는 동일, 변동만 표에서 반영
   - 유닛은 requiredExps 미사용
6. **행동/트리거 결정**:
   - 공통 행동(같은 가족 AI)이면 `gen-trigger`로 한 번 만들고 N개 정의가 같은 트리거 이름 참조
   - 멤버별 차이가 크면 각자 _drafts에 behavior 짝지움
7. **드롭 일괄 처리**(economy-balancer/content-designer):
   - 시리즈 멤버별 드롭 보상을 `rewards/_drafts/`에 일괄 생성 (또는 공통 reward 풀)
   - 천장(pity) 패밀리 규칙 일관 적용
8. **에셋 일괄**(asset-producer): sprite_key 컬럼 기준 — 색/크기 베리에이션은 베이스 1개 + tint 권장.
9. **_index 일괄 등록**: `units/_index.yaml`에 N행 (`series: <family-key>`, `tier`, `created_by: gen-units`).
10. **묶음 검수**(content-reviewer):
    - 시리즈 일관성(hp/atk 곡선 monotonic / 티어 누락 / 중복 ID)
    - 트리거·스킬·드롭 참조 무결성 일괄
11. **사용자 검수**: 표 + 샘플 2개 파일(저티어/고티어) 제시. 피드백이면 해당 멤버만 `_v2`.
12. **일괄 승인**: `_drafts/*_vN.yaml` → `approved/*.yaml` 일괄 이동. _index 갱신.

## 원칙
- **공통 결정 1회, 변동 표 1회** — gen-unit을 N번 부르지 말 것.
- **family-key**로 묶음 식별: growth 파일명·_index 태그 공통.
- 같은 가족 AI는 트리거 1개 공유. 다르면 멤버별 짝.
- 검수는 묶음 단위 — 곡선 monotonic, 등급 빠짐 없음, 종족 컬러 충돌 없음.
- N > 15면 등급/계보 단위로 분할 호출.

## 다른 스킬과의 협업
- 단일 유닛은 `/gen-unit`
- 시리즈 드롭 보상 → `rewards/_drafts/`에 묶음 생성
- 시리즈 등장 맵 → `/gen-maps`에서 적 편성 참조
- 공통 AI → `/gen-trigger`로 한 번
