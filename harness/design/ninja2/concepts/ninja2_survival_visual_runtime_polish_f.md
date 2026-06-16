# Ninja2 Survival Visual Runtime Polish F

## Intent

현재 Phaser 런타임 화면을 크게 갈아엎지 않고, 배경/이펙트/적 배치만 업그레이드했을 때의 보수적 목표 시안.

## Art Anchor

- 주인공과 일반 적은 현재 2D 에셋 방향을 유지한다.
- 숲 바닥, 자원 픽업, 보스/정예 적 배치를 현재 runtime에 가깝게 둔다.
- 등불 aura와 금색 slash가 주인공의 중심성을 만든다.

## Composition Rules

- 기존 top-down 2D 전투 문법을 유지한다.
- 중앙 hero readability circle, 상단 정예/보스, 가장자리 몹 압박, 전역 EXP/coin pickup을 조합한다.
- 배경은 지금보다 풍부하지만 2.5D나 레드문처럼 급격히 바꾸지 않는다.

## UI Direction

- 현재 상단 profile/timer/resource ledger/progress bar 구조와 가장 유사하다.
- bottom-left joystick, bottom-right skill buttons, bottom EXP bar를 그대로 가져가기 쉽다.

## Implementation Notes

- 가장 빠른 라스트마일 후보. `createWorld`, `drawForestProps`, `skill-vfx.js`, enemy spawn fixture만 조정해도 비슷해질 수 있다.
- 보스 warning circle과 pickup glow를 추가하면 현재 `ninja2_boss_full_centered_qa.png`의 약점을 바로 보완한다.
- D안보다 안전하고, B안보다 현재 뷰와 연결성이 높다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb63c-e41e-7353-b747-99fd04c40412/ig_0ec2cfc88bd1f992016a2a99405fb48197a5d9e01c759aec91.png`

![Ninja2 survival visual runtime polish F](ninja2_survival_visual_runtime_polish_f.png)
