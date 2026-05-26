# Mushroomer Data Completion Minimum Spec

## 목적

이 문서는 기존 `mushroomer` 프로젝트를 그대로 사용하면서, 현재 하네스 시스템으로
`버섯커 키우기` 방식의 플레이에 필요한 데이터를 완성하기 위한 최소 사양서다.

핵심 목표는 새 게임 슬러그나 신규 시스템을 만드는 것이 아니라 다음 질문에 답하는 것이다.

1. `mushroomer` 콘텐츠 데이터만 보강해 `ModeManagerMushroom` 기반 전투/성장 흐름을 닫을 수 있는가
2. `harness/content/mushroomer` 안에서 스탯, 성장, 스킬, 던전, 장비, shop 데이터를 완성할 수 있는가
3. 엔진 수정이 필요한 지점과 하네스 콘텐츠/툴링으로 해결 가능한 지점을 분리할 수 있는가

## 비목표

- `hamsterer` 같은 새 게임 슬러그 생성
- 햄스터 고유 성장축 추가
- 하우징, 친밀도, 먹이 주기, 꾸미기, 코스튬 시스템
- 신규 전투 룰 또는 신규 스탯 enum 추가
- 엔진 UI 대규모 개편
- 출시 볼륨의 라이브 서비스 경제 설계

기존 햄스터 리소스는 그대로 쓰되, 작업 단위는 **`mushroomer` 데이터 완성**이다.

## 기준 프로젝트

- 작업 시스템: `mushroomer`
- 클라이언트 흐름: `ModeManagerMushroom`
- 데이터 경로:
  - `harness/game-profiles/mushroomer.profile.yaml`
  - `harness/content/mushroomer/`

`mushroomer`는 이미 검증용 프로필과 수직 슬라이스 일부를 갖고 있으므로, 새 폴더를
파생하지 않는다. 목적은 `mushroomer` 안에서 부족한 시스템 데이터를 채워 하네스 기반
콘텐츠 제작 루프가 실제로 닫히는지 검증하는 것이다.

## 작업 전 상태

`python3 harness/tools/idlez_compile.py mushroomer` 기준 현재 툴체인은 통과한다.

| 산출물 | 현재 수량 | 해석 |
| --- | ---: | --- |
| `Units.json` | 3 | 플레이어 1, 일반 몬스터 1, 보스 1 수준 |
| `Items.json` | 11 | 시스템 통화 8, 캐릭터 1, 재료 2 수준 |
| `Skills.json` | 1 | 기본 스킬 1개 |
| `Buffs.json` | 0 | 버프형 스킬/장비 효과 없음 |
| `Maps.json` | 1 | 메인 던전 1개 |
| `Achievements.json` | 19 | 튜토리얼/예약 업적 중심 |
| `Audios.json` | 1 | 전투 BGM 1개 |
| `Triggers.json` | 10 | 현재 수직 슬라이스 전투 흐름 |

따라서 작업 전 `mushroomer`는 1맵 수직 슬라이스에 가깝고, 이번 사양서의 작업 목표는
이 슬라이스를 스탯/성장/스킬/던전/장비/shop이 있는 최소 키우기 루프로 확장하는 것이다.

## 1차 데이터 보강 결과

`python3 harness/tools/idlez_compile.py mushroomer` 기준 1차 보강 후 툴체인은 통과한다.

| 산출물 | 보강 후 수량 | 보강 내용 |
| --- | ---: | --- |
| `Units.json` | 3 | 기존 플레이어/몬스터/보스 유지 |
| `Items.json` | 69 | 재료, 티켓, 무기 15종, 장비 30종, 스킬북, shop 상품, 출석판 추가 |
| `Skills.json` | 4 | 단일딜, 광역, 보스딜, 자기 버프 스킬 구성 |
| `Buffs.json` | 1 | 공격/공속 성장형 자기 버프 추가 |
| `Maps.json` | 15 | 메인 5스테이지, 일반 던전 3종, 요일 던전 7종 |
| `Achievements.json` | 25 | 튜토리얼/예약 업적 외 성장 유도 업적 6종 추가 |
| `Audios.json` | 1 | 기존 전투 BGM 유지 |
| `Triggers.json` | 10 | 기존 `mushroom_field` 전투 트리거 재사용 |

