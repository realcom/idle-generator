#!/usr/bin/env python3
"""
Run a Unity Editor smoke test through youngwoocho02/unity-cli.

Default flow:
1. compile a harness game for validation
2. copy compiled JSON bundles into Unity PatchResources
3. refresh Unity and compile scripts
4. enter play mode from LoginScene
5. bootstrap local PatchResources into GameScene
6. assert the requested map/mode loaded without Unity console errors

The Unity editor must already be open with the unity-cli connector installed.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import textwrap
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TOOLS_DIR = ROOT / "harness" / "tools"
UNITY_PROJECT = ROOT / "engine" / "client" / "Client"
PATCH_ROOT = UNITY_PROJECT / "Assets" / "PatchResources"
LOGIN_SCENE = "Assets/Scripts/Components/Scenes/LoginScene.unity"

BUILD_OUTPUTS = [
    "Units.json",
    "Items.json",
    "Skills.json",
    "Buffs.json",
    "Maps.json",
    "Strings.json",
    "Achievements.json",
    "Audios.json",
    "Triggers.json",
    "ResourceGlobals.json",
]

BOOTSTRAP_USINGS = "Commons,Commons.Resources,Commons.Types.Players"
STATE_USINGS = "Commons.Game,Commons.Types.Units"
UPGRADE_USINGS = "Commons.Types.Units"
GROWTH_DOCK_USINGS = "Commons.Types.Units,System.Reflection"

BOOTSTRAP_CODE = r"""
Utility.ResetMissingResources();
LazyLoad.UnloadAll();
Config.InitializeConfigFromGameConfig();
BadWordFilter.Init();

string json;
json = Utility.LoadResource<string>("ResourceGlobals.json", true);
Commons.Resources.Resources.ReloadJson(json);
json = Utility.LoadResource<string>("Triggers.json", true);
ResourceTrigger.ReloadJson(json);
json = Utility.LoadResource<string>("Strings.json", true);
ResourceString.ReloadJson(json);
json = Utility.LoadResource<string>("Achievements.json", true);
ResourceAchievement.ReloadJson(json);
json = Utility.LoadResource<string>("Buffs.json", true);
ResourceBuff.ReloadJson(json);
json = Utility.LoadResource<string>("Items.json", true);
ResourceItem.ReloadJson(json);
json = Utility.LoadResource<string>("Maps.json", true);
ResourceMap.ReloadJson(json);
json = Utility.LoadResource<string>("Skills.json", true);
ResourceSkill.ReloadJson(json);
json = Utility.LoadResource<string>("Units.json", true);
ResourceUnit.ReloadJson(json);
json = Utility.LoadResource<string>("Audios.json", true);
ResourceAudio.ReloadJson(json);

MyPlayer.Player = new PlayerMessage { Id = 1 };
MyPlayer.CacheLevel(1);
MyPlayer.CacheAvatar(new PlayerAvatar
{
    Character = new PlayerItemMessage
    {
        Id = 3,
        ItemDataId = ResourceItem.Global.DataId.DefaultCharacter,
        Count = 1,
        Level = 1,
    },
});

var homeMap = ResourceMap.Get(__EXPECTED_MAP_ID__);
if (homeMap == null)
    homeMap = ResourceMap.Get(ResourceMap.Global.DataId.TutorialMap);
if (homeMap == null)
    return "failed: no home map";

