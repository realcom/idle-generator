# ninja2 survivor run leveling standard

작성일: 2026-06-19
대상: `mapGlobal.boardConstants.survivalRunLeveling`, Godot survivor runtime

## 문제

Godot survivor runtime의 인게임 플레이어 레벨업은 기존에 `battle_sim.gd` 상수로 정의되어 있었다.

- 기존 요구 EXP: `18 + 6 * (level - 1)`
- 기존 누적 요구 EXP: Lv2 18, Lv3 42, Lv4 72
- 저레벨 일반 몬스터 EXP: 대부분 1

75초 D1 전투에서 40~70킬이 나오면 선택지가 2~3회까지 빠르게 열릴 수 있어, 스킬 선택의 무게가 약하고 전투 초반이 과성장한다.

## D1 기준

첫 원정의 목표는 "레벨업 맛보기는 빠르게, 빌드 완성은 느리게"다.

| 항목 | 기준 |
| --- | ---: |
| 기준 런 길이 | 75초 |
| 평균 클리어 선택지 수 | 1~2회 |
| 숙련/고화력 선택지 수 | 2회 |
| 3회 이상 선택 | 매우 좋은 판 또는 후속 스테이지 |
| 첫 선택지 | 전투 초반 20~30킬 근처 |
| 두 번째 선택지 | 중반 이후 누적 70 EXP 근처 |

## 기본 곡선

`survivalRunLeveling.expRequirement`는 `base + linear * n + quadratic * n^2`를 사용한다. 여기서 `n = player_level - 1`.

| level up | 필요 EXP | 누적 EXP |
| --- | ---: | ---: |
| Lv1 -> Lv2 | 24 | 24 |
| Lv2 -> Lv3 | 46 | 70 |
| Lv3 -> Lv4 | 76 | 146 |
| Lv4 -> Lv5 | 114 | 260 |
| Lv5 -> Lv6 | 160 | 420 |

기본 데이터:

```yaml
survivalRunLeveling:
  targetRunSeconds: 75
  targetChoicesAtClear:
    average: 1.5
    skilled: 2
    cap: 3
  expRequirement:
    formula: base_linear_quadratic
    base: 24
    linear: 18
    quadratic: 4
  enemyExp:
    normalBase: 1
    normalLevelDivisor: 5
    bossBase: 8
    bossPerLevel: 1
  initialSkillIds: [300101]
  choicePoolSkillIds: [300102, 300103, 300115]
  maxRunSkillLevel: 5
```

## 튜닝 규칙

- 선택지가 너무 빠르면 `base`보다 `linear` 또는 `quadratic`을 먼저 올린다.
- 첫 선택지가 너무 늦으면 `base`만 내린다.
- 몬스터 레벨이 올라가며 EXP가 급증하면 `normalLevelDivisor`를 올린다.
- 보스 처치 보상을 크게 느끼게 하고 싶으면 `bossBase`만 올린다.
- 시작 스킬은 `initialSkillIds`에 둔다. D1 기본값은 `300101 쿠나이 베기` 하나다.
- 첫 레벨업 선택 풀은 `choicePoolSkillIds`로 제한한다. D1 기본값은 `300102`, `300103`, `300115`다.
- 맵별 페이스가 필요하면 `harness/content/ninja2/maps/_drafts/*.map.yaml`의 `boardConstants.survivalRunLeveling`에서 동일 키를 override한다.

## Godot 연결

Godot runtime은 `Maps.json.mapGlobal.boardConstants`를 기본값으로 읽고, 각 map의 `boardConstants`를 재귀 병합한다. 따라서 `resource_globals.yaml`에 둔 기본값이 모든 survival map에 적용되고, 맵별 override가 가능하다.
