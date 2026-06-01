# Mushroomer Seed Manifest

## 목적

`engine/client/Client/Assets/PatchResources`를 빈 상태에서 다시 세우기 위해,
`mushroomer` 1맵 수직 슬라이스가 부팅되는 데 필요한 최소 리소스 셋을 정리한다.

이 문서는 **예시 번들 전체를 복사하는 계획**이 아니라,
`example -> live`로 어떤 리소스를 어떤 우선순위로 가져와야 하는지 정하는 기준이다.

## 현재 판단

- `PatchResources` live 폴더는 현재 비어 있다.
- `harness/examples/patchresources`는 참고본이며, 그대로 live source of truth로 쓰지 않는다.
- `mushroomer` 메인 맵은 `BackpackDungeon`이 아니라 일반 `Dungeon`을 쓴다.
- 통합 UI 흐름은 맵 `type` 자동 추론이 아니라 `popupArgs` 명시 설정으로 붙인다.
- 따라서 첫 실험 맵은 아래 구조를 목표로 한다.

```yaml
type: Dungeon
popupArgs:
  ClientModeManager: ModeManagerMushroom
  ClientHomeMapDataId: self
```

## Seed Tier

### Tier 0. 로그인/리소스 부팅 필수

로그인 성공 직후 바로 읽는 파일들.
이 셋이 없으면 `GameScene` 이전에 막힌다.

- `PatchResources/GameConfig.json`
- `PatchResources/BannedKeywords.txt`
- `PatchResources/ResourceGlobals.json`
- `PatchResources/Triggers.json`
- `PatchResources/Strings.json`
- `PatchResources/Achievements.json`
- `PatchResources/Buffs.json`
- `PatchResources/Items.json`
- `PatchResources/Maps.json`
- `PatchResources/Skills.json`
- `PatchResources/Units.json`
- `PatchResources/Audios.json`

### Tier 1. 첫 전투맵 진입 필수

첫 메인 맵 1개를 열고 `ModeManagerMushroom`를 붙이기 위해 필요한 자산.

- `PatchResources/Maps/Prefabs/<scene>.prefab`
- 선택한 맵 프리팹이 참조하는 `Maps/0_Map_Palette/`
- 선택한 맵 프리팹이 참조하는 `Maps/1_Map_Images/`
- 플레이어 캐릭터 prefab + 관련 `Units/Characters/Assets/`
- 일반 몬스터 prefab + 관련 `Units/Monsters/Assets/`
- 보스 prefab + 관련 `Units/Monsters/Assets/`
- 전투 중 실제 호출되는 `FXPrefabs/`
- 전투 BGM 및 필수 SFX가 있는 `Sounds/`

editor 검증 기준으로는 additive scene이 없어도 prefab 로드는 계속 진행되도록 fallback을 둘 수 있다.
즉 1차 `mushroomer` 검증은 `Maps/<scene>.unity` 없이도 시작 가능하다.

### Tier 2. 통합 UI/메타 루프 필수

`ModeManagerMushroom` 자체는 Addressables로 열리지만,
실제 장비/강화/상점 페이지가 정상 표시되려면 아래가 필요하다.

- `PatchResources/Items/UI/`
- `PatchResources/UIAssets/ButtonSprites/`
- 아이템 아이콘에 대응하는 `PatchResources/Items/Icons/` 또는 `spriteGroups` 경로
- `PatchResources/ClientBubbleTextDefine.asset`

### Tier 3. 1차 제외 가능

첫 `mushroomer` 검증에서 당장 없어도 되는 후보들.

- `LobbyHUDLayoutDefine.asset`
- `ContentsOpenNotice.asset`
- `TutorialStepContainer.asset`
- 로비 전용 추가 UI 데이터
- 사용하지 않는 맵/몬스터/사운드 전체

## 확인된 함정

### 1. example JSON을 그대로 live에 넣으면 안 된다

현재 `harness/examples/patchresources`는 예시 자산과 예시 JSON이 함께 있지만,
일부 경로는 이미 서로 정합하지 않는다.

예시:

- `Maps.json`은 `prefab` 필드를 쓰고 있다.
  현재 클라는 `resMap.Scene`을 보고 `Maps/<scene>.unity`와 `Maps/Prefabs/<scene>.prefab`를 찾는다.
- `Units.json`은 `Units/Slime/slime_green.prefab`를 가리키지만,
  example 자산에는 `Units/Monsters/large_melee_slime_green.prefab`가 있다.
- `Skills.json`은 `FXPrefabs/VFX_Slash.prefab`를 가리키는데,
  example 자산에서는 같은 경로를 바로 찾지 못했다.
- `Audios.json`은 `Sounds/BGM/BGM_Meadow.mp3`를 가리키는데,
  example 자산에서는 같은 파일명을 바로 찾지 못했다.

즉 seed 전략은 `example JSON 복원`이 아니라,
**실제로 존재하는 example 자산 경로를 기준으로 mushroomer 콘텐츠를 새로 맞춘다**가 맞다.

