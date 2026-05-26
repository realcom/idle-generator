# Schema Card: Tutorial

튜토리얼은 아직 별도 `ResourceTutorial`이 아니다. 현재 idlez 엔진은 `ResourceAchievement.Global.DataId`와 일반 업적 상태를 튜토리얼 진행 저장소로 사용한다.

## Harness Source

`content/<game>/tutorials/*.tutorial.yaml`

핵심 출력:

| source | output | 의미 |
| --- | --- | --- |
| `achievementGlobal.dataId.tutorialComplete` | `Achievements.json.achievementGlobal.dataId.tutorialComplete` | 전체 튜토리얼 종료 플래그 |
| `achievementGlobal.dataId.ingameTutorialEnter` | `achievementGlobal.dataId.ingameTutorialEnter` | 첫 튜토리얼 맵 진입 플래그 |
| `achievementGlobal.dataId.tutorialSteps[]` | `achievementGlobal.dataId.tutorialSteps[]` | 클라 `Tutorial.Step` 진행 순서 |
| `achievements` | `achievements[]` | 튜토리얼 진입/브릿지/게이트 업적 |
| `steps[].achievement` | `achievements[]` | 단계별 진행 업적 |

## Current Runtime Contract

Unity 클라의 `Tutorial.cs`는 `tutorialSteps[]`의 인덱스를 `Tutorial.Step` enum 인덱스로 해석한다. 따라서 현재는 **순서가 API**다.

예:

```yaml
achievementGlobal:
  dataId:
    tutorialSteps: [610101, 610102, 610103, 610201, 610202, 610203, 610204, 610205]

steps:
  - id: 610101
    key: InGameTutorial_1_Merge
    achievement:
      initialOpen: true
      clientAchievement: true
      childAchievementDataIds: [610102]
```

`key`, `phase`, `clientFlow`는 harness/기획 메타데이터다. 현재 컴파일러는 `steps[].achievement`만 엔진 업적 필드로 내보낸다.

## ID Convention

튜토리얼 업적은 일반 업적 대역 안의 `610000-610399` 블록을 쓴다.

| 범위 | 용도 |
| --- | --- |
| `610000-610099` | 시스템 플래그/게이트 (`tutorialComplete`, `ingameTutorialEnter`, parent gate 등) |
| `610100-610199` | 인게임 튜토리얼 단계 |
| `610200-610299` | 로비/아웃게임 튜토리얼 단계 |
| `610300-610399` | 콘텐츠 오픈 안내/브릿지 업적 |

레거시 idlez 값인 `11`, `12`, `13`, `101` 같은 짧은 id는 새 manifest에서 쓰지 않는다.

## Generalization Rule

- 진행 상태는 `Achievement`로 둔다. 서버의 `OpenAchievement`, `childAchievementDataIds`, `parentAchievementDataId`, `progressParentOnComplete`, `autoReward`를 재사용한다.
- 튜토리얼 단계의 표시/클릭/마스크/팝업 시퀀스는 `clientFlow` 메타로 먼저 명시하고, 엔진 일반화가 준비되면 이 메타를 클라 런타임이 직접 읽게 한다.
- 새 게임은 `game-profiles/<game>.profile.yaml`의 `reserved_ids.achievement.*`와 tutorial manifest의 `achievementGlobal.dataId.*` 값을 반드시 맞춘다.

## Open Work

현재 `Tutorial.cs`의 행동은 여전히 C# switch에 있다. 다음 일반화 단계는 `clientFlow`를 `showPopup`, `showMask`, `click`, `buyItem`, `waitAchievement`, `claimAchievement` 같은 작은 액션 어휘로 확장하고, 클라가 그 리스트를 실행하도록 바꾸는 것이다.
