# Home Cash Shop Modal Concept B

## Intent

`ninja2` 현금 결제 상점의 기준 후보. 상점은 보급소/재화 교환이 아니라 Product item 기반 IAP 상품 리스트로 읽혀야 한다. 플레이어는 루비, 초심자 팩, 에너지 회복, 광고 제거를 같은 modal family 안에서 빠르게 스캔하고 구매 가능 상태를 확인한다.

## Art Anchor

- `ninja2`의 lantern sanctuary identity를 유지한다: cream parchment, dark ink outline, leafy frame ornaments, lantern crest, warm orange CTA, pale teal soulflame accents.
- 배경은 소유한 성소/헥스 보드를 어둡게 남긴다. 큰 캐릭터 초상이나 마케팅 hero 이미지는 사용하지 않는다.
- 상품 이미지는 object-only 아이콘으로 제한한다. 실제 주인공이나 닌자 복면을 새로 만들지 않는다.
- 생성 이미지의 텍스트는 방향성만 참고한다. 최종 문구/수량/가격은 Content YAML과 DOM text에서 관리한다.

## Composition Rules

- Portrait 9:16 target.
- Modal shell은 화면 중앙에 크게 두되, top resource band와 bottom tab dock의 맥락이 스크림 아래로 보이게 한다.
- Header는 `현금 결제 상품` kicker, 큰 `상점` title, 우상단 close button, 작은 lantern crest로 구성한다.
- Body는 4개 상품 row를 안정 치수로 반복한다.
- Row columns: left product icon, center name/reward summary, right price pill + purchase button.
- Footer는 `구매 가능한 상품` count와 `현금 결제 상점` label만 두고, 약관/설명형 긴 문구는 후순위로 둔다.

## UI Direction

- Product rows are dense and operational, not marketing cards.
- Price pill uses a light parchment chip with dark text; purchase button uses orange with dark outline.
- One-time products can switch to owned/claimed state by muting the button and changing the label to `보유`.
- Repeated cash products remain available after purchase in the harness.
- Reward summary should fit one line; if it overflows, ellipsis is acceptable.

## Implementation Notes

- This is the selected direction for the current Phaser mockup pass.
- Reuse common `home-modal-*` shell and `ninja2.ui.panel.parchment_9slice`.
- Product definitions should mirror `harness/content/ninja2/items/_drafts/201501~201504`.
- Generated product icons should be tracked in `asset-plan.yaml:ninja2.ui.shop_product_icons.cash_v1`.
- No store logo, dollar sign, platform badge, discount math, or full-screen hero art should be baked into the UI.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Runtime module: `harness/runtime/src/survivor/home-modals/shop.js`.
- UI spec: `harness/runtime/specs/ui/ninja2/home-modals/shop.yaml`.
- The Phaser harness may simulate payment success, but the visible model must still look like a cash shop.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb9c7-948e-74f1-ba24-1fa7b543dfd3/ig_0d953fc2dd9416ba016a2b8084fee8819682ea01b04644f101.png`

![Home cash shop modal concept B](concept-b.png)
