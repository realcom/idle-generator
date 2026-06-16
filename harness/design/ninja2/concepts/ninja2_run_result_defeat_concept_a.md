# Ninja2 Run Result Defeat Concept A

## Intent

`ninja2` 서바이벌 루프의 패배 결과 화면 후보. 플레이어가 맵을 클리어하지 못했다는 상태를 크게 먼저 보여주고, 유지되는 보상은 그 아래에 보조 정보로 정리한다.

## Art Anchor

- 기준 전투 화면은 `ninja2_flat_arcade_survivors_scene_f`다.
- 공통 모달 재료는 `ninja2_phaser_modal_system_a`의 양피지, 짙은 잉크 외곽선, 랜턴 장식 계열을 유지한다.
- 패배 상태는 깨진 랜턴, 붉은 천, 낮은 채도의 숲 배경으로 구분한다.
- 생성 이미지의 한글은 일부가 의도보다 장식적이므로 최종 문구로 사용하지 않는다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 상단 35-40%는 패배 상태판이 차지한다. `패배`가 보상보다 먼저 읽혀야 한다.
- 상태판 안에는 실패 Stage, 생존 시간, 처치 수, 받은 피해 같은 런 요약을 2-3개만 둔다.
- 보상 영역은 `획득 보상` 또는 `유지 보상` 섹션으로 상태판 아래에 둔다.
- 패배 보상은 승리보다 짧아야 한다. 영혼불, 목재, 등불 게이지 같은 유지 보상 위주로 3-4줄이면 충분하다.
- 하단 CTA는 하나만 둔다: `성소로 돌아가기` 또는 `성소로 귀환`.

## UI Direction

- Header state: muted red/orange loss slab, broken lantern crest, thick ink outline.
- Reward list: clear concept과 동일한 row grammar를 공유한다.
- Footer below modal may include 짧은 격려 문구를 둘 수 있지만, 런타임 1차 구현에서는 생략해도 된다.
- Loss does not show map progression unlocks. It may show retained resources only.

## Implementation Notes

- Do not bake this full image into runtime. Build it as DOM/Phaser slots.
- Victory and defeat should share one component with state class modifiers.
- The defeat header should be large enough to read at a glance even before the user scans rewards.
- Avoid dense flavor text in the modal body; defeat recovery path is the return button.
- Exact Korean title: `패배`. Kicker example: `Stage 1에서 패배`.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Verification should include forced enemy win and early return.
- Smoke should assert that defeat uses the loss state class, large title, and shorter reward list.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ea17b-289d-7421-a013-e43c422beb67/ig_0fff5d6df585eb11016a28fe69dc4c8196a736ca2f781e2217.png`

![Ninja2 run result defeat concept A](ninja2_run_result_defeat_concept_a.png)