### 장비 풀 확장

1차 장비 골격은 무기 3종 + 6슬롯 장비 6종으로 너무 얕았기 때문에, T2~T5 장비를
추가해 장비 계열을 45종까지 확장했다.

| 구분 | 수량 | 구성 |
| --- | ---: | --- |
| 무기 | 15 | Staff/Dagger/Hammer x T1~T5 |
| 장비 | 30 | Head/Chest/Gloves/Boots/Necklace/Ring x T1~T5 |
| 장비 상자 | 1 | T1~T5 전체 장비 풀을 tier별 가중치로 드롭 |

T2~T5는 `WeaponTier*Growth`, `EquipmentTier*Growth` 태그를 사용해 티어별 성장 배열을
분리한다. 따라서 상위 티어 장비가 T1과 같은 스탯 배열을 공유하지 않는다.

## 핵심 게임 루프

1. 플레이어 햄스터가 메인 던전에 진입한다.
2. 자동 전투로 일반 몬스터와 보스를 처치한다.
3. 골드, 경험치, 장비/스킬/강화 재료를 획득한다.
4. 골드와 재료로 스탯, 장비, 스킬을 성장시킨다.
5. 성장 후 더 높은 스테이지 또는 던전을 클리어한다.
6. 막히면 일반 던전/요일 던전/shop 보상으로 성장 재료를 보충한다.

이 루프가 10~20분의 짧은 세션 안에서 최소 1회 이상 닫히면 MVP 성공으로 본다.

## 스탯 시스템

### 사용 스탯

`mushroomer` 프로필의 기존 스탯 목록을 정본으로 사용한다.

| 스탯 | 용도 |
| --- | --- |
| `Hp`, `HpPercent` | 생존력 |
| `Attack`, `AttackPercent` | 기본 공격력 |
| `Defense`, `DefensePercent` | 피해 완화 |
| `CriticalPercent` | 치명타 확률 |
| `CriticalDamagePercent` | 치명타 피해 |
| `AttackSpeed`, `AttackSpeedPercent` | 기본 공격 속도 |
| `MoveSpeed` | 접근/추적 속도 |
| `CooldownPercent` | 스킬 쿨다운 감소 |
| `ExpPercent` | 경험치 획득 보너스 |
| `ItemDropPercent` | 드롭 보너스 |
| `MonsterDamageEfficiencyPercent` | 일반 몬스터 대상 피해 |
| `BossDamageEfficiencyPercent` | 보스 대상 피해 |

### 작성 규칙

- 새 스탯 enum은 만들지 않는다.
- 스탯 성장은 `Unit.addStats[].value[]`, `Item.equipAddStats[].value[]`,
  `Buff.addStats[].value[]`의 레벨 배열로 표현한다.
- 성장 배열은 `*.growth.md`에서 생성하고 YAML에 bind한다.
- `CriticalPercent`는 0~100 범위, `Attack`/`Hp`는 1 이상을 기본 가드레일로 둔다.

## 레벨업 및 성장 시스템

### 성장 축

| 성장 축 | 하네스 표현 | MVP 필요 여부 |
| --- | --- | --- |
| 플레이어 레벨 | `Item.Category=System`, reserved `playerLevel=1` | 필수 |
| 경험치 | reserved exp item `id=6` | 필수 |
| 기본 스탯 강화 | 스탯 성장용 item/achievement/shop 비용 | 필수 |
| 장비 강화 | `ResourceItem.requiredExps`, `levelUpMaterialItemGroups` | 필수 |
| 스킬 강화 | `Item.Category=Skill` 또는 스킬 관련 재료 | 필수 |
| 환생/프레스티지 | 별도 시스템 | 제외 |

### 최소 규칙

- 플레이어 레벨은 전투와 던전 클리어 보상으로 오른다.
- 레벨업은 `Attack`, `Hp`, `Defense` 중심으로 체감되게 만든다.
- 초반 10분 안에 5~10회 이상의 성장 클릭 또는 자동 성장이 발생해야 한다.
- 성장 비용은 골드 중심으로 시작하고, 장비/스킬부터 전용 재료를 붙인다.

## 전투 및 스테이지 시스템

### 메인 전투

