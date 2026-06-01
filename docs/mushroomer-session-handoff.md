# Mushroomer Session Handoff

최종 갱신: 2026-05-26

## 현재 목표

`mushroomer`를 `idlez` 레거시 엔진 위에서 `새 게임 1종 검증용 vertical slice`로 만들고 있다.
우선순위는 튜토리얼/업적이 아니라 다음 4축이다.

- map
- trigger
- unit
- skill

즉, 최소 성공 기준은:

1. 맵 진입
2. 플레이어 유닛 spawn
3. 적 유닛 spawn
4. 스킬 사용과 피격
5. 적 처치 후 웨이브 진행

## 이번 세션에서 된 것

### 1. 클라/엔진 쪽 기반

- `GameScene` 안에서 통합형 모드로 돌릴 수 있도록 `ModeManagerMushroom` 도입
- `Page_Equipment`, `Page_Ability`, `Page_Shop_New` 기반 overlay UI 연결
- `ClientMapFlowResolver`로 맵 `popupArgs.ClientModeManager=ModeManagerMushroom` 사용
- `Page_Shop_New`를 실제 최신 상점 자산으로 사용하는 브리지 추가

관련 파일:

- [ModeManagerMushroom.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/Scripts/Components/Game/ModeManagerMushroom.cs:1)
- [ClientMapFlowResolver.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/Scripts/Core/Game/ClientMapFlowResolver.cs:1)

### 2. PatchResources seed 복구 및 동기화 라인

- live `PatchResources`를 비운 뒤, 필요한 최소 seed를 다시 복구
- compile 산출물 + example seed + Unity dependency를 live `PatchResources`로 옮기는 스크립트 추가

관련 파일:

- [unity_seed_manifest.py](/Users/yangjinhwan/Projects/idle-game-generator/harness/tools/unity_seed_manifest.py:1)
- [sync_patchresources_seed.py](/Users/yangjinhwan/Projects/idle-game-generator/harness/tools/sync_patchresources_seed.py:1)
- [mushroomer-seed-manifest.md](/Users/yangjinhwan/Projects/idle-game-generator/docs/mushroomer-seed-manifest.md:1)

### 3. 컴파일러/behavior 파이프라인 수정

- `_index.yaml` 파싱이 `items`만 읽던 버그 수정
- behavior `$var`가 빈 variable node로 나가던 문제 수정
- 현재 `python3 harness/tools/idlez_compile.py mushroomer`는 통과함

관련 파일:

- [idlez_compile.py](/Users/yangjinhwan/Projects/idle-game-generator/harness/tools/idlez_compile.py:163)

### 4. mushroomer 콘텐츠 초안

- `resource_globals.yaml` 추가
- bootstrap system items 1~8 추가
- 기본 character item `110101` 추가
- 첫 메인 맵 `500101` 추가
- 플레이어/몹/보스/스킬/오디오 초안 추가

관련 파일:

- [resource_globals.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/resource_globals.yaml:1)
- [500101_포자초원입구_v1.map.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/maps/_drafts/500101_포자초원입구_v1.map.yaml:1)
- [110111_버섯용사_v1.unit.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/_drafts/110111_버섯용사_v1.unit.yaml:1)
- [110201_이끼포자_v1.unit.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/_drafts/110201_이끼포자_v1.unit.yaml:1)
- [110501_포자대왕_v1.unit.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/_drafts/110501_포자대왕_v1.unit.yaml:1)
- [300101_포자충격_v1.skill.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/skills/_drafts/300101_포자충격_v1.skill.yaml:1)

### 5. 보드 루프/오프라인 플레이어 경로 수정

- `GameBoardManager`가 서버와 같은 tick 순서로 보드를 돌도록 수정
  - `EarlyUpdate`
  - `HandleInput`
  - `PostprocessUpdatesAndActions`
  - `Update`
  - `PostUpdate`
- 오프라인 플레이어 생성 시 `ItemDataId = 101` 하드코딩 제거
- `defaultCharacter -> unitDataId`를 타도록 수정
- mushroomer 맵에서는 튜토리얼 로더를 바로 빠지게 해서 board pause 방지

