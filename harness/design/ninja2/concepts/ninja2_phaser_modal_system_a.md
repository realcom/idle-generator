# Ninja2 Phaser Modal System A

## Intent

`ninja2`의 Phaser 런타임에서 공통으로 재사용할 모달 패밀리 후보. 기존 `Run Level-Up Choice Modal A`를 단일 전투 팝업이 아니라 확인, 보상, 스크롤 목록, 설정, 스킬 선택까지 확장 가능한 시스템 쉘로 정리한다.

## Art Anchor

- 기준 화면은 `ninja2_flat_arcade_survivors_scene_f`와 `ninja2_run_levelup_choice_modal_a`다.
- 배경은 정지된 플랫 2D 서바이벌 전장 위에 어두운 스크림을 깐다.
- 모달 재료는 크림색 양피지, 짙은 잉크 외곽선, 랜턴 골드, 소울 티얼, 이끼색 보조 버튼을 사용한다.
- 상단 랜턴 문장과 잎 장식은 고정 스프라이트 오버레이로 두고, 본체 패널과 카드만 9-slice 후보로 본다.
- 생성 이미지 안의 영어/가짜 문구는 최종 UI 문구가 아니며, 구조와 비례만 참고한다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 941x1672.
- 큰 기본 모달은 화면 중앙 65% 안에 들어오며, 모바일 엄지 터치가 가능한 하단 액션 행을 가진다.
- 확인/보상/목록/설정/스킬 선택/알림 변형은 같은 프레임 문법을 공유한다.
- 닫기 버튼은 우상단 고정. 위험한 확인 플로우가 아니면 배경 탭 닫기는 기본 비활성이다.
- 배경 HUD는 흐름을 기억할 정도로만 남기고, 조이스틱/스킬 버튼은 입력을 받지 않는다.
- 카드, 목록 행, 토글, 버튼은 모두 안정 치수를 가진 슬롯으로 쪼갠다.

## UI Direction

- ModalHost: full-screen input capture layer, dark scrim, optional paused battle/home context.
- ModalShell: parchment 9-slice panel, fixed crest ornament, fixed leafy corner ornaments, close button anchor.
- Header slots: kicker, title, subtitle/run summary, optional resource cost chip.
- Body variants: plain message, reward grid, scroll list, settings rows, three-card choice, compact notice.
- Footer variants: one primary button, two-button confirm/cancel, hidden footer for passive notices, reroll/cost row for run choices.
- State language: selected uses lantern-gold glow, disabled uses low-contrast moss/gray, destructive uses muted red only as a secondary accent.

## Implementation Notes

- Phaser implementation should treat this as a native component family, not a single baked bitmap.
- `ninja2.ui.panel.parchment_9slice` can be the first shared shell/card skin.
- Text, numbers, pips, badges, reward counts, toggles, icons, and button labels remain Phaser-native slots.
- Ornament sprites are fixed overlays and must not stretch with panel size.
- Large modal, sheet modal, compact confirm, and toast/notice should share the same `ModalHost` lifecycle: open, input capture, close, focus restoration, and optional game pause.
- Existing `RunLevelUpChoice` can become the first concrete system consumer once the generic shell is extracted.

## Target Runtime Notes

- Target runtime family: `harness/runtime/src/idlez-phaser/modal-system.js` for existing Phaser modal manager patterns, and `harness/runtime/survivor-runtime.html` for the Ninja2 level-up DOM overlay prototype.
- Next design extraction should add a generic `PhaserModalSystem` surface to `component-blueprints.yaml` before runtime implementation.
- A later `gen-phaser-ui-spec` pass should define modal variants, z-order, safe-area padding, 9-slice slice hints, keyboard/back handling, and smoke fixtures.
- First runtime target should be a UI harness route that previews all variants without requiring actual game state.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ea0e4-330d-74c2-8e74-29c5f27a0dd3/ig_04d74b28d1996c3c016a251e1c5b7881918f2bc29a5697191c.png`

![Ninja2 Phaser modal system A](ninja2_phaser_modal_system_a.png)
