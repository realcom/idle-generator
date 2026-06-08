# Ninja2 Housing Bottom Loop Dock B

## Intent

`system-design-v0.md`의 HousingHome 하단 규칙을 Phaser 구현 기준으로 재정의한 시안. 기본 홈 상태에서는 `빠른 수령`, `동료 3슬롯`, `선택 건물 inspector`, `탐험 출발`, `5개 하단 탭`을 한 화면 아래쪽에 묶어 전투-귀환-강화 루프를 즉시 보이게 한다.

## Art Anchor

- `ninja2_rulelocked_housing_home_a`의 성소 헥스 보드, 등불 신전, 숲 배경, 굵은 잉크 외곽선을 유지한다.
- 하단 재료는 기존 runtime asset인 parchment panel, orange sortie CTA, generated home building sprites, companion color chips를 우선 재사용한다.
- 색상 축은 parchment cream, lantern gold, soul teal, forest green, action orange를 유지한다.

## Composition Rules

- Portrait 9:16 기준이며 중앙 헥스 보드가 하단 UI에 눌려 보이지 않도록 하단 패널은 compact inspector로 제한한다.
- 하단 위 레이어에는 동료 3명 shortcut strip을 둔다. 성소 홈의 동료 존재감을 유지하되, 보드 중앙을 가리지 않는다.
- 하단 action row는 좌측 quick collect, 중앙 selected building panel, 우측 sortie CTA의 3기능 구조다.
- 기본 상태에서는 sortie CTA가 가장 강한 색과 크기를 가진다.
- 건물 선택 상태에서는 selected building panel과 upgrade/build button이 강해지고, sortie CTA는 우측 고정 액션으로 유지한다.
- 하단 navigation dock은 D1 loop noun 기준으로 `성소`, `동료`, `탐험`, `임무`, `상점` 5개만 둔다. `가방`은 MVP 고정 탭에서 제외한다.

## UI Direction

- Quick collect는 작은 독립 카드로, resource bubble과 ready/idle 상태를 native text로 표시한다.
- Selected building panel은 parchment 9-slice skin 위에 thumbnail, building name, level/progress, two stat chips, upgrade/build button을 live DOM으로 올린다.
- Companion strip은 원형 속성 칩 + 짧은 이름 + 상태 dot 중심으로 유지한다.
- Bottom tabs는 stable equal-width icon-first buttons이며 selected tab은 lantern gold fill, inactive tab은 dark wood/ink fill을 사용한다.
- Orange sortie CTA는 fixed sprite로 유지하고 9-slice로 늘리지 않는다.

## Implementation Notes

- Implement in `harness/runtime/survivor-runtime.html` and `harness/runtime/src/survivor/survivor-app.js`.
- Reuse `.home-companions`, `.home-bottom`, `.home-panel`, `.home-tab-sortie`, and `.home-tabs`; do not add a full-screen mock overlay.
- Add a live `.home-quick-collect` button in the bottom action row. It may call the existing home income tick and pulse resource rows without creating a new economy contract.
- Keep `#homePanelSkinStage` drawing only the selected building parchment panel; quick collect and sortie remain native/CSS/fixed sprite.
- Update Phaser UI spec and component blueprint from 6 tabs to 5 tabs.

## Target Runtime Notes

- Preview URL: `harness/runtime/survivor-runtime.html?game=ninja2&homeDemo=city`.
- Target mobile shell: 430-440px wide, full viewport height.
- Bottom panel must not push `--home-board-bottom` beyond the current board clearance unless QA shows expansion cost overlap.
- At compact width, shrink tab icons/labels before allowing Korean labels to wrap.

## Source Image Link

- Raster concept: `harness/design/ninja2/concepts/ninja2_housing_bottom_loop_dock_b.png`
- Original generated source: `/Users/yangjinhwan/.codex/generated_images/019ea01b-c5a4-7221-9bec-4bf18c6d6b9b/ig_09da07c076740558016a24e4dc57608191a82caab41685eff5.png`
