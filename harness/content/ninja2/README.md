# 닌자 서바이벌 2 Content Notes

이 게임은 첫 MVP부터 `Survival + Housing`을 하나의 폐회로로 만든다.

## Core Loop

1. Survival 스테이지에서 오니/도적 웨이브를 처치한다.
2. 클리어 보상으로 골드, 경험치, 영지 목재, 기와석, 그림자 광석을 얻는다.
3. 하우징 홈의 헥스 격자 맵에서 인접 타일을 열고 생산 건물을 배치/강화한다.
4. 영지 생산 노드(`Item.Category=Mine`)는 방치 생산과 전투 보너스 재료를 제공한다.
5. 강화된 전투력/자원 생산으로 다시 하우징 화면에서 출격해 다음 Survival 스테이지에 진입한다.

## Housing 표현 규칙

- 생산형 건물: `Item.Category=Mine`
- 건물 강화 재료: `Item.Category=Material`
- 건물 효과 보상: `Stat` 아이템, `Buff`, 업적 보상 중 현 엔진에 맞는 것을 우선 사용
- 시각적 건물: 필요할 때만 `Unit.Type=Building`으로 추가
- 화면 구조: 하우징은 별도 세로형 홈 화면이며, 헥스 타일 영지를 확장하면서 건물을 짓는 보드로 표현한다.
- 배치 구조: 건물 정의는 13개 blueprint이고, 실제 보드에는 instance를 배치한다. 저장고/수용량/일반 생산 건물은 `repeatable`, 신전/관리/전역 보너스 건물은 `singleton`으로 둔다.
- 전투 진입: 하우징 화면의 `출격` CTA가 별도 Survival 전투 화면으로 이동한다.

## Housing Building Tech

건물 테크트리의 원천 기획은 `harness/design/ninja2/housing-building-tech-v0.yaml`이다.

- D1: 등불 신전만 시작 설치. 목재 작업장은 첫 튜토리얼 건설, 용병 훈련소는 신전/목재 성장 후 두 번째 목표로 둔다.
- D2~D3: 허브 정원, 주민 숙소, 공방, 수호등탑, 정찰소.
- D5~D7: 보급창고, 대나무숲, 철광산.

콘텐츠 draft는 `items/_drafts/200600~200612`에 `Item.Category=Mine`으로 둔다. 실제 하우징 전용 필드(타일 점유, 건설 시간, 레벨업 시간, 주민 배치, 인접 보너스)는 엔진 계약 확장 전까지 `popupArgs.Housing*`와 디자인 YAML에 보관한다.

반복 배치 가능 건물은 `popupArgs.HousingPlacementKind=repeatable`과 `HousingMaxInstancesByLanternLevel`을 가진다. 추가 인스턴스는 각자 건설/레벨업 시간을 갖고, 비용은 기본적으로 인스턴스가 늘어날수록 `cost x1.25`, `time x1.15`로 증가한다.

4X는 별도 시작점이 아니라, 위 Housing 자산을 `Alliance4X`로 확장하는 두 번째 패스다.
