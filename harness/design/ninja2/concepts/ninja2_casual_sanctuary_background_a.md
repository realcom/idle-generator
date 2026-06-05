# Ninja2 Casual Sanctuary Background A

## Intent

모바일 캐주얼을 우선한 성소 하우징 배경 후보. 하우징 홈은 밝고 꾸미고 싶은 헥스 영지이며, 바깥 탐험지는 살짝 수상한 숲으로만 대비한다.

## Art Anchor

- 홈은 안전하고 따뜻한 숲속 성소다.
- 중앙 성소, 등불나무, 작은 작업장, 밭, 우물, 광산, 빈 건설 타일, 안개 잠금 타일이 한눈에 읽혀야 한다.
- 배경은 어둡거나 공포스럽지 않고, 밝은 하늘과 초록 지형으로 모바일 진입성을 유지한다.
- 수상함은 영혼불, 숲 입구, 안개, 작은 문장 배너 정도의 포인트로 제한한다.

## Background Rules

- Home: bright, cozy, expandable.
- Exploration: mysterious, but inviting.
- Hex board: 건물/빈 타일/잠금 타일/자원 노드가 명확해야 한다.
- Props: 성소, 등불, 대나무, 채석장, 허브밭, 우물, 작은 울타리, 배너, 영혼불.
- Palette: fresh green, warm cream stone, sunny gold, coral banner, pale teal spirit light, soft gray fog.

## Implementation Notes

- 현재 캐주얼 성소 피벗의 배경 우선 후보.
- 실제 하우징 UI에서는 중앙 큰 환경 뷰를 `hex tile state` 데이터와 맞춘다: locked, fogged, empty, building, selected, available.
- `수련마당/대나무창고/그림자광맥`은 이 방향에서는 `수련마당/작업장/영혼광맥` 또는 `성소/작업장/채석장`으로 리네이밍하는 편이 자연스럽다.
- Survival 전투 배경은 우측 vignette의 숲 입구/자원 공터 톤에서 더 어둡게 파생한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e976722a08191b4cd82dc39e72768.png`

![Ninja2 casual sanctuary background A](ninja2_casual_sanctuary_background_a.png)
