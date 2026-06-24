#!/usr/bin/env python3
"""Post-process individually generated Dokkaebi outgame UI assets.

The source files come from built-in imagegen one asset at a time. This script
keeps the chroma-key source for provenance, removes the flat key background via
the shared imagegen helper, trims transparent padding, fits each asset to its
runtime target aspect, and mirrors outputs into design, Godot, and shared
runtime folders.
"""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[2]
GEN_ROOT = Path("/Users/yangjinhwan/.codex/generated_images/019ef0b9-4c8c-7af0-9000-9c2b2536099b")
SOURCE_DIR = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "ui" / "source" / "dokkaebi_outgame_imagegen_v2"
DESIGN_UI = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "ui"
GODOT_UI = ROOT / "harness" / "runtime" / "godot-dokkaebi" / "assets" / "generated" / "ui"
PHASER_UI = ROOT / "harness" / "runtime" / "assets" / "dokkaebi" / "ui"
REMOVE_KEY = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))) / "skills" / ".system" / "imagegen" / "scripts" / "remove_chroma_key.py"


@dataclass(frozen=True)
class Asset:
    name: str
    generated_file: str
    target_size: tuple[int, int]
    fit_scale: float = 0.94


ASSETS: tuple[Asset, ...] = (
    Asset("outgame_event_daily_v2", "ig_006dcadba15f0350016a39988e14b881918f57c1716283dfef.png", (300, 180), 0.96),
    Asset("outgame_event_relic_v2", "ig_0939c997d13d11f3016a39992241a48191b469cf625971b64b.png", (300, 180), 0.96),
    Asset("outgame_event_boss_v2", "ig_0939c997d13d11f3016a399952f86c8191bcbd597705bdc9c8.png", (300, 180), 0.96),
    Asset("outgame_event_locked_v2", "ig_0939c997d13d11f3016a39998646bc81919fc339dd5cf93723.png", (300, 180), 0.96),
    Asset("outgame_event_chest_v2", "ig_0939c997d13d11f3016a3999c9131081918c82bd4537e87326.png", (300, 180), 0.96),
    Asset("outgame_command_reward_v2", "ig_0939c997d13d11f3016a399a06ed008191931c2a018b8b323b.png", (328, 328), 0.96),
    Asset("outgame_command_training_v2", "ig_0939c997d13d11f3016a399a5951548191a4a374c20fd60349.png", (328, 328), 0.96),
    Asset("outgame_sortie_cta_v2", "ig_0939c997d13d11f3016a399aa8b9e8819198307784ffb012d3.png", (336, 248), 0.97),
    Asset("outgame_bottom_dock_v2", "ig_0939c997d13d11f3016a399ae028e88191a8e3c8c0bd2f6e85.png", (1080, 224), 0.98),
    Asset("outgame_tab_selected_v2", "ig_07326ea27d37eb37016a39a1848bdc8191adbe43cf69ff453f.png", (208, 184), 0.94),
    Asset("outgame_tab_home_v2", "ig_0939c997d13d11f3016a399b1f44e48191bf06a20b6c56018d.png", (128, 128), 0.92),
    Asset("outgame_tab_yokai_v2", "ig_0939c997d13d11f3016a399b54cb7c8191982e44859215a2ec.png", (128, 128), 0.92),
    Asset("outgame_tab_weapon_v2", "ig_0939c997d13d11f3016a399b84af6481918f77a4f0ba33b595.png", (128, 128), 0.92),
    Asset("outgame_tab_talisman_v2", "ig_0939c997d13d11f3016a399bcdb46081919894476c07b61aee.png", (128, 128), 0.92),
    Asset("outgame_tab_shop_v2", "ig_0939c997d13d11f3016a399c1d4aa8819191e91eb2a56e94f0.png", (128, 128), 0.92),
    Asset("outgame_top_profile_chip_v2", "ig_0939c997d13d11f3016a399c56e2e48191be442eb8eb38ca4a.png", (300, 100), 0.97),
    Asset("outgame_top_resource_chip_v2", "ig_0939c997d13d11f3016a399c85a53881919b391964639e70f8.png", (192, 84), 0.96),
    Asset("outgame_top_mail_button_v2", "ig_0939c997d13d11f3016a399cbeabc48191b70b8cf5d851c456.png", (96, 96), 0.94),
    Asset("outgame_resource_stamina_v2", "ig_0939c997d13d11f3016a399cef64fc8191ac59100087602d7c.png", (96, 96), 0.90),
    Asset("outgame_resource_coin_v2", "ig_0939c997d13d11f3016a399d3a6b848191af31e0bb293eddcb.png", (96, 96), 0.90),
    Asset("outgame_resource_gem_v2", "ig_0939c997d13d11f3016a399d9810708191b17ffe0a5d3e3bec.png", (96, 96), 0.90),
)


def main() -> None:
    for path in (SOURCE_DIR, DESIGN_UI, GODOT_UI, PHASER_UI):
        path.mkdir(parents=True, exist_ok=True)
    if not REMOVE_KEY.exists():
        raise FileNotFoundError(f"Missing imagegen chroma-key helper: {REMOVE_KEY}")

    for asset in ASSETS:
        source = GEN_ROOT / asset.generated_file
        if not source.exists():
            raise FileNotFoundError(f"Missing generated source for {asset.name}: {source}")

        chroma_path = SOURCE_DIR / f"{asset.name}_chromakey.png"
        alpha_path = SOURCE_DIR / f"{asset.name}_alpha.png"
        final_name = f"{asset.name}.png"

        shutil.copy2(source, chroma_path)
        subprocess.run(
            [
                sys.executable,
                str(REMOVE_KEY),
                "--input",
                str(chroma_path),
                "--out",
                str(alpha_path),
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

        final = fit_to_target(alpha_path, asset.target_size, asset.fit_scale)
        for out_dir in (DESIGN_UI, GODOT_UI, PHASER_UI):
            final.save(out_dir / final_name)
        print(DESIGN_UI / final_name)


def fit_to_target(path: Path, target_size: tuple[int, int], fit_scale: float) -> Image.Image:
    image = Image.open(path).convert("RGBA")
    alpha = image.getchannel("A")
    bbox = alpha.point(lambda px: 255 if px > 8 else 0).getbbox()
    if bbox is None:
        raise ValueError(f"No non-transparent pixels found in {path}")

    cropped = image.crop(bbox)
    target_w, target_h = target_size
    max_w = int(target_w * fit_scale)
    max_h = int(target_h * fit_scale)
    scale = min(max_w / cropped.width, max_h / cropped.height)
    resized = cropped.resize(
        (max(1, int(cropped.width * scale)), max(1, int(cropped.height * scale))),
        Image.Resampling.LANCZOS,
    )

    result = Image.new("RGBA", target_size, (0, 0, 0, 0))
    x = (target_w - resized.width) // 2
    y = (target_h - resized.height) // 2
    result.alpha_composite(resized, (x, y))
    return result


if __name__ == "__main__":
    main()
