---
name: build-unity-ui-prefab
description: "harness/unity recipe를 Unity uGUI prefab으로 생성하거나 갱신하는 작업을 수행한다. Editor builder, atom registry, 검증 스크립트와 함께 사용."
argument-hint: "[recipe 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
model: sonnet
---

# Build Unity UI Prefab

Purpose: convert a reviewed UI recipe into generated Unity uGUI prefabs.

## Always read

- The recipe file under `harness/unity/recipes/`.
- `harness/unity/registries/ugui-atoms.yaml`.
- `harness/design/<game>/component-skins.yaml`.
- `engine/client/Client/Assets/Scripts/Components/UI/UIElement.cs` naming and auto-binding rules.

## Workflow

1. Run `python3 harness/unity/validators/ui_prefab_validate.py --recipe <recipe>`.
2. If the Editor builder does not exist, create/update it under `engine/client/Client/Assets/Editor/Harness/`.
3. Generate prefabs only through Unity Editor APIs, not by hand-writing prefab YAML.
4. Follow `UIElement.FillReference` naming conventions: `Text_`, `Btn_`, `Icon`, `Panel_`, and field-prefix-compatible names.
5. Compile/refresh Unity through the existing unity-cli flow when available.
6. Report generated prefab paths and validation status.

## Rules

- Do not modify engine runtime systems unless the recipe cannot be represented by existing uGUI atoms.
- Generated prefab paths should live under a clearly marked generated folder.
- If a prefab already exists and is hand-authored, ask before replacing it.
