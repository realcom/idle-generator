---
name: growstone2-slice
description: "Growstone2/Taskstonebar 전용 수직 슬라이스 작업 스킬. 돌키우기2 콘텐츠, assets/growstone2 에셋 레지스트리, Godot taskbar runtime, Steam-market MMO 경제 계약을 함께 수정하거나 검증할 때 사용한다."
argument-hint: "[작업 설명: content | asset | runtime | economy | verify]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
model: sonnet
---

# Growstone2 Slice

Growstone2는 repo에서 `taskstonebar` game id로 관리한다. 작업 범위가 콘텐츠, 에셋, Godot runtime, Steam-market 경제 계약 중 하나라도 건드리면 이 스킬을 진입점으로 쓴다.

## Always Read

- `harness/pipeline/growstone2-harness.md`
- `harness/game-profiles/taskstonebar.profile.yaml`
- `harness/content/taskstonebar/README.md`
- 관련 카테고리의 `harness/content/taskstonebar/<category>/_index.yaml`
- 에셋 작업이면 `assets/growstone2/README.md`와 `assets/growstone2/asset-registry.yaml`
- Godot 작업이면 `harness/runtime/godot-taskstonebar/README.md`

## Workflow

1. 작업 유형을 고른다.
   - content: units/items/skills/maps/buffs/achievements의 YAML 및 `_index.yaml`
   - asset: `assets/growstone2` curated/runtime/generated/raw 정리 및 registry
   - runtime: `harness/runtime/godot-taskstonebar`
   - economy: `harness/design/taskstonebar/yaml-economy-contract.yaml`, Steam itemdef, drop/sink notes
   - verify: 변경 없이 하니스 검증만 실행
2. 콘텐츠 생성은 기존 `new-content` 또는 세부 `gen-*` 스킬 규칙을 따른다. 단, game id는 항상 `taskstonebar`이고 asset path는 새 참조에서 `assets/growstone2/...`를 우선한다.
3. `_drafts`에서 새로 만든 후보는 기본 `draft`; MVP 본선 검토 세트로 올릴 때는 `_index.yaml`의 status를 `review`로 바꾼다. `approved/` 이동은 사용자 승인 뒤에만 한다.
4. Godot 전투 smoke는 starter stone loadout을 기준으로 성공해야 한다. 기본 기대값은 map 500101 clear, player stone count 3, kill count 43이다.
5. 검증은 `python3 harness/tools/growstone2_harness.py verify`를 우선 사용한다.

## Commands

```bash
python3 harness/tools/growstone2_harness.py status
python3 harness/tools/growstone2_harness.py verify
python3 harness/tools/growstone2_harness.py verify --skip-godot
python3 harness/tools/growstone2_harness.py audit-assets --release
```

## Rules

- `harness/build/taskstonebar`는 직접 수정하지 않는다. 소스 YAML에서 컴파일한다.
- `harness/assets/growstone2`는 legacy symlink다. 새 에셋과 새 참조는 `assets/growstone2`를 쓴다.
- 원작 에셋이 있으면 새 스타일로 대체하지 않는다. 신규 생성은 runtime/Steam 요구를 원작 풀로 해결할 수 없을 때만 쓴다.
- Steam Market 가치에 영향을 주는 옵션은 item definition, tag, name, registry, 또는 economy overlay에서 보이게 한다.
- 검증 실패를 숨기지 않는다. Godot 미설치처럼 환경 문제인 경우 명확히 보고한다.
