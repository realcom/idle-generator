# Resource Production Pipeline (생산 라인)

engine-contract가 "콘텐츠가 *무엇인지*(정적 스펙)"라면, 이 파이프라인은 "리소스가 *어떻게 만들어지고 흘러가는지*(생산 라인)"다. **기획자 + AI가 함께** 데이터와 에셋을 양산·발산하는 흐름을 정의한다.

## 세 종류의 리소스

| 종류 | 정체 | 위치(소스) | 위치(엔진) |
| --- | --- | --- | --- |
| **데이터 리소스** | `Resource*` 정의 (유닛·아이템·스킬·버프·맵·성장식·행동) | `content/<game>/` | `Units.json`, `Items.json`, `Triggers.json` … |
| **에셋 리소스** | 정의가 *키로 참조*하는 미디어 (스프라이트·아이콘·프리팹·애니메이션·VFX·타일맵·오디오·현지화) | `assets/<game>/` (관례) | `PatchResources/` + Addressables 번들 |
| **디자인 리소스** | UI 시안·아트디렉션·레이아웃 토큰·컴포넌트 스킨·Unity UI recipe | `design/<game>/`, `unity/recipes/` | uGUI prefab / scene skin / 검증 스크린샷 |

> 핵심 계약: **데이터는 에셋을 "키(경로/이름)"로만 참조한다.** (예: `sprite: "Units/Slime/slime_green.png"`)
> 이 분리 덕에 데이터와 에셋을 독립적으로 만들고, 검증기가 "키 ↔ 실제 에셋" 매칭을 확인한다.
> 디자인은 바로 prefab을 쓰지 않고 **시안 → 토큰/스킨 → Unity recipe → prefab 생성** 순서로 흐른다.

## 생산 라인 (7단계)

```
① 기획(Spec)      기획자 의도(자연어) → AI가 작업 스펙 초안 (무엇을 몇 개, 어떤 테마로)
        │
② 생성(Generate)  ├─ 데이터: AI가 schema+profile 지켜 content YAML/growth/behavior 생성
        │         ├─ 에셋: AI 이미지 생성(스프라이트/아이콘) 또는 아티스트 요청 → assets/
        │         └─ 디자인: 시안 생성 → art-direction/layout/component-skin 추출
        │
③ 바인딩(Bind)    데이터 ↔ 에셋 키 연결. 에셋 키 레지스트리 갱신. (asset-pipeline.md)
        │
④ 검증(Validate)  tools/validate: 스키마·참조무결성·스탯 가드레일·성장식·행동어휘
        │         + 에셋 존재 검사(댕글링 키 0) + 밸런스 검산(드롭률·천장·곡선)
        │         + 디자인 리뷰(모바일성·전투 가시성·구현 가능성) + Unity UI recipe 검증
        │
⑤ 컴파일(Compile) 소스 → 엔진 proto-JSON (성장식→배열, behavior→Triggers.json)
        │         에셋 → Addressables 번들
        │         Unity recipe → uGUI prefab / scene skin
        │
⑥ 배포(Deploy)    CDN 패치 채널(Patches/<channel>/, md5 매니페스트) — 게임/환경/플랫폼별
        │
⑦ 리뷰(Review)    diff·밸런스 시뮬·플레이테스트 피드백 → ①로 반복
```

## 각 단계의 AI 역할 (.claude 에이전트 매핑)

| 단계 | AI 에이전트 (`.claude/agents/`) | 하는 일 |
| --- | --- | --- |
| ① 기획 | (오케스트레이터 `new-content` 스킬) | 자연어 의도를 작업 스펙으로 분해 |
| ② 생성(데이터) | `content-designer` | 유닛/아이템/스킬 정의 YAML 생성 |
| ② 생성(성장) | `economy-balancer` | 성장식(growth md) 작성·튜닝 |
| ② 생성(행동) | `behavior-author` | 자연어 → behavior YAML |
| ② 생성(에셋) | `asset-producer` | AI 이미지 생성/에셋 요청 + 키 바인딩 |
| ② 생성(디자인) | `gen-ui-concept` / `extract-design-system` | UI 시안 생성, 디자인 토큰·컴포넌트 스킨 추출 |
| ③~⑤ Unity UI | `gen-ingame-ui-recipe` / `build-unity-ui-prefab` | Unity recipe 작성, uGUI prefab 생성 |
| ④ 검증/⑦ 리뷰 | `content-reviewer` | validate 실행 + 일관성·참조무결성·밸런스 리뷰 |
| ④ 디자인 리뷰 | `design-review` | 모바일성·전투 가시성·햄스터 정체성·구현 가능성 리뷰 |

