# Reference Graph (engine-contract, 불변)

콘텐츠 타입들이 서로를 *무엇으로* 참조하는지의 지도. 출처: `idlez-client` `Commons/Resources/*` + `Commons/Types/*`.
모든 참조는 **정수 `dataId`** 또는 **트리거 이름(string)** 으로 이뤄진다. 이 그래프를 깨면(존재하지 않는 ID 참조 등) 콘텐츠가 런타임/세이브를 파손한다 — `tools/validate`가 검사하는 핵심.

## 3-분할 (가장 중요한 구분)

| 분할 | 엔진 클래스 | 정체 | 누가 만드나 | 어디로 가나 |
| --- | --- | --- | --- | --- |
| **정의(Definition)** | `Resource*` | 정적 콘텐츠 (유닛/아이템/스킬/버프/맵) | 기획자·AI | 빌드 → `Units.json` 등, 클라+서버 공유 |
| **인스턴스(Instance)** | `Player*` | 플레이어 런타임 상태 (인벤토리/보유아이템/랭킹) | 런타임 | 세이브 blob, 서버 동기화 |
| **런타임(Runtime)** | `Game*` (GameBoard) | 결정론적 전투/방치 시뮬 | 엔진 코드 | (코드, 콘텐츠 아님) |

> **인스턴스는 정의를 `dataId`로만 참조한다.** 이 규칙 덕에 ① 기획자는 정의만 건드리고 ② 서버는 인스턴스 blob만 동기화하고 ③ AI는 스키마 지키며 정의를 양산하고 ④ 검증기가 위반을 잡는다. 이 하네스가 다루는 건 **정의 계층**뿐이다.

## 정의 ↔ 정의 (콘텐츠 작성 시 지켜야 할 간선)

```
Unit (ResourceUnit)
  ├─ triggers[]              → Trigger 이름(string)          # 행동/로직 (behavior-format.md)
  ├─ addStats[]              → UnitStatType (+ value[] 레벨배열, level-1 인덱싱) ← 성장 자리(growth-pipeline.md)
  │                            ⚠ 유닛은 requiredExps 미사용(0/1010). requiredExps는 아이템 레벨업 전용
  ├─ dropAddItemGroups[]     → AddItemGroup → AddItem.itemDataId → Item.id
  ├─ itemDataId              → Item.id        # 이 유닛에 대응하는 인벤토리 아이템
  ├─ armorType               → ArmorType
  └─ deadUseSkill            → Skill.id

Item (ResourceItem)
  ├─ category / type         → enum (Character/Weapon/Equipment/Stat/Skill/Unit/Pet/Product/Gacha/…)
  ├─ requiredExps[]          → (아이템 레벨업 성장; growth-pipeline.md)
  ├─ addStats[] / equipAddStats[] → UnitStatType (+ value[])
  ├─ equipAddBuffs[]         → AddBuff → Buff.id
  ├─ equipSkillDataIds[]     → Skill.id
  ├─ unitDataId              → Unit.id        # 이 아이템이 소환/대응하는 유닛 (Category.Unit/Pet)
  ├─ skillDataId / mergeSkillDataId → Skill.id
  ├─ options[]               → ItemOptionGroup → ItemOption.addStats[] → UnitStatType   # 랜덤 옵션(affix)
  ├─ levelUpMaterialItemGroups[] / materialItemGroups[] → MaterialItem.id → Item.id     # 강화/제작 재료
  ├─ addItemGroups[] / sellAddItemGroups[] / decomposeAddItemGroups[] → AddItem.itemDataId → Item.id
  ├─ achievementDataId / rankingItemDataId  → Achievement.id / Item.id
  └─ iapIdentifier, priceWon/Usd/Xtr        → (상품/결제)

Skill (ResourceSkill)
  ├─ triggers[]              → Trigger 이름(string)
  ├─ timelines[]             → Timeline.action (Hit/Charge/Knockback/UseSkill/AddBuff/PlayFx/RunTrigger/Destroy/…)
  │     ├─ Hit.addDamage / addHeal / addBuffs[] → Buff.id
  │     └─ RunTrigger.name   → Trigger 이름(string)
  ├─ hitAddBuffs[] / selfAddBuffs[] → Buff.id
  ├─ consecutiveUseSkill     → Skill.id (UseSkill)
  ├─ itemDataId              → Item.id
  └─ damageType              → DamageType

Buff (ResourceBuff)
  ├─ triggers[]              → Trigger 이름(string)
  ├─ addStats[]              → UnitStatType (+ value[])  # 레벨/스택별
  ├─ periodicAddDamage / periodicAddHeal / periodicUseSkill → (Damage/Heal/Skill.id)
  ├─ maxStackUseSkill / maxLevelPeriodicUseSkill → Skill.id
  └─ replaceSourceSkillDataIds[] / replaceTargetSkillDataIds[] → Skill.id

Map (ResourceMap)  — 던전/레이드/랭크/이벤트/로비
  ├─ type                    → enum (Dungeon/Raid/Rank/Event/Lobby/RespawnDungeon/BackpackDungeon/…)
  ├─ triggers[]              → Trigger 이름(string)   # 웨이브/스폰/이벤트 로직 (예: Map_*_Wave3)
  ├─ locations[]             → AddUnit.LocationId      # location에는 geometries[] 필수
  ├─ (웨이브가 스폰) Unit.id  → AddUnit.UnitDataId
  ├─ (보상)                  → AddItemGroup → Item.id
  └─ boardConstants          → 보드 규칙(levelUpChoiceCount, 인벤토리 모양 등)

Achievement (ResourceAchievement) — 업적/미션/랭킹/이벤트패스
  ├─ type                    → enum (Normal/Daily/Weekly/Ranking/EventPass/Mission)
  ├─ condition               → enum Condition (engine-bound: KillUnit/AcquireItem/WinGame/UseSkill/Login/…)
  ├─ conditionValue1/2       → 조건별 (Unit.id / Item.id / Map.id / Skill.id / grade / level …)
  ├─ rewardAddItemGroups[]   → AddItemGroup → Item.id
  ├─ rewardRequiredItemDataId / rewardLevelReferenceItemDataId → Item.id
  ├─ rankingItemDataId       → Item.id (점수 통화)
  ├─ parentAchievementDataId → Achievement.id
  ├─ childAchievementDataIds[] → Achievement.id
  └─ dayResetOpenRequiredAchievementDataId → Achievement.id

  ← Item.achievementDataId / Item.requiredAchievementDataIds[]  (역참조: 상품/잠금)
  ← (시스템) ResourceItem.IsLockedByAchievement(부위) — equipmentSlotUnlock* 예약 id
```

