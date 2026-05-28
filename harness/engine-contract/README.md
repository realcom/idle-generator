# engine-contract — 결합도 층 분리 (coupling tiers)

콘텐츠는 엔진 결합도가 한 가지가 아니다. **얼마나 idlez 엔진에 묶여 있는지**로 이 폴더의 문서를 3층으로 나눈다.
이 구분이 중요한 이유: 엔진을 바꾸면(예: Godot) **portable은 대부분 따라오고, engine-bound는 전부 다시 써야** 한다. 트리거/행동이 가장 깊게 묶인 층이다.

## 3개 층

### 🟢 Portable — 개념·방법론 (엔진 독립)
다른 엔진으로 가도 그대로 유효한 사고방식·데이터.

| 문서 | 내용 | 비고 |
| --- | --- | --- |
| `growth-pipeline.md` | "식(md) → 레벨 배열" 성장 방법론 | 방법은 보편적. 타깃 필드명만 idlez |
| (원리) 소스→컴파일→엔진 JSON | README 통일 원리 | 어느 엔진에도 적용 |
| 밸런스/경제 개념 | faucet·sink·pity·곡선 | 장르 보편 |

### 🟡 Semi-coupled — idlez 스키마·데이터 형태 (재매핑 가능)
개념은 보편적이나 **구체적 모양이 idlez**다. 다른 엔진엔 대응 스키마로 재매핑 필요.

| 문서 | 내용 | 결합 지점 |
| --- | --- | --- |
| `stat-catalog.md` | 76종 스탯 | 키 집합은 idlez enum (개념은 보편) |
| `schema/unit.md` `item.md` `skill.md` `buff.md` `map.md` `reward.md` `tutorial.md` | 콘텐츠 정의 구조 | idlez Resource* 필드 모양과 튜토리얼 업적 계약 |
| `reference-graph.md` | 정의/인스턴스/런타임 참조 | idlez 3분할 구조 |

### 🔴 Engine-bound — idlez 런타임 API (이식 불가, 엔진 버전 고정)
**엔진을 바꾸면 전부 다시 정의.** 손으로 발명하지 말고 엔진 코드에서 추출·동기화.

| 문서 | 내용 | 출처(추출원) |
| --- | --- | --- |
| `trigger-feature-guide.md` | AI/사람용 behavior 기능 사용 가이드 | 하네스 compiler + 런타임 계약 |
| `action-vocabulary.md` | 트리거 액션·이벤트·변수 정본 | `ResourceTrigger.*Method.cs`, `ResourceTrigger.proto` |
| `trigger-runtime-semantics.md` | caller/slot, 숫자, AddUnit, Return 등 실행 의미 | `ResourceTrigger.*`, `GameUnit.*`, 서버 테스트 |
| `json-serialization.md` | idlez 커스텀 JSON 쿽 | 실제 `Units.json`/`Items.json` |
| `behavior-format.md` (시맨틱) | 행동 이벤트×액션 실행 모델 | idlez 트리거 런타임 (작성 *문법*은 우리 것, *의미*는 엔진) |

## 함의 (왜 이 분리가 중요한가)

- **트리거/행동을 짜는 건 곧 idlez를 상대로 프로그래밍하는 것**이다. `action-vocabulary.md`에 없는 동작은 behavior로 우회 불가 → "엔진에 메서드 추가 필요"로 플래그.
- AI가 behavior를 쓸 때는 `trigger-feature-guide.md`를 진입점으로 보고, 세부는 `behavior-format.md`와 `trigger-runtime-semantics.md`까지 같이 본다. 특히 `Return`, caller/slot, `AddUnit.locationId`, long damage/heal 규칙은 런타임 버그로 직결된다.
- 하네스의 **재사용 가능한 자산은 주로 🟢/🟡**(데이터·성장·밸런스 작성·검증·AI 생성)에 있다. 🔴은 idlez에 단단히 묶고 버전을 고정한다.
- 엔진 전환(Godot 등)을 고려할 때: 🟢 거의 유지, 🟡 재매핑, 🔴 재작성. 행동 자산이 클수록 전환 비용이 커진다. (그래서 "행동의 AI 친화성"은 엔진이 아니라 *프론트엔드*에서 확보 — `behavior-format.md` 참조.)

## 스킬 매핑

- 🟢/🟡 작성: `/new-content`, `/gen-unit`, `/gen-map`, `/gen-skill` (+ economy-balancer, content-designer)
- 🔴 작성: `/gen-trigger` (behavior-author) — `action-vocabulary.md`에 **엄격히 묶임**
