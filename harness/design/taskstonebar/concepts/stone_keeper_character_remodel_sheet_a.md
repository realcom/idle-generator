# Stone Keeper Character Remodel Sheet A

Purpose: remodel the `돌키우기1` bottom battle character into a `돌키우기2` taskbar-combat hero.

Source references:
- Original character sprite sheet: `harness/assets/taskstonebar/source/taskstone/hero.png`
- Current UI target: `stone_raising_2_taskbar_ui_concept_b`

Design intent:
- Keep the original cute chibi adventurer silhouette and white cap/hood readability.
- Add stone-game identity: moss scarf, stone-chip shoulder guard, rock backpack, throwing glove, small hammer/sling, ruby catalyst charm.
- Keep tiny bottom-lane readability more important than costume detail.
- Match the selected UI palette: black outline, off-white cap, dark leather, antique gold, moss green, stone gray, ruby red.

Files:
- Source chroma-key sheet: `concepts/stone_keeper_character_remodel_sheet_a_source.png`
- Transparent extracted sheet: `../../assets/taskstonebar/generated/characters/stone_keeper_character_remodel_sheet_a.png`
- Bottom-strip placement mock: `concepts/stone_keeper_character_in_taskbar_mock_a.png`

Next production step:
- Recut into exact runtime frames, likely `10 x 48x48` or `10 x 64x64`, then replace the current `hero.png` reference in the runtime.
- The enlarged preview character on the right side of the source sheet is for art review only and should not be packed into the final runtime sprite sheet.
