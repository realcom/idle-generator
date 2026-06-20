# Home Cash Shop Modal Concept C

## Intent

`ninja2` 홈 화면의 `상점` 탭에서 열리는 Phaser 상점 모달을 더 모바일 게임 상점답게 확장한 후보. 기존 B안의 현금 상품 리스트를 유지하되, 상단 카테고리 탭, 타임특가 배너, 할인 배지, 2열 추천 카드, 빠른 구매 리스트를 한 모달 안에 배치해 다양한 상품군을 수용한다.

## Art Anchor

- `ninja2_home_cash_shop_modal_b`의 성소 보드 배경, parchment modal family, object-only 상품 아이콘, KRW price pill, orange purchase CTA를 계승한다.
- `ninja2_phaser_modal_system_a`의 고정 랜턴 문장, 잎 장식, 굵은 잉크 외곽선, 모달 스크림 규칙을 따른다.
- 배경에는 홈 top resource band와 bottom five-tab dock을 흐리게 남기고, `상점` 탭 선택 상태를 유지한다.
- 상품 이미지는 기존 `ninja2.ui.shop_product_icons.cash_v1` 계열과 side pass 아이콘을 재사용하는 방향이다.

## Composition Rules

- Portrait 9:16 target, concept render size 1080x1920.
- Modal은 화면 중앙을 크게 차지하되 상단 자원 바와 하단 탭 dock의 맥락이 남아야 한다.
- Header는 `현금 결제 상품` kicker, 큰 `상점` title, close button, 보너스/상태 chip으로 구성한다.
- Header 아래에는 icon-first category tabs를 둔다: `추천`, `패키지`, `루비`, `에너지`, `패스`.
- 첫 화면의 최상단 body 슬롯은 타임특가 hero banner로 고정하고, 남은 시간 chip과 할인 ribbon을 분리한다.
- 추천 상품은 2열 카드로 배치하고, 반복 구매성 상품은 하단 빠른 구매 리스트로 보낸다.

## UI Direction

- Category tabs는 stable-width segmented bar이며, 선택 탭은 lantern-gold fill, 비선택 탭은 dark wood fill로 구분한다.
- 타임특가는 큰 product icon well, orange `타임특가` badge, teal countdown chip, red discount ribbon, orange purchase CTA를 가진다.
- Product card는 아이콘, 상품명, 한 줄 보상 요약, 2-3개 reward chips, 가격/구매 버튼으로 구성한다.
- 할인/신규/영구/오늘 같은 badge는 카드 우상단에 붙이고, 상품명과 겹치지 않도록 런타임에서는 짧은 card label을 우선한다.
- 상품군은 IAP만이 아니라 패스, 에너지, 재화, 1회 한정 패키지까지 확장 가능하게 둔다.

## Implementation Notes

- 이 시안은 구현용 full bitmap이 아니라 Phaser/DOM 슬롯형 UI의 구조 참조다.
- 상품명, 가격, 할인율, 카운트다운, 구매 상태, 보상 수량은 모두 runtime native text로 렌더링한다.
- Product 데이터는 기존 `harness/content/ninja2/items/_drafts/201501~201504`를 기본으로 하고, pass/monthly 상품은 별도 Product item 추가 후 같은 카드 컴포넌트로 노출한다.
- `CashShopProductRow`는 C안에서 카드형 `CashShopProductCard`와 compact row 변형으로 분리하는 것이 좋다.
- 할인 배지와 타임특가 카운트다운은 bitmap에 굽지 말고 native chip/badge component로 둔다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Runtime module candidate: `harness/runtime/src/survivor/home-modals/shop.js`.
- UI spec candidate: `harness/runtime/specs/ui/ninja2/home-modals/shop.yaml`.
- 후속 `gen-phaser-ui-spec`에서는 category tab data, featured banner slot, product card grid, quick-purchase list, owned/disabled state를 별도 fixture로 잡는다.

## Foundation Gaps Or Questions

- Shared button, modal, color, and shop icon foundation files exist. No blocking foundation gap for concept work.
- Follow-up question for runtime spec: 패스/월정액 상품을 D1에 실제 Product로 추가할지, 아니면 시안 전용 placeholder로 유지할지 결정해야 한다.

## Source Image

Built with the `gen-ui-concept` flow. A built-in imagegen pass established the mobile shop direction; the saved project concept image was locally rendered from existing Ninja2 UI assets so it can be referenced deterministically by Phaser implementation work.

![Home cash shop modal concept C](concept-c.png)
