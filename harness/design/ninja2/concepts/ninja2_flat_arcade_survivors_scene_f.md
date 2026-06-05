# Ninja2 Flat Arcade Survivors Scene F

## Intent

`casual_sanctuary` 서바이벌 전투를 아예 플랫한 2D 모바일 아케이드 문법으로 재정의한 우선 후보. 키아트 감성보다 게임 가시성, 대량 적 반복, 드롭 수집감, 구현 난이도를 먼저 잡는다.

## Art Anchor

- 주인공은 작은 SD 성소 수호자다. 갈색 머리, 크림색 망토, 붉은 스카프, 손등불만 남겨 작은 크기에서도 읽히게 한다.
- 흉터는 인게임 전장에서는 억지로 보이게 하지 않는다. 초상, 스킨 원화, 대화 컷에서 유지한다.
- 적은 3종 정도의 반복 가능한 플랫 스프라이트를 우선한다: 주황 잎 꼬마, 검은 숯 정령, 초록 가시 덩어리.
- 큰 장애/스킬 오브젝트는 납작한 가시 철구, 등불 탄환, 잎 부적 궤도로 표현한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 완전 평면 잔디 필드가 기본이다. 숲 배경, 큰 건물, 헥스맵, 원근감을 빼고 화면 전체를 전장으로 쓴다.
- 반복 적은 떼로 배치해 생존 압박을 만든다.
- 파란 EXP 조각은 화면 전체에 흩뿌려 수집 쾌감을 만든다.
- 노란 코인, 목재 상자, 영혼불은 색과 형태가 겹치지 않게 둔다.
- 피해 숫자는 흰색 글자와 검은 외곽선으로 즉시 읽히게 한다.

## UI Direction

- Top-left: 메뉴 버튼과 스킬/아이템 슬롯.
- Top-center: 스테이지/타이머 블록.
- Top-right: 코인/영혼불 카운터.
- Top-wide: 청록색 세그먼트 진행 바.
- Bottom-left: 반투명 조이스틱.
- Bottom-right: 큰 업그레이드/초상 버튼.
- UI는 굵은 검은 외곽선, 단순 면, 높은 대비를 사용한다.

## Implementation Notes

- 현재 SurvivalBattle의 우선 비주얼 방향으로 둔다.
- `scene_d`는 더 풍부한 2D 일러스트형 후보, 이 시트는 실제 양산/프로토타입 기준이다.
- Phaser/Unity 구현 시 배경은 1~2장 타일 또는 단색 plane + decal sprites로 충분하다.
- 적은 개별 Spine보다 sprite sheet 애니메이션이 더 적합하다. 2~4프레임 walk/hit/death만으로도 느낌이 난다.
- 주인공만 Spine 또는 약식 bone rig를 쓰고, 일반 적은 플랫 스프라이트 반복으로 생산비를 낮춘다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1eb0db47308191b4834bcf39547d29.png`

![Ninja2 flat arcade survivors scene F](ninja2_flat_arcade_survivors_scene_f.png)
