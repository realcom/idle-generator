---
name: gen-iap
description: "IAP 상품 1종을 완성형으로 제작 (Item.Category=Product). 일반 결제 상품 — 패키지/번들/가챠/스타터팩. 가격(USD/KRW/XTR) + 구성품(addItemGroups). 단일은 여기, 시리즈는 gen-iaps."
argument-hint: "[게임 id] [상품 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# IAP 상품 생성 (Category=Product)

ResourceItem(Category=Product)의 수직 슬라이스. **iapIdentifier + 가격 + 구성품**이 본질.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Product` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Product 필드: iapIdentifier(900), priceUsd(901), priceXtr(903), priceWon(904), addItemGroups(500), productMaterialItemGroups(600)
- `harness/engine-contract/reference-graph.md` — addItemGroups.addItems[].itemDataId → Item.id
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item, 가챠/번들 패턴
- `harness/content/<game>/items/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): 상품 종(번들/가챠/스타터팩/한정), 가격대(소액/중액/대액), 구성품, 구매 제약(1회/주간/달성도 기반), 광고/한정 여부.
2. **ID 할당**: `profile.id_ranges.item`.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Product
   - **iapIdentifier**: 스토어 식별자 (예: `idlez.product.starterpack01`)
   - **priceUsd / priceWon / priceXtr** (해당하는 것만, 무료 광고면 모두 0)
   - **addItemGroups**: 구성품 — 확정형 또는 weight 풀(가챠)
   - requiredItemDataIds/exclusiveItemDataIds (구매 제약)
   - requiredAchievementDataIds (달성 후 노출)
   - startAt/untilAt (한정)
   - spriteGroups (Icon)
4. **참조 검증**: 구성품 itemDataId가 items/_index.yaml의 approved에 실재.
5. **에셋**(asset-producer): 상품 배너 sprite + Icon.
6. **_index 등록**: `category: Product`, `iap` 또는 `bundle`/`gacha` 태그.
7. **검수/승인**.

## 원칙
- iapIdentifier는 스토어 등록 식별자 — 운영에서 사용. 중복 금지.
- 가챠형은 addItemGroups에 weight 분포 (천장 별도 처리 — 엔진 코드 의존).
- 한정 상품은 startAt/untilAt 필수.

## 협업
- 시리즈/가격대 라인업은 `/gen-iaps`
- 시즌 패스는 `/gen-gamepass` (다른 type)
- 출석 보상은 `/gen-attendance`
- 보상 풀의 아이템은 미리 만들어 두기
