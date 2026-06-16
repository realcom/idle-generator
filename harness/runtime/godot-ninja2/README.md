# Ninja2 Godot Runtime

Godot 4.6 Standard prototype for replacing the Unity `idlez-client` path with a data-driven client.

Current slice:

- Loads `harness/build/ninja2/*.json` directly.
- Uses existing `harness/runtime/assets/ninja2` PNGs.
- Shows a home screen with resources, stage selection, and starter equipment slots.
- Starts a small deterministic survival battle loop with player/enemy movement, auto attack, rewards, HP, timer, and result overlay.

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
4. Convert home/building/equipment screens from the Phaser survivor runtime into Godot `Control` scenes.
