# Ninja2 Survival Visual Flat Runtime B

## Intent

현재 2D 주인공 에셋을 가장 안전하게 살리는 구현형 플랫 아케이드 생존 시안. 기존 `flat_arcade_survivors_scene_f`보다 배경과 이펙트를 풍부하게 하되 생산성을 유지한다.

## Art Anchor

- 주인공은 기존 수호자 에셋처럼 크림 망토, 붉은 스카프, 손등불이 먼저 읽혀야 한다.
- 적은 반복 가능한 2D 스프라이트 군집으로 유지한다.
- 파란 EXP 보석과 금색 투사체가 화면 리듬을 만든다.

## Composition Rules

- Strict top-down 2D 모바일 전투.
- 밝은 숲 바닥을 쓰되 가장자리에 식생 프레임을 두어 평평함을 줄인다.
- 적, EXP, 코인, 영혼불을 충분히 많이 깔아 survivor-like 압박을 만든다.

## UI Direction

- 기존 런타임 HUD 구조와 가장 잘 맞는 안이다.
- 좌측 보조 패널은 실제 구현 시 줄이고, 상단/하단 edge HUD로 정리한다.

## Implementation Notes

- 1차 런타임 적용 후보. 배경 decal, 몹 수, EXP trail, kunai/shuriken trail만 바꿔도 체감이 크다.
- `skill-vfx.js`의 projectile/orbit/slash 계열을 조금 더 길고 밝게 조정하면 근접하게 갈 수 있다.
- 캐릭터와 적은 기존 방향 스프라이트/걷기 시트를 그대로 활용한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb63c-e41e-7353-b747-99fd04c40412/ig_0ec2cfc88bd1f992016a2a9652ea7c819791c1e5137705e214.png`

![Ninja2 survival visual flat runtime B](ninja2_survival_visual_flat_runtime_b.png)
