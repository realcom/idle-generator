import { NINJA2_SKILL_EFFECT_RECIPES } from './ninja2-skill-effects.js';

export const GOLDEN_SAMPLE_GUIDE = `Golden sample families in this lab:
- hit_pop_small: short target pop, readable within 0.2s
- hit_pop_crit: stronger impact, still clears quickly
- slash_arc: clear white edge plus colored trail
- dash_cut_trail: path motion, target sparks, no screen cover
- projectile_trail: caster-to-target travel with delayed impact
- impact_shockwave: center flash plus expanding ring
- heal_pulse: upward soft motes, gentle palette, caster/target readable
- caster_aura: looping buff around caster, low alpha, stable silhouette
- shield_ring: protective circle, not an explosion
- poison_cloud: lingering cloud with slow upward drift
- burn_tick: small repeated fire ticks, readable but not ultimate-sized
- freeze_shatter: cold ring plus shard burst
- ground_aoe_warning: delayed telegraph before impact
- delayed_explosion: warning pulse then burst
- ultimate_burst: larger layered effect, but target/caster must remain readable

Quality rules:
- Impact should be visible in the first 120-220ms unless it is a telegraph.
- Layer intent should be obvious: one core shape, one particle accent, optional afterglow.
- Prefer 2-4 layers for normal skills, 4-6 for ultimates.
- Avoid long noisy lifespans on mobile; clear most particles within 1.2s.
- Use bright core + colored secondary + muted shadow color instead of one flat hue.
- If revising, keep the best layer and adjust timing/quantity before rewriting everything.`;

export const AI_AUTHORING_PROMPT = `You are authoring a Phaser EffectRecipe JSON object.

Return exactly one JSON object, with no markdown inside the JSON.

Contract:
- schemaVersion: 1
- id: snake_case
- name: short display name
- durationMs: total effect duration
- loop: true for aura/ambient effects, false for one-shot impacts
- palette: 3 to 5 CSS hex colors
- emitters: Phaser particle emitters
- graphics: readable Phaser graphics primitives
- review.status: draft

Anchors:
- caster: player position
- target: enemy impact point
- midpoint: between caster and target
- path: projectile path from caster to target

Emitter fields:
- mode: burst or flow
- texture: spark, soft, glow, ring, shard, leaf, slash, mote
- blend: ADD or NORMAL
- quantity, frequency, lifespan {min,max}, speed {min,max}, angle {min,max}
- scale {start,end}, alpha {start,end}
- tint: array of CSS hex colors
- gravity {x,y}
- delayMs, durationMs

Graphics fields:
- type: ring, shockwave, beam, slash, glyph, pulse
- anchor: caster, target, midpoint, path
- color, alpha {start,end}, radius {start,end}, stroke, delayMs, durationMs

Design target:
- mobile idle RPG combat VFX
- readable at small size
- no giant screen-covering effects unless the user asks for ultimate skills
- prefer layered readable silhouettes over noisy particle spam

${GOLDEN_SAMPLE_GUIDE}`;

