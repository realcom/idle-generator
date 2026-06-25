# Status Window Concept B - Character Status

## Intent

스태이터스 창의 주체를 `돌`이 아니라 `캐릭터 / 돌지기 영웅`으로 바로잡은 단독 UI 시안이다. 돌키우기2의 돌 성장/합성 감성은 무기, 가방, 룬 아이콘, 전투 수치로만 보조하고, 상태창의 중심은 플레이어 캐릭터가 된다.

## Image

- File: `status_window_concept_b_character_status.png`
- Generator: built-in `image_gen`
- Source baseline: `../ui-feature-preview.html`

## Prompt Summary

- 단독 `스테이터스` 창.
- 메인 초상은 인간형 돌지기 캐릭터: 천 모자, 갈색 모험복, 녹색 스카프, 돌 가방, 작은 붉은 장식.
- 금지 조건: 살아있는 돌, 작업돌, 펫 돌, 돌 생물체를 상태창 주인공으로 만들지 않기.
- 상단: `돌지기`, `Lv. 31`, `EXP 39%`, 공격력, 투척 속도, 치명타 확률, 드롭 보너스.
- 중단: `골드 1.85x`, `보스 +18%`, `돌 피해 +22%`.
- 하단: `룬 & 마크` 성장 슬롯과 `캐릭터 특성` 버튼 3개.

## Useful Decisions

- StatusWindow는 캐릭터 성장/전투 스탯/룬/특성 관리 창이다.
- 돌 전용 성장과 합성은 중앙 `돌 인벤토리` 및 전투/투척 시스템에서 표현한다.
- 상태창 속 돌은 장비, 투척 무기, 아이콘, 룬 재료로만 등장한다.
- 이미지 내 한글은 방향 참고용이며, 실제 런타임에서는 엔진 텍스트로 재배치한다.

## Implementation Notes

- HTML 프리뷰의 좌측 StatusWindow도 캐릭터 초상과 캐릭터 특성 기준으로 수정했다.
- 런타임 분해 우선 대상:
  - `StatusWindowFrame`
  - `CharacterPortraitPanel`
  - `CharacterStatPanel`
  - `StatusBonusBadge`
  - `RuneMarkPanel`
  - `CharacterTraitButton`
- A안의 살아있는 돌 상태창은 폐기하지 말고, 추후 `돌 상세 팝업`이나 `돌 도감` 방향에 재활용 가능하다.

## Open Questions

- 캐릭터 직업명을 `돌지기`로 고정할지, `Class` 탭에서 바뀌는 구조로 둘지 결정 필요.
- 룬/마크가 캐릭터 전용 성장인지, 장비/돌 합성과 공유되는 성장인지 확정 필요.
