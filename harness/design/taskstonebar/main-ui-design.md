# Taskstonebar / 돌키우기2 Main UI Design

## 1. Purpose

이 문서는 `돌키우기2 / Taskstonebar`의 메인 UI 시안 생성을 위한 기준서다.

다음 단계에서 여러 장의 UI 시안을 만들 때, 모든 시안은 이 문서의 핵심 구조를 유지하고 `Concept Variation Plan`의 축만 다르게 가져간다. 선택된 시안은 이후 `ui-system-inventory.yaml`, 버튼/모달 시스템, Godot UI recipe, 런타임 구현의 기준이 된다.

## 2. Source Alignment

### TBH에서 가져올 구조

- 작업표시줄 위에서 자동 전투가 계속 보이는 PC idle RPG 감각.
- 여러 개의 독립적인 데스크톱 창처럼 보이는 UI.
- 스테이지 전투, 상자 드롭, 큐브 가공, 영구 성장, 포탈 진행이 한 화면에 연결되는 루프.
- 오프라인 보상과 온라인 전용 드롭의 차이를 UI에서 명확히 보여주는 구조.

### TBH에서 직접 가져오지 않을 것

- 클래스/장비 6,000종/룬 197개 같은 과밀한 영웅 RPG 정보량.
- 원작 고유 명칭, 배치, 아이콘, 장비 등급 표현의 직접 복제.
- 영웅 중심 인벤토리. 돌키우기2는 `돌`, `광석`, `큐브`, `Steam 자산`이 중심이다.

### 돌키우기2로 바꿀 핵심

```text
켜둔 동안 하단 전투 스트립에서 돌지기가 돌을 던진다
→ 몬스터/광맥/보스가 재료와 상자를 떨어뜨린다
→ 재료는 돌에게 먹이거나, 드래그 머지하거나, Steam Market에 판다
→ 활성 돌 인벤토리와 장비 보관함이 강해지고, 포탈 깊이가 열린다
```

## 3. Product Fantasy

메인 UI가 전달해야 하는 감정은 `내 PC 작업표시줄 위에서 작은 돌 세계가 계속 굴러간다`이다.

유저는 게임을 크게 열어두지 않아도 하단 스트립에서 진행을 본다. 클릭하면 세 개의 작업 창이 떠서 현재 돌의 상태, 성장 작업, 포탈 진행, 보상 수령을 처리한다. 메인 UI는 대시보드가 아니라 `작업표시줄 속 작은 MMO 작업장`이어야 한다.

## 4. Main Screen Information Architecture

### Persistent Layer

- Desktop background: OS 위에 떠 있는 느낌을 만든다. 풀스크린 판타지 배경보다 실제 데스크톱 노출이 우선이다.
- Top resource counters: 골드, 루비, 조약돌 파편, 이끼 광석, 큐브 촉매, 상자 대기열.
- Utility icons: 이벤트, 설정, 메뉴, Steam Inventory refresh.
- OS taskbar: 화면 최하단에 남겨 작업표시줄형 게임임을 고정한다.

### Bottom Combat Strip

하단 전투 스트립은 항상 살아 있는 메인 HUD다.

책임:

- 현재 스테이지와 지역 이름.
- 돌지기 캐릭터의 자동 전투.
- 몬스터/광맥/보스 체력.
- 투척 돌, 피해 숫자, 희귀 드롭 알림.
- 자동 전투 상태, 자동 스킬 토글, 보상 로그.
- 하단 인벤토리 독을 두지 않는다. 작업표시줄 위 영역은 전투 씬으로 사용한다.

규칙:

- 캐릭터는 스트립 안에 원래 그려진 것처럼 보여야 한다. 합성 티, 큰 그림자, 사각 외곽, 선택 테두리를 금지한다.
- 돌지기는 왼쪽, 적/광맥은 오른쪽, 드롭 알림은 중앙 또는 우측 상단에 짧게 뜬다.
- 전투 스트립은 장식 프레임보다 실제 전투 가시성이 우선이다.

### Left Window: 스테이터스

왼쪽 창은 현재 돌지기/편성의 전투 스탯과 장기 업그레이드를 담당한다.

주요 정보:

- 대표 돌지기 또는 메인 돌 초상: 귀여운 이끼 돌/돌지기 표정과 현재 역할.
- 레벨, EXP, HP 또는 내구도.
- 공격력, 공격 속도, 치명타 확률, 치명타 피해, 골드 획득, 드롭 보너스.
- 룬/문양/특성 트리.
- 스킬 포인트 또는 성장 포인트.

주요 액션:

- 상세 정보.
- 룬/문양 투자.
- 성장 보너스 확인.

### Center Window: 돌지기

