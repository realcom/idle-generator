---
name: gen-weapon
description: "무기 1종을 완성형으로 제작 (Item.Category=Weapon). Katana/Gun/Dagger/Hammer 등 Type별 무기 — 장착 스탯·옵션·강화 재료·티어. 단일은 여기, 시리즈는 gen-weapons."
argument-hint: "[게임 id] [무기 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 무기 생성 (Category=Weapon)

ResourceItem(Category=Weapon)의 수직 슬라이스. Type(Katana/Gun/Dagger/Hammer…)·등급·장착 스탯·강화 재료를 끝까지.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `harness/content/<game>/items/approved/{id}_{name}.yaml`
- `_index.yaml`에 `category: Weapon` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Category=Weapon 필드셋, Type 종류, equipAddStats/options/levelUpMaterialItemGroups
- `harness/engine-contract/stat-catalog.md` — Attack/AttackPercent/CriticalPercent 등
- `harness/engine-contract/reference-graph.md` — Item.equipAddBuffs(→Buff), equipSkillDataIds(→Skill), levelUpMaterialItemGroups(→Item)
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.item, 가드레일
- `harness/content/<game>/items/_index.yaml`

## 단계
1. **결정**(AskUserQuestion): Type(Katana/Gun/Dagger/Hammer…), grade/rarity/tier, 장착 스탯 종류(Attack 위주), 장착 버프/스킬, 강화 재료 계보.
2. **ID 할당**: `profile.id_ranges.item` 대역 + `_index.yaml` 스캔.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Weapon, type: <Katana/...>, grade, rarity, tier
   - equipAddStats (value[] 자리), equipAddBuffs(→Buff.id), equipSkillDataIds(→Skill.id)
   - requiredExps (레벨업 자리)
   - levelUpMaterialItemGroups (→Material Item.id)
   - options/optionCounts (랜덤 affix)
   - spriteGroups (Icon 필수)
4. **성장**(economy-balancer): `harness/content/<game>/growth/{id}_{name}.growth.md` → equipAddStats[].value[], requiredExps[].
5. **참조**: 강화 재료(→Material), 장착 스킬/버프.
6. **에셋**(asset-producer): Icon + 장착 sprite.
7. **_index 등록**: `category: Weapon`, `type` 태그.
8. **검수/승인**.

## 원칙
- equipAddStats는 반드시 growth 식과 페어 — value[] 손으로 채우지 말 것.
- 강화 재료 계보는 같은 무기 시리즈의 다음 등급(or Material 시리즈) 미리 확정.
- 옵션 affix는 등급별 weight 풀 구성 (reward.md 패턴 유사).

## 협업
- 시리즈는 `/gen-weapons`
- 강화 재료 → `/gen-material(s)` 먼저
- 장착 스킬 → `/gen-skill`
- 장착 버프 → buff _drafts