- 맵 타입은 기본 `Dungeon`을 사용한다.
- 메인 맵에는 다음 `popupArgs`를 명시한다.

```yaml
popupArgs:
  ClientModeManager: ModeManagerMushroom
  ClientHomeMapDataId: self
```

- 웨이브/스폰은 `maps/*.behavior.yaml` 트리거로 작성한다.
- 플레이어는 현재 `mushroomer` 수직 슬라이스처럼 햄스터 유닛 리소스를 사용한다.
- 적은 기존 사용 가능한 몬스터 리소스를 우선 재사용하되, 명칭과 보상은 `mushroomer` 콘텐츠에 맞춘다.

### 스테이지 구조

| 구간 | 목적 | 최소 볼륨 |
| --- | --- | --- |
| 튜토리얼/초반 | 자동 전투와 성장 클릭 확인 | 1맵 |
| 일반 스테이지 | 반복 전투, 골드/경험치 획득 | 5~10스테이지 |
| 보스 스테이지 | 성장 체크포인트 | 2~3보스 |

스테이지 요구 전투력은 `maps/*.growth.md` 또는 몬스터 `addStats[].value[]` 성장 배열로
표현한다.

## 스킬 시스템

### 최소 스킬 구성

| 스킬 | 역할 | 하네스 표현 |
| --- | --- | --- |
| 기본 공격 | 항상 사용하는 단일 타격 | `Unit.triggers` 또는 기본 Skill |
| 광역 공격 | 일반 몬스터 정리 | `ResourceSkill.timelines[].Hit` |
| 보스 강타 | 보스 단일딜 | `ResourceSkill.timelines[].Hit` |
| 자기 버프 | 공격/공속/치명 증가 | `selfAddBuffs` 또는 behavior |

### 작성 규칙

- 스킬은 `ResourceSkill`로 정의하고, 필요 시 `Item.Category=Skill` 아이템과 연결한다.
- 쿨다운, 타격 수, 타깃 갱신 방식은 엔진 enum 안에서만 고른다.
- 스킬 강화는 피해량 또는 쿨다운 감소를 레벨 배열로 표현한다.
- 신규 스킬 판정 타입이 필요하면 MVP 범위 밖으로 기록한다.

## 일반 던전

일반 던전은 메인 스테이지와 별도로 재료 또는 골드를 집중 지급하는 반복 콘텐츠다.

| 던전 | 목적 | 보상 |
| --- | --- | --- |
| 골드 던전 | 기본 스탯 성장 재화 공급 | 골드 |
| 강화석 던전 | 장비 강화 재료 공급 | 장비 강화석 |
| 스킬 던전 | 스킬 성장 재료 공급 | 스킬 조각/스크롤 |

### 최소 규칙

- 각 던전은 `Map.Type=Dungeon`으로 둔다.
- 입장권이 필요하면 `Item.Type=Ticket`으로 표현한다.
- 클리어 보상은 `rewardAddItemGroups`를 사용한다.
- 방치/정찰 보상이 필요하면 `scoutAddItemGroups`와 `maxMinutes`를 사용한다.

## 요일별 던전

요일별 던전은 하루 단위로 보상이 달라지는 반복 콘텐츠다. MVP에서는 엔진 캘린더
로직을 새로 만들지 않고, 콘텐츠 구조가 표현 가능한지부터 검증한다.

| 요일 | 던전 | 핵심 보상 |
| --- | --- | --- |
| 월 | 골드 던전 | 골드 |
| 화 | 장비 던전 | 장비 강화석 |
| 수 | 스킬 던전 | 스킬 재료 |
| 목 | 경험치 던전 | 경험치 |
| 금 | 장비 던전 | 장비 상자/강화석 |
| 토 | 종합 던전 | 골드+재료 |
| 일 | 보너스 던전 | 전체 보상 증가 |

### 판정 기준

- 7개 던전을 각각 `Map`으로 만들 수 있어야 한다.
- 보상표는 `rewardAddItemGroups`로 분리 가능해야 한다.
- 요일 해금/노출은 하네스 데이터만으로 충분한지 확인한다.
- 만약 실제 요일 회전 UI나 서버 시간이 엔진 코드에 묶여 있다면, MVP에서는
  "엔진 또는 운영 툴링 필요"로 기록하고 콘텐츠 생성은 진행한다.

