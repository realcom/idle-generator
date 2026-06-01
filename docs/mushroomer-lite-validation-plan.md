# Mushroomer-Lite Validation Plan

## 목적

이 문서의 목표는 `버섯커 키우기` 감성의 미니멀한 AFK RPG 1종을 만들어,
이 저장소의 핵심 약속이 실제로 성립하는지 검증하는 것이다.

검증 대상은 **게임의 재미 최대화**가 아니라 아래의 폐회로다.

1. `game-profile`을 새로 만든다.
2. `content/<game>/`에 새 콘텐츠를 작성한다.
3. `idlez_compile.py`로 엔진 JSON으로 컴파일한다.
4. `PatchResources`로 sync 한다.
5. 참조 런타임 또는 Unity에서 실제 플레이 가능한 상태를 확인한다.
6. 가능하면 **엔진 수정 없이** 완료한다.

즉, 이 프로젝트의 첫 성공 조건은 "새 게임 1종을 시스템으로 만든다"이지
"대형 라이브 게임 수준의 볼륨을 만든다"가 아니다.

## 프로젝트 원칙

- 기존 `idlez`를 확장하지 않고, **새 게임 슬러그**로 분리해 검증한다.
- 새 메커니즘을 발명하지 않고, **이미 engine-contract에 있는 문법만** 사용한다.
- 엔진 확장은 최후 수단이다. 필요 시 "왜 harness/content로 해결되지 않는가"를 기록한다.
- 초기 에셋은 placeholder 허용이다. 데이터/배포 루프 검증이 더 중요하다.
- MVP에서는 시스템 폭보다 **닫힌 루프 완성**을 우선한다.

## 게임 컨셉

- 작업명: `mushroomer`
- 장르: 세로형 AFK idle RPG lite
- 톤: 귀엽고 단순한 버섯 모험
- 한 줄 요약:
  버섯 용사가 자동으로 적을 처치하고 골드를 모아 성장하며,
  스테이지와 보스를 돌파하는 1챕터짜리 검증용 키우기 게임

## MVP 스코프

### 포함

- 플레이어 캐릭터 1종
- 일반 몬스터 6~10종
- 보스 2~3종
- 맵 5~8개
- 기본 강화 5종
  - 공격
  - 체력
  - 방어
  - 공격속도
  - 치명타
- 스킬 3~5개
  - 기본 단일 공격
  - 광역 공격 1개
  - 보스 대응 강타 1개
  - 선택 시 버프형 1~2개
- 장비 8~15개
  - 무기 중심
  - 필요하면 방어구는 1~2슬롯만
- 재료 4~6종
- 드롭 테이블
- 업적 8~15개
- 오프라인 보상
  - 가능하면 포함
  - 불확실하면 2차 검증 항목으로 분리

### 제외

- 펫
- 광맥
- 랭킹
- 출석
- 게임패스
- 가챠
- 길드/멀티
- 복수 재화 경제
- 복잡한 제작/분해 루프
- 방대한 로컬라이징

## 왜 이 스코프가 맞는가

- `unit / item / skill / buff / map / reward / achievement / growth / behavior`를 거의 모두 건드린다.
- 반면 `Mine`, `Ranking`, `Attendance`, `GamePass` 같은 확장 축은 의도적으로 뺀다.
- 이 범위면 "콘텐츠 시스템이 실제 게임 1종을 지탱하는가"를 확인하기에 충분하다.

## 성공 기준

### 필수 성공

- `harness/game-profiles/mushroomer.profile.yaml`이 생성된다.
- `harness/content/mushroomer/` 아래에 독립 콘텐츠가 구성된다.
- `python3 harness/tools/idlez_compile.py mushroomer`가 통과한다.
- `python3 harness/tools/idlez_compile.py mushroomer --sync`가 가능하다.
- 최소 1개 맵이 실제 전투 루프로 플레이 가능하다.
- 플레이어는 강화와 스킬 구매를 통해 명확히 성장한다.
- 보스 클리어까지 10분 안팎의 플레이 세션이 성립한다.

### 추가 성공

