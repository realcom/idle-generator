# GameUnit stat recalculation review

## 재계산 경계

`GameUnit.Stat` 재계산은 다음 경계로 나누어 본다.

- `RebuildUnitStatFromSources`: base/avatar/unit/buff의 raw `UnitStat` 값을 다시 합산한다.
- `CacheMaxResourceStats`: `MaxHp`, `MaxMp`, `MaxSp` cache를 갱신하고 HP/MP 현재값 보정 정책을 적용한다.
- `CacheResourceRegenStats`: HP/MP/SP regen cache를 갱신한다.
- `CacheCombatStats`: `Attack`, `Defense`, `MagicResist`, `GuardRatio`, `Weight`, `AttackSpeed` 등 전투 계산 cache를 갱신한다.
- `CacheMovementStats`: 이동 tick cache를 갱신한다.
- `CacheEconomyStats`: 판매/경제 계수를 갱신한다.
- `CacheScaleStats`: scale/skill scale과 size remapping cache를 갱신한다.
- group stat 재계산: armor/damage/item/slot/buff/skill group cache를 각각 재구축한다.

## 고정한 정책

- MaxHp/MaxMp 증가 시 현재 HP/MP는 증가분만큼 같이 오른다. 즉 기존 missing amount를 보존한다.
- MaxHp/MaxMp 감소 시 현재 HP/MP가 새 max를 넘으면 clamp한다.
- initial init에서는 이전 max가 0이므로 HP/MP가 max까지 채워진다.
- `ShieldPercent`로 생기는 일회성 shield는 stat 재계산 뒤의 `MaxHp`와 `ShieldEfficiency`를 사용한다.
- `UnitStat`의 MaxHp/MaxMp/Attack/Defense/MagicResist 같은 derived 공식은 saturated FixedFloat helper를 사용한다.
  정상 범위에서는 기존 FixedFloat 결과를 유지하고, 큰 값에서는 wrap 대신 `FixedFloat.MinValue`/`FixedFloat.MaxValue`로 clamp한다.
- armor/damage/skill/item group의 percent 기반 ratio cache는 `1 + percent / 100` 의미를 유지하되,
  큰 percent 합산에서는 saturated helper를 사용해 wrap으로 1 이하가 되는 일을 막는다.

## 이번에 고친 문제

- `DamageTypeGotDamageRatio` cache가 재계산 때 clear되지 않아 버프 제거 뒤 stale ratio가 남을 수 있었다.
- shield 부여 percent가 buff 적용 직전의 오래된 `ShieldEfficiency`를 사용했다. 이제 raw shield percent를 queue하고, 재계산 완료 후 최신 `MaxHp`/`ShieldEfficiency`로 shield를 산출한다.
- `FixedFloat * FixedFloat`, percent sum이 `UnitStat` 공식 안에서 overflow/wrap될 수 있었다.
  이제 `FixedFloatMath.AddSaturated`/`MultiplySaturated`와 `UnitStat` 내부 ratio helper를 사용한다.
- skill/item damage percent, critical damage percent, armor/damage type ratio cache도 같은 percent ratio helper를 사용한다.
  큰 값에서는 정확한 실수값보다 단조 clamp가 우선이다.

## 테스트

- `StatRecalculationTests` / `UnitStatTests` / `FixedFloatMathTests`
  - MaxHp/MaxMp 증가 시 missing HP/MP 보존.
  - MaxHp/MaxMp 감소 시 현재 HP/MP clamp.
  - Attack/Defense/MagicResist combat cache 갱신.
  - ShieldPercent가 최신 MaxHp와 ShieldEfficiency를 사용.
  - DamageTypeGotDamageRatio cache가 버프 제거 후 clear.
  - UnitStat 정상 공식 값, 대형 derived stat saturate, percent sum saturate.
  - FixedFloat saturated add/multiply 정상값 및 clamp.
  - armor/damage type ratio cache와 AddDamage/critical ratio가 대형 percent에서 wrap되지 않음.