## 장비 시스템

### 장비 슬롯

MVP 슬롯은 `mushroomer`/idlez 예약 업적과 맞추기 위해 6슬롯을 기준으로 한다.

| 슬롯 | Type |
| --- | --- |
| 머리 | `Head` |
| 갑옷 | `Chest` |
| 장갑 | `Gloves` |
| 신발 | `Boots` |
| 목걸이 | `Necklace` |
| 반지 | `Ring` |

무기 슬롯은 별도 `Item.Category=Weapon`으로 둔다.

### 장비 속성

- 장비는 `rarity`, `grade`, `tier`를 사용한다.
- 기본 장착 스탯은 `equipAddStats`로 표현한다.
- 강화 비용은 `levelUpMaterialItemGroups`로 표현한다.
- 랜덤 옵션이 필요한 경우 `options`/`optionCounts`를 사용한다.
- 슬롯 해금은 `reserved_ids.achievement.equipmentSlotUnlock*` 업적을 재사용한다.

### 최소 볼륨

- 무기 3종
- 방어구 6슬롯 x 1종
- 장비 강화 재료 1~2종
- 초반 드롭/던전/shop에서 획득 가능한 장비 상자 1종

## Shop 시스템

Shop은 결제 기능 완성보다 `Product` 데이터로 구매/보상 루프를 표현할 수 있는지 검증한다.

### 최소 상품

| 상품 | Category/Type | 가격 | 보상 |
| --- | --- | --- | --- |
| 무료 골드 팩 | `Product` | 무료/광고 | 골드 |
| 초보자 성장 팩 | `Product` | 루비 또는 가격 필드 | 골드+강화석 |
| 장비 상자 | `Product` | 루비 | 랜덤 장비 |
| 스킬 재료 팩 | `Product` | 루비 | 스킬 재료 |
| 던전 티켓 팩 | `Product` | 루비 | 티켓 |

### 작성 규칙

- 상품 보상은 `addItemGroups`를 사용한다.
- 가격은 `priceUsd`, `priceWon`, `priceXtr`, `productMaterialItemGroups` 중 현재 엔진 경로에
  맞는 필드를 사용한다.
- 광고 상품은 엔진/UI 의존성이 있으면 데이터만 먼저 만들고 실제 광고 호출은 검증 항목으로 둔다.
- Shop 탭/그룹 UI가 `PageShopDesignDefinition` 등 PatchResources 고정 데이터에 묶여 있으면
  하네스 콘텐츠 범위를 넘는 작업으로 분리한다.

## 재화 및 보상

### 재화

| 재화 | 예약/아이템 | 용도 |
| --- | --- | --- |
| 골드 | `id=5` | 기본 스탯 성장 |
| 루비 | `id=3` | shop 구매 |
| 무료 루비 | `id=4` | 보상성 premium |
| 경험치 | `id=6` | 플레이어 레벨 |
| 장비 강화석 | 신규 Material | 장비 강화 |
| 스킬 조각 | 신규 Material | 스킬 강화 |
| 던전 티켓 | 신규 Ticket | 던전 입장 |

### 보상 경로

- 몬스터 처치 드롭
- 스테이지 클리어 보상
- 일반 던전 보상
- 요일별 던전 보상
- 업적/미션 보상
- 출석 보상
- shop 상품 보상
- 방치/정찰 보상

모든 보상은 `AddItemGroup`으로 통일한다.

## 미션, 업적, 출석

버섯커식 성장 유도에 필요한 최소 메타 시스템으로 포함한다.

| 시스템 | 최소 역할 | 하네스 표현 |
| --- | --- | --- |
| 업적 | 누적 처치, 스테이지 클리어, 장비 강화 | `ResourceAchievement.Type=Normal` |
| 일일 미션 | 던전 참여, 스킬 사용, shop 무료 상품 수령 | `Type=Daily/Mission` |
| 출석 | 7일 기본 보상판 | `Item.Type=Attendance` 또는 Achievement 보상 |

출석 UI가 엔진 고정 팝업에 의존하면, MVP에서는 보상 데이터와 해금 조건까지만 작성한다.

## 방치 보상

방치 보상은 햄스터 고유 시스템이 아니라 버섯커식 AFK 루프의 필수 보상 채널로 본다.

