#!/usr/bin/env python3
"""Post-process scene-level imagegen assets for Dokkaebi outgame home."""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[2]
GEN_ROOT = Path("/Users/yangjinhwan/.codex/generated_images/019ef0b9-4c8c-7af0-9000-9c2b2536099b")
SOURCE_DIR = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "source" / "dokkaebi_outgame_scene_imagegen_v2"
DESIGN_BACKGROUNDS = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "backgrounds"
DESIGN_UNITS = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "units"
GODOT_BACKGROUNDS = ROOT / "harness" / "runtime" / "godot-dokkaebi" / "assets" / "generated" / "backgrounds"
GODOT_UNITS = ROOT / "harness" / "runtime" / "godot-dokkaebi" / "assets" / "generated" / "units"
PHASER_BACKGROUNDS = ROOT / "harness" / "runtime" / "assets" / "dokkaebi" / "backgrounds"
PHASER_UNITS = ROOT / "harness" / "runtime" / "assets" / "dokkaebi" / "units"
REMOVE_KEY = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))) / "skills" / ".system" / "imagegen" / "scripts" / "remove_chroma_key.py"

BACKGROUND_SOURCE = "ig_0668d8f64d5e089e016a39a5018a448191a0df74c18de69bfc.png"
HAEIL_SOURCE = "ig_0668d8f64d5e089e016a39a558d8548191a2b9e6086f4467a9.png"


def main() -> None:
    for path in (SOURCE_DIR, DESIGN_BACKGROUNDS, DESIGN_UNITS, GODOT_BACKGROUNDS, GODOT_UNITS, PHASER_BACKGROUNDS, PHASER_UNITS):
        path.mkdir(parents=True, exist_ok=True)

    bg_source = copy_source(BACKGROUND_SOURCE, "outgame_courtyard_bg_v2_source.png")
    bg = cover_resize(Image.open(bg_source).convert("RGB"), (540, 960))
    for out_dir in (DESIGN_BACKGROUNDS, GODOT_BACKGROUNDS, PHASER_BACKGROUNDS):
        bg.save(out_dir / "outgame_courtyard_bg_v2.png")

    hero_chroma = copy_source(HAEIL_SOURCE, "haeil_lobby_v2_chromakey.png")
    hero_alpha = SOURCE_DIR / "haeil_lobby_v2_alpha.png"
    subprocess.run(
        [
            sys.executable,
            str(REMOVE_KEY),
            "--input",
            str(hero_chroma),
            "--out",
            str(hero_alpha),
            "--auto-key",
            "border",
            "--soft-matte",
            "--transparent-threshold",
            "12",
            "--opaque-threshold",
            "220",
            "--despill",
            "--force",
        ],
        check=True,
    )
    hero = fit_alpha(Image.open(hero_alpha).convert("RGBA"), (360, 560), 0.96)
    for out_dir in (DESIGN_UNITS, GODOT_UNITS, PHASER_UNITS):
        hero.save(out_dir / "haeil_lobby_v2.png")

    print(DESIGN_BACKGROUNDS / "outgame_courtyard_bg_v2.png")
    print(DESIGN_UNITS / "haeil_lobby_v2.png")


def copy_source(generated_name: str, output_name: str) -> Path:
    source = GEN_ROOT / generated_name
    if not source.exists():
        raise FileNotFoundError(source)
    target = SOURCE_DIR / output_name
    shutil.copy2(source, target)
    return target


def cover_resize(image: Image.Image, target: tuple[int, int]) -> Image.Image:
    target_w, target_h = target
    scale = max(target_w / image.width, target_h / image.height)
    resized = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.LANCZOS)
    x = max(0, (resized.width - target_w) // 2)
    y = max(0, (resized.height - target_h) // 2)
    return resized.crop((x, y, x + target_w, y + target_h))


def fit_alpha(image: Image.Image, target: tuple[int, int], fit_scale: float) -> Image.Image:
    alpha = image.getchannel("A")
    bbox = alpha.point(lambda px: 255 if px > 8 else 0).getbbox()
    if bbox is None:
        raise ValueError("hero alpha image is empty")
    cropped = image.crop(bbox)
    max_w, max_h = int(target[0] * fit_scale), int(target[1] * fit_scale)
    scale = min(max_w / cropped.width, max_h / cropped.height)
    resized = cropped.resize((max(1, int(cropped.width * scale)), max(1, int(cropped.height * scale))), Image.Resampling.LANCZOS)
    result = Image.new("RGBA", target, (0, 0, 0, 0))
    result.alpha_composite(resized, ((target[0] - resized.width) // 2, (target[1] - resized.height) // 2))
    return result


if __name__ == "__main__":
    main()
