# Ninja2 Casual Sanctuary Survival Screen A

## Intent

`casual_sanctuary` 피벗의 세로형 모바일 서바이벌 전장 화면 후보. 하우징 홈에서 `탐험 출발`을 누른 뒤 진입하는 별도 전투 화면으로, 숲 탐험지에서 주인공이 적 웨이브를 상대하고 자원/영혼불을 회수하는 구조를 보여준다.

## Art Anchor

- 메인 캐릭터는 하우징 화면과 같은 이마 흉터, 붉은 스카프, 후드 망토, 등불 앵커를 유지한다.
- 전장은 하우징보다 어둡지만 읽기 쉬운 숲길/폐허/영혼불 배경으로 구분한다.
- 적은 공포물이 아니라 캐주얼한 어둠 숲 정령, 가시 덩어리, 변질 버섯, 작은 가면 몬스터 계열이다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 상단에는 캐릭터 HP/자원 바, 타이머, 웨이브, 일시정지/설정을 둔다.
- 좌측에는 미니맵과 획득 버프 스택을 배치한다.
- 우측에는 탐험 목표와 보상 미리보기를 둔다.
- 중앙 55~60%는 실제 전투 공간으로 비워둔다.
- 주인공은 중앙 하단 근처에 두어 적들이 상단/측면에서 접근하는 흐름이 보이게 한다.
- 하단에는 EXP 바, 조이스틱/자동 버튼, 3~4개 스킬 버튼, 우하단 게이지형 궁극/차지 버튼을 둔다.

## UI Direction

- Skill buttons: 등불 폭발, 영혼 돌진, 씨앗 부적, 수호 결계처럼 성소 테마 스킬을 사용한다.
- Combat readability: 적 HP 바, 데미지 숫자, 픽업 자원은 작고 선명하게 유지한다.
- Reward loop: 전장 안에 골드, 목재, 영혼불, 광석 픽업을 보여 하우징 귀환 보상을 암시한다.
- Darkness: 배경은 더 어둡지만, 캐릭터/적/스킬 효과는 명확하게 분리한다.

## Implementation Notes

- 이 화면은 하우징 헥스맵을 절대 보여주지 않는다. 같은 캐릭터와 자원만 공유한다.
- 현재 엔진 표현으로는 `Map` + wave trigger + skill buttons/auto combat HUD 방향으로 해석한다.
- 모바일 세로 화면에서 조이스틱과 스킬 버튼이 하단을 차지하므로, 전투 중심부는 UI에 가리지 않도록 camera pivot을 위로 둔다.
- 생성 이미지의 텍스트는 placeholder다. 실제 구현에서는 짧은 한글 라벨과 숫자만 사용한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e9eae23908191900d89b9fa34f105.png`

![Ninja2 casual sanctuary survival screen A](ninja2_casual_sanctuary_survival_screen_a.png)
