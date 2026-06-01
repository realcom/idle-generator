# Hamster Button Skin Sheet V1

## Intent

`hamster_portrait_combat_growth_dock_concept_d`의 버튼 재질을 분리한 component skin sheet. 전체 게임 화면이 아니라 Phaser/CSS/uGUI로 재사용할 버튼 atom 패밀리를 결정하기 위한 시안이다.

## Button Family

- Primary reward CTA: gold-orange glossy body, hamster medallion, dark cost pill.
- Green upgrade pill: coin medallion, thick green body, pressed state.
- Auto enhance: compact green square, hamster/mushroom icon area, two-line label.
- Side utility: vertical carved wood button with icon and alert badge option.
- Bottom tab: dock-integrated wood tray, active gold tab, inactive wood tab.
- Currency plus chip: dark wood capsule with coin/gem/seed medallion and plus knob.

## Implementation Notes

- All buttons share a dark chocolate outer stroke, inner highlight rim, and soft lower shadow.
- Pressed states should move down 1-2 px and deepen the lower rim.
- Korean labels should fit one or two short lines, never long descriptive text.
- Icons can be simplified in Phaser/CSS first, then replaced with sprite atoms later.

## Source Image

![Hamster button skin sheet v1](hamster_button_skin_sheet_v1.png)
