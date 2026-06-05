# Ninja2 Casual Sanctuary Housing Screen A

## Intent

`casual_sanctuary` 피벗의 세로형 모바일 하우징 홈 화면 후보. 플레이어가 안전한 숲속 성소에서 헥스 타일을 확장하고, 건물을 짓고, 생산/업그레이드를 관리한 뒤 `탐험 출발`로 별도 서바이벌 전장에 진입하는 구조를 보여준다.

## Art Anchor

- 메인 캐릭터는 `ninja2_casual_sanctuary_hero_scar_a`의 이마 흉터, 갈색 머리, 크림색 후드 망토, 붉은 스카프, 등불/펜던트 앵커를 유지한다.
- 배경은 `ninja2_casual_sanctuary_background_a`의 밝은 헥스 성소, 성소 건물, 등불나무, 작업장, 허브밭, 광산, 안개 잠금 타일을 기준으로 한다.
- 모바일 캐주얼 우선: 홈은 밝고 포근하며, 수상함은 영혼불과 안개 타일 정도로 제한한다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 화면 중앙 65~70%는 헥스 영지 보드가 차지한다.
- 상단에는 재화 바, 좌상단에는 캐릭터 초상/레벨/진행도, 우상단에는 업적/설정/메뉴를 둔다.
- 우측에는 일일 임무 패널을 작게 배치한다.
- 선택된 건물은 보드 위 라벨과 하단 정보 패널이 함께 반응한다.
- 하단에는 `영지`, `건설`, `업그레이드`, `주민`, `상점` 탭을 둔다.
- 전투 진입은 하단 우측의 큰 `탐험 출발` CTA로 분리한다.

## UI Direction

- Tile states: `building`, `empty build slot`, `selected`, `locked/fogged`, `expand cost`.
- Building tags: 이름, Lv., 업그레이드 가능 화살표만 보드 위에 표시한다.
- Info panel: 건물 초상, 생산량, 남은 시간, 업그레이드 비용만 담는다.
- CTA: 큰 검/전투 아이콘보다 깃발/등불/탐험 아이콘을 사용한다.
- Residents tab: 기존 닌자/스킬 탭보다 성소 주민 관리 루프를 강조한다.

## Implementation Notes

- 하우징 데이터는 헥스 좌표 상태(`locked`, `fogged`, `empty`, `building`, `selected`, `available`)로 관리한다.
- 현재 콘텐츠의 `수련마당`, `대나무창고`, `그림자광맥`은 새 테마에서는 `수련마당`, `작업장`, `영혼광맥/채석장` 계열로 리네이밍하는 것이 자연스럽다.
- 생성 이미지의 한글/숫자 텍스트는 구조 참고용이다. 실제 구현 라벨은 짧게 재작성한다.
- 하단 정보 패널과 CTA는 safe area 안에서 겹치지 않게 고정 높이를 잡는다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e9de553f48191aeaa945b49fdcee7.png`

![Ninja2 casual sanctuary housing screen A](ninja2_casual_sanctuary_housing_screen_a.png)
