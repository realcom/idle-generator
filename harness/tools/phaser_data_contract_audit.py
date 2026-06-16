#!/usr/bin/env python3
"""Audit Phaser UI specs and runtime files for data-driven contracts."""

from __future__ import annotations

import argparse
import json
import posixpath
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[2]
RUNTIME_SPECS_DIR = ROOT / "harness" / "runtime" / "specs" / "ui"
DESIGN_DIR = ROOT / "harness" / "design"

ASSET_EXTENSIONS = (".png", ".jpg", ".jpeg", ".webp", ".gif", ".mp3", ".wav", ".ogg", ".txt", ".bytes")
ASSET_RE = re.compile(r"""(?P<path>(?:\.\.?/)*assets/[A-Za-z0-9_./@%+\-]+\.(?:png|jpg|jpeg|webp|gif|mp3|wav|ogg|txt|bytes))""")
CONST_TABLE_RE = re.compile(
    r"""^\s*(?:export\s+)?(?:const|let|var)\s+"""
    r"""(?P<name>[A-Z][A-Z0-9_]{2,})\s*=\s*"""
    r"""(?:Object\.freeze\()?\s*(?P<kind>[\[{])"""
)
DATA_ID_RE = re.compile(r"""(?<![#\w.])(?P<id>[1-9]\d{4,8})(?![\w.])""")
KOREAN_RE = re.compile(r"""[가-힣]{2,}""")

CONTENT_TABLE_TOKENS = {
    "ACHIEVEMENT",
    "BALANCE",
    "BUILDING",
    "CATALOG",
    "CHOICE",
    "COMPANION",
    "DIFFICULTY",
    "DROP",
    "DUNGEON",
    "ENCOUNTER",
    "EQUIPMENT",
    "GACHA",
    "ITEM",
    "LEVEL",
    "LOOT",
    "MAP",
    "MISSION",
    "PRODUCT",
    "QUEST",
    "RESOURCE",
    "REWARD",
    "SHOP",
    "SKILL",
    "STAGE",
    "UNIT",
}
RUNTIME_CONSTANT_TOKENS = {
    "ANIM",
    "ASSET",
    "COLOR",
    "DIRECTION",
    "FRAME",
    "GEOMETRY",
    "ICON",
    "KEY",
    "LAYOUT",
    "LIMIT",
    "NINESLICE",
    "PATH",
    "SCALE",
    "SIZE",
    "SLICE",
    "TEXTURE",
    "WORLD",
}
ALLOW_MARKERS = (
    "phaser-data-contract: allow",
    "data-contract-allow",
    "hardcode-ok",
)


@dataclass(frozen=True)
class Issue:
    severity: str
    code: str
    file: str
    line: int
    message: str
    symbol: str = ""
    snippet: str = ""


@dataclass
class AssetIndex:
    exact: set[str] = field(default_factory=set)
    prefixes: set[str] = field(default_factory=set)

    @property
    def empty(self) -> bool:
        return not self.exact and not self.prefixes

    def add(self, value: str) -> None:
        normalized = normalize_asset_path(value)
        if not normalized:
            return
        if normalized.lower().endswith(ASSET_EXTENSIONS):
            self.exact.add(normalized)
        else:
            self.prefixes.add(normalized.rstrip("/") + "/")

    def accepts(self, value: str) -> bool:
        normalized = normalize_asset_path(value)
        if not normalized:
            return True
        return normalized in self.exact or any(normalized.startswith(prefix) for prefix in self.prefixes)


