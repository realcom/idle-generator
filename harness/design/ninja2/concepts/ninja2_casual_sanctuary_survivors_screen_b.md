# Ninja2 Casual Sanctuary Survivors Screen B

## Intent

`casual_sanctuary` 피벗의 서바이벌 전투 화면을 2D survivors-like 문법으로 재정리한 후보. 이전 `survival_screen_a`가 탐험 RPG 전투처럼 보였던 문제를 줄이고, 몰려오는 적, 자동 공격, 픽업, EXP 성장, 생존 타이머가 중심인 세로 모바일 전장을 목표로 한다.

## Art Anchor

- 메인 캐릭터는 `ninja2_casual_sanctuary_hero_scar_a`의 이마 흉터, 갈색 머리, 크림색 후드 망토, 붉은 스카프, 등불 앵커를 유지한다.
- 전장은 하우징 헥스맵과 분리된 탑다운 2D 숲 공터다.
- 적은 귀엽지만 어두운 숲 정령, 가시 덩어리, 변질 버섯, 작은 가면 임프 계열이다.
- 전투 효과는 성소 테마를 유지한다: 등불 폭발, 영혼 투사체, 씨앗 부적 궤도, 수호 결계.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 카메라는 명확한 top-down/2D arena 감각이어야 하며, 하우징의 isometric hex board를 보여주지 않는다.
- 주인공은 화면 중앙 근처에 작고 읽히는 스프라이트로 둔다.
- 적은 사방에서 몰려오고, 미니맵/화면상 적 분포가 “생존 중”임을 보여준다.
- 중앙 전투 공간은 넓게 비워두고, UI는 가장자리와 하단에 붙인다.
- 픽업 아이템은 골드, 목재, 영혼불, 보석, EXP 오브로 흩뿌린다.

## UI Direction

- Top-left: 캐릭터 초상, HP/특수 자원, 현재 레벨.
- Top-center: 생존 타이머, 웨이브, 진행 스파인.
- Top-right: 일시정지, 설정, 처치/영혼/골드 카운터.
- Left: 미니맵과 획득 버프 스택.
- Bottom: EXP 바, 조이스틱, 3~4개 스킬 쿨다운, 우하단 자동공격/궁극 게이지.
- 스킬 버튼은 장식 카드보다 원형 쿨다운 링을 우선한다.

## Implementation Notes

- 이 화면을 현재 SurvivalBattle 우선 후보로 둔다.
- 장르 계약은 `2D top-down survivors-like arena`: 자동 공격, 웨이브, 지속 생존, 픽업, 레벨업 선택, 스킬 쿨다운.
- Unity/Phaser 구현 시 전투 중심부가 하단 UI에 가리지 않도록 camera pivot을 약간 위로 둔다.
- UI 텍스트는 생성 이미지의 placeholder를 그대로 쓰지 말고, 짧은 한글 라벨로 재작성한다.
- 하우징의 출격 CTA는 이 화면으로 이동하며, 전투 종료 보상은 하우징 생산/확장 자원으로 귀환한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1ea174015481919a9e797939313964.png`

![Ninja2 casual sanctuary survivors screen B](ninja2_casual_sanctuary_survivors_screen_b.png)
