# H5 SFX Renderer

AI가 만든 Web Audio/H5 효과음 코드를 브라우저에서 `OfflineAudioContext`로 렌더링하고 `.wav`로 굽는 도구입니다. 엔진 쪽은 그대로 두고, harness에서 빠르게 효과음을 발산한 뒤 Unity가 먹기 쉬운 WAV로 고정하는 용도입니다.

## 빠른 사용

```bash
# 샘플 레시피 생성
python3 harness/tools/sfx_from_h5.py --write-template harness/build/sfx/slime_pop.js

# WAV 렌더 시도 + 렌더러 HTML 생성
python3 harness/tools/sfx_from_h5.py harness/build/sfx/slime_pop.js \
  --out harness/build/sfx/slime_pop.wav \
  --duration 0.6 \
  --channels 1
```

자동 렌더는 Node + Playwright + 브라우저 바이너리가 있으면 바로 `.wav`를 씁니다. 없으면 `harness/build/sfx/*.render.html`이 생성되며, 브라우저에서 열어 `Preview`로 들어보고 `Export WAV`로 내려받으면 됩니다. Playwright 패키지는 있는데 브라우저가 없다는 메시지가 나오면 해당 환경에서 `npx playwright install chromium`을 한 번 실행하면 됩니다.

## 레시피 계약

권장 형태:

```js
async function renderSfx(ctx, options = {}) {
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.connect(gain).connect(ctx.destination);
  osc.frequency.setValueAtTime(440, 0);
  gain.gain.setValueAtTime(0.5, 0);
  gain.gain.exponentialRampToValueAtTime(0.0001, 0.2);
  osc.start(0);
  osc.stop(0.22);
}
```

일반 H5 스니펫처럼 `new AudioContext()`를 쓰는 코드도 렌더러가 같은 context로 패치해서 실행합니다. 함수 이름이 `renderSfx`, `playSfx`, `playSound`, `play`가 아니면 `--entry 함수명`을 넘기세요.

## 옵션 전달

```bash
python3 harness/tools/sfx_from_h5.py sfx_hit.js \
  --out harness/build/sfx/sfx_hit.wav \
  --option volume=0.7 \
  --option startHz=320 \
  --option metallic=true
```

`--option` 값은 JSON으로 파싱을 시도하므로 숫자, boolean, 배열, 객체를 넣을 수 있습니다.

## HTML 입력

AI가 완성 HTML을 준 경우에도 inline `<script>` 블록을 추출해 렌더합니다.

```bash
python3 harness/tools/sfx_from_h5.py ai_sfx.html --out harness/build/sfx/ai_sfx.wav
```

외부 `<script src="...">`는 재현성이 떨어져서 가져오지 않습니다. 필요한 코드는 inline으로 합쳐 넣는 편이 안전합니다.
