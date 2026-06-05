# Ninja2 Hybrid Spine 3D Housing Scene C

## Intent

하우징을 전투처럼 완전 플랫하게 두지 않고, 3D풍 건물과 2D Spine 캐릭터를 섞는 하이브리드 후보. 플랫 하우징보다 소유감과 업그레이드 만족감이 좋고, 주민 캐릭터가 살아 움직이는 홈 화면으로 보인다.

## Art Anchor

- 하우징은 안전한 성소 홈이며, 서바이벌 전투와 별도 화면이다.
- 건물은 부드러운 3D풍 디오라마 자산처럼 보인다: 등불 신전, 목재소, 허브 정원, 영혼불 샘, 주민 숙소, 공방, 훈련장, 수호탑.
- 캐릭터와 주민은 2D Spine-style 컷아웃으로 건물 위에 얹힌다.
- 주인공 초상은 갈색 머리, 이마 흉터, 크림색 망토, 붉은 스카프, 손등불을 유지한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 중앙 65~70%는 헥스 성소 보드가 차지한다.
- 헥스 상태는 built, selected, empty plus, locked, expandable cost로 구분한다.
- 선택 건물은 cyan outline과 하단 정보 패널이 함께 반응한다.
- 주민은 보드 바깥 장식이 아니라, 건물 사이 경로와 생산 노드 주변에 배치한다.

## UI Direction

- Top-left: 메뉴, 2D 주인공 초상, 레벨/진행도.
- Top-center: 성소 이름/상태.
- Top-right: 코인, 영혼불, 목재, 잎 토큰.
- Left rail: 퀘스트, 우편함.
- Bottom: 선택 건물 생산/수령/업그레이드 패널.
- Bottom-right: 출정 CTA.
- Bottom nav: 성소, 건설, 업그레이드, 주민, 상점.

## Implementation Notes

- 이 시안은 기능 구조와 2D 주민 배치 참고용으로 둔다.
- 최종 하이브리드 기준은 건물의 매력과 2D 캐릭터 대비가 더 좋은 `ninja2_hybrid_spine_3d_housing_scene_d`를 우선한다.
- 3D풍 건물은 실제 3D 런타임으로 시작하기보다, MVP에서는 orthographic render 또는 AI/수작업 sprite atlas로 pre-render하는 편이 안전하다.
- 2D Spine 캐릭터는 y-sort 기준으로 건물 앞뒤를 오가게 하고, 건물 occluder mask는 꼭 필요한 큰 건물에만 둔다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_015cbf919917a6cf016a1ec3e44784819191b791ea8fd33100.png`

![Ninja2 hybrid Spine 3D housing scene C](ninja2_hybrid_spine_3d_housing_scene_c.png)
