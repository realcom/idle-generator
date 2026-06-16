# Slack Share Text

```text
UI 결정/반영 규칙을 repo 독립적으로 정리한 표준 키트 공유드립니다.

첨부: ui-decision-standard-kit-2026-06-16.zip

목적:
- UI 시안을 바로 구현하지 않고, 디자인 시스템과 Phaser 런타임까지 일관된 규칙으로 연결하기 위한 표준입니다.
- 다른 프로젝트에서도 UI 방향성, 공통 버튼/모달/색상 규칙, 에셋, 9-slice, Phaser spec, QA 기준을 같은 방식으로 맞출 수 있게 문서와 템플릿을 묶었습니다.

설치 방법:
1. zip을 프로젝트 안에 풀어주세요.
2. README.md, UI_DECISION_STANDARD.md, PHASER_HANDOFF.md, AGENT_BRIEF.md를 확인합니다.
3. 먼저 프로젝트에 기존 UI/design-system 문서가 있는지 확인합니다.
   - button system
   - modal/dialog system
   - color tokens
   - typography
   - spacing/layout
   - icon rules
   - 9-slice / UI skin policy
   - Phaser/UI harness 문서
4. 있으면 kit의 규칙과 연결하고, 없으면 templates 기반으로 최소 시스템 문서를 생성합니다.
5. SKILL_INTEGRATION.md를 기준으로 UI 관련 skill/harness 문서에 이 표준을 실제 작업 흐름으로 반영합니다.
6. 설치가 끝나면 사용자가 매번 공통 button/modal/color 규칙을 프롬프트에 반복하지 않아도, 관련 스킬이 기본으로 확인해야 합니다.

Codex 설치 요청 예시:
"첨부된 ui-decision-standard-kit을 현재 프로젝트에 설치해줘.
먼저 README.md, UI_DECISION_STANDARD.md, PHASER_HANDOFF.md, AGENT_BRIEF.md를 읽어줘.
SKILL_INTEGRATION.md를 기준으로 UI 관련 skill/harness 문서에 foundation gate를 반영해줘.
그다음 기존 UI/design-system, button, modal, color, typography, spacing, icon, 9-slice, Phaser/UI harness 문서를 찾아줘.
있는 문서는 kit 규칙과 연결하고, 없는 문서는 templates 기반으로 최소 규격을 만들어줘.
명확한 규칙을 찾지 못한 항목은 임의로 정하지 말고 사용자에게 질문 목록을 먼저 제시해줘.
답변을 받은 뒤 그 내용을 규격 문서와 관련 skill/harness 작업 흐름에 반영해줘."

사용법:
- 신규 UI는 concept 단계부터 시작합니다.
- 선택된 시안은 design-system, asset-plan, Phaser spec, runtime build, review 순서로 반영합니다.
- 버튼/모달/색상은 화면마다 새로 만들지 않고, 설치 단계에서 확인한 공통 시스템 문서를 기준으로 맞춥니다.
- 에셋 제작이 필요한 경우 Codex 사용을 권장합니다. asset-plan을 기준으로 에셋 생성, 경로 반영, 9-slice 검증, Phaser 연결까지 같이 처리하는 방식이 좋습니다.

Codex 사용 요청 예시:
"설치된 ui-decision-standard-kit 기준으로 <게임/화면명> UI 작업을 진행해줘.
관련 스킬/하니스에 반영된 foundation gate를 따라 필요한 산출물과 검증까지 처리해줘."

사용법이 헷갈릴 때 묻는 예시:
"ui-decision-standard-kit 기준으로 <게임/화면명> UI를 작업하려고 해.
다음에 호출할 스킬, 필요한 입력, 예상 산출물만 짧게 알려줘."

단계별 Codex 요청 예시:
- 설치/감사만:
  "ui-decision-standard-kit을 설치해줘.
  기존 button/modal/color/typography/spacing/icon/9-slice/Phaser harness 문서가 있는지만 먼저 감사해서 보고해줘."
- 누락 규격 만들기:
  "감사 결과 없는 button/modal/color 시스템을 templates 기반으로 만들어줘.
  모호한 규칙은 바로 쓰지 말고 사용자 질문 목록으로 먼저 정리해줘."
- 시안 단계:
  "<게임/화면명>의 UI concept를 만들거나 기존 concept를 selected 상태로 정리해줘.
  아직 Phaser 런타임 구현은 하지 말아줘."
- 디자인 시스템 추출:
  "selected concept를 기준으로 art-direction, layout-tokens, component-blueprints, component-skins, asset-plan, critique-rubric을 작성해줘.
  공통 button/modal/color 시스템과 충돌하는 부분이 있으면 먼저 알려줘."
- 버튼/모달 통일:
  "이번 화면의 버튼과 모달이 공통 button-system/modal-system/color-tokens를 따르는지 확인해줘.
  화면 전용 규칙이 필요하면 어떤 시스템 문서에 추가해야 하는지 제안해줘."
- 9-slice 판정:
  "asset-plan의 패널/버튼/카드/모달 skin 중 Phaser 9-slice 대상과 제외 대상을 판정해줘.
  slice_hints와 content_insets를 분리해서 기록해줘."
- 에셋 제작:
  "asset-plan 기준으로 필요한 UI 에셋을 생성해줘.
  생성 후 runtime 경로, 상태, 9-slice hint, 사용 컴포넌트를 갱신해줘."
- Phaser spec 작성:
  "현재 design-system과 asset-plan 기준으로 runtime/specs/ui/<화면명>.yaml Phaser UI spec만 먼저 작성해줘.
  아직 런타임 코드는 수정하지 말아줘."
- 런타임 반영:
  "작성된 Phaser UI spec을 기준으로 런타임에 반영해줘.
  smoke, audit, screenshot 검증까지 실행하고 결과를 알려줘."
- 리뷰만:
  "현재 runtime screenshot과 selected concept를 섹션별로 비교해줘.
  PASS/WARN/ERROR와 다음 수정 범위를 알려줘."
- 막혔을 때:
  "지금 단계에서 확정되지 않은 UI 규칙을 질문 목록으로 정리해줘.
  각 질문의 답변을 어느 시스템 문서에 반영할지도 같이 제안해줘."
```
