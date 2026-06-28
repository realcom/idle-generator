# Taskstonebar Godot Runtime

Godot-only combat runtime skeleton for `돌키우기2 / Taskstonebar`.
The current content set is a closed 100-map main chain generated from
`harness/tools/taskstonebar_generate_main_set.py`.

This project reads generated harness JSON directly:

```text
res://../../build/taskstonebar -> harness/build/taskstonebar
```

## Structure

```text
content_store.gd
  Loads Units/Items/Skills/Maps/Triggers JSON and provides small typed lookups.

combat/wave_planner.gd
  Extracts the current Taskstonebar wave plan from compiled map triggers.
  It reads map `initVariables` for enemy/boss level scaling. This is
  intentionally a subset, not a full trigger VM.

combat/basic_combat_sim.gd
  Owns the basic server-portable combat state machine:
  player stats, pending wave spawns, enemy movement, auto attack, damage,
  kill rewards, run result, and snapshot events.

visual/sprite_catalog.gd
  Loads Taskstone sprites directly from `assets/growstone2`.
  `harness/assets/growstone2` remains only as a legacy symlink.
  Player/projectile/resource sprites are fixed, while enemy sprites are loaded
  from each compiled unit's `sprite` field.

main.gd
  Thin Godot view/controller. It starts the sim, draws a taskbar battlefield,
  renders the sprite battlefield, and mirrors snapshot values into labels.
  `Farm` + `Continue` repeats the current map after clear; otherwise Continue
  follows `ClientNextMapDataId`. `Retry` restarts the current map.

tools/smoke.gd
  Headless smoke test for content loading, wave extraction, spawning, and kills.
```

## Verify

Compile content first:

```bash
/usr/bin/python3 harness/tools/idlez_compile.py taskstonebar
```

Then open or smoke the Godot project:

```bash
godot --path harness/runtime/godot-taskstonebar
godot --headless --path harness/runtime/godot-taskstonebar --script res://scripts/tools/smoke.gd
godot --path harness/runtime/godot-taskstonebar --script res://scripts/tools/capture_combat.gd
```

Marketable drops, Steam Inventory grants, cube results, and anti-abuse checks stay outside this local combat loop.
