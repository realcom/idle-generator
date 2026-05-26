# OCI 서비스 매핑 — IDLE Forge × Oracle Cloud Infrastructure

> 5장 (오라클 협업) 작성의 single source of truth.
> 모든 서비스는 협약기간('26.04~'26.11) 내 PoC → 정식 운영 가능한 형태로 매핑.

## 매핑 원칙

IDLE Forge 3-레이어 (콘텐츠 생성 / 엔진 / 게임) **모두**에 OCI가 들어감.
→ 단순한 호스팅이 아닌, **AI 워크플로우 전반의 OCI 네이티브 전환**.

→ 담당자가 안내한 가이드라인 ("OCI의 어떤 서비스를 이용하여, 어떤 가치를 만들 계획이다")에 정확히 부합.

## OCI Enterprise AI 우산 (2026 GA)

2026년 OCI는 Generative AI Service · Generative AI Agents · Data Science를 **OCI Enterprise AI**라는 단일 우산으로 통합 GA 발표. IDLE Forge는 이 Enterprise AI 스택을 **게임 도메인에 맞게 특화한 인디 게임 스튜디오용 워크플로우**.

## 리전 운용 전략

| 워크로드 | OCI 리전 | 이유 |
|---|---|---|
| 게임 서버 (실시간 트래픽) | **OCI Seoul / Chuncheon** | 한국·일본 유저 저지연 |
| AI Agents (콘텐츠 생성·검증) | **OCI Osaka (Japan East)** | Generative AI Agents 가용 최근접 리전 |
| 글로벌 CDN | OCI 멀티 리전 + edge | 콘텐츠 패치 글로벌 전송 |

---

## A. 콘텐츠 생성 레이어 → OCI AI 스택

### A-1. OCI Generative AI Service

- **역할**: 게임 콘텐츠(아이템·스킬·유닛·맵·트리거) 자동 생성
- **현재 상태**: Claude API 기반 `gen-*` 스킬 30+개 운영 중
- **OCI 전환 가치**:
  - Cohere Command A, xAI Grok 4.1 Fast, OpenAI gpt-oss 등 다양한 LLM 단일 API
  - **Model Import**으로 우리가 파인튜닝한 게임 도메인 모델 가져오기 가능
  - 엔터프라이즈 보안 + 비용 예측 + 데이터 주권 + 한국 인접 리전 선택
- **닌자서바이벌2 활용**:
  - 4X 영지·연맹 콘텐츠 양산 (영지 종류, 연맹 보상, 연맹 미션)
  - Housing 오브젝트·테마 양산
  - Survival 적·웨이브·보스 패턴 양산

### A-2. OCI Generative AI Agents

- **역할**: 콘텐츠 자동 검증·밸런스 시뮬·일관성 검사 멀티스텝 에이전트
- **현재 상태**: `content-reviewer`, `balance-review` 에이전트 운영 중
- **OCI 전환 가치**:
  - RAG · observability · evaluations · audit logs **내장**
  - MCP · Function Calling · Code Interpreter · File Search · Containers API 지원
  - 멀티스텝 워크플로우 (생성 → 스키마 검증 → 밸런스 시뮬 → 리뷰)를 단일 Agent로 통합
  - 운용 리전: 오사카 (한국 최근접)
- **닌자서바이벌2 활용**: 신규 콘텐츠가 기존 200+개 아이템·스킬과 밸런스·톤 충돌하는지 자동 검증

### A-3. Oracle Database 23ai · AI Vector Search

- **포지셔닝**: 별도 서비스 아님 — **DB 23ai 내부 네이티브 기능** (VECTOR 데이터 타입)
- **역할**: 기존 콘텐츠 임베딩 → RAG로 톤·밸런스 일관성 유지
- **OCI 전환 가치**:
  - 정확/근사 검색 인덱스 + SQL 시맨틱 검색 결합
  - 외부 임베딩 모델 import 가능
  - DB 기존 보안 정책(암호화·RBAC·Data Vault) 그대로 적용
- **닌자서바이벌2 활용**:
  - "기존 닌자키우기·닌자서바이벌 콘텐츠 풍 유지" 자동화
  - 신규 콘텐츠 생성 시 유사 콘텐츠 참조로 일관성 보장
  - 플레이어 행동 로그 임베딩 → 유사 클러스터 기반 동적 이벤트 추천

---

## B. 엔진 운영 레이어 → OCI Infrastructure

### B-1. OCI Compute + OKE (Kubernetes Engine)

- **역할**: idlez 게임 서버 (.NET) 글로벌 비동기 배포
- **OCI 전환 가치**:
  - **Virtual Nodes**(서버리스 K8s)로 인프라 운영 부담 0
  - 자동 스케일·로드밸런싱·장애 복구 내장
  - 4X 연맹 전쟁 시 폭증 트래픽 자동 대응
- **닌자서바이벌2 활용**: OCI Seoul/Chuncheon 리전 배포, 한·일·중·동남아 저지연

### B-2. OCI Object Storage + CDN

- **역할**: 모바일 앱 패치 리소스 (콘텐츠 JSON·에셋 `.bytes`) 글로벌 전송
- **현재 상태**: 로컬 `harness/build/idlez/*.json` → 수동 배포
- **OCI 전환 가치**: 네이티브 CDN으로 협약기간 내 AI 양산된 콘텐츠를 핫 패치로 즉시 글로벌 배포
- **닌자서바이벌2 활용**: 신규 영지·이벤트·연맹 콘텐츠 주 단위 핫 패치

### B-3a. OCI Application Performance Monitoring (APM)

