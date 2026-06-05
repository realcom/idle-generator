# Ninja2 Casual Sanctuary Survivors Scene D

## Intent

`casual_sanctuary` 서바이벌 전투의 우선 2D 인게임 기준안. 캐릭터 키아트보다 실제 플레이 화면 문법을 먼저 고정하기 위해, 평면 탑다운 2D 타일맵, 반복 가능한 적 스프라이트, 픽업, 스킬 쿨다운 HUD를 명확히 보여준다.

## Art Anchor

- 주인공은 작은 SD 성소 수호자 스프라이트다. 크림색 망토 실루엣, 붉은 스카프, 갈색 머리, 손등불을 유지한다.
- 이마 흉터는 전투 줌에서는 작게 보일 수 있으므로, UI 초상과 스킨 원화에서 확실히 유지한다.
- 적은 귀엽지만 약간 수상한 숲 생물이다: 잎 가면 임프, 가시 덩어리, 작은 그림자 정령, 보라 버섯.
- 전투 효과는 등불 불꽃, 영혼불, 원형 결계, 작은 피격 스파크를 사용한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 카메라는 strict orthographic top-down 2D다. 하우징 헥스맵, isometric perspective, 큰 배경 건물, 키아트 구도를 피한다.
- 화면 전체를 전투 가능한 아레나로 보고, 중앙은 이동 공간으로 비운다.
- 적은 사방에서 원형으로 접근하며, 같은 계열 스프라이트가 반복되어 실제 게임 자산처럼 보이게 한다.
- 바닥은 모스/흙/작은 돌/잎 데칼 정도의 반복 가능한 타일감으로 제한한다.
- 픽업은 파란 EXP, 노란 코인, 청록 영혼불, 목재 묶음으로 명확히 구분한다.

## UI Direction

- Top-left: 캐릭터 초상, HP 바, 레벨.
- Top-center: 생존 타이머와 웨이브.
- Top-right: 일시정지, 골드/영혼불 카운터.
- Bottom-left: 반투명 조이스틱.
- Bottom-right: 원형 스킬 쿨다운 3개.
- Bottom: EXP 진행 바.
- UI는 가장자리에 붙이고, 중앙 전투 공간을 가리지 않는다.

## Implementation Notes

- 현재 SurvivalBattle의 우선 구현 기준으로 둔다.
- Phaser/Unity 프로토타입에서는 이 구도를 기준으로 camera pivot을 중앙보다 약간 위에 둔다.
- 전투 플레이어 스프라이트는 `ninja2_spine_gameplay_rig_sheet_b`를 단순화해 사용한다.
- 배경 타일과 적 스프라이트는 개별 PNG atlas로 분리하기 좋게 단순한 외곽선과 제한 팔레트를 유지한다.
- 하우징 화면의 출격 버튼은 이 전장으로 진입하고, 전투 종료 보상은 목재/영혼불/코인/EXP로 귀환한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1eaf3775dc8191bb91d90062edda98.png`

![Ninja2 casual sanctuary survivors scene D](ninja2_casual_sanctuary_survivors_scene_d.png)
