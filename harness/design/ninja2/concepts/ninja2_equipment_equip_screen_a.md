# Ninja2 Equipment Equip Screen A

## Intent

하단 UI의 두 번째 탭을 `동료`에서 `장비`로 교체했을 때 열리는 장비 장착 화면 후보. 장착 슬롯, 전투력 변화, 장비 인벤토리, 필터/정렬을 한 화면 안에서 바로 읽게 해서 하단 탭 전환만으로 장비 성장 루프에 진입하도록 한다.

## Art Anchor

- `ninja2_rulelocked_housing_home_a`의 갈색 머리 수호자, 붉은 스카프, 손등불, 굵은 잉크 외곽선을 유지한다.
- `ninja2_sanctuary_build_modal_a`의 양피지 shell, 랜턴 ornament, 잎 장식, 짙은 목재 테두리 톤을 장비 화면에도 적용한다.
- 색상 축은 parchment cream, lantern gold, dark wood, moss green, soul teal을 유지하고, 장비 희귀도만 보조색으로 제한한다.
- 하단 독은 기존 성소 홈 문법을 유지하되 두 번째 탭을 `장비`로 바꾼다.

## Composition Rules

- Portrait 9:16 target. Generated concept size: 944x1672.
- Top resource bar와 profile block은 성소/전투 화면과 같은 위치 체계를 사용한다.
- 중앙은 캐릭터 paper-doll과 6개 장착 슬롯을 한 덩어리로 묶는다.
- 장착 슬롯은 `무기`, `머리`, `갑옷`, `장갑`, `신발`, `호부`의 고정 슬롯으로 시작한다.
- 우측 stat panel은 전투력, 공격력, 체력, 치명타, 영혼불 같은 핵심 변화량만 짧은 칩으로 보여준다.
- 하단 절반은 장비 인벤토리 grid로 사용한다. 장비 카드에는 아이콘, 레벨, 희귀도 테두리, 장착 체크만 둔다.
- 슬롯 확장 버튼은 넣지 않는다. 잠긴 grid 칸이 필요하면 카드 슬롯의 disabled state로만 표현한다.

## UI Direction

- Selected tab은 lantern gold fill과 검/갑옷 아이콘으로 강조한다.
- Bottom tabs는 `성소`, `장비`, `탐험`, `임무`, `상점` 5개 equal-width 구조를 유지한다.
- 필터는 텍스트 탭보다 아이콘 버튼 묶음으로 둔다. 전체/무기/방어구/장갑/신발/장신구 정도의 단순 분류가 적합하다.
- 장착 CTA는 green/gold primary button으로 두고, 비교/상세/세트 효과는 작은 secondary button이나 chip으로 낮춘다.
- 긴 문장형 description은 장비 화면의 기본 리스트에 넣지 않는다. 필요한 설명은 상세 팝업으로 분리한다.
- 이미지 속 텍스트는 구조 확인용이며, 실제 런타임에서는 Phaser/DOM 텍스트로 선명하게 렌더링한다.

## Implementation Notes

- Concept 단계이므로 아직 Phaser 런타임에는 반영하지 않는다.
- 후속 구현 시 `harness/runtime/specs/ui/ninja2-housing-home.yaml`과 `component-blueprints.yaml`의 bottom nav label을 `동료`에서 `장비`로 갱신한다.
- 장비 화면은 기존 `home-modal-*` 위에 띄우는 임시 모달보다 독립 탭 screen/state로 두는 편이 맞다.
- 장비 아이콘은 기존 item/equipment sprite가 있으면 우선 재사용하고, 부족한 slot/filter icon만 generated asset 후보로 남긴다.
- 카드 grid는 고정 aspect ratio를 두어 rarity border, level chip, equipped checkmark가 들어가도 셀 크기가 흔들리지 않게 한다.

## Target Runtime Notes

- Target runtime: `harness/runtime/survivor-runtime.html`.
- Entry point: `harness/runtime/src/survivor/survivor-app.js`.
- Preview query는 기존 home shell과 같은 `?game=ninja2&fixture=city&noAudio=1` 계열을 사용한다.
- Mobile target width는 390-440px portrait이며, bottom dock label은 줄바꿈 없이 한 줄로 고정한다.
- 런타임 QA에서는 장착 슬롯 hit area, inventory scroll, Korean text overflow, bottom dock selected state를 확인한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ea4a5-ee60-7891-97b1-34deadd1e4ec/ig_0fdf78ad211ee4a5016a2900f3ae40819193194f1a4756123b.png`

![Ninja2 equipment equip screen A](ninja2_equipment_equip_screen_a.png)