@dataclass
class AuditResult:
    spec: Path
    game: str
    runtime_files: list[Path] = field(default_factory=list)
    issues: list[Issue] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not any(issue.severity == "error" for issue in self.issues)

    @property
    def has_warnings(self) -> bool:
        return any(issue.severity == "warning" for issue in self.issues)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", help="Game id under harness/design/<game>.")
    parser.add_argument("--spec", action="append", help="Audit a specific harness/runtime/specs/ui/*.yaml file.")
    parser.add_argument("--all", action="store_true", help="Audit every UI spec.")
    parser.add_argument("--runtime-file", action="append", help="Extra runtime file to scan.")
    parser.add_argument("--asset-plan", help="Asset plan used to verify inline runtime asset paths.")
    parser.add_argument("--root", default=str(ROOT), help="Repository root.")
    parser.add_argument("--check-html-text", action="store_true", help="Also warn on Korean text literals in HTML.")
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = Path(args.root).resolve()
    spec_paths = resolve_specs(args, root)
    if not spec_paths:
        print("No Phaser UI specs found.", file=sys.stderr)
        return 2

    results = [
        audit_spec(
            spec_path=path,
            root=root,
            game=args.game,
            extra_runtime_files=[Path(item) for item in args.runtime_file or []],
            asset_plan=Path(args.asset_plan).resolve() if args.asset_plan else None,
            check_html_text=args.check_html_text,
        )
        for path in spec_paths
    ]

    if args.json:
        print(json.dumps([result_to_json(result) for result in results], ensure_ascii=False, indent=2))
    else:
        print_report(results)

    has_errors = any(not result.ok for result in results)
    has_warnings = any(result.has_warnings for result in results)
    return 1 if has_errors or (args.strict and has_warnings) else 0


def resolve_specs(args: argparse.Namespace, root: Path) -> list[Path]:
    if args.spec:
        return [resolve_repo_path(Path(value), root) for value in args.spec]
    specs_dir = root / "harness" / "runtime" / "specs" / "ui"
    paths = sorted(specs_dir.glob("*.yaml"))
    if args.all or not args.game:
        return paths
    out: list[Path] = []
    for path in paths:
        doc = load_yaml(path)
        if infer_game(doc, args.game, path) == args.game:
            out.append(path)
    return out


def audit_spec(
    spec_path: Path,
    root: Path = ROOT,
    game: str | None = None,
    extra_runtime_files: list[Path] | None = None,
    asset_plan: Path | None = None,
    check_html_text: bool = False,
) -> AuditResult:
    doc = load_yaml(spec_path)
    resolved_game = infer_game(doc, game, spec_path)
    result = AuditResult(spec=spec_path, game=resolved_game)

    data_contract = doc.get("data_contract")
    allowlist = collect_allowlist(data_contract)
    validate_data_contract(data_contract, result, root)

    result.runtime_files = resolve_runtime_files(doc, spec_path, root, extra_runtime_files or [])
    asset_index = build_asset_index(doc, resolved_game, root, asset_plan)

    for runtime_file in result.runtime_files:
        audit_runtime_file(runtime_file, root, asset_index, allowlist, check_html_text, result)

    result.issues = [item for item in result.issues if not issue_allowed(item, allowlist)]
    return result


def validate_data_contract(data_contract: Any, result: AuditResult, root: Path) -> None:
    spec_rel = relpath(result.spec, root)
    if data_contract is None:
        result.issues.append(issue(
            "error",
            "missing_data_contract",
            spec_rel,
            0,
            "Spec must declare data_contract before runtime implementation.",
        ))
        return
    if not isinstance(data_contract, dict):
        result.issues.append(issue(
            "error",
            "invalid_data_contract",
            spec_rel,
            0,
            "data_contract must be a mapping.",
        ))
        return

    source_keys = {
        "bindings",
        "card_fields",
        "content_sources",
        "document_datasets",
        "fixtures",
        "query",
        "scenario",
        "sources",
    }
    if not any(key in data_contract for key in source_keys):
        result.issues.append(issue(
            "warning",
            "thin_data_contract",
            spec_rel,
            0,
            "data_contract should name concrete sources, bindings, datasets, or fixtures.",
        ))


def resolve_runtime_files(doc: dict[str, Any], spec_path: Path, root: Path, extra: list[Path]) -> list[Path]:
    values: list[str] = []
    target = doc.get("target_runtime")
    if isinstance(target, str):
        values.append(target)
    elif isinstance(target, dict):
        for key in ("page", "entrypoint", "script", "owner"):
            value = target.get(key)
            if isinstance(value, str):
                values.append(value)
        runtime_files = target.get("runtime_files")
        if isinstance(runtime_files, list):
            values.extend(str(value) for value in runtime_files)

    for section_name in ("implementation_notes", "runtime_contract", "validation"):
        section = doc.get(section_name)
        if not isinstance(section, dict):
            continue
        runtime_files = section.get("runtime_files")
        if isinstance(runtime_files, list):
            values.extend(str(value) for value in runtime_files)

    paths = [clean_runtime_path(value, root) for value in values]
    paths.extend(resolve_repo_path(path, root) for path in extra)
    deduped: list[Path] = []
    seen: set[Path] = set()
    for path in paths:
        if path in seen:
            continue
        seen.add(path)
        deduped.append(path)
    return deduped


