# Growstone2 Assets

This is the canonical asset root for Growstone2 / Taskstonebar.

`harness/assets/growstone2` is kept only as a legacy symlink for older scripts and should not be used in new references.

## Layout

- `runtime/`: curated, ASCII-only assets that game content and runtime code may reference directly.
- `generated/`: generated candidates and derived assets that have not all been promoted to `runtime/`.
- `source/`: small imported prototype sources already used by the runtime seed.
- `effect/`: currently referenced legacy effect sprites. Keep new effect references ASCII and promote them into `runtime/effects/` when touched.
- `raw/original/`: unnormalized legacy import dumps, including Korean-named folders and source-art files.

## Layout Policy

- Keep authored or imported game assets under this root, not under `harness/`.
- Prefer ASCII, lowercase, hyphenated or underscored paths for all new curated runtime assets.
- Treat existing Korean-named folders as raw legacy imports until they are normalized into curated runtime paths.
- Keep generated assets under `generated/` until a build step promotes them into a stable runtime package.
- Keep `asset-registry.yaml` beside the assets it describes.

## Migration Notes

- Current runtime lookup checks `assets/growstone2` before the old harness symlink.
- Content YAML should use `assets/growstone2/...` for file-backed asset fields.
- Unit sprite YAML should reference `runtime/units/...`, not `raw/original/unit/...`.
- Do not edit files under `harness/assets/growstone2`; it points back here.
