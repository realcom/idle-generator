# Ninja2 Flat Arcade Housing Hex Scene A

## Intent

전투 `ninja2_flat_arcade_survivors_scene_f`와 맞춘 플랫 아케이드 하우징 후보. 헥스 영지, 생산 말풍선, 업그레이드, 확장 타일, 출정 CTA가 명확해 실제 게임 화면 구조 참고에 좋다.

## Art Anchor

- 하우징은 서바이벌 전장과 별도 화면이다.
- 주인공 초상은 갈색 머리, 이마 흉터, 크림색 망토, 붉은 스카프를 유지한다.
- 성소 테마는 등불 신전, 영혼불 우물, 작업장, 허브밭, 창고, 수련장, 감시 등불로 표현한다.
- 닌자성보다 성소/등불/잎/영혼불 앵커를 우선한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 중앙 65~70%는 헥스 보드가 차지한다.
- 헥스 상태는 built, selected, empty plus, locked, expand cost로 나눈다.
- 선택 건물은 보드의 cyan outline과 하단 정보 패널이 함께 반응한다.
- 출정 CTA는 하단 우측에 고정해 “하우징에서 전투로 간다”는 흐름을 만든다.

## UI Direction

- Top-left: 메뉴, 플레이어 초상, 레벨/진행도.
- Top-center: 성소 상태/이름.
- Top-right: 코인, 영혼불, 목재, 잎 토큰.
- Left rail: 퀘스트, 우편함 등 보조 진입.
- Bottom: 건물 정보, 생산 진행, 업그레이드 비용, 받기 버튼.
- Bottom nav: 홈, 건설, 업그레이드, 주민, 상점.

## Implementation Notes

- 정보 구조와 CTA 위치 참고용으로 둔다.
- 건물 표현이 약간 미니어처/아이소메트릭처럼 보여 최종 플랫 기준은 `ninja2_flat_arcade_housing_hex_scene_b`를 우선한다.
- 실제 구현에서는 건물 장식 디테일을 줄이고, 아이콘 실루엣과 레벨 라벨 중심으로 단순화한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1eb74fd1c081919aff119e595fbb98.png`

![Ninja2 flat arcade housing hex scene A](ninja2_flat_arcade_housing_hex_scene_a.png)
