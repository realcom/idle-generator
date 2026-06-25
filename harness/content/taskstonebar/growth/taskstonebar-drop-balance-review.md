# Taskstonebar Drop Balance Review

Reviewed after connecting monster kill rewards to the Godot `ProgressionState`.

## Sources

- Maps: `500101..500200` in `harness/content/taskstonebar/maps/_index.yaml`
- Units: `111011..111510` in `harness/content/taskstonebar/units/_index.yaml`
- Currency: `5` gold, `6` exp
- Materials: `200101` pebble fragment, `200102` moss ore, `200103` cube catalyst
- Stones: `200202..200211`, `StoneStage01..10`
- Equipment: `200301..200360`, grades `1..10`

## Runtime Drop Design

Godot combat reads killed monster units and resolves only their
`dropAddItemGroups`. Gold, EXP, materials, equipment, and stones are all baked
into the unit definition. There is no map reward policy or unit drop policy
side-channel for Taskstonebar combat.

- Gold: baked into unit min/max counts by representative chapter difficulty
- EXP: baked into unit counts by representative chapter difficulty
- Materials: direct unit drop groups, no level multiplier

Equipment and stones are direct weighted add-items in
`Unit.dropAddItemGroups`:

- Direct loot cap: `min(6, 1 + floor(representativeChapterStage / 20))`
- Grade/stage roll window: `cap`, `cap-1`, `cap-2`
- Weights: `1.0`, `0.45`, `0.2025`
- Equipment chance: normal 3%, elite 6%, mini boss 35%, chapter boss 100%
- Stone chance: normal 0.18%, elite 0.45%, mini boss 3.5%, chapter boss 12%

## Expected Drops

| Map stage | Kills | Direct cap | Gold | EXP | Equipment / clear | Cap equipment / clear | Stone / clear | Cap stone / clear |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 43 | 1 | 658 | 300 | 1.76 | 1.76 | 0.124 | 0.124 |
| 10 | 62 | 1 | 1,419 | 594 | 3.80 | 3.80 | 0.326 | 0.326 |
| 20 | 62 | 1 | 8,648 | 3,061 | 3.80 | 3.80 | 0.326 | 0.326 |
| 40 | 62 | 2 | 18,944 | 6,196 | 3.80 | 2.62 | 0.326 | 0.225 |
| 60 | 62 | 3 | 28,060 | 8,866 | 3.80 | 2.30 | 0.326 | 0.197 |
| 80 | 62 | 4 | 36,798 | 11,376 | 3.80 | 2.30 | 0.326 | 0.197 |
| 99 | 43 | 6 | 21,056 | 6,953 | 1.76 | 1.07 | 0.124 | 0.075 |
| 100 | 62 | 6 | 45,410 | 13,763 | 3.80 | 2.30 | 0.326 | 0.197 |

Map 100 Monte Carlo, 100,000 clears:

- Any stone: 28.6% clear chance
- Stage 6 stone: 18.2% clear chance, about one per 5.5 clears
- Any equipment: ~100% clear chance
- Grade 6 equipment: 93.2% clear chance

## Risk Notes

- Grade 6 equipment is intentionally common at map 100 because the closed set has six equipment slots and option rolls.
- Stage 6 stone is much rarer than equipment; direct drop is a long-tail reward, while lower stages and merge remain relevant.
- Stage 7-10 stones/equipment are not direct drops in this closed set. They should stay as merge, crafting, or future-extension goals.
