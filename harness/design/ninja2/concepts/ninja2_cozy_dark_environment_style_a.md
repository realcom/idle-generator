# Ninja2 Cozy Dark Environment Style A

## Intent

닌자 마을 대신 `따뜻한 성소 홈 + 어두운 숲 출격지`의 배경 스타일을 잡는다. 하우징은 안전한 거점이고, 서바이벌은 바깥 숲/폐허/성역으로 나가는 별도 화면이라는 구조를 시각적으로 분리한다.

## Art Anchor

- 하우징 홈은 안개 낀 숲 속 작은 성소다.
- 헥스/타일형 확장 보드가 읽혀야 하며, 각 타일은 건물/자원/빈 땅/잠금 상태를 가진다.
- 홈의 핵심 소품은 성소, 등불나무, 대나무/목재 작업장, 밭, 광석 채굴지, 작은 문, 토템, 울타리다.
- 출격지는 더 푸른 어둠, 뒤틀린 나무, 영혼불, 폐허 문, 의식석으로 구분한다.

## Background Rules

- Home: safe, warm, productive.
- Forest: mysterious, slightly dangerous, but unreadably dark하지 않게 유지.
- Expansion edge: gray fog, lock, unlit tile로 표시한다.
- 건물은 작고 귀여워도 기능이 읽혀야 한다. 도장보다 성소/작업장/밭/채석장이 중심이다.
- 전체 화면은 포근하지만, 바깥에는 탐험하고 싶은 불길함이 남아야 한다.

## Palette

- Home base: moss green, lantern gold, warm stone, muted red banners.
- Expedition forest: blue-green shadows, pale teal spirit lights, charcoal bark.
- Locked tiles: cool gray fog with teal/soft gold lock accents.
- Props: wood, bamboo, stone, small flowers, ritual charms.

## Implementation Notes

- 하우징 맵은 `hex tile state`를 기준으로 구현한다: `locked`, `fogged`, `empty`, `building`, `selected`, `available`.
- 출격 화면의 배경은 하우징 홈보다 명도와 채도를 낮추되, 영혼불/등불로 길을 보여준다.
- 이 방향에서는 기존 `수련마당/대나무창고/그림자광맥`을 `성소/작업장/채석장/영혼광맥` 쪽으로 리네이밍하는 것이 자연스럽다.
- 4X 확장은 종교/컬트가 아니라 성소 연합, 숲의 구역 복구, 작은 공동체 간 의식 교류로 풀 수 있다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e919dfda881919eb86c5677f96991.png`

![Ninja2 cozy dark environment style A](ninja2_cozy_dark_environment_style_a.png)
