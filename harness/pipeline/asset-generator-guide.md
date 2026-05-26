# Asset Generator Guide — AI 이미지 자동 생성

게임 에셋(아이콘·캐릭터·아이템)을 **텍스트 설명 → AI 이미지 생성**으로 빠르게 제작. growninja 기획팀의 검증된 워크플로우를 도입.

---

## 두 가지 실행 경로

### (A) 사용자 수동 실행 — Unity Editor GUI

```
Tools > Asset Generator (메뉴)
  → 카테고리·부위 선택
  → 참조 이미지 확인
  → 프롬프트 생성·편집
  → 에셋 생성·평가
  → 저장 (자동 import)
```

**장점**: UI에서 즉석 검토·재생성 가능. ART 리드와 함께 진행.  
**단계**: G0~G1 단계, 빠른 검증 필요 시.

---

### (B) AI 자동화 — CLI + Cowork

```bash
python tools/asset_gen_helper.py --category <Type> --desc "설명" --execute
```

**장점**: Claude AI가 기획서(G0) 작성 중에 **직접 호출** → 컨셉 이미지 즉시 생성.  
**제약**: `--execute` 전에 사용자 명시 승인 필수 (API quota 소비).  
**단계**: G0 후보 발산 → 추천안 컨셉 이미지 생성.

---

## 카테고리 및 출력

| 카테고리 | 입력 | 출력 경로 | 파일명 예 |
|---------|------|---------|----------|
| **Currency** | 간단 설명 | `assets/<game>/sprites/` | `item_currency_20260522_143022.png` |
| **Equipment** | 부위(BODY/GEAR/BOOTS/CAPE/CIRCLET/PENDANT/RING/BELT/EARRING/BRACELET/TALISMAN) + 설명 | `assets/<game>/sprites/` | `item_equip_BODY_20260522_143022.png` |
| **Character** | 캐릭터 ID + 설명 | `assets/<game>/sprites/` | `unit_1001_20260522_143022.png` |

---

## CLI 사용법

### 환경 설정 확인

```bash
# 설정 파일 검증 (Layer AI 토큰·Anthropic 키·Style ID)
python tools/asset_gen_helper.py --check-config

# 네트워크 연결 확인
python tools/asset_gen_helper.py --check-network
```

필요 파일: `AssetGeneratorSettings.json`
```json
{
  "layerAIToken": "your-layer-ai-token",
  "layerAIWorkspaceId": "workspace-id",
  "currencyStyleId": "style-id-currency",
  "equipmentStyleId": "style-id-equipment",
  "characterStyleId": "style-id-character",
  "anthropicApiKey": "your-anthropic-key",
  "anthropicModel": "claude-sonnet-4-6"
}
```

---

### Dry-run (API 미호출 검증)

```bash
python tools/asset_gen_helper.py --category Currency \
  --desc "정원 결정 — 녹색 빛나는 꽃 결정체"
```

출력:
```
[1/6] 참조 이미지 5장 수집:
      - assets/idlez/sprites/item_-52.png
      - assets/idlez/sprites/item_-51.png
      ...

[DRY-RUN] 실 API 호출은 안 함.
  - Anthropic: 영문 프롬프트 생성
  - Layer AI: 이미지 생성
  - Anthropic: 평가 (PASS/RETRY)
  - 저장: assets/<game>/sprites/
```

**용도**: 기획서 작성 중 프롬프트·참조 확인. 비용 없음.

---

### 실제 호출 (`--execute`)

```bash
python tools/asset_gen_helper.py --category Currency \
  --desc "정원 결정" --execute
```

**⚠️ 주의**: API 호출로 **quota 소비**. 사용자 승인 필수.

---

### 평가 생략 (빠른 생성)

```bash
python tools/asset_gen_helper.py --category Character \
  --desc "가시 덩굴 술사" --execute --skip-eval
```

Anthropic 평가 단계(PASS/RETRY) 건너뛰고 즉시 저장.

---

## 내부 흐름

### 1단계: 설정 로드
- `AssetGeneratorSettings.json`에서 Layer AI 토큰·Anthropic 키·Style ID 추출

### 2단계: 참조 이미지 자동 수집
- 카테고리에 맞는 기존 에셋 4~6장 샘플링
- Currency: `assets/<game>/sprites/item_-*.png` (음수 대역)
- Equipment: `assets/<game>/sprites/item_*.png`
- Character: `assets/<game>/sprites/unit_*.png`

### 3단계: 프롬프트 생성
- Anthropic API 호출
- 입력: 참조 이미지(base64) + 간단 설명(한/영)
- 출력: 영문 프롬프트 (게임 스타일 맞춤)

### 4단계: 이미지 생성
- Layer AI GraphQL `generateImages` 호출
- 카테고리별 학습된 Style ID 사용 → 게임 톤 자동 정렬
- 비동기 응답: inference ID로 폴링 (최대 40회, 3초 간격)

### 5단계: 자동 평가 (`--skip-eval` 아닐 시)
- Anthropic API: 생성 이미지 평가
- 입력: 참조 이미지 + 생성 이미지 + 프롬프트
- 출력: `PASS` / `RETRY` + 개선 프롬프트
- RETRY면 재생성 권장

