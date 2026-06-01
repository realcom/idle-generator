// Stylized mobile RPG SFX pack.
// Render one preset:
//   python3 harness/tools/sfx_from_h5.py harness/content/idlez/audios/recipes/sfx_pack_30.sfx.js \
//     --name coin_pickup --option preset=coin_pickup --out harness/build/sfx/coin_pickup.wav --duration 0.45 --channels 1

async function renderSfx(ctx, options = {}) {
  const presetName = options.preset || "ui_click_soft";
  const preset = PRESETS[presetName];
  if (!preset) {
    throw new Error(`Unknown SFX preset: ${presetName}`);
  }

  const rng = createRandom(hashString(`${presetName}:${options.seed ?? 1337}`));
  const master = createMaster(ctx, {
    volume: options.volume ?? preset.volume ?? 1,
    drive: preset.drive ?? 1.25,
    toneHz: preset.toneHz ?? 9000,
    highpassHz: preset.highpassHz ?? 20,
    threshold: preset.threshold ?? -12,
    ratio: preset.ratio ?? 6,
  });

  preset.render(ctx, master.input, rng, options);
}

const PRESETS = {
  ui_click_soft: {
    volume: 1.0,
    drive: 1.12,
    toneHz: 9000,
    highpassHz: 220,
    render(ctx, out, rng) {
      clickDust(ctx, out, rng, 0, 0.08, 5200, 0.024);
      noise(ctx, out, rng, { start: 0.006, duration: 0.04, gain: 0.045, attack: 0.001, decay: 0.03, filter: { type: "bandpass", f0: 980, q: 1.3 }, curve: 1.8 });
    },
  },

  ui_click_confirm: {
    volume: 1.0,
    drive: 1.15,
    toneHz: 9200,
    highpassHz: 180,
    render(ctx, out, rng) {
      clickDust(ctx, out, rng, 0, 0.095, 3600, 0.034);
      clickDust(ctx, out, rng, 0.07, 0.072, 5100, 0.022);
      noise(ctx, out, rng, { start: 0.018, duration: 0.12, gain: 0.05, attack: 0.006, decay: 0.08, filter: { type: "bandpass", f0: 1180, q: 0.9 }, curve: 1.3 });
    },
  },

  ui_error_buzz: {
    volume: 1.16,
    drive: 2.05,
    toneHz: 2200,
    highpassHz: 32,
    threshold: -17,
    render(ctx, out, rng) {
      clickDust(ctx, out, rng, 0, 0.055, 2300, 0.09);
      lowThump(ctx, out, 0, 170, 88, 0.22, 0.12);
      lowThump(ctx, out, 0.12, 135, 72, 0.2, 0.13);
      lowThump(ctx, out, 0.245, 108, 58, 0.16, 0.16);
      noise(ctx, out, rng, { start: 0, duration: 0.1, gain: 0.2, attack: 0.003, decay: 0.07, filter: { type: "bandpass", f0: 310, q: 6.8 }, curve: 0.65 });
      noise(ctx, out, rng, { start: 0.115, duration: 0.11, gain: 0.19, attack: 0.003, decay: 0.08, filter: { type: "bandpass", f0: 250, q: 7.4 }, curve: 0.62 });
      noise(ctx, out, rng, { start: 0.238, duration: 0.16, gain: 0.16, attack: 0.004, decay: 0.12, filter: { type: "bandpass", f0: 190, q: 6.2 }, curve: 0.55 });
      noise(ctx, out, rng, { start: 0.01, duration: 0.28, gain: 0.065, attack: 0.002, decay: 0.18, filter: { type: "highpass", f0: 1600, q: 0.7 }, curve: 2.2 });
    },
  },

  ui_reward_chime: {
    volume: 0.98,
    drive: 1.18,
    toneHz: 10800,
    highpassHz: 170,
    render(ctx, out, rng) {
      airy(ctx, out, rng, 0, 0.46, 0.1, 900, 3600);
      glimmer(ctx, out, rng, 0.05, 0.62, 13, 0.045, 2600, 8200);
      glassPing(ctx, out, 0.18, 2200, 0.12, 0.04);
    },
  },

  coin_pickup: {
    volume: 1.0,
    drive: 1.3,
    toneHz: 8800,
    highpassHz: 220,
    render(ctx, out, rng) {
      clickDust(ctx, out, rng, 0, 0.12, 4200, 0.08);
      clickDust(ctx, out, rng, 0.065, 0.09, 5800, 0.052);
      metalPing(ctx, out, 0.018, 1750, 0.06, 0.04);
      noise(ctx, out, rng, { start: 0.02, duration: 0.18, gain: 0.045, attack: 0.006, decay: 0.13, filter: { type: "bandpass", f0: 2400, q: 2.5 }, curve: 1.7 });
    },
  },

  gem_pickup: {
    volume: 0.98,
    drive: 1.16,
    toneHz: 12500,
    highpassHz: 420,
    render(ctx, out, rng) {
      iceBits(ctx, out, rng, 0, 0.34, 9, 0.045);
      glassPing(ctx, out, 0.06, 3100, 0.12, 0.035);
      glimmer(ctx, out, rng, 0.16, 0.52, 11, 0.026, 4200, 9800);
    },
  },

  level_up: {
    volume: 1.12,
    drive: 1.42,
    toneHz: 9500,
    highpassHz: 55,
    threshold: -15,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 150, 64, 0.16, 0.26);
      airy(ctx, out, rng, 0.02, 0.72, 0.22, 220, 5400);
      noise(ctx, out, rng, { start: 0.28, duration: 0.28, gain: 0.16, attack: 0.018, decay: 0.2, filter: { type: "bandpass", f0: 1100, f1: 2700, q: 0.85 }, curve: 1.1 });
      clickDust(ctx, out, rng, 0.36, 0.11, 5200, 0.12);
      noise(ctx, out, rng, { start: 0.38, duration: 0.18, gain: 0.14, attack: 0.004, decay: 0.12, filter: { type: "highpass", f0: 3600, q: 0.55 }, curve: 2.6 });
      glimmer(ctx, out, rng, 0.34, 0.98, 28, 0.034, 2600, 9000);
      lowThump(ctx, out, 0.42, 105, 72, 0.07, 0.2);
    },
  },

  quest_complete: {
    volume: 0.96,
    drive: 1.18,
    toneHz: 8500,
    highpassHz: 80,
    render(ctx, out, rng) {
      woodKnock(ctx, out, rng, 0, 0.08);
      airy(ctx, out, rng, 0.08, 0.62, 0.1, 420, 2600);
      glimmer(ctx, out, rng, 0.22, 0.7, 11, 0.032, 1800, 5600);
      glassPing(ctx, out, 0.32, 1300, 0.14, 0.04);
    },
  },

  sword_slash_light: {
    volume: 1.08,
    drive: 1.45,
    toneHz: 11000,
    highpassHz: 360,
    render(ctx, out, rng) {
      scrape(ctx, out, rng, 0, 0.26, 0.28, 7600, 1400);
      clickDust(ctx, out, rng, 0.028, 0.09, 5200, 0.05);
      noise(ctx, out, rng, { start: 0.08, duration: 0.12, gain: 0.05, attack: 0.002, decay: 0.08, filter: { type: "highpass", f0: 3000, q: 0.8 }, curve: 2.2 });
    },
  },

  sword_slash_heavy: {
    volume: 1.15,
    drive: 1.6,
    toneHz: 6200,
    highpassHz: 45,
    render(ctx, out, rng) {
      scrape(ctx, out, rng, 0, 0.36, 0.22, 3000, 360);
      lowThump(ctx, out, 0.025, 135, 45, 0.3, 0.28);
      noise(ctx, out, rng, { start: 0.04, duration: 0.25, gain: 0.15, attack: 0.004, decay: 0.18, filter: { type: "bandpass", f0: 520, q: 1.3 }, curve: 1 });
    },
  },

  arrow_shot: {
    volume: 1.08,
    drive: 1.25,
    toneHz: 11500,
    highpassHz: 190,
    render(ctx, out, rng) {
      clickDust(ctx, out, rng, 0, 0.1, 6200, 0.075);
      scrape(ctx, out, rng, 0.018, 0.24, 0.18, 7600, 2800);
      noise(ctx, out, rng, { start: 0.015, duration: 0.1, gain: 0.045, attack: 0.002, decay: 0.07, filter: { type: "bandpass", f0: 340, q: 1.6 }, curve: 1.2 });
    },
  },

  shield_block: {
    volume: 1.12,
    drive: 1.7,
    toneHz: 4800,
    highpassHz: 32,
    render(ctx, out, rng) {
      woodKnock(ctx, out, rng, 0, 0.22);
      metalPing(ctx, out, 0.012, 760, 0.1, 0.045);
      noise(ctx, out, rng, { start: 0.002, duration: 0.16, gain: 0.18, attack: 0.001, decay: 0.1, filter: { type: "bandpass", f0: 330, q: 1.7 }, curve: 1.2 });
    },
  },

  hit_blunt: {
    volume: 1.18,
    drive: 1.72,
    toneHz: 3600,
    highpassHz: 24,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 120, 38, 0.38, 0.22);
      noise(ctx, out, rng, { start: 0.002, duration: 0.17, gain: 0.22, attack: 0.002, decay: 0.13, filter: { type: "lowpass", f0: 650, q: 0.9 }, curve: 0.8 });
      clickDust(ctx, out, rng, 0.014, 0.06, 1800, 0.035);
    },
  },

  hit_critical: {
    volume: 1.08,
    drive: 1.58,
    toneHz: 10000,
    highpassHz: 55,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 180, 42, 0.28, 0.2);
      clickDust(ctx, out, rng, 0, 0.09, 5200, 0.12);
      glassPing(ctx, out, 0.025, 2800, 0.11, 0.055);
      glimmer(ctx, out, rng, 0.07, 0.42, 7, 0.027, 3000, 8600);
    },
  },

  monster_pop: {
    volume: 1.06,
    drive: 1.34,
    toneHz: 5200,
    highpassHz: 50,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 240, 410, 0.13, 0.16);
      noise(ctx, out, rng, { start: 0.02, duration: 0.2, gain: 0.16, attack: 0.003, decay: 0.14, filter: { type: "bandpass", f0: 1250, q: 1.1 }, curve: 2.3 });
      clickDust(ctx, out, rng, 0.12, 0.08, 2600, 0.05);
    },
  },

  slime_squish: {
    volume: 1.12,
    drive: 1.45,
    toneHz: 1700,
    highpassHz: 18,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 82, 45, 0.22, 0.32);
      noise(ctx, out, rng, { start: 0.006, duration: 0.36, gain: 0.26, attack: 0.01, decay: 0.27, filter: { type: "lowpass", f0: 430, q: 2.6 }, curve: 0.5 });
      blobBubbles(ctx, out, rng, 0.06, 8);
    },
  },

  fireball_cast: {
    volume: 1.08,
    drive: 1.55,
    toneHz: 4200,
    highpassHz: 24,
    render(ctx, out, rng) {
      airy(ctx, out, rng, 0, 0.5, 0.22, 260, 1800);
      noise(ctx, out, rng, { start: 0.02, duration: 0.5, gain: 0.24, attack: 0.02, decay: 0.34, filter: { type: "lowpass", f0: 1500, f1: 520, q: 0.8 }, curve: 0.6 });
      crackles(ctx, out, rng, 0.08, 0.54, 10, 0.048, 700, 3200);
    },
  },

  fireball_impact: {
    volume: 1.28,
    drive: 1.75,
    toneHz: 3400,
    highpassHz: 18,
    threshold: -14,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 195, 34, 0.42, 0.26);
      noise(ctx, out, rng, { start: 0, duration: 0.38, gain: 0.32, attack: 0.002, decay: 0.3, filter: { type: "lowpass", f0: 2200, f1: 330, q: 0.65 }, curve: 0.42 });
      clickDust(ctx, out, rng, 0.004, 0.055, 4200, 0.09);
      crackles(ctx, out, rng, 0.025, 0.4, 12, 0.048, 800, 3800);
      noise(ctx, out, rng, { start: 0.12, duration: 0.5, gain: 0.14, attack: 0.014, decay: 0.4, filter: { type: "lowpass", f0: 1050, f1: 220, q: 0.55 }, curve: 0.65 });
    },
  },

  ice_shard_hit: {
    volume: 1.05,
    drive: 1.25,
    toneHz: 13000,
    highpassHz: 420,
    render(ctx, out, rng) {
      iceBits(ctx, out, rng, 0, 0.36, 14, 0.048);
      noise(ctx, out, rng, { start: 0, duration: 0.09, gain: 0.12, attack: 0.001, decay: 0.06, filter: { type: "highpass", f0: 6500, q: 0.6 }, curve: 3.2 });
      glassPing(ctx, out, 0.04, 3600, 0.11, 0.035);
    },
  },

  lightning_zap: {
    volume: 1.08,
    drive: 1.9,
    toneHz: 12000,
    highpassHz: 300,
    threshold: -15,
    render(ctx, out, rng) {
      for (let i = 0; i < 7; i += 1) {
        const start = i * 0.026 + rng() * 0.01;
        clickDust(ctx, out, rng, start, 0.055, 4800 + i * 550, 0.055);
        noise(ctx, out, rng, { start, duration: 0.038, gain: 0.08, attack: 0.001, decay: 0.027, filter: { type: "highpass", f0: 4200 + i * 480, q: 0.75 }, curve: 3.2 });
      }
      scrape(ctx, out, rng, 0.02, 0.18, 0.1, 8800, 1400);
    },
  },

  heal_cast: {
    volume: 0.98,
    drive: 1.12,
    toneHz: 10500,
    highpassHz: 120,
    render(ctx, out, rng) {
      airy(ctx, out, rng, 0, 0.72, 0.12, 450, 2600);
      glimmer(ctx, out, rng, 0.05, 0.78, 18, 0.026, 2200, 6800);
      glassPing(ctx, out, 0.34, 1500, 0.18, 0.035);
    },
  },

  poison_tick: {
    volume: 1.05,
    drive: 1.55,
    toneHz: 1600,
    highpassHz: 18,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 110, 68, 0.11, 0.17);
      noise(ctx, out, rng, { start: 0.012, duration: 0.3, gain: 0.2, attack: 0.004, decay: 0.21, filter: { type: "bandpass", f0: 300, f1: 190, q: 3.4 }, curve: 0.48 });
      blobBubbles(ctx, out, rng, 0.045, 8);
    },
  },

  teleport_whoosh: {
    volume: 1.04,
    drive: 1.4,
    toneHz: 10000,
    highpassHz: 90,
    render(ctx, out, rng) {
      airy(ctx, out, rng, 0, 0.7, 0.16, 260, 7200);
      scrape(ctx, out, rng, 0.24, 0.42, 0.13, 7600, 190);
      noise(ctx, out, rng, { start: 0.08, duration: 0.5, gain: 0.12, attack: 0.04, decay: 0.34, filter: { type: "bandpass", f0: 2500, f1: 580, q: 1.2 }, curve: 1.25 });
      glimmer(ctx, out, rng, 0.2, 0.66, 9, 0.018, 3000, 9000);
    },
  },

  buff_activate: {
    volume: 0.98,
    drive: 1.15,
    highpassHz: 100,
    render(ctx, out, rng) {
      airy(ctx, out, rng, 0, 0.56, 0.1, 300, 2100);
      glimmer(ctx, out, rng, 0.16, 0.6, 12, 0.028, 1800, 6200);
      glassPing(ctx, out, 0.24, 1400, 0.16, 0.04);
    },
  },

  debuff_curse: {
    volume: 1.06,
    drive: 1.7,
    toneHz: 2200,
    highpassHz: 18,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 210, 58, 0.18, 0.48);
      noise(ctx, out, rng, { start: 0.04, duration: 0.55, gain: 0.18, attack: 0.025, decay: 0.4, filter: { type: "bandpass", f0: 270, f1: 150, q: 3.2 }, curve: 0.58 });
      crackles(ctx, out, rng, 0.12, 0.5, 9, 0.022, 260, 1500);
    },
  },

  chest_open: {
    volume: 1.04,
    drive: 1.34,
    toneHz: 7800,
    highpassHz: 38,
    render(ctx, out, rng) {
      woodKnock(ctx, out, rng, 0, 0.12);
      noise(ctx, out, rng, { start: 0.14, duration: 0.22, gain: 0.12, attack: 0.014, decay: 0.16, filter: { type: "bandpass", f0: 240, q: 1.5 }, curve: 1.1 });
      clickDust(ctx, out, rng, 0.31, 0.12, 2800, 0.045);
      glimmer(ctx, out, rng, 0.38, 0.78, 10, 0.024, 2200, 7000);
    },
  },

  item_drop: {
    volume: 1.06,
    drive: 1.36,
    toneHz: 4200,
    highpassHz: 28,
    render(ctx, out, rng) {
      woodKnock(ctx, out, rng, 0, 0.09);
      noise(ctx, out, rng, { start: 0.004, duration: 0.13, gain: 0.1, attack: 0.002, decay: 0.09, filter: { type: "bandpass", f0: 680, q: 1.4 }, curve: 1.4 });
      clickDust(ctx, out, rng, 0.045, 0.08, 2200, 0.04);
    },
  },

  crafting_success: {
    volume: 1.0,
    drive: 1.22,
    highpassHz: 70,
    render(ctx, out, rng) {
      scrape(ctx, out, rng, 0, 0.2, 0.1, 1100, 460);
      clickDust(ctx, out, rng, 0.08, 0.1, 2600, 0.04);
      glimmer(ctx, out, rng, 0.28, 0.72, 12, 0.027, 1800, 6200);
      glassPing(ctx, out, 0.42, 1900, 0.16, 0.04);
    },
  },

  boss_roar_short: {
    volume: 1.18,
    drive: 1.85,
    toneHz: 1500,
    highpassHz: 15,
    threshold: -16,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 95, 36, 0.34, 0.82);
      noise(ctx, out, rng, { start: 0.02, duration: 0.84, gain: 0.34, attack: 0.04, decay: 0.62, filter: { type: "bandpass", f0: 190, f1: 110, q: 2.6 }, curve: 0.4 });
      crackles(ctx, out, rng, 0.1, 0.64, 9, 0.018, 140, 800);
    },
  },

  explosion_small: {
    volume: 1.22,
    drive: 1.82,
    toneHz: 3000,
    highpassHz: 18,
    threshold: -15,
    render(ctx, out, rng) {
      lowThump(ctx, out, 0, 170, 34, 0.4, 0.32);
      noise(ctx, out, rng, { start: 0, duration: 0.4, gain: 0.36, attack: 0.002, decay: 0.32, filter: { type: "lowpass", f0: 2100, f1: 320, q: 0.6 }, curve: 0.38 });
      clickDust(ctx, out, rng, 0.006, 0.1, 3600, 0.08);
      crackles(ctx, out, rng, 0.08, 0.48, 10, 0.035, 600, 3200);
    },
  },
};

