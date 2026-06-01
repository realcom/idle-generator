# Mushroomer Skill Tree Modal Concept A

## Intent

`mushroomer` Phaser 스킬트리 모달의 후보 시안. 전투 화면 위에 뜨는 중앙 모달로, 스킬 슬롯 해금, 스킬 레벨업, 자동 사용, 장착 관리를 한 화면에서 읽히게 하는 방향이다.

## Art Anchor

- 기존 `idlez` 햄스터 UI의 warm carved wood, cream parchment, gold CTA, leaf-green action button을 유지한다.
- 캐릭터는 황금 햄스터가 먼저 보이고, 버섯/포자/잎 장식은 스킬 시스템의 보조 정체성으로 사용한다.
- 스킬 아이콘은 포자, 이끼, 달빛, 유성, 심장, 돌 같은 색상별 판독성을 가진다.
- 두꺼운 dark chocolate outline과 flat 2D mobile game rendering을 유지한다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 배경 전투는 어둡게 눌러 모달 가독성을 우선한다.
- 모달은 화면 높이 약 70%를 차지하고, 상단 타이틀, 요약, 장착 슬롯, 스킬 트리, 하단 CTA 순서로 쌓는다.
- 장착 슬롯은 트리보다 위에 두어 "선택한 스킬이 자동 사용 슬롯에 들어간다"는 관계를 먼저 보여준다.
- 스킬 카드들은 4열 x 3행 그리드로 두되, 세로 연결선과 작은 단계 점으로 트리 감각을 만든다.
- 하단 CTA는 자동 사용, 레벨 업, 장착 관리 3개로 분리한다.

## UI Direction

- Summary row: 플레이어 레벨, 경험/성장 진행, 스킬 포인트, 초기화 비용을 한 줄에 묶는다.
- Equipped row: 열린 슬롯은 선명한 아이콘과 Lv. 배지를, 잠긴 슬롯은 큰 자물쇠와 해금 레벨을 표시한다.
- Tree cards: 카드 내부는 아이콘, Lv., 단계 점, 순번 배지를 중심으로 하며 긴 설명은 뺀다.
- Action buttons: `자동 사용`은 green ON/OFF 상태, `레벨 업`은 gold primary CTA, `장착 관리`는 green secondary CTA.
- Bottom tab: 스킬 탭은 glow와 책/잎 아이콘으로 현재 위치를 명확히 한다.

## Implementation Notes

- Phaser 모달은 현재 420px wide overlay 기준이므로 카드 4열을 그대로 쓰기보다, 실제 구현에서는 3열 + 스크롤 또는 4열 compact variant를 선택한다.
- 현재 런타임에 있는 `skill_*` PNG 아이콘을 카드/슬롯에 적용하고, lock 카드만 CSS/Phaser vector로 처리해도 충분하다.
- 스킬 포인트 부족 상태는 버튼 라벨을 `부족 N`처럼 즉시 바꾸고 toast를 함께 띄운다.
- 장착 슬롯 해금 조건은 Lv.8, Lv.20, Lv.40을 슬롯 카드에 직접 노출한다.
- 텍스트는 실제 구현에서 짧은 한글 라벨로 재배치한다. 생성 이미지의 긴/부정확한 글자는 구조 참고용이다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8278-4da0-7d92-848a-c895c74469bd/ig_054fb9c83fb11050016a1d603d088c8191b955142f13780051.png`

![Mushroomer skill tree modal concept A](mushroomer_skill_tree_modal_concept_a.png)
