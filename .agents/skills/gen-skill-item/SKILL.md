---
name: gen-skill-item
description: "스킬 아이템 1종을 완성형으로 제작 (Item.Category=Skill). 스킬을 인벤토리 아이템으로 표상 — 스킬북/스크롤/스킬 슬롯. 스킬 정의(ResourceSkill)와는 다르며, 아이템으로 보관·획득되는 형태."
argument-hint: "[게임 id] [스킬 아이템 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스킬 아이템 생성 (Category=Skill, ⚠️ Skill 정의와 구분)

**중요**: `gen-skill`은 ResourceSkill(전투 스킬 정의), 이 스킬은 **Item.Category=Skill (인벤토리 표상)**. 양쪽 페어로 작업해야 할 수 있음.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Skill`(=Item.Category) 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Skill Category 필드, **skillDataId(211)** / mergeSkillDataId(214)
- `harness/engine-contract/schema/skill.md` — 연결될 ResourceSkill
- `harness/engine-contract/reference-graph.md`

## 단계
1. **결정**(AskUserQuestion): 표상 종류(스킬북=영구 학습/스크롤=일회용/슬롯 아이템), 연결 스킬, 강화 가능 여부.
2. **연결 ResourceSkill 확인/생성**: 없으면 `/gen-skill`로 먼저.
3. **ID 할당**: `profile.id_ranges.item`.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Skill
   - **skillDataId**: → Skill.id (연결)
   - mergeSkillDataId (합성/진화 시)
   - grade, rarity
   - sellPrice / iapIdentifier (상점 판매)
   - levelUpMaterialItemGroups, requiredExps (강화 시)
   - spriteGroups (Icon)
5. **참조 검증**: skillDataId가 skills/_index의 approved에 실재.
6. **에셋**(asset-producer): Icon (스킬 아이콘과 별도 또는 공유).
7. **_index 등록**: `category: Skill`, `target_skill: <skill_id>` 태그.
8. **검수/승인**.

## 원칙
- **Item.Category=Skill ≠ ResourceSkill** — 헷갈리지 말 것.
- skillDataId 페어 무결 — 양쪽 어딘가 _drafts/approved에 있어야.
- 스킬북은 보통 영구 학습(소비 후 영구), 스크롤은 일회용.

## 협업
- 시리즈는 `/gen-skill-items`
- 연결 Skill 정의 → `/gen-skill` 페어
- 합성 시 mergeSkillDataId 시리즈 사전 합의
