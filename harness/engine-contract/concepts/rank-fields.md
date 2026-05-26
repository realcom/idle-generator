# 순위/등급 필드 정의 (Rank Fields)

idlez 아이템(`ResourceItem`)은 여러 "순위/등급" 개념을 별도 필드로 표현한다. 혼동 방지를 위해 정의를 **정본으로 못박는다**. 콘텐츠 작성·리뷰 시 이 표를 정본으로 사용.

## 정의

| 필드 | 정의 | 변경성 | 결정 시점 | 표현 단위 |
| --- | --- | --- | --- | --- |
| **rarity** | **타고난 희귀도** — 시각적·드롭 확률 등급 | 🔒 **불변** | 가챠/드롭 시점 | 1~N (게임마다) |
| **grade** | **성장을 통해 상승하는 등급** (한계돌파·강화 단계) | 🔓 **변경** (DB 박힘) | 사용자 강화 행동 | 0~N |
| **tier** | **grade 안의 sub-step** — grade 단계 사이의 중간 단계 | 🔓 **변경** (DB) | 사용자 강화 (작은 단위) | 0~N |
| **extraGrade** | (deprecated) — 같은 grade의 계급 차이용. **rarity로 대체 가능** → 사용 비권장 | — | — | — |
| **level** | 현재 레벨 (= `requiredExps[]` 인덱스) | 🔓 변경 | exp 누적 | 1~max |

## 핵심 차이

```
rarity (불변)         "타고남"     → 3성, 4성, 5성 캐릭 (가챠 결과)
grade  (변함)         "성장"       → +1, +2, ... 한계돌파
tier   (변함)         "grade 안 step" → grade3.tier0 → grade3.tier1 → grade3.tier2 → grade4.tier0
extraGrade            (deprecated, 사용 X)
level                 "exp 강화"   → 1, 2, ..., max
```

## 업글 진행 예시 (grade × tier 결합)

```
grade=3, tier=0   ──업글──▶  grade=3, tier=1
grade=3, tier=1   ──업글──▶  grade=3, tier=2
grade=3, tier=2   ──업글──▶  grade=4, tier=0   (다음 grade로 이월)
grade=4, tier=0   ──업글──▶  grade=4, tier=1
```

→ tier 만료 시 grade가 +1 오르고 tier는 0으로 리셋.

## 가챠 게임 컨벤션 매핑

| 가챠 게임 표기 | 필드 | 예 |
| --- | --- | --- |
| 5★ 캐릭터 (드롭) | `rarity: 5` | 영원히 5성 |
| +3 한계돌파 | `grade: 3` | 사용자가 같은 캐릭 3번 합쳐서 올림 |
| 한계돌파 안 step 2/3 | `tier: 2` | grade 3 안의 세부 단계 |
| Lv. 60 (현재 레벨) | level 60 = `requiredExps[59]`까지 누적 exp 도달 | exp 강화 |

> **rarity는 영원히 안 변한다. grade·tier·level은 사용자 행동으로 변한다.**

## 게임별 사용 패턴

**필드 사용 여부·범위는 게임마다 다르다.** `game-profiles/<game>.profile.yaml`의 `rank_field_usage` 섹션(권장)에 명시하거나, 카테고리별 가이드라인을 두는 식.

### idlez 실측 사용 (1572 아이템 분석 기준)

| 필드 | Equipment | Pet | Skill | Trait | Product | Material | Unit |
| --- | --- | --- | --- | --- | --- | --- | --- |
| rarity     | —     | —   | 1~3 | 1~3 | —     | —   | —   |
| grade      | 1~6   | 1~6 | 1~3 | —   | 1~5   | —   | 1   |
| extraGrade | 1~2   | —   | —   | —   | —     | —   | —   |
| tier       | 1~3   | —   | —   | —   | —     | —   | —   |
| level      | (requiredExps) | (requiredExps) | — | — | — | — | — |

> idlez 컨벤션: **Material은 어떤 등급 필드도 안 씀** — 등급 차이는 ID/name으로만 (200101 낡은가죽 / 200102 튼튼한가죽 / 200103 빛나는가죽).
> 다른 게임은 Material에 rarity를 줄 수도 있음 — 게임 디자인 결정.

## 작성 규칙

- **불변/변경 구분** 지켜라.
  - 가챠/드롭으로 결정되는 등급 = `rarity`
  - 사용자 강화로 변하는 등급 = `grade` (+ `tier`로 미세 단계)
- **extraGrade는 신규 콘텐츠에서 사용 금지** — 같은 의도면 `rarity`로 표현.
- 기존(레거시) extraGrade가 박힌 데이터는 보존, 새 콘텐츠엔 사용 X.
- 게임마다 다른 사용 패턴은 `game-profiles/`에 명시.
- 카테고리별 어느 필드 쓸지는 schema/item.md의 카테고리 섹션 참조.

## 외부 참조

- proto: `engine/commons/Resources/ResourceItem.proto` 필드 105/108/109/112
- schema: `engine-contract/schema/item.md`
- 실데이터: `engine/client/Client/Assets/PatchResources/Items.json`
