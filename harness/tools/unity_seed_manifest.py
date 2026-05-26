#!/usr/bin/env python3
"""
Build a recursive dependency manifest for Unity YAML assets under a PatchResources-like tree.

Usage:
  python3 harness/tools/unity_seed_manifest.py \
      --root harness/examples/patchresources \
      Maps/MAP_MAKING_SCENE.unity \
      Maps/Prefabs/PFB_MAP_Meadow_Day_Chapter.prefab
"""

from __future__ import annotations

import argparse
import re
from collections import deque
from pathlib import Path


GUID_RE = re.compile(r"guid: ([0-9a-f]{32})")
TEXTUAL_RECURSE_EXTS = {
    ".prefab",
    ".unity",
    ".asset",
    ".mat",
    ".controller",
    ".anim",
    ".playable",
    ".overridecontroller",
    ".spriteatlasv2",
}
SKIP_EXTS = {".cs", ".dll", ".meta"}


def build_guid_index(root: Path) -> dict[str, Path]:
    guid_to_asset: dict[str, Path] = {}
    for meta_path in root.rglob("*.meta"):
        try:
            text = meta_path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue

        match = re.search(r"^guid: ([0-9a-f]{32})$", text, re.MULTILINE)
        if not match:
            continue

        asset_path = meta_path.with_suffix("")
        guid_to_asset[match.group(1)] = asset_path
    return guid_to_asset


def should_recurse(path: Path) -> bool:
    return path.suffix.lower() in TEXTUAL_RECURSE_EXTS


def extract_guids(path: Path) -> set[str]:
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return set()
    return set(GUID_RE.findall(text))


def resolve_dependencies(root: Path, seeds: list[Path]) -> tuple[list[Path], list[Path], list[str]]:
    guid_index = build_guid_index(root)
    missing_guids: set[str] = set()
    missing_files: list[Path] = []

    resolved: set[Path] = set()
    queue: deque[Path] = deque()

    for seed in seeds:
        seed_path = root / seed
        if not seed_path.exists():
            missing_files.append(seed_path)
            continue
        queue.append(seed_path)

    while queue:
        path = queue.popleft()
        if path in resolved:
            continue
        resolved.add(path)

        if not should_recurse(path):
            continue

        for guid in extract_guids(path):
            asset_path = guid_index.get(guid)
            if asset_path is None:
                missing_guids.add(guid)
                continue

            if asset_path.suffix.lower() in SKIP_EXTS:
                continue

            if asset_path not in resolved:
                queue.append(asset_path)

    ordered_assets = sorted(resolved)
    ordered_meta: list[Path] = []
    for asset_path in ordered_assets:
        meta_path = asset_path.with_suffix(asset_path.suffix + ".meta")
        if meta_path.exists():
            ordered_meta.append(meta_path)

    return ordered_assets, ordered_meta, sorted(missing_guids)


def main() -> int:
    parser = argparse.ArgumentParser(description="Resolve recursive Unity YAML dependencies inside a PatchResources tree.")
    parser.add_argument("--root", required=True, help="PatchResources-like directory root")
    parser.add_argument("seeds", nargs="+", help="Seed asset paths relative to --root")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    seed_paths = [Path(seed) for seed in args.seeds]

    assets, metas, missing_guids = resolve_dependencies(root, seed_paths)

    print(f"# Root: {root}")
    print("# Seeds:")
    for seed in seed_paths:
        print(seed.as_posix())

    print("\n# Assets")
    for asset in assets:
        print(asset.relative_to(root).as_posix())

    print("\n# Meta")
    for meta in metas:
        print(meta.relative_to(root).as_posix())

    if missing_guids:
        print("\n# Missing GUIDs")
        for guid in missing_guids:
            print(guid)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
