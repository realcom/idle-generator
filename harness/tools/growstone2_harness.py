#!/usr/bin/env python3
"""Growstone2/Taskstonebar harness commands."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Iterable

import yaml


ROOT = Path(__file__).resolve().parents[2]
GAME = "taskstonebar"
GODOT_PROJECT = ROOT / "harness" / "runtime" / "godot-taskstonebar"
CONTENT_DIR = ROOT / "harness" / "content" / GAME
INDEX_CATEGORIES = ["achievements", "buffs", "items", "maps", "skills", "units"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("status", help="Print Growstone2 content and asset status.")
    subparsers.add_parser("compile", help="Compile taskstonebar content.")

    audit_parser = subparsers.add_parser("audit-assets", help="Audit assets/growstone2 registry.")
    audit_parser.add_argument("--release", action="store_true", help="Require release-ready asset statuses.")

    smoke_parser = subparsers.add_parser("godot-smoke", help="Run Godot runtime smokes.")
    smoke_parser.add_argument("--skip-progression", action="store_true", help="Skip progression_logic_smoke.gd.")

    verify_parser = subparsers.add_parser("verify", help="Run compile, asset audit, tests, and Godot smokes.")
    verify_parser.add_argument("--skip-godot", action="store_true", help="Skip Godot-dependent checks.")
    verify_parser.add_argument("--release-assets", action="store_true", help="Run asset audit with --release.")

    args = parser.parse_args()
    if args.command == "status":
        return status()
    if args.command == "compile":
        return compile_content()
    if args.command == "audit-assets":
        return audit_assets(release=args.release)
    if args.command == "godot-smoke":
        return godot_smoke(skip_progression=args.skip_progression)
    if args.command == "verify":
        return verify(skip_godot=args.skip_godot, release_assets=args.release_assets)
    parser.error(f"unknown command: {args.command}")
    return 2


def status() -> int:
    print("=== Growstone2 / Taskstonebar status ===")
    print(f"content: {CONTENT_DIR.relative_to(ROOT)}")
    print(f"asset root: assets/growstone2")
    print(f"godot runtime: {GODOT_PROJECT.relative_to(ROOT)}")
    print()
    for category in INDEX_CATEGORIES:
        counts = status_counts(CONTENT_DIR / category / "_index.yaml", category)
        total = sum(counts.values())
        parts = ", ".join(f"{key}={counts[key]}" for key in sorted(counts))
        print(f"{category:12} {total:4d}  {parts}")
    return 0


def status_counts(index_path: Path, category: str) -> dict[str, int]:
    if not index_path.exists():
        return {"missing-index": 1}
    doc = yaml.safe_load(index_path.read_text(encoding="utf-8")) or {}
    rows = doc.get(category) or []
    counts: dict[str, int] = {}
    if not isinstance(rows, list):
        return {"invalid-index": 1}
    for row in rows:
        status_value = "unknown"
        if isinstance(row, dict):
            status_value = str(row.get("status") or "missing-status")
        counts[status_value] = counts.get(status_value, 0) + 1
    return counts


def verify(skip_godot: bool = False, release_assets: bool = False) -> int:
    steps = [
        ("compile", compile_content),
        ("asset audit", lambda: audit_assets(release=release_assets)),
        ("asset audit tests", asset_audit_tests),
    ]
    if not skip_godot:
        steps.append(("godot smoke", lambda: godot_smoke(skip_progression=False)))

    failed = False
    for label, fn in steps:
        print(f"\n=== {label} ===", flush=True)
        code = fn()
        if code != 0:
            failed = True
            print(f"growstone2_harness: {label} failed with exit code {code}", file=sys.stderr)
            break
    if failed:
        return 1
    print("\n✅ growstone2 harness verify passed", flush=True)
    return 0


def compile_content() -> int:
    return run([sys.executable, "harness/tools/idlez_compile.py", GAME])


def audit_assets(release: bool = False) -> int:
    cmd = [sys.executable, "harness/tools/asset_registry_audit.py", GAME]
    if release:
        cmd.append("--release")
    return run(cmd)


def asset_audit_tests() -> int:
    return run([sys.executable, "-m", "unittest", "harness.tools.tests.test_asset_registry_audit"])


def godot_smoke(skip_progression: bool = False) -> int:
    godot = shutil.which("godot")
    if not godot:
        print("growstone2_harness: godot executable not found", file=sys.stderr)
        return 127
    scripts = [
        "res://scripts/tools/json_parse_smoke.gd",
        "res://scripts/tools/smoke.gd",
    ]
    if not skip_progression:
        scripts.append("res://scripts/tools/progression_logic_smoke.gd")
    for script in scripts:
        code = run([godot, "--headless", "--path", str(GODOT_PROJECT), "--script", script])
        if code != 0:
            return code
    return 0


def run(cmd: Iterable[str]) -> int:
    cmd_list = [str(part) for part in cmd]
    print("$ " + " ".join(cmd_list), flush=True)
    return subprocess.run(cmd_list, cwd=ROOT).returncode


if __name__ == "__main__":
    raise SystemExit(main())
