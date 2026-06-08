# Phaser Effect Lab

`phaser-fx-lab.html` is a Phaser effect review and detail-tuning surface for the loop where an AI writes an effect recipe, a human verifies and tweaks it in the browser, and only approved recipes move toward runtime binding.

## Workflow

1. Ask an AI to produce one `EffectRecipe` JSON object using the authoring prompt in the lab.
2. Paste the AI result into the JSON panel and load it.
3. Tune intensity, scale, speed, playback mode, and inspection background.
4. Adjust individual emitter or graphics layers in the layer stack.
5. Preview the effect on the Phaser combat fixture.
6. Export a sprite-sheet PNG when an animation strip is useful for downstream review.
7. Mark the recipe approved or needs work, and copy a fix prompt when it should go back to AI.
8. Copy or export the approved JSON for the next binding step.

## Runtime

```bash
python3 -m http.server 8765
```

Open:

```text
http://127.0.0.1:8765/harness/runtime/phaser-fx-lab.html
```

## Verification

```bash
node --check harness/runtime/src/fx-lab/effect-recipes.js
node --check harness/runtime/src/fx-lab/effect-renderer.js
node --check harness/runtime/src/fx-lab/fx-lab-app.js
python3 harness/tools/phaser_smoke.py mushroomer --skip-compile --runtime harness/runtime/phaser-fx-lab.html --expect ui --screenshot /private/tmp/phaser-fx-lab.png
```

## Recipe Shape

The MVP recipe is intentionally small and Phaser-facing:

```json
{
  "schemaVersion": 1,
  "id": "spore_bloom",
  "name": "Spore Bloom",
  "durationMs": 1500,
  "loop": false,
  "palette": ["#8be36d", "#f7d66a", "#ffffff"],
  "emitters": [],
  "graphics": [],
  "review": { "status": "draft", "notes": "" }
}
```

Use `emitters` for Phaser particles and `graphics` for readable authored shapes such as rings, beams, slash arcs, glyphs, and shockwaves.

## Layer Editing

The layer stack edits the current recipe in-place:

- emitter layers expose mode, anchor, texture, blend, quantity, frequency, delay, duration, and tint list
- graphics layers expose shape, anchor, stroke, end radius, delay, duration, and color
- layer add, duplicate, delete, and within-kind move controls update the JSON panel immediately

## Human Review Loop

`Copy Fix Prompt` builds a revision prompt from the current recipe, review notes, and the selected layer. Use it when the effect is close but needs another AI pass for timing, readability, palette, or layer cleanup.

## Golden Samples

The lab includes 15 canonical sample recipes plus 3 legacy samples:

- normal hit, critical hit, slash, dash cut, projectile, heavy shockwave
- heal, caster aura, shield, poison, burn, freeze
- AoE warning, delayed explosion, ultimate burst

Each canonical sample carries review notes describing what is good, what commonly fails, and what to tune first. The AI authoring prompt also includes a compact golden-sample guide so new effects are biased toward these readable mobile combat patterns.

## Game Skill Drafts

The lab also includes 16 ninja2 skill FX draft recipes sourced from the current `harness/content/ninja2/skills/_drafts` skill pool. These presets are review-time EffectRecipe drafts only:

- basic attacks: kunai slash, shuriken barrage
- control and elemental skills: smoke bomb, lightning kunai, fire scroll, frost needle, weakness mark
- repeated/area skills: orbit shuriken, shadow clone, moon flash, bamboo spear rain, black lotus storm
- self-buffs: shadow breath, killing focus, time fold, gale steps

Each ninja2 draft includes `sourceSkill` metadata with the skill id, role, tier, sprite path, and hit/buff timing summary. They are meant to calibrate AI output against the actual skill fantasy before a future compiler path binds approved effects back to skill data.

## Sprite Sheet Export

The sprite-sheet exporter replays the current recipe in one-shot mode, captures the Phaser canvas over time, packs the frames into a PNG grid, and can copy a small metadata block containing frame size, frame count, columns, rows, FPS, and scale.

## Next Binding Step

Approved recipes should eventually live under:

```text
harness/content/<game>/effects/*.effect.yaml
```

Then the content compiler can emit an `Effects.json` bundle or embed effect ids into `Skills.json`. Until that compiler path exists, the lab is a standalone review and export tool.
