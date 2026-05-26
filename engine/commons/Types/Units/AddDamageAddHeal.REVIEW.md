# AddDamage / AddHeal review

## 결론

`AddDamage`와 `AddHeal`은 합칠 대상이 아니다. 둘 다 "전투 효과 원자"라는 점은 같지만,
damage는 armor/defense/critical/knockback/disable/damage type을 타고 heal은 heal efficiency/guard/shield/SP 회복을 탄다.
공통화는 proto 병합이 아니라 amount 계산 helper와 skill/buff source context 추출로 접근하는 편이 안전하다.

## 이번에 확인한 문제와 수정

- `ApplyDamage`에서 guard 또는 shield가 damage보다 작을 때, `SetGuard(0)`/`SetShield(0)` 뒤에 현재 값을 빼서 흡수량이 반영되지 않았다.
  - 수정: 초기 흡수량을 저장한 뒤 saturated subtract를 적용한다.
- `ApplyDamage`에 0 이하 damage가 들어오면 `ValidWithoutDamage` 경로에서 guard를 늘리거나 음수 `ValidDamage`가 나올 수 있었다.
  - 수정: 0 이하 damage는 실제 HP/guard/shield 적용 없이 `0` valid damage로 처리한다.
- `AddHeal` 적용부의 `heal * HealEfficiencyPercent`, `GuardRatio * guardHeal`이 long 값을 `FixedFloat` 곱셈 경로로 보내 대형 수치에서 wrap될 수 있었다.
  - 수정: `LongFixedFloatMath.ScaleSaturated`로 교체했다.
- HP/MP/SP/guard/shield 누적과 queued shield percent 적용도 unchecked long 덧셈 또는 `FixedFloat` 곱셈을 탔다.
  - 수정: saturated add/scale을 사용한다.
- `AddDamage`의 skill/item damage percent, critical damage percent 합산이 큰 값에서 wrap될 수 있었다.
  - 수정: percent sum과 ratio 곱셈에 saturated helper를 사용한다.
- `ValidDamage`는 현재 HP 실제 감소량이 아니라 guard/shield 통과 후 HP에 적용하려 한 유효 타격량이다.
  오버킬이면 현재 HP보다 클 수 있다. 하네스 계약에서는 이 의미를 그대로 노출하거나 별도 `AppliedHpDamage`를 추가해야 한다.
- attack/attacked/heal/healed trigger가 붙어 있기만 해도 대형 damage/heal이 `FixedFloat` bridge를 왕복하면서 줄어들 수 있었다.
  - 수정: trigger가 `Return`을 명시적으로 설정하지 않으면 원본 long damage/heal을 유지한다.
  - 제한: trigger 내부에서 `Damage`/`ValidDamage`/`Heal`을 읽거나 `Return`으로 다시 쓰는 값은 여전히 `FixedFloat` 범위로 clamp된다.
- 이름이 `Percent`여도 단위 의미가 필드별로 다르다.
  - `AddDamage.attackPercentDamages`, `hpPercentDamages`, `maxHpPercentDamages`: raw ratio다. `1`이 100%다.
  - `AddHeal.attackPercentHeals`: raw ratio다. `1`이 100%다.
  - `AddHeal.maxHpPercentHeals`, `maxHpPercentShieldHeals`: percent다. `100`이 100%다.
  - 큰 max HP percent heal/shield heal은 `percent / 100` 정수 divisor 경로를 사용해 `FixedFloat / FixedFloat` shift overflow를 피한다.
- skill/buff 적용부가 거의 같은 파이프라인을 복사하고 있었고, 이벤트/FX/source id 같은 출처별 차이만 흩어져 있었다.
  - 수정: `DamageSourceContext`와 `HealSourceContext`를 두고 amount 계산, trigger, armor/defense, HP 적용, SP/guard/shield, 이벤트/FX, 후속 skill 사용을 공통 경로로 모았다.
  - skill/buff 차이는 context가 보존한다. skill은 critical, item/slot/group damage ratio, timeline speed, item id 전달을 유지하고 buff는 critical 없이 buff id/source position 경로를 유지한다.
- heal skill은 `IgnoreAlive`가 붙고 sender가 없을 때 null healer로 진행해 crash될 수 있었다.
  - 수정: `IgnoreAlive`는 죽은 sender 허용까지만 적용하고, sender가 없으면 ignored 처리한다.

## 테스트

- `AddDamageTests`
  - `AddDamage.*PercentDamages`가 raw ratio 단위임을 검증한다.
  - partial guard + shield가 HP damage 전에 정확히 흡수되는지 검증한다.
  - `ValidWithoutDamage` 음수 damage가 guard heal처럼 작동하지 않는지 검증한다.
  - skill/item damage percent와 critical damage percent가 큰 값에서 wrap되지 않고 큰 피해로 유지되는지 검증한다.
  - buff source damage가 `BuffDataId`/`BuffId`로 이벤트와 FX에 남고 critical로 처리되지 않는지 검증한다.
- `AddHealTests`
  - `AddHeal.attackPercentHeals`는 raw ratio, max HP 기반 heal/shield heal은 percent 단위임을 검증한다.
  - 큰 max HP percent heal/shield heal이 wrap되지 않고 안전한 percent ratio를 쓰는지 검증한다.
  - 대형 heal + heal efficiency가 wrap되지 않고 saturate되는지 검증한다.
  - 대형 guard heal이 `GuardRatio`와 함께 saturate되는지 검증한다.
  - 기존 shield에 shield heal을 더할 때 overflow 대신 saturate되는지 검증한다.
  - skill/unit heal trigger가 `Return`을 설정하지 않을 때 대형 heal을 보존하는지 검증한다.
  - `IgnoreAlive` heal skill이라도 sender가 없으면 crash 대신 ignored 처리되는지 검증한다.
  - buff source heal이 `BuffDataId`/`BuffId`로 이벤트와 FX에 남는지 검증한다.

## 남은 설계 결정

- 하네스 계약에서는 저작 DSL을 `ratio`와 `percent`로 분리하고, 엔진 필드명에 직접 기대지 않게 해야 한다.
  - 엔진 `AddDamage.*PercentDamages`로 컴파일할 때는 저작 percent `p`를 `p / 100` ratio로 변환한다.
  - 엔진 `AddHeal.attackPercentHeals`로 컴파일할 때도 저작 percent `p`를 `p / 100` ratio로 변환한다.
  - 엔진 `AddHeal.maxHpPercentHeals`/`maxHpPercentShieldHeals`로 컴파일할 때는 저작 percent `p`를 그대로 넣는다.
- trigger parameter/predefined variable은 여전히 `FixedFloat` 저장소를 통과한다. damage/heal 자체는 long-safe가 되었지만, 초대형 값을 trigger로 넘기면 `FixedFloat` 범위로 saturate될 수 있다.
- source context는 현재 `AddDamage`/`AddHeal` 내부 전용 구조다. 하네스 계약에는 엔진 내부 타입이 아니라 `source.kind`, `source.id`, `source.dataId`, `amount` 같은 중립 필드로 노출하는 편이 맞다.