### 최소 규칙

- 오프라인 보상 최대 누적 시간: 8시간
- 보상 종류: 골드, 경험치, 낮은 확률의 재료
- 하네스 표현: `Map.scoutAddItemGroups`, `minutes`, `maxMinutes`
- 밸런스 기준: 같은 시간 수동 플레이 보상의 30~60%

## 햄스터 리소스 매핑

### MVP 리소스 원칙

- 플레이어 캐릭터는 기존 햄스터 리소스를 그대로 쓴다.
- 부족한 적/아이콘/맵은 기존 PatchResources의 사용 가능한 리소스를 재사용한다.
- 리소스 부족 때문에 신규 시스템을 만들지 않는다.

### 1차 매핑

| 용도 | 우선 리소스 |
| --- | --- |
| 플레이어 유닛 | `Units/Characters/PFB_HAM_Angel.prefab` |
| 플레이어 스프라이트 | `Units/Characters/Assets/hamsterAngel.png` |
| NPC/보조 햄스터 | `hamsternpc_public` 계열 |
| 메인 맵 | 기존 Meadow/Beach/Jungle 계열 |
| 장비 아이콘 | 기존 Items atlas |
| 상품/재료 아이콘 | 기존 Goods/Icons atlas |

리소스 키는 실제 PatchResources 존재 여부를 확인한 뒤 콘텐츠 YAML에 확정한다.

## 하네스 데이터 매핑

| 게임 개념 | 하네스/엔진 데이터 |
| --- | --- |
| 플레이어 햄스터 | `Unit.Type=Player` + `Item.Category=Character` |
| 일반 몬스터 | `Unit.Type=Monster` |
| 보스 | `Unit.Type=Boss` 또는 보스 태그 |
| 메인 스테이지 | `Map.Type=Dungeon` + `ModeManagerMushroom` |
| 웨이브 | `maps/*.behavior.yaml` trigger |
| 기본 스탯 성장 | `Unit.addStats`, `growth/*.growth.md` |
| 장비 | `Item.Category=Equipment/Weapon` |
| 장비 강화 | `requiredExps`, `levelUpMaterialItemGroups` |
| 스킬 | `ResourceSkill` + optional `Item.Category=Skill` |
| 재료 | `Item.Category=Material` |
| 티켓 | `Item.Type=Ticket` |
| Shop 상품 | `Item.Category=Product` |
| 던전 보상 | `Map.rewardAddItemGroups` |
| 방치 보상 | `Map.scoutAddItemGroups` |
| 업적/미션 | `ResourceAchievement` |
| 출석 | `Attendance` item 또는 achievement tree |

## 데이터 완성 범위

### 보강할 경로

- `harness/game-profiles/mushroomer.profile.yaml`
- `harness/content/mushroomer/resource_globals.yaml`
- `harness/content/mushroomer/units/`
- `harness/content/mushroomer/items/`
- `harness/content/mushroomer/skills/`
- `harness/content/mushroomer/maps/`
- `harness/content/mushroomer/rewards/`
- `harness/content/mushroomer/achievements/`
- `harness/content/mushroomer/growth/`
- `harness/content/mushroomer/tutorials/`

### 시스템별 데이터 목표

| 시스템 | 주 데이터 | 완료 기준 |
| --- | --- | --- |
| 스탯/성장 | `growth/*.growth.md`, `units/*.unit.yaml`, `items/*.item.yaml` | 플레이어/몬스터/장비 레벨 배열이 있고 초반 성장 곡선이 컴파일됨 |
| 스킬 | `skills/*.skill.yaml`, `skills/*.behavior.yaml`, skill item | 공격/광역/보스딜/버프 스킬이 보상 또는 장착 루프에 연결됨 |
| 일반 던전 | `maps/*.map.yaml`, `maps/*.behavior.yaml`, rewards | 골드/강화석/스킬 재료 던전이 각각 보상표를 가짐 |
| 요일별 던전 | weekday map 7종, rewards, tickets | 7개 맵과 요일별 보상 구성이 데이터로 존재함 |
| 장비 | weapon/equipment item, material, growth | 무기/6슬롯 장비/강화 재료/강화 비용이 연결됨 |
| shop | product item, addItemGroups, price/cost | 무료팩/성장팩/장비상자/스킬팩/티켓팩이 구매 보상 데이터를 가짐 |
| 메타 보상 | achievements, attendance, daily mission | 누적 업적, 일일 미션, 출석 보상이 최소 1세트 존재함 |

