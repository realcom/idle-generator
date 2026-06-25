#!/usr/bin/env python3
"""Build Godot Control scene/theme outputs from a harness Godot UI recipe."""

from __future__ import annotations

import argparse
import os
import shutil
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_ATOMS = ROOT / "harness" / "godot" / "registries" / "control-atoms.yaml"


@dataclass
class ExtResource:
    kind: str
    path: str
    id: str


@dataclass
class BuildState:
    recipe_path: Path
    project_root: Path
    atom_defs: dict[str, Any]
    asset_index: dict[str, dict[str, Any]]
    theme_res_path: str
    dry_run: bool = False
    ext_resources: list[ExtResource] = field(default_factory=list)
    texture_ids: dict[str, str] = field(default_factory=dict)
    copied_assets: list[tuple[Path, Path]] = field(default_factory=list)
    node_count: int = 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--recipe", required=True, type=Path)
    parser.add_argument("--atoms", default=DEFAULT_ATOMS, type=Path)
    parser.add_argument("--dry-run", action="store_true", help="Report output paths without writing files.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    recipe_path = args.recipe.resolve()
    atoms_path = args.atoms.resolve()
    try:
        outputs = build(recipe_path, atoms_path, dry_run=args.dry_run)
    except BuildError as exc:
        print(f"ERROR {exc}", file=sys.stderr)
        return 1
    for output in outputs:
        print(output)
    return 0


def build(recipe_path: Path, atoms_path: Path, dry_run: bool = False) -> list[str]:
    if not recipe_path.exists():
        raise BuildError(f"Recipe missing: {recipe_path}")
    if not atoms_path.exists():
        raise BuildError(f"Atom registry missing: {atoms_path}")

    recipe = load_yaml(recipe_path)
    registry = load_yaml(atoms_path)
    atom_defs = registry.get("atoms") if isinstance(registry, dict) else {}
    if not isinstance(atom_defs, dict):
        raise BuildError("control-atoms.yaml must define atoms")

    target = recipe.get("target") if isinstance(recipe.get("target"), dict) else {}
    output = target.get("output") if isinstance(target.get("output"), dict) else {}
    scene_path = required_output_path(recipe_path, output, "scene")
    theme_path = required_output_path(recipe_path, output, "theme")
    project_path = resolve_recipe_path(recipe_path, require_string(target, "project", "target.project"))
    project_root = project_path.parent
    theme_res_path = to_res_path(theme_path, project_root)

    asset_index = load_asset_index(recipe_path, recipe)
    state = BuildState(
        recipe_path=recipe_path,
        project_root=project_root,
        atom_defs=atom_defs,
        asset_index=asset_index,
        theme_res_path=theme_res_path,
        dry_run=dry_run,
    )
    state.ext_resources.append(ExtResource("Theme", theme_res_path, "1_theme"))
    ensure_required_texture_targets(recipe, state)

    root = recipe.get("control_tree", {}).get("root") if isinstance(recipe.get("control_tree"), dict) else None
    if not isinstance(root, dict):
        raise BuildError("control_tree.root must be a mapping")

    scene_text = render_scene(root, state)
    theme_text = render_theme(recipe)

    if not dry_run:
        scene_path.parent.mkdir(parents=True, exist_ok=True)
        theme_path.parent.mkdir(parents=True, exist_ok=True)
        scene_path.write_text(scene_text, encoding="utf-8")
        theme_path.write_text(theme_text, encoding="utf-8")

    return [
        f"scene: {scene_path}",
        f"theme: {theme_path}",
        f"nodes: {state.node_count}",
        f"ext_resources: {len(state.ext_resources)}",
        f"copied_assets: {len(state.copied_assets)}",
    ]


def ensure_required_texture_targets(recipe: dict[str, Any], state: BuildState) -> None:
    assets = recipe.get("assets") if isinstance(recipe.get("assets"), dict) else {}
    required_keys = assets.get("required_keys") if isinstance(assets.get("required_keys"), list) else []
    for key in required_keys:
        if not isinstance(key, str):
            continue
        entry = state.asset_index.get(key)
        if not isinstance(entry, dict):
            continue
        godot = entry.get("godot") if isinstance(entry.get("godot"), dict) else {}
        if str(godot.get("usage", "")) == "native_control":
            continue
        target_path = godot.get("target_path")
        if not isinstance(target_path, str) or not target_path:
            continue
        if not target_path.lower().endswith((".png", ".jpg", ".jpeg", ".webp")):
            continue
        target = (ROOT / target_path).resolve() if not Path(target_path).is_absolute() else Path(target_path)
        if not is_relative_to(target, state.project_root):
            raise BuildError(f"Godot TextureAtom target_path must live inside the Godot project: {key} -> {target}")
        ensure_texture_target(entry, target, state)


def render_scene(root: dict[str, Any], state: BuildState) -> str:
    body_lines = render_node(root, state, parent_path=None, node_path=".")
    load_steps = len(state.ext_resources) + 1
    lines = [f"[gd_scene load_steps={load_steps} format=3]", ""]
    for resource in state.ext_resources:
        lines.append(f'[ext_resource type="{resource.kind}" path="{resource.path}" id="{resource.id}"]')
    lines.append("")
    lines.extend(body_lines)
    return "\n".join(lines).rstrip() + "\n"


def render_theme(recipe: dict[str, Any]) -> str:
    slug = str(recipe.get("slug", "generated-godot-ui"))
    resource_name = "".join(part.capitalize() for part in slug.replace("_", "-").split("-"))
    return "\n".join(
        [
            "[gd_resource type=\"Theme\" format=3]",
            "",
            "[resource]",
            f"resource_name = {gd_value('Generated' + resource_name)}",
            "",
        ]
    )


def render_node(node: dict[str, Any], state: BuildState, parent_path: str | None, node_path: str) -> list[str]:
    atom = str(node.get("atom", "Control"))
    atom_def = state.atom_defs.get(atom, {}) if isinstance(state.atom_defs.get(atom), dict) else {}
    godot_type = str(atom_def.get("godot_type", "Control"))
    name = str(node.get("node_name") or node.get("name") or atom)
    state.node_count += 1

    header = f'[node name="{escape_string(name)}" type="{escape_string(godot_type)}"'
    if parent_path is not None:
        header += f' parent="{escape_string(parent_path)}"'
    header += "]"

    lines = [header]
    lines.extend(render_common_properties(node, state, atom, godot_type, parent_path is None))
    lines.append("")

    children = node.get("children", [])
    if isinstance(children, list):
        child_parent = "." if parent_path is None else node_path
        for child in children:
            if not isinstance(child, dict):
                continue
            child_name = str(child.get("node_name") or child.get("name") or child.get("atom", "Control"))
            child_path = child_name if child_parent == "." else f"{child_parent}/{child_name}"
            lines.extend(render_node(child, state, parent_path=child_parent, node_path=child_path))
    return lines


def render_common_properties(node: dict[str, Any], state: BuildState, atom: str, godot_type: str, is_root: bool) -> list[str]:
    lines: list[str] = []
    size = vector_from_mapping(node.get("size_px") or node.get("touch_size"))
    position = vector_from_mapping(node.get("position_px")) or (0.0, 0.0)

    lines.append("layout_mode = 3" if is_root else "layout_mode = 0")
    if is_root:
        lines.append('theme = ExtResource("1_theme")')
    if size is not None:
        x, y = position
        width, height = size
        lines.append(f"offset_left = {gd_number(x)}")
        lines.append(f"offset_top = {gd_number(y)}")
        lines.append(f"offset_right = {gd_number(x + width)}")
        lines.append(f"offset_bottom = {gd_number(y + height)}")
        lines.append(f"custom_minimum_size = Vector2({gd_number(width)}, {gd_number(height)})")

    if godot_type == "TextureRect":
        lines.append("expand_mode = 1")
        lines.append("stretch_mode = 5")
        texture_id = texture_ext_resource_id(node, state)
        if texture_id:
            lines.append(f'texture = ExtResource("{texture_id}")')
    elif godot_type == "NinePatchRect":
        texture_id = texture_ext_resource_id(node, state)
        if texture_id:
            lines.append(f'texture = ExtResource("{texture_id}")')
        slice_hints = node.get("slice_hints") or node.get("patch_margins")
        if isinstance(slice_hints, dict):
            for godot_prop, source_key in (
                ("patch_margin_left", "left"),
                ("patch_margin_right", "right"),
                ("patch_margin_top", "top"),
                ("patch_margin_bottom", "bottom"),
            ):
                if source_key in slice_hints:
                    lines.append(f"{godot_prop} = {gd_number(float(slice_hints[source_key]))}")
    elif godot_type == "Button":
        lines.append("flat = true")
        text = node.get("text") or node.get("text_key") or ""
        lines.append(f"text = {gd_value(text)}")
    elif godot_type == "Label":
        lines.append(f"horizontal_alignment = {alignment_value(node.get('horizontal_alignment'), 1)}")
        lines.append(f"vertical_alignment = {alignment_value(node.get('vertical_alignment'), 1)}")
        text = node.get("text")
        if text is None:
            text = node.get("preview_text")
        if text is None:
            text = node.get("text_binding_or_text_key", "")
        lines.append(f"text = {gd_value(text)}")
        font_size = node.get("font_size")
        if isinstance(font_size, (int, float)):
            lines.append(f"theme_override_font_sizes/font_size = {gd_number(float(font_size))}")
    elif godot_type == "ProgressBar":
        lines.append("show_percentage = false")
        lines.append("max_value = 1.0")
        lines.append("value = 0.0")
    elif godot_type == "GridContainer":
        columns = node.get("columns")
        if isinstance(columns, (int, float)):
            lines.append(f"columns = {int(columns)}")

    separation = node.get("separation")
    if isinstance(separation, (int, float)) and godot_type in ("HBoxContainer", "VBoxContainer", "GridContainer"):
        if godot_type in ("HBoxContainer", "GridContainer"):
            lines.append(f"theme_override_constants/h_separation = {gd_number(float(separation))}")
        if godot_type in ("VBoxContainer", "GridContainer"):
            lines.append(f"theme_override_constants/v_separation = {gd_number(float(separation))}")

    for key in (
        "atom",
        "component",
        "slot",
        "button_role",
        "asset_key",
        "text_binding_or_text_key",
        "value_binding",
        "color_token",
        "stylebox_key",
        "font_size",
    ):
        value = node.get(key)
        if value is not None:
            lines.append(f"metadata/{key} = {gd_value(value)}")
    return lines


def texture_ext_resource_id(node: dict[str, Any], state: BuildState) -> str:
    asset_key = node.get("asset_key")
    if not isinstance(asset_key, str):
        return ""
    entry = state.asset_index.get(asset_key)
    if not isinstance(entry, dict):
        return ""
    godot = entry.get("godot") if isinstance(entry.get("godot"), dict) else {}
    variant = node_texture_variant(node)
    target_path = godot_target_path(godot, variant)
    if not isinstance(target_path, str) or not target_path:
        return ""
    resolved = (ROOT / target_path).resolve() if not Path(target_path).is_absolute() else Path(target_path)
    if not is_relative_to(resolved, state.project_root):
        raise BuildError(f"Godot TextureAtom target_path must live inside the Godot project: {asset_key} -> {resolved}")
    ensure_texture_variant_targets(entry, state)
    ensure_texture_target(entry, resolved, state, variant)
    texture_key = resolved.as_posix()
    if texture_key in state.texture_ids:
        return state.texture_ids[texture_key]
    resource_id = f"{len(state.ext_resources) + 1}_tex"
    state.texture_ids[texture_key] = resource_id
    state.ext_resources.append(ExtResource("Texture2D", to_res_path(resolved, state.project_root), resource_id))
    return resource_id


def ensure_texture_variant_targets(entry: dict[str, Any], state: BuildState) -> None:
    godot = entry.get("godot") if isinstance(entry.get("godot"), dict) else {}
    paths = godot.get("variant_target_paths") or godot.get("target_paths")
    if not isinstance(paths, dict):
        return
    for variant, target_path in paths.items():
        if not isinstance(target_path, str) or not target_path:
            continue
        target = (ROOT / target_path).resolve() if not Path(target_path).is_absolute() else Path(target_path)
        if not is_relative_to(target, state.project_root):
            raise BuildError(f"Godot TextureAtom target_path must live inside the Godot project: {target}")
        ensure_texture_target(entry, target, state, str(variant))


def node_texture_variant(node: dict[str, Any]) -> str:
    variant = node.get("variant")
    if isinstance(variant, str) and variant:
        return variant
    variants = node.get("variants")
    if isinstance(variants, dict) and variants:
        if "clear" in variants:
            return str(variants["clear"])
        return str(next(iter(variants.values())))
    return ""


def godot_target_path(godot: dict[str, Any], variant: str) -> Any:
    for key in ("variant_target_paths", "target_paths"):
        paths = godot.get(key)
        if isinstance(paths, dict) and variant in paths:
            return paths[variant]
    return godot.get("target_path")


def ensure_texture_target(entry: dict[str, Any], target: Path, state: BuildState, variant: str = "") -> None:
    source = source_texture_path(entry, variant)
    if source is None:
        raise BuildError(f"Cannot find source texture for Godot target: {target}")
    if target.exists() and target.read_bytes() == source.read_bytes():
        return
    if state.dry_run:
        state.copied_assets.append((source, target))
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, target)
    state.copied_assets.append((source, target))


