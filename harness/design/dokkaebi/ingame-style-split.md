# Dokkaebi Ingame Style Split

작성일: 2026-06-23
상태: planning draft

## Decision

인게임은 두 방향을 별도 후보로 검증한다.

1. `TangTang` style: 탕탕특공대식 top-down survivor.
2. `ZombieWaves` style: Zombie Waves식 무기/영웅 성장 중심 survivor.

현재 구현 우선순위는 `TangTang` style이다.

## TangTang Style

목표: 10초 안에 조작과 재미가 이해되는 가장 순수한 survivor 코어.

- Camera: strict top-down or near-top-down.
- Field: 낮은 디테일의 평면 전장. 장애물보다 가독성 우선.
- Control: 이동만 직접 조작.
- Attack: 해일의 `수류 창격` 자동 발동.
- Progress: 요귀 처치 -> 영력 픽업 -> 런 레벨업 -> 3카드 선택.
- Visual focus: 적 떼, EXP/영력 보석, 자동 스킬 VFX, 원형/부채꼴 타격 범위.
- Session: 75-180초 prototype, 이후 8-15분 정식 런으로 확장.

현재 Godot prototype:

`harness/runtime/godot-dokkaebi`

## Zombie Waves Style

목표: 장기 매출형 성장 구조의 두께를 검증하는 두 번째 후보.

- Camera: top-down 유지 가능하지만, 전투 압박은 더 무겁고 staged.
- Control: 이동 + 무기/영웅 고유 액션의 체감 강화.
- Attack: 영웅/무기/동료/드론형 자동 공격이 더 중요.
- Progress: 판 안의 카드 선택보다 판 밖의 영웅, 무기, 장비, 패키지 성장이 더 크게 작동.
- Visual focus: 무기 궤적, 보스/엘리트 압박, 스테이지 클리어 보상, 캠프/수련당 성장.
- Session: 더 긴 스테이지/챕터 구조, 보스 웨이브와 장비 보상 강조.

## Shared IP Translation

- Zombie/zombie apocalypse 표현은 쓰지 않는다.
- 적은 `잡귀`, `망령`, `도깨비 하수`, `부적술사`, `밤도깨비 장군` 등으로 치환한다.
- 총기/미사일은 `창술`, `수류`, `부적`, `도깨비불`, `법기`, `식신`으로 치환한다.
- 생존 목표는 "버티기"보다 "요귀 정화"로 표현한다.

## First TangTang Checklist

- [x] 해일 직접 이동
- [x] 자동 수류 창격
- [x] 요귀 스폰
- [x] 영력 픽업
- [x] 런 레벨업
- [x] 3카드 선택
- [x] 스킬 4종 초안
- [ ] 해일 SD sprite 교체
- [ ] 잡귀/망령/도깨비 하수 sprite 교체
- [ ] 스킬 수치 `harness/content/dokkaebi` 데이터화
- [ ] 첫 75초 밸런스 리포트
