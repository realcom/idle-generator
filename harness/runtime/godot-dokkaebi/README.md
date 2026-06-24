# Dokkaebi Godot Prototype

Godot 4.6 prototype for the first `도깨비의 세계` mobile home and survivor combat slice.

This is intentionally a thin core-feel prototype before data/content integration:

- The app starts on a TangTang-style mobile outgame home.
- Haeil is the first playable hero.
- Movement is direct, attacks and skills are automatic.
- The current focus is the `탕탕특공대` style: flat top-down arena, dense swarms, EXP gems, and fast skill picks.
- A later `Zombie Waves` style can branch from the same mechanics with heavier hero/weapon progression and more staged pressure.
- Enemies spawn around the player in a readable top-down forest arena.
- Kills drop 영력 pickups.
- Collected 영력 levels the run and opens a 3-card skill choice.
- The first mechanic target is "요귀 정화", not generic survival.

## Run

```bash
godot --path harness/runtime/godot-dokkaebi
```

Keyboard controls:

- `Space` / `Enter`: start sortie from the home screen
- `WASD` / arrows: move
- `1`, `2`, `3`: choose a level-up card
- `Space`: accept the first card when a choice is open
- `R`: restart the run

## Verify

```bash
godot --headless --path harness/runtime/godot-dokkaebi --check-only --script res://scripts/main.gd
godot --headless --path harness/runtime/godot-dokkaebi --script res://scripts/tools/home_smoke.gd
godot --headless --path harness/runtime/godot-dokkaebi --script res://scripts/tools/smoke.gd
godot --path harness/runtime/godot-dokkaebi --script res://scripts/tools/capture_home.gd
godot --path harness/runtime/godot-dokkaebi --script res://scripts/tools/capture_ingame.gd
```

## Next Hooks

- Replace native home card/CTA/dock primitives with generated parchment and carved-wood 9-slice skins after outgame UX review.
- Replace primitive Haeil/enemy drawing with approved SD sprites.
- Move skill numbers into `harness/content/dokkaebi/skills`.
- Move wave timing into `harness/content/dokkaebi/maps`.
- Split HUD into reusable Godot Control scenes after the TangTang core is accepted.
- Add the second `Zombie Waves` variant as a separate scene or mode instead of blending both styles in one screen.
