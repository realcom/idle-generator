# Ninja2 Housing Top Bottom Tabs Arcade A

## Intent

Re-skin the housing home top and bottom UI around the current multi-hex base screen. The goal is to make the shell feel closer to a polished casual mobile game: chunky, tactile, icon-first, and strongly framed without hiding the owned-base board.

## Art Anchor

- Preserve the lantern sanctuary identity: warm parchment, dark ink outlines, lantern gold, soul teal, and action orange.
- Use the current multi-hex housing board as the center playfield.
- Capture the example image's broad mobile-game grammar: bold top information band, compact resource chips, large bottom action panel, and strong selected bottom tab.

## Composition Rules

- Top UI is a three-part band: guardian portrait, 2x2 resource board, people/menu stack.
- Shrine status sits as a separate centered plaque under the resource board.
- Side utility buttons remain on the left but should read as secondary tabs.
- Bottom UI has a selected-building card and a large sortie CTA in one row.
- Bottom navigation uses six fixed tabs with one lantern-gold selected state and dark inactive states.
- Board remains visible between top and bottom masks; avoid covering the central shrine cluster.

## UI Direction

- Resource chips: dark rounded rectangles with cream plus buttons.
- Top and bottom controls: 4px dark outline, hard cartoon shadow, inner highlight.
- Selected nav tab: lantern-gold fill with dark icon outline.
- Inactive nav tabs: dark brown/black fill with cream icon stroke.
- Sortie CTA: orange, oversized, tactile, separated from normal nav tabs.

## Implementation Notes

- Implement as Phaser/HTML/CSS, not as a full-screen mock image.
- Reuse existing DOM regions: `.home-top`, `.home-status`, `.home-bottom`, `.home-tab`, and `.sortie-button`.
- Use lucide-style or CSS icon masks where possible; keep Korean labels as live text.
- Maintain fixed tab dimensions so Korean labels do not resize the dock.
- The top status plaque can replace the current small centered status card, but it should keep the light progress bar.

## Target Runtime Notes

- Target viewport: mobile portrait around 430x932.
- Keep `survivor-runtime.html?game=ninja2` as the preview URL.
- The bottom panel should not push the board upward further than the current layout; instead, mask and frame the bottom edge.

## Source Image Link

- Raster concept: `harness/design/ninja2/concepts/ninja2_housing_top_bottom_tabs_arcade_a.png`
- Generated with `gen-ui-concept` workflow using the current `/tmp/ninja2-footprint-layout-v3.png` runtime screenshot as the center-board reference and an imagegen prompt for the top/bottom tab styling direction.
