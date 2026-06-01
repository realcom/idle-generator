# Content Organization (콘텐츠 저장 레이아웃)

`content/<game>/` 아래에 수천 개 규모의 데이터 리소스(유닛/아이템/스킬/맵/버프 등)를 저장·관리하는 규칙. AI 생성 → 검토 → 승인 흐름을 그대로 파일/폴더로 표현한다.

## 파일명 규칙

```
{id}_{name}.yaml
```

- `{id}` — game-profile의 `id_ranges` 안에서 할당된 정수. 파일명 = 고유 식별자.
- `{name}` — 가독성용. game-profile `theme.naming_style` 따름 (한글 또는 영문).
- draft 단계에서는 버전 접미사 `_v#`을 붙인다 (`{id}_{name}_v2.yaml`). approved에는 버전 표시 없음.

예:
- `110001_초록슬라임.yaml` (최종)
- `100001_전사_v2.yaml` (검토 중, 2차 수정본)

## 폴더 레이아웃

```
content/<game>/
├── units/
│   ├── _index.yaml              # 모든 유닛의 메타 (조회용, 수천 줄 가능)
│   ├── approved/                # 최종 승인본만
│   │   ├── 110001_초록슬라임.yaml
│   │   ├── 110002_슬라임보스.yaml
│   │   └── ...
│   └── _drafts/                 # AI 생성 후 검토 대기/수정 중
│       ├── 100001_전사_v1.yaml
│       ├── 100001_전사_v2.yaml
│       └── ...
│
├── items/    ├ _index.yaml, approved/, _drafts/
├── skills/   ├ _index.yaml, approved/, _drafts/
├── maps/     ├ _index.yaml, approved/, _drafts/
└── buffs/    └ _index.yaml, approved/, _drafts/
```

> 기존 `growth/`, `rewards/`, `behaviors/` 등 타입에 따라 같은 패턴을 적용한다 (선택). 단일 정의가 100개 이하인 카테고리는 _index 없이 평탄 구조도 허용.

## _index.yaml 포맷

```yaml
# units/_index.yaml
version: "1.0"
updated_at: 2026-05-23T10:00:00Z

units:
  - id: 110001
    name: "초록슬라임"
    file: approved/110001_초록슬라임.yaml
    status: approved              # approved | draft | rejected
    created_at: 2026-05-20T10:00:00Z
    created_by: gen-unit/v1.0
    reviewer: claude
    reviewed_at: 2026-05-21T14:30:00Z
    tags: [Monster, Easy]

  - id: 100001
    name: "전사"
    file: _drafts/100001_전사_v2.yaml
    status: draft
    created_at: 2026-05-23T10:00:00Z
    created_by: gen-unit/v1.0
    reviewer: null
    reviewed_at: null
    feedback: "HP 두 배로"
    tags: [Hero, Player]
```

`_index.yaml`은 **빠른 조회용 메타데이터만** 둔다. 실제 정의는 파일에. 이 분리 덕에 대규모 데이터에서도 한 파일 읽기로 전체 카탈로그 파악이 가능하다.

## 워크플로우

### ① 생성 (gen-unit · gen-item · gen-map · gen-skill 등)

1. game-profile의 `id_ranges` 확인 (예: unit 100000~199999).
2. 해당 카테고리의 `_index.yaml`을 스캔하여 다음 할당 id 결정.
3. `_drafts/{id}_{name}_v1.yaml` 생성.
4. `_index.yaml`에 행 추가 (`status: draft`).
5. 사용자에게 draft 파일을 제시.

### ② 피드백 → 재생성

- 새 버전 파일: `_drafts/{id}_{name}_v2.yaml`.
- `_index.yaml`의 `file` 경로 + `feedback` 필드 업데이트.
- 이전 버전 파일은 보존하거나 삭제(프로젝트 정책).

### ③ 승인

1. `_drafts/{id}_{name}_vN.yaml` → `approved/{id}_{name}.yaml`로 이동 (버전 접미사 제거).
2. `_index.yaml` 업데이트:
   - `status: approved`
   - `file: approved/{id}_{name}.yaml`
   - `reviewer`, `reviewed_at` 기록.

### ④ 거부 → status: rejected

- 파일은 `_drafts/`에 그대로 두고 `_index.yaml`의 `status: rejected` 마킹.
- 후속 정리는 일괄 작업으로.

## 장점

| 항목 | 개별 파일만 | Index + 폴더 분리 |
|------|------------|-------------------|
| 파일 개수 폭증 | diff 부하 큼 | approved/ 안에만 | 
| Git merge 충돌 | 잦음 | `_index.yaml` 한 곳만 병목 |
| 검토 상태 추적 | 파일명 규칙에 의존 | `status` 필드로 명확 |
| 대규모 조회 | 전체 스캔 | _index 한 번 |
| id 충돌 방지 | 약함 | 파일명 자체가 id |

## 규칙 요약

- **파일명에 id 필수** — 같은 이름이 겹쳐도 안전.
- **approved/에는 버전 접미사 없음** — 한 콘텐츠당 최종본 1개.
- **draft는 항상 _v#** — 히스토리 추적.
- **`_index.yaml`만 Git diff 병목** — 머지 충돌 시 행 단위 해결.
- **AI는 _drafts/에만 쓴다** — approved/로의 이동은 승인 액션.
- **id 할당은 game-profile.id_ranges 준수** — 카테고리별 대역 충돌 방지.
