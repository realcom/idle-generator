# Status Window Concept A - Refined Stone Status

## Intent

스태이터스 창을 메인 UI와 분리해 단독으로 뽑은 컴포넌트 시안이다. 기존 HTML 프리뷰의 역할 구조는 유지하되, `Taskbar Hero`식 짙은 프레임과 돌키우기2의 살아있는 돌 정체성을 더 강하게 보이도록 했다.

## Image

- File: `status_window_concept_a_refined_stone_status.png`
- Generator: built-in `image_gen`
- Source baseline: `../ui-feature-preview.html`

## Prompt Summary

- 단독 `스테이터스` 창.
- 검은 석재 프레임, 버건디 타이틀바, 금색 한글 타이틀.
- 상단: 살아있는 이끼돌 초상, `작업돌`, `Lv. 31`, `EXP 39%`, 공격력/공속/치명타/드롭 보너스.
- 중단: 골드 보너스, 보스 피해, 채굴 성장 보너스.
- 하단: 룬 & 마크 슬롯, 잠금 슬롯, 작업돌 특성 3개.
- 배경은 추출하기 쉬운 녹색 데스크톱 톤.

## Useful Decisions

- 스태이터스 창은 인간 영웅이 아니라 `돌 캐릭터의 상태창`으로 읽혀야 한다.
- 룬/마크는 성장 트리와 장착 슬롯의 중간 UI처럼 보이게 유지한다.
- 특성 버튼은 추후 `투척 강화`, `돌 회복`, `희귀 감지` 같은 패시브 성장 버튼으로 확장한다.
- 한글 텍스트는 실제 런타임에서는 HTML/Godot 텍스트로 재구성해야 하며, 생성 이미지의 글자는 시각 방향 참고용으로만 사용한다.

## Implementation Notes

- HTML 프리뷰에는 이미 동일한 역할 구조가 반영되어 있다.
- 런타임 분해 시 우선 추출 대상:
  - `StatusWindowFrame`
  - `StatusTitleBar`
  - `StonePortraitPanel`
  - `StatusStatPanel`
  - `BonusBadge`
  - `RuneSlot`
  - `TraitButton`
- 픽셀 텍스트는 이미지에서 직접 쓰지 말고 엔진 폰트로 재배치한다.

## Open Questions

- `룬 & 마크`가 장비와 별도 성장 시스템인지, 돌 합성 티어의 보조 성장인지 확정 필요.
- 특성 3개가 고정 노출인지, 레벨/스테이지에 따라 확장되는지 결정 필요.
