---
name: build-unity-ui-prefab
description: "harness/unity recipe를 Unity uGUI prefab으로 생성하거나 갱신한다. 9-slice sprite skin, generated icon sprite, Unity Editor builder, Play Mode visual QA까지 포함한다."
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
- Existing Editor builder/prefab if updating an already generated UI.

## Workflow

1. Run `python3 harness/unity/validators/ui_prefab_validate.py --recipe <recipe>`.
2. If the Editor builder does not exist, create/update it under `engine/client/Client/Assets/Scripts/Editor/Harness/` or the repo's existing Editor folder pattern.
3. Generate prefabs only through Unity Editor APIs. Do not hand-write prefab YAML.
4. Use uGUI elements as the real structure: `RectTransform`, `Image`, `Button`, `TextMeshProUGUI`, `CanvasGroup`, `AspectRatioFitter`, layout components when appropriate.
5. Follow `UIElement.FillReference` naming conventions: `Text_`, `Btn_`, `Icon`, `Panel_`, and field-prefix-compatible names.
6. Compile/refresh Unity through the existing unity-cli flow when available.
7. Run the builder through Unity Editor APIs, then run the recipe validator again.
8. Run a real Play Mode smoke when the prefab is intended to appear in `GameScene`.
9. Capture and inspect the actual Unity Game view after meaningful visual changes.
10. Report generated prefab paths, generated sprite paths, visual QA result, and any blocked verification.

## 9-slice skin rules

- Use 9-slice for scalable panel/button/card skins, not for semantic icons.
- For generated skin textures:
  - import as `TextureImporterType.Sprite`
  - use `SpriteImportMode.Single`
  - set `alphaIsTransparency = true`
  - set `mipmapEnabled = false`
  - set `spriteBorder = new Vector4(left, bottom, right, top)` or a symmetric border helper
- For uGUI skin objects, set `Image.type = Image.Type.Sliced`.
- Keep generated skin sprites under a clearly marked folder such as `Assets/Resources/HarnessPreview/GeneratedSprites/`.
- Keep icons as regular `Image` sprites with `preserveAspect = true`; do not 9-slice icons.
- Do not ship text fallback icons for stat/card UI unless explicitly marked temporary. Prefer generated icon sprites or verified imported sprites.
- Do not use one full-screen PNG/RawImage overlay as the implementation. Design mock PNGs are allowed as references only.

## Visual QA loop

- Prefer the repo smoke harness for GameScene previews:
  `python3 harness/tools/unity_cli_smoke.py mushroomer --skip-content-compile --skip-json-sync --skip-unity-compile --keep-playing --settle-seconds 8`
- If `/private/tmp/unity-cli` is missing, restore or locate the Unity CLI binary before claiming Unity verification.
- Verify the correct Unity project/version is open before testing. For this repo, check `engine/client/Client/ProjectSettings/ProjectVersion.txt`.
- If multiple Unity Editors are open, use the window title/project path to avoid testing the wrong project.
- Capture the real Unity Game window, not the Codex/browser window. On macOS, use the Unity window id with `screencapture -x -l <window-id> <path>`.
- Inspect the screenshot before finalizing. Check at minimum:
  - no white square/missing sprite placeholders
  - no full-screen PNG overlay hiding real uGUI elements
  - text is readable at the tested portrait resolution
  - combat, HUD, dock, and popups do not unintentionally occlude each other
  - generated icons look like icons, not emergency labels

## Rules

- Do not modify engine runtime systems unless the recipe cannot be represented by existing uGUI atoms.
- Generated prefab paths should live under a clearly marked generated folder.
- If a prefab already exists and is hand-authored, ask before replacing it.
- Include newly generated sprites and `.meta` files with the prefab change; otherwise Unity references will break.
- If Play Mode produces unrelated login/network popups, hide them only for screenshot QA and clearly say so.
