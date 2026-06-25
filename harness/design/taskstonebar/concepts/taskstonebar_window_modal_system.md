# Taskstonebar Window Modal System Reference

## Intent

User requested a Taskbar Hero-like modal/window system for `돌키우기2` in Godot.
The supplied reference image is a pixel `PORTAL` window with a red title bar,
black iron frame, parchment map body, tabs, difficulty selector, and square X
close button.

## Design Decision

Taskstonebar should use a desktop-style window manager, not a single blocking
mobile modal layer. Each gameplay surface is its own floating window:

- `StatusWindow`
- `HeroInventoryWindow`
- `PortalWindow`
- local child dialogs such as consume confirm, boss gate, and craft result

The X button must close only the window instance that owns the button. The
bottom taskbar combat strip and other open windows stay alive.

## Reference Cues To Preserve

- Black/brown pixel frame with hard corners.
- Burgundy title plate with gold native title text.
- Fixed crest and corner ornaments layered over the stretchable frame.
- Square X button at the title bar's top-right.
- Controls row below the title: selector, tabs, filter chips, or local buttons.
- Body is a separate framed well: dark well for stats/inventory, parchment well
  for portal maps and confirmations.
- Text, numbers, labels, stage nodes, counters, and cooldowns remain native
  runtime controls.

## Godot Target

Implement as `Control` nodes in `harness/runtime/godot-taskstonebar`, with
`NinePatchRect` for frame/body/tab/slot skins and native `Button` controls for
close actions. Use `window_id` as the close/focus payload.
