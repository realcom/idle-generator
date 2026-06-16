# Ninja2 Equipment Detail Modal A

## Intent

장비 카드 또는 장착 슬롯을 선택했을 때 열리는 상세 설명 모달 시안. 기존 장비 탭은 장착 슬롯과 인벤토리 비교를 빠르게 보여주고, 이 모달은 선택 장비의 이름, 희귀도, 레벨, 주요 스탯, 설명, 보유 수, 착용 부위, 장착 CTA를 확인하는 깊은 검사 흐름을 담당한다.

## Art Anchor

- `ninja2_equipment_equip_screen_a`의 장비 탭 배경, 카드 희귀도 테두리, 아이콘 중심 정보 구조를 유지한다.
- `ninja2_phaser_modal_system_a`와 `ninja2_sanctuary_build_modal_a`의 parchment shell, dark ink outline, lantern crest, leafy corner ornament, 원형 close button 문법을 따른다.
- 색상 축은 parchment cream, dark walnut, lantern gold, moss green, soul teal을 유지하고, 희귀도 색은 작은 badge와 아이콘 테두리에서만 쓴다.
- 배경 장비 화면은 스크림 아래에 보이되 입력은 모달이 독점한다.

## Composition Rules

- Portrait 9:16 target.
- 모달은 장비 화면 중앙에 뜨며, 하단 nav dock은 어두운 스크림 아래에 남아 현재 탭 맥락을 유지한다.
- Header는 작은 kicker/희귀도 badge, 큰 장비명, 우상단 닫기 버튼으로 구성한다.
- Body 상단은 좌측 큰 장비 아이콘 well, 우측 레벨/스탯 비교 영역으로 나눈다.
- Description block은 중단에 넓게 두되 2줄 내외로 clamp한다.
- 하단 metadata chips는 보유 수, 착용 부위, 요구 레벨 같은 짧은 값만 담는다.
- Footer는 green primary `장착`과 muted secondary `닫기` 2개 버튼을 안정 높이로 둔다.

## UI Direction

- Owned/equipped state는 작은 chip으로만 표시하고, 긴 설명은 본문 description에만 둔다.
- 스탯 행은 아이콘, 스탯명, 현재/변화값 또는 총합값을 분리해 비교가 가능하게 한다.
- 장착 불가 상태는 primary button disabled + 요구 조건 chip 강조로 처리한다.
- 장비가 이미 장착된 경우 primary button label은 `장착 중` 또는 disabled state로 바꾼다.
- 텍스트, 숫자, 설명, 스탯명, 버튼 라벨은 런타임 native DOM 텍스트로 렌더링한다.

## Implementation Notes

- baked concept PNG를 런타임에 올리지 않는다. 기존 `.home-modal-host`, `.home-modal-shell`, `.home-modal-scrim`, frame ornaments, parchment 9-slice를 재사용한다.
- 모달 루트는 `homeEquipmentDetailModal`로 두고, 장비 탭 안의 카드/슬롯 클릭에서 `selectedEquipmentItemId`를 갱신한 뒤 상세 모달을 연다.
- 장비 정보는 compiled `Items.json`의 Weapon/Equipment item 데이터와 sanctuary inventory/equipped state에서 가져온다.
- 아이콘은 `spriteGroups.Icon` 경로를 그대로 사용하고, 없으면 slot fallback glyph만 쓴다.
- 장비 설명은 content 데이터에 description 필드가 없을 수 있으므로 우선 category/type/rarity/stat 기반의 짧은 런타임 fallback 문구를 쓴다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Proposed spec: `harness/runtime/specs/ui/ninja2-equipment-detail-modal.yaml`.
- Preview query: `?game=ninja2&fixture=city&tab=equipment&equipmentDetail=200201`.
- QA 기준: card click opens modal, close/scrim/Escape closes modal, equip button equips selected owned item, Korean text fits at 500x920 smoke viewport.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb9c5-efef-7b31-8e85-07350a804383/ig_0f730fa265d6d1a8016a2b89b430248191b7731d6c593ac74f.png`

![Ninja2 equipment detail modal A](ninja2_equipment_detail_modal_a.png)