var gameBoard = MyPlayer.SetGameBoardLocal(homeMap.Id);
MyPlayer.Player.BoardId = gameBoard.Id;
SceneLoader.Get().LoadScene(Constants.GAME_SCENE, forced: true);
return $"loading GameScene map={homeMap.Id}:{homeMap.Name}";
"""

STATE_CODE = r"""
var gbm = GameBoardManager.Get();
var gb = gbm?.gameBoard;
var map = gb?.ResMap;
var unit = gb == null || MyPlayer.Player == null ? null : gb.GetUnitByPlayerId(MyPlayer.Player.Id);
var player = gb == null || MyPlayer.Player == null ? null : gb.GetPlayerById(MyPlayer.Player.Id);
Func<string, string> esc = value => (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"");
var scene = esc(SceneManager.GetActiveScene().path);
var mapText = esc(map == null ? "" : $"{map.Id}:{map.Name}");
var mode = esc(gbm?.modeManager?.GetType().Name ?? "");
return $"{{\"scene\":\"{scene}\",\"board\":{gb?.DataId ?? 0},\"map\":\"{mapText}\",\"mode\":\"{mode}\",\"player\":{MyPlayer.Player?.Id ?? 0},\"unit\":{unit?.DataId ?? 0},\"gold\":{player?.Gold ?? 0},\"attack\":{unit?.Attack ?? 0},\"baseAttack\":{player?.ItemStat[(int)UnitStatType.Attack] ?? 0},\"wave\":{(gb == null ? 0 : (int)gb.Variables.Get(BoardVariableId.Map.wave))}}}";
"""

UPGRADE_CODE = r"""
var gbm = GameBoardManager.Get();
var mode = gbm?.modeManager as ModeManagerMushroom;
var gb = gbm?.gameBoard;
var player = gb?.GetPlayerById(MyPlayer.Player.Id);
var unit = gb?.GetUnitByPlayerId(MyPlayer.Player.Id);
var method = typeof(ModeManagerMushroom).GetMethod("TryUpgrade", BindingFlags.Instance | BindingFlags.NonPublic);
method?.Invoke(mode, new object[] { "Attack" });
return $"gold={player?.Gold}|attack={unit?.Attack}|baseAttack={player?.ItemStat[(int)UnitStatType.Attack]}";
"""

GROWTH_DOCK_CODE = r"""
var gbm = GameBoardManager.Get();
var gb = gbm?.gameBoard;
var player = gb?.GetPlayerById(MyPlayer.Player.Id);
var unit = gb?.GetUnitByPlayerId(MyPlayer.Player.Id);
var presenter = UnityEngine.Object.FindFirstObjectByType<HamsterGrowthDockPresenter>();
var beforeItem = MyPlayer.GetItemByDataID(1001, checkCount:false, checkTimeValid:false, checkDeprecated:false);
var beforeLevel = beforeItem?.Level ?? 0;
var beforeGold = player?.Gold ?? 0;
var beforeHpStat = player != null && player.ItemStat.Count > (int)UnitStatType.Hp ? player.ItemStat[(int)UnitStatType.Hp] : 0f;
var beforeMaxHp = unit?.MaxHp ?? 0;
var method = typeof(HamsterGrowthDockPresenter).GetMethod("TryGrowCheapestAffordable", BindingFlags.Instance | BindingFlags.NonPublic);
method?.Invoke(presenter, null);
var afterItem = MyPlayer.GetItemByDataID(1001, checkCount:false, checkTimeValid:false, checkDeprecated:false);
var afterHpStat = player != null && player.ItemStat.Count > (int)UnitStatType.Hp ? player.ItemStat[(int)UnitStatType.Hp] : 0f;
var afterMaxHp = unit?.MaxHp ?? 0;
return $"{{\"presenter\":{(presenter != null ? "true" : "false")},\"goldBefore\":{beforeGold},\"goldAfter\":{player?.Gold ?? 0},\"hpItemLevelBefore\":{beforeLevel},\"hpItemLevelAfter\":{afterItem?.Level ?? 0},\"hpStatBefore\":{beforeHpStat},\"hpStatAfter\":{afterHpStat},\"maxHpBefore\":{beforeMaxHp},\"maxHpAfter\":{afterMaxHp}}}";
"""

GROWTH_DOCK_STATE_CODE = r"""
var gbm = GameBoardManager.Get();
var gb = gbm?.gameBoard;
var player = gb?.GetPlayerById(MyPlayer.Player.Id);
var unit = gb?.GetUnitByPlayerId(MyPlayer.Player.Id);
var item = MyPlayer.GetItemByDataID(1001, checkCount:false, checkTimeValid:false, checkDeprecated:false);
var hpStat = player != null && player.ItemStat.Count > (int)UnitStatType.Hp ? player.ItemStat[(int)UnitStatType.Hp] : 0f;
return $"{{\"gold\":{player?.Gold ?? 0},\"hpItemLevel\":{item?.Level ?? 0},\"hpStat\":{hpStat},\"maxHp\":{unit?.MaxHp ?? 0}}}";
"""


def parse_args() -> argparse.Namespace:
    default_cli = os.environ.get("UNITY_CLI_BIN") or os.environ.get("UNITY_CLI") or "/private/tmp/unity-cli"
    parser = argparse.ArgumentParser(description="Unity-cli smoke harness for local game slices.")
    parser.add_argument("game", nargs="?", default="mushroomer", help="Harness game key to compile/sync.")
    parser.add_argument("--unity-cli", default=default_cli, help="Path to unity-cli binary.")
    parser.add_argument("--project", default=str(UNITY_PROJECT), help="Unity project path.")
    parser.add_argument("--expected-map", type=int, default=500101, help="Expected local board dataId.")
    parser.add_argument("--expected-mode", default="ModeManagerMushroom", help="Expected mode manager type.")
    parser.add_argument("--settle-seconds", type=float, default=6.0, help="Wait after GameScene load.")
    parser.add_argument("--skip-content-compile", action="store_true", help="Skip harness content compile.")
    parser.add_argument("--skip-json-sync", action="store_true", help="Do not copy compiled JSON into PatchResources.")
    parser.add_argument("--sync-patchresources", action="store_true", help="Copy compiled build and seed assets into PatchResources before smoke.")
    parser.add_argument("--skip-build-sync", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--skip-unity-compile", action="store_true", help="Skip Unity refresh --compile.")
    parser.add_argument("--upgrade-smoke", action="store_true", help="Invoke Mushroomer attack upgrade once.")
    parser.add_argument("--growth-dock-smoke", action="store_true", help="Invoke HamsterGrowthDock growth once and validate Stat item state.")
    parser.add_argument("--keep-playing", action="store_true", help="Leave Unity in play mode after the smoke.")
    return parser.parse_args()


def run(cmd: list[str], *, input_text: str | None = None, timeout: int = 120) -> str:
    proc = subprocess.run(
        cmd,
        input=input_text,
        text=True,
        capture_output=True,
        timeout=timeout,
        cwd=ROOT,
    )
    output = (proc.stdout or "") + (proc.stderr or "")
    if proc.returncode != 0:
        raise RuntimeError(f"command failed ({proc.returncode}): {' '.join(cmd)}\n{output}")
    return output.strip()


def run_cli(args: list[str], *, input_text: str | None = None, timeout_ms: int = 30000) -> str:
    cli = Path(CLI_CONTEXT["unity_cli"])
    project = CLI_CONTEXT["project"]
    return run(
        [str(cli), "--timeout", str(timeout_ms), "--project", str(project), *args],
        input_text=input_text,
        timeout=max(30, timeout_ms // 1000 + 10),
    )


def compile_content(game: str) -> None:
    print(run([sys.executable, str(TOOLS_DIR / "idlez_compile.py"), game], timeout=60))


def sync_build_json(game: str, patch_root: Path) -> None:
    build_dir = ROOT / "harness" / "build" / game
    if not build_dir.exists():
        raise FileNotFoundError(build_dir)

    copied = 0
    skipped = 0
    for name in BUILD_OUTPUTS:
        src = build_dir / name
        dst = patch_root / name
        if not src.exists():
            raise FileNotFoundError(src)
        dst.parent.mkdir(parents=True, exist_ok=True)
        if dst.exists() and src.read_bytes() == dst.read_bytes():
            skipped += 1
            continue
        shutil.copyfile(src, dst)
        copied += 1

    print(f"synced JSON bundles to PatchResources: copied={copied}, unchanged={skipped}")


def sync_patchresources(game: str) -> None:
    print(run([sys.executable, str(TOOLS_DIR / "sync_patchresources_seed.py"), game], timeout=120))


def unity_exec(code: str, *, usings: str | None = None, timeout_ms: int = 30000) -> str:
    args = ["exec"]
    if usings:
        args.extend(["--usings", usings])
    return run_cli(args, input_text=textwrap.dedent(code).strip() + "\n", timeout_ms=timeout_ms)


def read_console() -> list[str]:
    raw = run_cli(["console", "--type", "error,warning", "--stacktrace", "user", "--lines", "120"])
    return json.loads(raw or "[]")


def parse_state(raw: str) -> dict[str, object]:
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        # Fallback for old connector builds that return raw C# strings.
        return {"raw": raw}


def main() -> int:
    args = parse_args()
    CLI_CONTEXT["unity_cli"] = args.unity_cli
    CLI_CONTEXT["project"] = args.project

    if not Path(args.unity_cli).exists():
        print(f"unity-cli not found: {args.unity_cli}", file=sys.stderr)
        return 2

    if not args.skip_build_sync and not args.skip_content_compile:
        compile_content(args.game)
    if not args.skip_build_sync and not args.skip_json_sync:
        sync_build_json(args.game, PATCH_ROOT)
    if not args.skip_build_sync and args.sync_patchresources:
        sync_patchresources(args.game)

    print(run_cli(["status"], timeout_ms=20000))
    if not args.skip_unity_compile:
        print(run_cli(["editor", "refresh", "--compile"], timeout_ms=120000))

    try:
        run_cli(["editor", "stop"], timeout_ms=30000)
        print(unity_exec(f'EditorSceneManager.OpenScene("{LOGIN_SCENE}"); return EditorSceneManager.GetActiveScene().path;'))
        print(run_cli(["editor", "play", "--wait"], timeout_ms=120000))
        time.sleep(0.5)
        run_cli(["console", "--clear"], timeout_ms=30000)
        bootstrap_code = BOOTSTRAP_CODE.replace("__EXPECTED_MAP_ID__", str(args.expected_map))
        print(unity_exec(bootstrap_code, usings=BOOTSTRAP_USINGS, timeout_ms=60000))
        time.sleep(args.settle_seconds)

        state = parse_state(unity_exec(STATE_CODE, usings=STATE_USINGS, timeout_ms=30000))
        print(json.dumps(state, ensure_ascii=False, indent=2))

        if state.get("board") != args.expected_map:
            raise RuntimeError(f"expected board {args.expected_map}, got {state.get('board')}")
        if state.get("mode") != args.expected_mode:
            raise RuntimeError(f"expected mode {args.expected_mode}, got {state.get('mode')}")

        if args.upgrade_smoke:
            print(unity_exec(UPGRADE_CODE, usings=UPGRADE_USINGS, timeout_ms=30000))
            time.sleep(1.0)
            upgraded_state = parse_state(unity_exec(STATE_CODE, usings=STATE_USINGS, timeout_ms=30000))
            print(json.dumps(upgraded_state, ensure_ascii=False, indent=2))
            if float(upgraded_state.get("gold", 0)) >= float(state.get("gold", 0)):
                raise RuntimeError("upgrade smoke did not spend gold")
            if float(upgraded_state.get("attack", 0)) <= float(state.get("attack", 0)):
                raise RuntimeError("upgrade smoke did not increase attack")

        if args.growth_dock_smoke:
            growth_state = parse_state(unity_exec(GROWTH_DOCK_CODE, usings=GROWTH_DOCK_USINGS, timeout_ms=30000))
            print(json.dumps(growth_state, ensure_ascii=False, indent=2))
            time.sleep(1.0)
            growth_after_tick = parse_state(unity_exec(GROWTH_DOCK_STATE_CODE, usings=GROWTH_DOCK_USINGS, timeout_ms=30000))
            print(json.dumps(growth_after_tick, ensure_ascii=False, indent=2))
            if not growth_state.get("presenter"):
                raise RuntimeError("growth dock presenter not found")
            if float(growth_state.get("goldAfter", 0)) >= float(growth_state.get("goldBefore", 0)):
                raise RuntimeError("growth dock smoke did not spend board gold")
            if int(growth_state.get("hpItemLevelAfter", 0)) <= int(growth_state.get("hpItemLevelBefore", 0)):
                raise RuntimeError("growth dock smoke did not level Stat item 1001")
            if float(growth_state.get("hpStatAfter", 0)) <= float(growth_state.get("hpStatBefore", 0)):
                raise RuntimeError("growth dock smoke did not update PlayerItemStat Hp")
            if float(growth_after_tick.get("maxHp", 0)) <= float(growth_state.get("maxHpBefore", 0)):
                raise RuntimeError("growth dock smoke did not update runtime unit MaxHp")

        console_entries = read_console()
        if console_entries:
            raise RuntimeError("Unity console has errors/warnings:\n" + "\n".join(console_entries))

        print("unity-cli smoke PASS")
        return 0
    finally:
        if not args.keep_playing:
            try:
                print(run_cli(["editor", "stop"], timeout_ms=30000))
            except Exception as exc:
                print(f"warning: failed to stop play mode: {exc}", file=sys.stderr)


CLI_CONTEXT = {
    "unity_cli": "/private/tmp/unity-cli",
    "project": str(UNITY_PROJECT),
}


if __name__ == "__main__":
    raise SystemExit(main())