export const PRESET_RECIPES = [
  {
    schemaVersion: 1,
    id: 'hit_pop_small',
    name: 'Hit Pop Small',
    durationMs: 720,
    loop: false,
    palette: ['#ffffff', '#ffd66a', '#ff6b55', '#51322b'],
    emitters: [
      {
        id: 'snap_sparks',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 18,
        lifespan: { min: 180, max: 420 },
        speed: { min: 120, max: 260 },
        angle: { min: 150, max: 235 },
        scale: { start: 0.32, end: 0.02 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#ffd66a', '#ff6b55'],
        gravity: { x: 0, y: 95 },
      },
    ],
    graphics: [
      {
        id: 'tiny_impact_ring',
        type: 'ring',
        anchor: 'target',
        color: '#ffffff',
        alpha: { start: 0.92, end: 0 },
        radius: { start: 12, end: 62 },
        stroke: 5,
        durationMs: 260,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: normal hit. Good: visible within 0.12s, clears fast, one readable core. Watch: do not add lingering smoke. Fix target: if weak, raise ring stroke or spark speed before adding layers.',
    },
  },
  {
    schemaVersion: 1,
    id: 'hit_pop_crit',
    name: 'Hit Pop Crit',
    durationMs: 980,
    loop: false,
    palette: ['#ffffff', '#ffe17a', '#43e7ff', '#ff4d6d'],
    emitters: [
      {
        id: 'crit_starburst',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 38,
        lifespan: { min: 240, max: 620 },
        speed: { min: 180, max: 390 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.42, end: 0.02 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#ffe17a', '#43e7ff'],
        gravity: { x: 0, y: 140 },
      },
      {
        id: 'crit_afterglow',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'ADD',
        quantity: 2,
        frequency: 34,
        durationMs: 220,
        lifespan: { min: 360, max: 560 },
        speed: { min: 20, max: 70 },
        angle: { min: 220, max: 320 },
        scale: { start: 0.16, end: 0.54 },
        alpha: { start: 0.52, end: 0 },
        tint: ['#ff4d6d', '#ffe17a'],
        gravity: { x: 0, y: -45 },
      },
    ],
    graphics: [
      {
        id: 'crit_shock',
        type: 'shockwave',
        anchor: 'target',
        color: '#ffe17a',
        alpha: { start: 0.9, end: 0 },
        radius: { start: 20, end: 116 },
        stroke: 7,
        durationMs: 380,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: critical hit. Good: larger than normal hit but still target-local. Watch: should not become ultimate scale. Fix target: keep duration under 1s and let the first shock sell the crit.',
    },
  },
  {
    schemaVersion: 1,
    id: 'slash_arc',
    name: 'Slash Arc',
    durationMs: 820,
    loop: false,
    palette: ['#ffffff', '#43e7ff', '#ffe17a', '#263e54'],
    emitters: [
      {
        id: 'edge_sparks',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 24,
        lifespan: { min: 200, max: 520 },
        speed: { min: 140, max: 310 },
        angle: { min: 150, max: 245 },
        scale: { start: 0.34, end: 0.02 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#43e7ff', '#ffe17a'],
        gravity: { x: 0, y: 100 },
      },
    ],
    graphics: [
      {
        id: 'white_cut_edge',
        type: 'slash',
        anchor: 'target',
        color: '#ffffff',
        alpha: { start: 1, end: 0 },
        radius: { start: 72, end: 96 },
        stroke: 9,
        durationMs: 300,
      },
      {
        id: 'blue_cut_tail',
        type: 'slash',
        anchor: 'target',
        color: '#43e7ff',
        alpha: { start: 0.62, end: 0 },
        radius: { start: 58, end: 112 },
        stroke: 4,
        delayMs: 70,
        durationMs: 420,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: single weapon slash. Good: white leading edge plus colored secondary trail. Watch: avoid symmetric circular bursts; slash should have direction. Fix target: adjust slash radius/stroke before adding particles.',
    },
  },
  {
    schemaVersion: 1,
    id: 'dash_cut_trail',
    name: 'Dash Cut Trail',
    durationMs: 980,
    loop: false,
    palette: ['#ffffff', '#a78bfa', '#43e7ff', '#ff6b55'],
    emitters: [
      {
        id: 'dash_path_motes',
        mode: 'flow',
        anchor: 'path',
        texture: 'soft',
        blend: 'ADD',
        quantity: 2,
        frequency: 24,
        durationMs: 360,
        lifespan: { min: 260, max: 520 },
        speed: { min: 10, max: 58 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.18, end: 0.03 },
        alpha: { start: 0.72, end: 0 },
        tint: ['#a78bfa', '#43e7ff', '#ffffff'],
      },
      {
        id: 'dash_finish_sparks',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 22,
        lifespan: { min: 220, max: 520 },
        speed: { min: 170, max: 340 },
        angle: { min: 145, max: 230 },
        scale: { start: 0.3, end: 0.02 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#ff6b55', '#43e7ff'],
        gravity: { x: 0, y: 110 },
        delayMs: 180,
      },
    ],
    graphics: [
      {
        id: 'dash_beam_ghost',
        type: 'beam',
        anchor: 'path',
        color: '#a78bfa',
        alpha: { start: 0.62, end: 0 },
        stroke: 6,
        durationMs: 360,
      },
      {
        id: 'finish_cut',
        type: 'slash',
        anchor: 'target',
        color: '#ffffff',
        alpha: { start: 0.92, end: 0 },
        radius: { start: 66, end: 96 },
        stroke: 7,
        delayMs: 160,
        durationMs: 300,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: dash attack. Good: path layer implies movement, delayed target sparks mark arrival. Watch: beam should be a ghost trail, not a laser. Fix target: tune path duration and target delay together.',
    },
  },
  {
    schemaVersion: 1,
    id: 'projectile_trail',
    name: 'Projectile Trail',
    durationMs: 1180,
    loop: false,
    palette: ['#ffffff', '#5eead4', '#38bdf8', '#164e63'],
    emitters: [
      {
        id: 'traveling_comet_tail',
        mode: 'flow',
        anchor: 'path',
        texture: 'glow',
        blend: 'ADD',
        quantity: 3,
        frequency: 34,
        durationMs: 560,
        lifespan: { min: 420, max: 720 },
        speed: { min: 12, max: 54 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.2, end: 0.05 },
        alpha: { start: 0.72, end: 0 },
        tint: ['#5eead4', '#38bdf8', '#ffffff'],
      },
      {
        id: 'projectile_impact_splash',
        mode: 'burst',
        anchor: 'target',
        texture: 'mote',
        blend: 'ADD',
        quantity: 30,
        lifespan: { min: 300, max: 680 },
        speed: { min: 80, max: 220 },
        angle: { min: 185, max: 355 },
        scale: { start: 0.26, end: 0.02 },
        alpha: { start: 0.95, end: 0 },
        tint: ['#ffffff', '#5eead4', '#38bdf8'],
        gravity: { x: 0, y: 74 },
        delayMs: 420,
      },
    ],
    graphics: [
      {
        id: 'projectile_path_line',
        type: 'beam',
        anchor: 'path',
        color: '#5eead4',
        alpha: { start: 0.48, end: 0 },
        stroke: 4,
        durationMs: 520,
      },
      {
        id: 'impact_water_ring',
        type: 'ring',
        anchor: 'target',
        color: '#38bdf8',
        alpha: { start: 0.74, end: 0 },
        radius: { start: 18, end: 88 },
        stroke: 5,
        delayMs: 430,
        durationMs: 420,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: projectile. Good: travel trail and impact are separate in time. Watch: target impact should not fire before travel reads. Fix target: adjust target delay to match perceived projectile arrival.',
    },
  },
  {
    schemaVersion: 1,
    id: 'impact_shockwave',
    name: 'Impact Shockwave',
    durationMs: 1020,
    loop: false,
    palette: ['#ffffff', '#f97316', '#facc15', '#7c2d12'],
    emitters: [
      {
        id: 'dust_kick',
        mode: 'burst',
        anchor: 'target',
        texture: 'soft',
        blend: 'NORMAL',
        quantity: 26,
        lifespan: { min: 420, max: 860 },
        speed: { min: 65, max: 180 },
        angle: { min: 190, max: 350 },
        scale: { start: 0.2, end: 0.68 },
        alpha: { start: 0.48, end: 0 },
        tint: ['#facc15', '#f97316', '#7c2d12'],
        gravity: { x: 0, y: 96 },
      },
    ],
    graphics: [
      {
        id: 'hard_white_flash',
        type: 'pulse',
        anchor: 'target',
        color: '#ffffff',
        alpha: { start: 0.58, end: 0 },
        radius: { start: 18, end: 70 },
        stroke: 3,
        durationMs: 240,
      },
      {
        id: 'orange_shockwave',
        type: 'shockwave',
        anchor: 'target',
        color: '#f97316',
        alpha: { start: 0.82, end: 0 },
        radius: { start: 28, end: 138 },
        stroke: 7,
        delayMs: 80,
        durationMs: 520,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: heavy impact. Good: flash then expanding shockwave sells weight. Watch: dust is secondary and should not hide actors. Fix target: if muddy, reduce dust alpha/quantity first.',
    },
  },
  {
    schemaVersion: 1,
    id: 'heal_pulse',
    name: 'Heal Pulse',
    durationMs: 1500,
    loop: false,
    palette: ['#ffffff', '#86efac', '#5eead4', '#166534'],
    emitters: [
      {
        id: 'heal_motes_up',
        mode: 'flow',
        anchor: 'caster',
        texture: 'mote',
        blend: 'ADD',
        quantity: 3,
        frequency: 48,
        durationMs: 720,
        lifespan: { min: 720, max: 1180 },
        speed: { min: 20, max: 72 },
        angle: { min: 230, max: 310 },
        scale: { start: 0.18, end: 0.04 },
        alpha: { start: 0.86, end: 0 },
        tint: ['#ffffff', '#86efac', '#5eead4'],
        gravity: { x: 0, y: -90 },
      },
      {
        id: 'heal_soft_glow',
        mode: 'flow',
        anchor: 'caster',
        texture: 'soft',
        blend: 'ADD',
        quantity: 1,
        frequency: 72,
        durationMs: 620,
        lifespan: { min: 760, max: 1100 },
        speed: { min: 4, max: 24 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.18, end: 0.8 },
        alpha: { start: 0.32, end: 0 },
        tint: ['#86efac', '#5eead4'],
      },
    ],
    graphics: [
      {
        id: 'heal_ground_ring',
        type: 'ring',
        anchor: 'caster',
        color: '#86efac',
        alpha: { start: 0.52, end: 0 },
        radius: { start: 36, end: 104 },
        stroke: 4,
        durationMs: 760,
      },
      {
        id: 'heal_inner_glyph',
        type: 'glyph',
        anchor: 'caster',
        color: '#5eead4',
        alpha: { start: 0.4, end: 0.04 },
        radius: { start: 42, end: 60 },
        stroke: 2,
        delayMs: 130,
        durationMs: 980,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: heal. Good: upward motion and soft green/cyan palette feel supportive. Watch: no violent radial sparks. Fix target: if it reads as poison, increase white core and reduce dark greens.',
    },
  },
  {
    schemaVersion: 1,
    id: 'caster_aura',
    name: 'Caster Aura',
    durationMs: 2200,
    loop: true,
    palette: ['#ffffff', '#a78bfa', '#60a5fa', '#312e81'],
    emitters: [
      {
        id: 'aura_orbit_motes',
        mode: 'flow',
        anchor: 'caster',
        texture: 'mote',
        blend: 'ADD',
        quantity: 1,
        frequency: 48,
        durationMs: 1900,
        lifespan: { min: 700, max: 1180 },
        speed: { min: 30, max: 96 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.18, end: 0.04 },
        alpha: { start: 0.7, end: 0 },
        tint: ['#ffffff', '#a78bfa', '#60a5fa'],
        gravity: { x: 0, y: -20 },
      },
      {
        id: 'aura_breath_glow',
        mode: 'flow',
        anchor: 'caster',
        texture: 'glow',
        blend: 'ADD',
        quantity: 1,
        frequency: 120,
        durationMs: 1800,
        lifespan: { min: 1100, max: 1600 },
        speed: { min: 4, max: 22 },
        angle: { min: 240, max: 300 },
        scale: { start: 0.2, end: 0.82 },
        alpha: { start: 0.25, end: 0 },
        tint: ['#a78bfa', '#60a5fa'],
        gravity: { x: 0, y: -42 },
      },
    ],
    graphics: [
      {
        id: 'aura_stable_ring',
        type: 'glyph',
        anchor: 'caster',
        color: '#a78bfa',
        alpha: { start: 0.56, end: 0.24 },
        radius: { start: 54, end: 70 },
        stroke: 3,
        durationMs: 1250,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: looping aura. Good: stable silhouette, low alpha, caster remains visible. Watch: loops must not accumulate too many particles. Fix target: reduce frequency before reducing visual identity.',
    },
  },
  {
    schemaVersion: 1,
    id: 'shield_ring',
    name: 'Shield Ring',
    durationMs: 1450,
    loop: false,
    palette: ['#ffffff', '#93c5fd', '#38bdf8', '#1e3a8a'],
    emitters: [
      {
        id: 'shield_ticks',
        mode: 'burst',
        anchor: 'caster',
        texture: 'ring',
        blend: 'ADD',
        quantity: 18,
        lifespan: { min: 520, max: 880 },
        speed: { min: 36, max: 112 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.18, end: 0.04 },
        alpha: { start: 0.82, end: 0 },
        tint: ['#ffffff', '#93c5fd', '#38bdf8'],
        gravity: { x: 0, y: -18 },
      },
    ],
    graphics: [
      {
        id: 'shield_outer',
        type: 'ring',
        anchor: 'caster',
        color: '#93c5fd',
        alpha: { start: 0.78, end: 0 },
        radius: { start: 46, end: 98 },
        stroke: 6,
        durationMs: 680,
      },
      {
        id: 'shield_inner',
        type: 'glyph',
        anchor: 'caster',
        color: '#38bdf8',
        alpha: { start: 0.52, end: 0.06 },
        radius: { start: 38, end: 62 },
        stroke: 3,
        delayMs: 120,
        durationMs: 980,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: defensive shield. Good: circular protection around caster, not an attack blast. Watch: avoid target anchor unless shield is applied to enemy. Fix target: increase ring alpha/stroke if shield reads too weak.',
    },
  },
  {
    schemaVersion: 1,
    id: 'poison_cloud',
    name: 'Poison Cloud',
    durationMs: 2100,
    loop: false,
    palette: ['#d9f99d', '#84cc16', '#a3e635', '#365314'],
    emitters: [
      {
        id: 'toxic_puffs',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'NORMAL',
        quantity: 3,
        frequency: 70,
        durationMs: 1180,
        lifespan: { min: 900, max: 1600 },
        speed: { min: 12, max: 62 },
        angle: { min: 205, max: 335 },
        scale: { start: 0.22, end: 0.82 },
        alpha: { start: 0.38, end: 0 },
        tint: ['#d9f99d', '#84cc16', '#365314'],
        gravity: { x: 0, y: -62 },
      },
      {
        id: 'toxic_bits',
        mode: 'flow',
        anchor: 'target',
        texture: 'mote',
        blend: 'ADD',
        quantity: 1,
        frequency: 56,
        durationMs: 1020,
        lifespan: { min: 520, max: 920 },
        speed: { min: 20, max: 88 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.13, end: 0.02 },
        alpha: { start: 0.62, end: 0 },
        tint: ['#d9f99d', '#a3e635'],
        gravity: { x: 0, y: -30 },
      },
    ],
    graphics: [
      {
        id: 'poison_ground_stain',
        type: 'pulse',
        anchor: 'target',
        color: '#84cc16',
        alpha: { start: 0.26, end: 0 },
        radius: { start: 52, end: 122 },
        stroke: 1,
        durationMs: 1250,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: poison/debuff cloud. Good: lingering but low alpha, reads as status not hit. Watch: too much green smoke hides target. Fix target: lower alpha or duration before cutting identity.',
    },
  },
  {
    schemaVersion: 1,
    id: 'burn_tick',
    name: 'Burn Tick',
    durationMs: 1280,
    loop: false,
    palette: ['#ffffff', '#fb923c', '#ef4444', '#7f1d1d'],
    emitters: [
      {
        id: 'flame_ticks',
        mode: 'flow',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 2,
        frequency: 56,
        durationMs: 760,
        lifespan: { min: 360, max: 760 },
        speed: { min: 36, max: 120 },
        angle: { min: 230, max: 310 },
        scale: { start: 0.24, end: 0.03 },
        alpha: { start: 0.92, end: 0 },
        tint: ['#ffffff', '#fb923c', '#ef4444'],
        gravity: { x: 0, y: -96 },
      },
      {
        id: 'ember_smoke',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'NORMAL',
        quantity: 1,
        frequency: 130,
        durationMs: 760,
        lifespan: { min: 680, max: 1080 },
        speed: { min: 8, max: 34 },
        angle: { min: 240, max: 300 },
        scale: { start: 0.16, end: 0.58 },
        alpha: { start: 0.24, end: 0 },
        tint: ['#7f1d1d', '#fb923c'],
        gravity: { x: 0, y: -55 },
      },
    ],
    graphics: [
      {
        id: 'burn_tick_flash',
        type: 'ring',
        anchor: 'target',
        color: '#fb923c',
        alpha: { start: 0.56, end: 0 },
        radius: { start: 18, end: 58 },
        stroke: 3,
        durationMs: 320,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: damage-over-time fire tick. Good: small, vertical, repeated-feeling without becoming a fireball. Watch: do not make it an explosion. Fix target: tune flame duration and upward gravity.',
    },
  },
  {
    schemaVersion: 1,
    id: 'freeze_shatter',
    name: 'Freeze Shatter',
    durationMs: 1160,
    loop: false,
    palette: ['#ffffff', '#bae6fd', '#38bdf8', '#1e3a8a'],
    emitters: [
      {
        id: 'ice_shards',
        mode: 'burst',
        anchor: 'target',
        texture: 'shard',
        blend: 'ADD',
        quantity: 34,
        lifespan: { min: 320, max: 760 },
        speed: { min: 95, max: 260 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.32, end: 0.02 },
        alpha: { start: 0.92, end: 0 },
        tint: ['#ffffff', '#bae6fd', '#38bdf8'],
        gravity: { x: 0, y: 90 },
        delayMs: 120,
      },
      {
        id: 'cold_mist',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'ADD',
        quantity: 2,
        frequency: 70,
        durationMs: 520,
        lifespan: { min: 640, max: 1080 },
        speed: { min: 16, max: 54 },
        angle: { min: 210, max: 330 },
        scale: { start: 0.18, end: 0.68 },
        alpha: { start: 0.32, end: 0 },
        tint: ['#bae6fd', '#38bdf8'],
        gravity: { x: 0, y: -40 },
      },
    ],
    graphics: [
      {
        id: 'freeze_lock_ring',
        type: 'glyph',
        anchor: 'target',
        color: '#bae6fd',
        alpha: { start: 0.62, end: 0.08 },
        radius: { start: 48, end: 58 },
        stroke: 3,
        durationMs: 520,
      },
      {
        id: 'shatter_ring',
        type: 'shockwave',
        anchor: 'target',
        color: '#38bdf8',
        alpha: { start: 0.76, end: 0 },
        radius: { start: 32, end: 112 },
        stroke: 5,
        delayMs: 130,
        durationMs: 460,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: freeze then shatter. Good: brief lock shape before shards. Watch: if all layers fire at once, it reads generic blue hit. Fix target: preserve 100-160ms delay between freeze and shatter.',
    },
  },
  {
    schemaVersion: 1,
    id: 'ground_aoe_warning',
    name: 'Ground AoE Warning',
    durationMs: 1900,
    loop: false,
    palette: ['#ffffff', '#facc15', '#f97316', '#7c2d12'],
    emitters: [
      {
        id: 'warning_runes',
        mode: 'flow',
        anchor: 'target',
        texture: 'ring',
        blend: 'ADD',
        quantity: 1,
        frequency: 82,
        durationMs: 950,
        lifespan: { min: 560, max: 920 },
        speed: { min: 18, max: 70 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.12, end: 0.04 },
        alpha: { start: 0.72, end: 0 },
        tint: ['#ffffff', '#facc15'],
      },
    ],
    graphics: [
      {
        id: 'warning_circle',
        type: 'glyph',
        anchor: 'target',
        color: '#facc15',
        alpha: { start: 0.52, end: 0.18 },
        radius: { start: 74, end: 90 },
        stroke: 4,
        durationMs: 950,
      },
      {
        id: 'impact_after_warning',
        type: 'shockwave',
        anchor: 'target',
        color: '#f97316',
        alpha: { start: 0.9, end: 0 },
        radius: { start: 36, end: 148 },
        stroke: 8,
        delayMs: 900,
        durationMs: 520,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: telegraphed AoE. Good: readable warning first, impact later. Watch: do not make warning too subtle. Fix target: if unfair, increase warning duration/alpha; if sluggish, reduce post-warning delay.',
    },
  },
  {
    schemaVersion: 1,
    id: 'delayed_explosion',
    name: 'Delayed Explosion',
    durationMs: 1680,
    loop: false,
    palette: ['#ffffff', '#fb923c', '#facc15', '#991b1b'],
    emitters: [
      {
        id: 'charge_heat',
        mode: 'flow',
        anchor: 'target',
        texture: 'glow',
        blend: 'ADD',
        quantity: 2,
        frequency: 72,
        durationMs: 620,
        lifespan: { min: 440, max: 760 },
        speed: { min: 8, max: 42 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.18, end: 0.46 },
        alpha: { start: 0.38, end: 0 },
        tint: ['#facc15', '#fb923c'],
      },
      {
        id: 'explosion_burst',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 52,
        lifespan: { min: 360, max: 840 },
        speed: { min: 160, max: 420 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.42, end: 0.03 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#facc15', '#fb923c'],
        gravity: { x: 0, y: 130 },
        delayMs: 650,
      },
      {
        id: 'explosion_smoke',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'NORMAL',
        quantity: 3,
        frequency: 80,
        durationMs: 520,
        lifespan: { min: 780, max: 1280 },
        speed: { min: 24, max: 100 },
        angle: { min: 200, max: 340 },
        scale: { start: 0.22, end: 0.84 },
        alpha: { start: 0.3, end: 0 },
        tint: ['#991b1b', '#fb923c', '#facc15'],
        gravity: { x: 0, y: -42 },
        delayMs: 700,
      },
    ],
    graphics: [
      {
        id: 'charge_warning',
        type: 'pulse',
        anchor: 'target',
        color: '#facc15',
        alpha: { start: 0.34, end: 0.08 },
        radius: { start: 36, end: 82 },
        stroke: 2,
        durationMs: 620,
      },
      {
        id: 'blast_ring',
        type: 'shockwave',
        anchor: 'target',
        color: '#fb923c',
        alpha: { start: 0.92, end: 0 },
        radius: { start: 30, end: 160 },
        stroke: 8,
        delayMs: 660,
        durationMs: 560,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: delayed explosion. Good: charge communicates delay, burst lands after. Watch: smoke is allowed only after impact. Fix target: keep charge and burst clearly separated in time.',
    },
  },
  {
    schemaVersion: 1,
    id: 'ultimate_burst',
    name: 'Ultimate Burst',
    durationMs: 2400,
    loop: false,
    palette: ['#ffffff', '#f0abfc', '#38bdf8', '#facc15', '#581c87'],
    emitters: [
      {
        id: 'ultimate_charge',
        mode: 'flow',
        anchor: 'midpoint',
        texture: 'glow',
        blend: 'ADD',
        quantity: 2,
        frequency: 60,
        durationMs: 620,
        lifespan: { min: 560, max: 880 },
        speed: { min: 16, max: 62 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.16, end: 0.76 },
        alpha: { start: 0.42, end: 0 },
        tint: ['#f0abfc', '#38bdf8'],
      },
      {
        id: 'ultimate_star_burst',
        mode: 'burst',
        anchor: 'target',
        texture: 'spark',
        blend: 'ADD',
        quantity: 72,
        lifespan: { min: 420, max: 1120 },
        speed: { min: 140, max: 460 },
        angle: { min: 0, max: 360 },
        scale: { start: 0.44, end: 0.03 },
        alpha: { start: 1, end: 0 },
        tint: ['#ffffff', '#f0abfc', '#38bdf8', '#facc15'],
        gravity: { x: 0, y: 85 },
        delayMs: 540,
      },
      {
        id: 'ultimate_afterglow',
        mode: 'flow',
        anchor: 'target',
        texture: 'soft',
        blend: 'ADD',
        quantity: 2,
        frequency: 70,
        durationMs: 920,
        lifespan: { min: 760, max: 1350 },
        speed: { min: 14, max: 72 },
        angle: { min: 210, max: 330 },
        scale: { start: 0.18, end: 0.9 },
        alpha: { start: 0.36, end: 0 },
        tint: ['#f0abfc', '#38bdf8'],
        gravity: { x: 0, y: -68 },
        delayMs: 640,
      },
    ],
    graphics: [
      {
        id: 'ultimate_charge_glyph',
        type: 'glyph',
        anchor: 'midpoint',
        color: '#f0abfc',
        alpha: { start: 0.62, end: 0.12 },
        radius: { start: 56, end: 92 },
        stroke: 4,
        durationMs: 620,
      },
      {
        id: 'ultimate_beam_snap',
        type: 'beam',
        anchor: 'path',
        color: '#38bdf8',
        alpha: { start: 0.74, end: 0 },
        stroke: 8,
        delayMs: 420,
        durationMs: 420,
      },
      {
        id: 'ultimate_target_wave',
        type: 'shockwave',
        anchor: 'target',
        color: '#facc15',
        alpha: { start: 0.86, end: 0 },
        radius: { start: 42, end: 190 },
        stroke: 9,
        delayMs: 560,
        durationMs: 740,
      },
    ],
    review: {
      status: 'draft',
      notes: 'GOLDEN: ultimate. Good: layered charge, beam snap, target burst. Watch: even an ultimate should leave actor silhouettes readable. Fix target: reduce afterglow alpha/scale before lowering the decisive burst.',
    },
  },
];

// Legacy names kept for people who may have copied early lab exports.
PRESET_RECIPES.push(
  {
    ...cloneRecipe(PRESET_RECIPES[0]),
    id: 'spore_bloom',
    name: 'Spore Bloom',
    palette: ['#8be36d', '#f7d66a', '#f8fff0', '#386e2d'],
    review: {
      status: 'draft',
      notes: 'LEGACY SAMPLE: readable mushroomer hit pop. Prefer hit_pop_small as the canonical normal-hit reference.',
    },
  },
  {
    ...cloneRecipe(PRESET_RECIPES[2]),
    id: 'kunai_moon_cut',
    name: 'Kunai Moon Cut',
    review: {
      status: 'draft',
      notes: 'LEGACY SAMPLE: fast directional slash with path motes. Prefer slash_arc or dash_cut_trail as canonical references.',
    },
  },
  {
    ...cloneRecipe(PRESET_RECIPES[7]),
    id: 'ember_orbit_aura',
    name: 'Ember Orbit Aura',
    palette: ['#ff9a3c', '#ffd66a', '#ffffff', '#8b2c1d'],
    review: {
      status: 'draft',
      notes: 'LEGACY SAMPLE: looping buff aura candidate. Prefer caster_aura as the canonical looping aura reference.',
    },
  },
);

PRESET_RECIPES.push(...NINJA2_SKILL_EFFECT_RECIPES);

export function cloneRecipe(recipe) {
  return JSON.parse(JSON.stringify(recipe));
}

export function normalizeRecipe(input) {
  const recipe = cloneRecipe(input || PRESET_RECIPES[0]);
  recipe.schemaVersion = Number(recipe.schemaVersion || 1);
  recipe.id = String(recipe.id || 'unnamed_effect').replace(/[^a-z0-9_]+/gi, '_').toLowerCase();
  recipe.name = String(recipe.name || recipe.id);
  recipe.durationMs = clampNumber(recipe.durationMs, 300, 8000, 1200);
  recipe.loop = Boolean(recipe.loop);
  recipe.palette = Array.isArray(recipe.palette) && recipe.palette.length ? recipe.palette : ['#ffffff', '#7dd3fc', '#fbbf24'];
  recipe.emitters = Array.isArray(recipe.emitters) ? recipe.emitters : [];
  recipe.graphics = Array.isArray(recipe.graphics) ? recipe.graphics : [];
  recipe.review = recipe.review && typeof recipe.review === 'object' ? recipe.review : {};
  recipe.review.status = recipe.review.status || 'draft';
  recipe.review.notes = recipe.review.notes || '';
  return recipe;
}

export function formatRecipe(recipe) {
  return JSON.stringify(normalizeRecipe(recipe), null, 2);
}

export function parseRecipeText(text) {
  const parsed = JSON.parse(text);
  return normalizeRecipe(parsed);
}

function clampNumber(value, min, max, fallback) {
  const number = Number(value);
  if (!Number.isFinite(number)) return fallback;
  return Math.max(min, Math.min(max, number));
}
