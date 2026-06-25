# Main UI Concept D - Minimal Taskbar First

## Intent

메인 UI 설계문서의 `Concept D: Minimal Taskbar First` 축을 이미지화한 시안이다. 데스크톱을 많이 가리지 않고 하단 전투 스트립 중심으로 항상 켜두는 게임 감각을 검증하는 것이 목적이다.

## Art Anchor

- 핵심은 하단 전투 스트립이다.
- 세 창은 접이식 위젯처럼 작고 정리된 형태로 보인다.
- 게임이 풀스크린 RPG라기보다 작업 중 옆에 살아 있는 PC companion idle game처럼 느껴져야 한다.

## Composition Rules

- 하단 전투 스트립은 다른 시안보다 더 넓고 선명하게 둔다.
- 세 창은 필수 요약만 담아 데스크톱 여백을 남긴다.
- 각 창에는 minimize/collapse 가능성을 암시하는 작고 명확한 컨트롤이 있어야 한다.
- 전투 가시성, 캐릭터 접지, 드롭 로그를 최우선으로 둔다.

## UI Direction

- `켜두는 게임` 설득력이 가장 강하다.
- 실제 Taskbar Mode / Workshop Mode 분리 설계의 출발점으로 좋다.
- 유저가 게임을 항상 켜둬도 부담이 적어 보인다.

## Implementation Notes

- 기능 전체를 한 화면에서 설명하는 힘은 A/B/C보다 약하다.
- 접이식/축약 모드와 확장 모드의 상태 전환 설계가 필요하다.
- 선택 시 bottom strip runtime 구현을 먼저 하고, 상단 위젯은 progressive disclosure로 확장하는 방향이 적합하다.

## Foundation Gaps

- folded taskbar mode contract 필요.
- compact widget layout breakpoints 필요.
- dock/undock window behavior 정의 필요.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_01890ecbd1c93603016a3b56e8b3b481908f173210c0e8a6f3.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_d_minimal_taskbar_first.png`