function createMaster(ctx, opts) {
  const input = ctx.createGain();
  const highpass = ctx.createBiquadFilter();
  const tone = ctx.createBiquadFilter();
  const drive = ctx.createWaveShaper();
  const comp = ctx.createDynamicsCompressor();
  const output = ctx.createGain();

  highpass.type = "highpass";
  highpass.frequency.value = opts.highpassHz;
  highpass.Q.value = 0.5;

  tone.type = "lowpass";
  tone.frequency.value = opts.toneHz;
  tone.Q.value = 0.45;

  drive.curve = saturationCurve(opts.drive);
  drive.oversample = "2x";

  comp.threshold.value = opts.threshold;
  comp.knee.value = 14;
  comp.ratio.value = opts.ratio;
  comp.attack.value = 0.001;
  comp.release.value = 0.12;

  output.gain.value = opts.volume;
  input.connect(highpass).connect(tone).connect(drive).connect(comp).connect(output).connect(ctx.destination);
  return { input };
}

function osc(ctx, out, opts) {
  const source = ctx.createOscillator();
  const gain = ctx.createGain();
  source.type = opts.type || "sine";
  source.frequency.setValueAtTime(Math.max(1, opts.f0), opts.start);
  if (opts.f1 && opts.f1 !== opts.f0) {
    source.frequency.exponentialRampToValueAtTime(Math.max(1, opts.f1), opts.start + opts.duration * 0.82);
  }
  envelope(gain.gain, opts.start, opts.attack ?? 0.004, opts.gain ?? 0.1, opts.decay ?? opts.duration * 0.75);
  source.connect(gain).connect(out);
  source.start(opts.start);
  source.stop(opts.start + opts.duration);
}

