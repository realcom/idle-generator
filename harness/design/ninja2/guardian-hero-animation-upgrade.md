# Guardian Hero Animation Upgrade

## Current Finding

The current protagonist walk does not need a rollback. Older sheets show the
same class of issue: either the silhouette barely changes, or the foot baseline
drifts enough to feel floaty.

A full-sheet regeneration attempt on 2026-06-07 produced stronger poses, but it
changed the guardian's face and head-to-body ratio. That candidate is rejected.
For this protagonist, better walking motion is not enough; the approved
character identity must remain intact.

Static direction PNGs such as `battle/directions/guardian_hero/down.png` are
also not valid animation seeds because their alpha bounds touch the bottom edge.
Use the 512x512 cells from `guardian_hero_walk_3x8.png` as the identity source;
those cells keep the current in-game face/body read and have safe bottom
padding.

Measured with:

```bash
python3 harness/tools/sprite_anim_qc.py \
  --sheet harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_3x8.png \
  --rows 3 \
  --cols 8 \
  --frame-width 512 \
  --frame-height 512 \
  --row-names down,left,up \
  --out-dir harness/build/animation-qc/guardian_hero_walk_3x8
```

| sheet | result |
| --- | --- |
| `guardian_hero_walk_3x8.png` | stable baseline, but down/left have low silhouette change; left also has low lower-body change |
| `guardian_hero_walk_4x8.png` | most rows have low silhouette/lower-body change; up row has abrupt warm-prop drift |
| `guardian_hero_walk_4x4.png` | stronger pose change, but foot baseline drifts 8-9px |
| `guardian_hero_walk_identity_v1.png` | safe identity-preserving warp candidate; slightly improves lower motion, but down/left still fail silhouette QC |
| `guardian_hero_walk_identity_v2.png` | stepped-contact variant of v1; reduces rubbery timing a little, but still fails down/left silhouette QC |
| `guardian_hero_walk_identity_v5.png` | keeps v2 down row and replaces left/up with a 7-frame AI edit repacked to 8 frames; left reads much better, up still needs review |
| `guardian_hero_walk_identity_v6.png` | left-foot contact upgrade over v5; side row now passes foot-contact QC, while up still needs a separate fix |
| `guardian_hero_walk_identity_v10.png` | current left-leg candidate: keeps the v5 upper body, transfers only lower-leg pixels from an AI side-row edit so the two legs alternate forward/back |
| `guardian_hero_walk_left_rig_v1.png` | first rough pose-data bake from `ninja2_guardian_left_walk_rig.py`; useful as a blocking baseline |
| `guardian_hero_walk_left_rig_v4.png` | proof/debug side-row rig; left/right leg identity is explicit, and frames 4-6 put the right leg forward in the left-facing row, but this is not usable final art |
| `guardian_hero_walk_left_graft_v2.png` | conservative usable side-row candidate, but the right-leg-forward read is still too subtle |
| `guardian_hero_walk_left_graft_v6.png` | current right-leg-forward candidate; keeps v5 upper/body pixels, pushes the old screen-right leg back, and grafts original boot/pants pixels forward in frames 4-6 |
| `guardian_hero_left_walk_genimage_frames_v1_sheet.png` | genimage-only test using eight separately generated frames; bottom alignment is stable, but the right-leg-forward read is still ambiguous |
| `guardian_hero_left_walk_genimage_frames_v2_sheet.png` | genimage-only follow-up that regenerates frames 4-6 one by one with a stronger right-leg-forward prompt; QC has no warnings, but visual review is still required before any runtime binding |
| `guardian_hero_left_walk_genimage_frames_v3_sheet.png` | genimage-only motion proof using eight newly generated frames; feet/stride are finally visible, but the character identity and body ratio drift too far for runtime use |
| `guardian_hero_left_walk_frame5_edit_target_rejected_v1.png` | target-edit attempt from the approved frame 5; generated a clearer stride, but still redrew the character and changed proportions, so rejected |

Review artifacts:

