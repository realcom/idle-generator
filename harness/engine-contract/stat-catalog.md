# Stat Catalog (engine-contract, 불변)

idlez 엔진의 스탯 시스템. 출처: `idlez-client` `Commons/Types/Units/UnitStatType.proto` (enum `UnitStatType`, 0~75, `Count=76`).
모든 유닛·아이템·버프·스킬의 수치는 이 스탯 키로 표현된다. 이 카탈로그는 **엔진이 정의한 불변 집합**이며, 게임이 추가/삭제할 수 없다(게임은 이 중 *어떤 것을 쓰는지*만 프로필에서 고른다).

## 표현 단위 규칙

스탯 키 접미사로 의미가 갈린다:

- `Xxx` (접미사 없음) — **flat(정수/실수 가산)**. 예: `Attack`, `Hp`, `Defense`.
- `XxxPercent` — **퍼센트 가산**. 보통 flat 합산 후 `(1 + Σpercent/100)`로 곱.
- `GameplayXxx` / `GameplayXxxPercent` — **인게임(보드) 한정 변형**. 아웃게임 스탯과 분리되어 전투 보드 안에서만 적용되는 별도 채널.

합산 모델(엔진 리뷰 기준): `flat` 절대값과 `percent` 배율 채널을 분리해 재계산한다.
`MaxHp`, `Attack`, `Defense`처럼 크게 커지는 절대 스탯은 long 경로에서 보존하고,
`XxxPercent`/`GameplayXxxPercent`는 `FixedFloat` 배율로 적용한다.
정확한 순서는 런타임 `GameUnit.Stat` 구현을 따른다.

주의: `FixedFloat`는 소수/배율 표현용이다. HP/damage/heal 같은 대형 절대값을 trigger expression으로 끌고 들어와 곱셈/나눗셈하면 clamp될 수 있다.
전투 수치와 trigger 숫자 계약은 `trigger-runtime-semantics.md`를 따른다.

## 적용 방식 (proto)

```proto
message AddUnitStat {
  UnitStatType type = 1;
  repeated float value = 2;   // ★ 배열 = 레벨 인덱스별 값 (성장은 여기로)
}
```

`value`가 **배열**인 점이 핵심이다. `value[level]`로 레벨별 값을 읽는다 → 성장은 곡선 객체가 아니라 **레벨 인덱스 배열**이며, 이 배열은 `growth-pipeline.md`의 식에서 생성된다.

## 스탯 키 (76종)

### 자원/생존 (Hp/Mp/Sp/Shield)
| key | id | 의미 |
| --- | --- | --- |
| `Hp` / `HpPercent` | 0 / 1 | 체력 |
| `GameplayHpPercent` | 2 | 보드 한정 체력% |
| `HpRegen` | 3 | 체력 재생 |
| `Mp` / `MpPercent` / `MpRegen` | 4 / 5 / 6 | 마나 |
| `ShieldPercent` | 7 | 보호막% |
| `Sp` / `SpRegen` | 8 / 9 | (스킬/특수 자원) |

### 이동/무게
| key | id | 의미 |
| --- | --- | --- |
| `MoveSpeed` / `MoveSpeedPercent` | 10 / 11 | 이동속도 |
| `Weight` | 12 | 무게(인벤토리/제약) |

### 공격/방어
| key | id | 의미 |
| --- | --- | --- |
| `Attack` / `AttackPercent` | 13 / 14 | 공격력 |
| `GameplayAttackPercent` | 15 | 보드 한정 공격% |
| `Defense` / `DefensePercent` | 16 / 17 | 방어력 |
| `GamePlayDefensePercent` | 63 | 보드 한정 방어% |
| `MagicResist` / `MagicResistPercent` | 18 / 19 | 마법저항 |

### 치명타
| key | id | 의미 |
| --- | --- | --- |
| `CriticalPercent` / `GameplayCriticalPercent` | 20 / 21 | 치명타 확률 |
| `CriticalDamagePercent` / `GameplayCriticalDamagePercent` | 22 / 23 | 치명타 피해 |

