# Phaser Harness

Phaser 작업은 Unity/.NET 엔진을 열지 않고도 콘텐츠, UI, 리소스, 배포를 빠르게 확인하기 위한 제작 경로다. 하네스는 아래 단위로 나눈다.

## 1. Smoke

목표: `content -> build -> browser runtime` 기본 연결이 깨지지 않았는지 확인한다.

```bash
python3 harness/tools/phaser_smoke.py mushroomer --no-browser
python3 harness/tools/phaser_smoke.py mushroomer --screenshot /private/tmp/idlez-phaser-smoke.png
python3 harness/tools/phaser_smoke.py mushroomer --timeout 120
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --screenshot /private/tmp/ninja2-survivor-battle.png
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --query "game=ninja2&mode=battle&levelup=demo" --screenshot /private/tmp/ninja2-survivor-levelup.png
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --query "game=ninja2&mode=battle&levelup=demo&skilluse=demo&fullAssets=1" --timeout 140 --screenshot /private/tmp/ninja2-survivor-skilluse.png
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --query "game=ninja2&mode=battle&vfx=demo" --timeout 120 --screenshot /private/tmp/ninja2-survivor-vfx.png
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --query "game=ninja2&mode=battle&encounter=demo" --timeout 50 --screenshot /private/tmp/ninja2-survivor-encounters.png
python3 harness/tools/phaser_smoke.py ninja2 --runtime harness/runtime/survivor-runtime.html --expect survivor --query "game=ninja2&mode=battle&loop=boss" --timeout 140 --screenshot /private/tmp/ninja2-survivor-loop.png
```

담당 범위:

- `harness/tools/idlez_compile.py`로 콘텐츠 컴파일
- 로컬 정적 서버 실행
- `idlez-phaser.html`, `Items.json`, `Units.json`, 런타임 JS/vendor 파일 HTTP probe
- 선택적으로 headless Chrome을 띄워 `__idlezPhaser` context, canvas, board tick 진행 확인
- `--expect survivor`일 때는 `survivor-runtime.html`의 `__IDLEZ_SURVIVOR__` / `__IDLEZ_SURVIVOR_BOARD__`와 `data-survivor-*` 계약으로 전투, 레벨업 선택, 실제 런 스킬 선택/타격 `skilluse=demo`, 스킬 VFX 데모, 맵 update trigger 기반 랜덤 인카운트 `encounter=demo`, `loop=full` 결과 화면 fixture와 `loop=boss` 보스 처치 승리 fixture를 확인
- Ninja2 battle HUD의 타이머/처치/적/픽업/보스 카운터는 `ninja2.ui.battle_counter_icons_v1` 생성 PNG를 `/battle-counters/` CSS background로 사용하며, survivor smoke가 이 경로를 확인한다.
- Ninja2 랜덤 인카운트 폭탄/자석/회복약/광산 픽업은 `ninja2.battle.encounter_icons.light_v1` 생성 PNG를 `/battle/encounters/` Phaser image texture로 사용하며, procedural Graphics 아이콘은 fallback 전용이다.
- Ninja2 D1 실제 런 선택 풀은 300102/300103/300115로 제한한다. `vfx=demo`의 16개 스킬은 이펙트 검증용 전체 카탈로그이고, 시작 캐릭터 기본 스킬은 300101 자동타 1개만 표시한다.
- 습득한 런 스킬은 실제 발동 시 프로필 스킬 아이콘 펄스, HUD 짧은 발동 chip, 플레이어 근처 스킬명 float text를 동시에 띄우며, `skilluse=demo` smoke가 `survivorRunSkillFeedbackCount`를 확인한다.

브라우저 smoke는 현재 `idlez-phaser.html`이 Phaser/protobuf를 CDN에서 읽기 때문에 네트워크가 막힌 환경에서는 실패할 수 있다. 이때는 `--no-browser`로 로컬 파일/빌드 연결만 먼저 확인한다.

headless Chrome에서 Spine asset preload가 느린 머신은 `--timeout`을 늘린다.

## 2. Runtime Core

목표: 게임 독립 실행 로직을 안정적으로 유지한다.

대상:

- `src/idlez-phaser/board-kernel.js`
- `src/idlez-phaser/trigger-vm.js`
- `src/idlez-phaser/resource-store.js`
- `src/idlez-phaser/network/*`

콘텐츠 제작 중에는 이 계층을 되도록 건드리지 않고, 필요한 경우 smoke를 먼저 추가한 뒤 수정한다.

## 3. UI Preview

목표: HUD, 성장, 장비, 스킬, 던전 같은 화면 상태를 전투 진입 없이 재현한다.

제작 순서:

```text
extract-design-system -> prepare-phaser-nine-slice -> gen-ui-assets -> gen-phaser-ui-spec -> build-phaser-ui-runtime
```

