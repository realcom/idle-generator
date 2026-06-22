# Dokkaebi Asset Workflow

작성일: 2026-06-22
상태: planning draft

## Goal

7명 팀이 `도깨비의 세계` IP 자료를 안전하게 다루면서, AI 에셋과 콘텐츠 정의를 빠르게 연결하는 제작 흐름을 만든다.

원칙은 단순하다.

- 원본 IP 이미지는 repo에 무단 복사하지 않는다.
- AI 산출물은 항상 `ai-draft`로 시작한다.
- 사람이 승인한 에셋만 `approved` 또는 `final`이 된다.
- 실제 콘텐츠 YAML은 키만 참조하고, 에셋 상태는 `asset-registry.yaml`에서 추적한다.

## Team Lanes

| Lane | Owner Role | Primary Output | AI Agent Fit |
| --- | --- | --- | --- |
| IP/Creative | Creative/IP lead | character bible, forbidden transforms, naming tone | human-led |
| Game Direction | Game director | MVP loop, feature priority, stage flow | content-designer |
| Combat | combat designer | skill list, enemy families, boss patterns | behavior-author |
| Economy | economy designer | growth curves, rewards, IAP/event seeds | economy-balancer |
| Assets | art producer | prompts, generated sprites, registry binding | asset-producer |
| UI/UX | UI designer | HUD, level-up card, result/home/shop flows | gen-ui-concept/review later |
| QA/Integration | integrator | compile, asset audit, runtime smoke, screenshots | content-reviewer |

## Asset Tiers

### Tier 0 - IP Protected Source

Examples: official Haeil/Mongryeon portrait, original sheets, licensed reference images.

- Storage: external secure location or user-provided archive only.
- Repo rule: do not commit source images unless explicit permission is documented.
- Usage: visual reference and human approval input.

### Tier 1 - Style Reference

Examples: PDF screenshots of NPC library, low-risk visual notes, internal style observations.

- Storage: docs may record observations.
- Repo rule: do not crop/extract protected image cells into committed assets.
- Usage: prompt direction, naming tone, NPC cost model.

### Tier 2 - AI Draft Asset

Examples: generated Haeil battle SD candidate, generic 요귀 enemy, skill icon draft.

- Storage: `harness/assets/dokkaebi/...` once generation is approved.
- Registry status: `ai-draft`.
- Usage: playable prototype and review only.

### Tier 3 - Approved Runtime Asset

Examples: approved hero sprite sheet, approved enemy atlas, approved UI icon.

- Storage: `harness/assets/dokkaebi/...` plus runtime copy if needed.
- Registry status: `approved` or `final`.
- Usage: build candidate.

## Folder Plan

```text
harness/design/dokkaebi/
  creative-brief.md
  asset-workflow.md
  art-direction.yaml          # next
  asset-plan.yaml             # next
  concepts/                   # generated or approved concept notes only

harness/assets/dokkaebi/
  STYLE.md                    # next
  asset-registry.yaml         # next
  sprites/
  portraits/
  icons/
  vfx/
  requests/

harness/content/dokkaebi/
  README.md                   # next
  units/
  skills/
  buffs/
  maps/
  items/
  rewards/
  achievements/
  growth/
```

## Generation Gate

For each asset request:

1. Record the asset need in `asset-plan.yaml`.
2. Create a short Korean art note and an English generation prompt.
3. Run dry-run only if using the external asset generator.
4. Ask for explicit approval before any quota-consuming generation.
5. Save outputs under `harness/assets/dokkaebi/` with `status: ai-draft`.
6. Add `used_by` only after a content id or UI component exists.
7. Promote to `approved/final` only after human review.

## Initial Asset Batch

| Priority | Key Draft | Purpose | Source Dependency |
| --- | --- | --- | --- |
| P0 | `dokkaebi.hero.haeil.battle_sd.v1` | playable hero | official Haeil reference required |
| P0 | `dokkaebi.hero.mongryeon.portrait_proxy.v1` | hero select/lock preview | official Mongryeon reference required |
| P0 | `dokkaebi.enemy.japgwi.swarm.v1` | base swarm enemy | can be AI-generated from style notes |
| P0 | `dokkaebi.enemy.dokkaebi_grunt.v1` | medium melee enemy | can be AI-generated from style notes |
| P0 | `dokkaebi.boss.night_ogre.v1` | first boss | needs art direction approval |
| P0 | `dokkaebi.map.night_forest_arena.v1` | first survival arena | can be generated with no IP likeness |
| P1 | `dokkaebi.skill.haeil_wave_slash.icon` | level-up card | depends on skill list |
| P1 | `dokkaebi.skill.mongryeon_spiritfire.icon` | level-up card | depends on skill list |
| P1 | `dokkaebi.ui.parchment_panel_9slice` | modal/card skin | can be generated from style notes |
| P1 | `dokkaebi.currency.soulflame` | meta currency | can be generated from style notes |

## Prompt Rules

Include:

- Korean folklore fantasy, Joseon-inspired clothing, mobile RPG, readable silhouette.
- Webtoon portrait or SD pixel sprite depending on target.
- Thick clean outline, controlled color accents, transparent background for sprites.
- No text, no watermark, no UI labels inside the image.

Avoid:

- Directly copying protected source images.
- Gore, horror realism, modern guns, zombie apocalypse language.
- Over-detailed costumes that collapse at 64-96 px.
- Purple-only or blue-only palettes across the whole game.

## Review Checklist

An asset is playable only if:

- silhouette reads at 64-96 px mobile scale;
- hero and enemy colors are not confused with EXP/currency pickups;
- transparent background is clean;
- pose has stable foot baseline for 4-way movement or idle;
- style does not drift into modern shooter, wuxia generic, or horror zombie;
- IP lead confirms no forbidden transformation or likeness issue.

## Next Decisions

- Pick the first implemented hero: Haeil is recommended because water-based skills are legible and beginner-friendly.
- Decide whether Mongryeon is playable in D1 or saved as D7 unlock/monetization anchor.
- Confirm whether existing NPC SD assets are legally usable in runtime, or only as style reference.
- Choose runtime target for the first playable: Phaser fastest, Godot possible if movement/juice is the focus.
