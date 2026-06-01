#!/usr/bin/env python3
"""
HTTP server for the Resource Visualizer.

Run:
    python3 tools/serve_visualizer.py
Then open:
    http://localhost:8080/tools/visualizer.html

In addition to static files, this server exposes:
    GET /api/growth      -> aggregated growth-formula index (parsed from content/**/*.growth.md)
"""

import http.server
import json
import os
import re
import socketserver
import sys
from pathlib import Path

PORT = int(os.environ.get("PORT", "8080"))
ROOT = Path(__file__).resolve().parent.parent
CONTENT_DIR = ROOT / "content"
ASSETS_DIR = ROOT / "runtime" / "assets"

# Spine triple extensions — when all three exist for the same stem, it's a spine asset.
SPINE_EXTS = {".atlas.txt", ".skel.bytes", ".png"}
IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp"}


def _parse_frontmatter(text: str):
    """Parse YAML frontmatter delimited by --- ... ---. Returns (meta_dict, body)."""
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n?(.*)$", text, re.DOTALL)
    if not m:
        return {}, text
    raw, body = m.group(1), m.group(2)

    try:
        import yaml  # type: ignore
        meta = yaml.safe_load(raw) or {}
    except Exception:
        meta = _shallow_yaml_parse(raw)
    return meta, body


def _shallow_yaml_parse(text: str):
    """Minimal YAML-ish parser as a fallback when PyYAML isn't installed.
    Handles the simple shapes used in growth.md frontmatter:
      key: value
      key:
        sub: value
      key: { a: b, c: d }
      - field: ...
    """
    def coerce(v: str):
        v = v.strip()
        if v == "" or v.lower() == "null":
            return None
        if v.lower() in ("true", "false"):
            return v.lower() == "true"
        try:
            if "." in v:
                return float(v)
            return int(v)
        except ValueError:
            pass
        if v.startswith('"') and v.endswith('"'):
            return v[1:-1]
        if v.startswith("'") and v.endswith("'"):
            return v[1:-1]
        return v

    def parse_inline(s: str):
        s = s.strip()
        if s.startswith("{") and s.endswith("}"):
            inner = s[1:-1].strip()
            obj = {}
            if inner:
                for part in _smart_split(inner, ","):
                    if ":" in part:
                        k, val = part.split(":", 1)
                        obj[k.strip()] = parse_inline(val)
                    else:
                        obj[part.strip()] = None
            return obj
        if s.startswith("[") and s.endswith("]"):
            inner = s[1:-1].strip()
            if not inner:
                return []
            return [parse_inline(x) for x in _smart_split(inner, ",")]
        return coerce(s)

    lines = [ln for ln in text.splitlines() if ln.strip() and not ln.strip().startswith("#")]
    return _parse_block(lines, 0)[0]


def _smart_split(s: str, sep: str):
    out, depth, buf = [], 0, ""
    for ch in s:
        if ch in "{[":
            depth += 1
        elif ch in "}]":
            depth -= 1
        if ch == sep and depth == 0:
            out.append(buf)
            buf = ""
        else:
            buf += ch
    if buf:
        out.append(buf)
    return out


def _parse_block(lines, indent):
    """Parse a block of lines at a given indentation. Returns (value, consumed)."""
    if not lines:
        return {}, 0

    # detect list block
    first = lines[0]
    first_indent = len(first) - len(first.lstrip(" "))
    if first.lstrip().startswith("- "):
        items = []
        i = 0
        while i < len(lines):
            ln = lines[i]
            li = len(ln) - len(ln.lstrip(" "))
            if li < first_indent:
                break
            if li == first_indent and ln.lstrip().startswith("- "):
                rest = ln.lstrip()[2:]
                if ":" in rest and not rest.strip().startswith("{"):
                    # inline dict start, gather subsequent indented lines
                    sub_lines = [" " * (first_indent + 2) + rest]
                    j = i + 1
                    while j < len(lines):
                        nl = lines[j]
                        ni = len(nl) - len(nl.lstrip(" "))
                        if ni > first_indent:
                            sub_lines.append(nl)
                            j += 1
                        else:
                            break
                    val, _ = _parse_block(sub_lines, first_indent + 2)
                    items.append(val)
                    i = j
                else:
                    items.append(_shallow_yaml_parse(rest) if rest.startswith("{") else rest)
                    i += 1
            else:
                i += 1
        return items, i

    # dict block
    result = {}
    i = 0
    while i < len(lines):
        ln = lines[i]
        li = len(ln) - len(ln.lstrip(" "))
        if li < indent:
            break
        if li != indent:
            i += 1
            continue
        stripped = ln.strip()
        if ":" not in stripped:
            i += 1
            continue
        key, _, rest = stripped.partition(":")
        key = key.strip()
        rest = rest.strip()
        if rest == "":
            # nested
            sub_lines = []
            j = i + 1
            while j < len(lines):
                nl = lines[j]
                ni = len(nl) - len(nl.lstrip(" "))
                if ni > indent:
                    sub_lines.append(nl)
                    j += 1
                else:
                    break
            val, _ = _parse_block(sub_lines, indent + 2)
            result[key] = val
            i = j
        else:
            if rest.startswith("{") or rest.startswith("["):
                result[key] = _shallow_yaml_parse_inline(rest)
            else:
                result[key] = _coerce_scalar(rest)
            i += 1
    return result, i


def _shallow_yaml_parse_inline(s: str):
    return _parse_inline_value(s)


