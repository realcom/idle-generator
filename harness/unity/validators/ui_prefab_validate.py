#!/usr/bin/env python3
"""Validate harness Unity UI recipes before generating uGUI prefabs.

This is intentionally lightweight: it catches missing design sources, unknown atom
keys, and obvious region-ratio mistakes before Unity Editor generation.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_RECIPE = ROOT / "harness" / "unity" / "recipes" / "ingame" / "hamster_growth_dock.yaml"
DEFAULT_ATOMS = ROOT / "harness" / "unity" / "registries" / "ugui-atoms.yaml"


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def resolve_recipe_path(recipe_path: Path, value: str) -> Path:
    return (recipe_path.parent / value).resolve()


def collect_atom_refs(value: Any) -> list[str]:
    refs: list[str] = []
    if isinstance(value, dict):
        atom = value.get("atom")
        if isinstance(atom, str):
            refs.append(atom)
        for child in value.values():
            refs.extend(collect_atom_refs(child))
    elif isinstance(value, list):
        for child in value:
            refs.extend(collect_atom_refs(child))
    return refs


def validate(recipe_path: Path, atoms_path: Path) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    if not recipe_path.exists():
        return [f"recipe missing: {recipe_path}"], warnings
    if not atoms_path.exists():
        return [f"atom registry missing: {atoms_path}"], warnings

    recipe = load_yaml(recipe_path)
    registry = load_yaml(atoms_path)

    for key in ("version", "game", "target", "backend", "source_concept", "regions"):
        if key not in recipe:
            errors.append(f"recipe missing required key: {key}")

    atoms = registry.get("atoms", {})
    if not isinstance(atoms, dict) or not atoms:
        errors.append("atom registry has no atoms")
        atoms = {}

    source_concept = recipe.get("source_concept")
    if isinstance(source_concept, str):
        source_path = resolve_recipe_path(recipe_path, source_concept)
        if not source_path.exists():
            errors.append(f"source_concept does not exist: {source_path}")

    for label, source in recipe.get("design_sources", {}).items():
        source_path = resolve_recipe_path(recipe_path, source)
        if not source_path.exists():
            errors.append(f"design source missing for {label}: {source_path}")

    region_ratios = []
    for region_name, region in recipe.get("regions", {}).items():
        atom = region.get("atom") if isinstance(region, dict) else None
        if atom and atom not in atoms:
            errors.append(f"unknown region atom {atom!r} in {region_name}")
        ratio = region.get("height_ratio") if isinstance(region, dict) else None
        if isinstance(ratio, (int, float)):
            region_ratios.append(float(ratio))
        else:
            warnings.append(f"region {region_name} has no numeric height_ratio")

    if region_ratios:
        total = sum(region_ratios)
        if not 0.96 <= total <= 1.04:
            errors.append(f"region height ratios should sum to about 1.0, got {total:.3f}")

    for atom in sorted(set(collect_atom_refs(recipe))):
        if atom not in atoms:
            errors.append(f"unknown atom reference: {atom}")

    for atom_name, atom_def in atoms.items():
        required = atom_def.get("required_children", [])
        if atom_def.get("status") == "generated" and not required:
            warnings.append(f"generated atom {atom_name} has no required_children")

    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--recipe", type=Path, default=DEFAULT_RECIPE)
    parser.add_argument("--atoms", type=Path, default=DEFAULT_ATOMS)
    args = parser.parse_args()

    errors, warnings = validate(args.recipe.resolve(), args.atoms.resolve())
    for warning in warnings:
        print(f"WARN: {warning}")
    for error in errors:
        print(f"ERROR: {error}")

    if errors:
        return 1
    print("ui prefab recipe validation PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
