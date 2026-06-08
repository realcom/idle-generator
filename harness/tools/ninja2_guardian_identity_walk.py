#!/usr/bin/env python3
"""Build an identity-locked guardian walk candidate from the approved sheet.

This is deliberately not an image-generation step. It reuses pixels from the
current 3x8 walk sheet and applies smooth local warps only around lower-body
and lantern regions, so the face and body ratio stay unchanged.
"""

from __future__ import annotations

import argparse
import math
from dataclasses import dataclass
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter


@dataclass(frozen=True)
class RowWarp:
    name: str
    lower_y: int
    split_x: int
    lower_amp: float
    lower_phase: tuple[float, ...]
    lantern_rect: tuple[int, int, int, int]
    lantern_amp_x: float
    lantern_amp_y: float
    lantern_phase: tuple[float, ...]


SMOOTH_PHASE = tuple(math.sin((index / 8) * math.tau) for index in range(8))
SMOOTH_PHASE_SHIFTED = tuple(math.sin(((index + 1) / 8) * math.tau) for index in range(8))
STEPPED_PHASE = (0.0, 0.45, 1.0, 0.35, 0.0, -0.45, -1.0, -0.35)
STEPPED_PHASE_SHIFTED = (-0.65, -0.95, -0.55, 0.0, 0.65, 0.95, 0.55, 0.0)
LEFT_FEET_FRONT_DX = (-20.0, -14.0, 0.0, 14.0, 20.0, 14.0, 0.0, -14.0)
LEFT_FEET_REAR_DX = tuple(-value for value in LEFT_FEET_FRONT_DX)
LEFT_FEET_FRONT_DY = (0.0, 0.0, -6.0, -10.0, -8.0, -4.0, 0.0, 0.0)
LEFT_FEET_REAR_DY = (-8.0, -4.0, 0.0, 0.0, 0.0, -4.0, -8.0, -10.0)


SMOOTH_WARPS = (
    RowWarp(
        name="down",
        lower_y=344,
        split_x=256,
        lower_amp=20.0,
        lower_phase=SMOOTH_PHASE,
        lantern_rect=(44, 224, 225, 445),
        lantern_amp_x=10.0,
        lantern_amp_y=3.0,
        lantern_phase=SMOOTH_PHASE_SHIFTED,
    ),
    RowWarp(
        name="left",
        lower_y=358,
        split_x=248,
        lower_amp=22.0,
        lower_phase=SMOOTH_PHASE,
        lantern_rect=(48, 268, 234, 452),
        lantern_amp_x=9.0,
        lantern_amp_y=3.0,
        lantern_phase=SMOOTH_PHASE_SHIFTED,
    ),
    RowWarp(
        name="up",
        lower_y=352,
        split_x=256,
        lower_amp=18.0,
        lower_phase=SMOOTH_PHASE,
        lantern_rect=(278, 246, 458, 448),
        lantern_amp_x=9.0,
        lantern_amp_y=3.0,
        lantern_phase=SMOOTH_PHASE_SHIFTED,
    ),
)

STEPPED_WARPS = (
    RowWarp(
        name="down",
        lower_y=348,
        split_x=256,
        lower_amp=24.0,
        lower_phase=STEPPED_PHASE,
        lantern_rect=(44, 224, 225, 445),
        lantern_amp_x=8.0,
        lantern_amp_y=2.0,
        lantern_phase=STEPPED_PHASE_SHIFTED,
    ),
    RowWarp(
        name="left",
        lower_y=360,
        split_x=250,
        lower_amp=27.0,
        lower_phase=STEPPED_PHASE,
        lantern_rect=(48, 268, 234, 452),
        lantern_amp_x=7.0,
        lantern_amp_y=2.0,
        lantern_phase=STEPPED_PHASE_SHIFTED,
    ),
    RowWarp(
        name="up",
        lower_y=354,
        split_x=256,
        lower_amp=21.0,
        lower_phase=STEPPED_PHASE,
        lantern_rect=(278, 246, 458, 448),
        lantern_amp_x=7.0,
        lantern_amp_y=2.0,
        lantern_phase=STEPPED_PHASE_SHIFTED,
    ),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a guardian walk candidate that preserves the current character identity."
    )
    parser.add_argument("--input", required=True, help="Current 3x8 guardian walk sheet.")
    parser.add_argument("--out", required=True, help="Output candidate sheet.")
    parser.add_argument("--frame-width", type=int, default=512)
    parser.add_argument("--frame-height", type=int, default=512)
    parser.add_argument("--cols", type=int, default=8)
    parser.add_argument(
        "--variant",
        choices=("smooth", "stepped", "left-feet"),
        default="smooth",
        help=(
            "Motion profile. smooth reproduces identity_v1; stepped holds contact "
            "frames for a less rubbery cycle; left-feet applies the v6 side-row "
            "foot-contact upgrade to an existing 3x8 sheet."
        ),
    )
    parser.add_argument(
        "--left-feet-scale",
        type=float,
        default=1.2,
        help="Strength for --variant left-feet. The v6 candidate uses 1.2.",
    )
    return parser.parse_args()


def smoothstep(value: np.ndarray) -> np.ndarray:
    clipped = np.clip(value, 0.0, 1.0)
    return clipped * clipped * (3.0 - 2.0 * clipped)


def blurred_rect(size: tuple[int, int], rect: tuple[int, int, int, int], blur: float) -> np.ndarray:
    mask = Image.new("L", size, 0)
    pixels = np.asarray(mask).copy()
    left, top, right, bottom = rect
    pixels[max(0, top) : min(size[1], bottom), max(0, left) : min(size[0], right)] = 255
    mask = Image.fromarray(pixels).filter(ImageFilter.GaussianBlur(blur))
    return np.asarray(mask).astype(np.float32) / 255.0


