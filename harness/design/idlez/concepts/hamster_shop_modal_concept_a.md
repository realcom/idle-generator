# Hamster Shop Modal Concept A

## Intent

하단 마지막 탭을 길드에서 상점으로 교체하고, 전투 화면 위에 빠르게 여닫는 기본 상점 시트를 정의한다.

## Art Anchor

- `hamster_portrait_combat_growth_dock_d`의 햄스터 전투 정체성과 목재/금색 하단 독을 유지한다.
- 상점은 전체 화면 전환이 아니라 전투가 살아 있는 상태에서 떠오르는 parchment sheet로 다룬다.
- 프리미엄 통화는 기존 idlez reserved currency인 루비/무료 루비 명칭을 그대로 쓴다.

## Composition Rules

- 상단 전투/HUD 영역은 계속 보이게 두고, 상점 시트는 하단 독 위부터 화면 중하단을 채운다.
- 첫 줄은 `루비`와 `한정 상품` segmented control로 구성한다.
- 루비 구매 카드는 3개 가격대가 한 줄로 보이게 하고, 큰 보너스는 붉은 스티커 배지로 처리한다.
- 한정 상품은 3개 카드로 고정한다: 장비 부스터 팩, 광고 제거권, 배속권.
- 하단 네비게이션 마지막 칸은 상점 아이콘과 `상점` 라벨로 활성 상태를 보여준다.

## UI Direction

- 목재 프레임, 양피지 본문, 녹색 구매 버튼, 금색 포인트를 기존 성장 독과 같은 계열로 유지한다.
- 루비 카드에는 붉은 보석 비주얼을 쓰고, 한정 상품 카드는 아이콘 중심의 빠른 판독 구조로 둔다.
- 상품 설명은 두 줄 이하로 압축하고 가격 버튼은 카드 하단에 고정한다.

## Implementation Notes

- Phaser runtime은 `shop` modal id를 새로 등록해 하단 탭에서 바로 연다.
- Unity preview builder는 `Tab_LockedGuild` 대신 `Tab_Shop`을 생성한다.
- 기본 상품 데이터는 `ResourceItem.Category=Product` 초안으로 생성하고, 런타임 상점은 이 상품군의 표시 구성을 하드코딩 프리뷰로 먼저 보여준다.
- 광고 제거권과 배속권의 영구 효과 처리는 아직 엔진 효과 바인딩 전이므로 `popupArgs`로 의도를 기록한다.

## Source Image

- Imagegen output copied from `/Users/yangjinhwan/.codex/generated_images/019e8335-cf9e-7a02-a1de-b995374ae8f6/ig_0401209f1ba5a0eb016a1d8160e45c8191ba9023658666a39b.png`
- Saved concept image: `hamster_shop_modal_concept_a.png`
