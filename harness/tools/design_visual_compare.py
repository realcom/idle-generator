#!/usr/bin/env python3
"""Build normalized concept-vs-runtime comparison boards for UI iteration."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Iterable

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError as exc:  # pragma: no cover - environment gate
    raise SystemExit(
        "Pillow is required. Install project tool requirements or run in the Codex workspace runtime."
    ) from exc


Color = tuple[int, int, int]


def parse_color(value: str) -> Color:
    text = value.strip().lstrip("#")
    if len(text) != 6:
        raise argparse.ArgumentTypeError(f"Expected 6-digit hex color, got {value!r}")
    try:
        return tuple(int(text[index : index + 2], 16) for index in (0, 2, 4))  # type: ignore[return-value]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"Invalid hex color: {value!r}") from exc


def parse_crop(value: str) -> tuple[int, int, int, int]:
    parts = [part.strip() for part in value.split(",")]
    if len(parts) != 4:
        raise argparse.ArgumentTypeError("Crop must be x,y,width,height")
    try:
        x, y, width, height = [int(part) for part in parts]
    except ValueError as exc:
        raise argparse.ArgumentTypeError("Crop values must be integers") from exc
    if width <= 0 or height <= 0:
        raise argparse.ArgumentTypeError("Crop width and height must be positive")
    return x, y, width, height


def load_font(size: int) -> ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/Library/Fonts/Arial Bold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ]
    for candidate in candidates:
        path = Path(candidate)
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def crop_image(image: Image.Image, crop: tuple[int, int, int, int] | None) -> Image.Image:
    if crop is None:
        return image
    x, y, width, height = crop
    return image.crop((x, y, x + width, y + height))


def fit_width(image: Image.Image, width: int) -> Image.Image:
    if image.width == width:
        return image
    height = max(1, round(image.height * width / image.width))
    return image.resize((width, height), Image.Resampling.LANCZOS)


def stack_board(
    concept: Image.Image,
    candidate: Image.Image,
    *,
    width: int,
    label_concept: str,
    label_candidate: str,
    bg: Color,
    label_bg: Color,
    label_fg: Color,
    gap: int,
    label_height: int,
) -> Image.Image:
    concept_fit = fit_width(concept, width)
    candidate_fit = fit_width(candidate, width)
    board_height = label_height + concept_fit.height + gap + label_height + candidate_fit.height
    board = Image.new("RGB", (width, board_height), bg)
    draw = ImageDraw.Draw(board)
    font = load_font(14)

    draw.rectangle((0, 0, width, label_height), fill=label_bg)
    draw.text((10, max(2, (label_height - 14) // 2)), label_concept, font=font, fill=label_fg)
    board.paste(concept_fit, (0, label_height))

    y = label_height + concept_fit.height + gap
    draw.rectangle((0, y, width, y + label_height), fill=label_bg)
    draw.text((10, y + max(2, (label_height - 14) // 2)), label_candidate, font=font, fill=label_fg)
    board.paste(candidate_fit, (0, y + label_height))
    return board


def side_by_side_board(
    concept: Image.Image,
    candidate: Image.Image,
    *,
    panel_width: int,
    label_concept: str,
    label_candidate: str,
    bg: Color,
    label_bg: Color,
    label_fg: Color,
    gap: int,
    label_height: int,
) -> Image.Image:
    concept_fit = fit_width(concept, panel_width)
    candidate_fit = fit_width(candidate, panel_width)
    image_height = max(concept_fit.height, candidate_fit.height)
    board = Image.new("RGB", (panel_width * 2 + gap, label_height + image_height), bg)
    draw = ImageDraw.Draw(board)
    font = load_font(14)

    panels: Iterable[tuple[int, str, Image.Image]] = (
        (0, label_concept, concept_fit),
        (panel_width + gap, label_candidate, candidate_fit),
    )
    for x, label, image in panels:
        draw.rectangle((x, 0, x + panel_width, label_height), fill=label_bg)
        draw.text((x + 10, max(2, (label_height - 14) // 2)), label, font=font, fill=label_fg)
        board.paste(image, (x, label_height))
    return board


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Create a normalized visual comparison board from a concept crop and runtime screenshot."
    )
    parser.add_argument("--concept", required=True, type=Path, help="Concept image or crop path.")
    parser.add_argument("--candidate", required=True, type=Path, help="Runtime screenshot or crop path.")
    parser.add_argument("--out", required=True, type=Path, help="Output PNG path.")
    parser.add_argument("--concept-crop", type=parse_crop, help="Optional crop as x,y,width,height.")
    parser.add_argument("--candidate-crop", type=parse_crop, help="Optional crop as x,y,width,height.")
    parser.add_argument("--width", type=int, default=500, help="Output width for stacked mode.")
    parser.add_argument(
        "--mode",
        choices=("stack", "side-by-side"),
        default="stack",
        help="Comparison board layout.",
    )
    parser.add_argument("--label-concept", default="CONCEPT", help="Label for the concept image.")
    parser.add_argument("--label-candidate", default="RUNTIME", help="Label for the candidate image.")
    parser.add_argument("--gap", type=int, default=8, help="Gap between panels in pixels.")
    parser.add_argument("--label-height", type=int, default=24, help="Label strip height in pixels.")
    parser.add_argument("--bg", type=parse_color, default=parse_color("#0c120e"), help="Board background hex.")
    parser.add_argument("--label-bg", type=parse_color, default=parse_color("#141f16"), help="Label background hex.")
    parser.add_argument("--label-fg", type=parse_color, default=parse_color("#fff6d6"), help="Label text hex.")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    if args.width <= 0:
        raise SystemExit("--width must be positive")

    concept = crop_image(Image.open(args.concept).convert("RGB"), args.concept_crop)
    candidate = crop_image(Image.open(args.candidate).convert("RGB"), args.candidate_crop)

    if args.mode == "stack":
        board = stack_board(
            concept,
            candidate,
            width=args.width,
            label_concept=args.label_concept,
            label_candidate=args.label_candidate,
            bg=args.bg,
            label_bg=args.label_bg,
            label_fg=args.label_fg,
            gap=args.gap,
            label_height=args.label_height,
        )
    else:
        board = side_by_side_board(
            concept,
            candidate,
            panel_width=args.width,
            label_concept=args.label_concept,
            label_candidate=args.label_candidate,
            bg=args.bg,
            label_bg=args.label_bg,
            label_fg=args.label_fg,
            gap=args.gap,
            label_height=args.label_height,
        )

    args.out.parent.mkdir(parents=True, exist_ok=True)
    board.save(args.out)
    print(args.out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
