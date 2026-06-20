# Ninja2 Godot Runtime

Godot 4.6 Standard prototype for replacing the Unity `idlez-client` path with a data-driven client.

Current slice:

- Loads `harness/build/ninja2/*.json` directly.
- Uses existing `harness/runtime/assets/ninja2` PNGs.
- Shows a title/main screen with continue, quick sortie, new game, and data reload actions.
- Shows a Phaser survivor-inspired home screen with top resources, side actions, sanctuary hex board, selected building panel, sortie button, and bottom tabs.
- Supports a first interactive home loop: building finish/upgrade actions, resource spending, and tab-specific dock panels for equipment, exploration, missions, and shop.
- Provides a reusable modal layer with a base modal frame and the first concrete building detail modal.
- Extracts a wave plan from `Maps.json` + `Triggers.json` `AddUnit` statements.
- Starts a small deterministic survival battle loop with player/enemy movement, data-driven skills, rewards, HP, timer, wave HUD, and result overlay.

## Runtime Shape

```text
content_store.gd
  Reads generated JSON and indexes maps, units, items, skills, triggers.

sim/wave_planner.gd
  Reads map trigger names and extracts AddUnit waves from compiled triggers.

sim/run_state.gd
  Owns home resources, stage clears, recent runs, and user:// persistence.

home/housing_tech_store.gd
  Reads Phaser survivor housing-tech data for sanctuary buildings and UI art paths.

home/sanctuary_state.gd
  Holds the Godot-side sanctuary/home view state, hex tiles, resources, and building placements.

home/home_screen.gd
  Composes the Godot home shell and routes sortie, title, tab, and building-selection signals.

home/components/*.gd
  Own reusable home UI slices: top bar, side menu, sanctuary board, building panel, bottom tabs, and shared theme helpers.

home/components/modal_layer.gd
  Owns modal stacking, dim overlay, outside-click close, and ESC close for the home shell.

home/modals/*.gd
  Own reusable modal frames and concrete modal bodies such as building detail/upgrade.

battle_sim.gd
  Runs the current survival battle using ContentStore + WavePlanner + RunState.

main.gd
  Thin app controller for title/home/battle screen construction and render sync.
```

## Run

Install Godot 4.6.3 Standard:

```bash
brew install --cask godot
```

Open the project:

```bash
godot --path harness/runtime/godot-ninja2
```

If your binary is named `godot4`:

```bash
godot4 --path harness/runtime/godot-ninja2
```

## Verify

```bash
godot --headless --path harness/runtime/godot-ninja2 --check-only --script res://scripts/main.gd
godot --headless --path harness/runtime/godot-ninja2 --scene res://scenes/main.tscn --quit-after 8
godot --headless --path harness/runtime/godot-ninja2 --script res://scripts/tools/modal_smoke.gd
godot --headless --path harness/runtime/godot-ninja2 --script res://scripts/tools/home_smoke.gd
godot --headless --path harness/runtime/godot-ninja2 --script res://scripts/tools/smoke.gd
godot --path harness/runtime/godot-ninja2 --script res://scripts/tools/capture_home.gd
godot --path harness/runtime/godot-ninja2 --script res://scripts/tools/capture_building_modal.gd
```

## Data Contract

The Godot project intentionally lives under `harness/runtime/godot-ninja2` and reads outside its project root during development:

```text
res://../../build/ninja2       -> harness/build/ninja2
res://../assets/ninja2         -> harness/runtime/assets/ninja2
```

That keeps `harness/content` and `harness/build` as the source of truth. An exported mobile client should copy these bundles into the Godot export, load them from `user://`, or fetch them from a patch server.

## Next Porting Targets

1. Port the Phaser `ResourceStore` indexing behavior more completely.
2. Port the `TriggerVM` subset used by `ninja2_survival_main.behavior.yaml`.
3. Replace the placeholder battle sim with the shared board contract.
4. Convert title/home/building/equipment screens from the Phaser survivor runtime into Godot `Control` scenes.
