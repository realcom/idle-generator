#!/usr/bin/env python3
"""Build per-tab bottom navigation cell skins for the Dokkaebi Godot home UI."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[2]
DESIGN_UI = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "ui"
GODOT_UI = ROOT / "harness" / "runtime" / "godot-dokkaebi" / "assets" / "generated" / "ui"


CELL_SIZE = (108, 92)


def main() -> None:
    normal = build_cell(selected=False)
    selected = build_cell(selected=True)
    outputs = [
        (DESIGN_UI / "outgame_bottom_tab_cell_9slice.png", normal),
        (GODOT_UI / "outgame_bottom_tab_cell_9slice.png", normal),
        (DESIGN_UI / "outgame_tab_selected_9slice.png", selected),
        (GODOT_UI / "outgame_tab_selected_9slice.png", selected),
    ]
    for path, image in outputs:
        path.parent.mkdir(parents=True, exist_ok=True)
        image.save(path)
        print(path)


def build_cell(selected: bool) -> Image.Image:
    width, height = CELL_SIZE
    image = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
    shadow = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
    draw_shadow = ImageDraw.Draw(shadow)
    draw_shadow.rectangle((0, 10, width, height), fill=(0, 0, 0, 118))
    draw_shadow.rounded_rectangle((2, 6, width - 2, height - 1), radius=5, fill=(0, 0, 0, 108))
    shadow = shadow.filter(ImageFilter.GaussianBlur(2.0))
    image.alpha_composite(shadow)

    body = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
    draw = ImageDraw.Draw(body)
    rect = (0, 5, width - 1, height - 1)
    fill_top = (50, 29, 15, 242) if not selected else (20, 49, 60, 246)
    fill_bottom = (15, 9, 6, 248) if not selected else (8, 17, 24, 250)
    draw_vertical_gradient(body, rect, fill_top, fill_bottom, radius=4)

    rim = (205, 153, 68, 214)
    rim_dark = (76, 48, 20, 220)
    if selected:
        glow_layer = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow_layer)
        diamond = [(54, 7), (100, 43), (54, 80), (8, 43)]
        gd.polygon(diamond, fill=(32, 154, 223, 84), outline=(97, 220, 255, 205))
        gd.line((18, 43, 54, 14, 90, 43, 54, 72, 18, 43), fill=(202, 159, 72, 190), width=2)
        body.alpha_composite(glow_layer.filter(ImageFilter.GaussianBlur(1.0)))
        draw.polygon(diamond, fill=(20, 77, 100, 98), outline=(96, 218, 255, 225))
        draw.rounded_rectangle(rect, radius=4, outline=(234, 179, 80, 235), width=2)
        draw.line((0, 8, width, 8), fill=(255, 211, 103, 205), width=2)
        draw.line((31, height - 7, width - 31, height - 7), fill=(42, 187, 255, 230), width=3)
    else:
        draw.rounded_rectangle(rect, radius=4, outline=rim, width=2)
        draw.line((0, 8, width, 8), fill=(229, 174, 76, 165), width=2)
        draw.line((0, height - 6, width, height - 6), fill=(82, 52, 22, 220), width=2)
        draw.line((0, 14, 0, height - 10), fill=(124, 82, 34, 180), width=1)
        draw.line((width - 1, 14, width - 1, height - 10), fill=(5, 4, 3, 210), width=1)
        draw.rounded_rectangle((7, 12, width - 8, height - 13), radius=3, outline=rim_dark, width=1)

    # Small cap ornaments. These are fixed-edge details and keep the center stretch-safe.
    for left in (True, False):
        x0 = 10 if left else width - 28
        x1 = 28 if left else width - 10
        draw.line((x0, 15, x1, 15), fill=(229, 174, 76, 190), width=2)
        draw.line((x0, height - 18, x1, height - 18), fill=(118, 76, 32, 190), width=2)
        draw.arc((x0 - 4, 11, x0 + 10, 25), 180, 270, fill=(229, 174, 76, 185), width=2)
        draw.arc((x1 - 10, 11, x1 + 4, 25), 270, 360, fill=(229, 174, 76, 185), width=2)

    if selected:
        underline = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
        ud = ImageDraw.Draw(underline)
        ud.rounded_rectangle((29, height - 9, width - 29, height - 4), radius=2, fill=(33, 181, 255, 210))
        underline = underline.filter(ImageFilter.GaussianBlur(0.7))
        image.alpha_composite(underline)

    image.alpha_composite(body)
    return image


def draw_vertical_gradient(
    image: Image.Image,
    rect: tuple[int, int, int, int],
    top: tuple[int, int, int, int],
    bottom: tuple[int, int, int, int],
    radius: int,
) -> None:
    x0, y0, x1, y1 = rect
    width = x1 - x0
    height = y1 - y0
    gradient = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(gradient)
    for y in range(height):
        t = y / max(1, height - 1)
        color = tuple(int(top[i] * (1.0 - t) + bottom[i] * t) for i in range(4))
        gdraw.line((0, y, width, y), fill=color)
    mask = Image.new("L", (width, height), 0)
    mdraw = ImageDraw.Draw(mask)
    mdraw.rounded_rectangle((0, 0, width - 1, height - 1), radius=radius, fill=255)
    image.paste(gradient, (x0, y0), mask)


if __name__ == "__main__":
    main()