def audit_runtime_file(
    path: Path,
    root: Path,
    asset_index: AssetIndex,
    allowlist: set[str],
    check_html_text: bool,
    result: AuditResult,
) -> None:
    if not path.exists():
        result.issues.append(issue(
            "error",
            "runtime_file_missing",
            relpath(path, root),
            0,
            "Runtime file referenced by the spec does not exist.",
        ))
        return

    text = path.read_text(encoding="utf-8", errors="ignore")
    for line_no, line in enumerate(text.splitlines(), start=1):
        if has_inline_allow_marker(line):
            continue
        scan_content_table(path, root, line_no, line, result)
        scan_data_ids(path, root, line_no, line, result)
        scan_asset_refs(path, root, line_no, line, asset_index, result)
        scan_text_literals(path, root, line_no, line, check_html_text, result)


def scan_content_table(path: Path, root: Path, line_no: int, line: str, result: AuditResult) -> None:
    match = CONST_TABLE_RE.search(line)
    if not match:
        return
    name = match.group("name")
    tokens = set(name.split("_"))
    if not tokens & CONTENT_TABLE_TOKENS:
        return
    if tokens & RUNTIME_CONSTANT_TOKENS and not (tokens & (CONTENT_TABLE_TOKENS - RUNTIME_CONSTANT_TOKENS)):
        return
    result.issues.append(issue(
        "warning",
        "runtime_content_table",
        relpath(path, root),
        line_no,
        f"{name} looks like runtime-owned content data; move it to compiled content, scenario JSON, or the UI spec.",
        symbol=name,
        snippet=line.strip(),
    ))


def scan_data_ids(path: Path, root: Path, line_no: int, line: str, result: AuditResult) -> None:
    if path.suffix.lower() not in {".js", ".mjs", ".html"}:
        return
    for match in DATA_ID_RE.finditer(line):
        data_id = match.group("id")
        result.issues.append(issue(
            "warning",
            "runtime_data_id_literal",
            relpath(path, root),
            line_no,
            f"Data id literal {data_id} should come from compiled JSON, scenario JSON, or a spec fixture.",
            symbol=data_id,
            snippet=line.strip(),
        ))


def scan_asset_refs(path: Path, root: Path, line_no: int, line: str, asset_index: AssetIndex, result: AuditResult) -> None:
    if asset_index.empty:
        return
    for match in ASSET_RE.finditer(line):
        asset_path = normalize_asset_path(match.group("path"))
        if not asset_path or asset_index.accepts(asset_path):
            continue
        result.issues.append(issue(
            "warning",
            "runtime_asset_unplanned",
            relpath(path, root),
            line_no,
            f"Inline asset path {asset_path} is not declared by asset-plan.yaml or the UI spec.",
            symbol=asset_path,
            snippet=line.strip(),
        ))


def scan_text_literals(path: Path, root: Path, line_no: int, line: str, check_html_text: bool, result: AuditResult) -> None:
    suffix = path.suffix.lower()
    if suffix == ".html" and not check_html_text:
        return
    if suffix not in {".js", ".mjs", ".html"}:
        return
    if not KOREAN_RE.search(line):
        return
    if suffix in {".js", ".mjs"} and not any(quote in line for quote in ("'", '"', "`")):
        return
    result.issues.append(issue(
        "warning",
        "runtime_text_literal",
        relpath(path, root),
        line_no,
        "User-facing text literal should be sourced from compiled strings, scenario data, or the UI spec.",
        snippet=line.strip(),
    ))


def build_asset_index(doc: dict[str, Any], game: str, root: Path, asset_plan: Path | None) -> AssetIndex:
    index = AssetIndex()
    collect_asset_paths(doc, index)

    plan_path = asset_plan or (root / "harness" / "design" / game / "asset-plan.yaml")
    if plan_path.exists():
        collect_asset_paths(load_yaml(plan_path), index)
    return index


