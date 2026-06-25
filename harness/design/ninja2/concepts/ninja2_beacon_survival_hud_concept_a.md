# Ninja2 Beacon Survival HUD Concept A

## Intent

`나뭇잎마을 키우기_인게임_검증기획서.xlsm`의 인게임 서바이벌 검증안을 기준으로 만든 세로 모바일 전투 HUD 시안. 핵심은 기존 `SurvivalBattle`의 플랫/런타임 친화적인 숲 전장 톤을 유지하면서, "3분 안에 봉화를 찾아 이동해야 한다"는 목표와 "물자/생존자/제단/항아리를 이동 중 선택한다"는 검증 포인트를 한 화면에서 읽히게 하는 것이다.

## Source Document Read

- `01_개요`: 4X + 서바이벌 결합, 봉화 탐색, 물자/생존자 구출, 실패해도 획득 물자/생존자 유지, 추가 원정 구조.
- `02_인게임 시스템`: 3분 봉화 탐색, 30초 어둠 카운트다운, 봉화 5초 상호작용, 보스 처치 후 귀환/추가 원정 선택, 물자 2초/생존자 물자 5초/제단 2초/봉화 5초 체류형 상호작용.
- `06_스폰_맵`: 사각형 오픈 필드, 장애물 없는 1차 검증, 봉화 거리 60~120초, 시작점-봉화 사이와 주변에 오브젝트 분산.
- `07_HUD_와이어프레임`: 하단 HUD 없음, 최상단 일시정지/경험치/레벨, 좌측 상단 무기/보조장비, 우측 상단 원정 재화, 상단 중앙 목표 문구와 시간.

## Art Anchor

- 주인공은 기존 `ninja2` 성소 수호자 정체성을 유지한다: 작은 SD 체형, 크림 망토, 붉은 스카프, 손등불 aura.
- 전장은 하우징 화면과 분리된 strict top-down 2D 숲 오픈 필드다. 큰 건물, 헥스 보드, 아이소메트릭 원근은 쓰지 않는다.
- 봉화는 단순 목표 마커가 아니라 어둠을 밀어내는 불이다. 금색 점선 링과 등불 화살표로 "지금 이동해야 할 곳"을 만든다.
- 적은 반복 가능한 숲 생물 스프라이트 계열로 둔다: 잎 임프, 가시 덤불, 검은 불씨 정령, 보라 버섯.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 하단 HUD와 하단 독을 제거해 전투 필드와 이동 경로를 비운다.
- 상단만 정보 밀도가 높다: 좌측 장비 슬롯, 중앙 목표/타이머/EXP, 우측 원정 자원 장부.
- 플레이어는 중앙보다 약간 아래에 두고, 봉화는 대각선 상단 방향에 보여 목적지를 한눈에 만든다.
- 생존자 물자 상자는 봉화와 다른 방향에 배치해 "더 챙길지, 봉화로 갈지"의 갈등을 만든다.
- 상호작용 오브젝트는 바닥 원형 범위와 오브젝트 상단 진행 바로 표시한다.
- 화면 가장자리에 어둠 vignette를 두되, 중앙 전투와 픽업 판독성은 보존한다.

## UI Direction

- Top-left: 44px 이상 일시정지 버튼, 무기/보조장비 슬롯 3개 이하, 각 슬롯은 아이콘 + `Lv.n` 숫자만.
- Top-center: 어두운 패널 안에 큰 목표 문구와 시간. 기본 상태 문구는 `봉화를 찾아 불을 밝혀라!` 계열, 시안에서는 짧은 한글 pseudo text만 구조 참고로 사용한다.
- Top-center lower: `Lv`와 얇은 EXP bar. 하단 EXP bar는 쓰지 않는다.
- Top-right: 목재, 석재, 식량, 생존자 수를 이번 원정 획득량 장부로 표시한다. 지갑 총량처럼 보이지 않게 아이콘 + 숫자만 둔다.
- In-world: 물자/생존자/제단/봉화는 원형 체류 범위, 진행 바, 짧은 상태 라벨로 구분한다.
- Bottom: 아무 UI도 두지 않는다. 실제 구현에서도 조이스틱/스킬 버튼을 숨기거나 자동 전투/드래그 이동 전제의 검증 모드로 분리해야 한다.

## Implementation Notes

- 기존 `ninja2_survival_visual_runtime_polish_f`와 같은 배경/VFX 밀도를 기반으로 하되, HUD 구조는 문서의 검증용 와이어프레임을 우선한다.
- 현재 `button-system.yaml`의 `battle_circular_action` 3버튼 독과 충돌한다. 이 시안은 "하단 HUD 없음" 검증 모드이므로 런타임 반영 전 입력 방식 결정을 먼저 해야 한다.
- 상호작용 진행은 런타임 native UI로 그린다. 생성 이미지의 텍스트와 숫자는 최종 문구가 아니라 배치 참고다.
- 봉화 방향 화살표는 UI overlay가 아니라 world-space guide sprite로 처리하면 이동 목표가 더 자연스럽다.
- 어둠 상태에서는 상단 목표 패널 문구와 타이머 색만 `boss_warning` 계열로 바꾸고, 필드 전체를 과도하게 어둡게 하지 않는다.
- 추가 원정 상태에서는 같은 상단 중앙 영역을 `요괴를 처치하고 살아남아라!`, 증가 타이머, `x1.01` 물자 보너스 표시로 교체한다.

## Target Runtime Notes

- Target surface: `SurvivalBattle`
- Orientation: portrait
- Runtime candidate: Phaser/Godot 공통 HUD 연구 후보. 바로 prefab/runtime 구현으로 점프하지 않고, 먼저 `ui-system-inventory.yaml`의 SurvivalBattle 변형 또는 별도 `BeaconSurvivalBattle` spec으로 분기하는 것이 안전하다.
- QA focus: 428px 모바일 폭에서 상단 장비 슬롯/목표 패널/자원 장부가 겹치지 않는지, 하단 조작 UI 없이 이동 입력이 충분히 직관적인지, 봉화와 생존자 상자 사이 선택 갈등이 플레이 중 읽히는지.

## Foundation Gaps / Questions

- 하단 HUD를 비우는 검증 모드에서 이동 입력은 화면 드래그, 가상 조이스틱 자동 숨김, 또는 기존 조이스틱 유지 중 무엇으로 고정할지 결정이 필요하다.
- 기존 `SurvivalBattle` selected 방향은 bottom-left joystick과 bottom-right 3-button action dock을 포함한다. 이 문서 기반 화면은 별도 변형으로 관리할지, selected HUD 자체를 바꿀지 디자인 리뷰가 필요하다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019ef8e2-6c5f-76d2-a8db-478e042957a5/ig_0a982a65fe2db163016a3b9ea497308191903c5f0e62ea416e.png`

![Ninja2 beacon survival HUD concept A](ninja2_beacon_survival_hud_concept_a.png)
