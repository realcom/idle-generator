// Fireball impact SFX recipe.
// Render:
//   python3 harness/tools/sfx_from_h5.py harness/content/idlez/audios/recipes/fireball_impact.sfx.js \
//     --out harness/build/sfx/fireball_impact.wav --duration 0.9 --channels 1

async function renderSfx(ctx, options = {}) {
  const t = 0;
  const volume = options.volume ?? 0.86;

  function seededRandom(seed) {
    let state = seed >>> 0;
    return () => {
      state = (state * 1664525 + 1013904223) >>> 0;
      return state / 0x100000000;
    };
  }

  function noiseSource(duration, seed) {
    const frames = Math.max(1, Math.ceil(ctx.sampleRate * duration));
    const buffer = ctx.createBuffer(1, frames, ctx.sampleRate);
    const data = buffer.getChannelData(0);
    const random = seededRandom(seed);
    for (let i = 0; i < frames; i += 1) {
      const fade = 1 - i / frames;
      data[i] = (random() * 2 - 1) * (0.35 + fade * 0.65);
    }
    const source = ctx.createBufferSource();
    source.buffer = buffer;
    return source;
  }

  function connectEnvelope(source, target, start, points) {
    const gain = ctx.createGain();
    gain.gain.setValueAtTime(0.0001, start);
    for (const [time, value] of points) {
      gain.gain.exponentialRampToValueAtTime(Math.max(0.0001, value), start + time);
    }
    source.connect(gain).connect(target);
    return gain;
  }

  const master = ctx.createGain();
  const shaper = ctx.createWaveShaper();
  const compressor = ctx.createDynamicsCompressor();
  const curve = new Float32Array(512);
  for (let i = 0; i < curve.length; i += 1) {
    const x = (i / (curve.length - 1)) * 2 - 1;
    curve[i] = Math.tanh(x * 2.2);
  }
  shaper.curve = curve;
  shaper.oversample = "2x";
  compressor.threshold.value = -18;
  compressor.knee.value = 18;
  compressor.ratio.value = 5;
  compressor.attack.value = 0.002;
  compressor.release.value = 0.18;
  master.gain.value = volume;
  master.connect(shaper).connect(compressor).connect(ctx.destination);

  const body = ctx.createOscillator();
  const bodyGain = ctx.createGain();
  body.type = "triangle";
  body.frequency.setValueAtTime(options.bodyStartHz ?? 165, t);
  body.frequency.exponentialRampToValueAtTime(options.bodyEndHz ?? 52, t + 0.34);
  bodyGain.gain.setValueAtTime(0.0001, t);
  bodyGain.gain.exponentialRampToValueAtTime(0.95, t + 0.012);
  bodyGain.gain.exponentialRampToValueAtTime(0.12, t + 0.17);
  bodyGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.52);
  body.connect(bodyGain).connect(master);
  body.start(t);
  body.stop(t + 0.55);

  const flame = noiseSource(0.62, options.seed ?? 91021);
  const flameLow = ctx.createBiquadFilter();
  flameLow.type = "lowpass";
  flameLow.frequency.setValueAtTime(3600, t);
  flameLow.frequency.exponentialRampToValueAtTime(620, t + 0.48);
  flameLow.Q.value = 0.72;
  const flameBand = ctx.createBiquadFilter();
  flameBand.type = "bandpass";
  flameBand.frequency.setValueAtTime(840, t);
  flameBand.frequency.exponentialRampToValueAtTime(230, t + 0.56);
  flameBand.Q.value = 1.2;
  flame.connect(flameLow).connect(flameBand);
  connectEnvelope(flameBand, master, t, [
    [0.008, 0.88],
    [0.075, 0.5],
    [0.42, 0.14],
    [0.62, 0.0001],
  ]);
  flame.start(t);
  flame.stop(t + 0.64);

  const crack = noiseSource(0.09, (options.seed ?? 91021) + 17);
  const crackFilter = ctx.createBiquadFilter();
  crackFilter.type = "highpass";
  crackFilter.frequency.value = 2800;
  crack.connect(crackFilter);
  connectEnvelope(crackFilter, master, t + 0.006, [
    [0.003, 0.55],
    [0.018, 0.18],
    [0.07, 0.0001],
  ]);
  crack.start(t + 0.006);
  crack.stop(t + 0.1);

  for (let i = 0; i < 5; i += 1) {
    const sparkTime = t + 0.08 + i * 0.055;
    const spark = ctx.createOscillator();
    const sparkGain = ctx.createGain();
    spark.type = i % 2 ? "square" : "sawtooth";
    spark.frequency.setValueAtTime(880 + i * 185, sparkTime);
    spark.frequency.exponentialRampToValueAtTime(420 + i * 70, sparkTime + 0.045);
    sparkGain.gain.setValueAtTime(0.0001, sparkTime);
    sparkGain.gain.exponentialRampToValueAtTime(0.12 - i * 0.012, sparkTime + 0.004);
    sparkGain.gain.exponentialRampToValueAtTime(0.0001, sparkTime + 0.052);
    spark.connect(sparkGain).connect(master);
    spark.start(sparkTime);
    spark.stop(sparkTime + 0.06);
  }

  const tail = noiseSource(0.34, (options.seed ?? 91021) + 99);
  const tailFilter = ctx.createBiquadFilter();
  tailFilter.type = "bandpass";
  tailFilter.frequency.setValueAtTime(520, t + 0.22);
  tailFilter.frequency.exponentialRampToValueAtTime(180, t + 0.62);
  tailFilter.Q.value = 0.95;
  tail.connect(tailFilter);
  connectEnvelope(tailFilter, master, t + 0.22, [
    [0.018, 0.18],
    [0.2, 0.07],
    [0.34, 0.0001],
  ]);
  tail.start(t + 0.22);
  tail.stop(t + 0.58);
}
