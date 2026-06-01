#!/usr/bin/env python3
"""
asset_gen_helper.py — Cowork(Claude AI) 에서 호출하는 Asset Generator 헬퍼.

이미지 생성 파이프라인 (growninja의 AssetGenerator와 동등):
  1. AssetGeneratorSettings.json 로드 (Layer AI · Anthropic 키 + Style ID)
  2. 카테고리·부위에 따른 참조 이미지 자동 수집 (5~6장)
  3. Anthropic API로 영문 프롬프트 자동 생성
  4. Layer AI GraphQL `generateImages` 뮤테이션 호출 + 폴링
  5. 생성 PNG 다운로드
  6. Anthropic API로 자동 평가 (PASS/RETRY + 개선 프롬프트)
  7. assets/<game>/sprites/ 에 저장

기본은 dry-run (실 API 호출 안 함). 실제 호출은 --execute 플래그 필요.

사용 예:
  # 검증
  python tools/asset_gen_helper.py --check-config
  python tools/asset_gen_helper.py --check-network

  # dry-run (요청 본문만 출력)
  python tools/asset_gen_helper.py --game idlez --category Currency \
    --desc "정원 결정 — 녹색 빛나는 꽃 결정체"

  # 실 호출 (API 키 사용, 사용자 quota 소비)
  python tools/asset_gen_helper.py --game idlez --category Currency \
    --desc "정원 결정" --execute
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import random
import sys
import time
from pathlib import Path
from typing import Optional
import urllib.request
import urllib.error

# ─────────────────────────────────────────────────────────────────────────
# 경로 정의 (스크립트 위치 기준)
# ─────────────────────────────────────────────────────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent  # idle-game-generator/

SETTINGS_PATH = PROJECT_ROOT / "AssetGeneratorSettings.json"
ASSETS_BASE = PROJECT_ROOT / "assets"
EXAMPLE_PATCHRESOURCES = PROJECT_ROOT / "examples" / "patchresources"

LAYER_AI_ENDPOINT = "https://api.app.layer.ai/"
ANTHROPIC_API_URL = "https://api.anthropic.com/v1/messages"
ANTHROPIC_API_VERSION = "2023-06-01"

# 카테고리 → (output sub, reference glob)
CATEGORY_CONFIG = {
    "Currency": {
        "output_sub": "sprites",
        "ref_glob": "sprites/item_-*.png",  # 재화·소재는 보통 음수 ID 대역
        "filename_prefix": "item_currency",
    },
    "Equipment": {
        "output_sub": "sprites",
        "ref_glob_template": "sprites/item_*.png",  # 부위로 더 정밀화 가능
        "filename_template": "item_equip_{part}",
    },
    "Character": {
        "output_sub": "sprites",
        "ref_glob": "sprites/unit_*.png",
        "filename_template": "unit_{character_id}",
    },
}


# ─────────────────────────────────────────────────────────────────────────
# 설정 로드
# ─────────────────────────────────────────────────────────────────────────
def load_settings() -> dict:
    if not SETTINGS_PATH.exists():
        sys.exit(
            f"[ERROR] AssetGeneratorSettings.json 없음: {SETTINGS_PATH}\n"
            f"  → 프로젝트 루트에 다음 파일을 생성하세요:\n"
            f"  {{\n"
            f'    "layerAIToken": "your-token",\n'
            f'    "layerAIWorkspaceId": "workspace-id",\n'
            f'    "currencyStyleId": "style-id",\n'
            f'    "equipmentStyleId": "style-id",\n'
            f'    "characterStyleId": "style-id",\n'
            f'    "anthropicApiKey": "your-key",\n'
            f'    "anthropicModel": "claude-sonnet-4-6"\n'
            f"  }}"
        )
    with SETTINGS_PATH.open(encoding="utf-8") as f:
        return json.load(f)


def get_style_id(settings: dict, category: str) -> str:
    key = {
        "Currency": "currencyStyleId",
        "Equipment": "equipmentStyleId",
        "Character": "characterStyleId",
    }[category]
    style_id = settings.get(key, "")
    if not style_id:
        sys.exit(
            f"[ERROR] {category} 카테고리의 Style ID가 비어있음 (settings.{key}).\n"
            f"  → AssetGeneratorSettings.json에 Style ID 입력 후 저장."
        )
    return style_id


# ─────────────────────────────────────────────────────────────────────────
# 참조 이미지 자동 수집
# ─────────────────────────────────────────────────────────────────────────
def gather_references(
    game: str,
    category: str,
    part: Optional[str] = None,
    k: int = 5,
    reference_root: Optional[Path] = None,
) -> list[Path]:
    """기존 게임 자산에서 참조 이미지 K장 수집."""
    game_assets = reference_root or (ASSETS_BASE / game)

    if category == "Currency":
        pattern = "sprites/item_-*.png"  # 음수 대역
    elif category == "Equipment":
        pattern = "sprites/item_*.png"
    elif category == "Character":
        pattern = "sprites/unit_*.png"
    else:
        pattern = "sprites/item_*.png"

    candidates = sorted(game_assets.glob(pattern))
    if not candidates and reference_root is None:
        candidates = gather_example_references(category, part)
    if not candidates:
        return []
    random.seed(42)  # 재현 가능성
    sample = random.sample(candidates, min(k, len(candidates)))
    return sample


def gather_example_references(category: str, part: Optional[str] = None) -> list[Path]:
    """harness/examples/patchresources 에서 참조 이미지 후보 수집."""
    if not EXAMPLE_PATCHRESOURCES.exists():
        return []

    if category == "Currency":
        patterns = ["Items/Goods/*.png", "Items/Icons/*.png"]
    elif category == "Equipment":
        patterns = ["Items/Equipments/*.png", "Items/InventoryWeapons/*.png"]
    elif category == "Character":
        patterns = [
            "Units/Characters/Assets/*.png",
            "Units/Monsters/Assets/*.png",
            "Units/Pets/Assets/*.png",
        ]
    else:
        patterns = ["Items/**/*.png"]

    candidates: list[Path] = []
    for pattern in patterns:
        candidates.extend(EXAMPLE_PATCHRESOURCES.glob(pattern))
    return sorted({path for path in candidates if path.is_file()})


def img_to_base64(path: Path) -> str:
    return base64.b64encode(path.read_bytes()).decode("ascii")


# ─────────────────────────────────────────────────────────────────────────
# Anthropic API — 프롬프트 생성·평가
# ─────────────────────────────────────────────────────────────────────────
def _anthropic_call(
    api_key: str,
    model: str,
    system: str,
    user_content: list,
    max_tokens: int = 1024,
) -> str:
    """Anthropic Messages API 호출. 텍스트 응답 반환."""
    body = {
        "model": model,
        "max_tokens": max_tokens,
        "system": system,
        "messages": [{"role": "user", "content": user_content}],
    }
    req = urllib.request.Request(
        ANTHROPIC_API_URL,
        data=json.dumps(body).encode("utf-8"),
        headers={
            "x-api-key": api_key,
            "anthropic-version": ANTHROPIC_API_VERSION,
            "content-type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        msg = e.read().decode("utf-8", "ignore")
        sys.exit(f"[ERROR] Anthropic API HTTP {e.code}: {msg}")
    return "".join(blk.get("text", "") for blk in data.get("content", []) if blk.get("type") == "text")


def claude_generate_prompt(
    api_key: str,
    model: str,
    description: str,
    reference_paths: list[Path],
) -> str:
    """간단 설명 + 참조 이미지 → 영문 프롬프트."""
    system = (
        "You convert a brief Korean/English description into a detailed English prompt "
        "optimized for generating game asset icons. "
        "Match the art style of the provided reference images. "
        "Output ONLY the prompt text — no preamble, no quotes, no JSON."
    )
    user_content = [{"type": "text", "text": "[참조 이미지들 — 기존 게임 에셋 스타일]"}]
    for ref in reference_paths:
        user_content.append(
            {
                "type": "image",
                "source": {"type": "base64", "media_type": "image/png", "data": img_to_base64(ref)},
            }
        )
    user_content.append(
        {
            "type": "text",
            "text": f"[유저 요청]\n{description}\n\n위 참조 스타일에 맞춰 영문 프롬프트만 출력.",
        }
    )
    return _anthropic_call(api_key, model, system, user_content, max_tokens=512).strip()


def claude_evaluate(
    api_key: str,
    model: str,
    generated_image_path: Path,
    reference_paths: list[Path],
    prompt: str,
    is_currency: bool,
) -> tuple[bool, str]:
    """생성 이미지 평가 → (PASS 여부, 개선 프롬프트)."""
    system = (
        "You evaluate a generated game asset against reference images and prompt. "
        "Score on: 스타일 매칭 / 프롬프트 충실도 / 품질(선·구도·아티팩트) / 게임 적합성. "
        "End with two lines:\n"
        "판정: PASS 또는 RETRY\n"
        "개선된 프롬프트: (RETRY면 수정, PASS면 원본 그대로)"
    )
    user_content = [{"type": "text", "text": "[참조 이미지들]"}]
    for ref in reference_paths:
        user_content.append(
            {
                "type": "image",
                "source": {"type": "base64", "media_type": "image/png", "data": img_to_base64(ref)},
            }
        )
    user_content += [
        {"type": "text", "text": "[생성된 이미지]"},
        {
            "type": "image",
            "source": {"type": "base64", "media_type": "image/png", "data": img_to_base64(generated_image_path)},
        },
        {"type": "text", "text": f"사용된 프롬프트: {prompt}"},
    ]
    if is_currency:
        user_content.append(
            {"type": "text", "text": "재화/소재 아이콘이므로 장비/방어구 표현 사용 금지."}
        )
    text = _anthropic_call(api_key, model, system, user_content, max_tokens=1024)
    passed = "PASS" in text.upper() and "RETRY" not in text.upper()
    # "개선된 프롬프트:" 이후 텍스트 추출
    refined = prompt
    marker = "개선된 프롬프트:"
    if marker in text:
        refined = text.split(marker, 1)[1].strip()
    return passed, refined


# ─────────────────────────────────────────────────────────────────────────
# Layer AI — 이미지 생성 (GraphQL)
# ─────────────────────────────────────────────────────────────────────────
def _gql_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "")


def layer_ai_generate(
    token: str, workspace_id: str, style_id: str, prompt: str, timeout_s: int = 120
) -> bytes:
    """Layer AI GraphQL generateImages 호출 + (필요 시) 폴링 → PNG bytes 반환."""
    gql = (
        "mutation { generateImages(input: { "
        f'prompt: "{_gql_escape(prompt)}", '
        f'workspaceId: "{workspace_id}", '
        f'styleId: "{style_id}"'
        " }) { __typename ... on Inference { id files { url } } ... on Error { type message } } }"
    )
    body = json.dumps({"query": gql}).encode("utf-8")

    def _post(query_body: bytes) -> dict:
        req = urllib.request.Request(
            LAYER_AI_ENDPOINT,
            data=query_body,
            headers={
                "Authorization": f"Bearer {token}",
                "Accept": "application/json",
                "Content-Type": "application/json",
            },
            method="POST",
        )
        with urllib.request.urlopen(req, timeout=timeout_s) as resp:
            return json.loads(resp.read().decode("utf-8"))

    # 1차 호출 (재시도 with backoff)
    last_err = None
    for delay in (0, 5, 10, 20):
        if delay:
            time.sleep(delay)
        try:
            data = _post(body)
            break
        except urllib.error.HTTPError as e:
            if e.code in (502, 503, 529):
                last_err = e
                continue
            sys.exit(f"[ERROR] Layer AI HTTP {e.code}: {e.read().decode('utf-8', 'ignore')}")
    else:
        sys.exit(f"[ERROR] Layer AI 재시도 한계: {last_err}")

    if "errors" in data:
        sys.exit(f"[ERROR] Layer AI GraphQL errors: {data['errors']}")

    gen = data.get("data", {}).get("generateImages", {})
    if gen.get("__typename") == "Error":
        sys.exit(f"[ERROR] Layer AI 응답 오류: {gen.get('message')}")

    # 동기 응답: files[].url 바로 있음
    files = gen.get("files") or []
    inference_id = gen.get("id")
    if files and files[0].get("url"):
        return _download(files[0]["url"])

    # 비동기 응답: id로 폴링
    if not inference_id:
        sys.exit(f"[ERROR] Layer AI 응답에서 id/url 추출 실패: {data}")

    poll_gql = (
        f'query {{ inference(id: "{inference_id}") '
        "{ id status files { url } } }"
    )
    poll_body = json.dumps({"query": poll_gql}).encode("utf-8")
    for attempt in range(40):
        time.sleep(3)
        try:
            d = _post(poll_body)
        except urllib.error.HTTPError:
            continue
        inf = d.get("data", {}).get("inference", {})
        status = inf.get("status", "")
        if status in ("COMPLETED", "SUCCEEDED"):
            files = inf.get("files") or []
            if files and files[0].get("url"):
                return _download(files[0]["url"])
        if status in ("FAILED", "ERROR"):
            sys.exit(f"[ERROR] Layer AI inference 실패: {inf}")
    sys.exit("[ERROR] Layer AI 폴링 타임아웃")


def _download(url: str) -> bytes:
    with urllib.request.urlopen(url, timeout=120) as resp:
        return resp.read()


# ─────────────────────────────────────────────────────────────────────────
# 저장
# ─────────────────────────────────────────────────────────────────────────
def save_asset(image_data: bytes, game: str, category: str, hint: str) -> Path:
    """assets/<game>/sprites/ 에 PNG 저장."""
    out_dir = ASSETS_BASE / game / "sprites"
    out_dir.mkdir(parents=True, exist_ok=True)
    ts = time.strftime("%Y%m%d_%H%M%S")
    name = f"{hint}_{ts}.png"
    out_path = out_dir / name
    out_path.write_bytes(image_data)
    return out_path


# ─────────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────────
def cmd_check_config() -> None:
    s = load_settings()
    print(f"[OK] Settings 로드: {SETTINGS_PATH}")
    fields = [
        "layerAIToken",
        "layerAIWorkspaceId",
        "currencyStyleId",
        "equipmentStyleId",
        "characterStyleId",
        "anthropicApiKey",
        "anthropicModel",
    ]
    for f in fields:
        v = s.get(f, "")
        mark = "✓" if v else "✗"
        masked = (v[:6] + "…") if v and len(v) > 8 else v
        print(f"  {mark} {f}: {masked or '(비어있음)'}")


def cmd_check_network() -> None:
    print("Anthropic API:", end=" ")
    try:
        urllib.request.urlopen(ANTHROPIC_API_URL, timeout=10)
    except urllib.error.HTTPError as e:
        print(f"reachable (HTTP {e.code})")
    except Exception as e:
        print(f"FAIL ({e})")
    print("Layer AI:", end=" ")
    try:
        urllib.request.urlopen(LAYER_AI_ENDPOINT, timeout=10)
    except urllib.error.HTTPError as e:
        print(f"reachable (HTTP {e.code})")
    except Exception as e:
        print(f"FAIL ({e})")


def cmd_generate(args: argparse.Namespace) -> None:
    game = args.game
    category = args.category
    desc = args.desc
    reference_root = Path(args.reference_root).resolve() if args.reference_root else None
    refs = gather_references(game, category, part=args.part, k=args.refs, reference_root=reference_root)
    print(f"[1/6] 참조 이미지 {len(refs)}장 수집:")
    for r in refs:
        try:
            display = r.relative_to(PROJECT_ROOT)
        except ValueError:
            display = r
        print(f"      - {display}")
    if not refs:
        print("[WARN] 참조 이미지 없음 — assets/<game>/sprites/ 에 에셋 추가 후 시도하세요")

    if not args.execute:
        print(
            "\n[DRY-RUN] 실 API 호출은 안 함. 실 호출은 `--execute` 플래그 추가.\n"
            "  - Anthropic: 영문 프롬프트 생성\n"
            "  - Layer AI: 이미지 생성\n"
            "  - Anthropic: 평가 (PASS/RETRY)\n"
            f"  - 저장: assets/{game}/sprites/"
        )
        return

    settings = load_settings()
    api_key = settings["anthropicApiKey"]
    model = settings.get("anthropicModel", "claude-sonnet-4-6")
    print(f"[2/6] 프롬프트 생성 (Anthropic {model})...")
    prompt = claude_generate_prompt(api_key, model, desc, refs)
    print(f"      → {prompt}\n")

    style_id = get_style_id(settings, category)
    token = settings["layerAIToken"]
    workspace = settings["layerAIWorkspaceId"]
    print(f"[3/6] 이미지 생성 (Layer AI, style={style_id[:8]}…)...")
    image_data = layer_ai_generate(token, workspace, style_id, prompt)
    print(f"      → {len(image_data)} bytes")

    # 임시 저장 후 평가
    hint = (
        CATEGORY_CONFIG[category].get("filename_prefix")
        or CATEGORY_CONFIG[category]
        .get("filename_template", "asset_{x}")
        .format(part=args.part or "X", character_id=args.character_id or 0, x="x")
    )
    saved = save_asset(image_data, game, category, hint)
    print(f"[4/6] 임시 저장: {saved.relative_to(PROJECT_ROOT)}")

    if args.skip_eval:
        print("[5/6] 평가 생략 (--skip-eval)")
        print(f"[6/6] 완료. 결과: {saved}")
        return

    print(f"[5/6] 자동 평가 (Anthropic)...")
    passed, refined = claude_evaluate(
        api_key, model, saved, refs, prompt, is_currency=(category == "Currency")
    )
    verdict = "PASS ✓" if passed else "RETRY"
    print(f"      → {verdict}")
    if not passed:
        print(f"      → 개선된 프롬프트: {refined[:200]}…")
        print(
            "\n      재생성하려면:\n"
            f'      python {Path(__file__).name} --game {game} --category {category} --desc "{refined}" --execute'
        )

    print(f"[6/6] 완료. 결과: {saved.relative_to(PROJECT_ROOT)}")
    print(f"      assets/{game}/asset-registry.yaml 에 새 키 등록 후 바인딩하세요.")


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    p.add_argument("--check-config", action="store_true", help="settings.json 확인")
    p.add_argument("--check-network", action="store_true", help="API 도달 확인")
    p.add_argument("--game", default="idlez", help="게임 이름 (기본: idlez)")
    p.add_argument("--category", choices=list(CATEGORY_CONFIG.keys()), help="카테고리")
    p.add_argument("--part", help="장비 부위 (BODY/GEAR/...)")
    p.add_argument("--character-id", type=int, help="캐릭터 ID")
    p.add_argument("--desc", help="간단 설명 (한/영)")
    p.add_argument("--refs", type=int, default=5, help="참조 이미지 장수 (기본 5)")
    p.add_argument(
        "--reference-root",
        help="참조 이미지 루트. 미지정 시 harness/assets/<game>를 보고, 없으면 harness/examples/patchresources를 사용.",
    )
    p.add_argument(
        "--execute", action="store_true", help="실 API 호출 (사용자 quota 소비)"
    )
    p.add_argument("--skip-eval", action="store_true", help="평가 단계 생략")
    args = p.parse_args()

    if args.check_config:
        cmd_check_config()
        return
    if args.check_network:
        cmd_check_network()
        return
    if not args.category or not args.desc:
        p.error("--category 와 --desc 필수 (또는 --check-config / --check-network)")
    cmd_generate(args)


if __name__ == "__main__":
    main()