function noise(ctx, out, rng, opts) {
  const source = makeNoise(ctx, opts.duration, rng, opts.curve ?? 1);
  const gain = ctx.createGain();
  const first = opts.filter ? createFilter(ctx, opts.filter, opts.start, opts.duration) : null;
  envelope(gain.gain, opts.start, opts.attack ?? 0.004, opts.gain ?? 0.1, opts.decay ?? opts.duration * 0.8);
  if (first) {
    source.connect(first).connect(gain).connect(out);
  } else {
    source.connect(gain).connect(out);
  }
  source.start(opts.start);
  source.stop(opts.start + opts.duration);
}

function sweep(ctx, out, rng, opts) {
  const source = makeNoise(ctx, opts.duration, rng, opts.curve ?? 1.25);
  const filter = ctx.createBiquadFilter();
  const gain = ctx.createGain();
  filter.type = "bandpass";
  filter.Q.value = opts.q ?? 1;
  filter.frequency.setValueAtTime(Math.max(1, opts.f0), opts.start);
  filter.frequency.exponentialRampToValueAtTime(Math.max(1, opts.f1), opts.start + opts.duration * 0.9);
  envelope(gain.gain, opts.start, opts.attack ?? 0.012, opts.gain ?? 0.12, opts.decay ?? opts.duration * 0.8);
  source.connect(filter).connect(gain).connect(out);
  source.start(opts.start);
  source.stop(opts.start + opts.duration);
}

