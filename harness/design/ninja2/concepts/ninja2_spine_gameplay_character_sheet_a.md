# Ninja2 Spine Gameplay Character Sheet A

## Intent

`casual_sanctuary` 피벗의 메인 캐릭터를 실제 게임 스프라이트/Spine 제작으로 내리기 위한 SD 스타일 가이드. 키아트 `ninja2_casual_sanctuary_hero_scar_a`의 매력 앵커를 유지하되, 모바일 전투 화면에서 읽히는 비율과 파츠 단순화를 우선한다.

## Art Anchor

- 핵심 식별자는 따뜻한 갈색 머리, 이마의 잎/불꽃형 흉터, 크림색 후드 망토, 모스그린 안감, 붉은 스카프, 원형 펜던트, 손등불이다.
- 얼굴은 밝고 호감형으로 유지한다. 전투 캐릭터라도 사납거나 복수극처럼 보이지 않는다.
- 전체 비율은 머리 40~45%, 몸통 35%, 다리 20~25% 정도의 모바일 SD 체형을 목표로 한다.
- 큰 칼, 검은 복면, 체크무늬 외투, 특정 애니메이션식 장신구는 피한다.

## Spine Notes

- 이 시트는 매력/비율/표정 기준용이며, 최종 리깅 기준은 `ninja2_spine_gameplay_rig_sheet_b`를 우선한다.
- 헤어 조각은 현재보다 줄인다. 최종본은 앞머리 3~4개, 뒷머리 2~3개, 꼭지 실루엣 1개 정도가 적당하다.
- 스카프, 망토, 등불은 짧은 idle motion을 줄 수 있는 보조 파츠로 유지한다.
- 이마 흉터는 얼굴 텍스처에 붙여도 되지만, 스킨 교체와 표정 교체가 잦다면 별도 overlay 파츠로 둔다.
- 부츠/장갑/허리 파우치는 작은 화면에서 복잡해 보이면 실루엣만 남긴다.

## Usage

- 캐릭터 선택창, 프로필 초상, 상점 스킨 프리뷰의 스타일 기준으로 사용한다.
- 전투용 Spine 제작 시에는 이 시트의 감정/매력은 살리고, 파츠 분리는 `rig_sheet_b` 구조에 맞춘다.
- UI 초상 crop은 하단 우측 bust 또는 좌측 full-body 얼굴을 기준으로 테스트한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1eac3bb6c88191ace446e1a627a0c4.png`

![Ninja2 spine gameplay character sheet A](ninja2_spine_gameplay_character_sheet_a.png)
