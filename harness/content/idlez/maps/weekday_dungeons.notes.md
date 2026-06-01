# 요일던전 v1 설계 메모

## 방치형 전제

요일던전은 컨트롤 기믹이 아니라 자동전투 성장축을 검사한다.

| 요일 | map id | group(mainId) | 특징 | 검사 성장축 | 주 보상 |
| --- | --- | --- | --- | --- | --- |
| 월 | 500301 | 500301 | 약한 황금 슬라임 다수 | 공격속도, 기본 공격력 | 골드 |
| 화 | 500302 | 500302 | 적은 수의 고방어 골렘 | 공격력, 치명타 피해 | 강화 재료 |
| 수 | 500303 | 500303 | 긴 전투와 누적 피해 | 체력, 방어력 | 경험치 |
| 목 | 500304 | 500304 | 균형형 비전 몬스터 | 종합 전투력 | 스탯 성장 아이템 |
| 금 | 500305 | 500305 | 젤리 드랍 기대값 | Luck, ItemDropPercent | 슬라임 젤리 |
| 토 | 500306 | 500306 | 빠른 공격 주기 | 공격속도, 쿨감, 치명타 | 공속/치피 성장 |
| 일 | 500307 | 500307 | 주간 종합 보스전 | 보스딜, 생존, 종합 성장 | 혼합 보상, 무료루비 |

## 난이도 확장 규칙

현재 파일은 각 요일의 난이도 1이다. 추후 난이도는 같은 `group` 아래에 map id만 확장한다.

```text
요일 family group = 50030D
난이도 N map id = 50030D + 10 * (N - 1)
stage = N
```

예시:

| 요일 | 난이도 1 | 난이도 2 | 난이도 3 |
| --- | --- | --- | --- |
| 월 | id 500301, group 500301 | id 500311, group 500301 | id 500321, group 500301 |
| 화 | id 500302, group 500302 | id 500312, group 500302 | id 500322, group 500302 |

서버/클라 정책으로는 `group`별 최고 클리어 stage를 저장하면 된다.

- 최초 클리어: 현재 최고 클리어 stage + 1만 도전 가능
- 재도전 제한: 이미 클리어한 stage는 직접 도전 불가
- 소탕: `group`의 최고 클리어 stage 이하 보상을 정책에 따라 지급
- 보상 증가: 난이도별 map의 `rewardAddItemGroups`를 증가시키거나, 서버에서 group/stage 보상 배율을 적용

## example 에셋 바인딩

유닛과 맵은 `harness/examples/patchresources/`에 존재하는 prefab/sprite 키를 참조한다.

- 월: `large_melee_slime_orange`
- 화: `large_melee_wood_golem_red`
- 수: `large_melee_bear_brown`
- 목: `elite_midboss_melee_ghost_female_blue`
- 금: `melee_slime3_yellow` / `melle_slime3.png`
- 토: `temp/boss_oni_ninja`
- 일: `dungeonboss_ranged_SlimeQueen`