function bell(ctx, out, start, freq, duration, gainValue) {
  osc(ctx, out, { type: "sine", start, duration, f0: freq, f1: freq * 0.992, gain: gainValue, attack: 0.004, decay: duration * 0.82 });
  osc(ctx, out, { type: "triangle", start: start + 0.002, duration: duration * 0.7, f0: freq * 2.01, f1: freq * 1.98, gain: gainValue * 0.22, attack: 0.003, decay: duration * 0.55 });
}

function metalPing(ctx, out, start, freq, duration, gainValue) {
  osc(ctx, out, { type: "triangle", start, duration, f0: freq, f1: freq * 0.96, gain: gainValue, attack: 0.002, decay: duration * 0.8 });
  osc(ctx, out, { type: "sine", start: start + 0.001, duration: duration * 0.7, f0: freq * 1.51, f1: freq * 1.47, gain: gainValue * 0.45, attack: 0.002, decay: duration * 0.56 });
}

function glassPing(ctx, out, start, freq, duration, gainValue) {
  osc(ctx, out, { type: "sine", start, duration, f0: freq, f1: freq * 1.006, gain: gainValue, attack: 0.002, decay: duration * 0.86 });
  osc(ctx, out, { type: "sine", start: start + 0.001, duration: duration * 0.82, f0: freq * 2.37, f1: freq * 2.31, gain: gainValue * 0.35, attack: 0.002, decay: duration * 0.62 });
  osc(ctx, out, { type: "triangle", start: start + 0.003, duration: duration * 0.56, f0: freq * 3.12, f1: freq * 3.03, gain: gainValue * 0.18, attack: 0.002, decay: duration * 0.42 });
}

