---
id: taskstonebar-skill-tree-30-design
bind: { type: item, match: { id: 200509 } }
levels: 1..1
output: float
clamp: { min: 0 }
targets: []
---

# Taskstonebar 플레이어 스킬트리 30 성장 곡선

## 개요

- 트리 ID: `Taskstonebar`
- 레벨 포인트: `200501 스킬 포인트`
- 신규 ResourceSkill: `300301..300330`
- 신규 Skill 아이템: `200509..200538`
- 신규 해금 Recipe: `200539..200568`
- 신규 레벨 게이트: `600105..600119` (`Lv.15..100`)

30개 노드는 기존 `200502 돌팔매 수련서`에서 출발해 `200503 조약돌 난사서`, `200504 균열 강타서`, `200505 태양석 파동서`를 거쳐 6개 lane으로 갈라진다. 각 lane은 5개 노드이며 모든 노드는 최대 5레벨이다.

| Lane | Skill Items | Resource Skills | 역할 | 대표 FX 색감 |
| --- | --- | --- | --- | --- |
| 투척 | 200509..200513 | 300301..300305 | 단일/연타 투척, 기본 DPS | DustGold, AmberOrb, OriginViolet |
| 광역 | 200514..200518 | 300306..300310 | 다수 처치, 웨이브 압축 | BlueDust, StoneFusion, BoomRed |
| 보스 | 200519..200523 | 300311..300315 | 단일 고배율, 치명/보스 피해 | CrackOrange, MoonWhite, BloodMoon |
| 파밍 | 200524..200528 | 300316..300320 | 빠른 저쿨/드롭/경험치 보조 | BlueDust, GoldDust, HarvestRed |
| 방어 | 200529..200533 | 300321..300325 | 방어 보너스와 반격형 광역 | ShieldWhite, ShieldBlue, ShieldStar |
| 제련편성 | 200534..200538 | 300326..300330 | 쿨감/편성 보조, 후반 핵심기 | ForgeOrange, CubeViolet, PrimalRed |

## 해금 레벨과 비용

| Lane | Node 1 | Node 2 | Node 3 | Node 4 | Node 5 |
| --- | --- | --- | --- | --- | --- |
| 투척 | Lv15 / 2pt | Lv25 / 3pt | Lv35 / 4pt | Lv50 / 5pt | Lv70 / 6pt |
| 광역 | Lv15 / 2pt | Lv25 / 3pt | Lv40 / 4pt | Lv55 / 5pt | Lv80 / 6pt |
| 보스 | Lv20 / 2pt | Lv30 / 3pt | Lv45 / 4pt | Lv60 / 5pt | Lv90 / 6pt |
| 파밍 | Lv20 / 2pt | Lv30 / 3pt | Lv40 / 4pt | Lv55 / 5pt | Lv80 / 6pt |
| 방어 | Lv25 / 2pt | Lv35 / 3pt | Lv50 / 4pt | Lv70 / 5pt | Lv95 / 6pt |
| 제련편성 | Lv25 / 2pt | Lv40 / 3pt | Lv60 / 4pt | Lv80 / 5pt | Lv100 / 6pt |

강화 비용은 노드 깊이별로 상승한다.

| Node depth | Lv1->2 | Lv2->3 | Lv3->4 | Lv4->5 |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1 | 1 | 2 | 2 |
| 2 | 1 | 2 | 2 | 3 |
| 3 | 2 | 2 | 3 | 4 |
| 4 | 2 | 3 | 4 | 5 |
| 5 | 3 | 4 | 5 | 6 |

## 밸런스 의도

- 초반 `Lv15..25` 구간은 0.82초~2.6초 쿨다운의 체감형 자동 스킬을 배치해 레벨업 직후 바로 스킬을 누르는 재미를 준다.
- 중반 `Lv30..60` 구간은 광역/보스/방어/제련 보조가 갈라져 같은 레벨 포인트로 다른 플레이 루프를 선택하게 한다.
- 후반 `Lv70..100` 구간은 큰 연출과 높은 비용을 가진 lane 종착점으로 구성했다. 스킬 한 방 배율은 커지지만 쿨다운을 4.6~6.2초로 두어 기존 짧은 투척 스킬을 완전히 대체하지 않는다.
- 파밍 lane은 스킬 자체 피해는 낮게 잡고 `ItemDropPercent`, `ExpPercent` 스탯 성장으로 장기 보상을 준다.
- 방어 lane은 `HpPercent`, `DefensePercent` 성장과 shield 계열 FX로 생존형 빌드 정체성을 만든다.
- 제련편성 lane은 `CooldownPercent`, `AttackSpeedPercent`를 작게 누적해 다른 lane과의 시너지를 노린다.

## FX 바인딩

ResourceSkill YAML의 `playFx.prefab`은 lane 색감이 드러나도록 `FXPrefabs/Taskstonebar/<ColorIntent>/...` 형태로 작성했다. Godot runtime에서는 같은 skill id를 `sprite_catalog.gd`의 기존 growstone2 FX 키로 매핑한다.

| FX key | 사용 lane |
| --- | --- |
| `fx_hit_dust`, `fx_skill_orb` | 투척/파밍 초반 |
| `fx_fireball`, `fx_fireball_boom` | 광역/제련 폭발 |
| `fx_boss_crack_small`, `fx_boss_crack_large` | 보스/방어 균열 |
| `fx_stone_fusion` | 광역/제련 융합 |
| `fx_moonslash` | 투척 고급/보스 치명 |
| `fx_bloodmoon`, `fx_bloodmoon_cast` | 보스/원석심장 종착점 |
| `fx_shield`, `fx_hit_white` | 방어 lane |