- 참조 런타임이 `gameId`, `mapId` 기준으로 파라미터화되어 새 게임도 읽는다.
- draft와 release-ready 콘텐츠의 게이트가 분리된다.
- placeholder 에셋 정책 또는 `asset-registry` 초안이 생긴다.

## 검증 중 꼭 답해야 할 질문

1. 새 프로필만으로도 기존 엔진을 새 게임처럼 사용할 수 있는가
2. 하네스 콘텐츠만 바꿔도 다른 감성의 게임 1종이 만들어지는가
3. 새 게임 제작 중 실제로 막히는 곳은 콘텐츠인가, 툴링인가, 엔진인가
4. 에셋 없이도 placeholder 기반으로 첫 플레이 검증이 가능한가
5. 출시 전 최소 게이트는 무엇인가

## 필수 산출물

### 1. 프로필

- `harness/game-profiles/mushroomer.profile.yaml`
- 사용 스탯, 통화, 예약 ID, 테마, 밸런스 가드레일 정의

### 2. 콘텐츠

- `harness/content/mushroomer/units/`
- `harness/content/mushroomer/items/`
- `harness/content/mushroomer/skills/`
- `harness/content/mushroomer/maps/`
- `harness/content/mushroomer/rewards/`
- `harness/content/mushroomer/achievements/`
- `harness/content/mushroomer/growth/`

### 3. 툴링 보완

- 참조 런타임의 `idlez`/`MAP_ID` 하드코딩 제거 또는 우회
- `approved-only compile` 정책 결정
- placeholder 에셋 규칙 문서화

## 1차 구현 순서

1. `mushroomer` 프로필 생성
2. 1맵 1플레이어 2몬스터 1보스 수직 슬라이스 작성
3. compile/sync 확인
4. 참조 런타임 또는 Unity에서 실제 전투 확인
5. 강화/스킬/드롭 루프 보정
6. 맵과 몬스터를 1챕터 분량으로 확장
7. 업적과 장비를 얹어 최소 메타 루프 완성

## 현재 예상 부족분

### 툴링

- 참조 런타임이 현재 `idlez`와 특정 맵에 하드코딩되어 있다.
- `compile` 단계가 draft도 태우므로 승인 게이트가 느슨하다.
- 에셋 레지스트리 문서는 있지만 실제 디렉터리와 운영 파일은 아직 없다.

### 콘텐츠

- `mushroomer` 프로필은 생겼지만 첫 수직 슬라이스 콘텐츠는 아직 없다.
- 새 게임의 기본 progression 공식을 아직 정하지 않았다.
- 1챕터 분량의 적/보스/장비/업적 볼륨이 아직 없다.

### 배포

- JSON sync는 되지만 release-ready 라인으로 보기엔 아직 얇다.
- `.bytes` 경로와 최종 채널 배포 절차는 후속 검증이 필요하다.

## 권장 의사결정

- 첫 검증 게임은 `mushroomer`로 고정한다.
- 1차 목표는 **"1챕터 플레이 가능"** 으로 자른다.
- 에셋은 1차에 placeholder 허용, 2차에 스타일 정리로 간다.
- 엔진 수정이 필요해 보이면 즉시 기록하고, 먼저 harness 우회 가능성을 확인한다.
- Unity 메인 맵 타입은 `BackpackDungeon` 같은 특수 타입이 아니라 기본 `Dungeon`을 우선 사용한다.
- 통합 UI 흐름은 맵 `type` 자동 추론이 아니라 `popupArgs.ClientModeManager=ModeManagerMushroom` 같은 명시 설정으로 붙인다.
- 로그인 후 재진입/귀환 맵도 `popupArgs.ClientHomeMapDataId=self` 또는 명시 dataId로 고정한다.

## 다음 작업

이 문서를 기준으로 바로 이어서 할 일은 아래 셋이다.

1. `mushroomer` 1맵 수직 슬라이스 콘텐츠 작성
2. 1챕터용 몬스터/맵/장비/업적 목록 확정
3. 참조 런타임을 새 게임 검증에 쓸지, Unity만 1차 타깃으로 할지 결정