function clickDust(ctx, out, rng, start, duration, freq, gainValue) {
  noise(ctx, out, rng, {
    start,
    duration,
    gain: gainValue,
    attack: 0.001,
    decay: Math.max(0.012, duration * 0.62),
    filter: { type: "highpass", f0: freq, q: 0.6 },
    curve: 3,
  });
  noise(ctx, out, rng, {
    start: start + 0.002,
    duration: duration * 0.75,
    gain: gainValue * 0.45,
    attack: 0.001,
    decay: duration * 0.42,
    filter: { type: "bandpass", f0: freq * 0.38, q: 1.4 },
    curve: 2.1,
  });
}

function lowThump(ctx, out, start, f0, f1, gainValue, duration) {
  osc(ctx, out, {
    type: "triangle",
    start,
    duration,
    f0,
    f1,
    gain: gainValue,
    attack: Math.min(0.012, duration * 0.08),
    decay: duration * 0.78,
  });
}

function airy(ctx, out, rng, start, duration, gainValue, f0, f1) {
  sweep(ctx, out, rng, {
    start,
    duration,
    gain: gainValue,
    f0,
    f1,
    q: 0.75,
    curve: 1.05,
  });
  noise(ctx, out, rng, {
    start: start + duration * 0.08,
    duration: duration * 0.75,
    gain: gainValue * 0.42,
    attack: duration * 0.08,
    decay: duration * 0.5,
    filter: { type: "bandpass", f0: (f0 + f1) * 0.45, f1: f0 * 0.8, q: 0.9 },
    curve: 1.2,
  });
}

