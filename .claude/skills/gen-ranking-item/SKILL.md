---
name: gen-ranking-item
description: "랭킹 점수 통화 1종을 완성형으로 제작 (Item.Category=Ranking). 랭킹 시즌의 점수 단위 — Ranking type Achievement와 페어."
argument-hint: "[게임 id] [랭킹 점수 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 랭킹 점수 생성 (Category=Ranking)

Ranking 카테고리는 **랭킹 점수 통화** — Achievement.Ranking이 rankingItemDataId로 참조.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Ranking` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Ranking Category 필드
- `harness/engine-contract/schema/achievement.md` — Achievement.Ranking, rankingItemDataId
- `harness/game-profiles/<game>.profile.yaml` — reserved_ids.rankPoint (예: idlez = 7)

## 단계
1. **결정**(AskUserQuestion): 랭킹 종(주간/월간/시즌), 점수 단위(처치수/클리어수/누적), 시즌 id.
2. **ID 할당**: 기존 reserved_ids.rankPoint 활용 또는 신규.
3. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Ranking
   - name
   - spriteGroups (Icon)
4. **연결 Achievement**: Achievement.Ranking type을 페어로 — rankingItemDataId가 이 id.
5. **에셋**(asset-producer): Icon.
6. **_index 등록**: `category: Ranking`, `season` 태그.
7. **검수/승인**.

## 원칙
- 보통 게임 전체에 랭킹 통화 1~2개만.
- 새 시즌마다 만들지 않고, 같은 점수 통화 재사용.
- Achievement.Ranking과 페어 무결.

## 협업
- 벌크 거의 없음.
- 연결 Achievement → `/gen-achievement` (type=Ranking)
