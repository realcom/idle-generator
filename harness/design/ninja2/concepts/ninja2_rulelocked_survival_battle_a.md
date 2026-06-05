# Ninja2 Rulelocked Survival Battle A

## Intent

`casual_sanctuary` 전투를 실제 모바일 서바이버 화면 규칙에 맞춰 다시 뽑은 기준 시안. 이전 `flat_arcade_survivors_scene_f`의 ultra-flat 방향을 유지하면서, 주인공 식별자와 전투 보상 픽업을 더 명확하게 고정한다.

## Art Anchor

- 전투는 하우징과 분리된 별도 SurvivalBattle 화면이다.
- 화면은 키아트가 아니라 실제 플레이 가능한 top-down 2D sprite-game mockup처럼 보여야 한다.
- 주인공은 작은 SD 성소 수호자다. 전투 스프라이트에서는 이마 흉터보다 붉은 스카프, 크림색 망토, 손등불, 따뜻한 등불 aura를 우선한다.
- 적은 반복 생산 가능한 숲 생물 스프라이트다: 잎 임프, 숯 정령, 가시 덤불, 보라 버섯.
- 투사체와 VFX는 등불 탄환, 영혼불, 원형 결계, 작은 피격 스파크로 제한한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- strict orthographic top-down 2D. 하우징 헥스, isometric depth, 큰 건물, 시네마틱 배경을 넣지 않는다.
- 중앙 플레이 공간은 비우고 적과 픽업을 원형으로 배치한다.
- 바닥은 녹색/흙 패치/잎/작은 돌 정도의 반복 가능한 타일감만 둔다.
- 픽업은 색과 형태가 겹치지 않아야 한다:
  - EXP: 파란 보석
  - coin: 노란 동전
  - soulflame: 청록 불꽃
  - wood: 목재 상자/묶음
- 피해 숫자는 흰색 + 검은 외곽선으로 둔다.

## UI Direction

- Top-left: 주인공 초상, HP, 레벨, 소형 상태 아이콘.
- Top-center: 타이머와 stage/wave 블록.
- Top-right: 코인/영혼불 카운터와 일시정지.
- Top-wide: 세그먼트 진행 바.
- Bottom-left: 반투명 조이스틱.
- Bottom-right: 원형 스킬 쿨다운 3개.
- Bottom: EXP 진행 바.
- UI는 가장자리에 붙이고 전투 필드를 가리지 않는다.

## Implementation Notes

- 일반 적은 Spine보다 2-4프레임 sprite sheet walk/hit/death로 제작한다.
- 주인공만 Spine 또는 약식 bone rig를 검토한다.
- VFX는 투사체 trail과 impact burst를 작고 반복 가능한 atlas로 만든다.
- 하우징 보상과 연결되는 목재/영혼불/코인은 전투 픽업에서도 같은 아이콘 색을 유지한다.
- 이 시안은 `candidate`로 두되, 이후 패스에서는 배경 가장자리 장식 밀도를 조금 낮춰 더 플랫하게 만들 수 있다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e89ea-8ace-7ed1-9f56-c17674701a8b/ig_02021c8f676fd39d016a1f38937868819181acca43d44d5149.png`

![Ninja2 rulelocked survival battle A](ninja2_rulelocked_survival_battle_a.png)
