#!/usr/bin/env python3
"""
sfx_from_h5.py — Web Audio/H5 SFX recipe → preview/export page and optional WAV render.

The input can be a plain JavaScript recipe or an HTML file with inline <script>
blocks. The generated renderer runs the recipe inside a browser with
OfflineAudioContext, then encodes the rendered AudioBuffer as a WAV file.

Examples:
  python3 harness/tools/sfx_from_h5.py --write-template harness/build/sfx/slime_pop.js
  python3 harness/tools/sfx_from_h5.py harness/build/sfx/slime_pop.js --out harness/build/sfx/slime_pop.wav
  python3 harness/tools/sfx_from_h5.py recipe.html --page harness/build/sfx/recipe.render.html --page-only
"""

from __future__ import annotations

import argparse
import html.parser
import json
import os
import shutil
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path
from typing import Iterable


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
DEFAULT_BUILD_DIR = PROJECT_ROOT / "harness" / "build" / "sfx"
RENDERER_TEMPLATE = SCRIPT_DIR / "templates" / "sfx_h5_renderer.html"
RECIPE_TEMPLATE = SCRIPT_DIR / "templates" / "sfx_recipe.js"


class InlineScriptExtractor(html.parser.HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self._capture = False
        self._chunks: list[str] = []
        self.scripts: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.lower() != "script":
            return
        attr_map = {name.lower(): value for name, value in attrs}
        if "src" in attr_map:
            return
        script_type = (attr_map.get("type") or "text/javascript").lower()
        if script_type in ("text/javascript", "application/javascript", "module", ""):
            self._capture = True
            self._chunks = []

    def handle_data(self, data: str) -> None:
        if self._capture:
            self._chunks.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag.lower() == "script" and self._capture:
            self.scripts.append("".join(self._chunks).strip())
            self._capture = False
            self._chunks = []


def read_recipe_source(path: Path) -> str:
    source = path.read_text(encoding="utf-8")
    if path.suffix.lower() not in (".html", ".htm"):
        return source

    parser = InlineScriptExtractor()
    parser.feed(source)
    scripts = [script for script in parser.scripts if script.strip()]
    if not scripts:
        raise SystemExit(f"[ERROR] inline <script> block not found: {path}")
    return "\n\n".join(scripts)


def parse_option(value: str) -> tuple[str, object]:
    if "=" not in value:
        raise argparse.ArgumentTypeError("--option must be key=value")
    key, raw = value.split("=", 1)
    key = key.strip()
    if not key:
        raise argparse.ArgumentTypeError("--option key cannot be empty")
    try:
        parsed: object = json.loads(raw)
    except json.JSONDecodeError:
        parsed = raw
    return key, parsed


def render_template(template: str, replacements: dict[str, str]) -> str:
    rendered = template
    for key, value in replacements.items():
        rendered = rendered.replace(f"__{key}__", value)
    return rendered


def write_render_page(
    recipe_path: Path,
    recipe_source: str,
    page_path: Path,
    *,
    name: str,
    duration: float,
    sample_rate: int,
    channels: int,
    entry: str,
    options: dict[str, object],
    download_name: str,
) -> Path:
    template = RENDERER_TEMPLATE.read_text(encoding="utf-8")
    config = {
        "name": name,
        "sourcePath": str(recipe_path),
        "duration": duration,
        "sampleRate": sample_rate,
        "channels": channels,
        "entry": entry,
        "options": options,
        "downloadName": download_name,
    }
    html = render_template(
        template,
        {
            "SFX_CONFIG_JSON": json.dumps(config, ensure_ascii=False),
            "SFX_RECIPE_SOURCE_JSON": json.dumps(recipe_source),
        },
    )
    page_path.parent.mkdir(parents=True, exist_ok=True)
    page_path.write_text(html, encoding="utf-8")
    return page_path


def write_template(path: Path, *, force: bool) -> None:
    if path.exists() and not force:
        raise SystemExit(f"[ERROR] already exists: {path} (use --force to overwrite)")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(RECIPE_TEMPLATE.read_text(encoding="utf-8"), encoding="utf-8")
    print(f"[OK] wrote recipe template: {path}")


def candidate_node_modules(explicit: str | None) -> Iterable[Path]:
    if explicit:
        yield Path(explicit).expanduser()

    for part in os.environ.get("NODE_PATH", "").split(os.pathsep):
        if part:
            yield Path(part).expanduser()

    yield PROJECT_ROOT / "node_modules"

    node_path = shutil.which("node")
    if node_path:
        node = Path(node_path).resolve()
        yield node.parent.parent / "node_modules"

    yield Path.home() / ".cache" / "codex-runtimes" / "codex-primary-runtime" / "dependencies" / "node" / "node_modules"


def find_playwright_node_path(explicit: str | None) -> Path | None:
    for node_modules in candidate_node_modules(explicit):
        if (node_modules / "playwright").exists():
            return node_modules
    return None


def render_with_playwright(page_path: Path, out_path: Path, *, node_modules: str | None) -> bool:
    node = shutil.which("node")
    if not node:
        print("[WARN] node not found; use the generated HTML page to export manually.", file=sys.stderr)
        return False

    playwright_modules = find_playwright_node_path(node_modules)
    if not playwright_modules:
        print("[WARN] playwright not found; use the generated HTML page to export manually.", file=sys.stderr)
        return False

    driver = r"""
const fs = require("fs");
const path = require("path");
const { chromium } = require("playwright");

async function main() {
  const pagePath = path.resolve(process.argv[2]);
  const outPath = path.resolve(process.argv[3]);
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  page.on("console", (msg) => {
    const text = msg.text();
    if (text) console.error(`[browser:${msg.type()}] ${text}`);
  });
  await page.goto(`file://${pagePath}`);
  await page.waitForFunction(() => typeof window.__sfxRenderForAutomation === "function");
  const result = await page.evaluate(() => window.__sfxRenderForAutomation());
  await browser.close();
  if (!result || !result.ok) {
    throw new Error((result && result.error) || "renderer returned no WAV data");
  }
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  const bytes = Buffer.from(result.base64, "base64");
  fs.writeFileSync(outPath, bytes);
  console.log(JSON.stringify({ out: outPath, bytes: bytes.length, stats: result.stats }, null, 2));
}

main().catch((error) => {
  console.error(error && error.stack ? error.stack : String(error));
  process.exit(1);
});
"""

    with tempfile.TemporaryDirectory(prefix="sfx-h5-") as tmp:
        driver_path = Path(tmp) / "render.cjs"
        driver_path.write_text(driver, encoding="utf-8")
        env = os.environ.copy()
        existing = env.get("NODE_PATH")
        env["NODE_PATH"] = str(playwright_modules) if not existing else f"{playwright_modules}{os.pathsep}{existing}"
        cmd = [node, str(driver_path), str(page_path), str(out_path)]
        proc = subprocess.run(cmd, text=True, capture_output=True, env=env)

    if proc.returncode != 0:
        print(proc.stderr.strip(), file=sys.stderr)
        print("[WARN] automatic render failed; use the generated HTML page to export manually.", file=sys.stderr)
        return False

    if proc.stderr.strip():
        print(proc.stderr.strip(), file=sys.stderr)
    print(proc.stdout.strip())
    return True


def positive_float(value: str) -> float:
    parsed = float(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be > 0")
    return parsed


def positive_int(value: str) -> int:
    parsed = int(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be > 0")
    return parsed


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Generate a browser renderer and optional WAV from H5/Web Audio SFX code.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent(
            """\
            Recipe contract:
              - Preferred: define async function renderSfx(ctx, options) { ... }
              - Also works: top-level Web Audio code that calls new AudioContext()
              - Optional entry: pass --entry playSfx for snippets that define playSfx()
            """
        ),
    )
    parser.add_argument("input", nargs="?", type=Path, help="JS recipe or HTML file with inline script blocks")
    parser.add_argument("--out", type=Path, help="WAV output path; attempts automatic render when Playwright is available")
    parser.add_argument("--page", type=Path, help="renderer HTML path")
    parser.add_argument("--page-only", action="store_true", help="only write the renderer page")
    parser.add_argument("--name", help="SFX display name; defaults to input stem")
    parser.add_argument("--duration", type=positive_float, default=1.0, help="offline render duration in seconds")
    parser.add_argument("--sample-rate", type=positive_int, default=44100, help="WAV sample rate")
    parser.add_argument("--channels", type=int, choices=(1, 2), default=1, help="WAV channel count")
    parser.add_argument("--entry", default="", help="function name to call after evaluating the recipe")
    parser.add_argument("--option", action="append", type=parse_option, default=[], help="recipe option as key=value; value may be JSON")
    parser.add_argument("--node-modules", help="node_modules path containing Playwright for automatic render")
    parser.add_argument("--write-template", type=Path, help="write an editable JS recipe template and exit")
    parser.add_argument("--force", action="store_true", help="overwrite --write-template destination")

    args = parser.parse_args(argv)

    if args.write_template:
        write_template(args.write_template, force=args.force)
        return 0

    if not args.input:
        parser.error("input is required unless --write-template is used")
    recipe_path = args.input.resolve()
    if not recipe_path.exists():
        raise SystemExit(f"[ERROR] input not found: {recipe_path}")

    name = args.name or recipe_path.stem
    out_path = args.out.resolve() if args.out else (DEFAULT_BUILD_DIR / f"{name}.wav")
    page_path = args.page.resolve() if args.page else (DEFAULT_BUILD_DIR / f"{name}.render.html")
    options = dict(args.option)
    recipe_source = read_recipe_source(recipe_path)

    write_render_page(
        recipe_path,
        recipe_source,
        page_path,
        name=name,
        duration=args.duration,
        sample_rate=args.sample_rate,
        channels=args.channels,
        entry=args.entry,
        options=options,
        download_name=out_path.name,
    )
    print(f"[OK] renderer page: {page_path}")

    if args.page_only:
        print(f"[INFO] open the page in a browser and click Export WAV. Suggested output: {out_path}")
        return 0

    rendered = render_with_playwright(page_path, out_path, node_modules=args.node_modules)
    if rendered:
        print(f"[OK] wav: {out_path}")
        return 0

    print(f"[INFO] open the page in a browser and click Export WAV. Suggested output: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
