# Ninja2 Beacon Survival Skill Sweep Concept B

## Intent

`ninja2_beacon_survival_hud_concept_a`가 봉화 탐색과 상호작용 검증을 보여주는 안이라면, 이 B안은 인게임 서바이벌의 즉각적인 쾌감인 "몬스터가 쏟아지고, 성장한 스킬로 한 번에 쓸어버리는 순간"을 보여주는 전투 밀도 후보다.

문서의 하단 HUD 제거와 상단 정보 집중 원칙은 유지하되, 화면 중앙은 몬스터 웨이브, 광역 스킬 궤적, 피해 숫자, EXP/코인 드롭 폭발로 채워 서바이버 장르의 핵심 기대감을 먼저 전달한다.

## Art Anchor

- 주인공은 작은 SD 성소 수호자다. 크림 망토, 붉은 스카프, 손등불 aura를 유지한다.
- 적은 반복 생산 가능한 숲 생물 스프라이트다: 잎 임프, 보라 버섯, 검은 불씨 정령, 가시 덤불.
- 스킬은 문서의 무기 방향과 연결한다:
  - 표창: 주인공 주변을 도는 금색 orbit blade.
  - 쿠나이: 진행 방향으로 큰 부채꼴 slash.
  - 팔괘진: 주인공 중심 원형 shockwave / 지속 장판.
  - 보조 연출: 청록 영혼불 체인 라이트닝.
- 봉화는 우상단에 남겨 목표성을 유지하지만, 이 시안의 주인공은 몬스터 벽을 뚫고 봉화로 가는 전투 상태다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 하단 HUD는 여전히 비운다. 화면 하단까지 적과 드롭이 보여야 한다.
- 주인공은 하단 중앙 근처, 따뜻한 금색 가시성 원 안에 둔다.
- 화면 좌측과 하단에는 몬스터 벽을 빽빽하게 두고, 우상단 봉화 방향은 화살표와 빈 통로로 읽히게 한다.
- 큰 금색 slash는 좌측 상단 몬스터 무리를 갈라내고, orbit blade는 주인공 주변 안전지대를 만든다.
- 청록 체인 라이트닝은 적 사이를 잇되, 주인공과 금색 slash를 가리지 않는다.
- 피해 숫자는 흰색 + 검은 외곽선으로 두고, 몬스터가 처치된 경로에는 EXP 보석과 코인 드롭을 밀도 있게 남긴다.

## UI Direction

- Top-left: 일시정지, 무기 슬롯 3개, 각 `Lv.5~6` 수준으로 성장감을 보여준다.
- Top-center: 목표 패널은 `봉화로 돌파하라!` 계열 문구와 01:12 타이머. 바로 아래 `Lv.12`와 EXP bar.
- Top-center lower: `연속 처치 / K.O. 148` 같은 작은 전투 성과 chip을 둬 쓸어버리는 피드백을 강화한다.
- Top-right: 목재, 석재, 식량, 생존자 수 장부. 몬스터 처치 화면에서도 4X 귀환 보상이 계속 쌓이고 있음을 보여준다.
- Bottom: 조이스틱, 스킬 버튼, 액션 독 없음. 전투 장면이 하단까지 이어진다.

## Implementation Notes

- A안보다 몹과 이펙트 밀도가 높으므로 런타임에서는 readability budget이 필요하다.
- 실제 구현에서 한 프레임에 모든 스킬을 동시에 상시 노출하기보다, 0.6~1.2초짜리 peak combat 순간에 slash, orbit, chain, hit spark를 겹치게 한다.
- VFX 우선순위:
  1. 주인공 가시성 원과 orbit blade
  2. 큰 부채꼴 slash
  3. hit spark와 damage number
  4. chain lightning
  5. pickup glow
- 적 수가 많아질수록 바닥 디테일은 낮추고, 작은 잎/돌 데칼은 몬스터와 픽업 아래로 묻히게 둔다.
- 피해 숫자는 일정 수 이상이면 샘플링하거나 합산 숫자로 줄여야 한다. 시안처럼 모든 적에 숫자를 띄우면 모바일에서는 과밀해질 수 있다.
- 봉화 화살표는 combat guide로 유지하되, slash/VFX와 같은 금색을 쓰므로 alpha와 두께를 낮춰 우선순위를 조절한다.

## Target Runtime Notes

- Target surface: `SurvivalBattle` 또는 문서 기반 `BeaconSurvivalBattle` 변형.
- Runtime owner 후보: `harness/runtime/src/survivor/survivor-app.js`, Godot 쪽은 `harness/runtime/godot-ninja2/scripts/battle_sim.gd`.
- Phaser/Godot 구현 시 우선 필요한 것은 HUD 재배치보다 enemy spawn fixture, skill VFX burst, pickup scatter, hit number budget이다.
- A안과 B안은 같은 HUD 계약을 쓰되 QA 목적이 다르다:
  - A안: 이동/목표/상호작용 동선 검증
  - B안: 몬스터 물량/스킬 청소감/성장 체감 검증

## Foundation Gaps / Questions

- 하단 스킬 버튼이 없는 상태에서 스킬 발동이 완전 자동인지, 플레이어가 방향 입력만 하는지 확정해야 한다.
- 쓸어버리는 장면을 기본 3분 구간의 중반 피크로 둘지, 봉화 점화 후 보스 전 전초전으로 둘지 정해야 한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ef8e2-6c5f-76d2-a8db-478e042957a5/ig_00cf3b246ef1a1bd016a3b9f922df8819199d3afcc1c071156.png`

![Ninja2 beacon survival skill sweep concept B](ninja2_beacon_survival_skill_sweep_concept_b.png)
