#!/usr/bin/env python3
"""
wav_peak_normalize.py — simple 16-bit PCM WAV peak normalizer.

Usage:
  python3 harness/tools/wav_peak_normalize.py --target-peak 0.62 harness/build/sfx/*.wav
"""

from __future__ import annotations

import argparse
from array import array
from pathlib import Path
import sys
import wave


def clamp_i16(value: float) -> int:
    return max(-32768, min(32767, int(round(value))))


def normalize(path: Path, target_peak: float, max_gain: float) -> tuple[float, float, float]:
    with wave.open(str(path), "rb") as reader:
        params = reader.getparams()
        frames = reader.readframes(params.nframes)

    if params.sampwidth != 2:
        raise ValueError(f"{path}: only 16-bit PCM WAV is supported")

    samples = array("h")
    samples.frombytes(frames)
    if sys.byteorder == "big":
        samples.byteswap()

    if not samples:
        return 0.0, 0.0, 1.0

    peak_i16 = max(abs(sample) for sample in samples)
    if peak_i16 == 0:
        return 0.0, 0.0, 1.0

    old_peak = peak_i16 / 32768.0
    gain = min(max_gain, target_peak / old_peak)
    if gain <= 0:
        gain = 1.0

    for i, sample in enumerate(samples):
        samples[i] = clamp_i16(sample * gain)

    new_peak = max(abs(sample) for sample in samples) / 32768.0

    if sys.byteorder == "big":
        samples.byteswap()
    with wave.open(str(path), "wb") as writer:
        writer.setparams(params)
        writer.writeframes(samples.tobytes())

    return old_peak, new_peak, gain


def main() -> int:
    parser = argparse.ArgumentParser(description="Normalize 16-bit PCM WAV files to a target peak.")
    parser.add_argument("paths", nargs="+", type=Path)
    parser.add_argument("--target-peak", type=float, default=0.62)
    parser.add_argument("--max-gain", type=float, default=12.0)
    args = parser.parse_args()

    if not 0 < args.target_peak <= 1:
        parser.error("--target-peak must be > 0 and <= 1")
    if args.max_gain <= 0:
        parser.error("--max-gain must be > 0")

    for path in args.paths:
        old_peak, new_peak, gain = normalize(path, args.target_peak, args.max_gain)
        print(f"{path}: peak {old_peak:.4f} -> {new_peak:.4f}, gain x{gain:.2f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
