#!/usr/bin/env python3
"""Generate Dokkaebi outgame home UI PNG assets.

The imagegen source sheet is kept for art provenance, while this script rebuilds
stretch-safe skins and small glyph atoms with deterministic geometry.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[2]
DESIGN_UI = ROOT / "harness" / "design" / "dokkaebi" / "assets" / "ui"
RUNTIME_UI = ROOT / "harness" / "runtime" / "godot-dokkaebi" / "assets" / "generated" / "ui"
PHASER_UI = ROOT / "harness" / "runtime" / "assets" / "dokkaebi" / "ui"


COLORS = {
    "ink": (9, 8, 6, 245),
    "wood": (36, 18, 9, 246),
    "wood_high": (70, 35, 14, 235),
    "gold": (216, 167, 75, 245),
    "gold_deep": (120, 78, 28, 245),
    "parchment": (231, 196, 111, 236),
    "parchment_light": (244, 218, 148, 238),
    "orange": (244, 122, 36, 245),
    "orange_dark": (130, 41, 9, 245),
    "blue": (35, 168, 255, 235),
    "teal": (56, 224, 201, 230),
    "red": (210, 64, 28, 230),
}


def main() -> None:
    for path in (DESIGN_UI, RUNTIME_UI, PHASER_UI):
        path.mkdir(parents=True, exist_ok=True)

    assets = {
        "outgame_parchment_card_9slice.png": parchment_card(),
        "outgame_resource_chip_9slice.png": resource_chip(),
        "outgame_sortie_cta_9slice.png": sortie_cta(),
        "outgame_bottom_dock_9slice.png": bottom_dock(),
        "outgame_tab_selected_9slice.png": tab_selected(),
    }
    icons = icon_set()
    assets.update({f"outgame_icon_{key}.png": image for key, image in icons.items()})
    assets["outgame_icon_set_v1.png"] = pack_icon_atlas(icons)

    for name, image in assets.items():
        for base in (DESIGN_UI, RUNTIME_UI, PHASER_UI):
            image.save(base / name)
        print(DESIGN_UI / name)


def new_canvas(width: int, height: int) -> Image.Image:
    return Image.new("RGBA", (width, height), (0, 0, 0, 0))


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), radius=radius, fill=255)
    return mask


def paste_shadow(canvas: Image.Image, rect: tuple[int, int, int, int], radius: int, alpha: int = 120) -> None:
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(shadow)
    x0, y0, x1, y1 = rect
    draw.rounded_rectangle((x0 + 3, y0 + 4, x1 + 3, y1 + 4), radius=radius, fill=(0, 0, 0, alpha))
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(3)))


def panel_base(width: int, height: int, fill: tuple[int, int, int, int], border: tuple[int, int, int, int], radius: int) -> Image.Image:
    image = new_canvas(width, height)
    paste_shadow(image, (3, 3, width - 5, height - 6), radius)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((4, 3, width - 5, height - 6), radius=radius, fill=fill, outline=border, width=3)
    draw.rounded_rectangle((8, 7, width - 9, height - 10), radius=max(1, radius - 2), outline=(255, 236, 174, 58), width=1)
    return image


def parchment_card() -> Image.Image:
    image = panel_base(192, 112, COLORS["parchment"], COLORS["gold_deep"], 7)
    draw = ImageDraw.Draw(image)
    for x, y in ((16, 15), (170, 15), (16, 92), (170, 92)):
        draw.polygon([(x, y - 6), (x + 7, y), (x, y + 6), (x - 7, y)], fill=(202, 143, 50, 150))
    draw.rectangle((24, 20, 168, 23), fill=(255, 241, 183, 42))
    draw.rectangle((22, 88, 170, 90), fill=(104, 64, 25, 38))
    return image


def resource_chip() -> Image.Image:
    image = panel_base(128, 56, (14, 10, 7, 236), COLORS["gold"], 6)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((13, 13, 41, 42), radius=5, fill=(35, 25, 14, 238), outline=(159, 111, 40, 210), width=2)
    draw.line((104, 17, 104, 39), fill=(154, 105, 37, 160), width=2)
    draw.line((96, 28, 112, 28), fill=(255, 216, 103, 210), width=2)
    draw.line((104, 20, 104, 36), fill=(255, 216, 103, 210), width=2)
    return image


def sortie_cta() -> Image.Image:
    image = panel_base(192, 112, COLORS["orange"], COLORS["orange_dark"], 8)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((10, 9, 181, 101), radius=5, outline=(255, 223, 111, 150), width=2)
    draw.polygon([(18, 13), (40, 13), (28, 28)], fill=(255, 202, 81, 150))
    draw.polygon([(174, 98), (151, 98), (164, 82)], fill=(88, 24, 6, 120))
    draw.arc((18, 26, 174, 104), 8, 172, fill=(255, 205, 88, 70), width=4)
    return image


def bottom_dock() -> Image.Image:
    image = panel_base(540, 112, COLORS["wood"], COLORS["gold"], 4)
    draw = ImageDraw.Draw(image)
    for x in range(108, 540, 108):
        draw.line((x, 12, x, 100), fill=(142, 95, 38, 150), width=2)
    draw.rectangle((0, 0, 540, 9), fill=(10, 6, 4, 210))
    draw.rectangle((0, 103, 540, 112), fill=(10, 6, 4, 220))
    return image


def tab_selected() -> Image.Image:
    image = panel_base(108, 92, (24, 106, 166, 230), COLORS["gold"], 6)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((9, 9, 98, 83), radius=5, outline=(105, 218, 255, 130), width=2)
    draw.polygon([(54, 80), (62, 90), (54, 100), (46, 90)], fill=(35, 168, 255, 210))
    return image


def icon_canvas() -> tuple[Image.Image, ImageDraw.ImageDraw]:
    image = new_canvas(64, 64)
    return image, ImageDraw.Draw(image)


def icon_set() -> dict[str, Image.Image]:
    icons: dict[str, Image.Image] = {}
    for key in [
        "stamina",
        "coin",
        "gem",
        "mail",
        "home",
        "yokai",
        "weapon",
        "talisman",
        "shop",
        "chest",
        "training",
        "relic",
        "boss",
    ]:
        image, draw = icon_canvas()
        draw.ellipse((8, 8, 56, 56), fill=(18, 12, 8, 220), outline=COLORS["gold"], width=3)
        if key == "stamina":
            draw.polygon([(32, 12), (22, 34), (30, 32), (25, 52), (43, 28), (34, 30)], fill=COLORS["blue"])
            draw.arc((18, 18, 48, 54), 110, 330, fill=(180, 245, 255, 210), width=3)
        elif key == "coin":
            draw.ellipse((18, 17, 47, 47), fill=(245, 181, 66, 235), outline=(255, 229, 118, 240), width=3)
            draw.line((25, 32, 40, 32), fill=(114, 66, 14, 220), width=3)
        elif key == "gem":
            draw.polygon([(32, 13), (49, 25), (43, 48), (21, 48), (15, 25)], fill=(74, 176, 110, 235), outline=(180, 245, 180, 230))
            draw.line((20, 25, 44, 25), fill=(214, 255, 212, 160), width=2)
        elif key == "mail":
            draw.rounded_rectangle((16, 22, 48, 43), radius=3, fill=(238, 214, 158, 235), outline=COLORS["gold_deep"], width=2)
            draw.line((17, 23, 32, 35, 47, 23), fill=(92, 50, 20, 220), width=2)
        elif key == "home":
            draw.polygon([(13, 35), (32, 16), (51, 35)], fill=(52, 123, 176, 230), outline=(178, 222, 255, 220))
            draw.rectangle((20, 34, 44, 50), fill=(30, 54, 80, 235), outline=COLORS["gold"], width=2)
        elif key == "yokai":
            draw.polygon([(20, 26), (15, 13), (30, 21), (34, 21), (49, 13), (44, 26), (45, 44), (32, 52), (19, 44)], fill=(178, 139, 78, 235), outline=COLORS["gold"], width=2)
            draw.ellipse((23, 33, 29, 39), fill=COLORS["red"])
            draw.ellipse((35, 33, 41, 39), fill=COLORS["red"])
        elif key == "weapon":
            draw.line((17, 47, 47, 17), fill=(228, 229, 214, 235), width=5)
            draw.line((18, 18, 47, 47), fill=(120, 86, 38, 235), width=5)
            draw.line((24, 40, 40, 56), fill=COLORS["gold"], width=3)
        elif key == "talisman":
            draw.rectangle((21, 13, 43, 51), fill=(230, 198, 105, 235), outline=COLORS["gold_deep"], width=2)
            draw.line((25, 27, 39, 27), fill=COLORS["red"], width=2)
            draw.line((26, 36, 38, 43), fill=COLORS["red"], width=2)
        elif key == "shop":
            draw.rectangle((18, 29, 47, 50), fill=(72, 38, 17, 235), outline=COLORS["gold"], width=2)
            draw.polygon([(15, 29), (21, 17), (44, 17), (50, 29)], fill=(226, 185, 92, 235), outline=COLORS["gold_deep"])
            draw.line((24, 50, 24, 37), fill=(30, 16, 8, 235), width=2)
        elif key == "chest":
            draw.rounded_rectangle((15, 26, 49, 48), radius=4, fill=(70, 37, 17, 235), outline=COLORS["gold"], width=2)
            draw.rectangle((18, 20, 46, 31), fill=(103, 59, 25, 235), outline=COLORS["gold"], width=2)
            draw.rectangle((29, 30, 35, 39), fill=(238, 193, 82, 240))
        elif key == "training":
            draw.rectangle((18, 21, 46, 43), fill=(230, 198, 116, 235), outline=COLORS["gold_deep"], width=2)
            draw.line((22, 28, 42, 28), fill=(93, 55, 22, 210), width=2)
            draw.line((22, 35, 38, 35), fill=(93, 55, 22, 210), width=2)
            draw.line((17, 44, 47, 44), fill=COLORS["blue"], width=4)
        elif key == "relic":
            draw.rectangle((21, 17, 43, 48), fill=(29, 58, 78, 235), outline=COLORS["gold"], width=2)
            draw.arc((20, 10, 44, 35), 190, 350, fill=COLORS["blue"], width=3)
            draw.ellipse((28, 28, 36, 36), fill=COLORS["teal"])
        elif key == "boss":
            draw.polygon([(18, 25), (16, 14), (28, 22), (36, 22), (48, 14), (46, 25), (44, 44), (32, 51), (20, 44)], fill=(150, 54, 29, 235), outline=COLORS["gold"], width=2)
            draw.line((23, 35, 30, 38), fill=(255, 204, 93, 235), width=3)
            draw.line((41, 35, 34, 38), fill=(255, 204, 93, 235), width=3)
        icons[key] = image
    return icons


def pack_icon_atlas(icons: dict[str, Image.Image]) -> Image.Image:
    keys = list(icons.keys())
    atlas = new_canvas(256, 256)
    for index, key in enumerate(keys):
        x = (index % 4) * 64
        y = (index // 4) * 64
        atlas.alpha_composite(icons[key], (x, y))
    return atlas


if __name__ == "__main__":
    main()