def source_texture_path(entry: dict[str, Any], variant: str = "") -> Path | None:
    godot = entry.get("godot") if isinstance(entry.get("godot"), dict) else {}
    for key in ("variant_source_paths", "source_paths"):
        paths = godot.get(key)
        if isinstance(paths, dict) and variant in paths:
            path = resolve_repo_path(str(paths[variant]))
            if path.is_file():
                return path
    for key in ("runtime_path", "actual_path", "alpha_source_path", "source_path"):
        value = entry.get(key)
        if isinstance(value, str):
            path = resolve_repo_path(value)
            if path.is_file():
                return path
        if isinstance(value, list):
            match = first_variant_path(value, variant)
            if match is not None:
                return match
    phaser = entry.get("phaser") if isinstance(entry.get("phaser"), dict) else {}
    target_path = phaser.get("target_path")
    if isinstance(target_path, str):
        path = resolve_repo_path(target_path)
        if path.is_file():
            return path
    return None


def first_variant_path(values: list[Any], variant: str) -> Path | None:
    fallback: Path | None = None
    for value in values:
        if not isinstance(value, str):
            continue
        path = resolve_repo_path(value)
        if not path.is_file():
            continue
        if fallback is None:
            fallback = path
        if variant and variant in path.stem:
            return path
    return fallback