`prepare-phaser-nine-slice`는 버튼/패널/dock/tab/chip/card 같은 generated UI skin을 Phaser 9-slice로 쓸지 먼저 판정한다. 세부 기준은 `harness/runtime/NINE_SLICE_UI.md`가 단일 출처다.

`gen-phaser-ui-spec`는 `harness/runtime/specs/ui/`에 구현 명세를 먼저 남기고, `build-phaser-ui-runtime`이 그 명세를 기준으로 런타임 JS/HTML/CSS를 수정한다.

UI 아이콘 생산 정책:

- `type: ui_icon_set` 또는 탭/사이드바/재화/상태 아이콘처럼 플레이어가 직접 보는 최종 아이콘 아트워크는 built-in `imagegen`/`image_gen` 산출물을 사용한다.
- 로컬 스크립트나 Pillow는 chroma-key 제거, alpha 검증, cell crop, resize, sprite-sheet packing 같은 후처리 용도로만 쓴다. 최종 아이콘 그림 자체를 절차적으로 새로 그리지 않는다.
- `asset-plan.yaml`에는 `generated_with`, `source_path`, `alpha_source_path` 또는 동등한 원본 추적 필드를 남겨 imagegen 원본과 후처리 경로를 확인할 수 있게 한다.
- CSS/emoji/Phaser Graphics 아이콘은 임시 wireframe 또는 명시적으로 승인된 runtime primitive에만 허용하며, approved UI icon asset을 대체할 수 없다.

실행:

```bash
python3 harness/tools/phaser_smoke.py mushroomer --no-browser
python3 -m http.server 8765
```

브라우저 smoke:

```bash
python3 harness/tools/phaser_smoke.py mushroomer --skip-compile --runtime harness/runtime/phaser-ui-harness.html --expect ui --screenshot /private/tmp/idlez-phaser-ui-harness.png
```

URL:

```text
http://127.0.0.1:8765/harness/runtime/phaser-ui-harness.html
http://127.0.0.1:8765/harness/runtime/phaser-ui-harness.html?modal=achievements
http://127.0.0.1:8765/harness/runtime/phaser-ui-harness.html?modal=weekdayDungeon
```

공용 모달 시스템 하네스:

```bash
python3 harness/tools/phaser_smoke.py ninja2 --skip-compile --runtime harness/runtime/phaser-modal-system-harness.html --expect ui --screenshot /private/tmp/phaser-modal-system-harness-shell.png
```

```text
http://127.0.0.1:8765/harness/runtime/phaser-modal-system-harness.html?game=ninja2&variant=shell
http://127.0.0.1:8765/harness/runtime/phaser-modal-system-harness.html?game=ninja2&variant=skillChoice
```

이 하네스는 `ResourceStore`/`BoardKernel` 없이 부팅된다. 새 게임의 모달 시스템을 만들 때는 먼저 `harness/runtime/specs/ui/phaser-modal-system-harness.yaml`의 `ModalHost`, `ModalShell`, variant 계약을 맞춘 뒤 게임별 스킨과 오너먼트만 교체한다.

현재 대상:

- `src/idlez-phaser/hud.js`
- `src/idlez-phaser/modal-system.js`
- `src/idlez-phaser/design-system.js`
- `phaser-ui-harness.html`
- `phaser-modal-system-harness.html`

예정 확장:

- `harness/runtime/scenarios/<game>/*.json`
- HUD 단독 fixture
- 모달별 golden screenshot

## 4. Asset Audit

목표: 콘텐츠와 런타임 asset 참조가 어긋나는 문제를 배포 전에 잡는다.

실행:

```bash
python3 harness/tools/phaser_asset_audit.py mushroomer
python3 harness/tools/phaser_nineslice_audit.py mushroomer
python3 harness/tools/phaser_asset_audit.py mushroomer --json
python3 harness/tools/asset_registry_audit.py mushroomer --release
```

확인:

- map `ClientPhaserBackground` 키와 `runtime/assets/maps/**`
- UI icon/button/banner registry와 실제 PNG
- UI skin `slice_hints`, `phaser.usage: phaser_nineslice`, Unity sliced sprite 계약
- audio 정의와 `runtime/assets/audio/**`
- Spine triple(`.atlas.txt`, `.skel.bytes`, `.png`) 완결성
- Spine atlas page image 참조
- `harness/assets/<game>/asset-registry.yaml` coverage/status

## 5. Deploy

목표: Railway/static 배포 흐름을 제작 smoke와 분리해 재현 가능하게 만든다.

대상:

- `harness/tools/railway_phaser_deploy.py`
- `harness/deploy/railway/phaser/*`
- `Dockerfile.phaser`
- `railway.json`
