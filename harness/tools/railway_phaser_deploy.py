#!/usr/bin/env python3
"""Build a minimal Railway deploy context for the Phaser web runtime."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HARNESS_CONFIG = ROOT / "harness" / "deploy" / "railway" / "phaser"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--game", default="mushroomer", help="Content game id compiled during Docker build.")
    parser.add_argument("--service", default="phaser-web", help="Railway service name.")
    parser.add_argument("--environment", default="production", help="Railway environment name.")
    parser.add_argument("--message", default="Deploy Phaser web static", help="Railway deployment message.")
    parser.add_argument("--railway-bin", default=None, help="Path to Railway CLI binary.")
    parser.add_argument("--docker-check", action="store_true", help="Build the staged Docker image before upload.")
    parser.add_argument("--dry-run", action="store_true", help="Prepare staging only; do not upload.")
    parser.add_argument("--keep-staging", action="store_true", help="Do not delete the staging directory.")
    return parser.parse_args()


def copy_tree(src: Path, dst: Path) -> None:
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)


def prepare_staging(stage: Path) -> None:
    (stage / "harness").mkdir(parents=True, exist_ok=True)

    shutil.copy2(HARNESS_CONFIG / "Dockerfile", stage / "Dockerfile.phaser")
    shutil.copy2(HARNESS_CONFIG / "railway.json", stage / "railway.json")
    shutil.copy2(HARNESS_CONFIG / ".dockerignore", stage / ".dockerignore")

    copy_tree(HARNESS_CONFIG, stage / "harness" / "deploy" / "railway" / "phaser")
    copy_tree(ROOT / "harness" / "runtime", stage / "harness" / "runtime")
    copy_tree(ROOT / "harness" / "tools", stage / "harness" / "tools")
    copy_tree(ROOT / "harness" / "content", stage / "harness" / "content")
    copy_tree(ROOT / "harness" / "game-profiles", stage / "harness" / "game-profiles")
    copy_tree(ROOT / "harness" / "engine-contract", stage / "harness" / "engine-contract")


def run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, cwd=cwd, check=True)


def find_railway(args: argparse.Namespace) -> str:
    explicit = args.railway_bin or os.environ.get("RAILWAY_BIN")
    if explicit:
        return explicit
    found = shutil.which("railway")
    if found:
        return found
    raise FileNotFoundError(
        "Railway CLI not found. Install it permanently and make `railway` available on PATH, "
        "or pass --railway-bin /absolute/path/to/railway. "
        "For one-off local overrides, RAILWAY_BIN=/absolute/path/to/railway also works."
    )


def main() -> int:
    args = parse_args()
    if args.game != "mushroomer":
        print("Only mushroomer is currently wired into the Phaser Dockerfile.", file=sys.stderr)
        return 2

    stage = Path(tempfile.mkdtemp(prefix="idlez-phaser-railway.", dir="/private/tmp"))
    try:
        prepare_staging(stage)
        print(f"Prepared staging: {stage}")

        if args.docker_check:
            run([
                "docker",
                "build",
                "-f",
                "Dockerfile.phaser",
                "-t",
                "idlez-phaser-railway-staging-smoke",
                str(stage),
            ])

        if args.dry_run:
            return 0

        railway = find_railway(args)
        run([
            railway,
            "up",
            str(stage),
            "--path-as-root",
            "--service",
            args.service,
            "--environment",
            args.environment,
            "--message",
            args.message,
        ], cwd=ROOT)
    finally:
        if args.keep_staging:
            print(f"Kept staging: {stage}")
        else:
            shutil.rmtree(stage, ignore_errors=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
