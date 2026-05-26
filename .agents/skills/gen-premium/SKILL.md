---
name: gen-premium
description: "프리미엄 권한 1개를 완성형으로 제작 (Item.Type=Premium). VIP/멤버십/구독 권한 — 기간 동안 영구 보너스. 보통 단일."
argument-hint: "[게임 id] [프리미엄 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 프리미엄 생성 (Type=Premium)

Premium은 **기간 동안 지속되는 영구 보너스 권한** — VIP, 멤버십, 구독.

## 저장 규칙
- `harness/content/<game>/items/_drafts/{id}_{name}_v#.yaml`
- `_index.yaml`에 `category: Product`, `type: Premium` 태그

## 항상 먼저 읽는다
- `harness/engine-contract/schema/item.md` — Premium 필드, 기간 + 연결 buff
- `harness/engine-contract/schema/buff.md` — 영구 buff
- `harness/game-profiles/<game>.profile.yaml` — premiumDailyReward 예약

## 단계
1. **결정**(AskUserQuestion): 권한 종류(VIP/Plus/Pro), 효과(일일보상/광고제거/슬롯확장 등), 기간(월/연/평생), 가격.
2. **ID 할당**: `profile.id_ranges.item`.
3. **연결 Buff/Achievement 결정**: 영구 buff는 buff로, 일일보상은 reserved_ids.achievement.premiumDailyReward와 연결.
4. **정의**(content-designer): `_drafts/{id}_{name}_v1.yaml`
   - category: Product, type: Premium
   - iapIdentifier, priceUsd
   - durationSeconds (또는 startAt/untilAt 패턴)
   - applyBuffOnUse → Buff.id (효과)
   - spriteGroups (Icon + 배지)
5. **에셋**(asset-producer): Icon + 배지 sprite.
6. **_index 등록**: `type: Premium`, `tier` 태그.
7. **검수/승인**.

## 원칙
- 보통 1~2종만 — 시리즈로 안 만듦 (벌크 스킬 없음).
- 효과는 buff/achievement로 — Premium 아이템 자체는 활성화 트리거.
- 갱신 정책은 엔진 처리 (자동 갱신 등).

## 협업
- 효과 buff → buff _drafts
- 일일보상 → reserved_ids.achievement.premiumDailyReward 활용
