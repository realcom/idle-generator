# Dokkaebi Survivor Quality Iterations

Target: Godot survivor mode, TangTang-style Haeil run.

Reference screenshot:
`harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`

## Iteration Log

1. Reconfirmed `build-godot-ui-runtime` contract and survivor battle HUD recipe as the active target.
2. Validated the current design blueprint and survivor recipe before new edits.
3. Shifted the generated action dock upward so secondary skill buttons no longer kiss the EXP bar.
4. Kept joystick absolute position stable while moving only the action cluster, preserving bottom-left muscle memory.
5. Reduced player runtime sprite height from oversized mockup scale toward the blueprint's 7-9 percent screen-height target.
6. Reduced common and elite enemy sprite heights to keep horde readability without crowding Haeil.
7. Replaced round EXP pickup dots with small diamond shards plus glow, improving separation from bullets/VFX.
8. Suppressed frequent basic attack and common kill text labels to reduce Korean text clutter during dense waves.
9. Added a subtle red threat ring around Haeil when nearby enemies enter pressure range.
10. Added a water-blue magnet aura around Haeil while pickup vacuum is active.
11. Added compact native labels to field items so bomb/magnet/potion/mine reads before pickup.
12. Reduced floating FX label size and added a dark shadow pass for readability.
13. Added `AUTO` status to the primary skill overlay so the main wave attack reads as automatic.
14. Lowered joystick opacity to avoid hiding enemies under the control zone.
15. Rebuilt the generated Godot HUD scene after layout edits and kept node count stable at 49.
16. Re-ran Godot main/script checks after the first patch and fixed parse/type issues immediately.
17. Re-ran survivor smoke after the first patch; combat still produced kills, enemies, EXP, and field items.
18. Re-captured the survivor screenshot and inspected the actual runtime frame for overlap.
19. Added debug snapshot fields for nearest threat distance, magnet remaining, and boss presence.
20. Extended the top combat vignette so enemies behind the top HUD do not visually fight the HUD panels.
21. Added pickup-to-Haeil pull lines while magnet mode is active for clearer vacuum feedback.
22. Added a runtime TTL ring to field items so item urgency reads without adding a new baked icon.
23. Added a boss presence ring and compact native boss label for the seeded elite in capture.
24. Rechecked the second patch scope against the blueprint rule that labels and timers stay runtime-native.
25. Inspected the level-up choice screenshot as part of the survivor flow rather than treating only the live HUD as in-scope.
26. Reduced level-up modal scrim opacity slightly so the active battle context remains visible behind choices.
27. Added a dark lacquer header band and gold divider to the level-up modal for clearer hierarchy.
28. Reworked skill cards with shadow, dark `NEW` headers, gold icon rims, and stronger native selection bars.
29. Reviewed section compare boards and lifted the third run-ledger row so `RUN DATA` no longer hugs the panel bottom.
