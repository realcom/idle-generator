# Ninja2 Rulelocked Housing Home A

## Intent

`casual_sanctuary` 방향을 실제 HousingHome 규칙에 맞춰 다시 뽑은 기준 시안. 이전 `hybrid_spine_3d_housing_scene_d`의 소유감과 `flat_arcade_housing_hex_scene_b`의 판독성을 합쳐, MVP 하우징 화면의 아트/UX 게이트로 사용한다.

## Art Anchor

- 하우징은 별도 세로형 홈 화면이며, 전투는 우측 하단 `Sortie` CTA로 진입한다.
- 중앙 건물은 `Lantern Shrine`이며 Town Center/Furnace 역할을 한다.
- 건물은 실제 3D 런타임이 아니라 3D풍 pre-rendered 2D sprite atlas로 제작 가능한 형태다.
- 주민은 2D Spine-style SD 캐릭터로, 목재 운반, 허브 관리, 신전 경비, 출격 복귀 같은 작업 상태를 보여준다.
- 주인공 식별자는 초상과 보드 캐릭터의 갈색 머리, 크림색 망토, 붉은 스카프, 손등불로 유지한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 중앙 헥스 보드가 화면의 핵심이며, UI는 보드를 가리지 않도록 가장자리에 붙인다.
- Tile states:
  - built: 녹색 헥스 + 3D풍 건물 + Lv 라벨
  - selected: 밝은 cyan rim
  - empty: 밝은 베이지 plus pad
  - locked: 회색 lock tile
  - fogged: 안개 낀 미정화 타일
  - expandable: 비용이 붙은 edge tile
- 하우징은 전투보다 배경 밀도를 허용하지만, 생산 말풍선/업그레이드 화살표/선택 패널보다 배경이 앞서면 안 된다.
- 안개 타일은 현재 시안에서 시선을 강하게 끄는 편이므로, 다음 패스에서는 대비와 면적을 낮춘다.

## UI Direction

- Top: 주인공 초상, 레벨, 주요 재화, 주민 수, 메뉴/설정.
- Left rail: 퀘스트, 우편, 보상/이벤트 계열 아이콘.
- Center board: 생산 말풍선, 업그레이드 화살표, Lv 라벨, 수령 가능 상태.
- Bottom panel: 선택 건물 이미지, 레벨 변화, 생산량, 타이머/진행 바, 업그레이드 비용.
- Bottom-right: 큰 오렌지 sortie CTA. 전투 진입 버튼은 화면의 가장 강한 액션 색으로 둔다.
- Bottom nav: Home, Residents, Build, Research, Shop, Bag 계열 탭. 실제 로컬라이즈 텍스트는 이후 UI recipe에서 정리한다.

## Implementation Notes

- MVP는 고정 헥스 좌표 + y-sort 주민으로 충분하다.
- 건물 업그레이드는 지붕/등불/소품 밀도/바닥 장식 추가로 3단계 이상 구분한다.
- 주민 애니메이션은 idle, carry, tend, guard, return-home의 5개 루프를 우선한다.
- 전투와의 통일성은 굵은 검은 외곽선, 청록 영혼불, 노란 코인, 크림색 주인공 실루엣, 오렌지 CTA로 맞춘다.
- 이 시안은 `candidate`로 두되, 다음 추출 단계에서는 안개 타일 대비와 하단 패널 높이를 조정한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e89ea-8ace-7ed1-9f56-c17674701a8b/ig_02021c8f676fd39d016a1f38409ca08191914b6709f7487952.png`

![Ninja2 rulelocked housing home A](ninja2_rulelocked_housing_home_a.png)
