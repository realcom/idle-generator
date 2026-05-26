# Growth Pipeline (engine-contract, 불변)

> **성장곡선은 마크다운에 *식*으로 적고, 빌드 스텝이 *레벨 인덱스 JSON 배열*로 뽑아낸다.**

idlez 엔진은 성장을 곡선 객체가 아니라 **명시적 레벨 배열**로 먹는다. 코드 확인됨(`UnitStatExtensions.cs`): 스탯은 `value[]` 배열을 **`(레벨-1)`로 인덱싱하며 범위를 클램프**한다 — `GetStat = x.Value.GetClamped(level-1)`. 즉 `value[]`가 곧 성장 배열이고, 길이1이면 전 레벨 상수다. 유닛은 `level`을 가진다(맵이 `ResMap.InitLevel`로 부여, 장비는 `item.Level`, 버프는 `buff.Level`로 인덱싱).

**성장의 진짜 자리 = 스탯 `value[]` 배열** (우선):

- `AddUnitStat { type; value : repeated float }` — 스탯 → **레벨별 값 배열** (level-1 인덱싱, 클램프). ★ 유닛/버프/장비 성장 모두 여기.
- `ResourceItem.requiredExps : repeated int64` — **아이템 레벨업** 경험치 (드묾, 예: item id 11). int64라 JSON에선 문자열.

> ⚠ 검증으로 정정: **유닛은 `requiredExps`를 안 쓴다(실측 0/1010).** 몬스터의 스테이지별 파워는 *유닛 base 배열*이 아니라 **맵이 부여하는 level + 스케일링 버프/장비**에서 온다(idlez 몬스터 base 배열은 길이1=상수). 그러니 "몬스터를 강하게"는 (1) value[] 배열을 레벨별로 길게 쓰거나, (2) 맵 레벨/버프로 스케일하는 두 경로가 있다.

기획자가 배열 수백 칸을 손으로 채우는 건 비현실적이다. 그래서 **소스는 식(formula), 산출물은 배열**로 통일한다 — 이건 idlez의 실제 메커니즘(value[] 레벨 인덱싱)과 정확히 맞는다. 스탯 성장·장비 레벨 스탯·아이템 레벨업(requiredExps)·(관례) 스테이지 요구치까지 **같은 파이프라인**.

## 소스 포맷 (`content/<game>/growth/*.growth.md`)

마크다운 + frontmatter. 한 파일에 여러 트랙을 담을 수 있다.

````markdown
---
id: slime-stat-growth
target: "addStats[Hp].value"          # 스탯 value[] 배열로 컴파일 (level-1 인덱싱)
bind: { type: unit, match: { tag: Monster } }
levels: 1..200                        # value[] 길이 (1이면 상수)
output: float                         # 스탯 value는 float
---

# 슬라임 체력 성장

## hp(level)
체력 = `base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 100 |
| exp | 1.5 |
| linear | 20 |

| param | value |
| --- | --- |
| base | 120 |
| growth | 1.12 |
````

규칙:
- **식은 코드블록/인라인 백틱 안의 한 줄**로 명확히. 변수는 표로 선언.
- 허용 함수: `pow, exp, log, log2, floor, ceil, round, min, max, clamp, sqrt`. 변수: `level`(현재 인덱스) + 표에 선언한 파라미터.
- 구간 분리(piecewise)는 `when level <= N: ...` 라인을 여러 개. 위에서 아래로 첫 매치.
- 통화 단위 점프(틱) 등은 `step:` 옵션으로(아래).

## 산출물 (컴파일된 배열, 엔진 JSON에 병합)

`slime-stat-growth` → 대상 유닛의 `addStats`에서 `type=Hp`인 항목의 `value[]`:

```json
{ "addStats": [ { "value": [120.0, 134.0, 150.0, "...len=200"] } ] }
```

> 직렬화 주의(`json-serialization.md` 참조): `type=Hp`는 enum 기본값(0)이라 JSON에서 **생략**된다(그래서 위 항목에 `type` 없음). `value`는 **float**. requiredExps 같은 int64 배열이면 원소는 **문자열**(`["30","100"]`).

이 배열은 해당 정의 JSON에 머지된다 — 성장 파일은 **정의 JSON의 특정 필드를 채우는 패치**다. `bind`로 어느 정의에 붙는지 지정.

## frontmatter 전체 스펙

```yaml
id: <고유 슬러그>
target: <필드 경로>            # 우선: addStats[<StatKey>].value  (유닛/버프 스탯 성장)
                              # | equipAddStats[*].value          (장비 레벨 스탯)
                              # | ResourceItem.requiredExps        (아이템 레벨업, int64→문자열)
                              # | (관례) 맵 스테이지 요구치
bind:                         # 이 배열이 머지될 정의 선택
  type: unit|item
  match: { tag: Monster }     # 또는 id/category로 단/다수 매칭
levels: 1..200                # value[] 길이 (1=상수)
output: float|int64|int32     # 스탯 value=float; requiredExps=int64(→문자열 emit)
round: nearest|floor|ceil     # 기본 nearest
step: 0                       # >0이면 그 배수로 스냅(통화 가독성)
clamp: { min: 0, max: null }
```

## 다른 성장도 같은 방식

| 트랙 | source | target | 비고 |
| --- | --- | --- | --- |
| 유닛/몬스터 스탯 성장 | `units/*.growth.md` | `addStats[<Stat>].value` | ★ 기본 경로 (level-1 인덱싱, 클램프) |
| 장비 레벨별 스탯 | `items/*.growth.md` | `equipAddStats[*].value` | item.Level로 인덱싱 |
| 버프 레벨/스택 스탯 | `buffs/*.growth.md` | `addStats[<Stat>].value` | buff.Level로 인덱싱 |
| 아이템 레벨업 경험치 | `items/*.growth.md` | `ResourceItem.requiredExps` | 드묾, int64→문자열 |
| (관례) 스테이지 요구치 | `maps/*.growth.md` | 맵 요구치 필드 | 몬스터 스테이지 스케일과 연동 |

> 유닛 `requiredExps`는 대상이 아니다(idlez 미사용). 몬스터를 스테이지별로 강하게 하려면 value[]를 길게 쓰거나 맵 레벨/스케일 버프로.

## 검증 (tools/validate)

- 식이 파싱되고 허용 함수만 쓰는가
- 산출 배열 길이 = `levels` 범위와 일치
- 값이 `output` 타입·`clamp` 범위 내, 단조성 위반 경고
- `bind`가 실제 정의를 매칭하는가 (참조 무결성)
- int64 타깃은 문자열로, enum 기본값 항목은 생략 규칙 적용(`json-serialization.md`)

## 왜 이렇게

식은 diff 한 줄로 밸런스를 바꾸고, AI가 "100시간차 곡선 완만하게" 같은 요청을 식 파라미터 조정으로 처리하며, 산출 배열은 엔진이 그대로 먹어 런타임 변경이 0이다. (배열을 손으로 고치는 순간 의도가 사라진다 — 식이 단일 진실.)
