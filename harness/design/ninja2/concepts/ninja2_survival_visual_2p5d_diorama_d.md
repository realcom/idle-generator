# Ninja2 Survival Visual 2.5D Diorama D

## Intent

현재 2D 주인공을 유지하면서 배경만 2.5D 디오라마처럼 고급화할 수 있는지 확인하는 실험 시안.

## Art Anchor

- 주인공은 2D sprite billboard처럼 보이며 기존 수호자 디자인을 유지한다.
- 적도 2D 스프라이트처럼 보여야 하며, 배경만 깊이감과 조명을 더한다.
- 등불, 영혼불, 금색 투사체가 2D/2.5D를 시각적으로 묶는다.

## Composition Rules

- 살짝 기울어진 top-down/isometric 느낌을 허용한다.
- 사찰 계단, 석등, 대나무, 돌바닥으로 고급 배경 레이어를 만든다.
- 주인공 주변에는 명확한 전투 원형 공간을 둔다.

## UI Direction

- UI는 기존 edge HUD를 유지하되 배경의 고급감을 가리지 않게 최소화한다.
- 2.5D 배경을 쓰더라도 조이스틱/스킬 버튼은 현재 모바일 문법을 유지한다.

## Implementation Notes

- 가장 큰 그래픽 도약 후보. 다만 현재 Phaser 전투의 strict 2D와 충돌할 수 있어 runtime prototype 검증이 필요하다.
- 구현한다면 배경을 한 장의 고해상도 bitmap + 별도 collision/ground plane으로 두고, 캐릭터는 기존 sprite layer에 둔다.
- Unity 쪽으로 확장할 때도 2D sprite + painted 2.5D background 방식으로 이식 가능하다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb63c-e41e-7353-b747-99fd04c40412/ig_0ec2cfc88bd1f992016a2a9833f6f08197a15ea16daac0c330.png`

![Ninja2 survival visual 2.5D diorama D](ninja2_survival_visual_2p5d_diorama_d.png)
