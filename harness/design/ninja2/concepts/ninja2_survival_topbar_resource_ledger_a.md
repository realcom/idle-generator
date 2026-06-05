# Ninja2 Survival Topbar Resource Ledger A

## Intent

SurvivalBattle 상단바를 모바일 서바이버 장르 문법에 맞추되, `ninja2`의 장기 성장 루프를 더 강하게 드러내는 HUD 후보. 일반 서바이버 게임처럼 타이머와 HP만 남기는 방향이 아니라, 전투 중 획득한 목재·석재·영혼불·코인을 `이번 원정 수집 장부`로 계속 보여주는 것을 핵심으로 한다.

## Research Notes

- Survivor.io 계열은 상단에 타이머/경고/일시정지와 얇은 진행 정보를 두고, 큰 스킬 선택은 중앙 오버레이로 분리한다.
- Vampire Survivors 계열은 전투 필드를 최대한 비우고, 타이머와 경험치 진행을 얇은 상단/하단 라인으로 둔다.
- Brotato처럼 짧은 웨이브 후 재료 수집이 다음 성장/상점으로 연결되는 게임은 전투 중 획득량 피드백이 플레이 동기에 직접 연결된다.
- `ninja2`는 하우징/성소 성장으로 돌아가는 게임이므로 장기 재화 수집량은 부가 정보가 아니라 핵심 전투 보상 피드백이다.

Reference links:
- [Survivor.io on Google Play](https://play.google.com/store/apps/details?id=com.dxx.firenow)
- [Vampire Survivors on Google Play](https://play.google.com/store/apps/details?id=com.poncle.vampiresurvivors)
- [Brotato on Google Play](https://play.google.com/store/apps/details?id=com.brotato.shooting.survivors.action.roguelike)
- [20 Minutes Till Dawn on Google Play](https://play.google.com/store/apps/details?id=com.Flanne.MinutesTillDawn.roguelike.shooting.gp)

## Art Anchor

- 메인 캐릭터는 SD 성소 수호자: 갈색 머리, 크림색 망토, 붉은 스카프, 손등불, 따뜻한 등불 aura.
- 전투는 하우징과 분리된 strict top-down 2D 숲 전장이다.
- 적은 반복 생산 가능한 숲 생물로 유지한다: 잎 임프, 숯 정령, 가시 덤불, 보라 버섯.
- UI는 기존 `rulelocked_survival_battle_a`의 굵은 검은 외곽선, 어두운 패널, 따뜻한 금색, 청록 영혼불을 유지한다.

## Composition Rules

- Portrait 9:16 모바일 화면.
- 상단 HUD 높이는 safe-area 포함 약 120-150px 안에 유지한다.
- 중앙 전투 시야를 덮는 풀폭 불투명 배너는 피한다.
- Top-left는 캐릭터 생존 상태, top-center는 전투 시간/웨이브, top-right는 수집 장부로 역할을 분명히 나눈다.
- 수집 장부는 상점 재화 지갑처럼 보이면 안 된다. `누적 총량 + 이번 증가량`을 같이 보여 전투 보상 피드백으로 읽히게 한다.
- EXP 진행은 상단 클러스터 아래 얇은 segmented bar로 배치해 레벨업 기대감을 유지한다.

## UI Direction

- Top-left: 원형 수호자 초상, HP bar, Lv, 3개 이하 버프/상태 슬롯.
- Top-center: 큰 타이머, Stage/Wave, skull kill count.
- Top-right: 4개 resource chip vertical ledger.
- Resource chips: wood, stone, soulflame, coin. 각 칩은 이번 원정에서 실제로 획득한 누적량만 표시하고, 획득 순간에만 초록색 `+gain` 배지가 떠오른다.
- Far-right: pause button. 수집 장부와 시각적으로 붙지 않게 둔다.
- Bottom-left: 반투명 joystick.
- Bottom-right: 3개 원형 스킬 쿨다운 버튼.
- Bottom EXP bar는 생략하거나 약하게 줄일 수 있다. EXP를 상단 진행바로 올리면 하단 전투 시야가 더 열린다.

## Implementation Notes

- Phaser에서는 기존 `.hud-top`을 3열 grid로 재구성하는 후보:
  - `heroStatus`: portrait, HP, level, buff icons
  - `battleClock`: timer, stage, kills
  - `resourceLedger`: wood, stone, soul, gold rows
- 장기 재화는 예측 정산량이나 현재 보유 총량이 아니라, 전투 중 실제 획득 이벤트로 증가한 run ledger만 보여준다.
- 목재/석재/영혼불/코인 드롭이 발생하면 해당 칩의 숫자가 증가하고, `+n` 배지가 짧게 튀는 애니메이션으로 반응한다.
- EXP segmented bar는 상단 전체 폭을 쓰되, playfield pointer input을 막지 않도록 HUD root의 hit area를 최소화한다.
- 모바일에서 resource ledger가 너무 빽빽하면 portrait/HP 폭을 줄이고, resource chip은 2x2 compact grid로 바꾸는 대안을 둔다.

## Target Runtime Notes

- Target preview: `harness/runtime/survivor-runtime.html?game=ninja2&mode=battle`
- Fits current Phaser direction: flat 2D battle, edge HUD, central combat readability.
- Candidate for next `gen-phaser-ui-spec` or direct Phaser topbar implementation pass.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019e9058-5e0f-7791-a765-3dca551cfbb9/ig_0f82cca15489c604016a21118e0fb88191a81c398defccfe7d.png`

![Ninja2 survival topbar resource ledger A](ninja2_survival_topbar_resource_ledger_a.png)
