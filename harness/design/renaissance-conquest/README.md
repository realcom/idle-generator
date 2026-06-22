# Renaissance Conquest

Working title for a Godot-first 2D turn-based conquest strategy game.

## Direction

- Setting: Renaissance Italy and the surrounding Mediterranean, not a fictional continent.
- Tone: modern anime isekai strategy/SRPG, closer to a readable game HUD than an old parchment sim.
- References: Romance of the Three Kingdoms 3-10 pacing plus Sengoku Rance-style AP pressure and officer events.
- Avoid: Japanese Sengoku setting, strict history simulation, full-parchment antique UI.

## Core Screens

- Campaign: Italy province/city map, top strategic resource HUD, left command rail, right selected-city inspector, bottom officer roster.
- Battle: 6 vs 6 officer unit battle with two columns by three lanes per side.
- Collection: officers are conquest rewards, domestic assets, story gates, and battle units.

## System Design

- `system-design-v0.md`: commander/city/battle/storylet system direction.
- `system-contracts-v0.yaml`: Godot-first data vocabulary and schema contract.
- `mvp-seed-v0.yaml`: first protagonist, faction, city, troop class, and S-grade officer seed set.
- `city-command-battle-v0.md`: first-playable city command and 6v6 battle loop.
- `city-command-battle-contracts-v0.yaml`: AP command, battle action, modifier, and aftermath contract.

## Godot Track

This concept is intentionally not forced into the idlez AFK-RPG JSON contract yet. The first playable surface lives in:

`harness/runtime/godot-renaissance-conquest/`

The initial Godot slice should prove:

1. A wide 16:9 grand-strategy campaign shell.
2. A tactical battle shell with the corrected 2 x 3 formation per side.
3. Officer collection/assignment UI visible from both screens.
4. Native Godot Control layout first, generated bitmap UI assets later.
