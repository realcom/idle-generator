# Ninja2 Survival Visual Moonlit Density A

## Intent

현재 2D 수호자 에셋을 유지한 채, 전투 화면의 조명/몹 밀도/픽업 밀도를 크게 올리는 어두운 숲 생존 시안.

## Art Anchor

- 주인공은 기존 `guardian_hero`의 갈색 머리, 크림 망토, 붉은 스카프, 손등불을 유지한다.
- 캐릭터를 복면 닌자나 다른 영웅으로 재설계하지 않는다.
- 숲 생물 적과 파란 EXP, 코인, 영혼불, 목재 상자를 유지한다.

## Composition Rules

- Portrait 9:16 모바일 전투 화면.
- 중앙은 등불 aura로 밝히고, 가장자리는 어두운 대나무 숲으로 압박감을 만든다.
- 적과 픽업은 화면 전역에 배치하되 주인공 주변 원형 공간은 읽히게 둔다.

## UI Direction

- 상단 HP/타이머/자원, 하단 조이스틱/스킬/EXP 바의 기존 생존 HUD 문법을 유지한다.
- UI는 검정/금색 프레임으로 고급화하되 플레이필드보다 우선하지 않는다.

## Implementation Notes

- `SurvivalBattle`의 배경 톤다운, edge vignette, pickup glow, VFX trail 강화 패스에 적합하다.
- 런타임에서는 기존 2D 스프라이트를 유지하고, Phaser graphics/tween VFX를 먼저 키운다.
- 다만 어두운 톤이 강하므로 모바일 밝기에서 EXP와 적 실루엣 테스트가 필요하다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb63c-e41e-7353-b747-99fd04c40412/ig_0ec2cfc88bd1f992016a2a95a715948197810e6095572e3196.png`

![Ninja2 survival visual moonlit density A](ninja2_survival_visual_moonlit_density_a.png)
