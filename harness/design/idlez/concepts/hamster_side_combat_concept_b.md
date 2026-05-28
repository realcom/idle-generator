# Hamster Side Combat Concept B

## Intent

`햄스터 키우기` GameScene 전투 화면 시안. 레퍼런스처럼 가로형 2D 사이드 전투 무대에서 햄스터가 왼쪽, 적이 오른쪽에 배치되고 자동 전투가 계속 진행되는 화면을 목표로 한다.

## Reference Takeaways

- Lower-half horizontal bridge/platform battle lane.
- Player character left, enemy target right.
- Compact top-center stage progress nodes ending in boss marker.
- Mission/goal headline near top center.
- Floating rounded mission reward card on right.
- Damage number, hit flash, coin/drop feedback around enemy.
- Simple, bright, readable garden background.

## Hamster Art Anchor

- Golden-yellow hamster with cream belly and muzzle.
- Tiny ears, blush, simple face, thick dark chocolate outline.
- Flat Spine-atlas-like 2D shapes with chunky toy-like silhouette.
- Optional mushroom-cap hood or leaf cape for the mushroom-growth theme.

## Unity Translation Notes

- Treat this as a `ModeBattleStageSkin`, not a full popup.
- Split into `BattleLane`, `ProgressNodes`, `MissionToast`, `DamageFeedback`, and `DropFeedback` prefab atoms.
- Keep the playable lane readable before adding upgrade panels or extra HUD.

## Source Image

![Hamster side combat concept B](hamster_side_combat_concept_b.png)