### 최소 콘텐츠 수량

| 카테고리 | 수량 |
| --- | --- |
| 플레이어 햄스터 | 1 |
| 일반 몬스터 | 5~10 |
| 보스 | 2~3 |
| 메인 맵/스테이지 | 5~10 |
| 일반 던전 | 3 |
| 요일 던전 | 7 |
| 스킬 | 4 |
| 무기 | 15 |
| 방어구/악세 | 30 |
| 재료 | 4~6 |
| shop 상품 | 5 |
| 업적/미션/출석 | 15~25 |

## 구현 가능성 판정표

| 항목 | 예상 판정 | 근거/확인점 |
| --- | --- | --- |
| 스탯 시스템 | 가능 | engine stat enum과 profile guardrail로 표현 |
| 레벨업/성장 | 가능 | `value[]` 성장 배열과 reserved exp/player level 사용 |
| 전투/스테이지 | 가능 | `Dungeon` + `ModeManagerMushroom` + behavior trigger |
| 스킬 | 가능 | `ResourceSkill` timeline/trigger 사용 |
| 일반 던전 | 가능 | 별도 `Map`과 보상표로 표현 |
| 요일별 던전 데이터 | 가능 | 7개 `Map`과 보상표 작성 가능 |
| 요일별 실제 회전 | 확인 필요 | UI/서버 시간/노출 조건이 엔진에 묶였는지 확인 |
| 장비 | 가능 | `Weapon/Equipment`, slot unlock achievement 사용 |
| Shop 상품 데이터 | 가능 | `Product` item과 `addItemGroups` 사용 |
| Shop UI 탭 구성 | 확인 필요 | PatchResources 고정 정의 의존 가능성 |
| 방치 보상 | 가능성 높음 | `scoutAddItemGroups` 경로 검증 필요 |
| 출석 UI | 확인 필요 | 데이터와 팝업 연결 방식 확인 필요 |

## 성공 기준

### 1차 성공

- `python3 harness/tools/idlez_compile.py mushroomer`가 통과한다.
- 햄스터 플레이어 1종이 `ModeManagerMushroom` 맵에서 전투한다.
- 골드/경험치/재료 획득 후 성장으로 다음 스테이지를 돌파한다.
- 스킬 1개 이상, 장비 1개 이상, shop 상품 1개 이상이 실제 보상 루프에 연결된다.

### 2차 성공

- 일반 던전 3종과 요일별 던전 7종이 데이터로 구성된다.
- 장비 6슬롯 해금과 강화가 작동한다.
- 방치 보상과 일일 미션/출석 보상이 최소 1회 지급된다.
- 하네스 콘텐츠만으로 해결 안 되는 지점이 명확히 분류된다.

## 1차 작업 순서

1. 현재 `mushroomer` 콘텐츠 인벤토리를 점검해 부족한 데이터 목록을 확정
2. 스탯/성장 곡선과 플레이어/몬스터/보스 데이터를 먼저 보강
3. 메인 맵 1개에서 compile 및 전투 진입 검증
4. 기본 스킬, 첫 장비, 골드/경험치 보상을 연결
5. 일반 던전 1종과 shop 상품 1종을 붙여 성장 루프 검증
6. 일반 던전 3종, 요일별 던전 7종, 장비 6슬롯으로 확장
7. 일일 미션/업적/출석 데이터를 붙여 반복 플레이 루프 완성

## 열린 확인 사항

- `ModeManagerMushroom`이 현재 `mushroomer` 맵의 `popupArgs`만으로 안정적으로 붙는지
- `mushroomer`의 `resource_globals.yaml`에 추가 전역 설정이 필요한지
- Shop 탭/그룹 UI를 하네스 콘텐츠로 제어할 수 있는지
- 요일별 던전의 실제 요일 회전을 데이터만으로 제어할 수 있는지
- 출석 보상 UI가 `Item.Type=Attendance`만으로 뜨는지
- `harness/build/mushroomer/*.json`을 Unity PatchResources로 sync하는 경로가 바로 작동하는지