def resolve_repo_path(value: str) -> Path:
    path = Path(value)
    if path.is_absolute():
        return path
    return (ROOT / path).resolve()


def load_asset_index(recipe_path: Path, recipe: dict[str, Any]) -> dict[str, dict[str, Any]]:
    sources = recipe.get("sources") if isinstance(recipe.get("sources"), dict) else {}
    asset_plan = sources.get("asset_plan")
    if not isinstance(asset_plan, str):
        return {}
    asset_path = resolve_recipe_path(recipe_path, asset_plan)
    doc = load_yaml(asset_path) if asset_path.exists() else {}
    assets = doc.get("assets") if isinstance(doc, dict) else []
    if not isinstance(assets, list):
        return {}
    return {str(entry.get("key")): entry for entry in assets if isinstance(entry, dict) and entry.get("key")}


def required_output_path(recipe_path: Path, output: dict[str, Any], key: str) -> Path:
    value = output.get(key)
    if not isinstance(value, str):
        raise BuildError(f"target.output.{key} is required")
    return resolve_recipe_path(recipe_path, value)


def require_string(mapping: dict[str, Any], key: str, path: str) -> str:
    value = mapping.get(key)
    if not isinstance(value, str):
        raise BuildError(f"{path} is required")
    return value


def resolve_recipe_path(recipe_path: Path, value: str) -> Path:
    path = Path(value)
    if path.is_absolute():
        return path
    return (recipe_path.parent / path).resolve()


