// Fireball impact SFX v2.
// Prompt-guided layered Web Audio recipe. See fireball_impact_v2.prompt.md.
// Render:
//   python3 harness/tools/sfx_from_h5.py harness/content/idlez/audios/recipes/fireball_impact_v2.sfx.js \
//     --out harness/build/sfx/fireball_impact_v2.wav --duration 0.85 --channels 1

async function renderSfx(ctx, options = {}) {
  const seed = options.seed ?? 424242;
  const volume = options.volume ?? 1.35;
  const t0 = 0;

  function randomFactory(initial) {
    let state = initial >>> 0;
    return () => {
      state ^= state << 13;
      state ^= state >>> 17;
      state ^= state << 5;
      return ((state >>> 0) / 0xffffffff);
    };
  }

  const random = randomFactory(seed);

  function makeNoise(duration, gainCurve = null) {
    const frames = Math.max(1, Math.ceil(duration * ctx.sampleRate));
    const buffer = ctx.createBuffer(1, frames, ctx.sampleRate);
    const data = buffer.getChannelData(0);
    for (let i = 0; i < frames; i += 1) {
      const p = i / Math.max(1, frames - 1);
      const shaped = gainCurve ? gainCurve(p) : 1;
      data[i] = (random() * 2 - 1) * shaped;
    }
    const source = ctx.createBufferSource();
    source.buffer = buffer;
    return source;
  }

  function expEnv(param, start, points) {
    param.cancelScheduledValues(start);
    param.setValueAtTime(0.0001, start);
    for (const [offset, value] of points) {
      param.exponentialRampToValueAtTime(Math.max(0.0001, value), start + offset);
    }
  }

  function linearEnv(param, start, points) {
    param.cancelScheduledValues(start);
    param.setValueAtTime(points[0][1], start + points[0][0]);
    for (let i = 1; i < points.length; i += 1) {
      param.linearRampToValueAtTime(points[i][1], start + points[i][0]);
    }
  }

  function saturator(amount) {
    const curve = new Float32Array(1024);
    for (let i = 0; i < curve.length; i += 1) {
      const x = (i / (curve.length - 1)) * 2 - 1;
      curve[i] = Math.tanh(x * amount) / Math.tanh(amount);
    }
    const node = ctx.createWaveShaper();
    node.curve = curve;
    node.oversample = "2x";
    return node;
  }

  const pre = ctx.createGain();
  const tone = ctx.createBiquadFilter();
  const drive = saturator(1.65);
  const limiter = ctx.createDynamicsCompressor();
  const out = ctx.createGain();

  tone.type = "lowpass";
  tone.frequency.value = 7200;
  tone.Q.value = 0.45;
  limiter.threshold.value = -13;
  limiter.knee.value = 14;
  limiter.ratio.value = 7;
  limiter.attack.value = 0.001;
  limiter.release.value = 0.12;
  out.gain.value = volume;

  pre.connect(tone).connect(drive).connect(limiter).connect(out).connect(ctx.destination);

  // 1. Low impact thump: short, front-loaded, and pitch-dropping.
  const thump = ctx.createOscillator();
  const thumpGain = ctx.createGain();
  thump.type = "triangle";
  thump.frequency.setValueAtTime(190, t0);
  thump.frequency.exponentialRampToValueAtTime(48, t0 + 0.16);
  thumpGain.gain.setValueAtTime(0.0001, t0);
  thumpGain.gain.exponentialRampToValueAtTime(0.92, t0 + 0.009);
  thumpGain.gain.exponentialRampToValueAtTime(0.2, t0 + 0.07);
  thumpGain.gain.exponentialRampToValueAtTime(0.0001, t0 + 0.2);
  thump.connect(thumpGain).connect(pre);
  thump.start(t0);
  thump.stop(t0 + 0.22);

  // 2. Warm mid explosion body.
  const body = makeNoise(0.33, (p) => Math.pow(1 - p, 0.55));
  const bodyLow = ctx.createBiquadFilter();
  const bodyBand = ctx.createBiquadFilter();
  const bodyGain = ctx.createGain();
  bodyLow.type = "lowpass";
  bodyLow.frequency.setValueAtTime(4200, t0);
  bodyLow.frequency.exponentialRampToValueAtTime(900, t0 + 0.28);
  bodyLow.Q.value = 0.62;
  bodyBand.type = "bandpass";
  bodyBand.frequency.setValueAtTime(1150, t0 + 0.006);
  bodyBand.frequency.exponentialRampToValueAtTime(650, t0 + 0.25);
  bodyBand.Q.value = 0.9;
  expEnv(bodyGain.gain, t0 + 0.006, [
    [0.006, 0.56],
    [0.08, 0.32],
    [0.28, 0.0001],
  ]);
  body.connect(bodyLow).connect(bodyBand).connect(bodyGain).connect(pre);
  body.start(t0 + 0.006);
  body.stop(t0 + 0.34);

  // 3. Bright snap for mobile-speaker readability.
  const snap = makeNoise(0.052, (p) => Math.pow(1 - p, 3.2));
  const snapHigh = ctx.createBiquadFilter();
  const snapGain = ctx.createGain();
  snapHigh.type = "highpass";
  snapHigh.frequency.value = 3100;
  snapHigh.Q.value = 0.5;
  expEnv(snapGain.gain, t0 + 0.004, [
    [0.002, 0.2],
    [0.018, 0.045],
    [0.052, 0.0001],
  ]);
  snap.connect(snapHigh).connect(snapGain).connect(pre);
  snap.start(t0 + 0.004);
  snap.stop(t0 + 0.06);

  // 4. Deterministic crackles across the first third of the sound.
  for (let i = 0; i < 11; i += 1) {
    const start = t0 + 0.025 + i * 0.025 + random() * 0.018;
    const duration = 0.018 + random() * 0.026;
    const crack = makeNoise(duration, (p) => Math.pow(1 - p, 2.1));
    const high = ctx.createBiquadFilter();
    const peak = ctx.createBiquadFilter();
    const gain = ctx.createGain();
    high.type = "highpass";
    high.frequency.value = 1800 + random() * 2200;
    peak.type = "peaking";
    peak.frequency.value = 2600 + random() * 2400;
    peak.Q.value = 3 + random() * 4;
    peak.gain.value = 4 + random() * 5;
    expEnv(gain.gain, start, [
      [0.002, 0.04 + random() * 0.065],
      [duration, 0.0001],
    ]);
    crack.connect(high).connect(peak).connect(gain).connect(pre);
    crack.start(start);
    crack.stop(start + duration + 0.004);
  }

  // 5. Flame whoosh tail: present, but tucked behind the hit.
  const tailStart = t0 + 0.1;
  const tail = makeNoise(0.5, (p) => Math.pow(1 - p, 0.75));
  const tailLow = ctx.createBiquadFilter();
  const tailBand = ctx.createBiquadFilter();
  const tailGain = ctx.createGain();
  tailLow.type = "lowpass";
  tailLow.frequency.setValueAtTime(1600, tailStart);
  tailLow.frequency.exponentialRampToValueAtTime(260, tailStart + 0.44);
  tailLow.Q.value = 0.55;
  tailBand.type = "bandpass";
  tailBand.frequency.setValueAtTime(520, tailStart);
  tailBand.frequency.exponentialRampToValueAtTime(190, tailStart + 0.42);
  tailBand.Q.value = 0.72;
  expEnv(tailGain.gain, tailStart, [
    [0.012, 0.19],
    [0.22, 0.07],
    [0.48, 0.0001],
  ]);
  tail.connect(tailLow).connect(tailBand).connect(tailGain).connect(pre);
  tail.start(tailStart);
  tail.stop(tailStart + 0.5);

  // Subtle ember chirps, low enough to avoid becoming a melody.
  for (let i = 0; i < 4; i += 1) {
    const start = t0 + 0.12 + i * 0.07 + random() * 0.02;
    const ember = ctx.createOscillator();
    const emberGain = ctx.createGain();
    ember.type = "sine";
    ember.frequency.setValueAtTime(520 + random() * 420, start);
    ember.frequency.exponentialRampToValueAtTime(260 + random() * 160, start + 0.035);
    expEnv(emberGain.gain, start, [
      [0.003, 0.025 + random() * 0.02],
      [0.038, 0.0001],
    ]);
    ember.connect(emberGain).connect(pre);
    ember.start(start);
    ember.stop(start + 0.045);
  }

  // Tiny master fade-out to avoid a click at the render edge.
  linearEnv(out.gain, t0, [
    [0, volume],
    [0.77, volume],
    [0.85, 0],
  ]);
}
