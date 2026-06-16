# Ninja2 Exploration Contract Board Concept B

## Intent

`ninja2` 홈의 `탐험` 탭을 B안으로 선택한다. 단순 던전 리스트 대신, 상단에는 짧은 루트 지도 strip을 두고 중앙에는 원정 의뢰 카드 3개, 하단에는 선택 목적지의 보상/난이도/입장 비용을 고정 drawer로 보여주는 구조다. 탐험의 목적지 선택, 파밍 보상, 준비 상태가 한 화면에서 읽힌다.

## Art Anchor

- 기준 분위기는 `ninja2_rulelocked_housing_home_a`의 등불 성소와 `ninja2_phaser_modal_system_a`의 양피지 모달 패밀리다.
- 색상 축은 parchment cream, dark ink outline, lantern gold, moss green, soul teal, action orange를 유지한다.
- 탐험지는 자원 수집/성소 성장 루프로 읽혀야 한다. 닌자 복면, 카타나, 도장, 암살자 판타지는 피한다.
- 이미지 속 한글/숫자는 pseudo text다. 실제 런타임에서는 `성소`, `장비`, `탐험`, `임무`, `상점` 탭 명칭과 콘텐츠 데이터를 네이티브 텍스트로 다시 배치한다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 1024x1792.
- 홈 화면은 어두운 스크림 아래에 남고, 탐험 모달은 화면 중앙 대부분을 차지한다.
- Header: 랜턴 crest, 짧은 title, 우상단 close button.
- Top map strip: 숲 루트, 3개 destination pin, dotted path. 지도는 방향성만 주고 긴 조작 표면이 되지 않는다.
- Body: 3개 expedition contract card. 각 카드는 왼쪽 icon medallion, title slot, reward chip row, wave/difficulty badge, right status stamp를 가진다.
- Bottom drawer: 선택 목적지 preview, 예상 보상, 추천 전투력/소모 재화, 난이도 segmented control, orange start CTA.
- 카드와 drawer가 하단 nav 및 sortie CTA를 침범하지 않도록 하며, body만 내부 스크롤 가능하게 둔다.

## UI Direction

- B안이 선택 방향이다. 이유는 지도감(A안)보다 정보 구조가 안정적이고, 현재 Phaser DOM overlay에 단계적으로 적용하기 쉽기 때문이다.
- `selected` card는 lantern gold stroke/glow, `cleared` card는 moss seal, `locked` card는 grayscale icon과 low-contrast stamp를 사용한다.
- 보상은 generated dungeon icon + native resource icon chip 조합으로 표시한다.
- 난이도 선택은 별/잎 1-3개 같은 작은 상태 원자로 구분하되, 정확한 수치는 네이티브 텍스트에 맡긴다.
- Primary CTA는 orange `탐험 시작` 계열 버튼 하나만 둔다. 상세/입장 이중 플로우보다 선택 카드 + drawer + start가 더 빠르다.

## Implementation Notes

- 전체 concept 이미지를 런타임 배경으로 쓰지 않는다.
- `ninja2.ui.panel.parchment_9slice`는 modal shell/card/drawer skin 후보로 재사용하고, crest/corner ornaments는 고정 sprite overlay로 유지한다.
- 기존 `ninja2.ui.dungeon_icon_set.resource_collection_v1`의 세 아이콘은 contract card medallion과 drawer preview에 재사용한다.
- 지도 strip은 새 generated background asset 후보가 될 수 있지만, destination pin, lock/clear/selected state, reward chips, difficulty, start button은 런타임 슬롯이다.
- 후속 `extract-design-system`에서 `ExplorationContractBoard`, `ExplorationMapStrip`, `ExpeditionContractCard`, `SelectedExpeditionDrawer`, `DifficultySegmentControl` 컴포넌트를 추가한다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Target entry: `harness/runtime/src/survivor/survivor-app.js`.
- Fixture URL: `harness/runtime/survivor-runtime.html?game=ninja2&fixture=city&tab=exploration`.
- 후속 구현은 기존 `.home-dungeon-modal`을 리스트 모달에서 `contract board` modal로 전환하고, 현재 상세 모달은 하단 drawer로 흡수하는 방향이 적합하다.
- Data contract상 dungeon ids, rewards, unlocks, difficulty state는 장기적으로 scenario/content source로 이동해야 한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb9c9-b02b-7543-9207-9048f10bb4ca/ig_08dea5dfa619d0a3016a2b7b2a48908191ac3e6fa7410ff7fb.png`

![Ninja2 exploration contract board concept B](ninja2_exploration_contract_board_concept_b.png)
