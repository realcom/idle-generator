# Sprite Animation Process

2D sprite animation should be produced as a pose-locked strip, not as a set of
independent frame images. The goal is to preserve character identity while
making the silhouette change enough to read as an action.

## Failure Mode

The common bad result is:

- every frame has a similar full-body silhouette
- feet or props drift by a few pixels without a clear contact pose
- bottom alignment is corrected after generation, but the walk still reads as
  shaking because the legs never carry the body
- small props, such as lanterns, move frame-by-frame without a deliberate arc
- a regenerated full sheet has better poses but changes the character's face,
  head-to-body ratio, or costume read

Reverting to an older generated sheet usually does not fix this. It only swaps
one version of the same generation failure for another.

## Identity Gate

For a main character, identity is a hard gate before animation quality:

- face, head size, body ratio, palette, and costume read must match the approved
  in-game sprite
- frame 1 of each row must be visually continuous with the shipped idle/static
  sprite
- a full redraw that improves walking but changes the character is rejected
- do not bind a candidate to runtime until identity is accepted separately from
  motion QC

If identity drift appears, stop full-sheet regeneration for that character. Move
to a locked-face/locked-torso workflow: simple part rig, masked limb edit,
hand-painted correction, or bone/Spine-style animation.

## Production Flow

1. Pick one approved in-game seed frame per facing direction.
2. Write a pose contract before image generation or painting.
3. Block the key poses as editable pose data before polishing pixels.
4. For main characters, lock the face and torso first. Prefer a part rig or
   masked edit over a full redraw.
5. Generate or edit the animation as one strip or full sheet, not isolated
   frames.
6. Normalize the whole strip with one shared scale and one shared bottom-center
   anchor.
7. Lock the seed/contact frame back to the approved sprite if continuity matters.
8. Run identity review, sprite animation QC, and preview GIFs.
9. Bind to runtime only after the sheet passes both identity and motion gates.

For a side walk, the minimum practical workflow is:

1. Build a visible blocking strip with colored/contact guides.
2. Review only the foot order and crossing first. If leg identity is ambiguous,
   make a proof strip that labels left/right legs separately from front/back
   draw order.
3. Bake the same pose data without guides as a rough paint candidate.
4. Polish the legs/boots while keeping the pose data unchanged.
5. Re-run the same QC and GIF review.

This keeps the question clear: first "are the legs walking?", then "does it
match the art style?" Avoid mixing those into one full-sheet image generation
step.

## Pose Contract

For an 8-frame walk cycle, require clear key poses instead of eight near-copies:

| frame | pose intent | required read |
| --- | --- | --- |
| 1 | contact A | one foot visibly planted, opposite foot back |
| 2 | down/recoil | body compresses slightly, planted foot stable |
| 3 | passing | rear foot passes under body |
| 4 | up/recovery | body rises, cloak/scarf counter-swing |
| 5 | contact B | opposite foot visibly planted |
| 6 | down/recoil | mirrored compression |
| 7 | passing | first foot passes under body |
| 8 | up/recovery | returns cleanly into frame 1 |

Direction-specific notes:

- Down/front: feet must separate outside the cloak, cloak hem opens/closes, and
  handheld props swing on a readable left/right arc.
- Side: front/back feet must cross clearly. A side row with only cloak wobble is
  not enough.
- Up/back: feet may be partially hidden, so cloak hem, scarf knot, hand, and prop
  need stronger counter-motion.

## QC Gate

Run:

```bash
python3 harness/tools/sprite_anim_qc.py \
  --sheet harness/runtime/assets/<game>/battle/animations/<sheet>.png \
  --rows <rows> \
  --cols <frames> \
  --frame-width <w> \
  --frame-height <h> \
  --row-names down,left,up \
  --out-dir harness/build/animation-qc/<sheet>
```

Default warnings are tuned for a main character walk cycle:

- `silhouette mean < 0.105`: pose silhouette is too similar between frames
- `lower mean < 0.13`: legs/feet are not carrying the walk
- `baseline range > 3px`: foot baseline drift
- `warm prop has abrupt frame drift`: lantern-like prop jumps instead of swinging

Runtime binding should wait until the report has no warnings for shipped rows, or
until each warning is accepted deliberately with a visual reason.

## Prompt Requirements

When AI image generation is used, the prompt must include:

- exact grid: row count, frame count, frame size, and direction order
- fixed bottom-center anchor and unchanged frame boxes
- no camera movement, no per-frame scale change, no body slide
- explicit contact/passing/up/down poses
- one planted foot per contact pose
- prop motion described as a pendulum arc, not random drift
- no labels, scenery, shadows, or extra characters

If the model cannot keep the character stable and create readable key poses at
the same time, prefer a simple part rig or hand-painted correction pass over
another full-sheet regeneration.
