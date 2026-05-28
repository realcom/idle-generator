# Hamster Portrait Combat Growth Dock Concept D

## Intent

`햄스터 키우기` 세로 모바일 GameScene 시안. Generated image 1의 portrait composition을 기준으로, 전투가 계속 진행되는 중앙 영역과 모바일 idle RPG다운 하단 성장 도크를 결합한다.

## Composition Rule

- Must be portrait 9:16.
- Top: compact HUD, currencies, combat power, stage/wave progress, menu/auto buttons.
- Middle: ongoing combat arena with hamster hero, enemies, HP bars, damage numbers, hit VFX, drops, and mission card.
- Bottom: persistent growth dock occupying the lower third.

## Bottom Dock Rule

- Warm carved wood frame with parchment stat cards.
- Green upgrade buttons, gold coin accents, thick dark outlines.
- Four upgrade stats:
  - Attack
  - Health
  - Gold gain
  - Growth speed
- Large golden growth reward CTA.
- Small auto-enhance button.
- Bottom tab row for core mobile game navigation.

## Art Anchor

- Golden-yellow hamster, cream belly/muzzle, tiny ears, blush.
- Thick dark chocolate outline.
- Flat Spine-atlas-like 2D shapes.
- Mushroom/leaf accent is allowed, but the hero must stay recognizably hamster-first.

## Unity Translation Notes

- `GameSceneShell` owns top HUD and combat lane.
- `GrowthDockRoot` anchors to bottom safe area.
- `GrowthStatCard` should be a repeatable uGUI prefab atom.
- `GrowthRewardButton`, `AutoEnhanceButton`, and `BottomTabBar` are separate atoms.
- The combat arena must reserve enough vertical space above the dock for hit feedback.

## Source Image

![Hamster portrait combat growth dock concept D](hamster_portrait_combat_growth_dock_concept_d.png)
