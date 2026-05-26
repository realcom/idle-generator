# FixedFloat 리뷰 노트

목표: 대형 전투 수치와 소수 배율 계산을 분리해, overflow로 값이 뒤집히거나 전투가 멈추는 상황을 막는다.

## 현재 타입 의미

- `FixedFloat`는 Q48.16 fixed point다. 실제 값은 `Raw / 65536`이다.
- 표현 가능한 값 범위는 대략 `+/- 1.4e14`다.
- `long -> FixedFloat` 변환은 `value * 65536`을 수행한다.
- `FixedFloat * FixedFloat`는 `a.Raw * b.Raw >> 16`을 수행한다.
- `FixedFloat / FixedFloat`는 `a.Raw << 16 / b.Raw`을 수행한다.

## 결론

- HP, damage, currency처럼 크게 커지는 절대 수치는 `long`을 유지하는 게 맞다.
- percent, ratio, probability, duration, vector처럼 소수/배율 의미가 강한 값은 `FixedFloat`가 맞다.
- 위험한 지점은 `long` 대형 수치를 `FixedFloat`로 바꾼 뒤 배율 체인에 태우는 경우다.
- 전투 계산은 정확한 소수 재현보다 “wrap/예외 없이 단조롭게 clamp”되는 쪽이 더 중요하다.

## 확인된 리스크

- `long` damage가 `FixedFloat`로 변환될 때 raw overflow가 날 수 있다.
- `FixedFloat` 곱셈은 중간 `Raw * Raw`가 `long` 범위를 넘으면 wrap된다.
- 아머/방어/크리티컬/피해증감은 작은 배율이지만, 대형 damage에 반복 적용될 때 wrap 위험이 커진다.
- 트리거 VM의 `Damage`/`ValidDamage`/`Heal`/`Return` 값 채널은 현재 `FixedFloat` 기반이라 대형 damage/heal을 온전히 표현하지 못한다.
  단, `Return`을 설정하지 않은 관찰용 trigger는 원본 long 값을 보존한다.

## 현재 보강

- `LongFixedFloatMath.ScaleSaturated(long value, FixedFloat ratio)`를 추가했다.
- `LongFixedFloatMath.AddSaturated(long a, long b)`를 추가했다.
- `LongFixedFloatMath.SubtractSaturated(long a, long b)`를 추가했다.
- `LongFixedFloatMath.ToFixedFloatSaturated(long value)`를 추가해, 기존 `FixedFloat` 트리거 훅으로 넘어갈 때 wrap 대신 clamp한다.
- 이 helper는 대형 `long` 값에 작은 `FixedFloat` 배율을 적용할 때 `long` 범위 안에서 clamp한다.
- `FixedFloatMath.AddSaturated`/`MultiplySaturated`를 추가했다.
  `UnitStat` derived 공식처럼 FixedFloat 값을 계속 유지해야 하는 좁은 경로에서 wrap 대신 clamp한다.
- `FixedFloatMath.RatioFromPercentSaturated`를 추가했다.
  `1 + percent / 100` 형태를 공통화하되, divisor는 정수 `100` 경로를 사용해 큰 percent에서 `FixedFloat / FixedFloat` shift overflow를 피한다.
- max HP 기반 heal/shield heal과 queued shield percent도 순수 percent 나눗셈에서 정수 `100` divisor를 사용한다.
- `AddDamage.GetDamageLong`을 추가해 base damage, attack/hp/maxHp 기반 damage 합산을 `long` 중심으로 처리한다.
- `GameUnit.AddDamage` 기본 경로는 damage를 `long`으로 유지한 채 critical, armor, defense, damage taken efficiency를 적용한다.
- `GameSkill`/`GameBuff`/`GameUnit` 트리거 훅은 기존 `FixedFloat` 계약을 유지하되, long damage/heal을 saturated bridge로 넘긴다.
  `Return`이 명시적으로 설정되지 않은 경우에는 bridge 값을 읽지 않고 원본 long 값을 유지한다.
- `AddHeal.GetHeal`/`GetShieldHeal`도 `long` 중심 합산과 saturated ratio 적용으로 바꿨다.
- `LongFixedFloatMathTests`에서 정상값, 음수 부호, 큰 양수/음수 clamp, saturated add/subtract, fixed bridge를 검증한다.
- `FixedFloatMathTests`/`UnitStatTests`에서 FixedFloat saturated helper, percent ratio helper, UnitStat derived 공식의 정상값/대형값 clamp를 검증한다.
- `ResourceTriggerEventTests`에서 `long.MaxValue` base damage와 no-return attack/attacked trigger가 ignored/wrap 없이 통과하는지 검증한다.
- `AddHealTests`에서 일반 힐 값, 대형 힐 합산 clamp, no-return heal/healed trigger의 long 보존을 검증한다.
- `AddDamageTests`/`AddHealTests`에서 percent 이름 필드의 실제 단위가 raw ratio인지 percent인지 characterization test로 고정한다.

## 추천 리팩터링 순서

1. 완료: `long x FixedFloat ratio` saturated helper와 단위 테스트 추가.
2. 완료: `AddDamage.GetDamageLong`의 내부 합산을 `long` 중심으로 바꿨다.
3. 완료: `ApplyArmor`, `ApplyDefense`, `ApplyDamageTakenEfficiency`, `ApplyCritical` 기본 경로를 `long damage + FixedFloat ratio` 방식으로 이전했다.
4. 완료: `AddHeal.GetHeal`/shield heal도 같은 long-safe helper로 맞췄다.
5. 완료: stat 재계산의 `MaxHp`, `Attack`, `Defense` 등 절대값/배율 경계를 나누고 UnitStat derived 공식에 saturated helper를 적용했다.
6. 완료: skill/item damage percent, critical damage percent, armor/damage type ratio cache의 percent 합성과 ratio 곱셈에 saturated helper를 적용했다.
7. 완료: 관찰용 trigger가 붙어도 대형 damage/heal 원본 long 값이 줄지 않도록 `Return` 미설정 경로를 분리했다.
8. 다음: 트리거가 대형 damage/heal을 읽고 수정해야 하는지 결정한다. 필요하면 `FixedFloat` predefined variable과 별개로 long value channel을 추가한다.
9. 이후: 하네스 검증기에 “절대 대형값은 long, 배율은 FixedFloat” 규칙과 ratio/denominator 범위 검증을 넣는다.
