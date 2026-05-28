# Hamster Side Combat Bottom Bar Concept C

## Intent

`햄스터 키우기` GameScene 전투 화면에 모바일 idle RPG다운 하단 성장 도크를 결합한 시안. 전투는 상단/중앙에서 계속 진행되고, 플레이어는 하단 도크에서 능력치를 반복 강화한다.

## Screen Composition

- Top/center: stage progress nodes, mission headline, compact utility buttons.
- Middle: side-view auto-battle lane with hamster hero left, enemies right, damage/drop feedback.
- Right: floating mission completion/reward card.
- Bottom: persistent growth dock occupying roughly the lower third.

## Bottom Dock Design

- Warm carved wood outer frame.
- Parchment upgrade cards with thick outlines.
- Four primary stat cards:
  - Attack
  - Health
  - Gold gain
  - Mushroom or growth speed
- Each card carries level, icon medallion, value, and green coin-cost button.
- Large golden center CTA for growth reward claim.
- Smaller green auto-enhance button to the right.
- Bottom tab row for growth, companion, equipment, pet, adventure, locked/guild.

## Unity Translation Notes

- Split the dock into `GrowthDockRoot`, `GrowthStatCard`, `GrowthRewardButton`, `AutoEnhanceButton`, and `BottomTabBar`.
- Treat stat cards as repeated uGUI atoms driven by data.
- Keep the battle lane above the dock so character silhouettes and hit feedback remain visible.
- Add safe-area padding only around the tab row and dock frame, not the battle lane.

## Source Image

![Hamster side combat bottom bar concept C](hamster_side_combat_bottom_bar_concept_c.png)
