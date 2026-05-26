// Web Audio SFX recipe template.
// Render with: python3 harness/tools/sfx_from_h5.py this_file.js --out harness/build/sfx/example.wav

async function renderSfx(ctx, options = {}) {
  const t = 0;
  const out = ctx.createGain();
  out.gain.value = options.volume ?? 0.8;
  out.connect(ctx.destination);

  const thump = ctx.createOscillator();
  const thumpGain = ctx.createGain();
  thump.type = "sine";
  thump.frequency.setValueAtTime(options.startHz ?? 260, t);
  thump.frequency.exponentialRampToValueAtTime(options.endHz ?? 92, t + 0.18);
  thumpGain.gain.setValueAtTime(0.0001, t);
  thumpGain.gain.exponentialRampToValueAtTime(0.9, t + 0.008);
  thumpGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.24);
  thump.connect(thumpGain).connect(out);
  thump.start(t);
  thump.stop(t + 0.25);

  const noise = Sfx.whiteNoise(ctx, 0.16);
  const filter = ctx.createBiquadFilter();
  const noiseGain = ctx.createGain();
  filter.type = "bandpass";
  filter.frequency.setValueAtTime(options.noiseHz ?? 1400, t);
  filter.Q.value = 4.5;
  noiseGain.gain.setValueAtTime(0.0001, t);
  noiseGain.gain.exponentialRampToValueAtTime(0.28, t + 0.012);
  noiseGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.13);
  noise.connect(filter).connect(noiseGain).connect(out);
  noise.start(t);
  noise.stop(t + 0.16);
}
