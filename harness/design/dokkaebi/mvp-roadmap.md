# Dokkaebi MVP Roadmap

작성일: 2026-06-22
상태: planning draft

## Target

첫 목표는 투자/팀 설득용 playable prototype이다.

완성 게임이 아니라, 다음 질문에 답하는 세로 슬라이스를 만든다.

- 해일/몽련 IP가 survival run 화면에서 즉시 읽히는가?
- 요귀 무리 처치가 30초 안에 재미있는가?
- 런 보상이 장비/수련당 성장으로 자연스럽게 이어지는가?
- AI 에셋 워크플로우가 7명 팀 속도로 굴러가는가?

## Milestone 0 - Setup

Duration: 0.5-1 day

- Create `dokkaebi` game profile and content folder.
- Clone useful `ninja2` survival-run notes as dokkaebi planning notes.
- Write asset `STYLE.md` and initial `asset-registry.yaml`.
- Define first IDs for hero, enemy, skill, map, reward.

Exit criteria:

- `python3 harness/tools/idlez_compile.py dokkaebi` can run once bootstrap content exists.
- Asset plan contains at least one P0 hero, two enemies, one map background, three skill icons.

## Milestone 1 - Combat Core

Duration: 2-3 days

- One playable hero, recommended Haeil.
- One starting auto attack.
- Three level-up choices.
- Two enemy types and one elite.
- 75-second D1 survival map.
- EXP pickup and result reward.

Exit criteria:

- Player reaches at least one level-up choice in average play.
- Skilled play can reach two choices.
- Combat remains readable with 30+ enemies on screen.

## Milestone 2 - IP Readability

Duration: 2-3 days

- Haeil battle SD candidate.
- Mongryeon portrait/locked hero card candidate.
- First boss with clear warning telegraph.
- Level-up card UI with skill icons.
- Result screen with reward and next-growth CTA.

Exit criteria:

- A reviewer can identify the hero fantasy without reading labels.
- Skill VFX colors do not hide enemies, pickups, or danger warnings.
- Boss appears materially different from swarm enemies.

## Milestone 3 - Meta Loop

Duration: 3-5 days

- Suryundang/home screen stub.
- Gold/soulflame reward.
- Equipment or talisman upgrade stub.
- Offline reward placeholder.
- Daily attendance and starter mission structure.

Exit criteria:

- Run clear -> reward -> upgrade -> next run loop is closed.
- One monetization-adjacent surface exists as stub, but no real payment integration is needed.

## Milestone 4 - Team Production Test

Duration: 1 week

Each lane produces one reviewed deliverable:

- IP/Creative: Haeil/Mongryeon bible v1.
- Game Direction: D1-D7 stage list.
- Combat: 12-skill catalogue.
- Economy: first 7-day growth/reward curve.
- Assets: P0 asset batch `ai-draft`.
- UI/UX: battle HUD + level-up + result screen concept.
- QA/Integration: compile/runtime smoke report.

Exit criteria:

- Every deliverable has an owner and a file path.
- No approved/runtime asset has unknown source or missing review state.
- One playable build or browser runtime URL can be shared internally.

## Starter Content List

### Units

| Type | Name | Runtime Role |
| --- | --- | --- |
| Hero | 해일 | beginner water-cleave hero |
| Hero | 몽련 | locked control/spiritfire hero |
| Normal | 잡귀 | fast weak swarm |
| Normal | 망령 | slow ghost swarm |
| Normal | 도깨비 하수 | medium melee |
| Elite | 부적술사 | ranged pressure |
| Elite | 산도적 우두머리 | human elite variant |
| Boss | 밤도깨비 장군 | first boss |

### Skills

| Owner | Skill | Role |
| --- | --- | --- |
| 해일 | 수류 베기 | basic cleave |
| 해일 | 파도 밀어내기 | aoe knockback/control |
| 해일 | 물소용돌이 | orbit/area damage |
| 해일 | 해일 일섬 | boss burst |
| 몽련 | 도깨비불 | tracking projectile |
| 몽련 | 몽환 연기 | slow/control field |
| 몽련 | 연꽃 결계 | defensive zone |
| 몽련 | 흑련 폭발 | late aoe ultimate |

### Meta

| System | First Version |
| --- | --- |
| Currency | 골드, 영혼불, 무료 루비 |
| Gear | 무기, 부적, 머리, 의복, 장신구, 신발 |
| Home | 수련당, 부적 공방, 영혼불 샘, 식신 우리 |
| Mission | 첫 정화, 수련당 강화, 보스 처치, 스킬 3회 선택 |

## Risk Register

| Risk | Mitigation |
| --- | --- |
| IP likeness or transformation issue | human IP lead approves every hero/major NPC generation |
| NPC style too small for combat | separate combat SD standard, larger silhouette and stronger VFX |
| Zombie Waves reference becomes too literal | borrow economy/meta structure only; expression remains Korean folklore fantasy |
| AI asset sprawl | asset-plan + registry + status gate before runtime binding |
| Engine work expands too early | clone/retarget existing `ninja2` survival runtime first |
