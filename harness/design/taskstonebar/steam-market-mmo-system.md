# 돌키우기2 Steam Market MMO System Skeleton

## Product Thesis

`돌키우기2 / Taskstonebar`는 Godot 클라이언트에서 돌아가는 작업표시줄형 MMO 파밍 게임이다. 거래소는 인게임에 만들지 않고 Steam Community Market만 사용한다. 따라서 게임의 핵심 경제 단위는 `우리 DB 아이템`이 아니라 `Steam Inventory asset`이다.

핵심 감정:

```text
켜둔 동안 돌과 광석이 떨어진다
→ 그 아이템은 Steam 인벤토리에 남는다
→ 내 돌에게 먹이거나, 큐브에 태우거나, Steam Market에 판다
```

## YAML Layering

현재 하네스의 엔진 콘텐츠는 `harness/content/taskstonebar` 아래의 `Item`, `Unit`, `Skill`, `Map` YAML로 충분히 표현된다. 새 엔진 필드를 만들지 않고, 컴파일러가 무시하는 `_economy` 블록을 각 콘텐츠에 얹는다.

```yaml
id: 200101
name: "조약돌 파편"
category: Material

_economy:
  role: feed_material
  steam:
    enabled: true
    itemdefid: 200101
    marketable: true
    tradable: true
  sinks:
    feed_xp: 1
    cube_xp: 1
```

`harness/tools/idlez_compile.py`는 `_`로 시작하는 키를 건너뛰므로 `Items.json`에는 들어가지 않는다. 대신 Godot 런타임 빌드 단계나 Steam ItemDef 생성기가 `_economy`를 읽는다.

## Asset Rule

기본 에셋 풀은 `assets/growstone2/`에 들어온 돌키우기1 원작 리소스다. 돌키우기2의 기본 룩은 이 에셋을 Godot에 맞게 정리해서 만든다. `harness/assets/growstone2/`는 구 경로 호환용 symlink로만 둔다.

우선순위:

1. 원작 PNG/GIF/스프라이트시트 그대로 사용
2. Godot atlas, frame, 9-slice, import preset으로 재패킹
3. 팔레트, 스케일, 투명도 같은 비파괴 가공
4. 누락된 Steam Market 아이콘/시즌 신규물만 원작 톤으로 생성

폴더 기준:

| Path | Role |
| --- | --- |
| `assets/growstone2/UI/` | 팝업, 탭, 버튼, 슬롯, 상점 프레임 |
| `assets/growstone2/unit/` | 원작 유닛/캐릭터/정렬 자료 |
| `assets/growstone2/effect/` | 스킬, 크리티컬, 레벨업, 보호막, 태양석 이펙트 |
| `assets/growstone2/map/` | 마을, 광산, 던전, 필드 배경 |

원작 에셋이 존재하는 영역은 새 스타일로 교체하지 않는다. 새 에셋은 원작 에셋으로 해결되지 않는 Steam/Godot/시즌 요구에 한정한다.

## Authority Model

| Layer | Owns | Rule |
| --- | --- | --- |
| Godot client | 화면, 입력, 연출, Steam 링크 | 아이템 생성 결정 금지 |
| Game server | 전투, 드롭, 진화, 큐브, 로그 | 모든 시장 자산 민팅 요청의 주체 |
| Steam Inventory | 판매 가능 아이템 소유권 | marketable/tradable 자산의 정본 |
| Steam Market | 가격, 판매, 구매 | 인게임 주문장 없음 |

Steam Inventory Service는 서버 없는 구성도 가능하지만, 이 게임은 MMO 파밍 경제가 중심이므로 trusted server가 게임 상태와 드롭 판정을 잡아야 한다.

## Server Mode Policy

라이브 경제는 처음부터 서버가 있어야 한다. 이유는 단순하다. Steam Market에 팔 수 있는 아이템이 걸리는 순간, 클라이언트 로컬 판정은 곧 아이템 민팅 취약점이 된다.

