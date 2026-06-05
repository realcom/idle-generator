# Mushroomer Skill Tree Modal Concept B

## Intent

`mushroomer` 스킬 모달을 3-lane 분기 트리로 재정리한 후보 시안. 기존 카드 그리드보다 선행 조건, 잠금 상태, 선택 스킬의 다음 행동이 즉시 읽히도록 만드는 것이 목표다.

## Art Anchor

- `idlez` 햄스터 UI의 warm carved wood, cream parchment, gold CTA, leaf-green action button을 유지한다.
- 햄스터가 전투 화면과 스킬 아이콘 양쪽에서 먼저 읽히고, 버섯/잎/포자는 스킬 속성 장식으로만 사용한다.
- 스킬 노드는 포자, 불씨, 회복, 달빛, 유성처럼 색상만 봐도 성격이 갈리는 아이콘을 사용한다.
- 두꺼운 dark chocolate outline, flat 2D mobile rendering, 둥근 한글 게임 UI 감성을 유지한다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 배경 전투는 어둡게 눌러 모달의 정보 계층을 우선한다.
- 모달 순서는 `타이틀 > 성장/포인트 요약 > 장착 슬롯 > 3-lane 스킬트리 > 선택 상세 > CTA`로 고정한다.
- 스킬트리는 공격, 지원, 궁극기 3개 lane으로 분리하고 각 lane의 세로 연결선을 강하게 보여준다.
- 선행 학습된 노드는 green check, 선택 노드는 gold ring, 잠긴 노드는 dark brown lock card로 명확히 구분한다.

## UI Direction

- Summary row: 레벨, XP, 스킬 포인트, 초기화 버튼을 한 줄에 묶는다.
- Equipped row: 장착 슬롯을 트리 위에 두어 "해금한 스킬을 슬롯에 넣는다"는 흐름을 먼저 인식시킨다.
- Tree body: 루트 노드에서 3개 lane으로 갈라지는 덩굴 연결선을 사용한다. 카드는 작아도 연결선은 굵게 유지한다.
- Detail panel: 선택한 스킬의 아이콘, 현재/다음 레벨, 효과 변화, 비용을 한 덩어리로 표시한다.
- CTA: `장착하기`는 green secondary, `레벨 업`은 gold primary로 분리한다.

## Implementation Notes

- 실제 Phaser 모달에서는 3열 트리 + 하단 sticky detail panel이 가장 안전하다.
- 노드당 텍스트는 이름 1줄, `Lv.N/5`, 잠금 레벨 정도만 유지한다.
- 장착 슬롯은 현재 quickbar와 같은 스킬 아이콘 PNG를 재사용하고, 쿨다운 링만 CSS/Phaser vector로 얹는다.
- 스킬 포인트 부족 시 gold CTA를 비활성화하지 말고 비용 chip을 붉게 바꿔 이유가 먼저 보이게 한다.
- 이 시안은 구현 난도가 낮은 안정형 후보이며, 강한 판타지 트리 감각은 Concept C가 더 좋다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8377-a60f-7073-99f9-013609da4b10/ig_0637247fc600b941016a1d8fd63f448191a54bf9262cbf6836.png`

![Mushroomer skill tree modal concept B](mushroomer_skill_tree_modal_concept_b.png)
