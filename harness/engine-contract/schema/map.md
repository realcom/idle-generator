# Schema Card: Map (던전/스테이지)

엔진 클래스: `ResourceMap` (`Commons/Resources/ResourceMap.proto`). 정의 계층.
맵 = 콘텐츠 컨테이너 (로비·던전·레이드·랭크·이벤트). 웨이브/지형/보드 규칙 + 트리거(웨이브·스폰·이벤트 로직).

## 타입 (Type)

| Type | id | 용도 |
| --- | --- | --- |
| `Lobby` / `ScenarioLobby` | 100 / 101 | 로비 |
| `Dungeon` / `RespawnDungeon` / `ScenarioDungeon` | 200~202 | 일반/부활/시나리오 던전 |
| `Raid` | 300 | 레이드 |
| `Event` | 400 | 이벤트 |
| `Rank` / `DefenseRank` | 500 / 501 | 랭킹 |
| `BackpackDungeon` | 600 | (backpack 게임 전용 — 엔진 범용성의 증거) |

## 핵심 필드

| 필드 | 의미 | 참조 |
| --- | --- | --- |
| `id` | 맵 dataId | — |
| `type` | 위 enum | — |
| `name` | 표시명 | Strings |
| `scene` | Unity 맵 basename. 클라는 `Maps/<scene>.unity`와 `Maps/Prefabs/<scene>.prefab`를 기대 | PatchResources |
| `triggers[]` | 웨이브/스폰/이벤트 로직 (예: `Map_Default3_Wave3`, `Map_BossDungeon_Update`) | → behavior |
| `boardConstants` | 보드 규칙 (`levelUpChoiceCount`, `fixX/fixY`, `defaultPlayerInventoryShapes`) | — |
| `popupArgs` | 클라이언트 흐름 오버라이드 (`ClientModeManager`, `ClientHomeMapDataId` 등) | Client |
| `Terrain` | 지형(정점/타일, Unit/Skill 종류) | — |
| `rewardAddItemGroups` | 클리어 보상 | → reward |
| `scoutAddItemGroups` | 정찰/방치 보상. `minutes`/`maxMinutes` 사용 | → reward |
| (적 편성) | 웨이브가 스폰하는 유닛 | → Unit.id |

## 전역(Global)

`ResourceMap.Global` — `dataId.tutorialMap`, `ScoutMinInterval`, `petSpawnOffsets`, 기본 보드 상수.

## 웨이브 = 트리거

idlez에서 웨이브/스폰 흐름은 대부분 **트리거**로 표현된다. `.ws` 파일명 규칙이 그대로 보인다: `Map_<MapName>_Wave<N>`, `Map_<MapName>_Update`, `Map_Tutorial_Wave2` 등. → 우리 포맷에선 `content/<game>/maps/<map>.behavior.yaml` (domain: map)로 작성, `spawnUnit` 등 boardMethod 액션 사용.

## Location / AddUnit

`BoardMethod.AddUnit`은 `locationId`가 없거나 0이면 `positionX/positionY` 좌표로 스폰하고,
`locationId`가 있으면 해당 map `locations[].geometries[]` 중 하나에서 랜덤 포인트를 뽑는다.

하네스 규칙:

- 모든 `locations[]`는 `geometries[]`를 1개 이상 가져야 한다.
- map trigger에서 `AddUnit.locationId`를 쓰면 같은 map 안에 해당 `Location.id`가 있어야 한다.
- 없는 `locationId`는 엔진에서 no-op이지만, AI 작성물에서는 실수일 가능성이 높으므로 검증 error로 본다.
- `AddUnit.unitDataId`는 반드시 정의된 Unit.id여야 한다.

## 작성 규칙

- 맵 정의(YAML)는 타입·이름·보드규칙·보상을 담고, 웨이브 로직은 `triggers[]` + map behavior로 분리.
- 클리어 보상 필드 정본은 `rewardAddItemGroups`다. 과거 `clearAddItemGroups`는 컴파일러 호환 alias로만 남긴다.
- Unity 클라이언트 검증용 맵은 `scene` 필드를 채워야 한다. 현재 로더는 `scene` basename 기준으로 scene/prefab 쌍을 찾는다.
- 적 편성은 Unit.id 참조 — 검증기가 무결성 확인.
- (관례) 스테이지 요구 전투력 곡선은 `maps/*.growth.md` 식으로 생성 가능 (`growth-pipeline.md`).
- 맵 비주얼(타일맵·프리팹)은 idlez에선 Unity 씬/프리팹(`PatchResources/Maps/`)이라 콘텐츠 계층은 *키 참조*만 한다.
- 메인 게임 흐름은 특수 타입(`BackpackDungeon`)에 기대기보다 일반 `Dungeon` + `popupArgs` 명시 설정을 우선한다.

## 클라이언트 흐름 팁

통합형 메인 플레이 화면처럼 특정 맵에서 기본 모드 매니저를 바꾸고 싶다면 `popupArgs`를 사용한다.

```yaml
type: Dungeon
scene: PFB_MAP_Meadow_Day_Chapter
popupArgs:
  ClientModeManager: ModeManagerMushroom
  ClientHomeMapDataId: self
```

- `ClientModeManager`: `GameScene` 안에서 붙일 모드 매니저 Addressable key
- `ClientHomeMapDataId`: 로그인 후 진입/전투 이탈 시 돌아갈 홈 맵. `self`면 현재 맵 유지

자동 반복/다음 맵 진행은 `group` 스캔에 기대지 말고 명시 edge를 둔다.

```yaml
tags: [Main, InfiniteWaves]
popupArgs:
  ClientAutoAdvance: true
  ClientNextMapDataId: self
  ClientRetryMapDataId: self
```

- `ClientAutoAdvance`: `GameEnded` 후 결과 팝업 대신 다음 맵으로 자동 진입
- `ClientNextMapDataId`: 승리 시 이동할 map id. `self`면 같은 맵 반복
- `ClientRetryMapDataId`: 패배 시 재시작할 map id. 생략 시 현재 맵
