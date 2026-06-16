# Ninja2 Exploration Route Map Concept A

## Intent

`ninja2` 홈의 `탐험` 탭을 단순 던전 리스트가 아니라 실제 원정 루트 지도처럼 읽히게 바꾸는 방향 후보. 성소 위에 열린 양피지 지도 안에서 목재, 석재, 동료 흔적 수집지가 노드로 연결되고, 선택한 목적지는 하단 준비 drawer에서 난이도와 보상을 확인한다.

## Art Anchor

- `ninja2_rulelocked_housing_home_a`의 등불 성소, 숲 배경, 굵은 잉크 외곽선, tactile mobile RPG UI를 유지한다.
- 공통 모달 문법은 `ninja2_phaser_modal_system_a`와 `ninja2_sanctuary_build_modal_a`의 양피지 패널, 랜턴 문장, 잎 장식을 계승한다.
- 탐험지는 닌자 도장/전투장이 아니라 자원 수집 루트다: 벌목길, 석재 채굴로, 동료 흔적 수집.
- 이미지 속 한글은 방향 참고용 pseudo text다. 실제 라벨, 숫자, 보상량은 런타임 네이티브 텍스트로 다시 배치한다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 1024x1792.
- 홈 HUD와 하단 도크는 스크림 아래에 희미하게 남겨 현재 위치가 성소 홈임을 유지한다.
- 중앙 모달은 큰 parchment map shell이며, 내부는 지도 일러스트 + 목적지 노드 + 하단 준비 drawer의 3층 구조다.
- 목적지 노드는 원형 아이콘 메달리온과 짧은 reward chip row를 가진다.
- 상태는 `cleared`, `selected`, `locked`를 노드 배지와 채도/광도로 구분한다.
- 하단 drawer는 선택 목적지 요약, 난이도 3개, orange start CTA를 안정 치수로 배치한다.

## UI Direction

- RouteMapPanel: 배경 지도와 점선 루트만 생성 이미지/스프라이트 후보로 본다.
- DestinationNode: 아이콘, 상태 배지, 보상 chip, 선택 halo는 슬롯형 컴포넌트로 분리한다.
- SelectedDestinationDrawer: 지도 아래에 고정된 준비 영역. 보상, 탐험 효과, 난이도, 입장 버튼을 포함한다.
- 선택 상태는 lantern gold halo, 잠금 상태는 low-contrast gray/ink, 완료 상태는 moss green seal을 사용한다.
- 현재 런타임의 세로 리스트보다 탐험감은 강하지만, 지도 일러스트가 커서 작은 화면에서는 카드형 B안보다 정보 밀도가 낮을 수 있다.

## Implementation Notes

- Phaser 구현 시 전체 mock PNG를 덮지 않는다.
- 지도 배경은 단일 generated bitmap 또는 작은 map strip sprite로 둘 수 있지만, 노드/텍스트/보상/난이도/버튼은 DOM 또는 Phaser 네이티브 슬롯으로 구성한다.
- 현재 `ninja2.ui.dungeon_icon_set.resource_collection_v1` 아이콘은 노드 메달리온 안에 재사용 가능하다.
- 난이도 버튼은 rectangular segmented control로 유지한다. 이미지는 skin/frame만 담당하고 별/잎/소울 비용은 런타임 원자다.
- 후속 추출 시 `ExplorationRouteMap`, `DestinationNode`, `SelectedDestinationDrawer`, `DifficultySegmentedControl` 컴포넌트가 필요하다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Target entry: `harness/runtime/src/survivor/survivor-app.js`.
- Fixture URL: `harness/runtime/survivor-runtime.html?game=ninja2&fixture=city&tab=exploration`.
- A안은 탐험감/지도감 검증용 draft로 남긴다. B안이 선택된 경우에도 map strip 또는 route node language를 일부 가져올 수 있다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb9c9-b02b-7543-9207-9048f10bb4ca/ig_08dea5dfa619d0a3016a2b7a7d54d481918a0daa4ebf98963b.png`

![Ninja2 exploration route map concept A](ninja2_exploration_route_map_concept_a.png)
