# Stone Raising 2 Taskbar UI Concept B

Purpose: lock the `돌키우기2` direction closer to the Taskbar Hero-like desktop overlay feeling.

Reference:
- User-provided Taskbar Hero screenshot, used only as style/layout reference.
- Key reference language: three floating ornate pixel windows on the desktop, red title bars, black/gold frame ornaments, right portal window, center hero/inventory window, left status window, and a tiny bottom taskbar combat strip.

Required adaptation for `돌키우기2`:
- Replace hero-centric middle window with `작업석`: living stone, evolution slots, bag/merge grid, cube synthesis, 합성/가방 controls.
- Left `스테이터스`: stone growth stats, level/exp, attack speed, skill/rune ladder.
- Right `포탈`: parchment stage map, stone-seal nodes, chest/catalyst reward area.
- Bottom: taskbar-style auto battle lane with tiny hero throwing stones at rock monsters.

What this corrects:
- The previous cave-workshop concept was too much like a normal full-screen Steam RPG dashboard.
- This concept keeps the desktop-widget/game-running-on-taskbar fantasy as the primary identity.

Implementation notes:
- Do not use this as a flat background. Extract panel proportions, header style, grid density, bottom strip placement, and stone synthesis ownership.
- Use real runtime text for labels; generated text is visual reference only.
- Keep UI windows separate and draggable-looking.
- Background should remain mostly desktop-visible, not a full game scene.
