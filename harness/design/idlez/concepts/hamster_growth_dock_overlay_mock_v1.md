# Hamster Growth Dock Overlay Mock v1

## Intent

Unity uGUI prefab 분해 전에 구도만 먼저 확인하기 위한 `1080x1920` 투명 오버레이 mock.

## Composition Rules

- 중앙 combat arena는 투명하게 비워 실제 GameScene 전투가 보이게 둔다.
- Top HUD, stage pill, mission card, damage bubble, bottom growth dock만 mock 이미지에 포함한다.
- Bottom dock은 화면 하단 약 37%를 차지하며, 2x2 stat card + reward row + tab bar로 고정한다.

## Why This Exists

직접 uGUI prefab으로 디자인을 잡으면 Unity Play 중 prefab instance/cache와 Free Aspect 왜곡 때문에 검수가 느려진다. 이 mock은 디자인 승인 전용이며, 승인 후에만 atom 단위 uGUI prefab으로 분해한다.

## Unity Preview

- HTML source: `hamster_growth_dock_overlay_mock_v1.html`
- Transparent PNG output/reference: `hamster_growth_dock_overlay_mock_v1.png`
- Unity element prefab: `Assets/Resources/HarnessPreview/HamsterGrowthDock.prefab`
- Generated Unity skin sprites: `Assets/Resources/HarnessPreview/GeneratedSprites/`

## Implementation Notes

- Game view should be checked in portrait ratios: `1080x1920`, `720x1280`, `1080x2340`.
- Free Aspect is not a valid design approval viewport.
- The approved HTML/PNG mock is the visual source; the Unity preview prefab is now rebuilt as uGUI `Image`, `Button`, and `TextMeshProUGUI` elements.
