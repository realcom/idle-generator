---
name: design-review
description: "UI 시안, 디자인 토큰, Unity recipe, 스크린샷을 기준으로 모바일성·전투 가시성·캐릭터 정체성·uGUI 구현 가능성을 리뷰한다."
argument-hint: "[게임 id] [concept/recipe/screenshot 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion
model: sonnet
---

# Design Review

Purpose: act as the design gate before approving concepts or generated UI prefabs.

## Always read

- `harness/design/<game>/critique-rubric.yaml`
- relevant concept note/image or Unity recipe
- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`

## Review order

1. Check blockers first:
   - wrong orientation
   - combat hidden by UI
   - hamster identity lost
   - non-mobile layout
   - unreadable priority information
2. Score weighted criteria from the rubric.
3. For recipes, also run `python3 harness/unity/validators/ui_prefab_validate.py` when applicable.
4. Give concrete changes as token/recipe edits, not vague taste comments.

## Output

- PASS/WARN/ERROR with evidence.
- Suggested next edits.
- Whether the concept can move to `selected`, `extracted`, or `approved`.

## Rules

- Lead with risks and blockers.
- Do not approve attractive images that cannot become repeatable UI atoms.
- Do not reject a concept only because text is imperfect; concept text is allowed to be pseudo text.
