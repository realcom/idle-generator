# Ninja2 Casual Sanctuary Survivors Scene C

## Intent

`casual_sanctuary` 서바이벌 전장을 더 게임 화면처럼 보이도록 다시 잡은 후보. 이전 시안보다 자동 공격, 적 웨이브, 픽업, HUD가 명확하지만, 상단 성소 건물과 배경 밀도가 있어 최종 구현 기준보다는 분위기/라이팅 참고로 둔다.

## Art Anchor

- 주인공은 갈색 머리, 크림색 망토, 붉은 스카프, 손등불 앵커를 유지한다.
- 전장은 하우징 화면과 분리된 숲 공터이며, 사방에서 적이 몰려오는 서바이벌 상태를 보여준다.
- 적은 가시 덩어리, 작은 숲정령, 변질 버섯 계열로 구성한다.
- 공격 VFX는 등불 궤도, 주황색 탄환, 작은 피격 스파크를 중심으로 한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 중앙 전투 공간은 넓게 비우고, 적과 픽업을 외곽에서 안쪽으로 배치한다.
- 상단 배경 건물은 분위기는 좋지만 전장 전용 화면에서는 시야 밀도를 높이므로, 구현용 시안에서는 제거하거나 아주 흐린 장식으로 낮춘다.
- 픽업은 EXP, 영혼불, 코인, 목재가 한눈에 구분되어야 한다.

## UI Direction

- Top-left: 초상, HP, 레벨.
- Top-center: 생존 타이머, 웨이브, 처치 목표.
- Top-right: 일시정지, 재화 카운터.
- Bottom-left: 조이스틱.
- Bottom-right: 3개 스킬 쿨다운 버튼.
- Bottom: EXP 바.

## Implementation Notes

- 분위기/색감은 참고하되, 실제 전장 구현 기준은 `ninja2_casual_sanctuary_survivors_scene_d`를 우선한다.
- 배경 밀도를 20~30% 줄여야 작은 적과 드롭이 더 잘 읽힌다.
- 상단 성소 건물은 하우징 출격 연출이나 전투 입장 컷신에 더 적합하다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1eaea3c3d08191b671bdf5b2fe2215.png`

![Ninja2 casual sanctuary survivors scene C](ninja2_casual_sanctuary_survivors_scene_c.png)
