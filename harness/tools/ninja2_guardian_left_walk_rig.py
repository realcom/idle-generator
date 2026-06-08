#!/usr/bin/env python3
"""Bake a pose-blocked left walk row for the ninja2 guardian.

This is a blocking/rigging tool, not a final paint system. The goal is to make
leg motion explicit and reproducible before any polish pass:

- contact frames put opposite feet forward/back
- passing frames cross the legs under the body
- upper-body identity comes from the approved source sheet
"""

from __future__ import annotations

import argparse
import math
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


FRAME_WIDTH = 512
FRAME_HEIGHT = 512
LEFT_ROW = 1
GROUND_Y = 462


@dataclass(frozen=True)
class SideLeftPose:
    left_foot_x: int
    left_foot_y: int
    right_foot_x: int
    right_foot_y: int
    left_lift: int
    right_lift: int


@dataclass(frozen=True)
class LegStyle:
    outline: tuple[int, int, int, int]
    pants: tuple[int, int, int, int]
    boot: tuple[int, int, int, int]


# In the left-facing side row, "forward" is screen-left, so smaller x means
# the foot is in front of the body. Frames 4-6 deliberately put the right leg
# forward; frame 5 is the opposite contact pose.
LEFT_POSES = (
    SideLeftPose(214, 461, 338, 461, 0, 0),
    SideLeftPose(228, 461, 326, 458, 0, -3),
    SideLeftPose(258, 455, 300, 461, -6, 0),
    SideLeftPose(300, 458, 244, 461, -3, 0),
    SideLeftPose(330, 461, 214, 461, 0, 0),
    SideLeftPose(316, 458, 230, 461, -3, 0),
    SideLeftPose(282, 461, 258, 455, 0, -6),
    SideLeftPose(236, 461, 314, 458, 0, -3),
)


COLORS = {
    "outline": (38, 23, 14, 255),
    "far_outline": (31, 21, 15, 248),
    "pants": (43, 86, 42, 255),
    "far_pants": (29, 62, 35, 245),
    "boot": (116, 61, 26, 255),
    "far_boot": (78, 43, 24, 245),
    "pants_shadow": (23, 50, 29, 210),
    "boot_highlight": (168, 91, 35, 215),
    "far_boot_highlight": (119, 68, 34, 180),
    "sole": (28, 18, 12, 255),
    "left_dot": (0, 230, 95, 255),
    "right_dot": (75, 145, 255, 255),
    "proof_left_outline": (0, 80, 36, 245),
    "proof_left_pants": (19, 185, 83, 190),
    "proof_left_boot": (11, 132, 70, 210),
    "proof_right_outline": (20, 62, 150, 245),
    "proof_right_pants": (78, 153, 255, 190),
    "proof_right_boot": (55, 105, 214, 210),
}

PAINT_FRONT = LegStyle(COLORS["outline"], COLORS["pants"], COLORS["boot"])
PAINT_BACK = LegStyle(COLORS["far_outline"], COLORS["far_pants"], COLORS["far_boot"])
PROOF_LEFT = LegStyle(COLORS["proof_left_outline"], COLORS["proof_left_pants"], COLORS["proof_left_boot"])
PROOF_RIGHT = LegStyle(COLORS["proof_right_outline"], COLORS["proof_right_pants"], COLORS["proof_right_boot"])


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Bake the guardian left walk from explicit leg poses.")
    parser.add_argument("--input", required=True, help="Input 3x8 sheet, usually guardian_hero_walk_identity_v5.png.")
    parser.add_argument("--out", required=True, help="Output 3x8 candidate sheet.")
    parser.add_argument("--out-dir", help="Optional review output directory.")
    parser.add_argument(
        "--mode",
        choices=("overlay", "proof", "paint"),
        default="paint",
        help=(
            "overlay draws guide dots, proof draws identity-colored L/R legs, "
            "paint makes a no-guide rough candidate."
        ),
    )
    parser.add_argument("--duration-ms", type=int, default=115, help="GIF frame duration.")
    return parser.parse_args()


def crop_frame(sheet: Image.Image, row: int, col: int) -> Image.Image:
    left = col * FRAME_WIDTH
    top = row * FRAME_HEIGHT
    return sheet.crop((left, top, left + FRAME_WIDTH, top + FRAME_HEIGHT)).convert("RGBA")


