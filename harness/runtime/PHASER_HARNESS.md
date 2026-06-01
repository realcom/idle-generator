# Phaser Harness

Phaser 작업은 Unity/.NET 엔진을 열지 않고도 콘텐츠, UI, 리소스, 배포를 빠르게 확인하기 위한 제작 경로다. 하네스는 아래 단위로 나눈다.

## 1. Smoke

목표: `content -> build -> browser runtime` 기본 연결이 깨지지 않았는지 확인한다.

```bash
python3 harness/tools/phaser_smoke.py mushroomer --no-browser
python3 harness/tools/phaser_smoke.py mushroomer --screenshot /private/tmp/idlez-phaser-smoke.png
python3 harness/tools/phaser_smoke.py mushroomer --timeout 120
```

담당 범위:

- `harness/tools/idlez_compile.py`로 콘텐츠 컴파일
- 로컬 정적 서버 실행
- `idlez-phaser.html`, `Items.json`, `Units.json`, 런타임 JS/vendor 파일 HTTP probe
- 선택적으로 headless Chrome을 띄워 `__idlezPhaser` context, canvas, board tick 진행 확인

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

현재 대상:

- `src/idlez-phaser/hud.js`
- `src/idlez-phaser/modal-system.js`
- `src/idlez-phaser/design-system.js`
- `phaser-ui-harness.html`

예정 확장:

- `harness/runtime/scenarios/<game>/*.json`
- HUD 단독 fixture
- 모달별 golden screenshot

## 4. Asset Audit

목표: 콘텐츠와 런타임 asset 참조가 어긋나는 문제를 배포 전에 잡는다.

예정 확인:

- map `ClientPhaserBackground` 키와 `runtime/assets/maps/**`
- UI icon/button/banner registry와 실제 PNG
- audio 정의와 `runtime/assets/audio/**`
- Spine triple(`.atlas.txt`, `.skel.bytes`, `.png`) 완결성

## 5. Deploy

목표: Railway/static 배포 흐름을 제작 smoke와 분리해 재현 가능하게 만든다.

대상:

- `harness/tools/railway_phaser_deploy.py`
- `harness/deploy/railway/phaser/*`
- `Dockerfile.phaser`
- `railway.json`
