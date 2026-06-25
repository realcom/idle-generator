# Main UI Concept C - Steam Market MMO Priority

## Intent

메인 UI 설계문서의 `Concept C: Steam Market MMO Priority` 축을 이미지화한 시안이다. 온라인 파밍, marketable 드롭, 먹이기/큐브 소각, Steam Inventory 연결 감정을 가장 강하게 보여주는 것이 목적이다.

## Art Anchor

- 귀여운 돌키우기 UI 위에 `켜두면 가치 있는 재료가 떨어진다`는 MMO 경제 감정을 얹는다.
- 인게임 거래소는 만들지 않는다. Market badge, Steam Inventory refresh, 드롭 알림, 소각 CTA만 보여준다.
- 오른쪽 포탈/보상 영역과 하단 전투 스트립에서 희귀 드롭 감정을 만든다.

## Composition Rules

- 하단 전투 스트립에 희귀 재료 드롭/loot toast가 보여야 한다.
- 중앙 작업석에는 marketable 재료가 먹이기/합성/큐브에 소비되는 구조를 보여준다.
- 오른쪽 포탈에는 온라인 보상과 오프라인 보상을 명확히 분리한다.
- 경제 정보가 보이되 가격표/주문장/차트 UI처럼 보이지 않아야 한다.

## UI Direction

- Steam Market MMO 포지셔닝을 가장 잘 설명하는 시안이다.
- `Farm it, feed it, burn it, or sell it on Steam` 루프가 보인다.
- 보상 카드, 드롭 배지, 온라인 전용 보상 설계 참고로 좋다.

## Implementation Notes

- 경제 UI가 과해지면 돌키우기 감성이 약해질 수 있으므로 최종 선택 시 배지 수를 줄여야 한다.
- Steam/market 표현은 실제 로고 대신 내부 badge language를 만든 뒤 Steam 외부 페이지 연결로 처리한다.
- online-only, marketable, burnable 상태를 icon badge contract로 분리해야 한다.

## Foundation Gaps

- market badge icon contract 필요.
- Steam Inventory refresh 상태/에러 UI 필요.
- irreversible consume confirmation modal 필요.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019ef36d-9707-7cb0-9b3f-c68712e5f437/ig_0c52eb3a1ed72497016a3b55f3d8ac8191bb780e902d04a864.png`
- Workspace copy: `harness/design/taskstonebar/concepts/main_ui_concept_c_steam_market_mmo_priority.png`