def collect_asset_paths(value: Any, index: AssetIndex) -> None:
    if isinstance(value, dict):
        for child in value.values():
            collect_asset_paths(child, index)
        return
    if isinstance(value, list):
        for child in value:
            collect_asset_paths(child, index)
        return
    if not isinstance(value, str):
        return
    for match in ASSET_RE.finditer(value):
        index.add(match.group("path"))
    if "assets/" in value:
        index.add(value)


def collect_allowlist(data_contract: Any) -> set[str]:
    if not isinstance(data_contract, dict):
        return set()
    raw = data_contract.get("hardcoding_allowlist") or data_contract.get("allow_hardcoded") or []
    if isinstance(raw, str):
        return {raw}
    if isinstance(raw, list):
        return {str(item) for item in raw}
    return set()


def issue_allowed(item: Issue, allowlist: set[str]) -> bool:
    if not allowlist:
        return False
    candidates = {
        item.code,
        f"{item.code}:{item.symbol}",
        f"{item.file}:{item.line}",
        f"{item.file}:{item.line}:{item.code}",
        f"{item.file}:{item.line}:{item.code}:{item.symbol}",
    }
    return bool(candidates & allowlist)


def has_inline_allow_marker(line: str) -> bool:
    lowered = line.lower()
    return any(marker in lowered for marker in ALLOW_MARKERS)


def infer_game(doc: dict[str, Any], fallback: str | None, spec_path: Path) -> str:
    if isinstance(doc.get("game"), str):
        return str(doc["game"])
    source_design = doc.get("source_design")
    if isinstance(source_design, dict) and isinstance(source_design.get("theme_source_game"), str):
        return str(source_design["theme_source_game"])
    if fallback:
        return fallback
    return spec_path.stem.split("-", 1)[0]


def clean_runtime_path(value: str, root: Path) -> Path:
    clean = value.split("?", 1)[0].split("#", 1)[0]
    if ":" in clean and clean.endswith((".yaml", ".yml")) is False:
        clean = clean.split(":", 1)[0]
    return resolve_repo_path(Path(clean), root)


def resolve_repo_path(path: Path, root: Path) -> Path:
    return path if path.is_absolute() else (root / path).resolve()


def normalize_asset_path(value: str) -> str:
    clean = value.split("?", 1)[0].split("#", 1)[0].strip().strip("\"'")
    clean = clean.removeprefix("./")
    while clean.startswith("../"):
        clean = clean[3:]
    marker = "harness/runtime/"
    if marker in clean:
        clean = clean.split(marker, 1)[1]
    marker = "assets/"
    if marker not in clean:
        return ""
    clean = clean[clean.find(marker):]
    normalized = posixpath.normpath(clean)
    return "" if normalized == "." else normalized


def load_yaml(path: Path) -> dict[str, Any]:
    if not path.exists():
        raise SystemExit(f"YAML file missing: {path}")
    doc = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(doc, dict):
        raise SystemExit(f"YAML root must be a mapping: {path}")
    return doc


def issue(severity: str, code: str, file: str, line: int, message: str, symbol: str = "", snippet: str = "") -> Issue:
    return Issue(severity=severity, code=code, file=file, line=line, message=message, symbol=symbol, snippet=snippet)


def relpath(path: Path, root: Path) -> str:
    try:
        return path.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return path.as_posix()


def result_to_json(result: AuditResult) -> dict[str, Any]:
    return {
        "spec": result.spec.as_posix(),
        "game": result.game,
        "runtime_files": [path.as_posix() for path in result.runtime_files],
        "ok": result.ok,
        "issues": [
            {
                "severity": item.severity,
                "code": item.code,
                "file": item.file,
                "line": item.line,
                "message": item.message,
                "symbol": item.symbol,
                "snippet": item.snippet,
            }
            for item in result.issues
        ],
    }


def print_report(results: list[AuditResult]) -> None:
    for result in results:
        status = "PASS" if result.ok and not result.has_warnings else "WARN" if result.ok else "ERROR"
        print(f"{status}: {relpath(result.spec, ROOT)} ({len(result.runtime_files)} runtime files)")
        for item in result.issues:
            location = f"{item.file}:{item.line}" if item.line else item.file
            symbol = f" {item.symbol}" if item.symbol else ""
            print(f"{item.severity.upper()}: {location} [{item.code}]{symbol} — {item.message}")
            if item.snippet:
                print(f"  {item.snippet[:180]}")


if __name__ == "__main__":
    raise SystemExit(main())
