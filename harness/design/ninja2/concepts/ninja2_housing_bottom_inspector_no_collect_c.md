# Ninja2 Housing Bottom Inspector No Collect C

## Intent

`ninja2_housing_bottom_loop_dock_b`에서 좌측 독립 `수령` 버튼을 제거하고, 선택 건물 inspector를 하단 action row의 주인공으로 다시 잡은 후보 시안이다. 생산 수령은 별도 버튼이 아니라 선택 건물 카드 안의 작은 상태/수령 칩으로 흡수하고, 우측 `탐험 출발` CTA는 계속 가장 강한 전환 액션으로 유지한다.

## Art Anchor

- `ninja2_rulelocked_housing_home_a`의 숲 성소, 등불 신전, 굵은 잉크 외곽선, tactile mobile RPG UI를 유지한다.
- 색상 축은 parchment cream, lantern gold, soul teal, moss forest green, action orange를 유지한다.
- 주인공 캐릭터는 이 영역에 새로 그리지 않는다. 실제 수호자 정체성은 기존 `profile_guardian` / `guardian_hero` 에셋을 기준으로 유지한다.

## Composition Rules

- 맨왼쪽 독립 수령 버튼은 없다.
- 하단 action row는 넓은 selected building inspector + 우측 orange sortie CTA의 2기능 구조다.
- 선택 건물 썸네일은 inspector 내부 좌측에 작게 둔다.
- 건물명, 다음 레벨, 생산량, 진행률, 작은 stat chip은 inspector 중앙에 묶는다.
- 랜덤/배치/강화 같은 보조 액션은 inspector 내부 우측의 compact button으로 제한한다.
- 수령 가능 상태가 필요하면 inspector 내부의 작은 green/gold chip으로 표시한다.
- orange sortie CTA는 독립 버튼으로 유지하되 inspector와 적당한 간격을 둔다.

## UI Direction

- 기존 B안의 `quick collect` 독립 카드보다 inspector 폭을 넓혀 건물 정보 가독성을 우선한다.
- “수령”은 최상위 CTA가 아니라 선택 건물 상태의 일부로 취급한다.
- 버튼 시각 위계는 `탐험 출발` > inspector 내부 primary/secondary action > stat chip 순서다.
- 하단 탭 dock은 이 crop에 포함하지 않지만, 실제 화면에서는 기존 `성소`, `동료`, `탐험`, `임무`, `상점` 5탭과 연결한다.

## Implementation Notes

- Concept 단계이므로 Phaser 런타임에는 아직 반영하지 않는다.
- 후속 구현 시 `.home-quick-collect`를 제거하고 `.home-bottom`을 `selected building panel + sortie CTA` 구조로 재배치한다.
- `quickCollectHomeIncome` 동작이 필요하면 selected building panel 내부의 compact collect chip 또는 생산 bubble click으로 이관한다.
- `#homePanelSkinStage`는 inspector 패널 전체 폭을 그리도록 확장하고, 좌측 독립 카드용 column은 삭제한다.
- QA에서는 panel text overflow, sortie CTA overlap, bottom nav와의 안전거리, compact width에서 Korean label wrapping을 확인한다.

## Target Runtime Notes

- Preview target: `harness/runtime/survivor-runtime.html?game=ninja2&homeDemo=city`.
- Target mobile shell: 390-440px wide portrait.
- Bottom action row should reserve board clearance no larger than the current B안; removed collect column should buy horizontal breathing room, not add height.

## Source Image Link

- Raster concept: `harness/design/ninja2/concepts/ninja2_housing_bottom_inspector_no_collect_c.png`
- Original generated source: `/Users/yangjinhwan/.codex/generated_images/019ea01b-c5a4-7221-9bec-4bf18c6d6b9b/ig_074307d85160231d016a24f31e6654819190a76a06e41806d7.png`