관련 파일:

- [GameBoardManager.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/Scripts/Core/Game/GameBoardManager.cs:221)
- [GameBoardManager.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/Scripts/Core/Game/GameBoardManager.cs:928)
- [Tutorial.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/Scripts/Tutorial/Tutorial.cs:125)

## 마지막으로 반영한 핵심 수정

### 맵 설정

- `500101`의 `playerUnitCount`를 `1 -> 0`으로 변경
- 이유:
  - `playerUnitCount > 0` 이면 엔진이 `avatar.Units[]`를 사용
  - 현재 mushroomer는 `avatar.Character`만 준비돼 있음
  - 따라서 플레이어가 join되지 않음

현재 source/build 기준 값:

- `harness/content/mushroomer/.../500101...map.yaml`: `playerUnitCount: 0`
- `harness/build/mushroomer/Maps.json`: `playerUnitCount: 0`

live도 마지막에 다시 sync해서 맞춤:

- [PatchResources/Maps.json](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/PatchResources/Maps.json:70)

### 전투용 최소 루프 콘텐츠

- 플레이어/몬스터/보스에 `targetMode: Chaser` 추가
- 플레이어/몹/보스에 주기적 `useSkill 300101` 트리거 추가
- `300101 포자 충격`에 실제 `hit.geometries` 추가
- `300101`에 `UseToTarget`, `TargetPosition`, `targetRefreshType: Nearest` 추가

관련 파일:

- [mushroom_hero.behavior.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/mushroom_hero.behavior.yaml:1)
- [sporeling.behavior.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/sporeling.behavior.yaml:1)
- [sporeking.behavior.yaml](/Users/yangjinhwan/Projects/idle-game-generator/harness/content/mushroomer/units/sporeking.behavior.yaml:1)

## 중요 메모

### compile -> sync 순서 주의

한 번 `compile`과 `sync`를 병렬로 돌려서,

- source/build는 최신값
- live `PatchResources`는 구버전 값

이 되는 문제가 있었다.

특히 `playerUnitCount`가 이 문제로 source는 `0`인데 live는 `1`로 남아 있었다.

다음부터는 반드시 순서대로 실행:

```bash
python3 harness/tools/idlez_compile.py mushroomer
python3 harness/tools/sync_patchresources_seed.py mushroomer
```

### 튜토리얼/업적

- 지금 우선순위는 아님
- 관련 로그는 남아도 무시 가능
- 다만 보드를 pause시키는 튜토리얼 경로는 막아둠

## 다음 세션 첫 체크리스트

1. Unity Play 재실행
2. 플레이어 유닛이 실제로 보이는지 확인
3. 적과 플레이어가 서로 타겟을 잡는지 확인
4. `300101` 사용 시 FX/피격/체력 감소가 생기는지 확인
5. 적 처치 후 wave 진행이 되는지 확인

## 다음 세션에서 막히면 먼저 볼 곳

### A. 플레이어가 여전히 안 보일 때

- live [Maps.json](/Users/yangjinhwan/Projects/idle-game-generator/engine/client/Client/Assets/PatchResources/Maps.json:70)의 `playerUnitCount`
- `MyPlayer.PlayerAvatar.Character` 값
- `GameBoard.AddOrUpdatePlayer()`의 default branch

핵심 파일:

- [GameBoard.Player.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/commons/Game/GameBoard.Player.cs:203)

### B. 플레이어는 보이는데 전투를 안 할 때

- `targetMode`, `targetAwareDistance`, `targetResetDistance`
- `UNIT_ONUPDATE_*` auto-use trigger
- `300101` geometry / target tags

### C. 스킬 FX는 나오는데 데미지가 없을 때

- `300101` timelines.hit.geometries
- `GameSkill.Hit.cs`의 target / geometry 판정

핵심 파일:

- [GameSkill.Hit.cs](/Users/yangjinhwan/Projects/idle-game-generator/engine/commons/Game/GameSkill.Hit.cs:8)

## 현재 판단

이제 문제는 “시스템이 아예 안 붙는다”가 아니라,

