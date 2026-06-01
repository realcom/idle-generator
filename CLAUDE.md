# CLAUDE.md — AI 작업 진입점

> 이 파일은 Claude가 이 모노리포에서 작업할 때 빠르게 참조하는 단축 정보.
> 사람용 소개는 [README.md](README.md).

## 모노리포 구조 (한 줄 요약)

| 경로 | 무엇 | 손대도 되나 |
| --- | --- | --- |
| `engine/client/` | Unity 클라 (idlez 레거시) | ⚠️ 신중히 — 검증된 기성 엔진 |
| `engine/server/` | .NET 서버 (idlez 레거시) | ⚠️ 신중히 |
| `engine/commons/` | 공유 라이브러리 (server SHA 단일화) | ⚠️ 신중히 — client/server symlink로 의존 |
| `harness/engine-contract/` | 엔진 계약 (스키마·스탯·어휘) | 🟡 불변 원칙 — 엔진 변경 시에만 |
| `harness/game-profiles/` | 게임별 가드레일 선언 | ✅ 자유롭게 |
| `harness/content/<game>/` | 콘텐츠 정의 (YAML + growth.md) | ✅ 작업 중심 |
| `harness/tools/` | 컴파일러·검증기 (Python) | ✅ 도구 개선 시 |
| `harness/runtime/` | engine-independent 참조 런타임 (HTML) | ✅ 자유 |
| `harness/build/` | 컴파일 산출물 | 🚫 gitignored, 직접 수정 금지 |
| `.claude/agents/` | 작성 에이전트 정의 | ✅ |
| `.claude/skills/` | 작성 스킬 정의 (gen-*, new-content 등) | ✅ |

## 자주 쓰는 명령

```bash
# 콘텐츠 컴파일·검증 (가장 자주)
python3 harness/tools/idlez_compile.py idlez
# 출력: harness/build/idlez/{Units,Items,Skills,Buffs,Maps,Strings,Achievements,Audios,Triggers}.json

# 검증만 (별도 도구 명세)
cat harness/tools/validate.md
```

## 커밋 컨벤션

지금까지 본 패턴 (유지):
- `chore(client): …` — engine/client 정리/수정
- `chore(server): …` — engine/server
- `chore(commons): …` — engine/commons
- `chore(.claude): …` — agents/skills 갱신
- `chore(harness): …` — harness 도구·문서
- `feat(content): …` — 새 콘텐츠 정의
- `fix(…): …` — 버그 수정

Co-Authored-By 라인을 메시지 끝에 추가 (현재 사용 중인 모델로).

## 핵심 정책

- **engine은 idlez 레거시 = 검증된 기성 머신.** 함부로 확장하지 말 것. RPG maker 발산은 harness 측에서.
- **commons는 server SHA 기준 단일화.** 분기 생기면 다시 묻지 말고 server SHA 채택.
- **harness 컴파일 산출물(`harness/build/`)은 절대 직접 수정 금지.** 소스(`harness/content/`)에서 컴파일.
- **engine/client/.../Commons / engine/server/.../Commons는 심볼릭 링크** — 갱신은 `engine/commons/`에만.

## LFS

- `engine/client/` 하위 바이너리(Spine, 사운드, 텍스처 등)는 LFS 추적.
- 루트 `.gitattributes`에 LFS 매크로 정의 (`[attr]lfs filter=lfs ...`) — 하위 .gitattributes의 매크로 차단 대응.
- LFS 객체 캐시는 `.git/lfs/objects/`. clone 후 `git lfs checkout` 필요.

## 외부 폴더 (legacy)

`~/idlez-client`, `~/idlez-server`는 모노리포 흡수 전 원본. **본 모노리포가 정본**. 외부 폴더는 LFS 캐시 백업으로 잠시 유지 — 향후 정리 가능.

## 작업 시 우선순위 (사용자가 명시한 방향)

1. **콘텐츠/AI 발산** (harness + .claude) — RPG maker로서 발산력·재사용성
2. **end-to-end 라스트마일** — harness 산출물이 실제 engine에 로드되는 경로 확립
3. 엔진 자체 확장은 **최후 수단** (정말 필요할 때만)

자세한 방향성: `~/.claude/projects/-Users-yangjinhwan-Documents-Claude-Projects-idle-game-generator/memory/` (project_direction.md, commons-policy.md, asset-generator-integration.md)

## 후속 정리 사안

- **Unity 컴파일 에러 stub** (예정): SDK 제거(`ea3b7d5`) 후 `Scripts/Components/PlatformManager.cs` 등 12개 파일에 Firebase/광고/Sentry 호출 잔존. Unity 컴파일 시 에러 보고 정리.
- **end-to-end 배포 스텝**: `harness/build/idlez/*.json` → `engine/client/Client/Assets/PatchResources/` 복사·검증 자동화 부재. `.bytes` 직렬화 필요 여부 확인 필요.
- **packages-lock.json** (`engine/client/Client/Packages/`): manifest.json 정리 후 Unity 다음 로드 시 자동 재생성.
