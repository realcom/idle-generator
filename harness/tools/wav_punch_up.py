#!/usr/bin/env python3
"""
wav_punch_up.py — make short generated SFX feel louder without hard clipping.

This is a simple offline mastering pass for 16-bit PCM WAVs:
  1. Estimate active RMS, ignoring near-silence.
  2. Raise gain toward a target active RMS.
  3. Soft-limit peaks with tanh saturation.
  4. Scale to a final peak ceiling.

Usage:
  python3 harness/tools/wav_punch_up.py --target-rms 0.13 --peak 0.74 harness/build/sfx/*.wav
"""

from __future__ import annotations

import argparse
from array import array
import math
from pathlib import Path
import sys
import wave


def read_wav(path: Path) -> tuple[wave._wave_params, list[float]]:
    with wave.open(str(path), "rb") as reader:
        params = reader.getparams()
        frames = reader.readframes(params.nframes)

    if params.sampwidth != 2:
        raise ValueError(f"{path}: only 16-bit PCM WAV is supported")

    samples = array("h")
    samples.frombytes(frames)
    if sys.byteorder == "big":
        samples.byteswap()
    return params, [sample / 32768.0 for sample in samples]


def write_wav(path: Path, params: wave._wave_params, samples: list[float]) -> None:
    out = array("h", (float_to_i16(sample) for sample in samples))
    if sys.byteorder == "big":
        out.byteswap()
    with wave.open(str(path), "wb") as writer:
        writer.setparams(params)
        writer.writeframes(out.tobytes())


def float_to_i16(value: float) -> int:
    return max(-32768, min(32767, int(round(value * 32767.0))))


def peak(samples: list[float]) -> float:
    return max((abs(sample) for sample in samples), default=0.0)


def rms(samples: list[float]) -> float:
    if not samples:
        return 0.0
    return math.sqrt(sum(sample * sample for sample in samples) / len(samples))


def active_rms(samples: list[float], threshold: float) -> float:
    active = [sample for sample in samples if abs(sample) >= threshold]
    return rms(active or samples)


def soft_limit(sample: float, ceiling: float, hardness: float) -> float:
    if ceiling <= 0:
        return sample
    return ceiling * math.tanh((sample / ceiling) * hardness) / math.tanh(hardness)


def process(
    samples: list[float],
    *,
    target_rms: float,
    peak_ceiling: float,
    max_gain: float,
    threshold: float,
    hardness: float,
) -> tuple[list[float], dict[str, float]]:
    before_peak = peak(samples)
    before_rms = rms(samples)
    before_active = active_rms(samples, threshold)

    gain = 1.0
    if before_active > 0:
        gain = min(max_gain, target_rms / before_active)

    driven = [sample * gain for sample in samples]
    limited = [soft_limit(sample, peak_ceiling, hardness) for sample in driven]

    after_limit_peak = peak(limited)
    if after_limit_peak > 0:
        final_gain = peak_ceiling / after_limit_peak
    else:
        final_gain = 1.0
    mastered = [sample * final_gain for sample in limited]

    return mastered, {
        "before_peak": before_peak,
        "before_rms": before_rms,
        "before_active_rms": before_active,
        "input_gain": gain,
        "final_gain": final_gain,
        "after_peak": peak(mastered),
        "after_rms": rms(mastered),
        "after_active_rms": active_rms(mastered, threshold),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Punch up 16-bit PCM WAV SFX with active-RMS gain and soft limiting.")
    parser.add_argument("paths", nargs="+", type=Path)
    parser.add_argument("--target-rms", type=float, default=0.13)
    parser.add_argument("--peak", type=float, default=0.74)
    parser.add_argument("--max-gain", type=float, default=8.0)
    parser.add_argument("--threshold", type=float, default=0.003)
    parser.add_argument("--hardness", type=float, default=1.45)
    args = parser.parse_args()

    if not 0 < args.target_rms < 1:
        parser.error("--target-rms must be > 0 and < 1")
    if not 0 < args.peak <= 1:
        parser.error("--peak must be > 0 and <= 1")
    if args.max_gain <= 0:
        parser.error("--max-gain must be > 0")

    for path in args.paths:
        params, samples = read_wav(path)
        mastered, stats = process(
            samples,
            target_rms=args.target_rms,
            peak_ceiling=args.peak,
            max_gain=args.max_gain,
            threshold=args.threshold,
            hardness=args.hardness,
        )
        write_wav(path, params, mastered)
        print(
            f"{path}: peak {stats['before_peak']:.3f}->{stats['after_peak']:.3f}, "
            f"rms {stats['before_rms']:.3f}->{stats['after_rms']:.3f}, "
            f"active {stats['before_active_rms']:.3f}->{stats['after_active_rms']:.3f}, "
            f"gain x{stats['input_gain']:.2f}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
