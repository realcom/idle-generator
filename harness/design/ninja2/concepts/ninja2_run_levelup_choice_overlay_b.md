# Ninja2 Run Level-Up Choice Overlay B

## Intent

`ninja2`의 레벨업 선택을 더 빠르고 아케이드적으로 보이게 하는 하단 스택형 후보. 전투 배경과 주인공 위치를 계속 살려서, 플레이 흐름이 끊기지 않는 느낌을 먼저 검토한다.

## Art Anchor

- 배경 전장은 `ninja2_flat_arcade_survivors_scene_f`와 같은 플랫 2D survivors-like 필드다.
- 성소 수호자, 랜턴, 붉은 스카프, 소울플레임, 파란 EXP 조각을 유지한다.
- 선택 카드의 주요 색은 크림 양피지 + 랜턴 골드 + 소울 티얼 외곽선이다.
- 스킬 아이콘은 번개 쿠나이, 흑련 폭풍, 약점 표식처럼 고대비 실루엣을 우선한다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 948x1659.
- 전장 배경을 A안보다 더 많이 남긴다.
- 레벨업 헤더는 상단 중앙에 떠 있고, 선택 카드는 lower-middle부터 bottom-right로 쌓인다.
- 카드는 3개 세로 스택이며, 선택 후보는 티얼/골드 이중 테두리로 강조한다.
- 조이스틱과 EXP 바는 보이되 어둡게 처리한다. 실제 구현에서는 카드와 겹치지 않도록 z-index와 bottom safe area를 엄격히 잡는다.

## UI Direction

- Header: 작은 랜턴/소울플레임 장식 + 레벨업 타이틀.
- Choice area: horizontal reward cards stacked vertically.
- Card hierarchy: icon badge, skill name, short effect copy, level pips, stat chip.
- Interaction feeling: 빠른 선택, 카드가 아래에서 튀어나오는 보상감, 선택 후 바로 전투 복귀.
- Recommended status: `draft`. 속도감은 좋지만 모바일 터치 안정성은 A안보다 약하다.

## Implementation Notes

- Phaser/DOM 구현 시 카드가 bottom skill buttons와 겹치지 않도록 `bottom: 96px` 이상을 보장한다.
- 생성 이미지의 한국어 문구는 정확한 최종 문구로 쓰지 않는다. 구조만 참고한다.
- 카드가 기울어진 느낌은 구현 난이도를 올리므로, 첫 구현에서는 직사각형 스택으로 단순화한다.
- 선택 카드 진입 애니메이션은 `translateY + alpha` 정도로 충분하다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- This concept can be used as a later "fast choice" variant after Modal A proves the data flow.
- Run-level only. Choices reset every expedition.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e9108-917a-71c3-9f23-edb09e76638d/ig_03b11bd02d2fabae016a2120fa7b84819182f76810a385ec76.png`

![Ninja2 run level-up choice overlay B](ninja2_run_levelup_choice_overlay_b.png)
