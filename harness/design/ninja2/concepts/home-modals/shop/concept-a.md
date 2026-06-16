# Home Cash Shop Modal Concept A

## Intent

`ninja2` 하단 `상점` 탭에서 열리는 현금 결제 상품 모달의 첫 시안. 목표는 기존 재화 교환 보급소가 아니라 실제 IAP 상품 리스트로 읽히게 만드는 것이다. 루비, 초심자 성소 팩, 에너지 회복, 광고 제거권을 한 화면에서 비교하고 구매 CTA까지 바로 보이게 한다.

## Art Anchor

- `ninja2_phaser_modal_system_a`와 `ninja2_sanctuary_build_modal_a`의 parchment shell, 굵은 잉크 외곽선, 랜턴/잎 장식, 원형 닫기 버튼을 따른다.
- 배경은 어두운 숲 성소 홈을 스크림 아래에 남겨 현재 탭 맥락을 유지한다.
- 상품 아이콘은 캐릭터 얼굴이 아니라 루비 주머니, 성소 보급함, 에너지 병, 광고 제거 부적 같은 object-only 소재로 둔다.
- 생성 이미지의 한글/가격은 구조 참고용이며, 최종 런타임 문구/가격은 Product 데이터와 native DOM 텍스트에서 온다.

## Composition Rules

- Portrait 9:16 target.
- 상단은 작은 현금 상점 kicker와 큰 `상점` 타이틀, 우상단 X 닫기 버튼으로 고정한다.
- Body는 4개의 세로 상품 행을 같은 높이로 배치한다.
- 각 상품 행은 좌측 원형 icon well, 중앙 상품명/보상 요약, 우측 가격 pill/구매 버튼으로 분리한다.
- 하단 도크는 스크림 아래에 남기고 `상점` 탭을 선택 상태로 둔다.

## UI Direction

- Purchase row: 아이콘, 상품명, 핵심 구성품 1~2줄, 구매 제한 badge, KRW 가격 pill, orange purchase button.
- 1회 상품은 작은 lock/account badge로 구매 제한을 표시한다.
- 루비/성장 재화/에너지/광고 제거는 서로 다른 실루엣으로 구분한다.
- 긴 마케팅 문구는 넣지 않는다. 상품 가치는 보상 요약과 가격만으로 비교되게 한다.

## Implementation Notes

- 이 시안은 baked bitmap이 아니라 HTML/Phaser 슬롯형 UI로 구현해야 한다.
- 상품명, 가격, 보상 수량, 구매 제한, 버튼 라벨은 런타임 native text로 둔다.
- 상품 아이콘은 `ninja2.ui.shop_product_icons.cash_v1` 같은 생성 이미지 에셋으로 분리한다.
- Concept A는 상점 정보 구조는 좋지만 닌자 캐릭터/전투 탭 분위기가 조금 강해 최종 후보는 Concept B를 우선한다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Proposed source split: `harness/runtime/src/survivor/home-modals/shop.js`.
- Proposed UI spec: `harness/runtime/specs/ui/ninja2/home-modals/shop.yaml`.
- Bottom `상점` tab opens the modal; the shared `homeFeatureScreen` should not own product rendering.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb9c7-948e-74f1-ba24-1fa7b543dfd3/ig_0d953fc2dd9416ba016a2b7ff38e548196880da55deb640a5a.png`

![Home cash shop modal concept A](concept-a.png)