def to_res_path(path: Path, project_root: Path) -> str:
    relative = os.path.relpath(path.resolve(), project_root.resolve())
    return "res://" + Path(relative).as_posix()


def is_relative_to(path: Path, base: Path) -> bool:
    try:
        path.resolve().relative_to(base.resolve())
        return True
    except ValueError:
        return False


def vector_from_mapping(value: Any) -> tuple[float, float] | None:
    if not isinstance(value, dict):
        return None
    if "width" in value and "height" in value:
        return (float(value["width"]), float(value["height"]))
    if "x" in value and "y" in value:
        return (float(value["x"]), float(value["y"]))
    return None


def gd_value(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return gd_number(float(value))
    return f'"{escape_string(str(value))}"'


def gd_number(value: float) -> str:
    if float(value).is_integer():
        return f"{int(value)}.0"
    return f"{value:.4f}".rstrip("0").rstrip(".")


def alignment_value(value: Any, default: int) -> int:
    if isinstance(value, (int, float)):
        return int(value)
    if isinstance(value, str):
        normalized = value.strip().lower()
        mapping = {
            "left": 0,
            "top": 0,
            "center": 1,
            "middle": 1,
            "right": 2,
            "bottom": 2,
            "fill": 3,
        }
        if normalized in mapping:
            return mapping[normalized]
    return default


def escape_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data if data is not None else {}


class BuildError(Exception):
    pass


if __name__ == "__main__":
    sys.exit(main())
