# Asset Pipeline (에셋 리소스)

데이터 정의가 *키로 참조*하는 실제 미디어의 생성·관리·배포. idlez 기준 에셋은 `PatchResources/` + Addressables + CDN 채널에 산다.

## 에셋 종류 (idlez 관찰 기반)

| 종류 | 예시 키 | 엔진 위치 | 참조하는 데이터 필드 |
| --- | --- | --- | --- |
| 스프라이트/아이콘 | `Items/Icon/item_-12.png` | PatchResources | Item.`spriteGroups`, Unit.`sprite` |
| 프리팹 | `FXPrefabs/VFX_DropItem_Gold_Low.prefab` | PatchResources | Item.`prefabGroups`, Unit.`prefab` |
| 애니메이션 | `slime_green_idle` | Animations | Unit.`animations`(map) |
| VFX | `VFX_Hit_Slash` | ##FX / FXPrefabs | Skill.timeline.PlayFx.`prefab`, Unit.`hitFx` |
| 타일맵/맵 씬 | `Map_Meadow_Day` | PatchResources/Maps (Unity 씬·프리팹) | Map 정의 |
| 오디오 | `bgm_meadow`, `sfx_slime_die` | Audios.json(ResourceAudio) | (ResourceAudio 키) |
| 현지화 문자열 | `unit.slime_green.name` | Localization / Strings.json | name 등 (선택) |

## 소스 레이아웃 (관례)

```
harness/assets/<game>/
├── sprites/        # 원본 아트 (png) + 메타
├── icons/
├── prefabs/        # (Unity 프리팹은 idlez 리포 소관 — 여기선 키/요청서)
├── vfx/
├── audio/
├── maps/
└── asset-registry.yaml   # ★ 키 → 파일/상태 매핑 (단일 진실)
```

> Unity 프리팹·씬은 idlez-client 리포가 보유한다. 이 하네스의 `assets/`는 **원본 아트(AI 생성 포함) + 키 레지스트리 + 요청서**를 관리하고, 최종 임포트/번들링은 엔진 리포에서.

## 키 레지스트리 (`asset-registry.yaml`)

데이터 ↔ 에셋의 단일 매핑. 댕글링(데이터가 없는 키 참조)과 고아(아무도 안 쓰는 에셋)를 잡는 근거.

```yaml
# harness/assets/idlez/asset-registry.yaml
assets:
  "assets/units/slime_green.png":
    type: sprite
    status: ai-draft          # ai-draft | review | approved | final
    source: ai-image-gen
    used_by: [unit:110201]    # 역참조 (고아 검출)
  "slime_green_idle":
    type: animation
    status: requested         # 아티스트 요청 중
    used_by: [unit:110201]
```

## AI 활용 (에셋 생성)

| 에셋 | AI 방식 | 산출 |
| --- | --- | --- |
| 스프라이트/아이콘 | 이미지 생성(텍스트→이미지) — **[Asset Generator](asset-generator-guide.md)** CLI 또는 GUI | `harness/assets/<game>/sprites/*.png` (status: ai-draft) |
| 컨셉/배리에이션(발산) | 동일 유닛의 색/등급 변형 일괄 생성 | 변형 세트 |
| 오디오 | Web Audio/H5 레시피 렌더 또는 생성/라이브러리 매칭 | `assets/<game>/audio/*.wav` 후보 + 키 |
| 현지화 | 텍스트 번역/문구 생성 | Strings 항목 |

**스프라이트·아이콘 생성 워크플로우**:
- **AI 기획 중**: `tools/asset_gen_helper.py --category <Type> --desc "설명"` (dry-run) → 검토 → `--execute`
- **사용자 검증**: Unity `Tools > Asset Generator` 메뉴로 실시간 평가·재생성
- **스프라이트 애니메이션**: [Sprite Animation Process](sprite-animation-process.md)의 키포즈 계약 → strip-first 생성 → shared-anchor 정규화 → QC 게이트를 통과한 뒤 바인딩한다.

**UI 아이콘 생산 규칙**:
- 플레이어에게 보이는 최종 UI 아이콘(`ui_icon_set`, 탭/사이드/재화/상태/버튼 glyph)은 built-in `imagegen`/`image_gen`으로 원본 아트워크를 생성한다.
- Pillow, CSS, emoji, Phaser Graphics, 수작업 스크립트는 최종 아이콘 그림을 새로 그리는 용도가 아니라 chroma-key 제거, alpha 검증, crop, resize, packing, naming 같은 후처리 용도로만 사용한다.
- `asset-plan.yaml`에는 `generated_with`, `source_path`, `alpha_source_path` 등 원본 imagegen 산출물과 후처리 과정을 추적할 수 있는 필드를 남긴다.
- 임시 placeholder 아이콘은 `ai-draft` 또는 runtime prototype으로만 취급하고, 승인/런타임 반영 전에 imagegen 기반 아이콘으로 교체한다.

**효과음 생성 워크플로우**:
- AI가 Web Audio/H5 레시피 JS를 작성한다.
- `python3 harness/tools/sfx_from_h5.py <recipe.js> --out harness/build/sfx/<name>.wav`로 브라우저 렌더러 HTML과 WAV 후보를 만든다.
- 자동 렌더가 불가한 환경에서는 생성된 `*.render.html`을 브라우저에서 열어 `Preview` 후 `Export WAV`로 내려받는다.
- 상세: [H5 SFX Renderer](../tools/SFX_H5_README.md)

원칙: AI 산출 에셋은 `status: ai-draft`로 들어가고, 사람이 `approved/final`로 승격해야 빌드에 포함. 스타일 일관성은 **게임별 스타일 가이드**(`harness/assets/<game>/STYLE.md`, 권장)로 프롬프트를 고정. → [Asset Generator Guide 참고](asset-generator-guide.md)

## 바인딩 (데이터 ↔ 에셋)

`asset-producer` 에이전트가 ② 생성 후 ③ 바인딩에서:
1. 데이터 정의의 `sprite`/`prefab`/`animations` 키를 채운다.
2. `asset-registry.yaml`에 키·status·`used_by` 등록.
3. 검증기가 "모든 데이터 참조 키가 레지스트리에 approved 이상으로 존재하는가" 확인.

## 검증 (asset 부분)

- **댕글링 키**: 데이터가 참조하는 에셋 키가 레지스트리에 없음 → 에러
- **고아 에셋**: 레지스트리에 있으나 `used_by` 비어 있음 → 경고
- **status 게이트**: 빌드 대상인데 `ai-draft/requested` 상태 → 경고(릴리스 차단 옵션)
- **네이밍 규칙**: 경로/이름 컨벤션 위반 → 경고

실행:

```bash
python3 harness/tools/asset_registry_audit.py mushroomer
python3 harness/tools/asset_registry_audit.py mushroomer --release
```

## 컴파일/배포

- 에셋 → Addressables 그룹/번들 (idlez 엔진 빌드 단계)
- CDN 채널 매니페스트(`Patches/<channel>/...`, md5+size) 갱신 — 데이터 JSON과 동일 채널 체계
- 게임/환경/플랫폼별 분리 (idlez vs backpack, dev vs live, ios vs aos)
