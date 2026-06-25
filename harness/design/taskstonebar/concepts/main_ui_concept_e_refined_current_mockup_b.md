# Main UI Concept E-B - Refined Current Mockup Candidate

## Intent

현재까지 사용자가 확정한 구조를 기준으로 다시 생성한 후보 시안이다. 목표는 `돌 / 장비` 탭형 중앙 인벤토리, 보상 카드가 제거된 포탈 맵, 하단 인벤토리 독이 없는 전투 씬을 하나의 Steam-ready pixel UI 방향으로 묶는 것이다.

## Art Anchor

- Latest HTML preview: `harness/design/taskstonebar/qa/ui-feature-preview-desktop.png`
- Stone keeper sprite identity: white cap, brown outfit, moss scarf, stone backpack/shoulder rock, ruby charm.
- Color tokens: black iron, burgundy title, antique gold, parchment tan, moss green, stone gray, ruby/catalyst accents.

## Composition Rules

- 16:9 desktop overlay with visible green desktop and OS taskbar.
- Left `스테이터스`: mossy living stone portrait, stat rows, rune/mark progression.
- Center `돌지기`: character portrait, left/right equipment slots, `돌` active tab, `장비` inactive tab, stone slot grid, bottom icon-only dock.
- Right `포탈`: Normal selector, Act tabs, parchment map, curved route, current marker with green ring and red flag, boss node.
- Bottom combat scene: stone keeper throws rocks from left to right, enemies on right, HP bar, damage number, rare drop toast.
- No bottom inventory dock. No online/offline reward cards inside the portal.

## UI Direction

This is the strongest current candidate for the updated direction. It keeps the Taskbar Hero-like desktop overlay feeling while replacing hero RPG dominance with stone raising and taskbar combat identity.

## Implementation Notes

- Treat the generated image as concept art, not exact runtime layout.
- The generated center grid should fill the window body as a compact 8x4 inventory; runtime must follow `StoneInventoryPanel.visible_columns = 8` and `visible_rows = 4`.
- The bottom combat scene should become the visual anchor for taskbar mode.
- The portal map has useful parchment-route mood; keep it separate from reward/claim UI.
- The icon-only dock is preferred over text CTA buttons in the center window.

## Target Runtime Notes

- Runtime decomposition targets:
  - `WindowFrame`
  - `StoneEquipmentTabBar`
  - `StoneInventoryPanel`
  - `KeeperIconDock`
  - `ParchmentRouteMap`
  - `TaskbarCombatStrip`
  - `RareDropToast`
- Use generated art for proportion, atmosphere, and style; use HTML/YAML for exact slot count and state logic.

## Foundation Gaps / Questions

- No shared `button-system.yaml` yet.
- No shared `modal-system.yaml` yet.
- Need final icon contract for center dock and combat mini dock.
- Need typography contract for Korean pixel labels.

## Prompt Summary

Generated with built-in `image_gen` in `ui-mockup` mode using the latest HTML screenshot as strict layout reference and the stone keeper sprite sheet as character identity reference. The prompt explicitly required three desktop windows, a `돌 / 장비` tabbed center inventory, no bottom inventory dock, no portal reward cards, and a bottom combat scene.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_0f8e1e018e3b4545016a3b77b8f47081918ff1521f2c7453c3.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_e_refined_current_mockup_b.png`