## 공유 부품 (여러 정의가 함께 쓰는 원시 타입)

- **AddItem / AddItemGroup / TraitItemGroup** (`Types/AddItem.proto`) — 드롭/보상 테이블. `weight`, `group`, `pityGroup`(천장), `probPercent`. → `reward.md`
- **ItemOption / ItemOptionGroup** (`Types/ItemOption.proto`) — 장비 랜덤 옵션. `grade`, `weight`, `addStats[]`.
- **MaterialItem / MaterialItemGroup** (`Types/MaterialItem.proto`) — 강화/제작 재료 비용.
- **AddDamage / AddHeal / AddBuff / UseSkill** (`Types/Units/*`) — 전투 효과 원자.
- **Curve** (`Types/Curve.proto`) — Unity AnimationCurve 직렬화. ⚠ 성장곡선 아님. VFX/타임라인 셰이핑용 유틸. 콘텐츠 계층에선 거의 안 씀.

## 잘 알려진 예약 dataId (idlez 기준, 게임별로 다를 수 있음)

통화/시스템 아이템은 `ResourceItem.Global.DataId`에 예약 ID로 박혀 있다 (실제 `Items.json`의 `itemGlobal.dataId` 값):

| 이름 | id | 비고 |
| --- | --- | --- |
| `playerLevel` | 1 | |
| `credit` | 2 | |
| `ruby` / `freeRuby` | 3 / 4 | 프리미엄 통화 |
| `gold` | 5 | 소프트 통화 |
| `exp` | 6 | |
| `rankPoint` | 7 | |
| `energy` | 8 | |
| `stage` | 9 (proto) | 진행 스테이지 |

> 이 예약 ID 셋은 **게임 프로필에서 재정의**한다(`game-profiles/<game>.profile.yaml`의 `currencies:`/`reserved_ids:`). idlez와 backpack은 서로 다른 ID 대역을 쓸 수 있다.

업적 시스템 예약 dataId는 `ResourceAchievement.Global.DataId`에 정의되어 있다. 실제 값은 proto field number가 아니라 게임별 `Achievements.json.achievementGlobal.dataId` 값이다. 엔진 코드가 직접 참조하므로 콘텐츠가 임의 재할당하지 않는다 — 프로필 `reserved_ids.achievement.*` 참조. 자세한 표는 `schema/achievement.md`.
