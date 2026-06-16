# Ninja2 Survival Visual Boss Trial C

## Intent

현재 2D 수호자와 대형 보스 에셋 방향을 살려, Steam 스크린샷에서 한눈에 강하게 보이는 보스 Trial 전투 시안.

## Art Anchor

- 주인공은 기존 수호자 실루엣을 유지한다.
- 보스는 가시/덩굴/숲 오염물 느낌의 거대 적으로, 현재 thorn boss 방향과 연결된다.
- 일반 적은 보스 주위를 압박하지만 주인공과 보스 실루엣을 가리지 않는다.

## Composition Rules

- Hero vs boss의 세로 대치 구도를 만든다.
- 붉은 보스 텔레그래프 원, 금색 투사체, 청록 영혼불로 위험/공격/보상 색을 분리한다.
- 보스는 화면 중앙 상단을 크게 점유하고, 하단은 플레이어 조작/스킬 영역으로 둔다.

## UI Direction

- 상단에는 보스 상태와 타이머가 함께 읽혀야 한다.
- 하단 EXP와 별도 boss progress를 동시에 둘 수 있지만, 실제 구현에서는 너무 많은 바를 정리해야 한다.

## Implementation Notes

- 보스전 마케팅/키샷 후보로 강하다.
- 런타임 우선 작업은 보스 경고 원, boss HP bar, camera shake, hit flash.
- 일반 웨이브 화면 기본안보다는 보스/Trial 모드의 목표 이미지로 쓰기 좋다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb63c-e41e-7353-b747-99fd04c40412/ig_0ec2cfc88bd1f992016a2a9765a068819785e97118779af0e9.png`

![Ninja2 survival visual boss trial C](ninja2_survival_visual_boss_trial_c.png)