다만 개발 속도를 위해 서버모드는 구분한다.

| Mode | Server | Steam Inventory | Marketable Drops | Migration |
| --- | --- | --- | --- | --- |
| `live` | required | real | enabled | local → live 금지 |
| `staging` | required | sandbox/test | test only | local → staging 금지 |
| `local_sandbox` | mock/embedded | disabled | disabled | live 이전 금지 |

`local_sandbox`는 Godot UI, 작업표시줄 연출, 전투 느낌, 밸런스 감각을 빠르게 확인하는 모드다. 이 모드에서 얻은 아이템, 성장, 세이브는 라이브 서버로 절대 옮기지 않는다.

따라서 서버 정책은 이렇다.

```text
서버는 처음부터 설계에 있어야 한다.
하지만 개발용 서버 OFF/Mock 모드는 둔다.
라이브 경제와 Steam Inventory가 켜진 순간부터는 서버 필수다.
```

## Content Lanes

TBH의 Steam 페이지는 작은 작업표시줄 RPG라도 클래스, 아이템, 스킬, 빌드 조합이 핵심이라고 보여준다. 돌키우기2는 여기에 원작 IP의 캐릭터/펫/내 캐릭터 편성 사냥과 Steam Market 자산 경제를 얹는다.

### 1. Feed Materials

초보 공급, 고인물 수요의 기본층.

- `조약돌 파편`
- `이끼 광석`
- `태양석 조각`
- `별가루 광석`

설계 원칙: 저등급 재료도 최상위 진화/문양/클랜 광산에 계속 들어가야 한다.

### 2. Catalysts

큐브와 강화의 병목 재료.

- `큐브 촉매`
- `응축 큐브 촉매`
- `고대 큐브 심지`

설계 원칙: 온라인/보스/레이드 중심 공급. 오프라인 보상에서는 제외한다.

### 3. Stone Cores

고가 목표물.

- `고대석 코어`
- `태양석 심장`
- `작업석 원형`

설계 원칙: 바로 장착해 강해지는 아이템보다, 상위 진화와 제작의 핵심 재료로 둔다.

### 4. Equipment

장비는 전부 들어간다. 다만 Steam Market에 올릴 장비는 무한히 숨은 난수값이 아니라, 유저가 검색하고 가격을 판단할 수 있는 정체성을 가져야 한다.

- `데굴 투석구 +0~+9`
- `광산 장갑 +0~+9`
- `돌지기 모자 +0~+9`

시장에 보이는 축:

- 슬롯: 무기, 모자, 장갑, 신발, 목걸이, 반지
- 희귀도: Common~Cosmic 계열
- 강화 구간: +0, +3, +6, +9 같은 bucket
- 옵션 계열: 공격형, 파밍형, 보스형, 생존형
- 옵션 티어: C/B/A/S

정확한 소수점 난수값과 강화 이력은 장착/감정 이후 서버 DB 귀속으로 둔다.

### 5. Cosmetics

리스크가 낮은 고가 수집품.

- 돌지기 스킨
- 투척 이펙트
- 작업표시줄 바닥 스킨
- 펫 외형

### 6. Characters

캐릭터도 Steam 자산으로 들어간다.

- `돌지기 소환석`
- `광부 돌지기`
- `태양석 수호자`
- `클랜 광산 감독관`

거래 가능한 것은 캐릭터 본체, 조각, 스킨, 소환권이다. 캐릭터 레벨, 장착 상태, 훈련 수치, 시즌 랭킹 기여도는 서버 DB 귀속이다.

### 7. Classes

직업은 단순 스킨이 아니라 편성 역할과 장비/스킬 빌드를 결정한다.

초기 역할:

| Class | Role | Loop |
| --- | --- | --- |
| 돌수호자 | tank | 보스/편성 생존, 도발, 피해 감소 |
| 돌팔매꾼 | ranged_dps | 빠른 자동사냥, 치명/공속 빌드 |
| 광부 | farming_support | 광석/상자/촉매 드롭 보조 |
| 태양석 주술사 | buff_heal | 편성 버프, 회복, 큐브/태양석 시너지 |

거래 가능한 직업 자산:

- 직업 해금권
- 직업 조각
- 직업 스킨
- 직업 전용 장비 상자

거래 불가 귀속 데이터:

- 직업 레벨
- 숙련도
- 스킬 포인트
- 편성 기여도
- 장착 후 확정된 랜덤 옵션

### 8. Pets

펫도 Steam 자산으로 들어간다.

- `광맥 박쥐 알`
- `이끼 달팽이`
- `태양석 정령`
- `상자 냄새꾼`

펫은 특히 시장성이 좋다. 알/미감정 펫은 거래 가능하게 두고, 부화/훈련/장착 후에는 서버 DB 귀속 인스턴스로 바꾸는 구조가 안전하다.

### 9. Formation Hunting

여기서 파티는 다른 유저와의 실시간 파티가 아니라 **내 계정 캐릭터 3~4명 출전 편성**이다. 전투 화면은 작은 작업표시줄형이므로 조작 부담이 아니라 자동 편성 효율, 캐릭터 수집, 장비/펫 세팅, 드롭 기대감이 핵심이다.

```text
MineChannel
→ account enters with 1~4 character formation
→ server validates character / gear / pet bindings
→ each character contributes role, stats, skills, and passive bonuses
→ formation synergy modifies kill speed and drop tables
→ account-level marketable drops go to Steam Inventory
```

편성 보상 원칙:

- 계정 드롭: 편성 전체 결과를 계정 단위로 서버가 굴린다.
- 캐릭터별 기여: 각 캐릭터의 직업, 장비, 펫, 스킬이 처치 속도와 드롭 보정에 기여한다.
- 편성 보너스: 직업 조합, 펫 조합, 클랜 버프가 드롭률/보스 코어/촉매에 영향을 준다.
- 막타 소유권 없음: 내 캐릭터끼리 막타 분쟁을 만들지 않는다.
- 고가 드롭 로그: 클랜/월드 로그로 시장 흥분을 만든다.

직업 조합 예:

```text
돌수호자 + 돌팔매꾼 + 광부 + 태양석 주술사
→ 보스 안정성 + 처치 속도 + 드롭 보너스 + 생존 버프
```

슬롯 해금:

```text
1번 슬롯: 시작 돌지기
2번 슬롯: 첫 보스 클리어
3번 슬롯: 큐브 Lv4 또는 첫 전직 문양
4번 슬롯: 문양 트리/Steam 자산 해금권/상위 광산 목표
```

시장 연결:

- 캐릭터 소환석, 조각, 스킨은 거래 가능
- 직업 해금권, 직업 장비 상자, 미감정 캐릭터는 거래 가능
- 캐릭터 레벨, 장착 상태, 편성 슬롯 배치, 장착 후 랜덤 옵션은 서버 DB 귀속

### 10. Random Options

랜덤 옵션은 유지한다. 대신 시장 표현은 세 모드로 나눈다.

| Mode | Steam Market | Game |
| --- | --- | --- |
| `sealed_roll` | 미감정 상자/알/장비로 거래 가능 | 감정 시 Steam 자산 소비, 서버 DB 귀속 난수 생성 |
| `visible_bucket` | 공격형 S, 파밍형 A처럼 이름/태그에 옵션 계열 노출 | 정확한 수치는 bucket 안에서 제한 |
| `bound_instance` | 거래 불가 | 장착, 강화, 재굴림, 훈련 이력 전체를 서버 DB에 저장 |

Steam dynamic property는 시장 가치의 정본으로 쓰지 않는다. Steam 문서상 dynamic property는 거래 시 초기화되고 Community Market에서 보이지 않기 때문이다. 따라서 가격에 영향을 주는 정보는 ItemDef, tag, `market_hash_name`에 올라와야 한다.

