# Taskstonebar MVP Roadmap

## 1. Data Slice

- Profile: `harness/game-profiles/taskstonebar.profile.yaml`
- Content: one player, two monsters, one boss, one starter weapon, three materials, one dungeon.
- Compile target: `python3 harness/tools/idlez_compile.py taskstonebar`

## 2. Visual Slice

- Import local Task Stone PNGs under `harness/assets/taskstonebar/source/taskstone/`.
- Use `frame.png`, `inner.png`, `slot.png`, `bar_frame.png`, `bar_fill.png` as UI atoms.
- Use `hero.png` as the first temporary hero sprite sheet.
- Use `stone0/1/2.png`, `rock.png`, `coin.png`, `ruby.png` for item/combat feedback.

## 3. Runtime Slice

- First runtime target: Phaser/HTML transparent taskbar strip plus three compact panels.
- Reuse the local prototype layout ideas:
  - bottom combat strip
  - status panel
  - stone/merge panel
  - portal panel
- Keep game logic data-driven where possible so later content comes from `harness/build/taskstonebar/*.json`.

## 4. System Slice

- Add online-only chest/catalyst loop after the first combat strip is running.
- Add cube functions in order: alchemy, 9-to-1 synthesis, catalyst crafting.
- Keep offline reward to gold/EXP only.
