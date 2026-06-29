# Skill Detail Window Concept A

## Intent

StatusWindow skill slots should open a focused skill description window instead of spending Skill Points immediately. The modal is the single place where the player confirms learning or leveling a skill.

## Source

- Image: `concepts/skill_detail_window_concept_a.png`
- Generated from the Taskstonebar modal/button system and the selected `status_window_concept_c_tbh_stat_skill_layout` direction.
- Parent references: `item_detail_modal_concept_a`, `window_title_bar_concept_c_forged_rail`, `modal-system.yaml`, `button-system.yaml`

## Composition

- Shared desktop modal chrome: forged dark frame, oxblood title bar, brass trim, small X close button.
- Compact body sized for `ModalHost`, with the status window and taskbar combat still visible under a dim scrim.
- Left column: 64px skill icon slot, current level chip, and auto-equip state chip.
- Right/body rows: requirement, owned Skill Points, current effect, next effect, cost/status.
- Footer: secondary close button and one primary CTA. The CTA text changes between `학습`, `레벨업`, and `최대`.

## Interaction Rules

- Clicking a StatusWindow skill slot only selects the skill and opens this modal.
- Skill Point spending happens only through `Btn_SkillDetailConfirm`.
- If the skill is not learned and requirements are met, the confirm button performs unlock.
- If the skill is learned and below max level, the confirm button performs level-up.
- If the skill reaches max level or requirements/cost fail, the confirm button is disabled and the reason is shown in the modal body.
- Learned skills are treated as auto-equipped by the progression/combat runtime; the modal shows this as an explicit chip.

## Runtime Notes

- Target runtime: `harness/runtime/godot-taskstonebar/scripts/main.gd`
- Modal host: existing `ModalHost` / `_active_generated_modal_host()`
- Suggested runtime node ids:
  - `Modal_SkillDetail`
  - `Scrim_SkillDetail`
  - `Text_SkillDetailTitle`
  - `Slot_SkillDetailIcon`
  - `Text_SkillDetailLevelChip`
  - `Text_SkillDetailAutoEquipChip`
  - `Text_SkillDetailRequirement`
  - `Text_SkillDetailPoints`
  - `Text_SkillDetailCurrentEffect`
  - `Text_SkillDetailNextEffect`
  - `Btn_SkillDetailConfirm`
  - `Btn_SkillDetailCancel`

## Foundation Gaps

- The generated image contains representative Korean labels; final runtime text should come from live `ProgressionState` previews.
- Future asset pass can replace the inline stone projectile icon with a dedicated skill icon atlas entry.
