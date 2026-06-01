# SFX Pack 30 Prompt Template

Create a compact Web Audio API SFX pack for a casual 2D idle RPG.

Requirements:

- Output one reusable `async function renderSfx(ctx, options = {})`.
- Select the sound by `options.preset`.
- Use only Web Audio API primitives: oscillators, noise buffers, filters, gain envelopes, saturation, compression.
- No external files, samples, libraries, or network.
- Every preset must be deterministic for the same `preset` and `seed`.
- Each sound should have a clear layer plan: attack, body, texture, and tail when appropriate.
- Sounds must be short and game-ready, not musical loops.
- Avoid harsh clipping. Aim for a practical mobile-game peak around 0.45-0.75.
- Style: stylized/cartoony mobile RPG, useful for idle-game UI, battle, loot, and magic feedback.

Preset set:

1. ui_click_soft
2. ui_click_confirm
3. ui_error_buzz
4. ui_reward_chime
5. coin_pickup
6. gem_pickup
7. level_up
8. quest_complete
9. sword_slash_light
10. sword_slash_heavy
11. arrow_shot
12. shield_block
13. hit_blunt
14. hit_critical
15. monster_pop
16. slime_squish
17. fireball_cast
18. fireball_impact
19. ice_shard_hit
20. lightning_zap
21. heal_cast
22. poison_tick
23. teleport_whoosh
24. buff_activate
25. debuff_curse
26. chest_open
27. item_drop
28. crafting_success
29. boss_roar_short
30. explosion_small
