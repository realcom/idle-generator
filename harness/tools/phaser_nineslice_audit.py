#!/usr/bin/env python3
"""Audit Phaser 9-slice UI skin contracts in harness/design asset plans."""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[2]
DESIGN_DIR = ROOT / "harness" / "design"

NINESLICE_TYPES = {
    "nine_slice_panel",
    "button_skin",
    "panel_skin",
    "modal_skin",
    "modal_frame",
    "dock_skin",
    "card_skin",
    "tab_skin",
    "chip_skin",
    "toast_skin",
    "slot_frame",
    "progress_frame",
    "ui_skin_set",
}
AVOID_TYPE_PARTS = {
    "background",
    "atlas",
    "spritesheet",
    "sprite",
    "hex_tile",
    "vfx",
    "character",
    "building",
    "pickup",
    "icon",
}
PHASER_NINESLICE_USAGES = {"phaser_nineslice", "phaser_nineslice_set", "nineslice", "nine_slice", "native_nineslice"}
UNITY_SLICED_USAGES = {"sliced_sprite", "sliced_sprite_set"}
CSS_USAGES = {"css_background", "css_background_images", "css_background_per_hex_state", "dom_background", "html_css_background"}


@dataclass(frozen=True)
class Issue:
    severity: str
    code: str
    asset_key: str
    message: str
    plan: str


@dataclass
class PlanAudit:
    path: Path
    game: str
    checked: int = 0
    accepted: list[str] = field(default_factory=list)
    rejected: list[str] = field(default_factory=list)
    issues: list[Issue] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not any(issue.severity == "error" for issue in self.issues)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", help="Game id under harness/design/<game>.")
    parser.add_argument("--asset-plan", help="Audit a specific asset-plan.yaml.")
    parser.add_argument("--all", action="store_true", help="Audit every harness/design/*/asset-plan.yaml.")
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    plans = resolve_plans(args)
    if not plans:
        print("No asset-plan.yaml files found.", file=sys.stderr)
        return 2

    results = [audit_plan(path) for path in plans]
    if args.json:
        print(json.dumps([result_to_json(result) for result in results], ensure_ascii=False, indent=2))
    else:
        print_report(results)

    has_errors = any(not result.ok for result in results)
    has_warnings = any(issue.severity == "warning" for result in results for issue in result.issues)
    return 1 if has_errors or (args.strict and has_warnings) else 0


def resolve_plans(args: argparse.Namespace) -> list[Path]:
    if args.asset_plan:
        return [Path(args.asset_plan).resolve()]
    if args.all:
        return sorted(DESIGN_DIR.glob("*/asset-plan.yaml"))
    if args.game:
        return [DESIGN_DIR / args.game / "asset-plan.yaml"]
    return sorted(DESIGN_DIR.glob("*/asset-plan.yaml"))


def audit_plan(path: Path) -> PlanAudit:
    doc = load_yaml(path)
    game = str(doc.get("game") or path.parent.name)
    result = PlanAudit(path=path, game=game)
    assets = doc.get("assets") or []
    if not isinstance(assets, list):
        result.issues.append(issue("error", "assets_not_list", "<root>", "asset-plan assets must be a list", path))
        return result

    for entry in assets:
        if not isinstance(entry, dict):
            result.issues.append(issue("error", "asset_not_mapping", "<unknown>", "asset entry must be a mapping", path))
            continue
        audit_asset(entry, result)
    return result


def audit_asset(entry: dict[str, Any], result: PlanAudit) -> None:
    result.checked += 1
    key = str(entry.get("key") or "<missing-key>")
    asset_type = normalized(entry.get("type"))
    phaser_usage = usage(entry, "phaser")
    unity_usage = usage(entry, "unity")
    platforms = [normalized(value) for value in entry.get("platforms") or []]
    hints = entry.get("slice_hints")
    has_hints = has_any_slice_hints(hints)
    avoid = is_avoid_type(asset_type)
    candidate = is_candidate_type(asset_type) or has_hints or phaser_usage in PHASER_NINESLICE_USAGES

    if avoid and phaser_usage in PHASER_NINESLICE_USAGES:
        result.issues.append(issue("error", "avoid_native_nineslice", key, f"{asset_type} should not use Phaser 9-slice", result.path))
        result.rejected.append(key)
        return
    if avoid and has_hints:
        result.issues.append(issue("warning", "avoid_has_slice_hints", key, f"{asset_type} has slice_hints but is normally not a 9-slice surface", result.path))
        result.rejected.append(key)
        return
    if not candidate:
        return

    if not has_hints:
        result.issues.append(issue("error", "missing_slice_hints", key, "9-slice candidate must define slice_hints", result.path))
        result.rejected.append(key)
        return

    validate_hint_values(key, hints, entry.get("target_size"), result)

    if phaser_usage in CSS_USAGES:
        result.issues.append(issue("error", "phaser_usage_css_background", key, "Use phaser.usage: phaser_nineslice, not CSS background, for production 9-slice skins", result.path))
    elif phaser_usage and phaser_usage not in PHASER_NINESLICE_USAGES:
        result.issues.append(issue("warning", "phaser_usage_not_nineslice", key, f"phaser.usage is {phaser_usage!r}; expected phaser_nineslice", result.path))
    elif not phaser_usage:
        result.issues.append(issue("error", "missing_phaser_usage", key, "Missing phaser.usage: phaser_nineslice", result.path))

    if "unity" in platforms and unity_usage not in UNITY_SLICED_USAGES:
        result.issues.append(issue("warning", "unity_not_sliced_sprite", key, "Unity-shared 9-slice skin should use unity.usage: sliced_sprite", result.path))

    if normalized(entry.get("background")) == "opaque":
        result.issues.append(issue("warning", "opaque_nineslice", key, "Most reusable UI skins should use transparent background", result.path))

    phaser = entry.get("phaser") or {}
    if isinstance(phaser, dict) and not phaser.get("target_path"):
        result.issues.append(issue("warning", "missing_phaser_target_path", key, "Missing phaser.target_path", result.path))

    result.accepted.append(key)


