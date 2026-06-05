# Mushroomer Skill Tree Modal Concept C

## Intent

`mushroomer` 스킬 모달을 지도형 스킬트리처럼 보이게 만든 후보 시안. 플레이어가 노드를 따라 내려가며 성장 경로를 고르는 느낌을 주고, 잠금/해금/선택/강화를 한 화면에서 직관적으로 판단하게 한다.

## Art Anchor

- 기존 햄스터 성장 UI의 carved wood frame, parchment sheet, gold title plaque, leaf accent를 유지한다.
- 스킬트리의 주 재료는 덩굴과 뿌리이며, 버섯/포자 요소는 노드 아이콘과 배경 패턴으로만 얹는다.
- 햄스터 얼굴과 볼주머니 스킬 아이콘을 중심으로 삼아, 버섯 게임이어도 햄스터-first 정체성을 잃지 않는다.
- 궁극기 노드는 달빛/별/황금 계열로 크게 처리해 수집 목표가 멀리서도 보이게 한다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 모달은 화면 대부분을 차지하지만 전투 배경이 상단 가장자리에서 살아 있어 "전투 위 팝업" 감각을 유지한다.
- 상단은 포인트/레벨/초기화, 그 아래는 장착 스킬 rail, 중앙은 지도형 트리, 하단은 선택 상세와 CTA로 구성한다.
- 트리 중앙에는 큰 core node를 두고, 좌/중/우 경로가 휘어진 뿌리처럼 이어진다.
- 오른쪽에는 얇은 progress spine 또는 미니맵을 둬 스크롤 가능한 큰 트리처럼 보이게 한다.

## UI Direction

- Learned node: 녹색 check badge와 밝은 rim.
- Selected node: 금색 halo, 큰 아이콘, 하단 상세 패널과 시각적으로 연결.
- Locked node: 잠금 badge와 `Lv.N` gate chip을 노드 가까이에 배치.
- Ultimate node: 보라/파랑/금색 외곽 장식으로 일반 노드와 등급 차이를 만든다.
- Equipped rail: 4개 슬롯을 타이틀 아래 고정하고, 각 슬롯에 cooldown ring과 level badge를 붙인다.
- Sticky detail panel: 선택 스킬 이름, 레벨 pips, 핵심 효과 1줄, 선행 스킬, 필요 비용, `장착하기`, `업그레이드`를 담는다.

## Implementation Notes

- Concept C를 구현 타깃으로 삼을 경우, 중앙 트리는 단순 CSS grid보다 절대 좌표 노드 + SVG/Canvas connector가 자연스럽다.
- Phaser DOM overlay에서는 노드 좌표를 데이터 배열로 관리하고, connector는 `svg path` 또는 Phaser graphics로 그리는 방식이 적합하다.
- 941x1672 생성물 기준으로는 텍스트가 많은 편이므로 실제 구현에서는 노드 이름을 더 줄이고 툴팁/상세 패널로 설명을 밀어낸다.
- 오른쪽 progress spine은 기능 구현이 늦어도 장식형으로 먼저 넣을 수 있다. 스크롤 위치 표시까지 연결하면 체감 품질이 오른다.
- 하단 CTA는 safe area를 고려해 최소 64px touch height를 유지한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8377-a60f-7073-99f9-013609da4b10/ig_0637247fc600b941016a1d907fa8d08191b3d99aa227297643.png`

![Mushroomer skill tree modal concept C](mushroomer_skill_tree_modal_concept_c.png)
