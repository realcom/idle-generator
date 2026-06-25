# Main UI Concept B - Stone Workshop Priority

## Intent

메인 UI 설계문서의 `Concept B: Stone Workshop Priority` 축을 이미지화한 시안이다. 돌키우기2의 주인공성을 중앙 작업석과 먹이기/합성/큐브 조작에서 가장 강하게 보여주는 것이 목적이다.

## Art Anchor

- 중심 주인공은 영웅이 아니라 귀여운 살아있는 작업석이다.
- 하단 전투 스트립은 유지하되, 화면의 감정 중심은 중앙 작업석 창이다.
- 돌키우기1의 귀여운 픽셀 돌 감성에 Steam PC UI 마감감을 더한다.

## Composition Rules

- 중앙 `작업석` 창을 가장 크게, 가장 밝고 매력적으로 둔다.
- 좌측 `스테이터스`와 우측 `포탈`은 보조 패널로 읽히게 한다.
- 먹이기, 합성, 큐브 제련 흐름이 한눈에 보여야 한다.
- 작업대, 재료 슬롯, 큐브 발광, 먹이 진행도를 가까이 묶는다.

## UI Direction

- 돌키우기2 고유 정체성이 가장 잘 보이는 방향이다.
- 유저가 `돌을 키운다`는 욕망을 빠르게 이해한다.
- 큐브/합성/재료 소모의 시각적 매력도 좋다.

## Implementation Notes

- 중앙 패널 구현 난도가 A보다 조금 높다. 피드/합성/큐브 영역의 탭 또는 하위 모드를 정해야 한다.
- 실제 런타임에서는 CTA를 `먹이기`, `합성`, `큐브` 중 한 개 primary로 정리해야 과밀하지 않다.
- 선택 시 중앙 작업석용 9-slice frame, pedestal, feed meter, material tray 추출이 중요하다.

## Foundation Gaps

- feed/cube confirmation modal 필요.
- material slot market badge 규칙 필요.
- primary/secondary button hierarchy 확정 필요.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_0cc8f68030ed990b016a3b5502d96081919ad9544c409ed3ed.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_b_stone_workshop_priority.png`
