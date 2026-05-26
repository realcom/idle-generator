#!/usr/bin/env python3
"""
Sync a minimal live PatchResources seed for a compiled game slice.

This script copies:
1. compiled JSON bundles from harness/build/<game>/
2. boot/config seed files from harness/examples/patchresources/
3. static engine compile/runtime prerequisites
4. transitive Unity asset dependencies for the compiled slice
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from pathlib import Path

from unity_seed_manifest import resolve_dependencies


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BUILD_ROOT = ROOT / "build"
DEFAULT_EXAMPLE_ROOT = ROOT / "examples" / "patchresources"
DEFAULT_PATCH_ROOT = ROOT.parent / "engine" / "client" / "Client" / "Assets" / "PatchResources"

BUILD_OUTPUTS = [
    "Units.json",
    "Items.json",
    "Skills.json",
    "Buffs.json",
    "Maps.json",
    "Strings.json",
    "Achievements.json",
    "Audios.json",
    "Triggers.json",
]

BOOT_FILES = [
    "GameConfig.json",
    "BannedKeywords.txt",
    "ResourceGlobals.json",
]

STATIC_FILES = [
    "ClientScriptableSingleton.cs",
    "CRC.cs",
    "CRC.asset",
    "CRCExtension.cs",
    "CRCExtension.asset",
    "ClientBubbleTextDefine.cs",
    "ClientBubbleTextDefine.asset",
    "LobbyHUDLayoutDefine.cs",
    "LobbyHUDLayoutDefine.asset",
]

STATIC_DIRS = [
    "Items/UI",
    "UIAssets/ButtonSprites",
]

STATIC_UNITY_SEEDS = [
    "Units/GameUnitObject.prefab",
    "Units/Characters/PFB_HAM_Blacksmith.prefab",
]

KNOWN_ASSET_PREFIXES = (
    "Maps/",
    "Units/",
    "FXPrefabs/",
    "Sounds/",
    "Items/",
    "UIAssets/",
    "Buffs/",
)

OPTIONAL_SCENE_PREFIX = "Maps/"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Sync minimal PatchResources assets for a compiled game slice.")
    parser.add_argument("game", help="Game key, e.g. mushroomer")
    parser.add_argument("--build-root", default=str(DEFAULT_BUILD_ROOT), help="Path to harness build root")
    parser.add_argument("--example-root", default=str(DEFAULT_EXAMPLE_ROOT), help="Path to example PatchResources seed root")
    parser.add_argument("--patch-root", default=str(DEFAULT_PATCH_ROOT), help="Path to live PatchResources root")
    return parser.parse_args()


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def copy_file(src: Path, dst: Path, copied: list[str], skipped: list[str]) -> None:
    if not src.exists():
        raise FileNotFoundError(src)

    ensure_parent(dst)
    if dst.exists() and src.read_bytes() == dst.read_bytes():
        skipped.append(str(dst))
    else:
        shutil.copyfile(src, dst)
        copied.append(str(dst))

    meta_src = src.with_suffix(src.suffix + ".meta")
    if meta_src.exists():
        meta_dst = dst.with_suffix(dst.suffix + ".meta")
        ensure_parent(meta_dst)
        if meta_dst.exists() and meta_src.read_bytes() == meta_dst.read_bytes():
            skipped.append(str(meta_dst))
        else:
            shutil.copyfile(meta_src, meta_dst)
            copied.append(str(meta_dst))


def copy_dir(src_dir: Path, dst_dir: Path, copied: list[str], skipped: list[str]) -> None:
    if not src_dir.exists():
        raise FileNotFoundError(src_dir)

    for src in sorted(src_dir.rglob("*")):
        if src.is_dir() or src.suffix == ".meta":
            continue
        rel = src.relative_to(src_dir)
        copy_file(src, dst_dir / rel, copied, skipped)


def read_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as fh:
        return json.load(fh)


def looks_like_asset_path(value: str) -> bool:
    return "/" in value and value.startswith(KNOWN_ASSET_PREFIXES)


def walk_strings(value, out: set[str]) -> None:
    if isinstance(value, dict):
        scene = value.get("scene")
        if isinstance(scene, str) and scene:
            out.add(f"Maps/Prefabs/{scene}.prefab")
            out.add(f"{OPTIONAL_SCENE_PREFIX}{scene}.unity")
        for nested in value.values():
            walk_strings(nested, out)
        return

    if isinstance(value, list):
        for nested in value:
            walk_strings(nested, out)
        return

    if isinstance(value, str) and looks_like_asset_path(value):
        out.add(value)


def collect_build_asset_seeds(build_dir: Path) -> set[str]:
    seeds: set[str] = set()
    for bundle_name in BUILD_OUTPUTS:
        bundle_path = build_dir / bundle_name
        if not bundle_path.exists():
            continue
        walk_strings(read_json(bundle_path), seeds)
    return seeds


def classify_seed_paths(example_root: Path, seed_paths: set[str]) -> tuple[list[Path], list[str]]:
    existing: list[Path] = []
    missing_optional: list[str] = []
    for rel in sorted(seed_paths):
        path = example_root / rel
        if path.exists():
            existing.append(Path(rel))
            continue
        if rel.endswith(".unity"):
            missing_optional.append(rel)
            continue
        raise FileNotFoundError(path)
    return existing, missing_optional


def sync_build_outputs(build_dir: Path, patch_root: Path, copied: list[str], skipped: list[str]) -> None:
    for name in BUILD_OUTPUTS:
        src = build_dir / name
        if not src.exists():
            raise FileNotFoundError(src)
        copy_file(src, patch_root / name, copied, skipped)


def sync_boot_files(example_root: Path, patch_root: Path, copied: list[str], skipped: list[str]) -> None:
    for rel in BOOT_FILES:
        copy_file(example_root / rel, patch_root / rel, copied, skipped)


def sync_static_files(example_root: Path, patch_root: Path, copied: list[str], skipped: list[str]) -> None:
    for rel in STATIC_FILES:
        copy_file(example_root / rel, patch_root / rel, copied, skipped)

    for rel in STATIC_DIRS:
        copy_dir(example_root / rel, patch_root / rel, copied, skipped)


def sync_unity_assets(example_root: Path, patch_root: Path, seed_paths: list[Path], copied: list[str], skipped: list[str]) -> list[str]:
    assets, _, missing_guids = resolve_dependencies(example_root, seed_paths)

    for src in assets:
        rel = src.relative_to(example_root)
        copy_file(src, patch_root / rel, copied, skipped)

    return missing_guids


def main() -> int:
    args = parse_args()

    build_dir = Path(args.build_root).resolve() / args.game
    example_root = Path(args.example_root).resolve()
    patch_root = Path(args.patch_root).resolve()

    if not build_dir.exists():
        print(f"missing build dir: {build_dir}", file=sys.stderr)
        return 2
    if not example_root.exists():
        print(f"missing example root: {example_root}", file=sys.stderr)
        return 2

    copied: list[str] = []
    skipped: list[str] = []

    sync_build_outputs(build_dir, patch_root, copied, skipped)
    sync_boot_files(example_root, patch_root, copied, skipped)
    sync_static_files(example_root, patch_root, copied, skipped)

    build_asset_seeds = collect_build_asset_seeds(build_dir)
    for rel in STATIC_UNITY_SEEDS:
        build_asset_seeds.add(rel)

    seed_paths, missing_optional = classify_seed_paths(example_root, build_asset_seeds)
    missing_guids = sync_unity_assets(example_root, patch_root, seed_paths, copied, skipped)

    print(f"synced game: {args.game}")
    print(f"build dir: {build_dir}")
    print(f"example root: {example_root}")
    print(f"patch root: {patch_root}")
    print(f"copied files: {len(copied)}")
    print(f"unchanged files: {len(skipped)}")
    print(f"unity seeds: {len(seed_paths)}")
    if missing_optional:
        print("optional missing scene assets:")
        for rel in missing_optional:
            print(f"  - {rel}")
    if missing_guids:
        print("missing guids (review if runtime import still fails):")
        for guid in missing_guids:
            print(f"  - {guid}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
