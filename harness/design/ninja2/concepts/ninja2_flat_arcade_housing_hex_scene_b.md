# Ninja2 Flat Arcade Housing Hex Scene B

## Intent

전투 `ninja2_flat_arcade_survivors_scene_f`와 같은 납작한 모바일 아케이드 문법으로 맞춘 하우징 우선 후보. 예쁜 성소 일러스트보다 헥스 타일 상태, 생산/업그레이드, 확장 비용, 출정 흐름을 먼저 읽히게 한다.

## Art Anchor

- 화면은 안전한 성소 홈이며, 전투는 하단 우측 `출정` 버튼으로 별도 SurvivalBattle 화면에 진입한다.
- 주인공 초상은 이마 흉터, 갈색 머리, 크림색 망토, 붉은 스카프를 유지한다.
- 건물은 보드게임 토큰처럼 납작한 아이콘으로 둔다: 등불 신전, 작업장, 허브밭, 영혼불 우물, 창고, 수련 표적, 주민 집, 감시 등불.
- 재화는 코인, 영혼불, 목재, 잎 토큰으로 색과 형태를 분리한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 중앙 헥스 보드는 화면의 핵심이며, 모든 타일은 같은 평면 규칙을 따른다.
- Tile states:
  - built: 녹색 헥스 + 건물 아이콘 + Lv 라벨
  - selected: cyan 외곽선
  - empty: 베이지 헥스 + plus
  - locked: 회색 헥스 + lock
  - fogged: 어두운 헥스 + question silhouette
  - expandable: 비용 아이콘이 있는 가장자리 헥스
- 생산 말풍선과 업그레이드 화살표는 보드 위에서 바로 읽히게 한다.
- 하단 패널은 선택 건물의 생산량, 진행 바, 수령, 업그레이드 비용만 담는다.

## UI Direction

- Top-left: 메뉴, 초상, 레벨.
- Top-center: 성소 상태/주민 수/진행 점.
- Top-right: 재화 카운터 4종.
- Left rail: 퀘스트, 우편함.
- Bottom-left: 전체 이동, 꾸미기 같은 보드 조작 버튼.
- Bottom-right: 출정 CTA.
- Bottom nav: 성소, 건설, 업그레이드, 주민, 상점.
- UI는 전투 화면처럼 굵은 검은 외곽선, 단순 면, 높은 대비를 유지한다.

## Implementation Notes

- 현재 HousingHome의 우선 비주얼 방향으로 둔다.
- 건물은 Spine보다 2D sprite/icon atlas가 적합하다. 레벨 업그레이드 단계는 아이콘 장식 1~2개 추가로 표현한다.
- 하우징 타일 데이터는 `locked`, `fogged`, `empty`, `built`, `selected`, `expandable` 상태를 기본으로 둔다.
- 전투 보상은 하우징 보드의 목재/영혼불/코인/잎 토큰으로 귀환한다.
- 전투와 하우징은 서로 다른 화면이지만, 같은 굵은 외곽선 UI와 색상 규칙을 공유한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1eb7b84a8c81919d71a4acadc9680c.png`

![Ninja2 flat arcade housing hex scene B](ninja2_flat_arcade_housing_hex_scene_b.png)
