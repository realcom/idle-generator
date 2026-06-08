# Phaser 9-Slice UI Policy

Purpose: decide when a generated UI skin should become a Phaser 9-slice object, and keep the same cap insets reusable for Unity sliced sprites.

## Decision

Use Phaser 9-slice only when all are true:

- The asset is a rectangular UI skin: panel, modal frame, button body, dock, tab, card, chip, toast, slot frame, or progress-bar frame.
- The same skin must render at multiple sizes or aspect ratios.
- Text, numbers, icons, badges, timers, prices, and localized labels are native runtime objects, not baked into the bitmap.
- Corners and edge caps contain the important bevel, outline, shadow, or ornament; the center can stretch or tile without visible distortion.
- `slice_hints` are known and valid: `left + right < width`, `top + bottom < height`.
- Text/icon layout uses separate `content_insets`; do not reuse `slice_hints` as padding.
- Phaser runs WebGL. This harness uses Phaser 4.1, so native `scene.add.nineslice(...)` is the default.

Do not use Phaser 9-slice for:

- Characters, monsters, buildings, pets, weapons, pickups, icons, portraits, VFX, background art, hex tiles, maps, sprite sheets, or atlases.
- Irregular silhouettes where corners are not fixed rectangular caps.
- Images with central illustration, strong gradients, noise, symbols, or shadows that would visibly stretch.
- Border/corner/crest/vine/badge ornaments that are not stretch-safe. Put these in a fixed ornament sprite layer from `component-blueprints.yaml` instead.
- DOM-only layout skins. CSS may be used for debug or preview, but not as the production 9-slice path.
- Very small fixed-size widgets where a plain sprite or native Phaser graphics is simpler and more stable.

## Routing

| Surface | Preferred implementation |
| --- | --- |
| Modal/panel/card/dock/button/tab/chip skin | `phaser_nineslice` |
| Fixed border ornaments, crests, corner leaves, clasps, vines | Image/sprite overlay from `component-blueprints.yaml` ornament layer |
| Simple solid rounded box, pill, separator, cooldown ring | Phaser graphics |
| Fixed icon, portrait, badge, pickup, building | Image/sprite |
| Background/scene art | Image, CSS background, or Phaser image cover |
| Hex tile or non-rectangular board tile | State-specific image/mask, not 9-slice |
| Text-heavy form/debug UI | DOM/CSS overlay |
| Unity shared UI skin | Same PNG plus `unity.usage: sliced_sprite` |

## Asset Plan Contract

9-slice-capable assets in `harness/design/<game>/asset-plan.yaml` should use:

```yaml
type: nine_slice_panel # or button_skin, dock_skin, card_skin, tab_skin, chip_skin
mode: hybrid
platforms: [phaser, unity]
background: transparent
slice_hints: { left: 28, right: 28, top: 28, bottom: 28 }
component_contract:
  slice_hints: "Bitmap stretch borders only."
  content_insets:
    ExamplePanel: { left: 14, right: 14, top: 18, bottom: 14 }
phaser:
  usage: phaser_nineslice
  target_path: harness/runtime/assets/<game>/ui/<asset>.png
unity:
  usage: sliced_sprite
  target_path: engine/client/Client/Assets/Resources/HarnessPreview/GeneratedSprites/<asset>.png
  slice_hints: { left: 28, right: 28, top: 28, bottom: 28 }
```

Keep state variants as separate keys or files when their cap geometry changes, such as `normal`, `pressed`, `selected`, and `disabled`.

For asset entries that intentionally bundle several UI skin PNGs, use `phaser.usage: phaser_nineslice_set`, `unity.usage: sliced_sprite_set`, and name each inset group under `slice_hints`.

For non-stretch-safe decorative attachments, use a separate fixed asset entry:

```yaml
type: frame_ornament_set
mode: hybrid
background: transparent
slice_hints: null
phaser:
  usage: image_sprite_set
```

Then reference it from `harness/design/<game>/component-blueprints.yaml` as an `ornament_layer`.

## Phaser Runtime Contract

Use native Phaser 4.1 WebGL 9-slice:

```js
const skin = scene.add.nineslice(
  x,
  y,
  textureKey,
  null,
  width,
  height,
  left,
  right,
  top,
  bottom
);
```

Runtime helpers may wrap this call, but they must preserve `slice_hints` from the asset plan. Use cached canvas slicing only as a deliberate legacy fallback, and document that fallback in the spec.

## Validation

Run the static audit after adding or changing candidate skins:

```bash
python3 harness/tools/phaser_nineslice_audit.py <game>
```

For visual surfaces, also run the relevant Phaser smoke and screenshot:

```bash
python3 harness/tools/phaser_smoke.py <game> --skip-compile --runtime harness/runtime/phaser-ui-harness.html --expect ui --screenshot /private/tmp/<game>-ui.png
```

Check at least three sizes when possible: compact mobile, target mobile, and an oversized modal/panel. Corners must remain crisp, edge bevels must not warp, text must not be baked into the skin, and the center stretch must not smear important art.

For blueprint-backed UI, also run:

```bash
python3 harness/tools/design_blueprint_validate.py <game>
```
