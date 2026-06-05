---
name: gen-unity-ui-recipe
description: "디자인 토큰, asset-plan, 선택된 시안을 바탕으로 인게임 HUD/전투 UI/하단 성장 도크용 Unity uGUI recipe YAML을 작성한다."
argument-hint: "[게임 id] [인게임 UI 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# Generate Unity UI Recipe

Purpose: define what Unity should build before any prefab is generated.

## Always read

- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/unity/registries/ugui-atoms.yaml`
- Relevant concept note under `harness/design/<game>/concepts/`

## Output

Write recipes under:

`harness/unity/recipes/ingame/{slug}.yaml`

## Recipe must include

- target scene or owner, usually `GameScene`
- backend, usually `ugui`
- source concept and design source paths
- generated/reused asset keys from `asset-plan.yaml`, limited to `platforms: [unity]` or shared assets
- screen orientation and safe-area policy
- top HUD, combat arena, and bottom dock regions
- atom references from `ugui-atoms.yaml`
- data bindings as symbolic keys
- validation viewports and blockers

## Rules

- A recipe is source; generated prefab is output.
- Do not directly edit Unity prefab YAML.
- Keep bindings symbolic if engine code is not ready yet.
- Validate atom names against `harness/unity/registries/ugui-atoms.yaml`.
- Do not solve Phaser DOM/canvas implementation here; use `gen-phaser-ui-spec` for that path.
