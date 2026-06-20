#!/usr/bin/env python3
"""Validate harness Godot UI recipes before scene/theme generation."""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_ATOMS = ROOT / "harness" / "godot" / "registries" / "control-atoms.yaml"


@dataclass(frozen=True)
class Issue:
    severity: str
    code: str
    path: str
    message: str


@dataclass
class Result:
    recipe: Path
    atoms: int = 0
    asset_keys: int = 0
    issues: list[Issue] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not any(issue.severity == "error" for issue in self.issues)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--recipe", required=True, type=Path)
    parser.add_argument("--atoms", default=DEFAULT_ATOMS, type=Path)
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = validate(args.recipe.resolve(), args.atoms.resolve())
    print_report(result)
    has_warnings = any(issue.severity == "warning" for issue in result.issues)
    return 1 if not result.ok or (args.strict and has_warnings) else 0


def validate(recipe_path: Path, atoms_path: Path) -> Result:
    result = Result(recipe=recipe_path)
    if not recipe_path.exists():
        result.issues.append(issue("error", "recipe_missing", "recipe", f"Recipe missing: {recipe_path}"))
        return result
    if not atoms_path.exists():
        result.issues.append(issue("error", "atom_registry_missing", "atoms", f"Atom registry missing: {atoms_path}"))
        return result

    recipe = load_yaml(recipe_path)
    registry = load_yaml(atoms_path)
    atom_defs = registry.get("atoms") if isinstance(registry, dict) else {}
    if not isinstance(atom_defs, dict) or not atom_defs:
        result.issues.append(issue("error", "atom_registry_empty", "atoms", "control-atoms.yaml must define atoms"))
        atom_defs = {}
    result.atoms = len(atom_defs)

    validate_root(recipe, result)
    validate_paths(recipe_path, recipe, result)
    asset_index = load_asset_index(recipe_path, recipe, result)
    validate_asset_plan_consistency(asset_index, result)
    validate_assets(recipe, asset_index, result)
    validate_control_tree(recipe.get("control_tree"), atom_defs, asset_index, result)
    return result


def validate_root(recipe: dict[str, Any], result: Result) -> None:
    required = ["version", "game", "slug", "status", "backend", "target", "sources", "blueprint_refs", "control_tree", "validation"]
    for key in required:
        if key not in recipe:
            result.issues.append(issue("error", "missing_top_level_key", key, f"Missing required top-level key: {key}"))
    if recipe.get("backend") != "godot_control":
        result.issues.append(issue("error", "invalid_backend", "backend", "backend must be godot_control"))
    if normalized(recipe.get("status")) not in {"draft", "pilot", "implemented", "approved"}:
        result.issues.append(issue("warning", "unknown_status", "status", "status should be draft, pilot, implemented, or approved"))


def validate_paths(recipe_path: Path, recipe: dict[str, Any], result: Result) -> None:
    target = recipe.get("target") if isinstance(recipe.get("target"), dict) else {}
    for key in ("project", "owner_scene", "owner_script"):
        value = target.get(key)
        if isinstance(value, str):
            resolved = resolve_recipe_path(recipe_path, value)
            if not resolved.exists():
                result.issues.append(issue("error", "target_path_missing", f"target.{key}", f"Target path missing: {resolved}"))
        else:
            result.issues.append(issue("error", "target_path_required", f"target.{key}", f"target.{key} is required"))

    output = target.get("output") if isinstance(target.get("output"), dict) else {}
    for key in ("scene", "theme"):
        value = output.get(key)
        if not isinstance(value, str):
            result.issues.append(issue("warning", "output_path_missing", f"target.output.{key}", f"target.output.{key} should be declared"))
            continue
        resolved = resolve_recipe_path(recipe_path, value)
        if "harness/runtime/godot-" not in resolved.as_posix():
            result.issues.append(issue("warning", "output_not_godot_runtime", f"target.output.{key}", "Generated Godot output should live under harness/runtime/godot-<game>/"))

    sources = recipe.get("sources") if isinstance(recipe.get("sources"), dict) else {}
    for key, value in sources.items():
        if key == "concepts" and isinstance(value, list):
            for index, concept in enumerate(value):
                validate_existing_path(recipe_path, concept, f"sources.concepts[{index}]", result)
        elif isinstance(value, str):
            validate_existing_path(recipe_path, value, f"sources.{key}", result)


