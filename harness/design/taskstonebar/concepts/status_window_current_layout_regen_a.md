# Status Window Current Layout Regen A

## Intent

현재 Godot `StatusWindow` 캡처의 화면 구성, 좌상단 배치, 창 크기, 정보 위계를 그대로 유지한 상태에서 픽셀 프레임과 슬롯 밀도를 다시 시안화한 비교용 컨셉이다.

이 시안은 새 구조 제안이 아니라 `status_window_concept_c_tbh_stat_skill_layout`을 실제 런타임 화면 기준으로 재생성한 레이아웃 잠금 패스다.

## Image

- File: `status_window_current_layout_regen_a.png`
- Source image: `status_window_current_layout_regen_a_source.png`
- Runtime baseline: `../../../runtime/godot-taskstonebar/screenshots/taskstonebar-status-window.png`
- Compare board: `../qa/status-window-current-vs-regen-a.png`
- Generator: built-in `image_gen`, then post-processed to match the Godot screenshot bounding box.

## Prompt Summary

- 1586x992 데스크톱 캔버스 위 좌상단 단독 `스테이터스` 창.
- 창 위치와 크기는 현재 Godot 캡처 기준 `x=74, y=44, w=454, h=570`으로 고정.
- 상단: 버건디 타이틀바, 금색 `스테이터스`, 작은 X 닫기 버튼.
- 상단 본문: `Stone Keeper` 리본, 스탯 리스트, 우측 스크롤바, 좌하단 검색 버튼.
- 중단: `Skill Points: 0` 헤더와 플러스 기호.
- 하단: `0 / 10 / 30` 세로 레벨 트랙, 3행 스킬 슬롯, 좌측 화살표.
- 금지: 캐릭터 초상, 전신 캐릭터, 살아있는 돌 초상, 장비 페이퍼돌, 인벤토리 그리드, 추가 창.

## Art Anchor

기준은 현재 Godot 캡처의 TBH식 상태창 구조다. 돌키우기2 정체성은 프레임의 암석/철제 질감, 스킬 아이콘의 돌/코인 계열, 버건디+골드 창 크롬으로만 드러내고, 상태창 안에 별도 캐릭터 비주얼은 넣지 않는다.

## Composition Rules

- 전체 캔버스와 창 바운딩 박스는 현재 캡처와 동일하게 유지한다.
- 우측과 하단의 넓은 주황 배경 여백은 비교용 기준이므로 유지한다.
- 창 내부 위계는 `타이틀바 -> 스탯 스크롤 패널 -> Skill Points -> 스킬 트리` 순서로 고정한다.
- 스킬 트리 행 수는 3행, 각 행의 슬롯 수는 3칸으로 유지한다.
- 레벨 트랙은 창 좌측 하단 영역에 붙이며, 스킬 행과 세로 정렬을 맞춘다.

## UI Direction

- 현재 Godot 구현보다 타이틀바와 외곽 프레임의 픽셀 질감을 강화한다.
- 스탯 패널은 parchment 카드로 읽히게 하되 텍스트는 런타임 네이티브 라벨로 재배치한다.
- 스킬 슬롯은 녹색-금색 선택 프레임과 어두운 행 배경의 대비를 유지한다.
- 아이콘은 현재 구조를 유지하면서 향후 `taskstonebar.ui.skill_tree_icon_set`으로 교체 가능한 단순 상징으로 둔다.

## Implementation Notes

- 이 이미지는 구현 대상 구조를 바꾸지 않는다. Godot 노드 구조는 `StatusStatScrollPanel`, `StatusSearchButton`, `SkillPointHeader`, `SkillLevelTrack`, `SkillTierRow`, `SkillIconSlot`을 그대로 사용한다.
- 생성본 원본은 창이 커지는 경향이 있어 최종 PNG는 현재 Godot 캡처 바운딩 박스에 맞게 후처리했다.
- 실제 적용 시 이미지를 통째로 쓰지 않고 타이틀바, 프레임, 슬롯, 패널 스킨 후보로 분해한다.
- 텍스트와 수치는 이미지 내 픽셀 글자를 사용하지 말고 Godot Label로 유지한다.

## Target Runtime Notes

- Target runtime: `harness/runtime/godot-taskstonebar`
- Baseline scene: `res://scenes/generated/status_window.tscn`
- Capture script: `res://scripts/tools/capture_status_window.gd`
- 레시피 기준은 `harness/godot/recipes/ui/taskstonebar-status-window.yaml`과 full overlay StatusWindow 섹션을 함께 본다.

## Foundation Gaps Or Questions

- 공유 버튼, 모달, 컬러, 컴포넌트 문서는 존재하므로 이 시안 기준의 큰 foundation gap은 없다.
- 남은 질문: 최종 한국어 픽셀 폰트와 스킬 아이콘 아틀라스가 확정되면 현재 슬롯 내부 아이콘을 어느 정도까지 원본 감성으로 교체할지 결정해야 한다.

## Source Image Link

- `status_window_current_layout_regen_a_source.png`
