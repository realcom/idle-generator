# 5. 추가 항목

## 5-1. 오라클 제공 서비스와 아이템의 협업 가능성

### □ 협업의 기본 구도

본 사업의 OCI 협업은 단순 클라우드 호스팅이 아니라, **자체 라이브 게임 데이터로 검증되는 게임 제작 플랫폼이라는 카테고리를 OCI Enterprise AI 위에서 형성**하는 구조입니다. IDLE Forge의 콘텐츠 양산·엔진 운영·라이브 운영 세 영역 모두에 OCI 서비스가 결합되며, 협약기간 종료 시점에 글로벌 라이브 운영 가능 상태에 도달합니다. **Oracle 측에는 게임 도메인 OCI Enterprise AI 레퍼런스 사례와 인디 게임사 대상 OCI Marketplace 매출 채널을 동시에 만드는 협업**입니다.

### □ 활용 OCI 서비스

  ○ **콘텐츠 생성** — Generative AI Service(Cohere Command A·OpenAI gpt-oss·xAI Grok 계열 등 OCI에서 제공하는 복수 모델 활용, Model Import로 게임 도메인 모델 활용), Generative AI Agents(콘텐츠 밸런스·톤 충돌 검사 멀티스텝 에이전트, RAG·관측성·감사 내장), Oracle AI Database · AI Vector Search(라이브 콘텐츠 임베딩 저장, RAG로 닌자 IP 톤 유지)

  ○ **엔진 운영** — Compute + OKE(자체 .NET 서버를 Seoul/Chuncheon 배포, Virtual Nodes로 인프라 인력 없이 4X 폭증 트래픽 자동 대응), Object Storage + CDN(AI 양산 콘텐츠 주 단위 핫 패치), APM·Logging Analytics·Data Science(분산 트레이싱·이상 탐지·결제 예측, APM 무료 티어로 초기 비용 절감)

  ○ **운영 자동화** — Language + Generative AI Agents(다국어 번역 API와 RAG 기반 사내 용어집으로 CS 자동 응대, 닌자 IP 고유 용어 일관 유지), Functions(콘텐츠 컴파일·업로드·CDN 캐시 무효화 자동 파이프라인)

  ○ **인게임 AI** — Generative AI Agents(RAG)(4X NPC가 점령 패턴 학습으로 외교·전쟁 동적 결정, 하우징 NPC가 진행도·자원에 따라 매번 다른 대화·퀘스트 제공)

### □ 리전 운용·지연 회피

| 워크로드 | OCI 리전 | 사유 |
|---|---|---|
| 게임 서버 (실시간) | Seoul · Chuncheon | 한·일 저지연 |
| AI Agents (콘텐츠 생성·검증) | Osaka (Japan East) | Generative AI Agents 가용 최근접 |
| 글로벌 CDN | 멀티 리전 + Edge | 패치 글로벌 전송 |

한국-Osaka 라운드트립(약 30~40ms)이 인게임 AI 응답에 영향을 주지 않도록 AI Agents 호출은 모두 비동기·사전 생성 패턴으로 설계합니다(4X 외교·하우징 NPC·동적 이벤트 모두 비실시간). 반복 응답은 Seoul Redis 캐시로 라운드트립 제거, 유저 동선 진입 시 사전 호출로 표시 시점 캐시 적재. 콘텐츠 생성은 오프라인 작업이라 분 단위 지연도 무관. 리전 분리는 한국 PIPA·EU GDPR·중국 PIPL 등 지역별 데이터 거버넌스 대응에도 활용됩니다.

### □ 협약기간 OCI 예상 소비 규모

협약기간 8개월 동안 OCI 누적 사용액은 **약 $55K (약 7,700만원, 환율 1,400원/USD)**를 목표로 합니다. 첫 2개월은 인프라 셋업 단계로 Compute·Object Storage·APM 도입에 한정되고, 협업 머신 개발과 콘텐츠 양산 파이프라인이 가동되는 3개월부터 GenAI Service·Agents·Vector Search 사용량이 증가하며, KPI 인텔리전스·다국어 CS·인게임 NPC PoC가 본격 가동되는 후반 4개월에 풀 사용 수준에 도달하는 ramp-up 패턴입니다.

| 워크로드 | 본격 가동 시기 | 8개월 누적 (USD) | 사용 근거 |
|---|---|---|---|
| Compute + OKE (Seoul·Chuncheon 멀티 리전) | '26.04 시작 (점진 확장) | $12K | 자체 .NET 서버 멀티 리전, Virtual Nodes 자동 스케일 |
| Generative AI Service | '26.06~ (협업 머신 개발) | $14K | 협업 머신 3종 + 콘텐츠 양산 모델 호출 (Cohere·gpt-oss·Grok) |
| Generative AI Agents | '26.07~ (콘텐츠 검증) | $8K | RAG·멀티스텝 검증·인게임 NPC PoC |
| APM·Logging Analytics·Data Science | '26.09~ (KPI 인텔리전스) | $8K | 분산 트레이싱·이상 탐지·LTV 예측 |
| Oracle AI Database + AI Vector Search | '26.06~ | $6K | 라이브 콘텐츠 임베딩·RAG 일관성 |
| Language + Functions | '26.08~ (다국어 CS·파이프라인) | $5K | 5~7개 언어 CS + 콘텐츠 컴파일·CDN 무효화 |
| Object Storage + CDN | '26.04 시작 | $2K | 콘텐츠 핫 패치·글로벌 배포 |
| **합계** | — | **$55K** | — |