상세 흐름은 [resource-lifecycle 단계](#생산-라인-7단계)와 [asset-pipeline.md](./asset-pipeline.md), 에이전트 정의는 `.claude/agents/`.

### 사용자 진입 스킬 (`.claude/skills/`)

| 스킬 | 용도 |
| --- | --- |
| `/new-content` | 신규 콘텐츠 일반 진입점 — 버프·보상 직접 처리 + 타입별 전용 스킬로 라우팅 |
| `/gen-unit` | 유닛(캐릭터/펫/몬스터) 1종 완성 |
| `/gen-item` | 아이템 (장비·무기·재료·상품·통화·펫·광맥·티켓) 1종 완성 |
| `/gen-map` | 맵/던전 (타입·웨이브·적 편성·보상) |
| `/gen-skill` | 스킬 (타임라인·타격/버프·상성) |
| `/gen-trigger` | AI 유닛 트리거 (이벤트 기반 행동 → Triggers) |
| `/gen-achievement` | 업적 (진행 조건·보상·잠금 아이템) |
| `/balance-review` | 성장·경제·드롭 시뮬레이션 검증 |
| `/local-server` | 로컬 `postgres + world-server + api-server` Docker 기동/재기동/로그/중지 |
| `/gen-ui-concept` | UI 시안 생성·저장 |
| `/extract-design-system` | 선택된 시안에서 디자인 토큰·스킨 추출 |
| `/gen-ingame-ui-recipe` | 인게임 HUD/하단바 Unity recipe 작성 |
| `/build-unity-ui-prefab` | Unity recipe를 uGUI prefab으로 생성 |
| `/design-review` | 시안/recipe/screenshot 디자인 게이트 |

## 로컬 실행 (Unity 연동)

콘텐츠를 하네스에서 컴파일한 뒤 실제 Unity 클라이언트와 함께 로컬 검증하려면 Docker 로컬 서버를 사용한다.

### 서버 기동

```bash
cd engine/server
docker compose -f docker-compose.local.yml up -d --build
```

### 상태/로그

```bash
cd engine/server
docker compose -f docker-compose.local.yml ps
docker compose -f docker-compose.local.yml logs --tail=200 world-server api-server postgres
```

### 재기동/중지

```bash
cd engine/server
docker compose -f docker-compose.local.yml restart
docker compose -f docker-compose.local.yml down
```

### DB까지 완전 초기화

```bash
cd engine/server
docker compose -f docker-compose.local.yml down -v
docker compose -f docker-compose.local.yml up -d --build
```

### Unity 에디터 기본 접속점

- `engine/client/Client/Assets/Resources/Debug.xml`
- `FixHost=127.0.0.1:11177`
- `FixWebHost=http://127.0.0.1:15000`

즉, Unity 에디터는 별도 수정 없이 로컬 Docker 서버를 기본으로 바라본다.

### 포트 기본값

- Postgres: `15432`
- WorldServer: `11177`
- ApiServer: `15000`

포트 충돌 시:

```bash
cd engine/server
IDLEZ_LOCAL_PG_PORT=25432 \
IDLEZ_LOCAL_WORLD_PORT=21177 \
IDLEZ_LOCAL_API_PORT=25000 \
docker compose -f docker-compose.local.yml up -d --build
```

이 경우 Unity `Debug.xml`도 같은 포트로 맞춘다.

## 계층 연결 (한눈에)

```
engine-contract/   (불변 규칙)  ─┐
game-profiles/     (게임 설정)  ─┼─→ AI 에이전트(.claude) ─생성→ content/ + assets/
                                 │                          ─검증→ tools/validate
                                 └────────── 컴파일/배포 ──→ 엔진 proto-JSON + Addressables (idlez)
```

## 관리 원칙

- **단일 진실**: 데이터는 `content/`, 에셋은 `assets/`, 매핑은 키 레지스트리. 손으로 엔진 JSON을 고치지 않는다.
- **참조 무결성**: 모든 dataId·에셋 키는 실재해야 한다 (검증기 게이트). 댕글링/고아 = 빌드 차단.
- **채널 분리**: 게임(idlez/backpack)·환경(dev/live)·플랫폼(ios/aos)별 배포는 CDN 매니페스트로.
- **AI는 소스를 만들고, 사람이 승인한다**: AI 산출물은 항상 검증·리뷰를 거쳐 커밋(자연어는 입력일 뿐).
- **콘텐츠 저장 레이아웃**: 수천 개 규모 데이터는 `_index.yaml` + `approved/` + `_drafts/` 구조, 파일명은 `{id}_{name}.yaml` — 자세한 규칙은 [content-organization.md](./content-organization.md).
