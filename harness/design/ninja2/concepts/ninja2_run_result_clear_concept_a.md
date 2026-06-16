# Ninja2 Run Result Clear Concept A

## Intent

`ninja2` 서바이벌 루프의 승리 결과 화면 후보. 전투가 끝났다는 상태 피드백을 보상 정산보다 훨씬 크게 먼저 보여주고, 보상은 그 아래에 정돈된 리스트로 내려보내는 구조를 잡는다.

## Art Anchor

- 기준 전투 화면은 `ninja2_flat_arcade_survivors_scene_f`다.
- 공통 모달 재료는 `ninja2_phaser_modal_system_a`의 양피지, 짙은 잉크 외곽선, 랜턴 골드, 소울 티얼을 따른다.
- 배경은 전투가 끝난 플랫 2D 숲 전장이다. 코인, 목재 상자, EXP 조각, 영혼불, 쓰러진 숲 몬스터가 남아 결과 화면의 원인을 설명한다.
- 생성 이미지의 영어와 일부 한글은 최종 문구가 아니며, 상태판과 보상 리스트의 비례만 참고한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 상단 35-40%는 승리 상태판이 차지한다. `맵 클리어`가 보상보다 먼저 읽혀야 한다.
- 상태판 안에는 큰 클리어 타이틀, Stage 배지, 생존 시간/처치 수/최고 레벨 같은 2-3개 런 요약만 둔다.
- 보상 영역은 상태판 아래 별도 섹션으로 두고, 세로 리스트 행을 사용한다.
- 보상 행은 아이콘, 이름, 수량만 가진다. 설명문, 장문 툴팁, 중첩 카드 구조는 금지한다.
- 하단 CTA는 하나만 둔다: `성소로 귀환`.

## UI Direction

- Header state: lantern-gold victory slab, trophy/lantern crest, thick ink outline, strong hard shadow.
- Reward list: parchment body on lighter cream, 6-8 rows max before scrolling, resource/gear icons use existing generated UI assets.
- Reward ordering: coin, EXP/item, wood, gear, stone, soulflame, lantern gauge.
- Loss variant must share layout but replace gold header with muted red and fewer kept rewards.
- Text exactness is solved in runtime; this concept only locks the hierarchy.

## Implementation Notes

- Do not bake this full image into runtime. Build it as DOM/Phaser slots.
- The current runtime result screen should reduce ornament density compared with this concept: keep the big status slab, not every decorative banner.
- The status region can be a fixed-height block; reward list should scroll independently.
- Use saved state reward rows, not board-only inventory, so displayed reward and persisted reward match.
- Exact Korean title: `맵 클리어`. Kicker example: `Stage 1 정화 성공`.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Verification should include victory, defeat, no-reward, and mixed reward cases.
- Smoke should assert title hierarchy and persisted reward deltas for resource and non-resource items.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ea17b-289d-7421-a013-e43c422beb67/ig_0fff5d6df585eb11016a28fe1572908196b4567645672917d0.png`

![Ninja2 run result clear concept A](ninja2_run_result_clear_concept_a.png)