def draw_limb(
    draw: ImageDraw.ImageDraw,
    start: tuple[int, int],
    end: tuple[int, int],
    width: int,
    fill: tuple[int, int, int, int],
    outline: tuple[int, int, int, int],
) -> None:
    draw.line([start, end], fill=outline, width=width + 5, joint="curve")
    draw.line([start, end], fill=fill, width=width, joint="curve")
    radius = max(2, width // 2)
    for x, y in (start, end):
        draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=fill, outline=outline, width=2)


def draw_highlight_line(
    draw: ImageDraw.ImageDraw,
    start: tuple[int, int],
    end: tuple[int, int],
    width: int,
    fill: tuple[int, int, int, int],
) -> None:
    dx = end[0] - start[0]
    dy = end[1] - start[1]
    length = max(1.0, math.hypot(dx, dy))
    nx = int(round(-dy / length * 4))
    ny = int(round(dx / length * 4))
    draw.line(
        [(start[0] + nx, start[1] + ny), (end[0] + nx, end[1] + ny)],
        fill=fill,
        width=width,
    )


def draw_boot(
    draw: ImageDraw.ImageDraw,
    foot_x: int,
    foot_y: int,
    fill: tuple[int, int, int, int],
    outline: tuple[int, int, int, int],
    highlight: tuple[int, int, int, int],
) -> None:
    toe = foot_x - 30
    heel = foot_x + 18
    top = foot_y - 20
    bottom = foot_y - 1
    outer = [
        (heel, top + 5),
        (heel + 5, bottom - 7),
        (toe + 8, bottom),
        (toe - 6, bottom - 7),
        (foot_x - 8, top),
    ]
    inner = [
        (heel - 3, top + 7),
        (heel + 1, bottom - 9),
        (toe + 10, bottom - 4),
        (toe, bottom - 8),
        (foot_x - 5, top + 4),
    ]
    draw.polygon(outer, fill=outline)
    draw.polygon(inner, fill=fill)
    draw.arc((toe + 4, top + 5, heel, bottom + 10), start=190, end=300, fill=highlight, width=3)
    draw.line((toe - 4, bottom - 2, heel + 2, bottom - 7), fill=COLORS["sole"], width=2)


