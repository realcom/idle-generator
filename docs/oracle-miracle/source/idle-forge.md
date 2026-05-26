# IDLE Forge — 플랫폼 정의

## 한 줄 정의

**IDLE Forge** = AI 콘텐츠 생성 하네스 + 검증된 모바일 게임 엔진(idlez) + 라이브 운영 파이프라인의 **수직 통합 AI 네이티브 게임 제작 플랫폼**.

## 왜 수직 통합인가 (차별성)

| 비교 | 일반 인디 스튜디오 | AI 도구만 활용 | **IDLE Forge** |
|---|---|---|---|
| 콘텐츠 생성 속도 | 1x | 2~3x | **5x+** (검증·컴파일·핫패치 자동화 포함) |
| 엔진 안정성 | 보유 | 외부 의존 | **자체 4년 검증 엔진(idlez)** |
| 글로벌 라이브 운영 | 가능 (N명 인력) | 부분 | **다국어 CS·KPI 자동화로 5인 미만 운영 가능** |
| 멀티 타이틀 확장 | 어려움 | 도구 학습 비용 | **하네스 재사용 → 신규 IP 3개월 내 출시** |

"AI 콘텐츠 도구"는 시장에 많지만, **엔진·콘텐츠·운영까지 단일 코드베이스로 결합**된 플랫폼은 희소.

## 3-레이어 구조

### 1. 콘텐츠 양산 레이어 — 하네스 (`harness/`)

- LLM 기반 콘텐츠 생성 워크플로우
- 도메인 특화 스킬: `gen-items`, `gen-skills`, `gen-units`, `gen-maps`, `gen-triggers`, `gen-achievements` 등 30+개
- 엔진 계약(`engine-contract`) 기반 스키마 자동 검증
- 콘텐츠 일관성·밸런스 자동 검증 에이전트 (`content-reviewer`, `balance-review`)
- 컴파일러: YAML/MD → JSON (엔진 로딩 가능 형태)

**→ Oracle Miracle 핵심**: 이 레이어를 **OCI Enterprise AI** (Generative AI Service + Generative AI Agents + Data Science) **+ Database 23ai AI Vector Search**로 클라우드 네이티브 전환

### 2. 엔진 레이어 — idlez Engine

- **클라이언트**: Unity 기반 모바일 앱 (`engine/client`)
- **서버**: .NET 기반 비동기 게임 서버 (`engine/server`)
- **공유 라이브러리**: `engine/commons` (server SHA 단일화)
- 4년 이상 실서비스 검증 (닌자키우기·닌자서바이벌 라이브 운영)
- 글로벌 초저지연 비동기 통신
- `PatchResources` 시스템으로 콘텐츠 핫 패치 가능

**→ Oracle Miracle 핵심**: 이 레이어를 **OCI Compute / OKE + Object Storage + CDN**으로 글로벌 배포

### 3. 콘텐츠 레이어 — 게임 (`harness/content/`)

- 게임별 콘텐츠 정의 (YAML + growth.md)
- 컴파일 산출물: `Units.json`, `Items.json`, `Skills.json`, `Maps.json`, `Triggers.json` 등
- 엔진의 `PatchResources/`로 로딩

**→ Oracle Miracle reference**: **닌자 서바이벌 2** (모바일 앱)

## 현재 운영 중인 검증된 자산

- **엔진**: 4년 검증 (전 소속사 시절 라이브 서비스로 입증)
- **AI 콘텐츠 워크플로우**: 이미 Claude API + Cursor 기반 운영 중 (gen-* 스킬 30+개)
- **AI 아트 워크플로우**: Midjourney + LayerAI 결합으로 인게임 아이콘·배경·UI·배너 대량 생산 중
- **자동 검증**: content-reviewer 에이전트가 스키마·참조무결성·밸런스 자동 검증

## B2B 확장 비전 (Scale-up 3단계)

| 단계 | 시기 | 내용 |
|---|---|---|
| 1. 자체 출시 검증 | **'26 (협약기간 포함)** | IDLE Forge로 닌자 서바이벌 2 베타·출시 — 실증 |
| 2. 멀티 타이틀 | '27~ | 동일 플랫폼으로 신규 IP 자체 출시 1~2종 추가, 캐시카우 다각화 |
| 3. SaaS 외부 공급 | '28~ | IDLE Forge를 다른 인디 게임사에 SaaS로 공급 (월 구독 + 매출 분배), **OCI Marketplace 등록 검토** |

## 협약기간 내 IDLE Forge 자체 목표

- IDLE Forge 코어 워크플로우 OCI 네이티브 전환 완료
- 닌자 서바이벌 2 베타 출시로 플랫폼 실증
- 다국어 CS·운영 자동화 PoC 완료 (5+개 언어)
- IDLE Forge 기술 자산 정리 (B2B 공급용 문서·SDK 초안)
