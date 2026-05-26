---
name: gen-skill-items
description: "스킬 아이템 여러 개를 한 번에 제작 (스킬북 라인업, 등급/속성 시리즈, Item.Category=Skill). ResourceSkill 정의와 페어로 양산. 단일은 gen-skill-item."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 스킬 아이템 벌크 (Item.Category=Skill)

## 사용 시나리오
- 스킬북 라인업 (티어별, 직업별)
- 4속성 스크롤
- 합성 체인 (1차→2차→3차 mergeSkillDataId)

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(스킬/등급/속성), N개.
2. **연결 Skill 시리즈 확인/생성**: `/gen-skills`로 먼저 또는 같은 라운드.
3. **변동 표**: `| item_id | skill_id | name | grade | merge_target |`
4. **ID 일괄 할당**.
5. **정의 N개 병렬**: skillDataId 페어 매핑.
6. **참조 일괄 검증**.
7. **에셋 일괄**.
8. **_index 일괄**: `series`, `target_skill`.
9. **승인**.

## 원칙
- Skill 정의 시리즈와 페어 작업 필수.
- 합성 체인은 표 단계에서 ID 사전 합의.

## 협업
- 단일은 `/gen-skill-item`
- Skill 정의 → `/gen-skills` 페어
