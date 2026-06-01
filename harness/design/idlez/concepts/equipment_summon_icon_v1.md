# Equipment Summon Icon V1

## Intent

Create a compact visual atom for the Phaser equipment summon CTA. The icon is meant to read instantly at button size, while the same button also carries the monster-soul cost.

## Art Anchor

- Gold-orange medallion frame from the selected hamster growth-dock button family.
- Open treasure chest, short sword, helmet, and purple monster-soul glow to communicate equipment summon without relying on text.
- Thick dark chocolate outline and toy-like highlights to match the current Phaser button set.

## Composition Rules

- Keep the icon square and centered.
- Preserve the large gold silhouette and purple soul core at small sizes.
- Do not bake labels, cost text, or button body into the image.
- Use the runtime export as a transparent PNG inside live HTML buttons.

## UI Direction

- The equipment summon CTA should be one button: summon icon, short label, and current/required monster soul count.
- Cost visibility belongs inside the button body so the CTA reads as a single action target.
- Disabled or unaffordable state should dim the whole button as one unit.

## Implementation Notes

- Concept PNG: `harness/design/idlez/concepts/equipment_summon_icon_v1.png`
- Runtime PNG: `harness/runtime/assets/ui/icons/equipment_summon_icon_v1.png`
- Source image was generated with imagegen, then alpha-cleaned from the generated checkerboard background.
- Original generated source: `/Users/yangjinhwan/.codex/generated_images/019e82c0-2b1f-74f0-82a8-5b51d9307c5a/ig_00e698b9be72ef61016a1d60a2381081919a187742948f139f.png`

## Source Image

![Equipment summon icon v1](equipment_summon_icon_v1.png)