### 경제/드롭/유틸
| key | id | 의미 |
| --- | --- | --- |
| `ExpPercent` | 24 | 경험치 획득% |
| `ItemDropPercent` | 25 | 아이템 드롭% |
| `SellPricePercent` | 32 | 판매가% |
| `Luck` / `GameplayLuck` | 45 / 46 | 행운 |
| `CooldownPercent` / `GameplayCooldownPercent` | 27 / 28 | 쿨다운 |
| `AttackSpeed` / `AttackSpeedPercent` | 29 / 30 | 공격속도 |
| `GuardPercent` | 31 | 가드% |

### 넉백
| key | id |
| --- | --- |
| `KnockbackPercent` / `GameplayKnockbackPercent` | 33 / 34 |
| `KnockbackEfficiencyPercent` / `GameplayKnockbackEfficiencyPercent` | 35 / 36 |

### 추가공격 / 버프 적용·저항·증폭
| key | id |
| --- | --- |
| `AdditionalAttackPercent` / `GameplayAdditionalAttackPercent` | 37 / 38 |
| `BuffApplyResistancePercent` / `Gameplay…` | 39 / 40 |
| `BuffApplyAmplifyPercent` / `Gameplay…` | 41 / 42 |
| `BuffApplyResistanceReducePercent` / `Gameplay…` | 43 / 44 |

### 스케일 / 버프 지속
| key | id |
| --- | --- |
| `ScalePercent` / `GameplayScalePercent` | 47 / 48 |
| `SkillScalePercent` / `GameplaySkillScalePercent` | 49 / 50 |
| `BuffDurationEfficiencyPercent` / `Gameplay…` | 51 / 52 |
| `SelfBuffDurationEfficiencyPercent` / `Gameplay…` | 53 / 54 |
| `TeamBuffDurationEfficiencyPercent` / `Gameplay…` | 55 / 56 |
| `EnemyBuffDurationEfficiencyPercent` / `Gameplay…` | 57 / 58 |

### 실드/받피/특수 피해 효율
| key | id | 의미 |
| --- | --- | --- |
| `ShieldEfficiencyPercent` / `GamePlayShieldEfficiencyPercent` | 59 / 60 | 실드 반영 증폭 |
| `DamageTakenEfficiencyPercent` / `Gameplay…` | 64 / 65 | 받는 피해 증감 |
| `MonsterDamageEfficiencyPercent` / `Gameplay…` | 66 / 67 | 몬스터 피해 증가 |
| `BossDamageEfficiencyPercent` / `Gameplay…` | 68 / 69 | 보스 피해 증가 |
| `HealEfficiencyPercent` / `Gameplay…` | 70 / 71 | 회복 효율 |
| `MonsterDamageTakenEfficiencyPercent` / `Gameplay…` | 72 / 73 | 몬스터에게 받는 피해 효율 |
| `BossDamageTakenEfficiencyPercent` / `Gameplay…` | 74 / 75 | 보스에게 받는 피해 효율 |

> deprecated: `ImmunityPercent`(26) → `BuffApplyResistancePercent` 사용.

## 보조 스탯 채널 (별도 enum)

스탯이 단일 enum만은 아니다. 방어/속성 상성 등은 키가 묶인 별도 stat 그룹으로 표현된다 — 콘텐츠에서 `addArmorTypeStats`, `addDamageTypeStats`, `addItemGroupStats`, `addSlotStats`, `addBuffGroupStats`, `addSkillGroupStats`로 부착:

- `ArmorType` / `ArmorTypeStat` — 방어 타입 및 타입별 보정
- `DamageType` / `DamageTypeStat` — 피해 타입 및 타입별 보정
- `ItemGroupStat`, `SlotStat`, `BuffGroupStat`, `SkillGroupStat` — 아이템군/슬롯/버프군/스킬군 단위 보정

상성 행렬은 `ResourceUnit.Global.StatConstants.DamageCoefficient(armorType × damageType → damagePercent)`에 정의된다.

## 게임 프로필에서 할 일

게임은 이 76종 + 보조 채널 중 **실제로 쓰는 스탯**과 그 **가드레일(권장 상·하한)**을 `game-profiles/<game>.profile.yaml`의 `stats:`에 선언한다. 검증기는 콘텐츠가 프로필에 없는 스탯을 쓰거나 범위를 벗어나면 잡는다.
