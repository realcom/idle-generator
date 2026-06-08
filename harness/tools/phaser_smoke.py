#!/usr/bin/env python3
"""Compile, serve, and smoke-test the Phaser runtime harness."""

from __future__ import annotations

import argparse
import base64
import errno
import json
import os
import shutil
import socket
import struct
import subprocess
import sys
import tempfile
import threading
import time
import urllib.error
import urllib.request
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_RUNTIME = "harness/runtime/idlez-phaser.html"
DEFAULT_BROWSER_TIMEOUT = 90.0
DEFAULT_WINDOW_SIZE = "500x920"


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, format: str, *args: object) -> None:
        return


class DevToolsClient:
    """Tiny Chrome DevTools Protocol client for local, unencrypted CDP sockets."""

    def __init__(self, websocket_url: str, timeout: float) -> None:
        self.websocket_url = websocket_url
        self.timeout = timeout
        self.sock: socket.socket | None = None
        self.next_id = 0
        self.errors: list[str] = []
        self.requests: dict[str, str] = {}

    def __enter__(self) -> "DevToolsClient":
        self.connect()
        return self

    def __exit__(self, *_exc: object) -> None:
        self.close()

    def connect(self) -> None:
        parsed = urlparse(self.websocket_url)
        if parsed.scheme != "ws":
            raise ValueError(f"Only ws:// CDP URLs are supported: {self.websocket_url}")

        port = parsed.port or 80
        path = parsed.path
        if parsed.query:
            path = f"{path}?{parsed.query}"

        sock = socket.create_connection((parsed.hostname or "127.0.0.1", port), self.timeout)
        sock.settimeout(self.timeout)
        key = base64.b64encode(os.urandom(16)).decode("ascii")
        request = (
            f"GET {path} HTTP/1.1\r\n"
            f"Host: {parsed.hostname}:{port}\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {key}\r\n"
            "Sec-WebSocket-Version: 13\r\n"
            "\r\n"
        )
        sock.sendall(request.encode("ascii"))
        response = self._recv_http_response(sock)
        if b" 101 " not in response.split(b"\r\n", 1)[0]:
            raise RuntimeError(f"CDP websocket upgrade failed: {response[:200]!r}")
        self.sock = sock

    def close(self) -> None:
        if not self.sock:
            return
        try:
            self._send_frame(b"", opcode=0x8)
        except OSError:
            pass
        try:
            self.sock.close()
        finally:
            self.sock = None

    def send(self, method: str, params: dict[str, object] | None = None, timeout: float | None = None) -> dict[str, object]:
        if not self.sock:
            raise RuntimeError("CDP client is not connected")
        self.next_id += 1
        message_id = self.next_id
        payload = {"id": message_id, "method": method}
        if params is not None:
            payload["params"] = params
        self._send_text(json.dumps(payload, separators=(",", ":")))

        deadline = time.monotonic() + (timeout or self.timeout)
        while time.monotonic() < deadline:
            self.sock.settimeout(max(0.1, deadline - time.monotonic()))
            message = json.loads(self._recv_text())
            if message.get("id") == message_id:
                if "error" in message:
                    raise RuntimeError(f"CDP {method} failed: {message['error']}")
                return message.get("result", {})
            self._record_event(message)
        raise TimeoutError(f"Timed out waiting for CDP response: {method}")

    def _record_event(self, message: dict[str, object]) -> None:
        method = message.get("method")
        params = message.get("params") or {}
        if not isinstance(params, dict):
            return

        if method == "Runtime.exceptionThrown":
            details = params.get("exceptionDetails") or {}
            if isinstance(details, dict):
                text = details.get("text") or details.get("exception", {})
                self.errors.append(f"exception: {self._remote_text(text)}")
            return

        if method == "Runtime.consoleAPICalled" and params.get("type") in {"error", "assert"}:
            args = params.get("args") or []
            if isinstance(args, list):
                self.errors.append("console: " + " ".join(self._remote_text(arg) for arg in args))
            return

        if method == "Log.entryAdded":
            entry = params.get("entry") or {}
            if isinstance(entry, dict) and entry.get("level") in {"error", "critical"}:
                url = entry.get("url") or ""
                if str(url).endswith("/favicon.ico"):
                    return
                self.errors.append(f"log: {entry.get('text') or entry}")
            return

        if method == "Network.requestWillBeSent":
            request_id = str(params.get("requestId") or "")
            request = params.get("request") or {}
            if request_id and isinstance(request, dict):
                self.requests[request_id] = str(request.get("url") or "")
            return

        if method == "Network.loadingFailed":
            if params.get("canceled"):
                return
            request_id = str(params.get("requestId") or "")
            url = self.requests.get(request_id, "")
            self.errors.append(f"network: {params.get('errorText')} {params.get('type')} {url}")
            return

        if method == "Network.responseReceived":
            response = params.get("response") or {}
            if not isinstance(response, dict):
                return
            status = int(response.get("status") or 0)
            url = str(response.get("url") or "")
            if status >= 400 and not url.endswith("/favicon.ico"):
                self.errors.append(f"http {status}: {url}")

    def _remote_text(self, value: object) -> str:
        if isinstance(value, dict):
            if "value" in value:
                return str(value["value"])
            if "description" in value:
                return str(value["description"])
            if "text" in value:
                return str(value["text"])
        return str(value)

    def _recv_http_response(self, sock: socket.socket) -> bytes:
        chunks: list[bytes] = []
        data = b""
        while b"\r\n\r\n" not in data:
            chunk = sock.recv(4096)
            if not chunk:
                break
            chunks.append(chunk)
            data = b"".join(chunks)
        return data

    def _send_text(self, text: str) -> None:
        self._send_frame(text.encode("utf-8"), opcode=0x1)

    def _send_frame(self, payload: bytes, opcode: int) -> None:
        if not self.sock:
            raise RuntimeError("CDP client is not connected")
        first = 0x80 | opcode
        length = len(payload)
        if length < 126:
            header = struct.pack("!BB", first, 0x80 | length)
        elif length < 65536:
            header = struct.pack("!BBH", first, 0x80 | 126, length)
        else:
            header = struct.pack("!BBQ", first, 0x80 | 127, length)
        mask = os.urandom(4)
        masked = bytes(byte ^ mask[index % 4] for index, byte in enumerate(payload))
        self.sock.sendall(header + mask + masked)

    def _recv_text(self) -> str:
        fragments: list[bytes] = []
        while True:
            fin, opcode, payload = self._recv_frame()
            if opcode == 0x8:
                raise EOFError("CDP websocket closed")
            if opcode == 0x9:
                self._send_frame(payload, opcode=0xA)
                continue
            if opcode in {0x1, 0x0}:
                fragments.append(payload)
                if fin:
                    return b"".join(fragments).decode("utf-8")

    def _recv_frame(self) -> tuple[bool, int, bytes]:
        if not self.sock:
            raise RuntimeError("CDP client is not connected")
        header = self._recv_exact(2)
        first, second = header[0], header[1]
        fin = bool(first & 0x80)
        opcode = first & 0x0F
        masked = bool(second & 0x80)
        length = second & 0x7F
        if length == 126:
            length = struct.unpack("!H", self._recv_exact(2))[0]
        elif length == 127:
            length = struct.unpack("!Q", self._recv_exact(8))[0]
        mask = self._recv_exact(4) if masked else b""
        payload = self._recv_exact(length) if length else b""
        if masked:
            payload = bytes(byte ^ mask[index % 4] for index, byte in enumerate(payload))
        return fin, opcode, payload

    def _recv_exact(self, length: int) -> bytes:
        if not self.sock:
            raise RuntimeError("CDP client is not connected")
        chunks: list[bytes] = []
        remaining = length
        while remaining:
            chunk = self.sock.recv(remaining)
            if not chunk:
                raise EOFError("CDP websocket ended unexpectedly")
            chunks.append(chunk)
            remaining -= len(chunk)
        return b"".join(chunks)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("game", nargs="?", default="mushroomer", help="Game id to compile and smoke-test.")
    parser.add_argument("--runtime", default=DEFAULT_RUNTIME, help="Runtime HTML path relative to the repo root.")
    parser.add_argument("--host", default="127.0.0.1", help="Local static server host.")
    parser.add_argument("--port", type=int, default=8765, help="Preferred local static server port.")
    parser.add_argument("--strict-port", action="store_true", help="Fail instead of choosing the next free port.")
    parser.add_argument("--skip-compile", action="store_true", help="Use the existing harness/build bundle.")
    parser.add_argument("--python-bin", default=os.environ.get("PHASER_SMOKE_PYTHON"), help="Python executable used for idlez_compile.py.")
    parser.add_argument("--query", default=None, help="Optional query string appended to the runtime URL.")
    parser.add_argument("--serve-only", action="store_true", help="Compile, serve, print the URL, and block.")
    parser.add_argument("--no-browser", action="store_true", help="Only run compile and HTTP probes.")
    parser.add_argument("--expect", choices=["app", "ui", "survivor"], default="app", help="Browser readiness contract to verify.")
    parser.add_argument("--chrome-bin", default=os.environ.get("CHROME_BIN"), help="Chrome/Chromium executable.")
    parser.add_argument("--cdp-port", type=int, default=9333, help="Preferred Chrome DevTools port.")
    parser.add_argument("--headful", action="store_true", help="Launch a visible browser instead of headless Chrome.")
    parser.add_argument("--keep-browser", action="store_true", help="Leave Chrome running after the smoke test.")
    parser.add_argument("--timeout", type=float, default=DEFAULT_BROWSER_TIMEOUT, help="Browser smoke timeout in seconds.")
    parser.add_argument("--window-size", default=DEFAULT_WINDOW_SIZE, help="Browser window size, for example 500x920.")
    parser.add_argument("--screenshot", default=None, help="Optional PNG screenshot output path.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    runtime_path = (ROOT / args.runtime).resolve()
    if not runtime_path.exists():
        print(f"Runtime HTML not found: {runtime_path}", file=sys.stderr)
        return 2

    if not args.skip_compile:
        run_compile(args.game, args.python_bin)

    port = choose_port(args.host, args.port, args.strict_port)
    server = start_server(args.host, port)
    runtime_url = append_runtime_query(f"http://{args.host}:{port}/{args.runtime}", args)
    try:
        print(f"Serving Phaser harness: {runtime_url}")
        run_http_probes(args.game, runtime_url, args.host, port)

        if args.serve_only:
            print("Press Ctrl-C to stop.")
            wait_forever()
            return 0

        if args.no_browser:
            print("Browser smoke skipped (--no-browser).")
            return 0

        result = run_browser_smoke(args, runtime_url)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0 if result.get("ok") else 1
    finally:
        server.shutdown()
        server.server_close()


def run_compile(game: str, python_bin: str | None = None) -> None:
    cmd = [find_compile_python(python_bin), str(ROOT / "harness" / "tools" / "idlez_compile.py"), game]
    print("+", " ".join(cmd), flush=True)
    subprocess.run(cmd, cwd=ROOT, check=True)


def find_compile_python(explicit: str | None = None) -> str:
    candidates = [
        explicit,
        os.environ.get("PHASER_SMOKE_PYTHON"),
        sys.executable,
        shutil.which("python3"),
        str(Path.home() / "opt" / "anaconda3" / "bin" / "python3"),
    ]
    seen: set[str] = set()
    fallback = sys.executable
    for candidate in candidates:
        if not candidate or candidate in seen:
            continue
        seen.add(candidate)
        path = Path(candidate)
        if not path.exists() and not shutil.which(candidate):
            continue
        probe = subprocess.run(
            [candidate, "-c", "import yaml"],
            cwd=ROOT,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if probe.returncode == 0:
            return candidate
    return fallback


def choose_port(host: str, preferred: int, strict: bool) -> int:
    port = preferred
    while port < preferred + 100:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as probe:
            probe.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                probe.bind((host, port))
                return port
            except OSError as error:
                if error.errno in {errno.EACCES, errno.EPERM}:
                    raise PermissionError(
                        f"Cannot bind local port {host}:{port}. "
                        "This environment may require running the smoke harness outside the sandbox."
                    ) from error
                if strict:
                    raise
                port += 1
    raise RuntimeError(f"No available port found starting at {preferred}")


def start_server(host: str, port: int) -> ThreadingHTTPServer:
    handler = partial(QuietHandler, directory=str(ROOT))
    server = ThreadingHTTPServer((host, port), handler)
    thread = threading.Thread(target=server.serve_forever, name="phaser-smoke-http", daemon=True)
    thread.start()
    return server


def run_http_probes(game: str, runtime_url: str, host: str, port: int) -> None:
    probes = [
        runtime_url,
        f"http://{host}:{port}/harness/build/{game}/Units.json",
        f"http://{host}:{port}/harness/build/{game}/Items.json",
        f"http://{host}:{port}/harness/runtime/src/idlez-phaser/app.js",
        f"http://{host}:{port}/harness/runtime/vendor/spine-webgl.min.js",
    ]
    for url in probes:
        with urllib.request.urlopen(url, timeout=5) as response:
            if response.status >= 400:
                raise RuntimeError(f"HTTP probe failed: {response.status} {url}")
            response.read()
        print(f"OK {url}")


def wait_forever() -> None:
    try:
        while True:
            time.sleep(3600)
    except KeyboardInterrupt:
        print("\nStopped.")


def append_runtime_query(runtime_url: str, args: argparse.Namespace) -> str:
    query = args.query
    if query is None and args.expect == "survivor":
        query = f"game={args.game}&mode=battle"
    if not query:
        return runtime_url
    query = str(query).strip()
    if not query:
        return runtime_url
    if query.startswith("?"):
        return f"{runtime_url}{query}"
    if query.startswith("&"):
        return f"{runtime_url}?{query[1:]}"
    return f"{runtime_url}?{query}"


def run_browser_smoke(args: argparse.Namespace, runtime_url: str) -> dict[str, object]:
    chrome = find_chrome(args.chrome_bin)
    cdp_port = choose_port("127.0.0.1", args.cdp_port, strict=False)
    profile_dir = Path(tempfile.mkdtemp(prefix="idlez-phaser-chrome.", dir=temp_dir()))
    screenshot = Path(args.screenshot).resolve() if args.screenshot else None
    width, height = parse_window_size(args.window_size)

    cmd = [
        chrome,
        f"--remote-debugging-port={cdp_port}",
        f"--user-data-dir={profile_dir}",
        "--no-first-run",
        "--no-default-browser-check",
        f"--window-size={width},{height}",
    ]
    if not args.headful:
        cmd.extend([
            "--headless=new",
            "--use-gl=angle",
            "--use-angle=swiftshader",
            "--enable-unsafe-swiftshader",
            "--ignore-gpu-blocklist",
        ])
    cmd.append("about:blank")

    print("+", " ".join(cmd), flush=True)
    chrome_log = profile_dir / "chrome.log"
    log_handle = chrome_log.open("wb")
    process = subprocess.Popen(cmd, stdout=log_handle, stderr=subprocess.STDOUT)
    try:
        try:
            page_ws = wait_for_page_websocket(cdp_port, args.timeout, process, chrome_log)
        finally:
            log_handle.flush()
        with DevToolsClient(page_ws, timeout=args.timeout) as client:
            client.send("Runtime.enable")
            client.send("Log.enable")
            client.send("Network.enable")
            client.send("Page.enable")
            client.send("Page.navigate", {"url": runtime_url})
            if args.expect == "ui":
                value = evaluate_ui_ready(client, args.timeout)
            elif args.expect == "survivor":
                value = evaluate_survivor_ready(client, args.timeout)
            else:
                value = evaluate_runtime_ready(client, args.timeout)
            if screenshot:
                capture = client.send("Page.captureScreenshot", {"format": "png", "captureBeyondViewport": False}, timeout=10)
                screenshot.parent.mkdir(parents=True, exist_ok=True)
                screenshot.write_bytes(base64.b64decode(str(capture["data"])))
                value["screenshot"] = str(screenshot)

            errors = unique_errors(client.errors)
            if args.expect == "ui":
                ok = bool(value.get("ok")) and value.get("uiHarnessReady") is True and not errors
            elif args.expect == "survivor":
                ok = bool(value.get("ok")) and value.get("survivorReady") is True and not errors
            else:
                ok = (
                    bool(value.get("ok"))
                    and value.get("finalContextReady") is True
                    and value.get("tickAdvanced") is True
                    and not errors
                )
            value["ok"] = ok
            value["errors"] = errors
            value["url"] = runtime_url
            value["cdpPort"] = cdp_port
            return value
    finally:
        log_handle.close()
        if args.keep_browser:
            print(f"Kept Chrome profile: {profile_dir}")
        else:
            terminate_process(process)
            shutil.rmtree(profile_dir, ignore_errors=True)


def evaluate_runtime_ready(client: DevToolsClient, timeout: float) -> dict[str, object]:
    timeout_ms = int(timeout * 1000)
    expression = f"""
(async () => {{
  const deadline = Date.now() + {timeout_ms};
  const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
  const getFinalContext = () => globalThis.__idlezPhaser || globalThis.__mushroomerPhaser || null;
  const getProvisionalContext = () => globalThis.__IDLEZ_PHASER_CONTEXT__ || globalThis.__MUSHROOMER_PHASER_CONTEXT__ || null;
  const isBootError = () => document.getElementById('bootStatus')?.classList.contains('is-error') || false;
  while (!getFinalContext() && !isBootError() && Date.now() < deadline) {{
    await sleep(100);
  }}
  const finalCtx = getFinalContext();
  const provisionalCtx = getProvisionalContext();
  const ctx = finalCtx || provisionalCtx;
  const status = document.getElementById('bootStatus')?.textContent || null;
  if (!ctx) {{
    return {{
      ok: false,
      reason: 'Phaser context missing',
      status,
      title: document.title,
      canvasCount: document.querySelectorAll('canvas').length
    }};
  }}
  const before = ctx.board?.tick ?? null;
  await sleep(650);
  const after = ctx.board?.tick ?? null;
  const stageCanvas = document.querySelector('#gameStage canvas');
  const spineCanvas = document.getElementById('spineCanvas');
  const stageRect = stageCanvas?.getBoundingClientRect?.();
  return {{
    ok: Boolean(ctx.store && ctx.board && stageCanvas && spineCanvas),
    finalContextReady: Boolean(finalCtx),
    provisionalContextReady: Boolean(provisionalCtx),
    gameId: ctx.gameId || null,
    status,
    title: document.title,
    tickBefore: before,
    tickAfter: after,
    tickAdvanced: typeof before === 'number' && typeof after === 'number' ? after > before : null,
    mapId: ctx.board?.map?.id ?? null,
    gameEnded: ctx.board?.gameEnded ?? null,
    canvasCount: document.querySelectorAll('canvas').length,
    stageWidth: stageRect?.width ?? null,
    stageHeight: stageRect?.height ?? null,
    units: ctx.board?.units?.length ?? null,
    enemies: ctx.board?.enemies?.length ?? null
  }};
}})()
"""
    result = client.send(
        "Runtime.evaluate",
        {"expression": expression, "awaitPromise": True, "returnByValue": True},
        timeout=timeout + 5,
    )
    if "exceptionDetails" in result:
        return {"ok": False, "reason": result["exceptionDetails"]}
    remote = result.get("result") or {}
    if isinstance(remote, dict) and isinstance(remote.get("value"), dict):
        return remote["value"]
    return {"ok": False, "reason": f"Unexpected Runtime.evaluate result: {result}"}


def evaluate_survivor_ready(client: DevToolsClient, timeout: float) -> dict[str, object]:
    timeout_ms = int(timeout * 1000)
    expression = f"""
(async () => {{
  const deadline = Date.now() + {timeout_ms};
  const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
  const params = new URL(location.href).searchParams;
  const requestedMode = String(params.get('mode') || '').toLowerCase();
  const wantsBattle = ['battle', 'combat', 'expedition'].includes(requestedMode);
  const wantsSkillUseDemo = ['1', 'true', 'demo', 'use', 'cast', 'skills'].includes(String(params.get('skilluse') || params.get('skillUseDemo') || params.get('runSkill') || '').toLowerCase());
  const wantsLevelChoice = wantsSkillUseDemo || ['1', 'true', 'demo', 'choice'].includes(String(params.get('levelup') || params.get('levelChoiceDemo') || '').toLowerCase());
  const wantsVfxDemo = ['1', 'true', 'demo', 'skills'].includes(String(params.get('vfx') || params.get('skillVfxDemo') || params.get('skillFxDemo') || '').toLowerCase());
  const wantsEncounterDemo = ['1', 'true', 'demo', 'encounters'].includes(String(params.get('encounter') || params.get('encounters') || '').toLowerCase());
  const loopMode = String(params.get('loop') || params.get('survivorLoop') || '').toLowerCase();
  const wantsBossClearLoop = ['clear', 'win', 'boss', 'bosskill', 'boss-clear', 'bossclear'].includes(loopMode);
  const wantsFullLoop = wantsBossClearLoop || ['1', 'true', 'full', 'result', 'end'].includes(loopMode);
  const isReady = () => document.documentElement.dataset.survivorReady === 'true';
  const isBootError = () => document.getElementById('bootStatus')?.classList.contains('is-error') || false;
  while (!isReady() && !isBootError() && Date.now() < deadline) {{
    await sleep(100);
  }}
  while (wantsBattle && document.documentElement.dataset.survivorBattleReady !== 'true' && Date.now() < deadline) {{
    await sleep(100);
  }}
  while (wantsLevelChoice && document.documentElement.dataset.survivorLevelChoiceOpen !== 'true' && Date.now() < deadline) {{
    await sleep(100);
  }}
  while (wantsSkillUseDemo && Number(document.documentElement.dataset.survivorRunSkillDamageCount || 0) < 1 && Date.now() < deadline) {{
    const app = globalThis.__IDLEZ_SURVIVOR__ || null;
    if (document.documentElement.dataset.survivorLevelChoiceOpen === 'true' && typeof app?.chooseLevelChoice === 'function') {{
      app.chooseLevelChoice(0);
      await sleep(600);
    }} else {{
      await sleep(120);
    }}
  }}
  while (wantsVfxDemo && document.documentElement.dataset.survivorSkillVfxDemo !== 'done' && Date.now() < deadline) {{
    await sleep(100);
  }}
  while (wantsEncounterDemo && document.documentElement.dataset.survivorEncounterDemo !== 'done' && Date.now() < deadline) {{
    const app = globalThis.__IDLEZ_SURVIVOR__ || null;
    if (document.documentElement.dataset.survivorLevelChoiceOpen === 'true' && typeof app?.chooseLevelChoice === 'function') {{
      app.chooseLevelChoice(0);
      await sleep(500);
    }} else {{
      await sleep(100);
    }}
  }}

  const applyBossClearFixture = () => {{
    if (!wantsBossClearLoop) return false;
    const app = globalThis.__IDLEZ_SURVIVOR__ || null;
    const board = globalThis.__IDLEZ_SURVIVOR_BOARD__ || null;
    const player = board?.playerUnit || null;
    if (player) {{
      player.baseMaxHp = Math.max(Number(player.baseMaxHp || 0), 50000);
      player.baseAttack = Math.max(Number(player.baseAttack || 0), 900);
      if (typeof player.refreshStatsFromBoard === 'function') player.refreshStatsFromBoard();
      player.maxHp = Math.max(Number(player.maxHp || 0), 50000);
      player.hp = Math.max(Number(player.hp || 0), Math.floor(player.maxHp * 0.88));
      player.attack = Math.max(Number(player.attack || 0), 900);
      player.alive = true;
      player.reviveAtTick = null;
    }}
    if (app?.runSkillLevels instanceof Map) {{
      for (const [skillDataId, level] of [[300102, 3], [300103, 2], [300115, 3]]) {{
        app.runSkillLevels.set(skillDataId, Math.max(Number(app.runSkillLevels.get(skillDataId) || 0), level));
        if (typeof app.setRunSkillCooldown === 'function') app.setRunSkillCooldown(skillDataId, 1);
      }}
      document.documentElement.dataset.survivorRunSkillCount = String(app.runSkillLevels.size);
    }}
    document.documentElement.dataset.survivorBossLoopFixture = 'true';
    return true;
  }};

  const chooseLoopLevelChoiceIndex = () => {{
    if (!wantsBossClearLoop) return 0;
    const choices = globalThis.__NINJA2_LEVEL_CHOICE_DEMO__?.choices || [];
    const priority = [300102, 300115, 300103];
    let bestIndex = 0;
    let bestScore = -Infinity;
    choices.forEach((choice, index) => {{
      const skillDataId = Number(choice?.skillDataId || 0);
      const priorityIndex = priority.indexOf(skillDataId);
      const priorityScore = priorityIndex === -1 ? 0 : 100 - priorityIndex * 12;
      const levelScore = Number(choice?.nextRunLevel || 0);
      const score = priorityScore + levelScore;
      if (score > bestScore) {{
        bestScore = score;
        bestIndex = index;
      }}
    }});
    return bestIndex;
  }};

  const tickBefore = Number(document.documentElement.dataset.survivorTick || 0);
  let survivorLoopAutoChoices = 0;
  if (wantsBossClearLoop) applyBossClearFixture();
  while (wantsFullLoop && document.documentElement.dataset.survivorGameEnded !== 'true' && Date.now() < deadline) {{
    const app = globalThis.__IDLEZ_SURVIVOR__ || null;
    if (wantsBossClearLoop) applyBossClearFixture();
    if (document.documentElement.dataset.survivorLevelChoiceOpen === 'true' && typeof app?.chooseLevelChoice === 'function') {{
      if (app.chooseLevelChoice(chooseLoopLevelChoiceIndex())) survivorLoopAutoChoices += 1;
      await sleep(500);
    }} else {{
      await sleep(250);
    }}
  }}

  if (wantsBattle && !wantsLevelChoice && !wantsVfxDemo && !wantsFullLoop) {{
    while (
      Number(document.documentElement.dataset.survivorTick || 0) <= tickBefore
      && document.documentElement.dataset.survivorGameEnded !== 'true'
      && Date.now() < deadline
    ) {{
      await sleep(100);
    }}
  }} else {{
    await sleep(350);
  }}

  const ds = document.documentElement.dataset;
  const app = globalThis.__IDLEZ_SURVIVOR__ || null;
  const board = globalThis.__IDLEZ_SURVIVOR_BOARD__ || null;
  const stageCanvas = document.querySelector('#gameStage canvas');
  const stageRect = stageCanvas?.getBoundingClientRect?.();
  const levelModal = document.getElementById('levelModal');
  const homeScreen = document.getElementById('homeScreen');
  const resultScreen = document.getElementById('resultScreen');
  const resultRewardRows = [...document.querySelectorAll('#resultRewards .reward-line')];
  const counterIconNodes = [...document.querySelectorAll('.counter-icon')];
  const counterIconBackgrounds = [
    ...counterIconNodes.map(node => getComputedStyle(node).backgroundImage),
    getComputedStyle(document.querySelector('.timer'), '::before').backgroundImage,
    getComputedStyle(document.querySelector('.stage-track b')).backgroundImage,
  ].filter(Boolean);
  const counterIconsReady = counterIconBackgrounds.filter(value => value.includes('/battle-counters/')).length >= 5;
  const encounterTextureKeys = ['encounterBomb', 'encounterMagnet', 'encounterPotion', 'encounterMine'];
  const encounterTextureUrls = encounterTextureKeys.map(key => {{
    const source = app?.textures?.get?.(key)?.source?.[0] || null;
    return source?.url || source?.image?.currentSrc || source?.image?.src || '';
  }});
  const encounterTextureReady = encounterTextureKeys.every(key => app?.textures?.exists?.(key));
  const encounterResourceUrls = performance.getEntriesByType('resource')
    .map(entry => entry.name || '')
    .filter(value => value.includes('/assets/ninja2/battle/encounters/') && value.includes('.png'));
  const encounterIconsReady = encounterTextureReady && encounterResourceUrls.length >= 4;
  const tickAfter = Number(ds.survivorTick || 0);
  const enemyCount = Number(ds.survivorEnemyCount || 0);
  const killCount = Number(ds.survivorKills || 0);
  const bossAliveCount = board
    ? (typeof board.GetUnitCount === 'function'
        ? Number(board.GetUnitCount({{ unitDataId: 110501 }}) || 0)
        : [...board.units.values()].filter(unit => unit.alive && Number(unit.dataId) === 110501).length)
    : null;
  const skillVfxCount = Number(ds.survivorSkillVfxCount || 0);
  const skillVfxDemoFired = Number(ds.survivorSkillVfxDemoFired || 0);
  const levelChoiceCount = Number(ds.survivorLevelChoiceCount || 0);
  const runSkillCount = Number(ds.survivorRunSkillCount || 0);
  const profileSkillIcons = [...document.querySelectorAll('#profileSkillList .profile-skill-icon')];
  const profileSkillLabels = profileSkillIcons.map(node => node.getAttribute('aria-label') || node.getAttribute('title') || '').filter(Boolean);
  const expectedProfileSkillMax = Math.max(1, Math.min(3, runSkillCount || 1));
  const skillCastFeedChips = [...document.querySelectorAll('#skillCastFeed .skill-cast-chip')];
  const homeOpen = homeScreen?.classList.contains('is-open') || false;
  const battleReady = ds.survivorBattleReady === 'true';
  const playerVisible = ds.survivorPlayerVisible === 'true';
  const levelChoiceOpen = ds.survivorLevelChoiceOpen === 'true';
  const vfxReady = ds.survivorSkillVfxReady === 'true';
  const vfxDemoDone = ds.survivorSkillVfxDemo === 'done';
  const generatedAssetMode = ['generated-vfx-demo', 'generated-levelup-demo'].includes(ds.survivorAssetMode || '');
  const encounterDemoDone = ds.survivorEncounterDemo === 'done';
  const survivorTriggers = ds.survivorTriggers || '';
  const encounterMapTriggerHostPresent = /MAP_ONUPDATE_NINJA2MAINWAVES(3|4|5|7|10)UPDATE/.test(survivorTriggers);
  const resultOpen = resultScreen?.classList.contains('is-open') || false;
  const resultWon = ds.survivorWinningTeam === '1';

  const checks = {{
    survivorReady: Boolean(app && board && ds.survivorReady === 'true'),
    canvasVisible: Boolean(stageCanvas && stageRect?.width > 0 && stageRect?.height > 0),
    homeOpen,
    battleReady,
    playerVisible,
    enemiesSpawned: !wantsBattle || wantsEncounterDemo || enemyCount > 0 || killCount > 0,
    tickAdvanced: !wantsBattle || wantsLevelChoice || wantsVfxDemo || wantsFullLoop || tickAfter > tickBefore,
    levelChoiceOpen: !wantsLevelChoice || wantsSkillUseDemo || (levelChoiceOpen && levelChoiceCount === 3 && levelModal?.classList.contains('is-open')),
    profileSkillLean: !wantsBattle || profileSkillIcons.length <= expectedProfileSkillMax,
    runSkillUsed: !wantsSkillUseDemo || (
      runSkillCount >= 1
      && Number(ds.survivorRunSkillSpawnCount || 0) >= 1
      && Number(ds.survivorRunSkillDamageCount || 0) >= 1
      && Number(ds.survivorRunSkillDamageTotal || 0) > 0
    ),
    runSkillFeedback: !wantsSkillUseDemo || (
      Number(ds.survivorRunSkillFeedbackCount || 0) >= 1
      && Boolean(ds.survivorRunSkillLastFeedbackName)
    ),
    counterIconsReady: !wantsBattle || counterIconsReady,
    encounterIconsReady: !wantsBattle || generatedAssetMode || encounterIconsReady,
    vfxDemoDone: !wantsVfxDemo || (vfxReady && skillVfxCount === 16 && vfxDemoDone && skillVfxDemoFired === 16),
    encounterDemoDone: !wantsEncounterDemo || (
      encounterMapTriggerHostPresent
      && encounterDemoDone
      && Number(ds.survivorEncounterTriggerSerial || 0) >= 4
      && Number(ds.survivorEncounterCollected || 0) >= 3
      && Number(ds.survivorEncounterMined || 0) >= 1
    ),
    resultReached: !wantsFullLoop || (ds.survivorGameEnded === 'true' && resultOpen && resultRewardRows.length > 0),
    resultWon: !wantsBossClearLoop || resultWon,
    bossDefeated: !wantsBossClearLoop || bossAliveCount === 0,
  }};
  const battleRequirementMet = wantsFullLoop
    ? checks.resultReached
    : (!wantsBattle || (checks.battleReady && checks.playerVisible && checks.enemiesSpawned && checks.tickAdvanced));
  const visualRequirementMet = checks.canvasVisible || (wantsFullLoop && checks.resultReached);
  const ok = checks.survivorReady
    && visualRequirementMet
    && battleRequirementMet
    && (wantsBattle || checks.homeOpen)
    && checks.levelChoiceOpen
    && checks.profileSkillLean
    && checks.runSkillUsed
    && checks.runSkillFeedback
    && checks.counterIconsReady
    && checks.encounterIconsReady
    && checks.vfxDemoDone
    && checks.encounterDemoDone
    && checks.resultReached
    && checks.resultWon
    && checks.bossDefeated;

  return {{
    ok,
    checks,
    title: document.title,
    href: location.href,
    bootStatus: document.getElementById('bootStatus')?.textContent || null,
    survivorReady: checks.survivorReady,
    survivorBootPhase: ds.survivorBootPhase || null,
    survivorMode: ds.survivorMode || null,
    survivorBattleReady: battleReady,
    survivorPlayerVisible: playerVisible,
    survivorTickBefore: tickBefore,
    survivorTickAfter: tickAfter,
    survivorEnemyCount: enemyCount,
    survivorBossAliveCount: bossAliveCount,
    survivorPickupCount: Number(ds.survivorPickupCount || 0),
    survivorKills: killCount,
    survivorStageProgress: ds.survivorStageProgress || null,
    survivorMapId: ds.survivorMapId || null,
    survivorTriggers,
    survivorGameEnded: ds.survivorGameEnded || null,
    survivorWinningTeam: ds.survivorWinningTeam || null,
    survivorResultWon: resultWon,
    survivorLoopAutoChoices,
    survivorLevelChoiceOpen: levelChoiceOpen,
    survivorLevelChoiceCount: levelChoiceCount,
    survivorLevelChoiceSource: ds.survivorLevelChoiceSource || null,
    survivorProfileSkillIconCount: profileSkillIcons.length,
    survivorProfileSkillLabels: profileSkillLabels,
    survivorRunSkillCount: runSkillCount,
    survivorRunSkillLastCast: ds.survivorRunSkillLastCast || null,
    survivorRunSkillLastCastSource: ds.survivorRunSkillLastCastSource || null,
    survivorRunSkillSpawnCount: Number(ds.survivorRunSkillSpawnCount || 0),
    survivorRunSkillLastSpawn: ds.survivorRunSkillLastSpawn || null,
    survivorRunSkillDamageCount: Number(ds.survivorRunSkillDamageCount || 0),
    survivorRunSkillDamageTotal: Number(ds.survivorRunSkillDamageTotal || 0),
    survivorRunSkillLastDamage: ds.survivorRunSkillLastDamage || null,
    survivorRunSkillFeedbackCount: Number(ds.survivorRunSkillFeedbackCount || 0),
    survivorRunSkillLastFeedback: ds.survivorRunSkillLastFeedback || null,
    survivorRunSkillLastFeedbackName: ds.survivorRunSkillLastFeedbackName || null,
    survivorSkillCastFeedCount: skillCastFeedChips.length,
    survivorSkillCastFeedLabels: skillCastFeedChips.map(node => node.textContent.replace(/\\s+/g, ' ').trim()),
    survivorRunSkillAutoCasts: Number(ds.survivorRunSkillAutoCasts || 0),
    survivorRunSkillLastAuto: ds.survivorRunSkillLastAuto || null,
    survivorCounterIconCount: counterIconNodes.length,
    survivorCounterIconsReady: counterIconsReady,
    survivorCounterIconBackgrounds: counterIconBackgrounds,
    survivorEncounterIconsReady: encounterIconsReady,
    survivorEncounterIconUrls: encounterTextureUrls,
    survivorEncounterIconResourceUrls: encounterResourceUrls,
    survivorSkillVfxReady: vfxReady,
    survivorSkillVfxCount: skillVfxCount,
    survivorSkillVfxDemo: ds.survivorSkillVfxDemo || null,
    survivorSkillVfxDemoFired: skillVfxDemoFired,
    survivorEncounterDemo: ds.survivorEncounterDemo || null,
    survivorEncounterActiveCount: Number(ds.survivorEncounterActiveCount || 0),
    survivorEncounterCollected: Number(ds.survivorEncounterCollected || 0),
    survivorEncounterMined: Number(ds.survivorEncounterMined || 0),
    survivorEncounterLast: ds.survivorEncounterLast || null,
    survivorEncounterTriggerSerial: Number(ds.survivorEncounterTriggerSerial || 0),
    survivorEncounterTriggerType: Number(ds.survivorEncounterTriggerType || 0),
    survivorEncounterDemoStep: Number(ds.survivorEncounterDemoStep || 0),
    survivorEncounterMapTriggerHostPresent: encounterMapTriggerHostPresent,
    survivorEncounterMineProgress: ds.survivorEncounterMineProgress || null,
    survivorEncounterBombHits: Number(ds.survivorEncounterBombHits || 0),
    survivorEncounterHeal: Number(ds.survivorEncounterHeal || 0),
    survivorMagnetActive: ds.survivorMagnetActive || null,
    survivorCompanionSkillCount: Number(ds.survivorCompanionSkillCount || 0),
    survivorCompanionReadyCount: Number(ds.survivorCompanionReadyCount || 0),
    homeNineslice: ds.homeNineslice || null,
    canvasCount: document.querySelectorAll('canvas').length,
    stageWidth: stageRect?.width ?? null,
    stageHeight: stageRect?.height ?? null,
    boardTick: board?.tick ?? null,
    boardUnitCount: board?.units?.size ?? null,
    boardEnemyCount: board ? [...board.units.values()].filter(unit => unit.alive && unit.team !== 1).length : null,
    resultOpen,
    resultTitle: document.getElementById('resultTitle')?.textContent || null,
    resultSummary: document.getElementById('resultSummary')?.textContent || null,
    resultRewardCount: resultRewardRows.length,
    resultRewards: resultRewardRows.map(row => row.textContent.replace(/\\s+/g, ' ').trim()),
  }};
}})()
"""
    result = client.send(
        "Runtime.evaluate",
        {"expression": expression, "awaitPromise": True, "returnByValue": True},
        timeout=timeout + 5,
    )
    if "exceptionDetails" in result:
        return {"ok": False, "reason": result["exceptionDetails"]}
    remote = result.get("result") or {}
    if isinstance(remote, dict) and isinstance(remote.get("value"), dict):
        return remote["value"]
    return {"ok": False, "reason": f"Unexpected Runtime.evaluate result: {result}"}


def evaluate_ui_ready(client: DevToolsClient, timeout: float) -> dict[str, object]:
    timeout_ms = int(timeout * 1000)
    expression = f"""
(async () => {{
  const deadline = Date.now() + {timeout_ms};
  const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
  const isReady = () => document.documentElement.dataset.uiHarnessReady === 'true';
  const isBootError = () => document.getElementById('previewStatus')?.classList.contains('is-error') || false;
  while (!isReady() && !isBootError() && Date.now() < deadline) {{
    await sleep(100);
  }}
  await sleep(350);
  const ctx = globalThis.__idlezPhaserUiHarness || null;
  const status = document.getElementById('previewStatus')?.textContent || null;
  const modalStage = document.getElementById('modalStage');
  const activeButton = document.querySelector('[data-modal-id].active');
  const canvas = modalStage?.querySelector('canvas');
  const rect = canvas?.getBoundingClientRect?.();
  return {{
    ok: Boolean(ctx && modalStage?.classList.contains('is-active') && canvas),
    uiHarnessReady: Boolean(ctx && isReady()),
    gameId: ctx?.gameId || null,
    status,
    activeModal: activeButton?.dataset?.modalId || null,
    modalStageActive: modalStage?.classList.contains('is-active') || false,
    modalButtons: document.querySelectorAll('[data-modal-id]').length,
    canvasCount: document.querySelectorAll('canvas').length,
    stageWidth: rect?.width ?? null,
    stageHeight: rect?.height ?? null,
    logRows: document.querySelectorAll('.log-row').length,
  }};
}})()
"""
    result = client.send(
        "Runtime.evaluate",
        {"expression": expression, "awaitPromise": True, "returnByValue": True},
        timeout=timeout + 5,
    )
    if "exceptionDetails" in result:
        return {"ok": False, "reason": result["exceptionDetails"]}
    remote = result.get("result") or {}
    if isinstance(remote, dict) and isinstance(remote.get("value"), dict):
        return remote["value"]
    return {"ok": False, "reason": f"Unexpected Runtime.evaluate result: {result}"}


def find_chrome(explicit: str | None) -> str:
    candidates = []
    if explicit:
        candidates.append(explicit)
    candidates.extend([
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        "/Applications/Chromium.app/Contents/MacOS/Chromium",
    ])
    candidates.extend(
        found for found in (
            shutil.which("google-chrome"),
            shutil.which("google-chrome-stable"),
            shutil.which("chromium"),
            shutil.which("chromium-browser"),
            shutil.which("chrome"),
        )
        if found
    )
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return candidate
    raise FileNotFoundError("Chrome/Chromium not found. Pass --chrome-bin or use --no-browser.")


def wait_for_page_websocket(cdp_port: int, timeout: float, process: subprocess.Popen[bytes], chrome_log: Path) -> str:
    deadline = time.monotonic() + timeout
    last_error: Exception | None = None
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise RuntimeError(
                f"Chrome exited before DevTools became ready (exit {process.returncode}). "
                f"Chrome log: {tail_file(chrome_log)}"
            )
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{cdp_port}/json", timeout=1) as response:
                pages = json.loads(response.read().decode("utf-8"))
            for page in pages:
                if page.get("type") == "page" and page.get("webSocketDebuggerUrl"):
                    return str(page["webSocketDebuggerUrl"])
        except (urllib.error.URLError, TimeoutError, OSError) as error:
            last_error = error
        time.sleep(0.1)
    raise TimeoutError(
        f"Chrome DevTools did not become ready on {cdp_port}: {last_error}. "
        f"Chrome log: {tail_file(chrome_log)}"
    )


def parse_window_size(value: str) -> tuple[int, int]:
    try:
        width, height = value.lower().split("x", 1)
        parsed = (int(width), int(height))
    except ValueError as error:
        raise argparse.ArgumentTypeError(f"Invalid --window-size: {value}") from error
    if parsed[0] <= 0 or parsed[1] <= 0:
        raise argparse.ArgumentTypeError(f"Invalid --window-size: {value}")
    return parsed


def unique_errors(errors: list[str]) -> list[str]:
    seen: set[str] = set()
    unique: list[str] = []
    for error in errors:
        compact = " ".join(str(error).split())
        if compact in seen:
            continue
        seen.add(compact)
        unique.append(compact)
    return unique


def terminate_process(process: subprocess.Popen[bytes]) -> None:
    if process.poll() is not None:
        return
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait(timeout=5)


def tail_file(path: Path, limit: int = 1600) -> str:
    try:
        data = path.read_bytes()
    except OSError:
        return "<unavailable>"
    if not data:
        return "<empty>"
    return data[-limit:].decode("utf-8", errors="replace").strip() or "<empty>"


def temp_dir() -> str:
    path = Path("/private/tmp")
    if path.exists() and os.access(path, os.W_OK):
        return str(path)
    return tempfile.gettempdir()


if __name__ == "__main__":
    raise SystemExit(main())