def load_asset_index(recipe_path: Path, recipe: dict[str, Any], result: Result) -> dict[str, dict[str, Any]]:
    sources = recipe.get("sources") if isinstance(recipe.get("sources"), dict) else {}
    asset_plan = sources.get("asset_plan")
    if not isinstance(asset_plan, str):
        result.issues.append(issue("error", "asset_plan_missing", "sources.asset_plan", "Recipe must reference asset-plan.yaml"))
        return {}
    asset_path = resolve_recipe_path(recipe_path, asset_plan)
    if not asset_path.exists():
        result.issues.append(issue("error", "asset_plan_path_missing", "sources.asset_plan", f"Asset plan missing: {asset_path}"))
        return {}
    doc = load_yaml(asset_path)
    assets = doc.get("assets") if isinstance(doc, dict) else []
    if not isinstance(assets, list):
        result.issues.append(issue("error", "asset_plan_invalid", "sources.asset_plan", "asset-plan.yaml assets must be a list"))
        return {}
    index = {str(entry.get("key")): entry for entry in assets if isinstance(entry, dict) and entry.get("key")}
    result.asset_keys = len(index)
    return index


def validate_assets(recipe: dict[str, Any], asset_index: dict[str, dict[str, Any]], result: Result) -> None:
    assets = recipe.get("assets") if isinstance(recipe.get("assets"), dict) else {}
    required = assets.get("required_keys") if isinstance(assets, dict) else []
    if not isinstance(required, list) or not required:
        result.issues.append(issue("error", "required_assets_missing", "assets.required_keys", "Recipe must declare required asset keys"))
        return
    for key in required:
        validate_asset_key(str(key), "assets.required_keys", asset_index, result)

    for group_name in ("fixed_atoms", "native_controls"):
        group = assets.get(group_name)
        if not isinstance(group, list):
            continue
        for index, entry in enumerate(group):
            if isinstance(entry, dict) and entry.get("key"):
                validate_asset_key(str(entry["key"]), f"assets.{group_name}[{index}]", asset_index, result)


def validate_control_tree(tree: Any, atom_defs: dict[str, Any], asset_index: dict[str, dict[str, Any]], result: Result, path: str = "control_tree") -> None:
    if not isinstance(tree, dict):
        result.issues.append(issue("error", "control_tree_invalid", path, "control_tree must be a mapping"))
        return
    root = tree.get("root") if path == "control_tree" else tree
    if not isinstance(root, dict):
        result.issues.append(issue("error", "control_tree_root_missing", f"{path}.root", "control_tree.root must be a mapping"))
        return
    validate_node(root, atom_defs, asset_index, result, f"{path}.root")


def validate_node(node: dict[str, Any], atom_defs: dict[str, Any], asset_index: dict[str, dict[str, Any]], result: Result, path: str) -> None:
    atom = node.get("atom")
    atom_def: dict[str, Any] = {}
    if not isinstance(atom, str):
        result.issues.append(issue("error", "node_atom_missing", path, "Node must declare atom"))
    elif atom not in atom_defs:
        result.issues.append(issue("error", "unknown_atom", f"{path}.atom", f"Unknown Godot Control atom: {atom}"))
    else:
        atom_def = atom_defs[atom] if isinstance(atom_defs[atom], dict) else {}
        validate_required_properties(node, atom, atom_def, result, path)
        if atom_def.get("supports_nine_slice"):
            if "slice_hints" not in node and "patch_margins" not in node:
                result.issues.append(issue("error", "ninepatch_missing_slice_hints", path, "NinePatchPanel nodes must declare slice_hints or patch_margins"))
            if "content_insets" not in node:
                result.issues.append(issue("error", "ninepatch_missing_content_insets", path, "NinePatchPanel nodes must declare content_insets"))

    asset_key = node.get("asset_key")
    if isinstance(asset_key, str):
        validate_asset_key(asset_key, f"{path}.asset_key", asset_index, result)

    children = node.get("children", [])
    if children and not isinstance(children, list):
        result.issues.append(issue("error", "children_not_list", f"{path}.children", "children must be a list"))
        return
    if atom_def:
        validate_required_children(children, atom, atom_def, result, path)
    for index, child in enumerate(children):
        if not isinstance(child, dict):
            result.issues.append(issue("error", "child_not_mapping", f"{path}.children[{index}]", "Child node must be a mapping"))
            continue
        validate_node(child, atom_defs, asset_index, result, f"{path}.children[{index}]")


def validate_required_properties(node: dict[str, Any], atom: str, atom_def: dict[str, Any], result: Result, path: str) -> None:
    required = atom_def.get("required_properties", [])
    if not isinstance(required, list):
        result.issues.append(issue("warning", "atom_required_properties_invalid", path, f"{atom}.required_properties should be a list"))
        return
    for property_name in required:
        prop = str(property_name)
        if not node_has_property(node, prop):
            result.issues.append(issue("error", "atom_property_missing", path, f"{atom} requires property: {prop}"))


