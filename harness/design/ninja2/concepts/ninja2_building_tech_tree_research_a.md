# Ninja2 Building Tech Tree Research A

## Intent

`ninja2` 건물 테크트리를 독립 연구 화면으로 보여주는 세로형 모바일 UI 후보. 등불 신전을 루트 노드로 두고, 신전 레벨에 따라 Ring 1/2/3 건물이 순차 해금되는 구조를 한눈에 읽히게 한다.

## Art Anchor

- `ninja2_hybrid_spine_3d_housing_scene_d`의 2.5D 성소 건물감, 굵은 잉크 외곽선, 따뜻한 등불 창문을 유지한다.
- `ninja2_housing_top_bottom_tabs_arcade_a`의 chunky topbar, 어두운 재화 칩, 양피지 패널, 금색 선택 탭을 이어받는다.
- 중심 건물은 등불 신전이며, 목재 작업장, 채석장, 수련마당, 영혼광맥, 허브 정원, 주민 숙소, 공방, 수호등탑, 정찰소가 큰 노드로 읽혀야 한다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 상단 safe area에는 수호자 초상, 레벨, 골드/영혼불/목재/석재 재화 칩, 메뉴 버튼을 둔다.
- 중앙은 세로 스크롤 가능한 테크 그래프다. 등불 신전이 루트, Ring 1은 신전 Lv.2, Ring 2는 신전 Lv.4, Ring 3은 신전 Lv.6 게이트로 묶는다.
- 노드는 작은 아이콘이 아니라 건물 메달리온/카드 크기로 배치해 터치 타깃을 확보한다.
- 해금됨, 업그레이드 가능, 잠김, 안개 잠김 상태를 색과 선명도로 구분한다.
- 하단 고정 패널은 선택 노드의 현재 레벨, 다음 효과, 비용, 선행조건, 연구/업그레이드 CTA를 보여준다.

## UI Direction

- 연결선은 해금 구간은 lantern gold, 진행 예정/선택 브랜치는 soul teal, 잠금 구간은 회색 점선으로 구분한다.
- 노드 라벨은 짧은 이름, Lv., 잠금 아이콘, 업그레이드 화살표 정도만 노출한다.
- 하단 패널은 좌측 건물 일러스트, 중앙 효과/비용, 우측 큰 주황 CTA의 3분할 구조가 좋다.
- 하단 nav는 `성소`, `건설`, `연구`, `주민`, `상점`으로 두고 `연구`를 선택 상태로 둔다.
- 생성 이미지의 한글 텍스트는 구조 참고용이다. 실제 구현 문구는 런타임 데이터에서 짧게 재작성한다.

## Implementation Notes

- `harness/design/ninja2/housing-building-tech-v0.yaml`의 `tech_tree`와 `buildings.unlock`을 그래프 데이터 원천으로 삼는다.
- Ring 라벨은 신전 레벨 게이트와 연결한다: Ring 1 = shrine Lv.2, Ring 2 = shrine Lv.4, Ring 3 = shrine Lv.6.
- 그래프는 모든 노드를 한 화면에 압축하지 말고 중앙 영역만 세로 스크롤로 둔다.
- 건물별 아이콘은 기존 `building_atlas_lantern_sanctuary`와 확장 아틀라스 계획을 재사용한다.
- A안은 연구 전용 화면으로 강하지만, 기존 영지 보드와의 직접 연결감은 B안보다 약하므로 구현 우선순위는 낮게 둔다.

## Target Runtime Notes

- Phaser: topbar/bottom dock은 기존 home UI chrome을 재사용하고, 중앙만 scrollable DOM/Canvas hybrid tree로 구현한다.
- Unity: `ScrollRect` 안에 노드 프리팹과 connector line을 배치하고, 하단 detail drawer는 고정한다.
- 엔진 계약 확장은 필요하지 않다. 초기에는 runtime housing tech data에서 UI만 그린다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e91af-d669-72a1-a4dc-00d676548793/ig_08802cd4f51c8079016a21339316d481958debfad7e1892309.png`

![Ninja2 building tech tree research A](ninja2_building_tech_tree_research_a.png)