### 6단계: 저장
- `assets/<game>/sprites/` 또는 `assets/<game>/units/` 에 PNG 저장
- 파일명: `{prefix}_{YYYYMMDD}_{HHMMSS}.png`

---

## 기획서 작성 시 AssetGenerator 명세

### G0 단계 (후보 발산)

기획서 G0 섹션에 각 후보별로 다음을 포함:

```markdown
## 후보 2: "정원·자연"

### 아트 컨셉
- **전체 톤**: 부드러운 녹색, 자연스러운 조명
- **몬스터**: 식물 모티브, 둥근 실루엣
- **아이템**: 결정·꽃·나뭇잎 소재

### AssetGenerator 입력 명세

| 종류 | 카테고리 | 부위/ID | 설명 |
|------|---------|--------|------|
| 재화 | Currency | — | 정원 결정 — 녹색 빛나는 꽃 결정체 |
| 몬스터 | Character | 201 | 아이비 슬라임 — 덩굴 감싼 부드러운 초록 구체 |
| 장비 | Equipment | BODY | 나뭇잎 갑옷 — 자연스러운 갈색·녹색 톤 |
```

---

### G0 → G1 승인 단계

추천안 선택 후:

```bash
# 1. Dry-run으로 프롬프트·참조 확인
python tools/asset_gen_helper.py --category Currency \
  --desc "정원 결정 — 녹색 빛나는 꽃 결정체"

# 2. 출력 검토 후 사용자 승인
# → "OK, 생성해주세요"

# 3. 실행 (사용자 명시 동의)
python tools/asset_gen_helper.py --category Currency \
  --desc "정원 결정" --execute
```

생성된 이미지 경로를 기획서에 기록:

```markdown
## G1 컨셉 합의

### 승인된 아트

| 종류 | 생성 이미지 | 상태 | 비고 |
|------|-----------|------|------|
| 재화 | `assets/idlez/sprites/item_currency_20260522_143022.png` | approved | Anthropic 자동 평가 PASS |
| 캐릭터 | `assets/idlez/sprites/unit_201_20260522_143456.png` | approved | 한 번의 재생성 후 PASS |
```

---

## AI 협업 규칙

| 작업 | 협업 모드 | 자동 모드 |
|------|:--------:|:--------:|
| Dry-run (참조·프롬프트 확인) | ✅ | ✅ |
| **`--execute` 호출** | **❌ 사용자 승인** | **❌ 사용자 승인** |
| 아트 컨셉 초안 | ✅ (초안만) | ✅ |
| 컨셉 방향 최종 합의 | ❌ (인간 결정) | ❌ (인간 결정) |

**원칙**:
- AI가 dry-run 결과 보여주기 → 사용자 확인 → 사용자가 "OK" 신호 → AI가 `--execute` 호출
- API quota를 사용자가 관리하므로, 부주의한 호출 방지

---

## 체크리스트 (기획서 G0~G1)

- [ ] G0 후보 N종 각각에 아트 컨셉(키워드·무드·모티브)이 명세됐는가
- [ ] 추천안의 **AssetGenerator 입력 명세**(카테고리·부위·간단 설명)가 기획서에 작성됐는가
- [ ] Dry-run 결과로 참조 이미지와 생성될 프롬프트를 확인했는가
- [ ] 사용자가 `--execute` 승인하고 이미지를 생성했는가
- [ ] 생성 이미지 경로를 기획서 G1 섹션에 `approved` 상태로 기록했는가
- [ ] 자동 평가 결과(PASS/RETRY)를 기획서에 부기했는가 (RETRY면 개선 과정 기술)

---

## 참고: 스타일 가이드 (선택)

게임별 일관성을 위해 `assets/<game>/STYLE.md` 작성 권장:

```markdown
# Style Guide — Idle Game Sprites

## 게임 톤
- **카테고리**: 한국 판타지 RPG
- **색 팔레트**: 따뜻한 갈색·녹색·금색 (기본)
- **아이콘 크기**: 128x128px (2배수)
- **선 굵기**: 2-3px (일관)

## 참조 이미지
- 기존 아이템 아이콘: `assets/idlez/sprites/item_*.png`
- 기존 캐릭터: `assets/idlez/sprites/unit_*.png`

## 프롬프트 패턴
- 재화: "재화 이름 — (색·질감·모티브 3~4개)"
- 캐릭터: "캐릭터 이름 — (직업·무기·복장 3~4개)"
```

---

## FAQ

**Q. `--execute`를 실수로 여러 번 호출했어요. 이미지가 여러 개 생성됐는데요?**  
A. 각 호출마다 새 이미지 생성(타임스탬프로 구분). 필요 없는 것은 삭제 후 `asset-registry.yaml`에서 제거.

**Q. Anthropic 평가에서 RETRY가 나왔어요.**  
A. CLI 출력의 "개선된 프롬프트"를 복사해 다시 실행. 예: `--desc "개선된 설명 텍스트" --execute`

**Q. Layer AI / Anthropic 할당량이 부족해요.**  
A. `--check-config`에서 키를 확인. 팀 레벨에서 할당량 증액 요청.

**Q. 참조 이미지가 없어요 (새 게임).**  
A. 카테고리별 기본 샘플 5~10개를 손으로 준비 후 `assets/<game>/sprites/` 에 배치. 다음부터 자동 수집됨.