- 플레이어 join
- 타겟 탐색
- 최소 공격 루프

이 3개를 실제 런타임에서 맞추는 단계다.

즉 `mushroomer`는 이미 기획/컴파일/seed/클라 모드 기반은 깔렸고,
다음 세션부터는 진짜로 `전투 1회전`을 끝까지 붙이는 작업으로 넘어가면 된다.

## 추가 메모: 키우기M식 현재 씬 전환

2026-05-26 추가 수정:

- `500101` 맵에서 `ContainPlayerInventory` 태그 제거
- `ModeManagerMushroom`에서 레거시 `MergeBoard`를 런타임 숨김 처리
- 하단 탭을 `전투 / 성장 / 상점` 중심으로 재구성
- 상단에 맵·웨이브·HP·EXP·레벨·공격·골드 HUD 추가
- 인벤토리 없는 맵에서도 `MergeBoard` 초기화/인덱스 체크가 터지지 않도록 가드 추가
- 장비 보드가 없을 때 공격력 표시가 0으로 떨어지지 않도록 기본 공격력을 표시

검증:

```bash
python3 harness/tools/idlez_compile.py mushroomer
python3 harness/tools/sync_patchresources_seed.py mushroomer
```

두 명령을 이 순서대로 재실행했고, live `PatchResources/Maps.json`에서도 `tags: ["Main"]`, `playerUnitCount: 0`을 확인했다.

다음 Unity Play 체크는 기존 전투 루프 체크에 더해:

1. 빈 무기/인벤토리 배치판이 보이지 않는지
2. 하단 탭이 `전투 / 성장 / 상점`으로 보이는지
3. 상단 HUD가 플레이어 HP/EXP/공격/골드를 갱신하는지
4. 성장/상점 overlay를 열어도 보드가 pause되지 않는지

### 프리팹 구성 메모

- `ModeManagerMushroom.prefab`의 레거시 `Rect` 루트는 비활성화했다.
- `ModeManagerMushroomPrefabBuilder`를 추가했다.
  - 메뉴: `Tools > IdleZ > Mushroomer > Rebuild ModeManager Prefab`
  - 생성 대상: `MushroomHudRoot`, `MushroomQuickGrowthRoot`, `MushroomDock`, `MushroomOverlayRoot`
- batchmode 실행은 같은 Unity 프로젝트가 열려 있어서 한 번 실패했다.
- 열린 Unity 메뉴 자동 실행은 macOS Assistive Access 권한이 없어 실패했다.
- 이후 열린 Unity가 run-once를 실행해 프리팹 생성은 완료됐다.

2026-05-26 추가 확인:

- 열린 Unity가 뒤늦게 run-once를 실행했고, 프리팹에 아래 루트가 실제 생성됐다.
  - `MushroomHudRoot`
  - `MushroomQuickGrowthRoot`
  - `MushroomDock`
  - `MushroomOverlayRoot`
- `ModeManagerMushroomPrefabBuilder.runonce` 마커는 삭제됐다.
- Play 로그에서 다음 레거시 UI NRE가 새로 보였다.
  - `Utility.ModifyModiferValues()`가 null `AnimationRegion`을 순회
  - `MergeBoardBase.PositionCells()`가 null/empty grid를 순회
- 위 두 케이스는 null/empty guard로 막았다.

### 현재 화면 깨짐 대응 메모

2026-05-26 추가 수정:

- `FollowTargetCamera`의 던전 기본 `viewRect`가 화면 위쪽 띠만 렌더해서 세로 화면 대부분이 검게 비는 문제가 있었다.
- `ModeManagerMushroom`에서 mushroomer 전용 카메라 레이아웃을 강제로 적용한다.
  - `viewRect = (0, 0, 1, 1)`
  - `fov = 9.25`
  - `targetCameraPivot = (0.5, 0.58)`