function glimmer(ctx, out, rng, start, end, count, gainValue, minFreq, maxFreq) {
  for (let i = 0; i < count; i += 1) {
    const t = start + (end - start) * rng();
    clickDust(ctx, out, rng, t, 0.035 + rng() * 0.035, minFreq + rng() * (maxFreq - minFreq), gainValue * (0.55 + rng() * 0.75));
  }
}

function iceBits(ctx, out, rng, start, end, count, gainValue) {
  for (let i = 0; i < count; i += 1) {
    const t = start + (end - start) * rng();
    clickDust(ctx, out, rng, t, 0.03 + rng() * 0.035, 5200 + rng() * 5000, gainValue * (0.6 + rng()));
    if (i % 4 === 0) {
      glassPing(ctx, out, t + 0.004, 2400 + rng() * 2600, 0.08 + rng() * 0.04, gainValue * 0.28);
    }
  }
}

function scrape(ctx, out, rng, start, duration, gainValue, f0, f1) {
  sweep(ctx, out, rng, { start, duration, gain: gainValue, f0, f1, q: 1.15, curve: 1.5 });
  noise(ctx, out, rng, {
    start: start + duration * 0.12,
    duration: duration * 0.55,
    gain: gainValue * 0.32,
    attack: 0.002,
    decay: duration * 0.35,
    filter: { type: "highpass", f0: Math.max(f0, f1) * 0.7, q: 0.7 },
    curve: 2.2,
  });
}

