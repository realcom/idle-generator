# Ninja2 Run Level-Up Choice Modal A

## Intent

`ninja2`의 매판 새로 고르는 스킬 성장 화면 후보. 전투를 잠깐 멈추고 3장의 스킬 카드 중 하나를 고르는 정석적인 Vampire Survivors식 레벨업 선택 팝업을 Ninja2의 플랫 아케이드 전투 톤으로 정리한다.

## Art Anchor

- 배경은 `ninja2_flat_arcade_survivors_scene_f`의 플랫 2D 전장 문법을 유지한다.
- 주인공은 작은 성소 수호자다. 갈색 머리, 크림색 망토, 붉은 스카프, 손등불이 작게라도 보여야 한다.
- 주요 색은 짙은 잉크 외곽선, 크림색 양피지, 랜턴 골드, 소울 티얼, 초록 전장이다.
- 카드 아이콘은 실제 스킬 풀과 연결된다: 표창/쿠나이, 연막, 질풍 보법 계열.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 948x1659.
- 전장 HUD는 뒤에 남기되 강한 어둠 오버레이로 시선이 카드에 모이게 한다.
- 중앙 대형 패널은 화면 대부분을 차지해 조작 실수를 줄인다.
- 카드 3장은 같은 높이와 폭으로 배치하고, 선택 후보는 금색 테두리/글로우로 확실히 표시한다.
- 카드 하단에는 태그/효과 칩을 두되 실제 구현에서는 2줄 이하로 줄인다.
- 하단 조이스틱, EXP 바, 스킬 버튼은 배경 상태로 보이지만 팝업과 상호작용하지 않는다.

## UI Direction

- Header: 랜턴 장식 + 큰 레벨업 타이틀 + 짧은 선택 안내.
- Body: 3 vertical skill cards.
- Card hierarchy: icon, skill name, level pips, one-sentence effect, stat chips, category chip.
- Footer: reroll button with soulflame cost. 초기 구현에서는 reroll을 비활성/숨김 처리해도 된다.
- Recommended status: `selected`. 구현 안정성과 정보 명확성이 가장 좋아 첫 Phaser 구현 기준으로 사용한다.

## Implementation Notes

- Phaser DOM/HTML overlay로 먼저 구현하기 좋다. 카드, 패널, 칩은 CSS로 충분하다.
- 배경 dim은 `rgba(0,0,0,.52)` 정도로 시작한다.
- 카드 수는 3개 고정. 모바일 세로폭이 부족하면 카드 설명은 1줄 clamp로 줄인다.
- 카드 아이콘은 이번 VFX 프로파일의 family를 기반으로 임시 generated icon 또는 lucide 없는 native glyph/canvas icon을 사용할 수 있다.
- 실제 문구는 이미지의 생성 텍스트를 사용하지 않는다. `ResourceSkill.name`, 성장 레벨, 주요 stat delta에서 런타임 문자열을 만든다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Level-up modal should pause board stepping while open, then resume after choice.
- Choice data should stay run-level only. No persistent skill tree, recipe, or achievement gate dependency.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e9108-917a-71c3-9f23-edb09e76638d/ig_03b11bd02d2fabae016a21207ee1a88191b0198e851cef3e24.png`

![Ninja2 run level-up choice modal A](ninja2_run_levelup_choice_modal_a.png)