def validate_hint_values(key: str, hints: Any, target_size: Any, result: PlanAudit) -> None:
    if not isinstance(hints, dict):
        return
    if not valid_hint_shape(hints):
        for name, nested in hints.items():
            nested_key = f"{key}.{name}"
            if valid_hint_shape(nested):
                validate_hint_values(nested_key, nested, target_size, result)
            else:
                result.issues.append(issue("error", "invalid_slice_hint_group", nested_key, "Nested slice_hints must contain left/right/top/bottom", result.path))
        return

    values = {name: number_or_none(hints.get(name)) for name in ("left", "right", "top", "bottom")}
    for name, value in values.items():
        if value is None or value <= 0:
            result.issues.append(issue("error", "invalid_slice_hint", key, f"slice_hints.{name} must be > 0", result.path))

    if not isinstance(target_size, dict):
        return
    width = number_or_none(target_size.get("width"))
    height = number_or_none(target_size.get("height"))
    if width and values["left"] and values["right"] and values["left"] + values["right"] >= width:
        result.issues.append(issue("error", "slice_hints_exceed_width", key, "left + right must be smaller than target width", result.path))
    if height and values["top"] and values["bottom"] and values["top"] + values["bottom"] >= height:
        result.issues.append(issue("error", "slice_hints_exceed_height", key, "top + bottom must be smaller than target height", result.path))


def is_candidate_type(asset_type: str) -> bool:
    return asset_type in NINESLICE_TYPES or any(asset_type.endswith(f"_{suffix}") for suffix in NINESLICE_TYPES)


def is_avoid_type(asset_type: str) -> bool:
    return any(part in asset_type for part in AVOID_TYPE_PARTS) and asset_type not in NINESLICE_TYPES


def valid_hint_shape(value: Any) -> bool:
    return isinstance(value, dict) and all(name in value for name in ("left", "right", "top", "bottom"))


def has_any_slice_hints(value: Any) -> bool:
    if valid_hint_shape(value):
        return True
    return isinstance(value, dict) and any(valid_hint_shape(nested) for nested in value.values())


def usage(entry: dict[str, Any], platform: str) -> str:
    value = entry.get(platform) or {}
    return normalized(value.get("usage")) if isinstance(value, dict) else ""


def normalized(value: Any) -> str:
    return str(value or "").strip().lower()


def number_or_none(value: Any) -> float | None:
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def load_yaml(path: Path) -> dict[str, Any]:
    if not path.exists():
        raise SystemExit(f"asset plan missing: {path}")
    doc = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(doc, dict):
        raise SystemExit(f"asset plan root must be a mapping: {path}")
    return doc


def issue(severity: str, code: str, asset_key: str, message: str, path: Path) -> Issue:
    return Issue(severity=severity, code=code, asset_key=asset_key, message=message, plan=path.relative_to(ROOT).as_posix())


def print_report(results: list[PlanAudit]) -> None:
    for result in results:
        print(f"== {result.path.relative_to(ROOT)} ({result.game}) ==")
        print(f"checked: {result.checked}")
        print(f"accepted 9-slice: {len(result.accepted)}")
        if result.accepted:
            for key in result.accepted:
                print(f"  OK {key}")
        if result.issues:
            print("issues:")
            for item in result.issues:
                print(f"  [{item.severity}] {item.asset_key}: {item.code} - {item.message}")
        else:
            print("issues: none")


def result_to_json(result: PlanAudit) -> dict[str, Any]:
    return {
        "path": result.path.relative_to(ROOT).as_posix(),
        "game": result.game,
        "checked": result.checked,
        "accepted": result.accepted,
        "rejected": result.rejected,
        "ok": result.ok,
        "issues": [item.__dict__ for item in result.issues],
    }


if __name__ == "__main__":
    raise SystemExit(main())
