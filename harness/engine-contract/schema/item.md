# Schema Card: Item

엔진 클래스: `ResourceItem` (`Commons/Resources/ResourceItem.proto`). 정의 계층.
idlez에서 **아이템은 가장 넓은 개념**이다 — 통화·장비·무기·캐릭터·펫·스킬·상품(IAP)·티켓·광맥(Mine)까지 전부 Item으로 표현된다(category로 구분). 통화도 예약 id를 가진 Item.

## 분류 (Category, field 103)

| Category | id | 용도 |
| --- | --- | --- |
| `System` | 0 | 시스템(통화·플레이어레벨·exp 등 예약 id) |
| `Character` | 1 | 플레이어 캐릭터 |
| `Weapon` | 2 | 무기 |
| `Equipment` | 3 | 장비 |
| `Stat` | 4 | 스탯 강화 아이템 |
| `Skill` | 5 | 스킬 아이템 |
| `Trait` | 6 | 특성 |
| `Material` | 100 | 재료 |
| `Product`/`Recipe`/`Boost`/`Utility`/`GamePass`/`Ticket`/`SelectableBox`/`Premium`/`Attendance` | 200~208 | 상점/상품/패스/출석 |
| `Unit`/`Mine`/`Pet` | 300~302 | 유닛·광맥·펫 아이템 |
| `Ranking` | 400 | 랭킹 |

`Type`(104)은 세부 종류(무기 Katana/Gun/Dagger/Hammer, 장비 Head/Chest/Ring…, Boost/Utility/Skill/Product/GamePass 등 100~20899대).

## 핵심 필드

| 필드 (#) | 타입 | 의미 | 참조 |
| --- | --- | --- | --- |
| `id` (100) | int32 | 아이템 dataId | — |
| `category`/`type` (103/104) | enum | 분류 | — |
| `name` (200) | string | 표시명 | Strings |
| `rarity` (108) | int32 | **타고난 희귀도** (불변) — 가챠/드롭 시점 결정 | → `concepts/rank-fields.md` |
| `grade` (105) | int32 | **성장 등급** (변경, DB 박힘) — 강화/한계돌파 단계 | → `concepts/rank-fields.md` |
| `tier` (109) | int32 | **grade 안 sub-step** — grade 사이 미세 단계 | → `concepts/rank-fields.md` |
| `extraGrade` (112) | int32 | ⚠️ **deprecated** — `rarity`로 대체. 신규 사용 금지 | (legacy only) |
| `power` (106) | int32 | 표시 전투력 기여 | — |
| `requiredExps` (4) | repeated int64 | 아이템 레벨업 경험치 | ← growth |
| `addStats`/`equipAddStats` (404/405) | repeated AddUnitStat | 보유/장착 스탯 (`value[]` 레벨배열) | → stat-catalog, growth |
| `equipAddBuffs` (406) | repeated AddBuff | 장착 버프 | → Buff.id |
| `equipSkillDataIds` (403) | repeated int32 | 장착 스킬 | → Skill.id |
| `options`/`optionCounts` (13000/13001) | ItemOptionGroup | 랜덤 옵션(affix) | → ItemOption→stat |
| `levelUpMaterialItemGroups` (602) | MaterialItemGroup | 강화 재료 | → Item.id |
| `unitDataId` (205) | int32 | 대응 유닛(Category.Unit/Pet) | → Unit.id |
| `skillDataId`/`mergeSkillDataId` (211/214) | int32 | 관련 스킬 | → Skill.id |
| `sellPrice`/`sellAddItemGroups` (315/316) | — | 판매가/판매보상 | → reward |
| `addItemGroups`/`decomposeAddItemGroups` (500/502) | AddItemGroup | 개봉/분해 보상 | → reward |
| `dailyRewardAddItemGroups` / JSON `DailyRewardAddItemGroups` (550) | AddItemGroup | 출석/일일 보상 | → reward |

## 구매/획득 제약 (305~323)

`requiredAchievementDataIds`, `exclusiveAchievementDataIds`, `requiredItemDataIds`, `exclusiveItemDataIds`, `requiredItemTags`, `exclusiveItemTags` — 조건부 획득/구매.

## 상품/결제 (Product 계열)

`iapIdentifier`(900), `priceUsd`(901), `priceWon`(904), `productMaterialItemGroups`(600). `priceXtr`(903)는 legacy 필드라 신규 콘텐츠에서는 사용하지 않는다. 가챠/번들/광고상품은 `Type` 700대 + `addItemGroups`(확률 드롭)로 구성.

## 광맥(Mine, 10000대) / 인벤토리스킬(11000대) / 사이즈아이템(12000대)

방치형 특화 필드군: `efficiencyPercents`(채굴 효율), `maxStamina`, `staminaRegenPerSecond`, `inventorySkillCommands`(인벤토리 스킬 패턴), `inventoryCells`(차지 칸).

## 작성 규칙

- 통화/시스템 아이템은 게임 프로필 `reserved_ids`와 일치해야 한다.
- 보상 필드(`addItemGroups`, `sellAddItemGroups`, `decomposeAddItemGroups`, `dailyRewardAddItemGroups`)는 `reward.md`의 `AddItemGroup` YAML 모양을 그대로 쓴다. `dailyRewardAddItemGroups`는 엔진 proto 원문이 대문자로 시작해 산출 JSON에서는 `DailyRewardAddItemGroups`로 정규화된다.
- 장비 스탯/레벨업은 `growth/*.growth.md` 식으로 생성해 `equipAddStats`/`requiredExps`에 bind.
- 랜덤 옵션은 `options`(ItemOptionGroup) — 등급별 weight로 affix 풀 구성 → `reward.md` 패턴과 유사.
