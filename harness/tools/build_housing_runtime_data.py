#!/usr/bin/env python3
"""Build Phaser housing runtime JSON from the design YAML source."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INPUT = ROOT / "harness/design/ninja2/housing-building-tech-v0.yaml"
DEFAULT_OUTPUT = ROOT / "harness/runtime/data/ninja2/housing-tech.json"
DEFAULT_ITEM_INDEX = ROOT / "harness/content/ninja2/items/_index.yaml"

PRODUCTION_EFFECT_RE = re.compile(r"_(?:per_min|per_hour)$")


def camel_duplicate_scaling(raw: dict[str, Any] | None) -> dict[str, Any]:
    if not raw:
        return {}
    result: dict[str, Any] = {}
    if "cost_multiplier_per_extra" in raw:
        result["costMultiplierPerExtra"] = raw["cost_multiplier_per_extra"]
    if "time_multiplier_per_extra" in raw:
        result["timeMultiplierPerExtra"] = raw["time_multiplier_per_extra"]
    if "effect_stack" in raw:
        result["effectStack"] = raw["effect_stack"]
    return result


def build_resources(data: dict[str, Any]) -> dict[str, Any]:
    resource_ids = data.get("resource_ids") or {}
    planned = resource_ids.get("planned") or {}
    merged_ids = {
        key: value
        for key, value in resource_ids.items()
        if key != "planned"
    }
    merged_ids.update(planned)

    names = data.get("resource_names") or {}
    icons = ((data.get("runtime_board") or {}).get("resource_icons") or {})
    resources: dict[str, Any] = {}
    for key, item_id in merged_ids.items():
        name = names.get(item_id) or names.get(str(item_id)) or key
        resources[key] = {
            "itemId": item_id,
            "name": name,
            "icon": icons.get(key, ""),
        }
    return resources


def build_level(row: dict[str, Any]) -> dict[str, Any]:
    result = {
        "level": row["level"],
        "effect": row.get("effect") or {},
    }
    if row.get("level_up"):
        result["levelUp"] = row["level_up"]
    return result


def csv_numbers(raw: Any) -> list[float]:
    if raw is None:
        return []
    if isinstance(raw, list):
        values = raw
    else:
        values = [part.strip() for part in str(raw).split(",")]
    result: list[float] = []
    for value in values:
        if value in ("", None):
            continue
        number = float(value)
        result.append(int(number) if number.is_integer() else number)
    return result


def parse_level_effects(raw: Any) -> dict[int, dict[str, Any]]:
    if not raw:
        return {}
    effects_by_level: dict[int, dict[str, Any]] = {}
    for chunk in str(raw).split(";"):
        chunk = chunk.strip()
        if not chunk:
            continue
        match = re.match(r"Lv\s*(\d+)\s+(.+)$", chunk)
        if not match:
            continue
        level = int(match.group(1))
        effect: dict[str, Any] = {}
        for pair in match.group(2).split(","):
            if "=" not in pair:
                continue
            key, value = pair.split("=", 1)
            key = key.strip()
            value = value.strip()
            try:
                number = float(value)
                effect[key] = int(number) if number.is_integer() else number
            except ValueError:
                effect[key] = value
        effects_by_level[level] = effect
    return effects_by_level


def load_building_popup_args(item_index: Path = DEFAULT_ITEM_INDEX) -> dict[int, dict[str, Any]]:
    if not item_index.exists():
        return {}
    index_data = yaml.safe_load(item_index.read_text(encoding="utf-8")) or {}
    item_root = item_index.parent
    result: dict[int, dict[str, Any]] = {}
    for row in index_data.get("items") or []:
        item_id = int(row.get("id") or 0)
        item_file = row.get("file")
        if not item_id or not item_file:
            continue
        path = item_root / str(item_file)
        if not path.exists():
            continue
        item = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        popup_args = item.get("popupArgs") or {}
        if popup_args.get("HousingKey"):
            result[item_id] = popup_args
    return result


def resource_key_by_item_id(resources: dict[str, Any]) -> dict[int, str]:
    return {
        int(resource["itemId"]): key
        for key, resource in resources.items()
        if resource.get("itemId")
    }


def split_actions(raw: Any) -> list[str]:
    if not raw:
        return []
    if isinstance(raw, list):
        return [str(value).strip() for value in raw if str(value).strip()]
    return [part.strip() for part in str(raw).split(",") if part.strip()]


def merge_item_popup_contract(
    result: dict[str, Any],
    popup_args: dict[str, Any] | None,
    item_id_to_resource_key: dict[int, str],
) -> dict[str, Any]:
    if not popup_args:
        return result

    result["role"] = popup_args.get("HousingRole") or result.get("role")
    result["purpose"] = popup_args.get("HousingPurpose") or result.get("purpose", "")
    result["instanceRole"] = popup_args.get("HousingInstanceRole") or result.get("instanceRole")
    result["effectKind"] = popup_args.get("HousingEffectKind") or result.get("effectKind", "")
    result["description"] = popup_args.get("HousingDescription") or result.get("description", "")
    result["tapFlow"] = popup_args.get("HousingTapFlow") or "open_modal_only"
    result["collectTiming"] = popup_args.get("HousingCollectTiming") or ""
    result["collectAnimation"] = popup_args.get("HousingCollectAnimation") or ""
    result["bubblePolicy"] = popup_args.get("HousingBubblePolicy") or ""
    result["featureModal"] = popup_args.get("HousingFeatureModal") or ""
    result["featureActions"] = split_actions(popup_args.get("HousingFeatureActions"))

    level_effects = parse_level_effects(popup_args.get("HousingLevelEffectByLevel"))
    if level_effects:
        for level in result.get("levels") or []:
            effect = dict(level_effects.get(int(level.get("level") or 0), level.get("effect") or {}))
            level["effect"] = effect

    production_item_id = int(popup_args.get("HousingProductionItemDataId") or 0)
    if production_item_id:
        result["production"] = {
            "itemDataId": production_item_id,
            "resourceKey": item_id_to_resource_key.get(production_item_id, ""),
            "rateUnit": popup_args.get("HousingProductionRateUnit") or "per_minute",
            "rateByLevel": csv_numbers(popup_args.get("HousingProductionRateByLevel")),
            "storageMinutesByLevel": csv_numbers(popup_args.get("HousingStorageMinutesByLevel")),
        }
    else:
        result.pop("production", None)

    if not production_item_id:
        for level in result.get("levels") or []:
            effect = level.get("effect") or {}
            level["effect"] = {
                key: value
                for key, value in effect.items()
                if not PRODUCTION_EFFECT_RE.search(key)
            }

    return result


def build_building(
    building: dict[str, Any],
    ui: dict[str, Any],
    default_duplicate_scaling: dict[str, Any],
    item_popup_args: dict[int, dict[str, Any]],
    item_id_to_resource_key: dict[int, str],
) -> dict[str, Any]:
    key = building["key"]
    ui_data = ui.get(key) or {}
    placement_kind = building.get("placement_kind") or "singleton"
    result: dict[str, Any] = {
        "key": key,
        "contentItemId": building.get("content_item_id"),
        "name": building.get("name"),
        "tier": building.get("tier"),
        "role": building.get("role"),
        "purpose": building.get("purpose", ""),
        "footprint": building.get("footprint"),
        "runtimeTiles": building.get("runtime_tiles") or [],
        "runtimeAnchorTile": building.get("runtime_anchor_tile"),
        "spriteKey": building.get("sprite_key"),
        "assetStatus": building.get("asset_status", ""),
        "startsBuilt": bool(building.get("starts_built")),
        "homePreview": bool(ui_data.get("home_preview", False)),
        "icon": ui_data.get("icon", ""),
        "output": ui_data.get("output", ""),
        "kind": ui_data.get("kind", ""),
        "visual": ui_data.get("visual") or {},
        "base": ui_data.get("base") or {},
        "construction": building.get("construction") or {"seconds": 0, "cost": {}},
        "placementKind": placement_kind,
        "instanceRole": building.get("instance_role") or building.get("role"),
        "maxInstancesByLanternLevel": building.get("max_instances_by_lantern_level") or {},
        "effectKind": building.get("effect_kind", ""),
        "levels": [build_level(row) for row in building.get("level_curve") or []],
    }

    if building.get("unlock"):
        result["unlock"] = building["unlock"]

    additional = (building.get("additional_instance") or {}).get("base_construction")
    if additional:
        result["additionalConstruction"] = additional

    raw_duplicate_scaling = building.get("duplicate_scaling")
    if raw_duplicate_scaling:
        result["duplicateScaling"] = camel_duplicate_scaling(raw_duplicate_scaling)
    elif placement_kind == "repeatable":
        result["duplicateScaling"] = camel_duplicate_scaling(default_duplicate_scaling)

    return merge_item_popup_contract(
        result,
        item_popup_args.get(int(result.get("contentItemId") or 0)),
        item_id_to_resource_key,
    )


def build_runtime_data(source: Path) -> dict[str, Any]:
    data = yaml.safe_load(source.read_text(encoding="utf-8"))
    runtime_board = data.get("runtime_board") or {}
    placement_model = data.get("placement_model") or {}
    default_duplicate_scaling = placement_model.get("default_duplicate_scaling") or {}
    ui = runtime_board.get("building_ui") or {}
    resources = build_resources(data)
    item_popup_args = load_building_popup_args()
    item_id_to_resource_key = resource_key_by_item_id(resources)

    return {
        "version": data.get("version"),
        "game": data.get("game"),
        "source": str(source.relative_to(ROOT)),
        "sourceUpdatedAt": str(data.get("updated_at", "")),
        "generatedBy": "harness/tools/build_housing_runtime_data.py",
        "resources": resources,
        "homePaths": runtime_board.get("home_paths") or [],
        "buildings": [
            build_building(
                building,
                ui,
                default_duplicate_scaling,
                item_popup_args,
                item_id_to_resource_key,
            )
            for building in data.get("buildings") or []
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    runtime_data = build_runtime_data(args.input)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(runtime_data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
