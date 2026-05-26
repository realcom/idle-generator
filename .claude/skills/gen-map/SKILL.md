---
name: gen-map
description: "맵/던전 1개를 완성형으로 제작 (ResourceMap: 타입·웨이브·적 편성·보상·보드규칙). 던전/레이드/랭크/이벤트 스테이지를 만들 때 사용."
argument-hint: "[게임 id] [맵 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 맵 제작 (수직 슬라이스)

ResourceMap 정의 + 웨이브 로직 + 보상을 끝까지 만든다. 인자 없으면 사용법 출력 후 정지.

## 콘텐츠 저장 규칙 (필수)

산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.

- **파일명**: `{id}_{name}.yaml`
- **draft**: `harness/content/<game>/maps/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/maps/approved/{id}_{name}.yaml`
- **_index.yaml**: `harness/content/<game>/maps/_index.yaml`에 행 등록/갱신.

## 항상 먼저 읽는다
- `harness/engine-contract/schema/map.md` — 타입(Dungeon/Raid/Rank/Event/Lobby…), boardConstants, 웨이브=트리거
- `harness/engine-contract/reference-graph.md` — 적 편성(→Unit.id), 보상(→AddItemGroup→Item.id)
- `harness/engine-contract/behavior-format.md` — 웨이브/스폰 로직 (domain: map, spawnUnit 등 boardMethod)
- `harness/game-profiles/<game>.profile.yaml` — ID 대역, 테마, 밸런스 가드레일
- `harness/pipeline/content-organization.md` — 저장 레이아웃·_index 형식
- `harness/content/<game>/maps/_index.yaml` — 이미 등록된 맵 id 확인

## 단계
1. **결정**(AskUserQuestion): 맵 type, 테마/배경, 웨이브 수·난이도, 등장 적(Unit.id), 보상 성격, 보스 유무.
2. **ID 할당**: `profile.id_ranges.map` 대역에서 `_index.yaml` 스캔 후 다음 빈 id 결정.
3. **정의**(Task content-designer): `harness/content/<game>/maps/_drafts/{id}_{name}_v1.yaml` — id, type, name, boardConstants, 적 편성(Unit.id 참조).
4. **웨이브 로직**(Task behavior-author): `harness/content/<game>/maps/_drafts/{id}_{name}_behavior_v1.yaml` (domain: map) — 웨이브 스폰/이벤트. 컴파일 이름은 정의 triggers[]에 연결. (또는 정의 파일 내 같은 _drafts 폴더에 짝지어 보관)
5. **보상**(Task economy-balancer/content-designer): 클리어/드롭 보상 AddItemGroup (천장 포함). 모든 itemDataId가 `items/_index.yaml`의 approved에 실재 확인. 새 reward면 `rewards/_drafts/`로.
6. **(관례) 스테이지 요구치**(Task economy-balancer): 필요 시 `growth/{id}_{name}.growth.md`로 요구 전투력 곡선 + 몬스터 스케일 연동.
7. **_index 등록**: `maps/_index.yaml`에 `{id, name, file, status: draft, created_at, created_by: gen-map, tags}` 행 추가.
8. **검증**(Task content-reviewer): 적/보상 ID 무결성, 트리거 일치, 가드레일.
9. **사용자 검수**: draft 파일 제시. 피드백이면 `_v2`로 재생성. 승인이면 `approved/`로 이동, `_index` 상태 갱신.

## 주의
- 맵 비주얼(타일맵·프리팹)은 idlez Unity 씬 소관 — 콘텐츠 계층은 *키 참조*만(asset-producer가 바인딩).
- 적 편성 Unit.id, 보상 Item.id는 반드시 `_index.yaml`의 approved 항목에 실재해야 함(댕글링=빌드 차단).
- AI는 `_drafts/`에만 쓴다. `approved/` 이동은 승인 액션.
