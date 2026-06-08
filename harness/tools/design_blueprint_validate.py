#!/usr/bin/env python3
"""Validate component-blueprints.yaml design contracts."""

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

ALLOWED_MODES = {"native_ui", "generate_image", "hybrid", "reuse"}
RECTANGULAR_ASSET_TYPES = {
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


@dataclass(frozen=True)
class Issue:
    severity: str
    code: str
    path: str
    message: str


@dataclass
class ValidationResult:
    path: Path
    game: str
    surfaces: int = 0
    sections: int = 0
    components: int = 0
    assets_checked: int = 0
    issues: list[Issue] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not any(issue.severity == "error" for issue in self.issues)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", help="Game id under harness/design/<game>.")
    parser.add_argument("--blueprint", help="Validate a specific component-blueprints.yaml.")
    parser.add_argument("--asset-plan", help="Asset plan used to verify asset_dependency_matrix keys.")
    parser.add_argument("--all", action="store_true", help="Validate every harness/design/*/component-blueprints.yaml.")
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    paths = resolve_blueprints(args)
    if not paths:
        print("No component-blueprints.yaml files found.", file=sys.stderr)
        return 2

    results = [validate_blueprint(path, args) for path in paths]
    if args.json:
        print(json.dumps([result_to_json(result) for result in results], ensure_ascii=False, indent=2))
    else:
        print_report(results)

    has_errors = any(not result.ok for result in results)
    has_warnings = any(issue.severity == "warning" for result in results for issue in result.issues)
    return 1 if has_errors or (args.strict and has_warnings) else 0


def resolve_blueprints(args: argparse.Namespace) -> list[Path]:
    if args.blueprint:
        return [Path(args.blueprint).resolve()]
    if args.all:
        return sorted(DESIGN_DIR.glob("*/component-blueprints.yaml"))
    if args.game:
        return [DESIGN_DIR / args.game / "component-blueprints.yaml"]
    return sorted(DESIGN_DIR.glob("*/component-blueprints.yaml"))


def validate_blueprint(path: Path, args: argparse.Namespace) -> ValidationResult:
    doc = load_yaml(path, "blueprint")
    game = str(doc.get("game") or path.parent.name)
    result = ValidationResult(path=path, game=game)
    asset_plan = load_asset_plan(path, args)
    asset_index = build_asset_index(asset_plan)

    validate_root(doc, path, result)
    validate_surfaces(doc, result)
    validate_components(doc, result)
    validate_asset_dependency_matrix(doc, asset_index, result)
    validate_runtime_mapping(doc, result)
    return result


def validate_root(doc: dict[str, Any], path: Path, result: ValidationResult) -> None:
    required = [
        "version",
        "game",
        "status",
        "source_concepts",
        "surfaces",
        "components",
        "asset_dependency_matrix",
        "runtime_token_mapping",
        "review_gate",
    ]
    for key in required:
        if key not in doc:
            result.issues.append(issue("error", "missing_top_level_key", key, f"Missing required top-level key: {key}"))

    if str(doc.get("game") or path.parent.name) != path.parent.name:
        result.issues.append(issue("warning", "game_path_mismatch", "game", "game should match harness/design/<game> folder name"))

    status = normalized(doc.get("status"))
    if status not in {"draft", "pilot", "extracted", "approved"}:
        result.issues.append(issue("warning", "unknown_status", "status", "status should be draft, pilot, extracted, or approved"))


def validate_surfaces(doc: dict[str, Any], result: ValidationResult) -> None:
    surfaces = doc.get("surfaces")
    components = doc.get("components") if isinstance(doc.get("components"), dict) else {}
    if not isinstance(surfaces, dict) or not surfaces:
        result.issues.append(issue("error", "surfaces_missing", "surfaces", "surfaces must be a non-empty mapping"))
        return

    result.surfaces = len(surfaces)
    for surface_name, surface in surfaces.items():
        path = f"surfaces.{surface_name}"
        if not isinstance(surface, dict):
            result.issues.append(issue("error", "surface_not_mapping", path, "Surface entry must be a mapping"))
            continue
        require_mapping_keys(surface, ["intent", "sections", "component_tree", "layout_contract"], path, result)
        tree = surface.get("component_tree")
        if not isinstance(tree, list) or not tree:
            result.issues.append(issue("error", "component_tree_missing", f"{path}.component_tree", "component_tree must be a non-empty list"))
            continue
        section_components = validate_sections(surface, components, path, result)
        for item in tree:
            component_name = component_name_from_tree_item(item)
            if component_name and component_name not in components:
                result.issues.append(issue("error", "component_tree_unknown_component", f"{path}.component_tree", f"Unknown component in tree: {item}"))
            elif component_name and section_components and component_name not in section_components:
                result.issues.append(issue("warning", "component_not_in_section", f"{path}.component_tree", f"Component is in component_tree but not owned by any section: {component_name}"))


def validate_sections(
    surface: dict[str, Any],
    components: dict[str, Any],
    path: str,
    result: ValidationResult,
) -> set[str]:
    sections = surface.get("sections")
    if not isinstance(sections, dict) or not sections:
        result.issues.append(issue("error", "sections_missing", f"{path}.sections", "sections must be a non-empty mapping"))
        return set()

    result.sections += len(sections)
    owned: set[str] = set()
    for section_name, section in sections.items():
        section_path = f"{path}.sections.{section_name}"
        if not isinstance(section, dict):
            result.issues.append(issue("error", "section_not_mapping", section_path, "Section entry must be a mapping"))
            continue
        require_mapping_keys(section, ["role", "components"], section_path, result)
        if "layout_contract" not in section:
            result.issues.append(issue("warning", "section_without_layout_contract", section_path, "Section should define layout_contract"))
        section_components = section.get("components")
        if not isinstance(section_components, list) or not section_components:
            result.issues.append(issue("error", "section_components_missing", f"{section_path}.components", "Section components must be a non-empty list"))
            continue
        for item in section_components:
            component_name = component_name_from_tree_item(item)
            if not component_name:
                continue
            if component_name not in components:
                result.issues.append(issue("error", "section_unknown_component", f"{section_path}.components", f"Unknown component in section: {item}"))
            owned.add(component_name)
    return owned


def validate_components(doc: dict[str, Any], result: ValidationResult) -> None:
    components = doc.get("components")
    matrix = doc.get("asset_dependency_matrix") if isinstance(doc.get("asset_dependency_matrix"), dict) else {}
    if not isinstance(components, dict) or not components:
        result.issues.append(issue("error", "components_missing", "components", "components must be a non-empty mapping"))
        return

    result.components = len(components)
    for name, component in components.items():
        path = f"components.{name}"
        if not isinstance(component, dict):
            result.issues.append(issue("error", "component_not_mapping", path, "Component entry must be a mapping"))
            continue
        require_mapping_keys(component, ["role", "mode"], path, result)
        mode = normalized(component.get("mode"))
        if mode and mode not in ALLOWED_MODES:
            result.issues.append(issue("warning", "unknown_component_mode", f"{path}.mode", f"Unknown component mode: {mode}"))
        if not component.get("anatomy") and component.get("repeatable"):
            result.issues.append(issue("warning", "repeatable_without_anatomy", path, "Repeatable components should define anatomy"))
        if any(key in component for key in ("box_model", "skin_contract", "asset_contract")) is False:
            result.issues.append(issue("warning", "component_without_contract", path, "Component should define box_model, skin_contract, or asset_contract"))

        skin = component.get("skin_contract")
        if isinstance(skin, dict):
            validate_skin_contract(skin, f"{path}.skin_contract", matrix, result)

        asset = component.get("asset_contract")
        if isinstance(asset, dict):
            validate_asset_contract(asset, f"{path}.asset_contract", matrix, result)


def validate_skin_contract(skin: dict[str, Any], path: str, matrix: dict[str, Any], result: ValidationResult) -> None:
    asset_key = skin.get("asset_key")
    if asset_key:
        validate_asset_key_reference(str(asset_key), path, matrix, result)

    has_slice = "slice_hints_px" in skin
    has_insets = "content_insets_px" in skin
    if has_slice:
        validate_inset_shape(skin.get("slice_hints_px"), f"{path}.slice_hints_px", "slice hints", result)
        if not has_insets:
            result.issues.append(issue("error", "slice_without_content_insets", path, "Skin contracts with slice_hints_px must define content_insets_px"))
    if has_insets:
        validate_inset_shape(skin.get("content_insets_px"), f"{path}.content_insets_px", "content insets", result)


def validate_asset_contract(asset: dict[str, Any], path: str, matrix: dict[str, Any], result: ValidationResult) -> None:
    asset_key = asset.get("asset_key")
    if asset_key:
        validate_asset_key_reference(str(asset_key), path, matrix, result)
    if asset.get("not_nine_slice") and asset.get("slice_hints_px"):
        result.issues.append(issue("error", "ornament_has_slice_hints", path, "not_nine_slice asset contracts must not define slice_hints_px"))


def validate_asset_dependency_matrix(doc: dict[str, Any], asset_index: dict[str, dict[str, Any]], result: ValidationResult) -> None:
    matrix = doc.get("asset_dependency_matrix")
    if not isinstance(matrix, dict) or not matrix:
        result.issues.append(issue("error", "asset_dependency_matrix_missing", "asset_dependency_matrix", "asset_dependency_matrix must be a non-empty mapping"))
        return

    for asset_key, entry in matrix.items():
        path = f"asset_dependency_matrix.{asset_key}"
        result.assets_checked += 1
        if not isinstance(entry, dict):
            result.issues.append(issue("error", "asset_dependency_not_mapping", path, "Asset dependency entry must be a mapping"))
            continue
        slots = entry.get("component_slots")
        if not isinstance(slots, list) or not slots:
            result.issues.append(issue("error", "asset_dependency_missing_slots", f"{path}.component_slots", "component_slots must be a non-empty list"))
        if asset_index and asset_key not in asset_index:
            result.issues.append(issue("error", "asset_key_missing_from_plan", path, "asset_dependency_matrix key is not present in asset-plan.yaml"))

        plan_entry = asset_index.get(asset_key, {})
        if is_rectangular_skin(entry, plan_entry):
            if "slice_hints_px" not in entry:
                result.issues.append(issue("error", "rectangular_asset_missing_slice_hints", path, "Rectangular skin dependency must define slice_hints_px"))
            else:
                validate_inset_shape(entry.get("slice_hints_px"), f"{path}.slice_hints_px", "slice hints", result)
            if "content_insets_by_slot" not in entry:
                result.issues.append(issue("error", "rectangular_asset_missing_content_insets", path, "Rectangular skin dependency must define content_insets_by_slot"))
            elif not isinstance(entry.get("content_insets_by_slot"), dict) or not entry.get("content_insets_by_slot"):
                result.issues.append(issue("error", "invalid_content_insets_by_slot", f"{path}.content_insets_by_slot", "content_insets_by_slot must be a non-empty mapping"))

        if entry.get("fixed_sprite_sizes_px") and entry.get("slice_hints_px"):
            result.issues.append(issue("error", "fixed_sprite_has_slice_hints", path, "Fixed sprite ornament/icon dependencies must not define slice_hints_px"))


def validate_runtime_mapping(doc: dict[str, Any], result: ValidationResult) -> None:
    mapping = doc.get("runtime_token_mapping")
    if not isinstance(mapping, dict) or not mapping:
        result.issues.append(issue("error", "runtime_token_mapping_missing", "runtime_token_mapping", "runtime_token_mapping must be a non-empty mapping"))
        return
    if not any(key in mapping for key in ("css_custom_properties", "phaser_constants", "unity_recipe_values", "existing_css_classes")):
        result.issues.append(issue("warning", "runtime_mapping_empty", "runtime_token_mapping", "Map at least one runtime token or class to blueprint components"))


def validate_asset_key_reference(asset_key: str, path: str, matrix: dict[str, Any], result: ValidationResult) -> None:
    if asset_key not in matrix:
        result.issues.append(issue("error", "asset_contract_missing_matrix_entry", path, f"Asset key must be listed in asset_dependency_matrix: {asset_key}"))


def validate_inset_shape(value: Any, path: str, label: str, result: ValidationResult) -> None:
    if not isinstance(value, dict):
        result.issues.append(issue("error", "invalid_inset_shape", path, f"{label} must be a mapping"))
        return
    required = ["left", "right", "top", "bottom"]
    for key in required:
        if key not in value:
            result.issues.append(issue("error", "invalid_inset_shape", path, f"{label} must contain {', '.join(required)}"))
            return
    for key in required:
        number = number_or_none(value.get(key))
        if number is None or number < 0:
            result.issues.append(issue("error", "invalid_inset_value", f"{path}.{key}", f"{label}.{key} must be a non-negative number"))


def is_rectangular_skin(matrix_entry: dict[str, Any], plan_entry: dict[str, Any]) -> bool:
    if matrix_entry.get("slice_hints_px") or matrix_entry.get("content_insets_by_slot"):
        return True
    asset_type = normalized(plan_entry.get("type"))
    phaser = plan_entry.get("phaser") or {}
    usage = normalized(phaser.get("usage")) if isinstance(phaser, dict) else ""
    return asset_type in RECTANGULAR_ASSET_TYPES or usage in {"phaser_nineslice", "phaser_nineslice_set"}


def require_mapping_keys(entry: dict[str, Any], keys: list[str], path: str, result: ValidationResult) -> None:
    for key in keys:
        if key not in entry:
            result.issues.append(issue("error", "missing_mapping_key", f"{path}.{key}", f"Missing required key: {key}"))


def component_name_from_tree_item(value: Any) -> str:
    text = str(value or "").strip()
    if "[" in text:
        text = text.split("[", 1)[0]
    if "." in text:
        text = text.split(".", 1)[0]
    return text


def load_asset_plan(blueprint_path: Path, args: argparse.Namespace) -> dict[str, Any]:
    if args.asset_plan:
        path = Path(args.asset_plan).resolve()
    else:
        path = blueprint_path.parent / "asset-plan.yaml"
    if not path.exists():
        return {}
    return load_yaml(path, "asset plan")


def build_asset_index(asset_plan: dict[str, Any]) -> dict[str, dict[str, Any]]:
    assets = asset_plan.get("assets") if isinstance(asset_plan, dict) else None
    if not isinstance(assets, list):
        return {}
    index: dict[str, dict[str, Any]] = {}
    for entry in assets:
        if isinstance(entry, dict) and entry.get("key"):
            index[str(entry["key"])] = entry
    return index


def load_yaml(path: Path, label: str) -> dict[str, Any]:
    if not path.exists():
        raise SystemExit(f"{label} missing: {path}")
    doc = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(doc, dict):
        raise SystemExit(f"{label} root must be a mapping: {path}")
    return doc


def issue(severity: str, code: str, path: str, message: str) -> Issue:
    return Issue(severity=severity, code=code, path=path, message=message)


def normalized(value: Any) -> str:
    return str(value or "").strip().lower()


def number_or_none(value: Any) -> float | None:
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def result_to_json(result: ValidationResult) -> dict[str, Any]:
    return {
        "path": result.path.relative_to(ROOT).as_posix(),
        "game": result.game,
        "ok": result.ok,
        "surfaces": result.surfaces,
        "sections": result.sections,
        "components": result.components,
        "assets_checked": result.assets_checked,
        "issues": [issue.__dict__ for issue in result.issues],
    }


def print_report(results: list[ValidationResult]) -> None:
    for result in results:
        print(f"== {result.path.relative_to(ROOT)} ({result.game}) ==")
        print(f"surfaces: {result.surfaces}")
        print(f"sections: {result.sections}")
        print(f"components: {result.components}")
        print(f"asset dependencies: {result.assets_checked}")
        if result.issues:
            for item in result.issues:
                print(f"{item.severity.upper()} {item.code} {item.path}: {item.message}")
        else:
            print("OK no issues")


if __name__ == "__main__":
    sys.exit(main())