def _parse_inline_value(s: str):
    s = s.strip()
    if s.startswith("{") and s.endswith("}"):
        inner = s[1:-1].strip()
        obj = {}
        if inner:
            for part in _smart_split(inner, ","):
                if ":" in part:
                    k, val = part.split(":", 1)
                    obj[k.strip()] = _parse_inline_value(val)
                else:
                    obj[part.strip()] = None
        return obj
    if s.startswith("[") and s.endswith("]"):
        inner = s[1:-1].strip()
        if not inner:
            return []
        return [_parse_inline_value(x) for x in _smart_split(inner, ",")]
    return _coerce_scalar(s)


def _coerce_scalar(v: str):
    v = v.strip()
    if v == "" or v.lower() == "null":
        return None
    if v.lower() in ("true", "false"):
        return v.lower() == "true"
    if v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    if v.startswith("'") and v.endswith("'"):
        return v[1:-1]
    try:
        if "." in v:
            return float(v)
        return int(v)
    except ValueError:
        return v


def _extract_formulas(body: str):
    """Parse markdown body to extract per-formula sections.
    Each '## name(level) — comment' (or '## name — ...') block becomes a formula entry.
    Within the block, the first backtick-wrapped line is the formula expression,
    and the markdown table that follows holds param/value pairs.
    """
    formulas = {}
    # Split by H2 headers
    sections = re.split(r"(?m)^##\s+", body)
    for sec in sections[1:]:
        lines = sec.splitlines()
        if not lines:
            continue
        header = lines[0].strip()
        # name is the part up to '(' or ' — ' or whitespace
        name_match = re.match(r"([A-Za-z_][A-Za-z0-9_]*)", header)
        if not name_match:
            continue
        name = name_match.group(1)

        # find first backtick-wrapped expression
        expr = None
        for ln in lines[1:]:
            m = re.search(r"`([^`]+)`", ln)
            if m:
                expr = m.group(1).strip()
                break

        # parse markdown table: | param | value | rows
        params = {}
        for ln in lines:
            ln = ln.strip()
            if not ln.startswith("|") or "---" in ln:
                continue
            cells = [c.strip() for c in ln.strip("|").split("|")]
            if len(cells) >= 2 and cells[0].lower() not in ("param", "parameter", "key"):
                params[cells[0]] = _coerce_scalar(cells[1])

        formulas[name] = {
            "header": header,
            "expression": expr,
            "params": params,
        }
    return formulas


def collect_growth():
    """Scan content/ for *.growth.md and return a list of growth entries."""
    out = []
    if not CONTENT_DIR.exists():
        return out
    for path in CONTENT_DIR.rglob("*.growth.md"):
        try:
            text = path.read_text(encoding="utf-8")
        except Exception as e:
            print(f"[growth] failed reading {path}: {e}", file=sys.stderr)
            continue
        meta, body = _parse_frontmatter(text)
        formulas = _extract_formulas(body)
        # attach formula expression/params to targets if possible
        targets = meta.get("targets") or []
        if isinstance(targets, list):
            for t in targets:
                if isinstance(t, dict):
                    fname = t.get("formula")
                    if fname and fname in formulas:
                        t["expression"] = formulas[fname].get("expression")
                        t["params"] = formulas[fname].get("params")
        out.append({
            "source": str(path.relative_to(ROOT)),
            "id": meta.get("id"),
            "bind": meta.get("bind"),
            "levels": meta.get("levels"),
            "output": meta.get("output"),
            "round": meta.get("round"),
            "clamp": meta.get("clamp"),
            "targets": targets,
            "formulas": formulas,
            "body": body.strip(),
        })
    return out


def collect_assets():
    """Scan runtime/assets/ and group files by stem.
    Returns a list of asset entries:
      { stem, kind: 'spine'|'image', files: { atlas, skel, image }, sizeBytes }
    """
    out = []
    if not ASSETS_DIR.exists():
        return out

    # Group files by stem (strip known compound extensions first)
    groups = {}
    for path in sorted(ASSETS_DIR.iterdir()):
        if not path.is_file():
            continue
        name = path.name
        stem = None
        role = None
        if name.endswith(".atlas.txt"):
            stem = name[: -len(".atlas.txt")]
            role = "atlas"
        elif name.endswith(".skel.bytes"):
            stem = name[: -len(".skel.bytes")]
            role = "skel"
        else:
            ext = path.suffix.lower()
            if ext in IMAGE_EXTS:
                stem = path.stem
                role = "image"
        if stem is None:
            continue
        g = groups.setdefault(stem, {})
        g[role] = {
            "name": name,
            "url": f"/runtime/assets/{name}",
            "sizeBytes": path.stat().st_size,
        }

    for stem, files in sorted(groups.items()):
        is_spine = "atlas" in files and "skel" in files and "image" in files
        out.append({
            "stem": stem,
            "kind": "spine" if is_spine else "image",
            "files": files,
            "sizeBytes": sum(f["sizeBytes"] for f in files.values()),
        })
    return out


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        super().end_headers()

    def do_GET(self):
        if self.path.startswith("/api/growth"):
            return self._serve_json(collect_growth, "Growth aggregation failed")
        if self.path.startswith("/api/assets"):
            return self._serve_json(collect_assets, "Asset scan failed")
        return super().do_GET()

    def _serve_json(self, fn, err_label):
        try:
            data = fn()
            payload = json.dumps(data, ensure_ascii=False, indent=2).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
        except Exception as e:
            self.send_error(500, f"{err_label}: {e}")

    def log_message(self, format, *args):
        print(f"[{self.log_date_time_string()}] {format % args}", file=sys.stderr)


if __name__ == "__main__":
    os.chdir(ROOT)
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print("Resource Visualizer Server")
        print(f"Open: http://localhost:{PORT}/tools/visualizer.html")
        print(f"Growth API: http://localhost:{PORT}/api/growth")
        print(f"Assets API: http://localhost:{PORT}/api/assets")
        print("Press Ctrl+C to stop.\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
