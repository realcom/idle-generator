---
name: gen-unit
description: "유닛 1종을 완성형(정의+성장식+행동+드롭+에셋 키)으로 생성하는 수직 슬라이스. 몬스터/영웅/펫 한 마리를 끝까지 만들 때 사용."
argument-hint: "[게임 id] [유닛 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 유닛 생성 (수직 슬라이스)

한 유닛을 정의→성장→행동→드롭→에셋까지 완성한다. 패턴 증명 + 빠른 양산용.

## 콘텐츠 저장 규칙 (필수)

산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.

- **파일명**: `{id}_{name}.yaml` (예: `110001_초록슬라임.yaml`)
- **draft**: `harness/content/<game>/units/_drafts/{id}_{name}_v#.yaml` (검토 중, 버전 명시)
- **approved**: `harness/content/<game>/units/approved/{id}_{name}.yaml` (승인 후, 버전 없음)
- **_index.yaml**: 카테고리 전체 메타. 새 항목마다 행 추가/업데이트.

## 단계
1. **읽기**: `harness/engine-contract/schema/unit.md`, `reference-graph.md`, `harness/game-profiles/<game>.profile.yaml`, `harness/pipeline/content-organization.md`, `harness/content/<game>/units/_index.yaml`(있다면).
2. **결정**(AskUserQuestion): type(몬스터/영웅/펫/보스), 티어/등급, 테마, 어느 맵에 등장, 드롭 성격.
3. **ID 할당**: `profile.id_ranges.unit` 대역에서 `_index.yaml` 스캔 후 다음 빈 id 결정.
4. **정의**(content-designer): `harness/content/<game>/units/_drafts/{id}_{name}_v1.yaml` — id, type, armorType, addStats 시드(value[]), triggers 자리. (유닛 requiredExps 미사용)
5. **성장**(economy-balancer): `harness/content/<game>/growth/{id}_{name}.growth.md` 또는 공용 growth에 bind — hp/atk/def 식.
6. **행동**(behavior-author): 필요 시 `harness/content/<game>/skills/_drafts/{trigger_id}_{name}_v1.behavior.yaml` 또는 공용 트리거.
7. **드롭**(content-designer/economy-balancer): `harness/content/<game>/rewards/_drafts/{reward_id}_{name}_drops_v1.yaml` — 골드/경험치 + 가중 드롭 + 천장.
8. **에셋**(asset-producer): 스프라이트/애니메이션 키 + AI 생성/요청 + asset-registry 등록.
9. **_index 등록**: `harness/content/<game>/units/_index.yaml`에 `{id, name, file, status: draft, created_at, created_by: gen-unit, tags}` 행 추가. 연결된 rewards/skills 카테고리의 _index도 동일.
10. **사용자 검수**: draft 파일 제시 → OK면 11, 피드백이면 `_v2`로 재생성(이전 v는 보존, _index의 file 갱신).
11. **승인**(content-reviewer 통과 후): draft 파일을 `approved/{id}_{name}.yaml`로 이동(버전 접미사 제거), _index의 `status: approved`, `reviewer`, `reviewed_at` 갱신.

## 산출 예 (참고)
- `harness/content/idlez/units/approved/110001_초록슬라임.yaml` (정의)
- `harness/content/idlez/growth/slime-stat-growth.growth.md` (식 — growth는 공용 시 평탄 구조 허용)
- `harness/content/idlez/rewards/approved/700001_초원슬라임드롭.yaml`
- `harness/content/idlez/units/_index.yaml`에 등록

## 원칙
- AI는 `_drafts/`에만 쓴다. `approved/`로의 이동은 사용자 승인 액션.
- id는 `profile.id_ranges` 대역 + 카테고리별 `_index.yaml` 중복 확인 후 할당.
- 같은 id의 재생성은 `_v#` 번호를 올린다(이전 v 보존).
