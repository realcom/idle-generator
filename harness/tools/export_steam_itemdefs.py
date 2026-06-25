#!/usr/bin/env python3
"""
export_steam_itemdefs.py

Build a Steam Inventory ItemDef preview from content item YAML `_economy.steam`
blocks. This is intentionally a preview/export skeleton: public icon URLs,
appid, pricing, and partner-site upload concerns are filled later.

Usage:
  python3 harness/tools/export_steam_itemdefs.py taskstonebar
  python3 harness/tools/export_steam_itemdefs.py taskstonebar /tmp/itemdefs.json
"""
import json
import os
import sys

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_yaml(path):
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def stringify_tags(*tag_maps):
    merged = {}
    for tags in tag_maps:
        if tags:
            merged.update({key: value for key, value in tags.items() if value is not None})
    if not merged:
        return ""
    return ";".join(f"{key}:{value}" for key, value in merged.items())


def itemdef_from_item(item, source):
    economy = item.get("_economy") or {}
    steam = economy.get("steam") or {}
    if not steam.get("enabled"):
        return None

    itemdefid = steam.get("itemdefid") or item.get("id")
    if not itemdefid:
        raise ValueError(f"{source}: steam.enabled item is missing itemdefid/id")

    out = {
        "itemdefid": int(itemdefid),
        "type": steam.get("itemdef_type", "item"),
        "name": steam.get("market_hash_name") or item.get("name"),
        "display_type": steam.get("display_type") or economy.get("role", "Item"),
        "marketable": bool(steam.get("marketable")),
        "tradable": bool(steam.get("tradable")),
        "auto_stack": bool(steam.get("auto_stack")),
        "store_hidden": bool(steam.get("store_hidden", True)),
    }

    market_identity = steam.get("market_identity") or {}
    tags = stringify_tags(steam.get("tags"), market_identity)
    if tags:
        out["tags"] = tags

    # Keep source breadcrumbs outside the Steam schema in a namespaced extension.
    out["x_taskstonebar"] = {
        "source": source,
        "content_item_id": item.get("id"),
        "korean_name": item.get("name"),
        "role": economy.get("role"),
        "market_lot_size": (economy.get("stack") or {}).get("market_lot_size"),
        "market_identity": market_identity,
    }
    return out


def collect_itemdefs(game):
    base = os.path.join(ROOT, "content", game, "items")
    index_path = os.path.join(base, "_index.yaml")
    index = load_yaml(index_path)
    rows = index.get("items") or []

    itemdefs = []
    seen = {}
    for row in rows:
        rel = row.get("file")
        if not rel:
            continue
        path = os.path.join(base, rel)
        if not os.path.exists(path):
            continue
        item = load_yaml(path)
        itemdef = itemdef_from_item(item, os.path.relpath(path, ROOT))
        if not itemdef:
            continue
        old = seen.get(itemdef["itemdefid"])
        if old:
            raise ValueError(f"duplicate itemdefid {itemdef['itemdefid']}: {old} and {path}")
        seen[itemdef["itemdefid"]] = path
        itemdefs.append(itemdef)

    return sorted(itemdefs, key=lambda row: row["itemdefid"])


def main():
    game = sys.argv[1] if len(sys.argv) > 1 else "taskstonebar"
    out_path = (
        sys.argv[2]
        if len(sys.argv) > 2
        else os.path.join(ROOT, "build", game, "SteamItemDefs.preview.json")
    )

    itemdefs = collect_itemdefs(game)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(itemdefs, f, ensure_ascii=False, indent=2)
        f.write("\n")

    print(f"wrote {len(itemdefs)} Steam itemdef preview(s): {out_path}")


if __name__ == "__main__":
    main()
