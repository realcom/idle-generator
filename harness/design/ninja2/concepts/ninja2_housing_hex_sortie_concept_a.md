# Ninja2 Housing Hex Sortie Concept A

## Intent

`ninja2`의 하우징 홈 화면 후보 시안. 하우징은 별도 홈/영지 화면이며, 플레이어는 헥스 격자 맵에 건물을 짓고 인접 타일을 열어 영지를 넓힌 뒤 `출격`으로 서바이벌 전투 화면에 진입한다.

## Art Anchor

- 기존 닌자 IP의 캐주얼하고 굵은 외곽선 캐릭터 감각을 유지한다.
- 영지는 따뜻한 닌자 은신처로 보이되, 배경 그림이 아니라 조작 가능한 전략 보드처럼 읽혀야 한다.
- 주요 건물 앵커는 도장, 훈련장, 목재소/창고, 그림자 광산, 등불 신사다.
- 바깥쪽 잠금 타일은 안개, 자물쇠, 확장 비용 칩으로 표시해 성장 목표를 만든다.

## Composition Rules

- Portrait 9:16 모바일 화면 기준.
- 화면 중앙 70% 이상은 헥스 보드가 차지한다.
- 중앙 도장 주변에 생산 건물과 빈 건설 가능 타일을 배치한다.
- 외곽 타일은 잠금/안개 상태로 두어 확장 방향을 보여준다.
- 상단은 재화 바, 좌측은 플레이어/미션, 우측은 설정/우편 같은 보조 버튼으로 제한한다.
- 하단에는 `영지`, `건설`, `업그레이드`, `스킬`, `상점` 탭을 두고, 전투 진입은 큰 `출격` 버튼으로 분리한다.

## UI Direction

- 선택된 건물은 헥스 위 라벨과 중앙 하단의 compact info panel이 함께 반응한다.
- 건물 라벨은 `Lv`, 생산 아이콘, 남은 시간만 보여주고 긴 설명은 빼야 한다.
- 빈 타일은 `+ 건설 가능`, 잠금 타일은 `확장 필요 + 비용`으로 상태를 즉시 구분한다.
- `출격` 버튼은 하우징 화면에서 가장 강한 CTA이며, 서바이벌 전투가 별도 화면임을 나타내는 검/화살표 아이콘을 사용한다.
- `건설 모드`는 좌하단 보조 버튼으로 두어 헥스 선택/배치 모드 전환을 담당한다.

## Implementation Notes

- Unity/Phaser 구현 시 헥스 좌표는 axial 또는 offset coordinate로 관리한다.
- 각 타일 상태는 `locked`, `fogged`, `empty`, `building`, `selected`, `available` 정도로 분리한다.
- 현재 콘텐츠 데이터의 Housing 생산 노드(`수련마당`, `대나무창고`, `그림자광맥`)는 이 보드의 building tile로 매핑한다.
- 서바이벌 전투 화면은 별도 concept으로 만든다. 이 화면 안에 전투 UI를 섞지 않는다.
- 실제 구현 텍스트는 더 짧게 다듬고, 생성 이미지의 한글/숫자는 구조 참고용으로만 사용한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e8712-1b4b-78c1-9431-b9afb7ad2fe0/ig_09083b92b346bdac016a1e80f3174c8191810175352286bd8a.png`

![Ninja2 housing hex sortie concept A](ninja2_housing_hex_sortie_concept_a.png)
