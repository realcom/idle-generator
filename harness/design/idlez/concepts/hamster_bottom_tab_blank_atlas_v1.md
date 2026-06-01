# Hamster Bottom Tab Blank Atlas V1

Generated compact bottom navigation button bodies for the Phaser mobile harness.

## Purpose

- Replace the wide tab bodies from `hamster_button_blank_atlas_v1`, which were being squeezed into a six-column mobile nav.
- Keep the bottom nav visually tied to the growth dock without competing with the reward CTA.
- Preserve separate selected, inactive, and pressed states so Phaser/CSS can respond without repainting text into the bitmap.

## Runtime Exports

- `harness/runtime/assets/ui/buttons/btn_bottom_tab_gold.png`
- `harness/runtime/assets/ui/buttons/btn_bottom_tab_gold_pressed.png`
- `harness/runtime/assets/ui/buttons/btn_bottom_tab_wood.png`
- `harness/runtime/assets/ui/buttons/btn_bottom_tab_wood_pressed.png`

## Adaptation Notes

- Source atlas uses magenta key color and should be alpha-cleaned before runtime use.
- Runtime export size is `180x126`, then CSS stretches it into narrow mobile tabs with `background-size: 100% 100%`.
- Labels remain live HTML text for localization and state changes.
