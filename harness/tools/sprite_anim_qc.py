#!/usr/bin/env python3
"""Measure whether a 2D sprite sheet reads as animation instead of jitter.

The tool is intentionally visual-production oriented: it reports silhouette
change, lower-body change, foot/contact drift, and optional bright warm prop
movement for things like lanterns. Outputs are written under harness/build by
convention and should be treated as review artifacts, not source assets.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

import numpy as np
from PIL import Image, ImageDraw


@dataclass
class FrameMetrics:
    frame: int
    bbox: list[int] | None
    area: int
    center_x: float | None
    center_y: float | None
    bottom_y: int | None
    contact_x: float | None
    contact_y: float | None
    lower_center_x: float | None
    lower_center_y: float | None
    warm_prop_x: float | None
    warm_prop_y: float | None


@dataclass
class RowMetrics:
    row: int
    name: str
    frames: list[FrameMetrics]
    silhouette_delta_mean: float
    silhouette_delta_min: float
    silhouette_delta_max: float
    lower_delta_mean: float
    lower_delta_min: float
    lower_delta_max: float
    cycle_variation: float
    bottom_y_range: float
    contact_x_range: float
    lower_center_x_range: float
    warm_prop_travel: float | None
    warm_prop_step_max: float | None
    warnings: list[str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="QC a fixed-grid sprite animation sheet for jitter vs readable motion."
    )
    parser.add_argument("--sheet", required=True, help="Input spritesheet PNG.")
    parser.add_argument("--rows", type=int, required=True, help="Number of animation rows.")
    parser.add_argument("--cols", type=int, required=True, help="Number of frames per row.")
    parser.add_argument("--frame-width", type=int, help="Frame width. Defaults to sheet width / cols.")
    parser.add_argument("--frame-height", type=int, help="Frame height. Defaults to sheet height / rows.")
    parser.add_argument(
        "--row-names",
        help="Comma-separated row names. Example: down,left,up.",
    )
    parser.add_argument(
        "--out-dir",
        help="Optional output directory for metrics, markdown, contact sheet, and row GIFs.",
    )
    parser.add_argument(
        "--alpha-threshold",
        type=int,
        default=8,
        help="Alpha above this value counts as sprite silhouette. Default: 8.",
    )
    parser.add_argument(
        "--silhouette-min",
        type=float,
        default=0.105,
        help="Warn when mean adjacent silhouette delta is below this ratio. Default: 0.105.",
    )
    parser.add_argument(
        "--lower-min",
        type=float,
        default=0.13,
        help="Warn when mean lower-body delta is below this ratio. Default: 0.13.",
    )
    parser.add_argument(
        "--contact-min",
        type=float,
        default=8.0,
        help="Warn when contact/foot x travel is below this many pixels. Default: 8.",
    )
    parser.add_argument(
        "--baseline-max",
        type=float,
        default=3.0,
        help="Warn when bottom baseline range exceeds this many pixels. Default: 3.",
    )
    parser.add_argument(
        "--warm-prop-min",
        type=float,
        default=10.0,
        help="Warn when detected warm prop travel is below this many pixels. Default: 10.",
    )
    return parser.parse_args()


def split_sheet(
    image: Image.Image,
    rows: int,
    cols: int,
    frame_width: int,
    frame_height: int,
) -> list[list[Image.Image]]:
    frames: list[list[Image.Image]] = []
    for row in range(rows):
        row_frames: list[Image.Image] = []
        for col in range(cols):
            left = col * frame_width
            top = row * frame_height
            row_frames.append(image.crop((left, top, left + frame_width, top + frame_height)))
        frames.append(row_frames)
    return frames


def alpha_mask(frame: Image.Image, threshold: int) -> np.ndarray:
    rgba = np.asarray(frame.convert("RGBA"))
    return rgba[:, :, 3] > threshold


def bbox_from_mask(mask: np.ndarray) -> tuple[int, int, int, int] | None:
    ys, xs = np.nonzero(mask)
    if len(xs) == 0:
        return None
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def centroid(mask: np.ndarray) -> tuple[float, float] | tuple[None, None]:
    ys, xs = np.nonzero(mask)
    if len(xs) == 0:
        return None, None
    return float(xs.mean()), float(ys.mean())


def ratio_delta(a: np.ndarray, b: np.ndarray) -> float:
    union = np.logical_or(a, b)
    union_area = int(union.sum())
    if union_area == 0:
        return 0.0
    return float(np.logical_xor(a, b).sum() / union_area)


def value_range(values: list[float | int | None]) -> float:
    clean = [float(value) for value in values if value is not None]
    if len(clean) < 2:
        return 0.0
    return max(clean) - min(clean)


def path_travel(points: list[tuple[float | None, float | None]]) -> tuple[float | None, float | None]:
    clean = [(float(x), float(y)) for x, y in points if x is not None and y is not None]
    if len(clean) < 2:
        return None, None
    distances = [
        math.hypot(clean[index][0] - clean[index - 1][0], clean[index][1] - clean[index - 1][1])
        for index in range(1, len(clean))
    ]
    return float(sum(distances)), float(max(distances))


def lower_body_mask(mask: np.ndarray, bbox: tuple[int, int, int, int] | None) -> np.ndarray:
    if bbox is None:
        return np.zeros_like(mask, dtype=bool)
    _, top, _, bottom = bbox
    cutoff = int(round(top + (bottom - top) * 0.58))
    lower = np.zeros_like(mask, dtype=bool)
    lower[cutoff:, :] = mask[cutoff:, :]
    return lower


def contact_mask(mask: np.ndarray, bbox: tuple[int, int, int, int] | None) -> np.ndarray:
    if bbox is None:
        return np.zeros_like(mask, dtype=bool)
    _, _, _, bottom = bbox
    band_top = max(0, bottom - max(10, int(round(mask.shape[0] * 0.06))))
    contact = np.zeros_like(mask, dtype=bool)
    contact[band_top:bottom, :] = mask[band_top:bottom, :]
    return contact


def warm_prop_mask(frame: Image.Image, silhouette: np.ndarray, bbox: tuple[int, int, int, int] | None) -> np.ndarray:
    if bbox is None:
        return np.zeros_like(silhouette, dtype=bool)
    rgba = np.asarray(frame.convert("RGBA")).astype(np.int16)
    red = rgba[:, :, 0]
    green = rgba[:, :, 1]
    blue = rgba[:, :, 2]
    alpha = rgba[:, :, 3]
    _, top, _, bottom = bbox
    lower_cutoff = int(round(top + (bottom - top) * 0.34))
    y_gate = np.zeros_like(silhouette, dtype=bool)
    y_gate[lower_cutoff:, :] = True
    return (
        silhouette
        & y_gate
        & (alpha > 24)
        & (red > 175)
        & (green > 105)
        & (blue < 115)
        & ((red - blue) > 75)
        & ((green - blue) > 35)
    )


def frame_metrics(frame: Image.Image, index: int, threshold: int) -> tuple[FrameMetrics, np.ndarray, np.ndarray]:
    silhouette = alpha_mask(frame, threshold)
    bbox = bbox_from_mask(silhouette)
    center_x, center_y = centroid(silhouette)
    lower = lower_body_mask(silhouette, bbox)
    lower_center_x, lower_center_y = centroid(lower)
    contact = contact_mask(silhouette, bbox)
    contact_x, contact_y = centroid(contact)
    warm = warm_prop_mask(frame, silhouette, bbox)
    warm_x, warm_y = centroid(warm)
    metrics = FrameMetrics(
        frame=index,
        bbox=list(bbox) if bbox else None,
        area=int(silhouette.sum()),
        center_x=center_x,
        center_y=center_y,
        bottom_y=bbox[3] - 1 if bbox else None,
        contact_x=contact_x,
        contact_y=contact_y,
        lower_center_x=lower_center_x,
        lower_center_y=lower_center_y,
        warm_prop_x=warm_x,
        warm_prop_y=warm_y,
    )
    return metrics, silhouette, lower


def row_metrics(
    row_index: int,
    name: str,
    frames: list[Image.Image],
    threshold: int,
    args: argparse.Namespace,
) -> RowMetrics:
    frame_data = [frame_metrics(frame, index, threshold) for index, frame in enumerate(frames)]
    metrics = [data[0] for data in frame_data]
    silhouettes = [data[1] for data in frame_data]
    lowers = [data[2] for data in frame_data]
    adjacent_silhouette = [
        ratio_delta(silhouettes[index - 1], silhouettes[index])
        for index in range(1, len(silhouettes))
    ]
    adjacent_lower = [
        ratio_delta(lowers[index - 1], lowers[index])
        for index in range(1, len(lowers))
    ]
    union = np.logical_or.reduce(silhouettes)
    intersection = np.logical_and.reduce(silhouettes)
    cycle_variation = 0.0 if union.sum() == 0 else float(np.logical_xor(union, intersection).sum() / union.sum())
    warm_travel, warm_step_max = path_travel([(m.warm_prop_x, m.warm_prop_y) for m in metrics])
    bottom_y_range = value_range([m.bottom_y for m in metrics])
    contact_x_range = value_range([m.contact_x for m in metrics])
    lower_center_x_range = value_range([m.lower_center_x for m in metrics])
    warnings: list[str] = []
    silhouette_mean = float(np.mean(adjacent_silhouette)) if adjacent_silhouette else 0.0
    lower_mean = float(np.mean(adjacent_lower)) if adjacent_lower else 0.0
    if silhouette_mean < args.silhouette_min:
        warnings.append("low silhouette change")
    if lower_mean < args.lower_min:
        warnings.append("low lower-body/foot change")
    if bottom_y_range > args.baseline_max:
        warnings.append("foot baseline drift")
    if contact_x_range < args.contact_min and lower_mean < args.lower_min * 1.25:
        warnings.append("feet read as planted/jittering")
    if lower_center_x_range < args.contact_min and lower_mean < args.lower_min * 1.2:
        warnings.append("lower-body mass barely travels")
    if warm_travel is not None and warm_travel < args.warm_prop_min:
        warnings.append("warm prop swing is too subtle")
    if warm_step_max is not None and warm_travel is not None and warm_step_max > max(18.0, warm_travel * 0.45):
        warnings.append("warm prop has abrupt frame drift")
    return RowMetrics(
        row=row_index,
        name=name,
        frames=metrics,
        silhouette_delta_mean=silhouette_mean,
        silhouette_delta_min=float(min(adjacent_silhouette)) if adjacent_silhouette else 0.0,
        silhouette_delta_max=float(max(adjacent_silhouette)) if adjacent_silhouette else 0.0,
        lower_delta_mean=lower_mean,
        lower_delta_min=float(min(adjacent_lower)) if adjacent_lower else 0.0,
        lower_delta_max=float(max(adjacent_lower)) if adjacent_lower else 0.0,
        cycle_variation=cycle_variation,
        bottom_y_range=bottom_y_range,
        contact_x_range=contact_x_range,
        lower_center_x_range=lower_center_x_range,
        warm_prop_travel=warm_travel,
        warm_prop_step_max=warm_step_max,
        warnings=warnings,
    )


def paint_checkerboard(image: Image.Image, tile: int = 32) -> None:
    draw = ImageDraw.Draw(image)
    colors = ((238, 242, 246, 255), (225, 231, 237, 255))
    for top in range(0, image.height, tile):
        for left in range(0, image.width, tile):
            color = colors[((left // tile) + (top // tile)) % 2]
            draw.rectangle((left, top, left + tile, top + tile), fill=color)


def render_contact_sheet(
    rows: list[list[Image.Image]],
    metrics: list[RowMetrics],
    out_path: Path,
    frame_width: int,
    frame_height: int,
) -> None:
    sheet = Image.new("RGBA", (frame_width * len(rows[0]), frame_height * len(rows)), (255, 255, 255, 255))
    paint_checkerboard(sheet)
    draw = ImageDraw.Draw(sheet)
    for row_index, row in enumerate(rows):
        for col_index, frame in enumerate(row):
            x = col_index * frame_width
            y = row_index * frame_height
            sheet.alpha_composite(frame, (x, y))
            draw.rectangle((x, y, x + frame_width - 1, y + frame_height - 1), outline=(32, 38, 44, 210), width=2)
            draw.text((x + 8, y + 8), f"{metrics[row_index].name} {col_index + 1}", fill=(32, 38, 44, 255))
            frame_metric = metrics[row_index].frames[col_index]
            if frame_metric.bottom_y is not None:
                baseline = y + frame_metric.bottom_y
                draw.line((x, baseline, x + frame_width, baseline), fill=(255, 70, 60, 180), width=2)
            if frame_metric.contact_x is not None and frame_metric.contact_y is not None:
                cx = x + frame_metric.contact_x
                cy = y + frame_metric.contact_y
                draw.ellipse((cx - 5, cy - 5, cx + 5, cy + 5), fill=(60, 220, 120, 230), outline=(20, 80, 40, 255))
            if frame_metric.warm_prop_x is not None and frame_metric.warm_prop_y is not None:
                px = x + frame_metric.warm_prop_x
                py = y + frame_metric.warm_prop_y
                draw.ellipse((px - 6, py - 6, px + 6, py + 6), fill=(255, 205, 42, 240), outline=(92, 56, 0, 255))
    out_path.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out_path)


def render_row_gifs(rows: list[list[Image.Image]], metrics: list[RowMetrics], out_dir: Path) -> None:
    for row, row_metric in zip(rows, metrics):
        composites: list[Image.Image] = []
        for frame in row:
            composite = Image.new("RGBA", frame.size, (255, 255, 255, 255))
            paint_checkerboard(composite)
            composite.alpha_composite(frame)
            composites.append(composite.convert("P", palette=Image.Palette.ADAPTIVE))
        if composites:
            composites[0].save(
                out_dir / f"{row_metric.name}.gif",
                save_all=True,
                append_images=composites[1:],
                duration=120,
                loop=0,
                disposal=2,
            )


def write_report(sheet_path: Path, metrics: list[RowMetrics], out_path: Path) -> None:
    lines = [
        f"# Sprite Animation QC: {sheet_path.name}",
        "",
        "| row | silhouette mean | lower mean | cycle variation | baseline range px | contact x range px | warm travel px | warnings |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for row in metrics:
        warm = "-" if row.warm_prop_travel is None else f"{row.warm_prop_travel:.1f}"
        warnings = ", ".join(row.warnings) if row.warnings else "ok"
        lines.append(
            "| "
            + " | ".join(
                [
                    row.name,
                    f"{row.silhouette_delta_mean:.3f}",
                    f"{row.lower_delta_mean:.3f}",
                    f"{row.cycle_variation:.3f}",
                    f"{row.bottom_y_range:.1f}",
                    f"{row.contact_x_range:.1f}",
                    warm,
                    warnings,
                ]
            )
            + " |"
        )
    lines.extend(
        [
            "",
            "## Legend",
            "",
            "- `silhouette mean`: adjacent-frame alpha-mask delta. Too low means the pose barely changes.",
            "- `lower mean`: same delta, limited to lower body. Too low means feet/legs are not carrying the walk.",
            "- `baseline range`: bottom-most alpha drift. High values make the sprite slide or bob unexpectedly.",
            "- `contact x range`: horizontal movement of the lower contact cluster. Very low values plus low lower-body change reads as jitter.",
            "- `warm travel`: detected bright warm prop path, useful for lantern swing checks.",
            "",
        ]
    )
    out_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    args = parse_args()
    sheet_path = Path(args.sheet)
    image = Image.open(sheet_path).convert("RGBA")
    frame_width = args.frame_width or image.width // args.cols
    frame_height = args.frame_height or image.height // args.rows
    if image.width < frame_width * args.cols or image.height < frame_height * args.rows:
        raise SystemExit("The requested grid does not fit inside the sheet.")
    row_names = args.row_names.split(",") if args.row_names else [f"row-{index + 1}" for index in range(args.rows)]
    if len(row_names) != args.rows:
        raise SystemExit("--row-names count must match --rows.")

    rows = split_sheet(image, args.rows, args.cols, frame_width, frame_height)
    metrics = [
        row_metrics(index, row_names[index], row, args.alpha_threshold, args)
        for index, row in enumerate(rows)
    ]
    data: dict[str, Any] = {
        "sheet": str(sheet_path),
        "rows": args.rows,
        "cols": args.cols,
        "frame": {"width": frame_width, "height": frame_height},
        "row_metrics": [asdict(row) for row in metrics],
    }
    if args.out_dir:
        out_dir = Path(args.out_dir)
        out_dir.mkdir(parents=True, exist_ok=True)
        (out_dir / "metrics.json").write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")
        write_report(sheet_path, metrics, out_dir / "report.md")
        render_contact_sheet(rows, metrics, out_dir / "contact_sheet.png", frame_width, frame_height)
        render_row_gifs(rows, metrics, out_dir)
    print(json.dumps(data, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