- 맵 YAML에도 같은 카메라 값을 넣고 `compile -> sync`를 다시 순서대로 실행했다.
- 상단 HUD 제목은 `ClientName` fallback 키(`Map_500101_Name`) 대신 원본 `resMap.Name`을 사용한다.
- 하단 UI는 세로 화면 기준으로 `성장 버튼 영역 + 전투/성장/상점 dock`이 화면 하단에 고정되도록 런타임에서 재배치한다.
- `ModeManagerMushroomPrefabBuilder.runonce` 마커를 다시 만들었다. Unity가 스크립트 리로드를 허용하면 프리팹도 같은 레이아웃으로 다시 생성된다.

### 버튼 동작 메모

2026-05-26 추가 수정:

- dock 버튼은 Addressables 페이지를 열지 않고, `ModeManagerMushroom` 안의 로컬 패널만 토글한다.
  - `전투`: overlay 닫기
  - `성장`: 성장 패널 열기/다시 누르면 닫기
  - `상점`: 상점 패널 열기/다시 누르면 닫기
- 빠른 성장 버튼 3개를 추가했다.
  - `공격 강화`: 골드 소모, HUD 공격 표시 보너스 증가
  - `체력 강화`: 골드 소모, HUD HP 표시 보너스 증가
  - `스킬 강화`: 골드 소모, HUD 공격 표시 보조 보너스 증가
- 상점 패널은 아직 실제 결제/광고가 아니라 테스트 보급 버튼이다.
  - `포자 보급`: `+120G`
  - `광고 보상`: `+300G`
  - `패키지`: 준비중 피드백
- 현재 성장 보너스는 전투 수치에 직접 쓰는 영구 스탯이 아니라, 버튼 반응 검증용 로컬 표시 보너스다.

### 마지막으로 잡은 런타임 버그

2026-05-26 추가 수정:

- Unity 로그에서 `GameBoard.PostUpdate failed: KeyNotFoundException: 110111`가 반복됐다.
- 원인:
  - 첫 tick에서 플레이어 join이 `InitUnits()`보다 먼저 queue될 수 있음
  - 이후 `InitUnits()`가 unit count dictionary를 비움
  - `HandleAddUnits()`는 queue 시점에 count가 있었다고 가정하고 바로 감소시키다 터짐
- 수정:
  - `GameBoard.Unit.cs`의 add/remove unit count 감소를 `TryGetValue` 기반으로 방어했다.
- 검증:
  - `dotnet test engine/server/Server/Server.Tests/Server.Tests.csproj --no-restore`
  - 결과: 53개 테스트 통과

다음 Unity Play 체크는 반드시 Play 재시작 후:

1. `KeyNotFoundException: 110111`이 다시 나오지 않는지
2. `[MushroomTick]`에서 `units=1` 이상으로 올라오는지
3. 플레이어 유닛이 카메라 중앙 근처에 보이는지
4. 빠른 성장/성장 패널 버튼 클릭 시 골드가 줄고 HUD 표시가 갱신되는지
5. 상점 보급 버튼 클릭 시 골드가 늘고 버튼 비용 색상이 갱신되는지

### 하단 35~40% UI 레이아웃 메모

2026-05-26 추가 수정:

- 참고 화면처럼 하단 관리 UI가 화면을 확실히 덮도록 `BottomUiHeightRatio = 0.38`로 잡았다.
- `FollowTargetCamera.viewRect`도 `(0, 0.38, 1, 0.62)`로 바꿔서 전투 카메라는 상단 62% 영역에만 렌더한다.
- 새 하단 배경 루트:
  - `MushroomBottomUiRoot`
  - 불투명 갈색 패널 + 상단 금색 라인
- 하단 배치:
  - `MushroomDock`: 화면 y `0.016 ~ 0.088`
  - `MushroomQuickGrowthRoot`: 화면 y `0.274 ~ 0.362`
  - 성장/상점 패널: 화면 y `0.102 ~ 0.364`
- overlay dim은 제거했다.
  - 성장/상점 패널은 화면 전체를 어둡게 막는 팝업이 아니라 하단 관리 패널 안에서 교체되는 느낌으로 동작한다.
- `ModeManagerMushroomPrefabBuilder.runonce` 마커를 다시 만들었다.
  - Unity가 스크립트 리로드하면 `MushroomBottomUiRoot` 포함 프리팹이 다시 생성된다.