def validate_required_children(children: Any, atom: str, atom_def: dict[str, Any], result: Result, path: str) -> None:
    required = atom_def.get("required_children", [])
    if not isinstance(required, list):
        result.issues.append(issue("warning", "atom_required_children_invalid", path, f"{atom}.required_children should be a list"))
        return
    if not required:
        return
    if not isinstance(children, list):
        result.issues.append(issue("error", "atom_children_missing", path, f"{atom} requires children: {', '.join(str(item) for item in required)}"))
        return
    available = {child_contract_name(child) for child in children if isinstance(child, dict)}
    for child_name in required:
        expected = normalize_contract_name(child_name)
        if expected not in available:
            result.issues.append(issue("error", "atom_child_missing", path, f"{atom} requires child slot: {child_name}"))


def node_has_property(node: dict[str, Any], property_name: str) -> bool:
    aliases = {
        "name": ("name", "node_name"),
        "position_or_anchors": ("position_or_anchors", "position_px", "anchors_preset", "anchor", "layout"),
        "texture": ("texture", "texture_path", "asset_key"),
        "patch_margins": ("patch_margins", "slice_hints"),
        "stylebox": ("stylebox", "stylebox_key", "style", "color_token"),
        "text_binding_or_text_key": ("text_binding_or_text_key", "text_binding", "text_key", "text"),
        "value_binding": ("value_binding", "binding", "bindings"),
    }
    for candidate in aliases.get(property_name, (property_name,)):
        if has_value(node.get(candidate)):
            return True
    return False


def has_value(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, str):
        return bool(value.strip())
    if isinstance(value, (list, dict)):
        return bool(value)
    return True


def child_contract_name(child: dict[str, Any]) -> str:
    for key in ("slot", "child_role", "role"):
        value = child.get(key)
        if has_value(value):
            return normalize_contract_name(value)
    return normalize_contract_name(child.get("node_name", ""))


def normalize_contract_name(value: Any) -> str:
    return str(value or "").strip().lower().replace("-", "_").replace(" ", "_")


def validate_asset_plan_consistency(asset_index: dict[str, dict[str, Any]], result: Result) -> None:
    for key, entry in asset_index.items():
        platforms = entry.get("platforms") or []
        if not isinstance(platforms, list):
            continue
        normalized_platforms = [str(value).strip().lower() for value in platforms]
        if "godot" not in normalized_platforms:
            continue
        godot = entry.get("godot")
        if not isinstance(godot, dict):
            result.issues.append(issue("warning", "godot_platform_without_block", f"asset_plan.{key}", f"Asset platforms include godot but no godot block is declared: {key}"))
            continue
        if not godot.get("target_path") and normalized(godot.get("usage")) != "none":
            result.issues.append(issue("warning", "godot_target_path_missing", f"asset_plan.{key}", f"Godot asset block should declare target_path: {key}"))


def validate_asset_key(key: str, path: str, asset_index: dict[str, dict[str, Any]], result: Result) -> None:
    entry = asset_index.get(key)
    if entry is None:
        result.issues.append(issue("error", "asset_key_missing_from_plan", path, f"Asset key not found in asset-plan.yaml: {key}"))
        return
    platforms = entry.get("platforms") or []
    if isinstance(platforms, list) and "godot" not in [str(value) for value in platforms]:
        result.issues.append(issue("warning", "asset_not_marked_godot", path, f"Asset key is used by Godot recipe but platforms does not include godot: {key}"))
    godot = entry.get("godot")
    if isinstance(godot, dict) and not godot.get("target_path") and normalized(godot.get("usage")) != "none":
        result.issues.append(issue("warning", "godot_target_path_missing", path, f"Asset key has godot block without target_path: {key}"))


def validate_existing_path(recipe_path: Path, value: Any, path: str, result: Result) -> None:
    if not isinstance(value, str):
        result.issues.append(issue("warning", "path_not_string", path, "Path should be a string"))
        return
    resolved = resolve_recipe_path(recipe_path, value)
    if not resolved.exists():
        result.issues.append(issue("error", "source_path_missing", path, f"Source path missing: {resolved}"))


def resolve_recipe_path(recipe_path: Path, value: str) -> Path:
    path = Path(value)
    if path.is_absolute():
        return path
    return (recipe_path.parent / path).resolve()


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data if data is not None else {}


def issue(severity: str, code: str, path: str, message: str) -> Issue:
    return Issue(severity=severity, code=code, path=path, message=message)


def normalized(value: Any) -> str:
    return str(value or "").strip().lower()


def print_report(result: Result) -> None:
    print(f"== {result.recipe} ==")
    print(f"atoms: {result.atoms}")
    print(f"asset keys: {result.asset_keys}")
    if not result.issues:
        print("OK no issues")
        return
    for item in result.issues:
        print(f"{item.severity.upper()} {item.code} {item.path}: {item.message}")


if __name__ == "__main__":
    sys.exit(main())