- `harness/build/animation-qc/guardian_hero_walk_3x8/report.md`
- `harness/build/animation-qc/guardian_hero_walk_3x8/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_4x8/report.md`
- `harness/build/animation-qc/guardian_hero_walk_4x8/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_4x4/report.md`
- `harness/build/animation-qc/guardian_hero_walk_4x4/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_identity_v1/report.md`
- `harness/build/animation-qc/guardian_hero_walk_identity_v1/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_identity_v2/report.md`
- `harness/build/animation-qc/guardian_hero_walk_identity_v2/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_identity_v5/report.md`
- `harness/build/animation-qc/guardian_hero_walk_identity_v5/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_identity_v6/report.md`
- `harness/build/animation-qc/guardian_hero_walk_identity_v6/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_identity_v10/report.md`
- `harness/build/animation-qc/guardian_hero_walk_identity_v10/contact_sheet.png`
- `harness/build/animation-blocking/guardian-left-walk-v1/tool-overlay/left_overlay.gif`
- `harness/build/animation-qc/guardian_hero_walk_left_rig_v1/report.md`
- `harness/build/animation-qc/guardian_hero_walk_left_rig_v1/contact_sheet.png`
- `harness/build/animation-blocking/guardian-left-walk-v4/proof/left_proof.gif`
- `harness/build/animation-blocking/guardian-left-walk-v4/proof/left_proof_strip.png`
- `harness/build/animation-qc/guardian_hero_walk_left_rig_v4/report.md`
- `harness/build/animation-qc/guardian_hero_walk_left_rig_v4/contact_sheet.png`
- `harness/build/animation-blocking/guardian-left-walk-v6/proof/left_proof.gif`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v2/report.md`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v2/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v2/left_graft.gif`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v2/left_v5_vs_graft_v2.gif`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v6/report.md`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v6/contact_sheet.png`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v6/left_graft.gif`
- `harness/build/animation-qc/guardian_hero_walk_left_graft_v6/left_v5_vs_graft_v6.gif`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v1/left_genimage.gif`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v1/left_genimage_strip.png`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v1/qc/report.md`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v2/left_genimage.gif`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v2/left_genimage_strip.png`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v2/v1_vs_v2_strip.png`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v2/qc/report.md`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v3/left_genimage.gif`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v3/left_genimage_strip.png`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v3/genimage_attempts_comparison.png`
- `harness/build/animation-qc/guardian_hero_left_walk_genimage_frames_v3/qc/report.md`

## Upgrade Target

Keep the 3-direction runtime contract for now:

- row 1: down
- row 2: left/side
- row 3: up
- right movement mirrors the side row in Phaser
- 8 frames per row
- 512x512 frame cells
- fixed bottom-center anchor

The next production candidate should be named as a new versioned asset, for
example `guardian_hero_walk_pose_v1.png`, and only replace the runtime binding
after QC and visual review.

Do not create the next candidate by full-character sheet regeneration. Use an
identity-locked method:

- keep the approved face/head/torso pixels or shapes as the source of truth
- animate only legs, cloak hem, scarf tail, hand, and lantern
- if AI is used, use masked edits around movable parts rather than a full redraw
- if the model changes the face or body ratio, reject the candidate even if the
  motion scores improve

The current safe candidates are:

- smooth v1: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_identity_v1.png`
- stepped v2: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_identity_v2.png`
- mixed v5: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_identity_v5.png`
- left-foot v6: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_identity_v6.png`
- lower-leg transfer v10: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_identity_v10.png`
- pose-rig v1: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_left_rig_v1.png`
- proof pose-rig v4: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_left_rig_v4.png`
- usable graft v2: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_left_graft_v2.png`
- right-forward graft v6: `harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_left_graft_v6.png`
- builder:
  - `python3 harness/tools/ninja2_guardian_identity_walk.py --variant smooth|stepped`
  - `python3 harness/tools/ninja2_guardian_identity_walk.py --variant left-feet --left-feet-scale 1.2 --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v6.png`
  - `python3 harness/tools/ninja2_guardian_left_walk_rig.py --mode overlay --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/build/animation-blocking/guardian-left-walk-v1/guardian_hero_walk_left_block_overlay_v1.png --out-dir harness/build/animation-blocking/guardian-left-walk-v1/tool-overlay`
  - `python3 harness/tools/ninja2_guardian_left_walk_rig.py --mode paint --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/design/ninja2/assets/battle/animations/guardian_hero_walk_left_rig_v1.png --out-dir harness/build/animation-qc/guardian_hero_walk_left_rig_v1`
  - `python3 harness/tools/ninja2_guardian_left_walk_rig.py --mode proof --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/build/animation-blocking/guardian-left-walk-v4/guardian_hero_walk_left_proof_v4.png --out-dir harness/build/animation-blocking/guardian-left-walk-v4/proof`
  - `python3 harness/tools/ninja2_guardian_left_walk_rig.py --mode paint --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/design/ninja2/assets/battle/animations/guardian_hero_walk_left_rig_v4.png --out-dir harness/build/animation-qc/guardian_hero_walk_left_rig_v4`
  - `python3 harness/tools/ninja2_guardian_left_walk_graft.py --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/design/ninja2/assets/battle/animations/guardian_hero_walk_left_graft_v2.png --out-dir harness/build/animation-qc/guardian_hero_walk_left_graft_v2`
  - `python3 harness/tools/ninja2_guardian_left_walk_graft.py --input harness/design/ninja2/assets/battle/animations/guardian_hero_walk_identity_v5.png --out harness/design/ninja2/assets/battle/animations/guardian_hero_walk_left_graft_v6.png --out-dir harness/build/animation-qc/guardian_hero_walk_left_graft_v6`

