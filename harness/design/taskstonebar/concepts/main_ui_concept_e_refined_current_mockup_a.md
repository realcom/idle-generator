# Main UI Concept E-A - Refined Current Mockup Draft

## Intent

현재 `ui-feature-preview.html`에서 정리한 최신 구조를 이미지 생성으로 다시 그린 draft 시안이다. 목적은 HTML 목업의 기능 구조를 유지하면서 더 자연스러운 Steam-ready pixel UI 마감, 전투 씬 감정, 포탈 지도 분위기를 확인하는 것이다.

## Art Anchor

- 최신 HTML 목업: `harness/design/taskstonebar/qa/ui-feature-preview-desktop.png`
- 돌지기 캐릭터 정체성: `stone_keeper_character_remodel_sheet_a_source.png`
- 이전 Taskbar Hero-like 방향: 세 개의 독립 데스크톱 창, 붉은 타이틀 바, 검은 철 프레임, 하단 전투 씬.

## Composition Rules

- Windows-like green desktop background and visible OS taskbar.
- Three ornate windows: `스테이터스`, `돌지기`, `포탈`.
- Center window keeps `돌 / 장비` tab language and stone-only inventory intent.
- Bottom area is combat scene only, not an inventory dock.
- Portal keeps difficulty selector, Act tabs, parchment route map, current flag, and boss node.

## UI Direction

이 draft는 전투 씬의 감정과 전체 PC idle RPG 마감이 좋다. 중앙 인벤토리 그리드는 런타임 요구에 맞춰 8 columns x 4 rows로 창 내부를 꽉 채우는 구현 기준을 우선한다.

## Implementation Notes

- Generated text is visual reference only; runtime labels must replace it.
- Use the bottom combat lane lighting, enemy contact, rare drop toast, and stone keeper integration as art-direction reference.
- Do not import the full image as a background. Extract proportions, frame language, map mood, combat composition, and icon-dock treatment.

## Target Runtime Notes

- Godot/Phaser runtime should keep deterministic slot count from `ui-system-inventory.yaml`.
- Keep bottom combat scene as a real layered runtime surface: background, ground, hero sprite, projectile, enemies, HP bar, drop toast, mini shortcut dock.

## Foundation Gaps / Questions

- `button-system.yaml` and `modal-system.yaml` do not exist yet.
- Icon badge contract and exact typography scale are still unresolved.
- Need a later decision on whether the center title remains `돌지기` or changes to a broader inventory label.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_09302475f0d0f593016a3b76bd04b881969fae5cc5e667a96f.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_e_refined_current_mockup_a.png`
