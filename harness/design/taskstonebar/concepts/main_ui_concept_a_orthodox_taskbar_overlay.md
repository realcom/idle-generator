# Main UI Concept A - Orthodox Taskbar Overlay

## Intent

메인 UI 설계문서의 `Concept A: Orthodox Taskbar Overlay` 축을 이미지화한 시안이다. 작업표시줄형 게임 정체성을 가장 강하게 보여주는 것이 목적이다.

## Art Anchor

- Windows-like green desktop background.
- Three separate ornate pixel windows: `스테이터스`, `작업석`, `포탈`.
- Red/burgundy title bars, black iron frame, warm gold labels.
- Bottom taskbar combat strip with the stone keeper throwing rocks.

## Composition Rules

- 세 창은 좌/중/우 균형을 유지한다.
- 중앙 작업석은 중요하지만, 전체 화면은 세 창이 나란히 떠 있는 데스크톱 오버레이처럼 보여야 한다.
- 하단 전투 스트립은 OS taskbar 바로 위에 붙어야 한다.
- 데스크톱 배경 여백을 남겨 `작업표시줄 위에서 도는 게임` 인상을 유지한다.

## UI Direction

- 가장 보수적이고 구현 기준으로 쓰기 쉬운 구조다.
- 정보 밀도, 패널 크기, 상단 자원 카운터, 포탈/보상 배치가 균형형이다.
- 이후 Godot Control scene으로 분해할 때 기준 비율로 쓰기 좋다.

## Implementation Notes

- 생성 텍스트는 실제 런타임 라벨로 교체한다.
- 프레임, 헤더, 슬롯, 버튼, 하단 스트립을 별도 UI atoms로 추출한다.
- 작업표시줄 정체성은 좋지만 돌키우기2만의 감정은 Concept B보다 약할 수 있다.

## Foundation Gaps

- 버튼 시스템, 모달 시스템, 아이콘 badge contract는 아직 미정이다.
- 선택 시 `ui-system-inventory.yaml` 추출이 필요하다.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_01e17524cd61099d016a3b53f8d3f481918ed3defb4ce6a228.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_a_orthodox_taskbar_overlay.png`
