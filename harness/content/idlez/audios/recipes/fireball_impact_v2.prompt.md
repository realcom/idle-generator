# Fireball Impact V2 Prompt

Web Audio API로 0.85초짜리 fireball impact SFX를 만들어줘.
게임은 캐주얼 2D idle RPG다. 현실적인 영화 효과음보다는 stylized/cartoony 모바일 RPG 타격음이어야 한다.

소리 구조:

1. 0.00s: 짧고 선명한 저역 impact thump.
   - sine/triangle 계열
   - 190Hz에서 48Hz로 빠르게 pitch drop
   - 0.18초 안에 대부분 사라짐

2. 0.006s: 뜨거운 폭발의 중역 body.
   - filtered noise
   - bandpass 650~1200Hz
   - attack은 빠르게, decay는 0.28초 정도
   - 너무 하얀 노이즈처럼 들리지 않게 lowpass로 둥글게 처리

3. 0.025s~0.32s: 불꽃 crackle 9~13개.
   - 짧은 highpass noise burst
   - 각 burst의 시간, gain, 주파수는 deterministic random으로 약간 다르게
   - crackle은 타격음을 가리지 않고 표면 질감만 준다

4. 0.10s~0.55s: 작은 불꽃 whoosh tail.
   - lowpass noise
   - 1600Hz에서 260Hz로 어두워지며 감소
   - 뒤에서 자연스럽게 사라짐

5. 0.00s~0.08s: 아주 짧은 bright snap.
   - 과하지 않은 high transient
   - 모바일 스피커에서도 타격 시작점이 느껴져야 함

6. 전체 처리:
   - 살짝 saturation/compression
   - peak가 0.75를 넘지 않게 gain staging
   - harsh clipping 금지
   - melody처럼 들리면 안 됨

출력은 아래 형태로:

```js
async function renderSfx(ctx, options = {}) { ... }
```

외부 파일/라이브러리 없이 OfflineAudioContext에서 렌더 가능해야 한다.