### 2. 기본 경로는 `scene + prefab` 쌍이지만, editor 검증은 prefab-only fallback 가능

현재 클라 기본 경로는 아래 두 단계를 모두 탄다.

1. `PatchResources/Maps/<scene>.unity` additive load
2. `PatchResources/Maps/Prefabs/<scene>.prefab` instantiate

다만 빈 `PatchResources`에서 첫 slice를 검증하기 위해,
editor에서는 scene 파일이 없으면 additive load를 건너뛰고 prefab 로드를 계속 진행하는 fallback을 둘 수 있다.

### 3. 전투 중 ScriptableSingleton asset도 필요하다

`ClientBubbleTextDefine.asset`이 없으면 전투 중 bubble sequence 접근에서
null reference 위험이 있다.

반대로 `LobbyHUDLayoutDefine.asset`은 `ModeManagerLobby`에 묶여 있으므로,
`ModeManagerMushroom` 실험에서는 1차 필수까지는 아니다.

### 4. local board 경로는 별도 주의가 필요하다

`NetworkSystem.enableSocketConnection == false`인 로컬 전투 경로는
플레이어 캐릭터를 임시 `ItemDataId = 101`로 세팅한다.
이 값은 현재 간단한 seed 상태와 맞지 않을 가능성이 높다.

따라서 1차 검증은

- 네트워크/기존 avatar 경로를 유지하거나
- 로컬 보드 진입 로직을 `mushroomer` seed에 맞게 별도 정리

중 하나가 필요하다.

## 첫 번째 Seed 후보

`mushroomer` 1차는 "실제로 존재하는 경로"를 쓰는 게 중요하다.
현재 example 기준으로 가장 무난한 후보는 아래처럼 잡는 편이 낫다.

- 맵 prefab 후보: `Maps/Prefabs/PFB_MAP_Meadow_Day_Chapter.prefab`
- 일반 몬스터 prefab 후보: `Units/Monsters/large_melee_slime_green.prefab`
- 보스 prefab 후보: `Units/Monsters/finalboss_melee_slime_boss_green.prefab`
- 공통 배경/UI 스프라이트: `Items/UI/`, `UIAssets/ButtonSprites/`
- 전투 bubble singleton: `ClientBubbleTextDefine.asset`

맵 scene 쪽은 현재 example 안에서 바로 대응되는 `.unity` 쌍이 보이지 않는다.
하지만 editor fallback이 있으면 1차 seed는 map prefab 중심으로 먼저 닫을 수 있다.

## 다음 실행 순서

1. 첫 메인 맵 basename을 확정한다.
   - 권장: `PFB_MAP_Meadow_Day_Chapter` 기반
2. `mushroomer` 맵 YAML은 `scene:` 필드를 기준으로 작성한다.
   - `prefab:` 기준으로는 현재 클라와 정합하지 않는다.
3. 몬스터/보스/스킬/BGM은 "example에 실제 존재하는 경로"만 참조하도록 다시 고른다.
4. 그 다음에야 `compile -> sync -> live PatchResources` 실험을 한다.

## 현재 결론

지금 단계에서 가장 중요한 일은 `PatchResources` 전체 복원이 아니라,
`scene/prefab/player/monster/fx/audio`가 실제로 맞물리는 **첫 slice seed 조합 1개**를 고정하는 것이다.

그 조합이 고정되면, 이후 작업은 아래 순서로 단순해진다.

1. `mushroomer` content 작성
2. `--sync`로 JSON 반영
3. seed asset만 live PatchResources에 채움
4. Unity에서 첫 맵 진입 검증

## 실행 명령

현재는 아래 두 명령으로 `mushroomer` 첫 slice를 다시 세울 수 있다.

```bash
python3 harness/tools/idlez_compile.py mushroomer
python3 harness/tools/sync_patchresources_seed.py mushroomer
```

- 첫 번째 명령은 `harness/build/mushroomer/`의 JSON 번들을 다시 만든다.
- 두 번째 명령은 그 번들 + `harness/examples/patchresources` seed를 이용해
  live `engine/client/Client/Assets/PatchResources`를 채운다.

## 현재 결과

2026-05-25 기준으로 `sync_patchresources_seed.py mushroomer` 실행 결과는 아래와 같다.

- build JSON + boot 파일 + static singleton/scriptable asset 복원 완료
- live `PatchResources`에 `PFB_MAP_Meadow_Day_Chapter`, `PFB_HAM_Angel`, 슬라임 일반몹/보스, `VFX_LiquidHitGreen`, `BGM_Battle_Default`까지 반영 완료
- `Maps/PFB_MAP_Meadow_Day_Chapter.unity`는 example에 없지만 editor fallback 덕분에 1차 검증 blocker는 아님

즉 현재 남은 핵심 검증은 `Unity에서 로그인 -> GameScene -> mushroomer 첫 맵 진입` 확인이다.
