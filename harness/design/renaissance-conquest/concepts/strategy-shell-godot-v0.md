# Strategy Shell Godot V0

## Intent

Create a Godot-native strategy shell for a Renaissance Italy isekai conquest game. The prototype must be functional enough to click between campaign and battle, inspect cities, and understand the battle formation without reading external notes.

## Campaign Surface

- Top HUD: YEAR, TURN, SEASON, AP, GOLD, GRAIN, TROOPS, PRESTIGE, FAITH, TECH, UNREST.
- Left command rail: War, Develop, Recruit, Officers, Diplomacy, Intrigue, Explore, Dungeon, Events, Decrees.
- Center: stylized Italy/Mediterranean map using actual geographic intent.
- Right inspector: selected city name, crest/faction, level, income, food, garrison, fortress, public order, faith, trade value, development slots, assigned officer, action buttons.
- Bottom roster: officer portraits, class, troop/HP, stamina, loyalty/bond, status.

## Battle Surface

- 6 vs 6 battle inspired by Sengoku Rance.
- Corrected formation:
  - Ally side: BACK column, FRONT column.
  - Enemy side: FRONT column, BACK column.
  - Vertical lanes: TOP, MID, BOTTOM.
- The board must remain readable; large cards should not cover unit lanes.
- Bottom skill dock: Strike, Guard, Volley, Rally, Scheme, Cannon.
- Prediction panel: damage, morale change, advantage change, counter risk, wall bonus, capture chance.

## Tone

Use crisp dark panels, faction color chips, luminous Renaissance jewel accents, and readable modern HUD density. Avoid full-screen parchment or antique simulation UI.
