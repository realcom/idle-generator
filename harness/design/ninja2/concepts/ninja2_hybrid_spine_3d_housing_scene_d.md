# Ninja2 Hybrid Spine 3D Housing Scene D

## Intent

하우징의 우선 비주얼 후보. 서바이벌 전투는 ultra-flat 2D로 가시성을 챙기고, 하우징은 3D풍 건물과 2D Spine 캐릭터를 섞어 “키우고 싶은 성소”의 매력을 살린다.

## Art Anchor

- 안전한 성소 홈 화면이며, 하단 우측 `탐험 출발`로 별도 SurvivalBattle 화면에 들어간다.
- 건물은 살짝 3D 디오라마처럼 보이는 업그레이드 자산이다: 등불 신전, 목재소, 허브 정원, 영혼불 샘, 공방, 창고, 훈련장, 수호탑.
- 캐릭터는 3D 모델이 아니라 2D Spine-style 스프라이트다. 주민은 나무 운반, 허브 돌보기, 순찰, 공방 작업, 손 흔들기 같은 idle pose를 가진다.
- 주인공은 갈색 머리, 크림색 망토, 붉은 스카프, 손등불을 유지한다. 이마 흉터는 초상과 대화 컷에서 확실히 읽히게 한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 헥스 보드는 약한 2.5D 깊이를 가져도 되지만, 타일 상태는 즉시 구분되어야 한다.
- Tile states:
  - built: 3D풍 건물 + Lv 라벨
  - selected: cyan rim
  - empty: 베이지 plus pad
  - locked: 회색 lock tile
  - fogged: 어두운 mystery tile
  - expandable: 비용 아이콘이 붙은 edge tile
- 주민은 건물 사이 경로를 따라 배치하고, 선택 건물 주변에는 생산 말풍선과 업그레이드 화살표를 둔다.
- 하우징은 전투보다 배경 밀도를 더 허용하지만, 재화 말풍선/CTA/선택 타일을 가리지 않는다.

## UI Direction

- Top-left: 메뉴, 2D 주인공 초상, 레벨.
- Top-center: 성소 이름, 하트/주민 수/성장 단계.
- Top-right: 코인, 영혼불, 목재, 잎 토큰.
- Left rail: 퀘스트, 우편함, 이벤트.
- Bottom: 선택 건물 패널, 생산량, 수령 버튼, 업그레이드 비용.
- Bottom-right: 큰 오렌지색 `탐험 출발` CTA.
- Bottom nav: 성소, 건설, 업그레이드, 주민, 상점.
- UI는 전투 화면과 같은 굵은 외곽선/고대비 규칙을 유지한다.

## Implementation Notes

- 현재 HousingHome의 우선 비주얼 방향으로 둔다.
- MVP 구현은 “3D풍으로 보이는 2D sprite atlas + Spine 주민”이 가장 안전하다. 실제 3D 런타임은 카메라/조명/정렬 비용이 크므로, 먼저 pre-rendered building sprites로 검증한다.
- 2D Spine 캐릭터는 board y-position 기준 sorting order를 사용한다.
- 큰 건물 뒤로 캐릭터가 지나가는 연출은 선택적으로 occluder sprite/mask를 둔다.
- 전투 화면은 계속 `ninja2_flat_arcade_survivors_scene_f`처럼 플랫하게 유지한다. 두 화면의 통일성은 캐릭터 초상, 재화 색상, 굵은 UI 외곽선, 등불/영혼불 아이콘으로 맞춘다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1ec4a6b63481919c7802cdd3b3ee68.png`

![Ninja2 hybrid Spine 3D housing scene D](ninja2_hybrid_spine_3d_housing_scene_d.png)
