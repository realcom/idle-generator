#!/usr/bin/env python3
"""Graft original guardian leg pixels into the side-left walk row.

This is a production-facing follow-up to the pose proof in
`ninja2_guardian_left_walk_rig.py`: use the approved sheet's own boot/pants
pixels, not debug-colored guide limbs, while making the right leg visibly step
forward in frames 4-6 of the left-facing row.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter


FRAME_WIDTH = 512
FRAME_HEIGHT = 512
LEFT_ROW = 1


@dataclass(frozen=True)
class GraftPose:
    frame: int
    foot_x: int
    foot_y: int
    scale: float
    alpha: float


RIGHT_FORWARD_GRAFTS = (
    GraftPose(frame=3, foot_x=224, foot_y=461, scale=1.02, alpha=1.00),
    GraftPose(frame=4, foot_x=188, foot_y=461, scale=1.08, alpha=1.00),
    GraftPose(frame=5, foot_x=210, foot_y=461, scale=1.04, alpha=1.00),
)


RECESS_MASKS = {
    3: ((278, 386), (340, 372), (392, 454), (334, 468)),
    4: ((284, 386), (350, 374), (404, 454), (338, 470)),
    5: ((274, 388), (340, 374), (394, 456), (326, 470)),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Create a usable side-left leg-graft candidate.")
    parser.add_argument("--input", required=True, help="Input 3x8 sheet, usually guardian_hero_walk_identity_v5.png.")
    parser.add_argument("--out", required=True, help="Output 3x8 candidate sheet.")
    parser.add_argument("--out-dir", help="Optional review output directory.")
    parser.add_argument("--duration-ms", type=int, default=115, help="GIF frame duration.")
    return parser.parse_args()


def crop_frame(sheet: Image.Image, row: int, col: int) -> Image.Image:
    left = col * FRAME_WIDTH
    top = row * FRAME_HEIGHT
    return sheet.crop((left, top, left + FRAME_WIDTH, top + FRAME_HEIGHT)).convert("RGBA")


def leg_color_mask(crop: Image.Image) -> Image.Image:
    rgba = np.asarray(crop.convert("RGBA")).astype(np.int16)
    r = rgba[:, :, 0]
    g = rgba[:, :, 1]
    b = rgba[:, :, 2]
    a = rgba[:, :, 3]

    pants = (g > 42) & (g > r * 0.72) & (r < 105) & (b < 95)
    boot = (r > 38) & (r < 165) & (g > 22) & (g < 110) & (b < 78) & ((r - b) > 22)
    warm_prop = (r > 150) & (g > 92) & (b < 90) & ((r - b) > 58)
    tan_cloak = (r > 125) & (g > 92) & (b > 45) & ((r - g) < 70) & (b > 30)
    mask = (a > 24) & (pants | boot) & ~warm_prop & ~tan_cloak

    out = Image.fromarray(mask.astype(np.uint8) * 255)
    out = out.filter(ImageFilter.GaussianBlur(0.25))
    return out


def extract_front_leg_patch(source_frame: Image.Image) -> tuple[Image.Image, tuple[int, int]]:
    # Frame 1's screen-left leg has the closest color/shading match for a
    # forward step. The color mask strips lantern glow and cloak trim.
    rect = (204, 376, 318, 463)
    crop = source_frame.crop(rect).convert("RGBA")
    mask = leg_color_mask(crop)
    alpha = crop.getchannel("A")
    crop.putalpha(Image.composite(alpha, Image.new("L", crop.size, 0), mask))
    bbox = crop.getbbox()
    if bbox is None:
        raise SystemExit("Could not extract a leg patch from the source frame.")
    patch = crop.crop(bbox)
    anchor = (rect[0] + bbox[2] - 28, rect[1] + bbox[3] - 2)
    local_anchor = (anchor[0] - rect[0] - bbox[0], anchor[1] - rect[1] - bbox[1])
    return patch, local_anchor


def prepare_patch(patch: Image.Image, scale: float, alpha: float) -> Image.Image:
    if scale != 1.0:
        size = (max(1, round(patch.width * scale)), max(1, round(patch.height * scale)))
        patch = patch.resize(size, Image.Resampling.LANCZOS)
    patch = ImageEnhance.Color(patch).enhance(0.96)
    patch = ImageEnhance.Contrast(patch).enhance(0.98)
    alpha_channel = patch.getchannel("A").point(lambda value: int(value * alpha))
    patch.putalpha(alpha_channel)
    return patch


def paste_right_forward_leg(
    frame: Image.Image,
    source_patch: Image.Image,
    source_anchor: tuple[int, int],
    pose: GraftPose,
) -> Image.Image:
    patch = prepare_patch(source_patch.copy(), pose.scale, pose.alpha)
    anchor = (round(source_anchor[0] * pose.scale), round(source_anchor[1] * pose.scale))
    x = pose.foot_x - anchor[0]
    y = pose.foot_y - anchor[1]

    out = recess_original_back_leg(frame.copy(), pose.frame)
    # Paint only the lower exposed area. The existing cloak remains the main
    # occluder, so the graft reads as a real hidden leg instead of a new limb.
    lower_gate = Image.new("L", patch.size, 0)
    gate_draw = ImageDraw.Draw(lower_gate)
    gate_draw.rectangle((0, max(0, 32), patch.width, patch.height), fill=255)
    gated_alpha = Image.composite(patch.getchannel("A"), Image.new("L", patch.size, 0), lower_gate)
    patch.putalpha(gated_alpha)
    out.alpha_composite(patch, (x, y))
    return out


def recess_original_back_leg(frame: Image.Image, frame_index: int) -> Image.Image:
    polygon = RECESS_MASKS.get(frame_index)
    if polygon is None:
        return frame

    mask = Image.new("L", frame.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.polygon(polygon, fill=210)
    mask = mask.filter(ImageFilter.GaussianBlur(4.0))

    rgba = np.asarray(frame.convert("RGBA")).astype(np.float32)
    m = np.asarray(mask).astype(np.float32) / 255.0

    # Push the old screen-right leg into the background instead of deleting it:
    # lower alpha and darken it so the new forward leg reads as the active one.
    rgba[:, :, 0] = rgba[:, :, 0] * (1.0 - 0.22 * m)
    rgba[:, :, 1] = rgba[:, :, 1] * (1.0 - 0.22 * m)
    rgba[:, :, 2] = rgba[:, :, 2] * (1.0 - 0.25 * m)
    rgba[:, :, 3] = rgba[:, :, 3] * (1.0 - 0.34 * m)
    return Image.fromarray(np.clip(rgba, 0, 255).astype(np.uint8))


def save_review_outputs(out_dir: Path, frames: list[Image.Image], duration_ms: int) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    review_frames: list[Image.Image] = []
    strip = Image.new("RGBA", (FRAME_WIDTH * len(frames), FRAME_HEIGHT), (238, 242, 247, 255))
    for index, frame in enumerate(frames):
        canvas = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (238, 242, 247, 255))
        canvas.alpha_composite(frame)
        draw = ImageDraw.Draw(canvas)
        draw.text((12, 12), f"graft left {index + 1}", fill=(20, 24, 30, 255))
        draw.line((0, 462, FRAME_WIDTH, 462), fill=(255, 62, 62, 170), width=2)
        strip.alpha_composite(canvas, (index * FRAME_WIDTH, 0))
        review_frames.append(canvas.convert("P", palette=Image.Palette.ADAPTIVE, colors=255))
    review_frames[0].save(
        out_dir / "left_graft.gif",
        save_all=True,
        append_images=review_frames[1:],
        duration=duration_ms,
        loop=0,
        disposal=2,
    )
    strip.save(out_dir / "left_graft_strip.png")


def main() -> None:
    args = parse_args()
    sheet = Image.open(args.input).convert("RGBA")
    out = sheet.copy()
    source_patch, source_anchor = extract_front_leg_patch(crop_frame(sheet, LEFT_ROW, 0))
    poses_by_frame = {pose.frame: pose for pose in RIGHT_FORWARD_GRAFTS}
    left_frames: list[Image.Image] = []

    for col in range(8):
        frame = crop_frame(sheet, LEFT_ROW, col)
        if col in poses_by_frame:
            frame = paste_right_forward_leg(frame, source_patch, source_anchor, poses_by_frame[col])
        out.paste(frame, (col * FRAME_WIDTH, LEFT_ROW * FRAME_HEIGHT))
        left_frames.append(frame)

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out.save(out_path)
    if args.out_dir:
        save_review_outputs(Path(args.out_dir), left_frames, args.duration_ms)


if __name__ == "__main__":
    main()
