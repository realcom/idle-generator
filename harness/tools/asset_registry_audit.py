#!/usr/bin/env python3
"""Audit runtime asset references against a game asset registry."""

from __future__ import annotations

import argparse
import fnmatch
import json
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[2]
TOOLS_DIR = Path(__file__).resolve().parent
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from phaser_asset_audit import (  # noqa: E402
    BUILD_DIR,
    RUNTIME_DIR,
    Reference,
    asset_exists,
    collect_build_refs,
    collect_runtime_refs,
    dedupe_refs,
)


DEFAULT_REGISTRY_ROOT = ROOT / "harness" / "assets"
ALLOWED_STATUSES = {"requested", "ai-draft", "review", "approved", "final"}
RELEASE_STATUSES = {"approved", "final"}


@dataclass(frozen=True)
class RegistryMatch:
    key: str
    status: str
    type: str
    source: str = ""
    via: str = "asset"


@dataclass
class Registry:
    path: Path
    game: str
    assets: dict[str, dict[str, Any]] = field(default_factory=dict)
    collections: list[dict[str, Any]] = field(default_factory=list)


@dataclass
class RegistryAuditResult:
    game: str
    registry_path: str
    referenced_assets: list[Reference] = field(default_factory=list)
    missing_files: list[Reference] = field(default_factory=list)
    missing_registry: list[Reference] = field(default_factory=list)
    release_blocked: list[Reference] = field(default_factory=list)
    invalid_registry: list[str] = field(default_factory=list)
    orphan_assets: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not (
            self.missing_files
            or self.missing_registry
            or self.release_blocked
            or self.invalid_registry
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", default="mushroomer", help="Game id under harness/build and harness/assets.")
    parser.add_argument("--registry", help="Path to asset-registry.yaml. Defaults to harness/assets/<game>/asset-registry.yaml.")
    parser.add_argument("--runtime-dir", default=str(RUNTIME_DIR), help="Runtime directory containing assets/.")
    parser.add_argument("--build-dir", default=str(BUILD_DIR), help="Build directory containing <game>/*.json.")
    parser.add_argument("--release", action="store_true", help="Require referenced assets to be approved/final.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    registry_path = Path(args.registry).resolve() if args.registry else DEFAULT_REGISTRY_ROOT / args.game / "asset-registry.yaml"
    result = audit(
        game=args.game,
        registry_path=registry_path,
        runtime_dir=Path(args.runtime_dir),
        build_dir=Path(args.build_dir),
        release=args.release,
    )
    if args.json:
        print(json.dumps(result_to_json(result), ensure_ascii=False, indent=2))
    else:
        print_report(result, release=args.release)
    return 0 if result.ok else 1


def audit(
    game: str,
    registry_path: Path,
    runtime_dir: Path = RUNTIME_DIR,
    build_dir: Path = BUILD_DIR,
    release: bool = False,
) -> RegistryAuditResult:
    result = RegistryAuditResult(game=game, registry_path=str(registry_path))
    registry = load_registry(registry_path, result.invalid_registry)
    if registry is None:
        return result

    result.referenced_assets = collect_referenced_assets(game, runtime_dir, build_dir)
    result.missing_files = [ref for ref in result.referenced_assets if not asset_exists(runtime_dir, ref.path)]

    referenced_keys = {ref.path for ref in result.referenced_assets}
    explicit_keys = set(registry.assets)

    for key, entry in registry.assets.items():
        validate_registry_entry(registry, key, entry, result.invalid_registry)
        if key not in referenced_keys:
            result.orphan_assets.append(key)
        validate_entry_file(registry, key, entry, runtime_dir, result.invalid_registry)

    for index, collection in enumerate(registry.collections):
        validate_collection(index, collection, result.invalid_registry)

    for ref in result.referenced_assets:
        match = match_registry(registry, ref.path)
        if match is None:
            result.missing_registry.append(ref)
            continue
        if release and match.status not in RELEASE_STATUSES:
            result.release_blocked.append(ref)

    return result


def collect_referenced_assets(game: str, runtime_dir: Path, build_dir: Path) -> list[Reference]:
    return dedupe_refs([
        *collect_runtime_refs(runtime_dir),
        *collect_build_refs(build_dir / game),
    ])


def load_registry(path: Path, errors: list[str]) -> Registry | None:
    if not path.exists():
        errors.append(f"registry missing: {path}")
        return None
    try:
        doc = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except yaml.YAMLError as error:
        errors.append(f"registry yaml error: {error}")
        return None
    if not isinstance(doc, dict):
        errors.append("registry root must be a mapping")
        return None

    assets = doc.get("assets") or {}
    collections = doc.get("collections") or []
    if not isinstance(assets, dict):
        errors.append("registry.assets must be a mapping")
        assets = {}
    if not isinstance(collections, list):
        errors.append("registry.collections must be a list")
        collections = []

    return Registry(
        path=path,
        game=str(doc.get("game") or ""),
        assets=assets,
        collections=collections,
    )


def validate_registry_entry(registry: Registry, key: str, entry: Any, errors: list[str]) -> None:
    if not isinstance(entry, dict):
        errors.append(f"asset {key}: value must be a mapping")
        return
    validate_status(f"asset {key}", entry.get("status"), errors)
    if not entry.get("type"):
        errors.append(f"asset {key}: type is required")
    used_by = entry.get("used_by", [])
    if used_by is not None and not isinstance(used_by, list):
        errors.append(f"asset {key}: used_by must be a list")


def validate_entry_file(registry: Registry, key: str, entry: Any, runtime_dir: Path, errors: list[str]) -> None:
    if not isinstance(entry, dict):
        return
    file_value = entry.get("file")
    if file_value:
        path = (registry.path.parent / str(file_value)).resolve()
    elif key.startswith("assets/"):
        path = runtime_dir / key
    else:
        return
    if not path.exists():
        errors.append(f"asset {key}: file missing: {path}")


def validate_collection(index: int, collection: Any, errors: list[str]) -> None:
    ctx = f"collection[{index}]"
    if not isinstance(collection, dict):
        errors.append(f"{ctx}: value must be a mapping")
        return
    if not (collection.get("prefix") or collection.get("pattern")):
        errors.append(f"{ctx}: prefix or pattern is required")
    if not collection.get("type"):
        errors.append(f"{ctx}: type is required")
    validate_status(ctx, collection.get("status"), errors)


def validate_status(ctx: str, status: Any, errors: list[str]) -> None:
    if not status:
        errors.append(f"{ctx}: status is required")
        return
    if str(status) not in ALLOWED_STATUSES:
        errors.append(f"{ctx}: unknown status {status!r}")


def match_registry(registry: Registry, key: str) -> RegistryMatch | None:
    entry = registry.assets.get(key)
    if isinstance(entry, dict):
        return RegistryMatch(
            key=key,
            status=str(entry.get("status") or ""),
            type=str(entry.get("type") or ""),
            source=str(entry.get("source") or ""),
            via="asset",
        )

    for collection in registry.collections:
        if not isinstance(collection, dict):
            continue
        prefix = collection.get("prefix")
        pattern = collection.get("pattern")
        if prefix and key.startswith(str(prefix)):
            return collection_match(collection)
        if pattern and pattern_matches(str(pattern), key):
            return collection_match(collection)
    return None


def collection_match(collection: dict[str, Any]) -> RegistryMatch:
    return RegistryMatch(
        key=str(collection.get("name") or collection.get("prefix") or collection.get("pattern") or "<collection>"),
        status=str(collection.get("status") or ""),
        type=str(collection.get("type") or ""),
        source=str(collection.get("source") or ""),
        via="collection",
    )


def pattern_matches(pattern: str, key: str) -> bool:
    if pattern.endswith("/*"):
        prefix = pattern[:-1]
        if not key.startswith(prefix):
            return False
        return "/" not in key[len(prefix):]
    return fnmatch.fnmatchcase(key, pattern)


def print_report(result: RegistryAuditResult, release: bool = False) -> None:
    mode = "release" if release else "dev"
    print(f"=== Asset registry audit ({result.game}, {mode}) ===")
    print(f"registry          : {result.registry_path}")
    print(f"referenced assets : {len(result.referenced_assets)}")
    print()
    print_ref_section("Missing files", result.missing_files)
    print_ref_section("Missing registry entries", result.missing_registry)
    print_ref_section("Release-blocked assets", result.release_blocked)
    print_text_section("Invalid registry", result.invalid_registry)
    print_text_section("Orphan explicit registry assets", result.orphan_assets, warning=True)
    print()
    print("asset registry audit passed" if result.ok else "asset registry audit failed")


def print_ref_section(title: str, refs: list[Reference]) -> None:
    if not refs:
        print(f"{title}: none")
        return
    print(f"{title}:")
    for ref in refs[:80]:
        location = f"{ref.source}:{ref.line}" if ref.line else ref.source
        print(f"  - {ref.path} ({location})")
    if len(refs) > 80:
        print(f"  ... {len(refs) - 80} more")


def print_text_section(title: str, values: list[str], warning: bool = False) -> None:
    if not values:
        print(f"{title}: none")
        return
    suffix = " (warning)" if warning else ""
    print(f"{title}{suffix}:")
    for value in values[:80]:
        print(f"  - {value}")
    if len(values) > 80:
        print(f"  ... {len(values) - 80} more")


def result_to_json(result: RegistryAuditResult) -> dict[str, Any]:
    return {
        "ok": result.ok,
        "game": result.game,
        "registryPath": result.registry_path,
        "referencedAssets": len(result.referenced_assets),
        "missingFiles": [ref.__dict__ for ref in result.missing_files],
        "missingRegistry": [ref.__dict__ for ref in result.missing_registry],
        "releaseBlocked": [ref.__dict__ for ref in result.release_blocked],
        "invalidRegistry": result.invalid_registry,
        "orphanAssets": result.orphan_assets,
    }


if __name__ == "__main__":
    raise SystemExit(main())
