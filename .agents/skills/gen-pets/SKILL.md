---
name: gen-pets
description: "펫 여러 개를 한 번에 제작 (4속성 패밀리, 등급 시리즈, Category=Pet). Item+Unit 페어로 묶음 양산. 단일은 gen-pet."
argument-hint: "[게임 id] [시리즈 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 펫 벌크 생성 (Pet 시리즈)

Item + Unit 페어 N쌍을 일괄. 4속성/등급 시리즈가 가장 흔함.

## 사용 시나리오
- **4속성 패밀리**: 화/수/풍/지 펫 4종 (스탯 같음, 스킬/색만 다름)
- **등급 시리즈**: 같은 펫의 일반/희귀/영웅/전설 4등급
- **종족 묶음**: 강아지/고양이/슬라임… 5종 펫

## 저장 규칙
- Items + Units 양쪽 _drafts에 N쌍
- 두 _index 모두 N행 등록, `series: <family-key>`

## 항상 먼저 읽는다
- gen-pet 참조 문서 동일

## 단계
1. **시리즈 정의**(AskUserQuestion): 변동(속성/등급/종족), N개.
2. **페어 표 작성**: `| item_id | unit_id | name | element | hp seed | atk seed | skill_id | sprite |`
3. **ID 일괄 할당**: Item ids 연속 + Unit ids 연속 (페어 매핑).
4. **공통 growth 패밀리**: Unit Hp/Atk 곡선 + Item requiredExps 곡선.
5. **Unit 정의 N개 병렬**(content-designer): type=Pet, addStats, triggers (공통 AI 1개 권장).
6. **Item 정의 N개 병렬**: category=Pet, unitDataId(페어), Icon.
7. **공통 AI 트리거**: 시리즈 공유 behavior (모두 같은 트리거 이름 참조).
8. **에셋 일괄**: 같은 베이스 + 속성별 tint.
9. **_index 일괄 등록**: items와 units 양쪽, refs로 페어 명시.
10. **묶음 검수**: 페어 매핑 무결, 스탯 곡선 monotonic.
11. **사용자 검수**: 표 + 샘플 1쌍 (Item+Unit).
12. **일괄 승인**: 페어로 동시 이동.

## 원칙
- **페어 일관성**: Item id ↔ Unit id 표 단계에서 사전 확정.
- 4속성 패밀리는 공통 AI + 속성별 damageType만 다름.
- Item/Unit 한쪽만 v#가 올라가면 다른 쪽도 동시 갱신.

## 협업
- 단일은 `/gen-pet`
- 시리즈 스킬 → `/gen-skills`
- 공통 AI → `/gen-trigger`
