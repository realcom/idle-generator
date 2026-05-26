# Resource Visualizer

게임의 모든 리소스(Items, Units, Skills, Maps 등)를 시각적으로 탐색하고, 각 리소스의 상세 정보와 관계도를 확인할 수 있는 웹 기반 대시보드입니다.

## 🚀 실행 방법

### 방법 1: Claude Code Preview (권장)
```bash
# Claude Code에서 /preview 명령어 사용:
/preview Resource Visualizer
```

또는 VS Code에서 Launch Panel에서 "Resource Visualizer" 선택 후 실행.

### 방법 2: 직접 Python 서버 실행
```bash
cd tools
python3 serve_visualizer.py
```
그 후 브라우저에서 `http://localhost:8080/tools/visualizer.html` 열기.

### 방법 3: 정적 파일 열기
HTML 파일을 직접 브라우저에서 열기 (로컬 서버 필요 없음)
```bash
open tools/visualizer.html
```

## 📊 주요 기능

### 1. 리소스 타입 네비게이션
- **왼쪽 사이드바**: 총 14개 리소스 (Items, Units, Skills, Maps, Buffs, Triggers, Achievements, Audios, Strings)
- **통계 표시**: 각 타입별 리소스 개수 확인
- 클릭으로 타입 선택

### 2. 리소스 카드 그리드
- 선택한 타입의 모든 리소스를 카드 형태로 표시
- **표시 정보**:
  - 이름 (한글)
  - ID
  - 카테고리/타입 배지
  - Grade, Tags 등 메타데이터

### 3. 상세 정보 패널
리소스 카드 클릭 시 다음 정보 표시:
- **기본 정보**: JSON 형식의 기본 속성
- **상세 속성**: 모든 필드와 값 (json 형식)
- **연결된 리소스**: 다른 리소스에서 참조되는 관계도

### 4. 검색 & 필터
- 검색창에 입력하면 실시간 필터링
- 검색 대상:
  - 이름 (한글 지원)
  - ID (정확한 숫자 검색)
  - 카테고리/타입

### 5. 관계도 탐색
- "연결된 리소스" 섹션의 링크 클릭으로 관계된 리소스 직접 이동
- 예: Item이 어느 Unit에서 드롭되는지, Skill이 어느 Unit에 적용되는지 등

## 📁 파일 구조

```
tools/
├── visualizer.html           # 메인 웹 인터페이스
├── serve_visualizer.py       # 로컬 서버 (선택)
└── VISUALIZER_README.md      # 이 파일
```

## 🔍 사용 예시

### 1. 아이템 찾기
1. 사이드바에서 "Items" 클릭
2. 4개 아이템이 카드로 표시
3. 카드 클릭하여 상세 정보, 스탯, 에셋 연결 확인

### 2. 유닛과 드롭 아이템 관계도 보기
1. "Units" 선택
2. 유닛 카드 클릭
3. "연결된 리소스" 섹션에서 이 유닛에 참조된 모든 리소스 확인

### 3. 빠른 검색
1. 검색창에 찾는 아이템/유닛 이름 또는 ID 입력
2. 현재 타입에서 필터된 결과만 표시
3. 검색 초기화하려면 검색창 비우기

## 💡 개발자를 위한 정보

### JSON 구조 자동 감지
- `build/idlez/*.json` 파일들을 자동 로드
- 각 JSON의 루트 키(items, units, skills 등) 자동 감지
- id 필드를 기준으로 관계도 추적

### 성능 최적화
- 클라이언트 사이드 렌더링 (순수 JavaScript)
- 검색은 메모리에서 수행 (매우 빠름)
- 대규모 리소스 확장 시 가상 스크롤링으로 최적화 가능

### 확장성
새로운 리소스 타입 추가:
1. `build/idlez/` 에 새 JSON 파일 추가 (예: `NewType.json`)
2. `visualizer.html` 의 types 배열에 추가
3. 자동으로 사이드바에 표시됨

## 🎨 UI 특징

- 깔끔한 투톤 디자인 (흰색/파랑)
- 반응형 레이아웃
- 호버 효과와 트랜지션
- 실시간 검색 필터링
- 클릭 가능한 관계도 링크

## 📝 라이선스

프로젝트 내부 개발 도구