중앙 창은 TBH의 `Hero` 패널 같은 밀도 높은 핵심 조작 공간이다. 단, 영웅 장비창을 그대로 복제하지 않고 `돌지기`, `돌 / 장비 탭바`, `돌 전용 인벤토리`, `장비 보관 인벤토리`를 한 창 안에서 연결한다.

주요 정보:

- 중앙 캐릭터/돌지기 초상, 클래스/역할, 레벨.
- 좌우 장착/돌 슬롯: 무기, 보조석, 룬, 펫/장신구, 잠금 슬롯.
- 상단 탭바: `돌` / `장비`를 전환한다. 기본은 `돌` 탭이며, 선택한 인벤토리만 같은 본문 영역에 표시된다.
- `돌` 탭: 6칸 x 5줄 그리드, 활성 슬롯, 비활성 슬롯, 쿨타임 표시.
- `장비` 탭: 6칸 x 5줄 그리드, 무기, 룬, 펫, 장신구, 상자 등 돌이 아닌 아이템 보관.
- 활성 슬롯은 맨 왼쪽 위부터 순서대로 열린다.
- 활성 슬롯에 놓인 돌만 쿨타임이 돌면서 공격한다.
- 돌 합성은 별도 하단 탭이 아니라 돌 전용 인벤토리 안에서 드래그로 처리한다.

주요 액션:

- 재료를 돌에게 먹이기.
- 같은 티어 돌을 다른 돌 위로 드래그해서 상위 돌 만들기.
- 돌을 활성 슬롯에 배치하거나 비활성 슬롯으로 보관하기.
- 장비/펫/스킬 슬롯 확인하기.
- 가방 열기.

위계:

- 1순위 영역: `돌 / 장비` 인벤토리 탭바.
- 2순위 영역: 현재 선택된 인벤토리 본문. 기본은 `돌 전용 인벤토리`.
- 3순위 CTA: 장착/해제, 상세 보기, 가방.

### Right Window: 포탈

오른쪽 창은 진행과 스테이지 선택을 담당한다. 보상 카드와 오프라인 정산은 이 포탈 맵 본문에 넣지 않는다.

주요 정보:

- Act/막 탭.
- 난이도 선택 드롭다운.
- 낡은 양피지 지도 위의 곡선형 스테이지 경로.
- 현재 스테이지 노드와 보스 노드.
- 스테이지 권장 레벨 또는 위험도.

주요 액션:

- 현재 스테이지 이동.
- 포탈 다음 막 확인.
- 보스 입장 또는 준비 상태 확인.

## 5. Economy UI Rules

돌키우기2는 Steam Market MMO 구조를 UI에서 숨기지 않는다. 단, 인게임 거래소처럼 보이면 안 된다.

표현 규칙:

- Marketable 아이템에는 작은 Steam/market badge를 붙인다.
- `팔기`는 인게임 주문장이 아니라 Steam Market 페이지 열기다.
- `먹이기`와 드래그 머지는 marketable 아이템을 소모하는 핵심 액션이므로 irreversible 느낌을 줘야 한다.
- 오프라인 보상 창에는 상자/촉매/고급 광석을 보여주지 않는다. 온라인 전용 보상과 명확히 분리한다.
- 희귀 드롭은 전투 스트립에서 먼저 감정적으로 보여주고, 이후 가방/Steam Inventory 갱신으로 연결한다.

## 6. Visual Contract

### Art Identity

- 원작 돌키우기1 픽셀 밀도와 귀여운 돌 감성을 유지한다.
- Steam PC 게임답게 프레임, 타이틀, 보상 카드, 버튼의 마감만 한 단계 올린다.
- 화면은 어둡고 무겁기보다 `작고 진한 픽셀 장난감`처럼 보여야 한다.

### Frame Language

- 창은 독립 데스크톱 위젯처럼 보인다.
- 프레임은 검은 철, 낡은 갈색, 붉은 타이틀 바, 금색 포인트를 사용한다.
- 내부는 parchment/stone well/slot grid를 섞되 텍스트 대비를 잃지 않는다.

### Color Anchors

- `panel_outer`: frame border.
- `panel_mid`: main frame body.
- `panel_inner`: dark content well.
- `title_gold`: titles and key labels.
- `ruby_red`: catalyst and premium emphasis only.
- `moss_green`: stone growth and early ore identity.
- `hp_red`, `exp_blue`: progress bars.

### Pixel Contract

- 32px icon family.
- 48-64px bottom hero frame.
- nearest-neighbor scaling only.
- 1-2px dark sprite outline.
- no blurred antialias, soft vector glow, or smooth mobile UI.

## 7. Interaction States

메인 UI 시안은 최소한 다음 상태를 상상할 수 있어야 한다.

