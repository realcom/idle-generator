#!/usr/bin/env python3
"""Audit Phaser runtime asset references against harness/runtime/assets."""

from __future__ import annotations

import argparse
import json
import posixpath
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
RUNTIME_DIR = ROOT / "harness" / "runtime"
BUILD_DIR = ROOT / "harness" / "build"
PHASER_SCENE = RUNTIME_DIR / "src" / "idlez-phaser" / "phaser-scene.js"
RUNTIME_SCAN_GLOBS = [
    "*.html",
    "src/idlez-phaser/*.js",
    "src/idlez-phaser/network/*.js",
]
BUILD_BUNDLES = [
    "Items.json",
    "Skills.json",
    "Units.json",
    "Maps.json",
    "Achievements.json",
    "Audios.json",
]
ASSET_RE = re.compile(r"""(?P<path>assets/[A-Za-z0-9_./@%+\-]+\.(?:png|jpg|jpeg|webp|gif|mp3|wav|ogg|txt|bytes))""")


@dataclass(frozen=True)
class Reference:
    path: str
    source: str
    line: int = 0


@dataclass
class AuditResult:
    game: str
    runtime_refs: list[Reference] = field(default_factory=list)
    build_refs: list[Reference] = field(default_factory=list)
    missing_assets: list[Reference] = field(default_factory=list)
    map_background_keys: set[str] = field(default_factory=set)
    unknown_map_backgrounds: list[str] = field(default_factory=list)
    spine_checks: int = 0
    missing_spine_files: list[Reference] = field(default_factory=list)
    atlas_image_checks: int = 0
    missing_atlas_images: list[Reference] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not (
            self.missing_assets
            or self.unknown_map_backgrounds
            or self.missing_spine_files
            or self.missing_atlas_images
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", default="mushroomer", help="Compiled game id under harness/build.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON.")
    parser.add_argument("--runtime-dir", default=str(RUNTIME_DIR), help="Runtime directory containing assets/.")
    parser.add_argument("--build-dir", default=str(BUILD_DIR), help="Build directory containing <game>/*.json.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = audit(
        game=args.game,
        runtime_dir=Path(args.runtime_dir),
        build_dir=Path(args.build_dir),
    )
    if args.json:
        print(json.dumps(result_to_json(result), ensure_ascii=False, indent=2))
    else:
        print_report(result)
    return 0 if result.ok else 1


def audit(game: str, runtime_dir: Path = RUNTIME_DIR, build_dir: Path = BUILD_DIR) -> AuditResult:
    result = AuditResult(game=game)

    result.runtime_refs = collect_runtime_refs(runtime_dir)
    result.build_refs = collect_build_refs(build_dir / game)
    all_refs = dedupe_refs([*result.runtime_refs, *result.build_refs])
    result.missing_assets = [ref for ref in all_refs if not asset_exists(runtime_dir, ref.path)]

    known_backgrounds = parse_map_background_keys(PHASER_SCENE)
    result.map_background_keys = collect_build_background_keys(build_dir / game)
    result.unknown_map_backgrounds = sorted(key for key in result.map_background_keys if key not in known_backgrounds)

    result.spine_checks, result.missing_spine_files = audit_spine_triples(runtime_dir)
    result.atlas_image_checks, result.missing_atlas_images = audit_atlas_images(runtime_dir)

    return result


def collect_runtime_refs(runtime_dir: Path) -> list[Reference]:
    refs: list[Reference] = []
    for pattern in RUNTIME_SCAN_GLOBS:
        for path in sorted(runtime_dir.glob(pattern)):
            if not path.is_file():
                continue
            refs.extend(extract_asset_refs(path, path.relative_to(runtime_dir).as_posix()))
    return refs


def collect_build_refs(game_build_dir: Path) -> list[Reference]:
    refs: list[Reference] = []
    for bundle in BUILD_BUNDLES:
        path = game_build_dir / bundle
        if not path.exists():
            continue
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as error:
            refs.append(Reference(f"<json-error:{error.lineno}:{error.colno}>", path.relative_to(ROOT).as_posix(), error.lineno))
            continue
        refs.extend(extract_refs_from_json(data, path.relative_to(ROOT).as_posix()))
    return refs


def extract_asset_refs(path: Path, source: str) -> list[Reference]:
    refs: list[Reference] = []
    for line_no, line in enumerate(path.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1):
        for match in ASSET_RE.finditer(line):
            refs.append(Reference(normalize_asset_path(match.group("path")), source, line_no))
    return refs


def extract_refs_from_json(value: Any, source: str, refs: list[Reference] | None = None) -> list[Reference]:
    refs = refs if refs is not None else []
    if isinstance(value, dict):
        for child in value.values():
            extract_refs_from_json(child, source, refs)
    elif isinstance(value, list):
        for child in value:
            extract_refs_from_json(child, source, refs)
    elif isinstance(value, str):
        for match in ASSET_RE.finditer(value):
            refs.append(Reference(normalize_asset_path(match.group("path")), source, 0))
    return refs


def normalize_asset_path(path: str) -> str:
    clean = path.split("?", 1)[0].split("#", 1)[0]
    return posixpath.normpath(clean)


def asset_exists(runtime_dir: Path, asset_path: str) -> bool:
    if not asset_path.startswith("assets/"):
        return True
    return (runtime_dir / asset_path).is_file()


def dedupe_refs(refs: list[Reference]) -> list[Reference]:
    seen: set[tuple[str, str, int]] = set()
    out: list[Reference] = []
    for ref in refs:
        key = (ref.path, ref.source, ref.line)
        if key in seen:
            continue
        seen.add(key)
        out.append(ref)
    return out


def parse_map_background_keys(scene_path: Path) -> set[str]:
    if not scene_path.exists():
        return set()
    text = scene_path.read_text(encoding="utf-8", errors="ignore")
    match = re.search(r"const\s+MAP_BACKGROUNDS\s*=\s*\{(?P<body>.*?)\n\};\s*\nconst\s+SKILL_EFFECTS", text, re.S)
    if not match:
        return set()
    body = match.group("body")
    return set(re.findall(r"^  ([A-Za-z0-9_]+):\s*\{", body, re.M))


def collect_build_background_keys(game_build_dir: Path) -> set[str]:
    path = game_build_dir / "Maps.json"
    if not path.exists():
        return set()
    data = json.loads(path.read_text(encoding="utf-8"))
    keys: set[str] = set()
    for map_def in data.get("maps", []):
        value = (map_def.get("popupArgs") or {}).get("ClientPhaserBackground")
        if value:
            keys.add(str(value))
    return keys


def audit_spine_triples(runtime_dir: Path) -> tuple[int, list[Reference]]:
    missing: list[Reference] = []
    checks = 0
    for skel in sorted((runtime_dir / "assets").rglob("*.skel.bytes")):
        checks += 1
        stem = skel.name.removesuffix(".skel.bytes")
        for suffix in [".atlas.txt", ".png"]:
            expected = skel.with_name(f"{stem}{suffix}")
            if not expected.exists():
                missing.append(Reference(
                    expected.relative_to(runtime_dir).as_posix(),
                    skel.relative_to(runtime_dir).as_posix(),
                    0,
                ))
    return checks, missing


def audit_atlas_images(runtime_dir: Path) -> tuple[int, list[Reference]]:
    missing: list[Reference] = []
    checks = 0
    for atlas in sorted((runtime_dir / "assets").rglob("*.atlas.txt")):
        for line_no, raw in enumerate(atlas.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1):
            line = raw.strip()
            if not line.lower().endswith((".png", ".jpg", ".jpeg", ".webp")):
                continue
            checks += 1
            image = atlas.parent / line
            if not image.exists():
                missing.append(Reference(
                    image.relative_to(runtime_dir).as_posix(),
                    atlas.relative_to(runtime_dir).as_posix(),
                    line_no,
                ))
    return checks, missing


def print_report(result: AuditResult) -> None:
    print(f"=== Phaser asset audit ({result.game}) ===")
    print(f"runtime asset refs : {len(result.runtime_refs)}")
    print(f"build asset refs   : {len(result.build_refs)}")
    print(f"map backgrounds   : {len(result.map_background_keys)}")
    print(f"spine triples     : {result.spine_checks}")
    print(f"atlas image refs   : {result.atlas_image_checks}")
    print()

    print_section("Missing asset refs", result.missing_assets)
    print_section("Missing spine triple files", result.missing_spine_files)
    print_section("Missing atlas page images", result.missing_atlas_images)
    if result.unknown_map_backgrounds:
        print("Unknown map background keys:")
        for key in result.unknown_map_backgrounds:
            print(f"  - {key}")
    else:
        print("Unknown map background keys: none")

    print()
    print("✅ asset audit passed" if result.ok else "❌ asset audit failed")


def print_section(title: str, refs: list[Reference]) -> None:
    if not refs:
        print(f"{title}: none")
        return
    print(f"{title}:")
    for ref in refs[:80]:
        location = f"{ref.source}:{ref.line}" if ref.line else ref.source
        print(f"  - {ref.path} ({location})")
    if len(refs) > 80:
        print(f"  ... {len(refs) - 80} more")


def result_to_json(result: AuditResult) -> dict[str, Any]:
    return {
        "ok": result.ok,
        "game": result.game,
        "runtimeRefs": len(result.runtime_refs),
        "buildRefs": len(result.build_refs),
        "mapBackgroundKeys": sorted(result.map_background_keys),
        "spineChecks": result.spine_checks,
        "atlasImageChecks": result.atlas_image_checks,
        "missingAssets": [ref.__dict__ for ref in result.missing_assets],
        "unknownMapBackgrounds": result.unknown_map_backgrounds,
        "missingSpineFiles": [ref.__dict__ for ref in result.missing_spine_files],
        "missingAtlasImages": [ref.__dict__ for ref in result.missing_atlas_images],
    }


if __name__ == "__main__":
    raise SystemExit(main())
