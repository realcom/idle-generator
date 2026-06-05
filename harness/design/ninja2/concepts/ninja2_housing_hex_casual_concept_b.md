# Ninja2 Housing Hex Casual Concept B

## Intent

`ninja2` 하우징 홈 화면의 캐주얼 톤 후보 시안. Concept A의 검은 복면, 강한 무기감, 전투 CTA가 유치하고 과하게 닌자처럼 보이는 문제를 줄이고, 밝은 헥스 영지 확장 보드와 친근한 캐릭터 중심으로 재정리했다.

## Art Anchor

- 닌자 정체성은 전면 복면/검/암살자 분위기가 아니라 도장, 대나무, 작은 깃발, 수련 마당 같은 생활형 모티프로 표현한다.
- 캐릭터는 무서운 닌자가 아니라 캐주얼 모험가형 주인공이다. 부드러운 얼굴, 간단한 머리띠/스카프, 작은 장비 정도만 사용한다.
- 색감은 밝은 풀밭, 목재, 붉은 지붕, 골드 CTA, 작은 하늘색 광석 포인트를 중심으로 한다.
- 외곽 잠금 타일은 위협적인 안개보다 부드러운 구름/잠금 표현으로 확장 목표를 만든다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 중앙 70% 이상은 헥스 보드가 차지하고, UI는 보드를 가리지 않게 가장자리와 하단에 둔다.
- 건물은 전투 시설보다 영지 생산/성장 시설처럼 보여야 한다: 수련마당, 대나무 작업장, 창고, 허브밭, 신사, 채석장.
- 선택된 헥스는 밝은 노란 테두리와 하단 정보 패널로 연결한다.
- 출격 CTA는 `전투 개시`보다 `탐험 출발`에 가까운 톤으로, 큰 검 대신 작은 깃발/화살표 아이콘을 쓴다.

## UI Direction

- Top resources: 골드, 루비, 목재, 석재, 광석을 밝은 칩으로 배치한다.
- Side missions: 일일 임무는 작은 진행 바와 체크로 충분히 보여준다.
- Hex states: `건설 가능`, `확장 필요`, `선택됨`, `생산 중`, `업그레이드 가능` 상태를 색과 아이콘으로 구분한다.
- Building labels: 이름, Lv., 업그레이드 화살표만 남기고 긴 설명은 하단 정보 패널로 보낸다.
- Bottom dock: `영지`, `건설`, `업그레이드`, `스킬`, `상점` 순서. `동맹/4X`는 MVP 이후 잠금 탭으로 추가한다.

## Implementation Notes

- 이 시안을 현재 우선 후보로 둔다. Concept A는 닌자성이 강해 reference로만 유지한다.
- `ninja2`의 Housing 생산 노드 `수련마당`, `대나무창고`, `그림자광맥`은 이 보드의 건물 타일로 매핑한다.
- UI recipe 단계에서는 하단 CTA 문구를 `탐험 출발` 또는 `출격` 중 하나로 짧게 선택한다.
- 캐릭터 아바타는 기존 `Ninster3`의 닌자 모티프를 직접 복제하지 말고, 캐주얼 주인공 얼굴/스카프/머리띠로 재해석한다.
- 실제 구현에서는 정보 패널 높이를 줄이고, safe area 안에서 하단 탭과 CTA가 겹치지 않게 고정 높이를 잡는다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e81cb48208191a82c789c24b0d486.png`

![Ninja2 housing hex casual concept B](ninja2_housing_hex_casual_concept_b.png)
