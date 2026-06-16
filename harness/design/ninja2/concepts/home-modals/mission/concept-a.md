# Home Mission Modal Concept A

## Intent

하단 `임무` 탭에서 열리는 독립 모달 시안. 현재 런타임의 일일 임무 리스트를 홈 전면 패널이 아니라 공통 모달 패밀리 안으로 옮기는 방향을 잡는다. 플레이어는 오늘 받을 수 있는 보상, 진행 중인 목표, 이미 받은 항목을 한눈에 확인해야 한다.

## Art Anchor

- `ninja2_phaser_modal_system_a`의 크림색 양피지 shell, 짙은 잉크 외곽선, 랜턴 문장, 잎 장식, 원형 닫기 버튼 문법을 따른다.
- 배경은 `ninja2_rulelocked_housing_home_a` 계열의 어두운 숲 성소 홈이며, 스크림 아래에 흐릿하게 남긴다.
- 임무 아이콘은 목재, 신전, 두루마리, 광산, 보급 주머니처럼 성소 루프에서 바로 읽히는 소재를 쓴다.
- 생성 이미지 안의 한글/숫자는 최종 UI 문구가 아니며, 구조와 비례만 참고한다.

## Composition Rules

- Portrait 9:16 target.
- 모달은 화면 중앙의 큰 parchment shell이며, 하단 도크는 어두운 스크림 아래에 남겨 현재 탭 맥락을 유지한다.
- Header는 짧은 kicker, 큰 `임무` 타이틀, 우상단 `X` 닫기 버튼으로 고정한다.
- Body는 5개 내외의 세로 임무 행을 보여주며, 목록만 내부 스크롤 가능하게 한다.
- Footer는 다음 갱신까지 남은 시간이나 짧은 상태 힌트만 둔다.
- 한 행 안의 아이콘, 진행도, 보상, 액션 버튼은 안정 치수 슬롯으로 분리한다.

## UI Direction

- Mission row: 좌측 사각 아이콘, 중앙 제목/조건/진행 바, 우측 보상 칩과 claim 버튼.
- Claimable state: 행 테두리와 버튼에 lantern-gold glow를 준다.
- Active state: 일반 parchment row와 green progress bar를 쓴다.
- Claimed state: 채도 낮은 row, 비활성 보상 칩, 큰 check mark로 처리한다.
- Reward chips는 목재, 골드, 영혼불, 석재 아이콘을 재사용하고 수량은 런타임 텍스트로 둔다.
- 긴 설명문은 넣지 않는다. 미션 조건은 한 줄, 보상은 칩으로 끝낸다.

## Implementation Notes

- 이 시안은 baked bitmap이 아니라 Phaser/HTML 슬롯형 모달로 구현해야 한다.
- 공통 `home-modal-*` shell과 `ninja2.ui.panel.parchment_9slice`를 재사용한다.
- 모달 전용 파일로 분리할 때 `mission` 모듈은 미션 정의, 상태 계산, 행 렌더, 액션 핸들러만 소유한다.
- 텍스트, 진행도, 보상 수량, 버튼 라벨은 런타임 native layer로 유지한다.
- 기존 `homeFeatureScreen` 공유 패널에서 `mission` 모달 파일로 옮기는 것이 후속 구현 목표다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Proposed source split: `harness/runtime/src/survivor/home-modals/mission.js`.
- Proposed UI spec: `harness/runtime/specs/ui/ninja2/home-modals/mission.yaml`.
- The bottom `임무` tab should open this modal family instead of rendering mission content inside the shared `homeFeatureScreen`.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb679-880b-7f12-8e6c-aa28d06a0b1b/ig_06c448e25811fe79016a2b31686930819194aa1f99b9d27c16.png`

![Home mission modal concept A](concept-a.png)
