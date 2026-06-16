# Ninja2 Sanctuary Build Modal A

## Intent

`ninja2` 하단 `성소` 버튼에서 열리는 건설 모달 후보. 현재 지을 수 있는 건물 후보는 자원 부족 상태여도 숨기지 않고 모두 보여주며, 하단에는 이미 지어진 건물 정보를 고정 영역으로 노출한다. 설명문형 `desc` 카피는 제거하고 카드/칩/버튼만으로 상태를 읽게 한다.

## Art Anchor

- 기준 모달 문법은 `ninja2_phaser_modal_system_a`의 양피지 패널, 짙은 잉크 외곽선, 랜턴 문장, 잎 장식, 원형 닫기 버튼이다.
- 화면 맥락은 `ninja2_rulelocked_housing_home_a`의 성소 홈 화면이다.
- 생성 이미지 안의 텍스트는 최종 문구가 아니며, 최종 런타임 라벨은 `건설 후보`와 `보유 건물` 계열로 정리한다.
- 건물 썸네일은 청록 지붕, 따뜻한 등불, 굵은 외곽선으로 Ninja2 하우징의 소유감을 유지한다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 941x1672.
- 모달은 화면 중앙의 큰 parchment shell로 두고, 뒤쪽 하우징 HUD와 하단 도크는 어두운 스크림 아래에 남긴다.
- Header는 짧은 제목만 사용한다. 부제, 안내문, 긴 설명문은 넣지 않는다.
- Body 상단은 세로 스크롤 가능한 `건설 후보` 리스트다.
- Body 하단은 고정 `보유 건물` shelf다. 후보 리스트 스크롤에 밀려 사라지지 않는다.
- 후보 행, 보유 카드, 비용 칩, 액션 버튼은 안정 치수를 가진 슬롯으로 구성한다.

## UI Direction

- Candidate row: 상태 아이콘, 건물 썸네일, 이름, 짧은 레벨/슬롯 배지, 비용 칩, 우측 액션 버튼.
- 자원이 부족한 후보는 숨기지 않고 비용 칩만 붉은 부족 상태로 표시한다. 액션 버튼은 disabled 스타일을 사용한다.
- 건설 슬롯이나 인구/주민 조건은 작은 배지로 처리한다.
- Owned shelf: 건물 썸네일, 이름, 레벨, 생산량/효과/타이머 칩을 2줄 이하로 표시한다.
- 잠긴 슬롯은 하단 shelf의 마지막 카드처럼 잠금 카드로 보여줄 수 있다.
- 하단 `슬롯 확장` 같은 보조 액션은 shelf 아래의 단일 footer button으로 둔다.

## Implementation Notes

- 이 시안은 baked bitmap이 아니라 Phaser/HTML 슬롯형 UI로 구현해야 한다.
- `ninja2.ui.panel.parchment_9slice` 계열 shell을 재사용하고, 후보 행/card만 리스트 variant로 확장한다.
- 건설 후보 필터는 해금/슬롯/규칙 기준만 적용한다. 재화 부족은 필터가 아니라 disabled state로 표현한다.
- `desc` 필드는 렌더링하지 않는다. 필요 정보는 칩과 짧은 라벨로만 노출한다.
- 건물이 하나도 없거나 후보가 비어도 모달 shell은 반드시 열린다. 빈 상태는 짧은 empty row나 locked card로 처리한다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- `homeBuildModal`은 기존 DOM overlay prototype을 유지하되, 공통 `home-modal-*` shell class와 `PhaserModalSystem` 방향으로 수렴시킨다.
- 모바일에서는 후보 리스트만 스크롤하고 modal header, owned shelf, footer action은 고정한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ea4a5-ee60-7891-97b1-34deadd1e4ec/ig_085a8dbce722f5bb016a261c58757c8191b08f35e536be7c6f.png`

![Ninja2 sanctuary build modal A](ninja2_sanctuary_build_modal_a.png)