협약 종료 후 닌자 서바이벌 2 정식 출시('27.01) 이후 라이브 트래픽 확대로 누적 약 $200K, '28년 Stretch 전환 + B2B 라이선시 운영 시작 시 누적 약 $500K로 확대를 예상합니다(5-3 측정 지표 참조).

---

## 5-2. 글로벌 기업 협업 프로그램 성공을 위한 핵심성과 및 전략

### □ 핵심성과

  ○ 신규 IP 출시 주기 단축 — 전통 인디 스튜디오 신작 1종 출시까지 1.5~2년이 소요됩니다. IDLE Forge + OCI AI 서비스 결합으로 3개월 수준 단축을 목표로 하며, 협약기간 내 닌자 서바이벌 2 베타 출시가 1차 실증입니다.

  ○ 10인 이하 조직 글로벌 라이브 운영 — OCI Virtual Nodes로 인프라 인력, OCI Language·Agents로 다국어 CS 인력을 각각 최소화. 동일 매출 규모 전통 게임사 30인 조직 대비 9인(합류 4 + 채용 5)으로 운영합니다.

  ○ 닌자 서바이벌 2 매출 — '27 Base DAU 3만·결제 3%·ARPPU $40 → 월 약 0.5억(연 약 6억), '28~ Stretch DAU 6만·결제 5%·ARPPU $80 → 월 약 3.4억(연 약 40억). 산식 상세는 3장.

  ○ IDLE Forge B2B 외부 공급 — '28년부터 셋업 fee + 매출 분배 7%로 외부 인디에 공급, OCI Marketplace 등록 검토.

### □ 성과 실현 전략

  ○ 협약기간 8개월에 OCI 네이티브 전환 집중 — IDLE Forge 핵심 워크플로우를 OCI 위로 이식해 협약 종료 시점 글로벌 베타 운영 가능 상태에 도달합니다.

  ○ 검증된 팀과 엔진 위에 OCI 결합 — 다년간 함께 일한 동일 팀이 그대로 합류하고 4년 검증된 자체 게임 엔진 위에 OCI를 결합하는 구조로, 새로 도입하는 요소를 OCI로 좁혀 협업 가치에 집중합니다.

  ○ 협업 사례화로 OCI Marketplace 채널 확보 — 협약기간 8개월과 '27년 라이브 운영 데이터를 축적해 OCI 기반 게임 도메인 적용 사례를 만들고, 기술 문서·컨퍼런스·블로그 형태로 공개 가능한 범위를 정리합니다. 향후 OCI Marketplace 등록을 통해 인디 게임사 대상 공급 채널도 함께 확보합니다.

  ○ Oracle 네트워크를 퍼블리싱·시장 인지도 채널로 활용 — 퍼블리셔 미확보 상태에서 Oracle for Startups와 Oracle AI World 2026을 한·중·동남아 컨택 기회로 활용합니다. 운영 경험 공개로 2028년 외부 공급 시점의 시장 신뢰를 확보합니다.

---

## 5-3. 협업 로드맵

### □ 협약기간 ('26.04 ~ '26.11) 단계별 도입

협약기간 8개월 안에 OCI 핵심 4종 워크로드를 운영 전환하고, 확장 5종 워크로드는 PoC로 검증합니다. 월별 OCI 도입과 게임 마일스톤 상세는 3-3-2(그림 10)에서 다룹니다.

### □ 협약 종료 이후

'27년 닌자 서바이벌 2 글로벌 정식 출시, OCI 위 라이브 운영 지속(시즌·연맹 이벤트 OCI Functions 주 단위 자동 배포, Base 연 약 6억). '28년 IDLE Forge B2B 공급 시작(1호 라이선시 연중 목표, OCI Marketplace 등록), 신규 IP 1~2종 추가 출시. '29년 이후 자체 출시 누적 3종 이상, IDLE Forge 외부 고객사 다수 확보, Oracle 글로벌 커뮤니티 사례 공유로 시장 인지도 안정화.

### □ 협업 성공 측정 지표

| 지표 | 협약 종료 | 2027년 말 | 2028년 말 |
|---|---|---|---|
| 글로벌 누적 다운로드 | 5만 (베타 클로즈드) | 60만 (정식 출시 1년) | 120만 (Stretch 전환) |
| 월 매출 | 베타 단계 | 약 0.5억 (Base) | 약 3.4억 (Stretch) |
| 다국어 CS | 3개국어 | 5개국어 | 7개국어 |
| 활용 OCI 워크로드 | 핵심 4종 + 확장 PoC | 운영 고도화 | Marketplace 검토 |
| **OCI 누적 사용액 (USD)** | **약 $55K (8개월)** | **약 $200K** | **약 $500K** |
| IDLE Forge 외부 고객사 | 준비 | SDK·문서 정리 | 1호 |