랜덤 옵션 파이프라인:

```text
서버 드롭 판정
→ base item 결정
→ market-visible identity 결정
   (slot / rarity / option_family / option_tier / enhancement_band)
→ Steam Inventory 자산 발급
→ 유저 선택
   → 팔기: 그대로 Steam Market
   → 감정/장착: Steam 자산 소비 + 서버 DB 귀속 난수 생성
   → 큐브: Steam 자산 소비 + 재료/상위 결과 생성
```

## Core Systems

### Farming

```text
MineChannel online tick
→ server validates active session
→ server rolls drop table
→ nonmarket progress goes to DB
→ marketable drops are granted to Steam Inventory
```

초기 맵은 현재 `작업표시줄 동굴`을 확장한다. 몬스터 드롭은 `dropAddItemGroups`에 남겨 엔진/시뮬레이션이 읽게 하고, 실제 Steam 지급 정책은 `_economy.supply`가 정한다.

### Feeding

```text
Steam Inventory material
→ server consumes asset
→ stone_feed_xp added to DB stone
→ no marketable output unless evolution threshold crossed
```

먹이는 가격 방어가 아니라 수요 압박이다. 출시 초반 상위 랭커가 저등급 재료를 계속 빨아먹게 만든다.

### Cube

큐브는 경제 소각장이다.

- `Alchemy`: 재료/장비를 태워 골드 + 큐브 XP
- `Synthesis`: 같은 lane N개를 태워 상위 재료
- `Refining`: 촉매 + 광석을 태워 상위 코어
- `Inscription`: 시즌 말 상위 유저용 대형 소각

큐브 결과물이 marketable이면 Steam ExchangeItems 또는 trusted server grant 경로로 처리한다.

### Clan Mine

집단 소각장.

```text
clan members donate marketable materials
→ server consumes Steam assets
→ clan mine level / buff / raid unlock progresses
→ season ranking pressure creates bulk demand
```

인게임 거래소가 없으므로 클랜은 시장 가격을 올리는 강력한 수요 장치다.

### Season

1년 가격 유지가 목표가 아니므로 시즌은 1~3개월 거래 속도를 만든다.

- 시즌 랭킹은 재료 소모량과 보스 기여도를 함께 본다.
- 시즌 스킨 제작은 구 재료를 대량 소각한다.
- 다음 시즌은 새 faucet을 추가하되 기존 저등급 재료 수요를 유지한다.

## Godot UX Skeleton

### Taskbar Mode

- 현재 광산 채널과 드롭 로그만 작게 보여준다.
- 희귀 드롭은 Steam Inventory grant 알림과 연결한다.
- Sell/Feed/Cube는 확장 패널에서 처리한다.

### Workshop Mode

- `Inventory`: Steam Inventory + DB 귀속 아이템을 함께 표시
- `Feed`: 드래그해서 돌에게 먹이기
- `Cube`: 소각/합성/제련
- `Market`: 인게임 주문장 없음. 선택한 아이템의 Steam Market 페이지 열기
- `Clan`: 기부, 클랜 광산, 시즌 랭킹

## Launch Skeleton

### Vertical Slice

- Godot login via Steam
- Town + one MineChannel
- `작업표시줄 동굴` waves
- 3 marketable materials
- one catalyst
- feeding
- cube alchemy + synthesis
- Steam Inventory refresh
- Steam Market deep link

### Economy MVP

- 초보가 시간당 팔 수 있는 저등급 재료가 나온다.
- 상위 유저는 같은 재료를 수백~수천 개 단위로 먹인다.
- 촉매는 온라인/보스 중심이라 가격축 역할을 한다.
- 큐브가 공급 과잉을 계속 태운다.

### First Expansion

- Clan Mine
- Boss Raid cores
- season skin crafting
- equipment enhancement tiers
- Steam itemdef generator export from `_economy`