Do not use a full generated side-row replacement directly unless identity is
reviewed again. The 2026-06-07 AI side-row edit produced useful alternating
leg poses, but changed too much of the upper body when used as a full row.
`identity_v10` uses that edit only as a lower-leg source and keeps the v5
upper body in place.

They are not runtime-bound yet. They are useful as review baselines, but not a
final answer to the walk problem.

Current recommendation: use `guardian_hero_walk_left_graft_v6.png` as the
right-leg-forward review candidate, while keeping `guardian_hero_walk_left_rig_v4`
as a proof/debug artifact only. The proof rig establishes the leg order: in the
left-facing row, smaller x is forward, and frames 4-6 put the right leg forward.
The v2 graft was too conservative and still read as if the right leg stayed
back. The v6 graft pushes the old screen-right leg back and moves the grafted
boot/pants pixels farther forward. It is still not runtime-bound.

Genimage-only status, 2026-06-08: the one-frame-at-a-time v2 pass improved
frames 4-6 and removed foot-baseline drift after packing, but it should remain
a review artifact for now. The art was generated by genimage; local processing
only removed the chroma-key background, normalized the 512px cells, packed the
sheet, and produced GIF/QC outputs.

Follow-up on 2026-06-08: v3 proves that genimage can create a side walk with
visible feet when the prompt exaggerates contact poses. QC improved sharply
(`contact x range` 50.0px, `lower mean` 0.411), but the sprite is no longer the
approved protagonist. A visible-target edit from the approved frame also failed
the identity gate because the model redrew the body ratio. Do not runtime-bind
these genimage-only attempts without accepting a character redesign.

## Pose Requirements

Down row:

- frame 1 and frame 5 must show opposite contact feet
- boots should separate enough to change the outer silhouette
- cloak hem opens on passing frames and settles on contact frames
- lantern follows a smooth arc, roughly 14-24px across the cycle

Side row:

- contact poses must show one foot planted and the other clearly trailing
- passing frames must show the rear foot crossing under the body
- scarf and cloak counter-swing against the legs
- lantern should swing forward/back, not just slide with the body

Up row:

- feet can be partly hidden, but the cloak bottom must expose alternating foot
  shapes
- scarf knot and lantern hand need stronger counter-motion
- avoid sudden horizontal jumps in the lantern cluster

## Acceptance Gate

Before runtime binding:

```bash
python3 harness/tools/sprite_anim_qc.py \
  --sheet harness/runtime/assets/ninja2/battle/animations/guardian_hero_walk_pose_v1.png \
  --rows 3 \
  --cols 8 \
  --frame-width 512 \
  --frame-height 512 \
  --row-names down,left,up \
  --out-dir harness/build/animation-qc/guardian_hero_walk_pose_v1
```

Target:

- approved same-character review: face, head size, body ratio, scarf, cloak, and
  lantern read as the current guardian
- no `low silhouette change`
- no `low lower-body/foot change`
- no `foot baseline drift`
- no abrupt warm-prop drift
- visual GIFs read as walking before the sprite is judged by Phaser runtime

## Next Production Path

Preferred path:

1. Cut a simple part rig from the approved down/side/up sprites.
2. Lock head, face, torso, belt, and core cloak mass.
3. Animate only boots/legs, cloak hem, scarf tail, forearm, and lantern.
4. Bake the rig to a new 3x8 512px sheet.
5. Run identity review first, then `sprite_anim_qc.py`.

Fallback path:

1. Build a masked edit canvas per row from the approved sprite.
2. Keep the face/head/torso outside the edit mask.
3. Ask for contact/passing/up/down poses only in legs, cloak hem, scarf tail, and
   lantern.
4. Normalize and run the same QC gate.