1. Default Farming: 자동 전투 중, 세 창이 열린 기본 상태.
2. Rare Drop: 전투 스트립에서 marketable 아이템이 떨어진 순간.
3. Feed Ready: 재료가 충분해서 돌 먹이기 CTA가 켜진 상태.
4. Drag Merge Ready: 같은 티어 돌을 드래그 합성할 수 있는 상태.
5. Active Stone Cooldown: 활성 슬롯의 돌들이 각자 쿨타임을 돌며 공격하는 상태.
6. Offline Return: 오프라인 골드/EXP/basic ore만 수령하는 상태.
7. Boss Gate: 포탈 보스 노드 진입 직전 상태.

## 8. Concept Variation Plan

첫 시안 묶음은 기본 4개를 권장한다. 사용자가 원하는 경우 `N`을 늘려도 되지만, 모든 시안은 위 정보구조를 유지한다.

### Concept A: Orthodox Taskbar Overlay

- TBH식 세 창 구성을 가장 강하게 유지한다.
- 빨간 타이틀 바, 검은 철 프레임, 데스크톱 배경, 하단 전투 스트립을 명확히 보여준다.
- 선택 기준: 작업표시줄 게임 정체성이 제일 강한가.

### Concept B: Split Inventory Priority

- 중앙 돌지기 창을 TBH `Hero` 패널처럼 가장 밀도 있게 만든다.
- 돌 전용 인벤토리와 장비 보관 인벤토리를 상단 탭으로 명확히 나눈다.
- 돌 전용 인벤토리에서 활성 공격 슬롯과 드래그 머지가 한눈에 들어오게 한다.
- 선택 기준: 돌키우기2의 돌 운용과 장비 보관 구조가 제일 명확한가.

### Concept C: Steam Market MMO Priority

- 드롭, Steam Inventory badge, marketable 재료, 먹이기/드래그 머지 소모 흐름을 더 뚜렷하게 보여준다.
- 전투 스트립의 희귀 드롭 감정과 오른쪽 보상 카드가 중요하다.
- 선택 기준: 켜두면 실제 가치 있는 재료가 쌓인다는 욕망이 보이는가.

### Concept D: Minimal Taskbar First

- 세 창을 조금 더 작고 접이식 위젯처럼 만들고, 하단 전투 스트립을 주인공으로 둔다.
- 게임이 데스크톱을 덜 가리고 항상 켜두기 좋다는 느낌을 강화한다.
- 선택 기준: 작업 중 켜두는 게임의 설득력이 좋은가.

## 9. Prompt Invariants For Future Mockups

모든 메인 UI 시안 프롬프트에 반드시 들어갈 내용:

- Full-screen 16:9 Korean retro PC idle RPG UI.
- Windows-like green desktop background and OS taskbar.
- Three ornate floating pixel windows: `스테이터스`, `돌지기`, `포탈`.
- Bottom combat strip with stone keeper throwing rocks.
- Cute mossy living stone as the true protagonist.
- Stone feeding, drag-merge stone inventory, equipment storage inventory, portal progression, chest rewards.
- Marketable material badges and online-only rare drop feeling.
- Crisp pixel art, black/burgundy/gold frames, parchment panels, readable compact UI.

금지:

- pasted character cutout.
- thick shadow blob under hero.
- direct TBH UI copy or logos.
- mobile game landing page.
- modern flat dashboard.
- hero/class/equipment RPG dominance.
- unreadable generated text as the main value.

## 10. Selection Rubric

시안 선택은 다음 기준으로 본다.

| Criterion | Question |
| --- | --- |
| Taskbar Identity | 작업표시줄 위에서 도는 게임처럼 보이는가? |
| Stone Raising Identity | 돌 먹이기와 드래그 머지 욕망이 보이는가? |
| Combat Readability | 하단 전투가 작아도 읽히는가? |
| Economy Clarity | 먹이기/드래그 머지/Steam Market 루프가 보이는가? |
| Asset Affinity | 돌키우기1 에셋 감성과 이어지는가? |
| Runtime Feasibility | Godot UI와 9-slice/슬롯/아이콘으로 분해 가능한가? |
| Steam Polish | 인디 PC 게임처럼 마감감이 있는가? |

## 11. Foundation Gaps

아직 확정되지 않은 UI 시스템 문서:

- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- typography contract
- icon badge contract
- responsive/folded taskbar mode contract

메인 시안 선택 후 위 문서를 추출한다. 지금 단계에서는 버튼/모달의 최종 수치보다 메인 화면의 구성, 정보 위계, 감정이 우선이다.

## 12. Next Deliverables

1. 이 문서를 기준으로 4개 메인 UI 시안을 생성한다.
2. 각 시안은 `harness/design/taskstonebar/concepts/`에 이미지와 `.md` 노트를 함께 저장한다.
3. `design-registry.yaml`에 `draft` 또는 `candidate`로 등록한다.
4. 선택된 시안 1개를 `selected`로 승격한다.
5. 선택 시안에서 UI atoms, 버튼, 모달, color/token 보완, Godot recipe를 추출한다.
