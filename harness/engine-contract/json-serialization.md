# JSON Serialization Quirks (engine-contract, 불변)

> ⚠ idlez의 콘텐츠 JSON은 **표준 proto3-JSON이 아니다.** 커스텀 직렬화라 쿽이 있다. 컴파일러/검증기는 이 규칙을 그대로 재현해야 실제 엔진이 먹는다. (2026-05-21 실제 `Units.json`/`Items.json` 대조로 확인.)

## 1. 최상위 구조

```json
{ "<x>Global": { ... }, "<x>s": [ {엔트리}, ... ] }
```
예: `unitGlobal`/`units`, `itemGlobal`/`items`. 엔트리는 `id`로 식별.

## 2. int64 → JSON 문자열

`int64`(long) 필드는 **문자열**로 직렬화된다.
- `requiredExps: ["30","100","240"]`
- `AddItem.count: "1000"`

컴파일러는 int64 타깃을 `"..."`로 emit. 검증기는 숫자로 들어온 int64를 경고/교정.

## 3. 기본값(0/false/"") 생략

proto 기본값은 JSON에서 **빠진다**. 특히 **enum 값 0 생략**이 함정:
- 스탯 `type=Hp`(UnitStatType.Hp=0) → `{"value":[120.0]}` (type 키 없음)
- 유닛 `type=Normal`(0) → `type` 키 없음 (실측 333/1010만 type 보유)
- `armorType=Normal`(0), `targetMode=None`(0) 등도 생략

컴파일러: 값이 enum 0이면 그 필드를 emit하지 않는다. 검증기/리더: 키 없음 = 기본값으로 해석.

## 4. enum 표기가 혼합 (★주의)

같은 JSON 안에서도 enum 표기가 일관되지 않다:
- **문자열 이름**: `UnitStatType`("MoveSpeed"), `ResourceUnit.Type`("Player"), `TargetMode`("Chaser")
- **정수**: `unitGlobal.statConstants.damageCoefficients`의 `armorType`/`damageType` (0/1/2)

→ 필드별로 idlez 실제 표기를 따라야 한다. 임의로 통일하지 말 것. (정본 표기는 실제 JSON에서 필드별 확인.)

## 5. float 표기

스탯 `value`, 좌표, 비율은 float (`120.0`, `0.5`). 정수처럼 보여도 `.0` 유지될 수 있음.

## 6. 중첩/맵

- 중첩 메시지는 객체(`collideOffset: {"y":0.5}` — 기본값 0인 `x`는 생략).
- proto `map<>`는 JSON 객체(키는 문자열化). 예: `animations: {"idle":"..."}`, `spriteGroups`.

## 컴파일러 체크리스트

- [ ] 최상위 `<x>Global`/`<x>s` 래핑
- [ ] int64 → 문자열
- [ ] enum 0 값 → 필드 생략
- [ ] enum 표기: 필드별(문자열 vs 정수) 정확히
- [ ] float `.0` 유지
- [ ] 기본값(0/false/빈) 전반 생략

> 권장: 가능하면 idlez의 실제 직렬화기/스키마(`Commons` proto + 커스텀 JSON)를 그대로 재사용해 컴파일하는 것이 가장 안전하다. 별도 컴파일러를 쓸 땐 이 쿽을 1:1로 맞추고, 산출물을 실제 `*.json` 샘플과 diff해 회귀 검사.