function woodKnock(ctx, out, rng, start, gainValue) {
  lowThump(ctx, out, start, 190, 75, gainValue * 1.8, 0.18);
  noise(ctx, out, rng, {
    start,
    duration: 0.14,
    gain: gainValue * 1.25,
    attack: 0.002,
    decay: 0.09,
    filter: { type: "bandpass", f0: 420, q: 1.5 },
    curve: 1.2,
  });
}

function sparkle(ctx, out, rng, start, end, count, gainValue, minFreq = 1400, maxFreq = 4000) {
  for (let i = 0; i < count; i += 1) {
    const t = start + (end - start) * rng();
    const f = minFreq + rng() * (maxFreq - minFreq);
    bell(ctx, out, t, f, 0.06 + rng() * 0.07, gainValue * (0.65 + rng() * 0.55));
  }
}

function crackles(ctx, out, rng, start, end, count, gainValue, minFreq = 1800, maxFreq = 4400) {
  for (let i = 0; i < count; i += 1) {
    const t = start + (end - start) * rng();
    noise(ctx, out, rng, {
      start: t,
      duration: 0.018 + rng() * 0.03,
      gain: gainValue * (0.55 + rng() * 0.8),
      attack: 0.001,
      decay: 0.02 + rng() * 0.025,
      filter: { type: "highpass", f0: minFreq + rng() * (maxFreq - minFreq), q: 0.8 },
      curve: 2.2,
    });
  }
}

