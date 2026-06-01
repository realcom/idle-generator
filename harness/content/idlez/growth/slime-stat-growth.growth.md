---
id: slime-stat-growth
bind:
  type: unit
  match: { tag: Monster }        # tag=Monster 인 모든 유닛에 머지
levels: 1..200                    # value[] 길이 (1이면 상수)
output: float                     # 스탯 value 는 float
round: nearest
clamp: { min: 0 }
targets:
  - field: "addStats[Hp].value"
    formula: hp
  - field: "addStats[Attack].value"
    formula: atk
  - field: "addStats[Defense].value"
    formula: def
---

# 몬스터 스탯 성장 (meadow tier)

검증으로 정정됨: 성장은 유닛의 `requiredExps`가 아니라 **스탯 `value[]` 배열**(level-1 인덱싱, 클램프)에 들어간다.
식 한 줄로 전 레벨 배열을 생성하고, 밸런스는 파라미터만 바꾼다. (배열을 직접 만지지 않는다.)

## hp(level) — 체력
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 120 |
| growth | 1.12 |

## atk(level) — 공격력
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 12 |
| growth | 1.11 |

## def(level) — 방어력
`value = base + linear * (level - 1)`

| param | value |
| --- | --- |
| base | 4 |
| linear | 1.5 |

> 컴파일 결과(예): addStats[Hp].value = [120.0, 134.4, 150.5, ...] (len=200, float).
> type=Hp 항목은 직렬화 시 type 키 생략 → `{"value":[...]}`.
> 몬스터를 길이1 상수로 두고 스테이지별 스케일을 맵 레벨/버프로 줄 수도 있다(idlez 기본 방식).