def bilinear_sample(array: np.ndarray, src_x: np.ndarray, src_y: np.ndarray) -> np.ndarray:
    height, width, channels = array.shape
    src_x = np.clip(src_x, 0, width - 1)
    src_y = np.clip(src_y, 0, height - 1)
    x0 = np.floor(src_x).astype(np.int32)
    y0 = np.floor(src_y).astype(np.int32)
    x1 = np.clip(x0 + 1, 0, width - 1)
    y1 = np.clip(y0 + 1, 0, height - 1)
    wx = (src_x - x0)[..., None]
    wy = (src_y - y0)[..., None]

    top = array[y0, x0] * (1.0 - wx) + array[y0, x1] * wx
    bottom = array[y1, x0] * (1.0 - wx) + array[y1, x1] * wx
    return top * (1.0 - wy) + bottom * wy


def warp_frame(frame: Image.Image, warp: RowWarp, col: int) -> Image.Image:
    array = np.asarray(frame.convert("RGBA")).astype(np.float32)
    height, width, _ = array.shape
    yy, xx = np.mgrid[0:height, 0:width].astype(np.float32)

    lower_weight = smoothstep((yy - warp.lower_y) / max(1.0, height - warp.lower_y - 44))
    side_weight = np.tanh((xx - warp.split_x) / 36.0)
    center_gate = smoothstep((np.abs(xx - warp.split_x) - 24.0) / 54.0)
    lower_dx = warp.lower_amp * warp.lower_phase[col] * side_weight * lower_weight * center_gate

    lantern_weight = blurred_rect((width, height), warp.lantern_rect, blur=18.0)
    lantern_dx = warp.lantern_amp_x * warp.lantern_phase[col] * lantern_weight
    lantern_dy = -warp.lantern_amp_y * math.cos((col / 8) * math.tau) * lantern_weight

    src_x = xx - lower_dx - lantern_dx
    src_y = yy - lantern_dy
    warped = bilinear_sample(array, src_x, src_y)

    # Keep the very top completely identical. The warp field is already zero
    # there, but this guards against any interpolation surprise.
    warped[: min(warp.lower_y - 88, height), :, :] = array[: min(warp.lower_y - 88, height), :, :]
    return Image.fromarray(np.clip(warped, 0, 255).astype(np.uint8))


def warp_left_feet_frame(frame: Image.Image, col: int, scale: float) -> Image.Image:
    """Strengthen the left-row foot contact without touching the upper body."""
    array = np.asarray(frame.convert("RGBA")).astype(np.float32)
    height, width, _ = array.shape
    yy, xx = np.mgrid[0:height, 0:width].astype(np.float32)

    front_weight = blurred_rect((width, height), (178, 382, 292, 470), blur=14.0)
    rear_weight = blurred_rect((width, height), (286, 360, 430, 470), blur=16.0)
    bottom_gate = smoothstep((yy - 342.0) / 98.0)
    front_protect = smoothstep((yy - 392.0) / 36.0) * smoothstep((xx - 178.0) / 36.0)
    front_base = front_weight * bottom_gate * front_protect
    rear_base = rear_weight * bottom_gate

    # Keep the two foot fields mostly separate so the planted foot stays readable.
    front_base = front_base * (1.0 - 0.55 * rear_base)
    rear_base = rear_base * (1.0 - 0.35 * front_base)

    dy_scale = min(scale, 1.35)
    dx = (
        front_base * LEFT_FEET_FRONT_DX[col]
        + rear_base * LEFT_FEET_REAR_DX[col]
    ) * scale
    dy = (
        front_base * LEFT_FEET_FRONT_DY[col]
        + rear_base * LEFT_FEET_REAR_DY[col]
    ) * dy_scale

    warped = bilinear_sample(array, xx - dx, yy - dy)

    # Leave head, torso, hand, and most of the lantern identical.
    lock = (yy < 334.0) | ((xx < 178.0) & (yy < 430.0))
    warped[lock] = array[lock]
    return Image.fromarray(np.clip(warped, 0, 255).astype(np.uint8))


def crop_frame(sheet: Image.Image, frame_width: int, frame_height: int, row: int, col: int) -> Image.Image:
    left = col * frame_width
    top = row * frame_height
    return sheet.crop((left, top, left + frame_width, top + frame_height))


def main() -> None:
    args = parse_args()
    sheet = Image.open(args.input).convert("RGBA")
    frame_width = args.frame_width
    frame_height = args.frame_height
    if args.variant == "left-feet":
        out = Image.new("RGBA", (frame_width * args.cols, frame_height * 3), (0, 0, 0, 0))
        for row in range(3):
            for col in range(args.cols):
                frame = crop_frame(sheet, frame_width, frame_height, row, col)
                candidate = warp_left_feet_frame(frame, col, args.left_feet_scale) if row == 1 else frame
                out.paste(candidate, (col * frame_width, row * frame_height))
        out_path = Path(args.out)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out.save(out_path)
        return

    warps = STEPPED_WARPS if args.variant == "stepped" else SMOOTH_WARPS
    out = Image.new("RGBA", (frame_width * args.cols, frame_height * len(warps)), (0, 0, 0, 0))

    for row, warp in enumerate(warps):
        for col in range(args.cols):
            frame = crop_frame(sheet, frame_width, frame_height, row, col)
            candidate = warp_frame(frame, warp, col)
            out.alpha_composite(candidate, (col * frame_width, row * frame_height))

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out.save(out_path)


if __name__ == "__main__":
    main()