function blobBubbles(ctx, out, rng, start, count) {
  for (let i = 0; i < count; i += 1) {
    const t = start + i * 0.045 + rng() * 0.02;
    osc(ctx, out, { type: "sine", start: t, duration: 0.09, f0: 180 + rng() * 120, f1: 95 + rng() * 80, gain: 0.04 + rng() * 0.035, attack: 0.006, decay: 0.06 });
  }
}

function envelope(param, start, attack, peak, decay) {
  const safeAttack = Math.max(0.001, attack);
  const safeDecay = Math.max(0.003, decay);
  param.cancelScheduledValues(start);
  param.setValueAtTime(0.0001, start);
  param.exponentialRampToValueAtTime(Math.max(0.0001, peak), start + safeAttack);
  param.exponentialRampToValueAtTime(0.0001, start + safeAttack + safeDecay);
}

function createFilter(ctx, opts, start, duration) {
  const filter = ctx.createBiquadFilter();
  filter.type = opts.type || "bandpass";
  filter.Q.value = opts.q ?? 1;
  filter.frequency.setValueAtTime(Math.max(1, opts.f0), start);
  if (opts.f1 && opts.f1 !== opts.f0) {
    filter.frequency.exponentialRampToValueAtTime(Math.max(1, opts.f1), start + duration * 0.85);
  }
  return filter;
}

function makeNoise(ctx, duration, rng, curvePower) {
  const frames = Math.max(1, Math.ceil(duration * ctx.sampleRate));
  const buffer = ctx.createBuffer(1, frames, ctx.sampleRate);
  const data = buffer.getChannelData(0);
  for (let i = 0; i < frames; i += 1) {
    const p = i / Math.max(1, frames - 1);
    const fade = Math.pow(1 - p, curvePower);
    data[i] = (rng() * 2 - 1) * fade;
  }
  const source = ctx.createBufferSource();
  source.buffer = buffer;
  return source;
}

function saturationCurve(amount) {
  const curve = new Float32Array(1024);
  const normal = Math.tanh(amount);
  for (let i = 0; i < curve.length; i += 1) {
    const x = (i / (curve.length - 1)) * 2 - 1;
    curve[i] = Math.tanh(x * amount) / normal;
  }
  return curve;
}

function hashString(value) {
  let hash = 2166136261;
  for (let i = 0; i < value.length; i += 1) {
    hash ^= value.charCodeAt(i);
    hash = Math.imul(hash, 16777619);
  }
  return hash >>> 0;
}

function createRandom(seed) {
  let state = seed >>> 0;
  return () => {
    state += 0x6d2b79f5;
    let t = state;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
