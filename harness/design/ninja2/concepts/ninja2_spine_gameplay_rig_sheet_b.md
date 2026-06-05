# Ninja2 Spine Gameplay Rig Sheet B

## Intent

`casual_sanctuary` 메인 캐릭터의 우선 리깅 기준안. 키아트의 분위기를 직접 게임에 넣으려 하지 않고, Spine/2D bone animation으로 제작 가능한 단순 SD 캐릭터로 재해석한다.

## Production Priority

- 현재 게임용 캐릭터 제작 기준은 이 시트를 우선한다.
- `ninja2_casual_sanctuary_hero_scar_a`는 키아트/브랜드 기준, `ninja2_spine_gameplay_character_sheet_a`는 매력 보조 기준, 이 문서는 실제 파츠/리깅 기준이다.
- 정면 neutral pose를 전투 idle의 기준 자세로 삼고, 측면/후면은 이동 방향 테스트와 스킨 제작 참고로 쓴다.

## Rigging Rules

- 몸통은 상의/망토/후드/스카프를 분리하되, 전투 스프라이트에서는 장식선을 30~40% 줄인다.
- 얼굴은 head, eyes, mouth, scar overlay로 분리한다. 흉터는 항상 유지되는 주인공 식별자다.
- 머리는 front bangs, side hair, back hair, top tuft 정도로 압축한다.
- 팔은 upper arm, forearm, hand를 좌우로 분리한다. 손 포즈는 기본 open, fist, thumbs-up 정도면 충분하다.
- 다리는 thigh, shin/wrap, boot를 좌우로 분리한다. 작은 화면에서 무릎 디테일은 과감히 줄인다.
- 망토 아래 자락, 스카프 꼬리, 등불 줄은 보조 bone으로 흔들림을 줄 수 있다.
- 펜던트와 등불은 캐릭터의 실루엣을 살리는 액세서리지만, 피격/회피 애니메이션에서 몸통을 가리지 않게 둔다.

## Combat Readability

- 2D survivors-like 전투 화면에서는 이마 흉터가 작아질 수 있으므로 붉은 스카프와 손등불을 함께 식별자로 유지한다.
- 공격 VFX는 등불/영혼불/부적 궤도 계열로 잡고, 검술 중심 닌자 이미지를 줄인다.
- 캐릭터는 중앙에서 항상 밝은 크림색 망토 실루엣이 읽혀야 한다.
- 적과 배경이 어두워질수록 펜던트/등불의 warm glow가 주인공 focus marker 역할을 한다.

## Follow-Up Asset Tasks

- 정면 idle용 파츠 PNG 추출.
- 8방향 이동이 필요하면 좌/우 3/4 view를 추가 생성.
- 표정 세트: neutral, smile, focus, hurt, victory.
- 전투 애니메이션: idle, run, cast, hit, pickup, level-up, return-home.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1eacd7dc3881918c908613767c36b9.png`

![Ninja2 spine gameplay rig sheet B](ninja2_spine_gameplay_rig_sheet_b.png)
