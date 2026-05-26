# Schema Card: Unit

엔진 클래스: `ResourceUnit` (`idlez-client` `Commons/Resources/ResourceUnit.proto`). 정의(Definition) 계층.
유닛 = 플레이어 영웅·펫·몬스터·보스·건물의 템플릿. 스탯 + 트리거(행동) + 드롭 + 성장(레벨 배열)의 묶음.

## 핵심 필드

| 필드 (proto field#) | 타입 | 의미 | 참조 |
| --- | --- | --- | --- |
| `id` (100) | int32 | 유닛 dataId (정본 키) | — |
| `type` (101) | enum Type | Normal / Player(1) / Pet(2) / Elite(10) / Boss(11) / MidBoss(12) / Building(20) | — |
| `name` (200) | string | 표시명 (한글 가능) | Strings |
| `tags` (1) | repeated Tag | 분류 태그 (★닫힌 Tag enum, 문자열 직렬화. 자유문자열 아님 — 예: `ScaleRemappingPossible`) | Tags enum |
| `triggers` (2) | repeated string | 행동/로직 트리거 이름 (UPPER_SNAKE `UNIT_ON*`) | → behavior |
| `initVariables` (3) | repeated InitVariable | 트리거 초기 변수 (`callerKey`:int + `value`) | — |
| `addStats` (4) | repeated AddUnitStat | 기본 스탯. `value[]`는 **레벨 배열**(`level-1` 인덱싱, 클램프). 단일값이면 상수 | → stat-catalog, growth |
| ~~`requiredExps` (6)~~ | repeated int64 | ⚠ 유닛은 **미사용**(실측 0/1010). 아이템 레벨업 전용. 유닛 성장은 `value[]`로 | (growth는 value[]로) |
| `dropAddItemGroups` (5) | repeated AddItemGroup | 처치 시 드롭 | → reward |
| `armorType` (102) | enum ArmorType | 방어 타입(상성) | → DamageCoefficient |
| `itemDataId` (203) | int32 | 대응 인벤토리 아이템 | → Item.id |
| `deadUseSkill` (402) | UseSkill | 사망 시 스킬 | → Skill.id |

## 보조 스탯 채널 (상성/그룹 보정)

`addArmorTypeStats`(103) · `addDamageTypeStats`(104) · `addItemGroupStats`(105) · `addSlotStats`(106) · `addBuffGroupStats`(107) · `addSkillGroupStats`(108) — `stat-catalog.md`의 보조 채널 참조.

## 전역(Global) 상수

`ResourceUnit.Global.StatConstants` — 상성 행렬 `DamageCoefficient(armorType × damageType → damagePercent)`, `usePercentDefense`. 모든 유닛 공통 규칙이며 게임당 1회 설정.

## 표현/연출 필드 (클라)

`prefab`(201), `sprite`(202), `uiScale`(205), `uiOffset`(206), `collideSize`(301), `hitSize`(303), `shotOffset`(306), `hitFx`(400), `animations`(1000, map). 콘텐츠 작성 시 아트 에셋 키만 채우면 된다.

## 작성 규칙

- `id`는 게임 프로필의 ID 대역 규칙을 따른다 (예: idlez 캐릭터 `1101xx`).
- 스탯 성장은 `addStats[].value`를 손으로 채우지 말고 `growth/*.growth.md` 식으로 생성 → `bind`로 이 유닛에 머지. (몬스터를 스테이지별로 강하게 하려면 value[]를 길게 쓰거나 맵 레벨/스케일 버프.)
- 행동은 `triggers[]`에 트리거 이름을 넣고, 해당 `*.behavior.yaml`을 작성.
- 적 유닛이면 `dropAddItemGroups`로 드롭을, `armorType`으로 상성을 지정.
- `tags`는 엔진 Tag enum 값만. 임의 문자열 금지 (검증기가 잡음).
- unit behavior에서 `unitMethod`를 호출하려면 receiver가 필요하다. 하네스 action alias는 owner/caller 호출 의미를 숨겨주지만, raw AST를 만들 때는 `call.caller`와 slot 규칙을 `trigger-runtime-semantics.md`에 맞춘다.
- `GetCurrentHpPercent`는 최신 엔진에서 `MaxHp <= 0`이면 `Return = 0`을 반환한다. AI는 HP 조건식을 쓸 때 divide-by-zero 방어를 따로 만들 필요는 없지만, 0 HP 설계 자체는 피한다.

## 컴파일 시 직렬화 (json-serialization.md)

컴파일되면 `Units.json`의 `units[]` 한 항목으로 들어간다. 주의: enum 기본값 생략(`type=Hp`/`type=Normal`은 키 생략), enum 표기(문자열), float `.0`, int64는 문자열. 실제 작성 형태는 `content/idlez/units/slime_green.unit.yaml` 참조.