- **역할**: 분산 트레이싱 (게임 클라 → 서버 → DB → 외부 결제), 가용성 모니터링
- **OCI 가치**: OpenTelemetry 표준, **무료 티어 1,000 trace/h + 10 synthetic/h** (스타트업 단계 충분)
- **닌자서바이벌2 활용**: 결제 깔때기 trace, 50+개 글로벌 vantage point에서 가용성 체크

### B-3b. OCI Logging Analytics

- **역할**: ML 기반 로그 분석, **250+ prebuilt parsers**, 대시보드
- **닌자서바이벌2 활용**: 이상 패턴(부정 결제·치팅·봇) 자동 탐지, 운영 사고 사후 분석

### B-3c. OCI Data Science (Enterprise AI)

- **역할**: 게임 KPI 머신러닝 분석, LTV 예측, 이탈 예측
- **OCI 가치**: Jupyter notebook, MLOps, Mistral/Meta LLM 내장, NVIDIA GPU 분산 학습
- **닌자서바이벌2 활용**:
  - 3단계 융합 루프 (Survival → Housing → 4X) 각 단계 전환율 모델링
  - 결제 가능성 예측 → 동적 오퍼링 (4X 게임의 BM 핵심)

---

## C. 운영 자동화 레이어 → OCI Workflow

### C-1. OCI Language + Generative AI Agents

- **역할**: 다국어 CS 자동 응대 + 게임 내 텍스트 자동 로컬라이징
- **OCI 가치**:
  - **30개 언어 번역** 지원
  - **Custom Glossary**로 IP 고유 용어(닌자 캐릭터명·스킬명·아이템명) 일관 유지
  - Real-time Translation + Async Document Translation (Word/PPT/Excel/HTML/JSON/CSV/SRT)
  - GenAI Agent와 결합 → 단순 번역이 아닌 문맥·톤 유지 응대
- **현재 계획**: ChatGPT/Claude 기반 CS 자동화 예정 → **OCI로 정식 구현**
- **닌자서바이벌2 활용**: 한·영·중·일·동남아 5+개 언어 CS를 인력 0~1명으로 운영

### C-2. OCI Functions (serverless)

- **역할**: 콘텐츠 컴파일·검증·배포 파이프라인 자동화
- **현재 상태**: 로컬 `idlez_compile.py` 수동 실행
- **OCI 가치**:
  - **Provisioned Concurrency**로 콜드스타트 제거
  - Multi-AD HA 자동
  - 사용한 만큼 과금 — 스타트업 초기 비용 최적
- **OCI 전환 후**: 콘텐츠 YAML 푸시 → Functions가 컴파일 → Object Storage 업로드 → CDN 캐시 무효화까지 **완전 자동**
- **닌자서바이벌2 활용**: 기획자가 콘텐츠 정의를 푸시하면 즉시 게임에 반영 — 운영 민첩성 극대화

---

## D. 인게임 AI 레이어 → OCI GenAI Agents (RAG)

### D-1. 동적 NPC (4X 연맹·외교)

- **역할**: AI NPC가 플레이어 행동에 동적으로 반응
- **닌자서바이벌2 활용**: NPC 연맹이 플레이어 점령 패턴을 학습 → 동적 외교·전쟁 결정 (단순 룰 기반 대비 차별화)

### D-2. 동적 이벤트·대화 (Housing)

- **역할**: 영지에 방문하는 NPC가 RAG 기반으로 플레이어 진행도에 맞춘 대화·퀘스트 제공
- **닌자서바이벌2 활용**: 플레이어 진행도·소유 자원에 따라 매번 다른 NPC 만남 → 리텐션 강화

---

## 협약기간 내 OCI 도입 로드맵

| 시기 | OCI 워크로드 | 매핑 |
|---|---|---|
| '26.04 ~ '26.05 | OCI 환경 셋업, OKE에 idlez 서버 PoC 배포, Object Storage + CDN 연동 | B-1, B-2 |
| '26.06 ~ '26.07 | OCI GenAI Service + Agents로 콘텐츠 양산 파이프라인 전환 | A-1, A-2 |
| '26.08 ~ '26.09 | Vector Search RAG, Language CS 자동화, Functions 파이프라인 | A-3, C-1, C-2 |
| '26.10 | APM·Data Science 운영 KPI 대시보드, 인게임 NPC Agents | B-3, D-1, D-2 |
| '26.11 | **Oracle AI World 2026** (라스베가스, 10/26~29) 참여, 글로벌 베타 출시 | - |

---

## 협업으로 창출되는 핵심 가치 (5-2 골자)

1. **콘텐츠 생산성**: 전통 방식 대비 5x+, 신규 IP 출시 주기 3개월 이내
2. **운영 효율**: 전통 방식 대비 운영 원가 70% 절감 (인력 + 인프라)
3. **글로벌 확장**: 멀티 리전 자동 배포 + 다국어 CS 자동화 → 5인 미만 조직으로 글로벌 라이브 운영
4. **B2B 스케일업**: '28년부터 IDLE Forge SaaS로 외부 인디 게임사 공급 — **OCI Marketplace 등록**

---

## 5-3 협업 로드맵 골자

- 본 사업 종료 후에도 OCI 위에서 라이브 서비스 지속
- '27 정식 출시 후 IDLE Forge로 신규 IP 1~2종 추가 (멀티 타이틀)
- '28~ **OCI Marketplace를 통한 SaaS 형태 외부 공급** (월 구독 + 매출 분배)
- Oracle for Startups / AI World 커뮤니티 네트워크 활용한 글로벌 인디 생태계 형성
- 한국 인디 게임의 AI 네이티브 전환을 IDLE Forge가 선도 — Oracle의 한국 게임 산업 진출 레퍼런스
