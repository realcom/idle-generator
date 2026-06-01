---
name: gen-item
description: "아이템 1종 제작 라우터 — Category 결정 후 적합한 세부 스킬로 위임. 분류가 불명확할 때 진입점. 분류가 명확하면 직접 gen-weapon/gen-equipment/gen-material/gen-pet/gen-mine/gen-iap 등을 호출하는 게 더 빠름."
argument-hint: "[게임 id] [아이템 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 아이템 라우터 (Category 결정 → 세부 스킬 위임)

idlez에서 **아이템은 가장 넓은 개념**(Weapon/Equipment/Material/Pet/Mine/Product/Stat/Skill/Trait/Recipe/System/Character/Ranking/Unit). 카테고리에 따라 필요한 스킬이 다르므로 **분류 결정이 먼저**.

## 사용 시점
- 사용자가 카테고리를 모를 때 ("아이템 만들어줘")
- 분류가 헷갈릴 때 ("이건 펫인가 유닛아이템인가?")
- 분류 명확하면 직접 세부 스킬 호출이 더 빠름.

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Category 분류표
- `harness/game-profiles/<game>.profile.yaml` — id_ranges, reserved_ids
- `harness/content/<game>/items/_index.yaml`

## 단계

### 1. Category 결정 (AskUserQuestion)
사용자 요청을 듣고 적합한 Category 후보 3~4개 제시. 결정되면 **즉시 위임**.

| Category | 위임 스킬 | 어떤 경우 |
| --- | --- | --- |
| Weapon | `/gen-weapon` | 검/총/단검/해머 등 무기 |
| Equipment | `/gen-equipment` | 머리/가슴/링 등 슬롯 장비 |
| Material | `/gen-material` | 가죽/광물/파편 등 재료 |
| Pet | `/gen-pet` | 펫 (Unit 페어 자동) |
| Mine | `/gen-mine` | 광맥 (방치형) |
| Product (일반 IAP) | `/gen-iap` | 가챠/번들/패키지 |
| Product/GamePass | `/gen-gamepass` | 시즌 패스 |
| Product/Attendance | `/gen-attendance` | 출석 보상판 |
| Product/Ticket | `/gen-ticket` | 입장권 |
| Product/Boost | `/gen-boost` | 시간제 부스터 |
| Product/Utility | `/gen-utility` | 리셋권/이름변경 |
| Product/SelectableBox | `/gen-selectable-box` | 선택 상자 |
| Product/Premium | `/gen-premium` | VIP/멤버십 |
| Product/Recipe | `/gen-recipe` | 제작 레시피 |
| Stat | `/gen-stat-item` | 스탯 강화(능력서/룬) |
| Skill (Item) | `/gen-skill-item` | 스킬북/스크롤 (ResourceSkill ≠) |
| Trait | `/gen-trait` | 특성/패시브 |
| System (Currency) | `/gen-currency` | 통화 (드뭄, 엔진 합의 필요) |
| Character | `/gen-character` | 플레이어 본체 (Unit 페어) |
| Ranking | `/gen-ranking-item` | 랭킹 점수 통화 |
| Unit (Item) | `/gen-unit-item` | 영웅 카드/소환서 (Pet ≠) |

### 2. 위임 실행
결정된 Category에 대응되는 세부 스킬 호출. 사용자 의도 그대로 전달.

### 3. (직접 처리 안 함)
이 스킬은 **라우터** — 정의 작성·검증·승인은 모두 세부 스킬에 위임.

## 원칙
- **분기 결정만이 임무** — 위임 후 종료.
- Category 헷갈리는 경계(Pet vs Unit-item, Skill 정의 vs Skill 아이템, Currency vs 일반)는 schema 카드 참조.
- 사용자가 명확하게 Category 말하면 즉시 위임 (Q 생략 가능).

## 협업
- 시리즈/벌크는 `/gen-items` (벌크 라우터)
- 직접 카테고리 알면 해당 세부 스킬 바로 호출
