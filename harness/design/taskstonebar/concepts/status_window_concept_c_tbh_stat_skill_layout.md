# Status Window Concept C - TBH Stat Skill Layout

## Intent

스태이터스 창을 `캐릭터 초상 창`이 아니라, Taskbar Hero 레퍼런스처럼 `스탯 리스트 + 스킬 포인트 + 레벨별 스킬 트리` 창으로 정리한 교정 시안이다.

중앙 돌지기 창에 이미 캐릭터가 보이므로 StatusWindow 안에는 캐릭터 전신/초상/돌 초상을 넣지 않는다.

## Image

- File: `status_window_concept_c_tbh_stat_skill_layout.png`
- Generator: built-in `image_gen`
- Source baseline: user-provided STATUS reference image and `../ui-feature-preview.html`

## Prompt Summary

- 단독 `STATUS` 창.
- 상단: 클래스 리본 `돌지기`, 스크롤 가능한 스탯 리스트, 우측 스크롤바, 좌하단 검색 버튼.
- 중단: `Skill Points: 0` 헤더.
- 하단: 세로 레벨 축 `0 / 10 / 30`, 좌측 화살표, 3행 스킬 슬롯.
- 스킬 아이콘은 돌 던지기, 방어, 화염, 집중, 골드/드롭, 희귀 감지 계열.
- 금지: 캐릭터 초상, 전신 캐릭터, 살아있는 돌 초상, 인벤토리 그리드, 장비 페이퍼돌.

## Useful Decisions

- StatusWindow는 플레이어 상태와 스킬 트리만 담당한다.
- 캐릭터 비주얼은 중앙 `돌지기` 창과 하단 전투바에서만 보여준다.
- 돌키우기 감성은 상태창 안에서는 스킬 아이콘/수치명/드롭 보너스 정도로만 제한한다.
- 실제 런타임에서는 이미지 텍스트를 그대로 쓰지 않고 UI 텍스트로 재배치한다.

## Implementation Notes

- HTML 프리뷰도 이 구조로 수정했다.
- 런타임 분해 우선 대상:
  - `StatusWindowFrame`
  - `StatusStatScrollPanel`
  - `StatusSearchButton`
  - `SkillPointHeader`
  - `SkillLevelTrack`
  - `SkillTierRow`
  - `SkillIconSlot`
- 이 시안이 현재 StatusWindow 타겟이다.
