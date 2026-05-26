# idle-game-generator

**AI-driven RPG maker** — 기획자 + AI가 자연어·식·선언형 YAML로 콘텐츠를 만들고, 검증된 idlez 엔진(Unity 클라 + .NET 서버) 위에서 굴린다.

> 레퍼런스: 레전드 오브 슬라임, 세븐나이츠 키우기.
> 본 저장소는 **모노리포** — 엔진(idlez 레거시) + 콘텐츠 제작 하네스 + AI 작성 계층을 한 곳에서 관리한다.

---

## 레이아웃

```
idle-game-generator/                  ← monorepo root
├── engine/                           # idlez 레거시 엔진 (검증된 기성 머신)
│   ├── client/                       #   Unity 클라 (puzzlemonsters/idlez-client subtree)
│   ├── server/                       #   .NET 서버  (puzzlemonsters/idlez-server subtree)
│   └── commons/                      #   공유 라이브러리 (server SHA 기준 단일화, client는 symlink)
├── harness/                          # 콘텐츠 제작 하네스 (소스 → 엔진 JSON 컴파일러)
│   ├── engine-contract/              #   엔진 계약 (스키마·스탯·참조그래프·행동 어휘)
│   ├── game-profiles/                #   게임별 스탯/통화/ID대역/가드레일 선언
│   ├── content/<game>/               #   실제 콘텐츠 정의 (YAML + growth.md)
│   ├── pipeline/                     #   생산 라인 문서 (기획→생성→바인딩→검증→컴파일→배포)
│   ├── tools/                        #   컴파일러·검증기 (idlez_compile.py, asset_gen_helper.py)
│   ├── runtime/                      #   engine-independent 참조 런타임 (idlez 없이 플레이)
│   └── build/<game>/                 #   컴파일 산출물 (gitignored, 엔진이 먹는 JSON)
├── docs/                             # 프레젠테이션 등 보조 자료
├── .claude/                          # AI 작성 계층 (agents + skills)
│   ├── agents/                       #   content-designer, behavior-author, asset-producer, …
│   └── skills/                       #   /new-content · /gen-unit · /gen-skill · /gen-map · …
├── CLAUDE.md                         # ★ AI 작업 진입점
└── README.md                         # (이 파일)
```

---

## 3-계층 분리 (왜 발산 가능한가)

| 계층 | 위치 | 변하나? | 무엇 |
| --- | --- | --- | --- |
| **engine-contract** | `harness/engine-contract/` | 불변(모든 게임 공유) | idlez에서 증류한 스키마·스탯·참조그래프·성장/행동 포맷 |
| **game-profile** | `harness/game-profiles/` | 게임마다 | 그 게임이 쓰는 스탯/통화/ID대역/테마/밸런스 가드레일 |
| **content** | `harness/content/<game>/` | 게임마다 | 프로필 위의 실제 정의 (유닛·아이템·스킬·드롭·성장식) |

엔진 계약·검증기·AI 작성 에이전트는 **모든 게임이 공유**, 게임마다 다른 건 프로필 + 콘텐츠뿐.
idlez 엔진은 이미 같은 코드로 `idlez`·`backpack` 두 게임을 채널별 콘텐츠 JSON만 갈아끼워 굴리고 있다.

---

## 빠른 시작

### 콘텐츠 컴파일 (harness)
```bash
python3 -m pip install -r harness/tools/requirements.txt
python3 harness/tools/idlez_compile.py idlez
# harness/build/idlez/*.json 생성 (Units, Items, Skills, Buffs, Maps, Strings, Achievements, Audios, Triggers)
```

### 하네스 예시 산출물

Unity `PatchResources` 전체 예시는 `harness/examples/patchresources/`에 보관한다.
예시 폴더의 JSON은 최신 `harness/content/idlez` 컴파일 산출물로 갱신한다.
실제 Unity 기본 리소스 폴더 `engine/client/Client/Assets/PatchResources/`는 비워둔다.

```bash
# 엔진 PatchResources에 덮어쓰지 않고 생성물만 확인
python3 harness/tools/idlez_compile.py idlez
```

클라이언트 로드 경로를 검증할 때만 `--sync` 또는 `--sync-dir`로 명시적으로 배포한다.

### 새 게임 시작
1. `harness/game-profiles/_TEMPLATE.profile.yaml` 복제 → `<game>.profile.yaml`로 스탯·통화·테마 선언
2. `harness/content/<game>/` 아래에 유닛·스킬·드롭 작성 (또는 `/new-content` 스킬에 자연어로 시킴)
3. `harness/tools/idlez_compile.py <game>`로 컴파일·검증
4. `harness/build/<game>/*.json`을 `engine/client/Client/Assets/PatchResources/`로 배포

### 엔진 빌드 (사용자)
- 클라: Unity로 `engine/client/Client.sln` 열기
- 서버: .NET으로 `engine/server/Server.sln` 빌드

### 로컬 서버 실행 (Docker)
```bash
cd engine/server
docker compose -f docker-compose.local.yml up -d --build
```

기본 접속점:
- Postgres `localhost:15432`
- WorldServer `localhost:11177`
- ApiServer `http://localhost:15000`
- Swagger `http://localhost:15000/swagger`

Unity 에디터는 `engine/client/Client/Assets/Resources/Debug.xml`을 통해 기본으로 위 로컬 서버에 붙는다.

---

## 통일 원리

> **사람·AI가 읽고 쓰는 소스(markdown + 식 + 선언형 YAML) → 컴파일 → 엔진 proto-JSON**

소스가 편집·버전관리·AI 친화적 표면이고, 엔진이 먹는 JSON(`Units.json` 등)은 *생성물*이다.
기획자는 배열 수백 개나 Blockly 블록이 아니라 **식 한 줄과 선언형 텍스트**를 만진다.

```
engine-contract (불변 규칙) + game-profiles (게임 설정)
        │
        ▼
.claude AI 에이전트 ──생성→ harness/content/ (데이터) + harness/assets/
        │          ──검증→ harness/tools/idlez_compile.py
        ▼
컴파일/배포 → 엔진 proto-JSON → engine/client (Unity) + engine/server (.NET)
```

자세한 흐름: [`harness/pipeline/README.md`](harness/pipeline/README.md)

---

## 상태 (2026-05-24)

**모노리포 통합 완료**: idle-game-generator 하네스 + idlez-client + idlez-server + commons가 한 저장소로. subtree 기반, commons는 server SHA 기준 단일화 + 양쪽 symlink. 흡수 시 `engine/client` 14GB 중 코드/LFS만 들여와 1.3GB → 외부 SDK 정리 후 약 920MB. [`CLAUDE.md`](CLAUDE.md) 참조.

**툴체인 v0.3**: `harness/tools/idlez_compile.py` — 8 콘텐츠 타입 + behavior→Triggers 컴파일·검증. 9/9 PASS.

**참조 런타임**: `harness/runtime/idle-runtime.html` — idlez 없이 콘텐츠로 구동되는 engine-independent 플레이어블 데모.

**다음 단계**: 콘텐츠 발산(다양한 RPG 장르 프로필), end-to-end 라스트마일(build → PatchResources 자동 배포, .bytes 직렬화, 에셋 파이프라인 실파일).
