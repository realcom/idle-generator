#!/usr/bin/env python3
"""Build a minimal Railway deploy context for the Phaser web runtime."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HARNESS_CONFIG = ROOT / "harness" / "deploy" / "railway" / "phaser"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--game", default="ninja2", help="Content game id compiled during Docker build.")
    parser.add_argument("--service", default="ninja2-web", help="Railway service name.")
    parser.add_argument("--environment", default="production", help="Railway environment name.")
    parser.add_argument("--message", default="Deploy Ninja2 Phaser web static", help="Railway deployment message.")
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
    copy_tree(ROOT / "engine" / "commons", stage / "engine" / "commons")


def run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, cwd=cwd, check=True)


def rewrite_default_game(stage: Path, game_id: str) -> None:
    dockerfile = stage / "Dockerfile.phaser"
    caddyfile = stage / "harness" / "deploy" / "railway" / "phaser" / "Caddyfile"
    railway_config = stage / "railway.json"
    harness_railway_config = stage / "harness" / "deploy" / "railway" / "phaser" / "railway.json"
    root_route = "/survivor-runtime.html?game=ninja2" if game_id == "ninja2" else "/idlez-phaser.html"

    dockerfile.write_text(
        dockerfile.read_text(encoding="utf-8").replace("ARG GAME_ID=ninja2", f"ARG GAME_ID={game_id}"),
        encoding="utf-8",
    )
    caddyfile.write_text(
        caddyfile.read_text(encoding="utf-8").replace(
            "/survivor-runtime.html?game=ninja2",
            root_route,
        ),
        encoding="utf-8",
    )
    for config in [railway_config, harness_railway_config]:
        config.write_text(
            config.read_text(encoding="utf-8")
            .replace("harness/content/ninja2/**", f"harness/content/{game_id}/**")
            .replace("harness/game-profiles/ninja2.profile.yaml", f"harness/game-profiles/{game_id}.profile.yaml"),
            encoding="utf-8",
        )


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

    stage = Path(tempfile.mkdtemp(prefix="idlez-phaser-railway.", dir="/private/tmp"))
    try:
        prepare_staging(stage)
        rewrite_default_game(stage, args.game)
        print(f"Prepared staging: {stage}")

        if args.docker_check:
            run([
                "docker",
                "build",
                "--build-arg",
                f"GAME_ID={args.game}",
                "-f",
                "Dockerfile.phaser",
                "-t",
                f"idlez-phaser-railway-{args.game}-staging-smoke",
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
