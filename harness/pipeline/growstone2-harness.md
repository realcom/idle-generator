# Growstone2 Harness

Growstone2 is authored as `taskstonebar` in this monorepo.

## Canonical Paths

- Profile: `harness/game-profiles/taskstonebar.profile.yaml`
- Content: `harness/content/taskstonebar/`
- Design: `harness/design/taskstonebar/`
- Godot runtime: `harness/runtime/godot-taskstonebar/`
- Asset root: `assets/growstone2/`
- Legacy asset symlink: `harness/assets/growstone2`

## Working Loop

1. Read the profile, content README, and relevant category `_index.yaml`.
2. Edit source YAML, design contract, asset registry, or Godot runtime files.
3. Keep generated build output under `harness/build/taskstonebar` untouched.
4. Run `python3 harness/tools/growstone2_harness.py verify`.
5. If Godot is unavailable, run `python3 harness/tools/growstone2_harness.py verify --skip-godot` and report the skipped runtime check.

## Content Status

- `draft`: newly generated candidate.
- `review`: current MVP mainline candidate; compile and smoke should pass.
- `approved`: user-approved final source. Move files out of `_drafts/` only after explicit approval.
- `bootstrap`: reserved system/currency item.

The current MVP mainline uses `review` status in category indexes while files remain in `_drafts/`. This keeps history intact until Godot QA and asset license checks are complete.

## Asset Policy

- New file-backed references should use `assets/growstone2/...`.
- `harness/assets/growstone2` exists only for legacy scripts.
- Curated runtime assets go under `assets/growstone2/runtime/`.
- Generated candidates stay under `assets/growstone2/generated/` until promoted.
- Korean-named legacy imports stay under `assets/growstone2/raw/original/` until normalized.
- `assets/growstone2/asset-registry.yaml` must pass `growstone2_harness.py audit-assets`.

## Runtime Smoke Contract

The baseline Godot smoke must start with three starter stones and clear map `500101`.

Expected smoke signals:

- `result=clear`
- `stones=3`
- `kills=43`
- no pending enemies

Use progression smoke to cover stone synthesis, equipment synthesis, drops, dynamic level-up, and skill level-up.

## Commands

```bash
python3 harness/tools/growstone2_harness.py status
python3 harness/tools/growstone2_harness.py compile
python3 harness/tools/growstone2_harness.py audit-assets
python3 harness/tools/growstone2_harness.py audit-assets --release
python3 harness/tools/growstone2_harness.py godot-smoke
python3 harness/tools/growstone2_harness.py verify
```
