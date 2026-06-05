# Ninja2 Building Tech Tree Board B

## Intent

`ninja2` 건물 테크트리를 기존 영지 보드와 직접 연결해 보여주는 구현 후보. 화면 상단에는 작은 성소 보드 프리뷰를 남기고, 하단의 큰 양피지 영역에서 생산/성장/방어/주민/탐험 브랜치를 카드형 트리로 관리한다.

## Art Anchor

- 기존 하우징 홈의 성소 보드, 등불 신전, 목재 작업장, 허브 정원, 영혼광맥, 주민 캐릭터 실루엣을 유지한다.
- UI 재료는 warm parchment, dark wood frame, thick ink outline, lantern gold selected state, soul teal branch highlight를 사용한다.
- 건물 카드는 `building_atlas_lantern_sanctuary` 계열처럼 teal roof, lantern window, stone base가 있는 2.5D 스프라이트를 전면에 둔다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 상단 safe area에는 수호자 초상과 재화 칩을 유지한다.
- 상단 25~30%는 현재 영지 보드 프리뷰다. 플레이어가 어떤 건물 테크를 보고 있는지 홈 화면과 즉시 연결되어야 한다.
- 보드 아래에는 `전체`, `생산`, `성장`, `방어`, `주민`, `탐험` 세그먼트 탭을 둔다.
- 하단 55~60%는 양피지 테크 영역이다. 좌측에는 등불 신전 루트와 브랜치 레이블, 우측에는 큰 건물 카드 그리드를 둔다.
- 최하단 detail drawer는 선택 건물의 Lv. 변화, 다음 효과, 비용 충족 여부, 연구 시작 CTA를 보여준다.
- 하단 nav는 기존 성소/건설/테크트리/주민/상점 탭 구조를 따르고 `테크트리`를 선택 상태로 둔다.

## UI Direction

- 브랜치는 역할별로 묶는다: 생산, 성장, 방어, 주민, 탐험.
- 선택 브랜치는 soul teal outline과 glow로 강조하고, 선택 탭은 lantern gold로 표시한다.
- 건물 카드는 동일한 크기를 유지하며 이름, Lv., progress pips, 잠금/업그레이드 가능 상태만 노출한다.
- 잠긴 카드는 실루엣과 안개, 자물쇠로 표시한다. 선행 조건 텍스트는 카드 안에 길게 넣지 않는다.
- 비용 영역은 재화 아이콘 + 보유/필요 수량 + 체크 상태로 빠르게 스캔되게 한다.

## Implementation Notes

- B안은 현재 `HousingHome`에서 `TechTree` 탭으로 전환되는 화면의 1차 구현 후보로 적합하다.
- `harness/design/ninja2/housing-building-tech-v0.yaml`의 `role`, `tier`, `unlock`, `level_curve`를 카드 그룹/상태/비용 표시의 원천으로 삼는다.
- 상단 보드 프리뷰는 실제 보드 렌더를 축소하거나, 초기에는 동일 배경/건물 스프라이트를 쓰는 read-only preview로 대체할 수 있다.
- 카드 텍스트는 생성 이미지 그대로 쓰지 않는다. 실제 문구는 `name`, `level`, `effect_kind`, `cost`를 짧은 UI 문자열로 변환한다.
- 잠긴 미래 건물은 silhouette placeholder로 충분하다. Ring 3용 세부 아트는 확장 아틀라스 제작 후 교체한다.

## Target Runtime Notes

- Target preview: `harness/runtime/survivor-runtime.html?game=ninja2`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Data source candidate: `harness/runtime/src/survivor/housing-tech.js`, 추후 YAML에서 생성한 JSON/JS로 교체.
- Phaser/HTML 구현 시 `.home-top`, `.home-bottom`, `.home-tab` chrome을 재사용하고 중앙 content panel만 `tech-tree` view로 교체한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e91af-d669-72a1-a4dc-00d676548793/ig_08802cd4f51c8079016a2133e5a8e48195bc4991e2013d7901.png`

![Ninja2 building tech tree board B](ninja2_building_tech_tree_board_b.png)