def draw_pose_leg(
    draw: ImageDraw.ImageDraw,
    hip: tuple[int, int],
    foot_x: int,
    foot_y: int,
    lift: int,
    front: bool,
    style: LegStyle,
) -> None:
    bend = -10 if foot_x < hip[0] else 9
    knee = ((hip[0] + foot_x) // 2 + bend, 414 + lift // 2)
    ankle = (foot_x + 10, 439 + lift // 2)
    thigh_width = 23 if front else 19
    shin_width = 21 if front else 18
    draw_limb(draw, hip, knee, thigh_width, style.pants, style.outline)
    draw_limb(draw, knee, ankle, shin_width, style.boot, style.outline)
    draw_highlight_line(draw, hip, knee, 4 if front else 3, COLORS["pants_shadow"])
    draw_highlight_line(
        draw,
        knee,
        ankle,
        4 if front else 3,
        COLORS["boot_highlight"] if front else COLORS["far_boot_highlight"],
    )
    draw_boot(
        draw,
        foot_x,
        foot_y,
        style.boot,
        style.outline,
        COLORS["boot_highlight"] if front else COLORS["far_boot_highlight"],
    )


def paint_style(front: bool) -> LegStyle:
    if front:
        return PAINT_FRONT
    return PAINT_BACK


def draw_label(
    draw: ImageDraw.ImageDraw,
    label: str,
    foot_x: int,
    foot_y: int,
    fill: tuple[int, int, int, int],
) -> None:
    x = foot_x
    y = foot_y - 44
    draw.ellipse((x - 15, y - 15, x + 15, y + 15), fill=fill, outline=(0, 0, 0, 230), width=2)
    bbox = draw.textbbox((0, 0), label)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    draw.text((x - text_w / 2, y - text_h / 2 - 1), label, fill=(255, 255, 255, 255))


def draw_foot_dot(
    draw: ImageDraw.ImageDraw,
    foot_x: int,
    foot_y: int,
    fill: tuple[int, int, int, int],
) -> None:
    draw.ellipse((foot_x - 5, foot_y - 5, foot_x + 5, foot_y + 5), fill=fill)


def leg_guide_layer(pose: SideLeftPose, mode: str) -> Image.Image:
    layer = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)

    left_hip = (248, 382)
    right_hip = (302, 384)
    right_is_forward = pose.right_foot_x < pose.left_foot_x
    proof = mode == "proof"

    if proof:
        left_style = PROOF_LEFT
        right_style = PROOF_RIGHT
    else:
        left_style = paint_style(not right_is_forward)
        right_style = paint_style(right_is_forward)

    if right_is_forward:
        draw_pose_leg(
            draw,
            left_hip,
            pose.left_foot_x,
            pose.left_foot_y,
            pose.left_lift,
            front=False,
            style=left_style,
        )
        draw_pose_leg(
            draw,
            right_hip,
            pose.right_foot_x,
            pose.right_foot_y,
            pose.right_lift,
            front=True,
            style=right_style,
        )
    else:
        draw_pose_leg(
            draw,
            right_hip,
            pose.right_foot_x,
            pose.right_foot_y,
            pose.right_lift,
            front=False,
            style=right_style,
        )
        draw_pose_leg(
            draw,
            left_hip,
            pose.left_foot_x,
            pose.left_foot_y,
            pose.left_lift,
            front=True,
            style=left_style,
        )

    if mode in ("overlay", "proof"):
        draw_foot_dot(draw, pose.left_foot_x, pose.left_foot_y, COLORS["left_dot"])
        draw_foot_dot(draw, pose.right_foot_x, pose.right_foot_y, COLORS["right_dot"])
    if proof:
        draw_label(draw, "L", pose.left_foot_x, pose.left_foot_y, COLORS["left_dot"])
        draw_label(draw, "R", pose.right_foot_x, pose.right_foot_y, COLORS["right_dot"])
    return layer


def original_leg_clear_mask(frame: Image.Image, guide: Image.Image) -> Image.Image:
    alpha = guide.getchannel("A").filter(ImageFilter.MaxFilter(13)).filter(ImageFilter.GaussianBlur(1.2))
    # Keep original pixels outside the guide neighborhood. This prevents broad holes.
    return alpha


def bake_left_frame(frame: Image.Image, pose: SideLeftPose, mode: str) -> Image.Image:
    layer = leg_guide_layer(pose, mode=mode)
    if mode in ("overlay", "proof"):
        out = frame.copy()
        out.alpha_composite(layer)
        return out

    transparent = Image.new("RGBA", frame.size, (0, 0, 0, 0))
    cleared = Image.composite(transparent, frame, original_leg_clear_mask(frame, layer))
    # Put the rough rig legs under the original cloak/lantern pixels that remain.
    out = Image.new("RGBA", frame.size, (0, 0, 0, 0))
    out.alpha_composite(layer)
    out.alpha_composite(cleared)
    return out


def save_review_outputs(out_dir: Path, left_frames: list[Image.Image], duration_ms: int, label: str) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    review_frames: list[Image.Image] = []
    strip = Image.new("RGBA", (FRAME_WIDTH * len(left_frames), FRAME_HEIGHT), (0, 0, 0, 0))
    for index, frame in enumerate(left_frames):
        canvas = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (238, 242, 247, 255))
        canvas.alpha_composite(frame)
        draw = ImageDraw.Draw(canvas)
        draw.text((12, 12), f"{label} left {index + 1}", fill=(20, 24, 30, 255))
        draw.line((0, GROUND_Y, FRAME_WIDTH, GROUND_Y), fill=(255, 62, 62, 170), width=2)
        review_frames.append(canvas.convert("P", palette=Image.Palette.ADAPTIVE, colors=255))
        strip.alpha_composite(canvas, (index * FRAME_WIDTH, 0))
    review_frames[0].save(
        out_dir / f"left_{label}.gif",
        save_all=True,
        append_images=review_frames[1:],
        duration=duration_ms,
        loop=0,
        disposal=2,
    )
    strip.save(out_dir / f"left_{label}_strip.png")


def main() -> None:
    args = parse_args()
    sheet = Image.open(args.input).convert("RGBA")
    out = sheet.copy()
    left_frames: list[Image.Image] = []

    for col, pose in enumerate(LEFT_POSES):
        frame = crop_frame(sheet, LEFT_ROW, col)
        candidate = bake_left_frame(frame, pose, args.mode)
        out.paste(candidate, (col * FRAME_WIDTH, LEFT_ROW * FRAME_HEIGHT))
        left_frames.append(candidate)

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out.save(out_path)

    if args.out_dir:
        save_review_outputs(Path(args.out_dir), left_frames, args.duration_ms, args.mode)


if __name__ == "__main__":
    main()
