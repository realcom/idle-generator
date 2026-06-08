const PhaserScene = globalThis.Phaser?.Scene ?? class {};

const TEXTURE_SIZE = 96;
const STAGE_WIDTH = 800;
const STAGE_HEIGHT = 520;
const ANCHORS = Object.freeze({
  caster: { x: 230, y: 344 },
  target: { x: 585, y: 310 },
  midpoint: { x: 408, y: 326 },
});
const DEFAULT_CONTROLS = Object.freeze({
  intensity: 1,
  scale: 1,
  speed: 1,
  background: 'dark',
  mode: 'loop',
});

export class FxLabScene extends PhaserScene {
  constructor() {
    super('FxLabScene');
    this.recipe = null;
    this.controls = { ...DEFAULT_CONTROLS };
    this.fxObjects = [];
    this.fxTimers = [];
    this.fxTweens = [];
    this.replayCount = 0;
    this.stageBackground = null;
    this.statusText = null;
  }

  create() {
    this.cameras.main.setBackgroundColor('#07090d');
    this.#createTextures();
    this.#createStage();
    globalThis.dispatchEvent(new CustomEvent('phaser-fx-lab-ready', { detail: { scene: this } }));
  }

  playRecipe(recipe, controls = {}) {
    this.recipe = recipe;
    this.controls = this.#normalizeControls(controls);
    this.replayCount += 1;
    this.#clearFx();
    this.#paintStage(this.controls.background);
    this.#setStatusText(recipe);
    this.#drawInspectionGuides(recipe);
    this.#drawSustainedPreview(recipe);
    this.#drawImpactFlash(recipe);

    for (const graphic of recipe.graphics || []) {
      this.#schedule(graphic.delayMs || 0, () => this.#drawGraphic(graphic));
    }

    for (const emitter of recipe.emitters || []) {
      this.#schedule(emitter.delayMs || 0, () => this.#spawnEmitter(emitter, recipe));
    }

    if (this.controls.mode === 'loop') {
      const loopDelay = Math.max(480, this.#scaledDuration(recipe.durationMs || 1400) + 180);
      const timer = this.time.delayedCall(loopDelay, () => this.playRecipe(recipe, this.controls));
      this.fxTimers.push(timer);
    }
  }

  getMetrics() {
    const liveParticles = this.fxObjects.reduce((total, object) => {
      if (object?.getAliveParticleCount) return total + object.getAliveParticleCount();
      return total;
    }, 0);
    return {
      replayCount: this.replayCount,
      fxObjects: this.fxObjects.length,
      liveParticles,
      canvasWidth: this.scale.width,
      canvasHeight: this.scale.height,
      controls: { ...this.controls },
    };
  }

  #createStage() {
    this.stageBackground = this.add.graphics().setDepth(0);
    this.#paintStage(DEFAULT_CONTROLS.background);

    this.#drawActor(ANCHORS.caster.x, ANCHORS.caster.y, {
      body: 0x4b9360,
      accent: 0xffd66a,
      label: 'CASTER',
      flip: false,
    });
    this.#drawActor(ANCHORS.target.x, ANCHORS.target.y, {
      body: 0x6d4fba,
      accent: 0xff8b64,
      label: 'TARGET',
      flip: true,
    });

    this.statusText = this.add.text(18, 16, '', {
      color: '#f8fff0',
      fontFamily: 'system-ui, sans-serif',
      fontSize: '13px',
      fontStyle: '700',
      stroke: '#07090d',
      strokeThickness: 4,
    }).setDepth(110);
  }

  #paintStage(mode) {
    const g = this.stageBackground;
    if (!g) return;
    g.clear();

    if (mode === 'alpha') {
      this.cameras.main.setBackgroundColor('#11151b');
      g.fillStyle(0x141923, 1);
      g.fillRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
      for (let y = 0; y < STAGE_HEIGHT; y += 32) {
        for (let x = 0; x < STAGE_WIDTH; x += 32) {
          g.fillStyle((x + y) % 64 === 0 ? 0x2c3340 : 0x202733, 1);
          g.fillRect(x, y, 32, 32);
        }
      }
      g.fillStyle(0x000000, 0.22);
      g.fillEllipse(408, 360, 640, 118);
      this.#drawStageGrid(g, 0xffffff, 0.08);
      return;
    }

    if (mode === 'arena') {
      this.cameras.main.setBackgroundColor('#17201b');
      g.fillGradientStyle(0x2f8fb7, 0x2f8fb7, 0x85c66d, 0x6fac58, 1);
      g.fillRect(0, 0, STAGE_WIDTH, 250);
      g.fillGradientStyle(0x6fac58, 0x6fac58, 0x243d24, 0x17281a, 1);
      g.fillRect(0, 250, STAGE_WIDTH, STAGE_HEIGHT - 250);
      g.fillStyle(0xf0d27a, 0.88);
      g.fillEllipse(410, 350, 640, 120);
      this.#drawStageGrid(g, 0x24421f, 0.32);
      return;
    }

    this.cameras.main.setBackgroundColor('#07090d');
    g.fillGradientStyle(0x0b1018, 0x0f1420, 0x171b23, 0x080a0e, 1);
    g.fillRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
    g.fillStyle(0x1b232c, 0.96);
    g.fillEllipse(410, 352, 660, 126);
    g.fillStyle(0x324051, 0.32);
    g.fillEllipse(410, 344, 520, 84);
    g.lineStyle(1, 0x81d7ff, 0.09);
    for (let x = 72; x <= 728; x += 82) {
      g.lineBetween(x, 286, x - 56, 426);
    }
    g.lineStyle(1, 0xffd66a, 0.08);
    for (let y = 292; y <= 418; y += 24) {
      g.lineBetween(104, y, 700, y + 8);
    }
  }

  #drawStageGrid(g, color, alpha) {
    g.lineStyle(2, color, alpha);
    for (let i = 0; i < 8; i += 1) {
      g.beginPath();
      g.moveTo(90 + i * 88, 300);
      g.lineTo(40 + i * 94, 432);
      g.strokePath();
    }
  }

  #drawActor(x, y, { body, accent, label, flip }) {
    const actor = this.add.container(x, y).setDepth(40);
    const shadow = this.add.ellipse(0, 42, 100, 28, 0x000000, 0.28);
    const torso = this.add.ellipse(0, 0, 56, 88, body, 1);
    const rim = this.add.ellipse(0, 0, 62, 94).setStrokeStyle(3, 0xffffff, 0.12);
    const head = this.add.circle(flip ? -8 : 8, -56, 28, 0xf3d0a5, 1);
    const mark = this.add.rectangle(flip ? -22 : 22, -62, 18, 6, accent, 1);
    const weapon = this.add.rectangle(flip ? 44 : -44, -12, 14, 82, accent, 1)
      .setRotation((flip ? -1 : 1) * 0.54);
    const name = this.add.text(0, 72, label, {
      color: '#ffffff',
      fontFamily: 'system-ui, sans-serif',
      fontSize: '11px',
      fontStyle: '800',
      stroke: '#1c1713',
      strokeThickness: 3,
    }).setOrigin(0.5);
    actor.add([shadow, rim, torso, head, mark, weapon, name]);
  }

  #setStatusText(recipe) {
    const intensity = Math.round(this.#intensity() * 100);
    this.statusText.setText(`${recipe.name}  #${recipe.id}  ${intensity}%`);
  }

  #clearFx() {
    for (const timer of this.fxTimers) timer?.remove?.(false);
    this.fxTimers = [];
    for (const tween of this.fxTweens) tween?.stop?.();
    this.fxTweens = [];
    for (const object of this.fxObjects) {
      this.tweens.killTweensOf?.(object);
      object?.destroy?.();
    }
    this.fxObjects = [];
  }

  #schedule(delayMs, callback) {
    const scaledDelay = this.#scaledDuration(delayMs);
    if (scaledDelay <= 0) {
      callback();
      return;
    }
    const timer = this.time.delayedCall(scaledDelay, callback);
    this.fxTimers.push(timer);
  }

  #drawInspectionGuides(recipe) {
    const anchors = new Set();
    for (const def of [...(recipe.emitters || []), ...(recipe.graphics || [])]) {
      anchors.add(def.anchor || 'target');
    }
    if (!anchors.size) anchors.add('target');

    const g = this.add.graphics().setDepth(34);
    const primary = this.#paletteColor(recipe, 0);
    const secondary = this.#paletteColor(recipe, 1);

    if (anchors.has('path') || [...(recipe.graphics || [])].some(def => def.type === 'beam')) {
      g.lineStyle(3, secondary, 0.24);
      g.beginPath();
      g.moveTo(ANCHORS.caster.x + 18, ANCHORS.caster.y - 38);
      g.lineTo(ANCHORS.midpoint.x, ANCHORS.midpoint.y - 86);
      g.lineTo(ANCHORS.target.x - 18, ANCHORS.target.y - 36);
      g.strokePath();
    }

    for (const anchor of anchors) {
      const resolved = anchor === 'path' ? 'midpoint' : anchor;
      this.#drawGuideMarker(g, this.#resolveAnchor(resolved), primary);
    }
    this.fxObjects.push(g);
  }

  #drawGuideMarker(g, point, color) {
    const radius = 26 * this.#scaleFactor();
    g.fillStyle(color, 0.14);
    g.fillCircle(point.x, point.y, radius);
    g.lineStyle(2, color, 0.42);
    g.strokeCircle(point.x, point.y, radius);
    g.lineStyle(1, 0xffffff, 0.28);
    g.strokeCircle(point.x, point.y, radius * 0.58);
  }

  #drawSustainedPreview(recipe) {
    const g = this.add.graphics().setDepth(84);
    const palette = Array.isArray(recipe.palette) && recipe.palette.length ? recipe.palette : ['#ffffff'];
    const intensity = this.#intensity();
    const scale = this.#scaleFactor();

    for (const graphic of recipe.graphics || []) {
      const point = this.#resolveAnchor(graphic.anchor);
      const color = this.#colorInt(graphic.color || palette[0]);
      const startRadius = Number(graphic.radius?.start ?? 28) * scale;
      const endRadius = Number(graphic.radius?.end ?? 92) * scale;
      const radius = (startRadius + endRadius) * 0.5;
      const stroke = Math.max(3, Number(graphic.stroke || 3) * (1.35 + (scale - 1) * 0.3));
      const alpha = clamp01(Number(graphic.alpha?.start ?? 0.78)) * 0.48;

      if (graphic.type === 'beam') this.#drawBeam(g, color, stroke, alpha);
      else if (graphic.type === 'slash') this.#drawSlash(g, point, color, stroke, alpha, radius);
      else if (graphic.type === 'glyph') this.#drawGlyph(g, point, color, stroke, alpha, radius, 0.25);
      else if (graphic.type === 'shockwave') this.#drawShockwave(g, point, color, stroke, alpha, radius);
      else this.#drawRing(g, point, color, stroke, alpha, radius, graphic.type === 'pulse');
    }

    for (const emitter of recipe.emitters || []) {
      const point = this.#resolveAnchor(emitter.anchor);
      const colors = Array.isArray(emitter.tint) && emitter.tint.length ? emitter.tint : palette;
      const count = Math.min(46, Math.max(10, Math.round(Number(emitter.quantity || 8) * intensity * 1.35)));
      const plume = Number(emitter.gravity?.y || 0) < 0;
      const path = emitter.anchor === 'path';

      for (let i = 0; i < count; i += 1) {
        const color = this.#colorInt(colors[i % colors.length]);
        let x = point.x;
        let y = point.y;
        if (path) {
          const t = count <= 1 ? 0 : i / (count - 1);
          x = ANCHORS.caster.x + (ANCHORS.target.x - ANCHORS.caster.x) * t;
          y = ANCHORS.caster.y - 42 + (ANCHORS.target.y - 34 - (ANCHORS.caster.y - 42)) * t - Math.sin(t * Math.PI) * 58;
        } else {
          const angle = i * 2.399963229728653;
          const radius = (18 + (i % 9) * 8 + Math.floor(i / 9) * 5) * scale;
          x += Math.cos(angle) * radius * (plume ? 0.68 : 1);
          y += Math.sin(angle) * radius * (plume ? 0.46 : 0.72);
          if (plume) y -= (i % 7) * 9 * scale;
        }
        g.fillStyle(color, 0.34);
        g.fillCircle(x, y, (4.5 + (i % 4) * 1.5) * scale);
        g.fillStyle(0xffffff, 0.12);
        g.fillCircle(x - 1.5 * scale, y - 1.5 * scale, (2.2 + (i % 2)) * scale);
      }
    }

    this.fxObjects.push(g);
    const tween = this.tweens.add({
      targets: g,
      alpha: { from: 0.78, to: 1 },
      duration: Math.max(260, this.#scaledDuration(620)),
      yoyo: true,
      repeat: -1,
      ease: 'Sine.easeInOut',
    });
    this.fxTweens.push(tween);
  }

  #drawImpactFlash(recipe) {
    const anchor = this.#primaryAnchor(recipe);
    const point = this.#resolveAnchor(anchor === 'path' ? 'midpoint' : anchor);
    const color = this.#paletteColor(recipe, 0);
    const accent = this.#paletteColor(recipe, 1);
    const g = this.add.graphics().setDepth(90);
    const maxRadius = 58 * this.#scaleFactor();
    this.fxObjects.push(g);

    const tween = this.tweens.addCounter({
      from: 0,
      to: 1,
      duration: Math.max(160, this.#scaledDuration(420)),
      ease: 'Cubic.easeOut',
      onUpdate: counter => {
        const t = counter.getValue();
        const alpha = 1 - t;
        const radius = 14 + maxRadius * t;
        g.clear();
        g.fillStyle(0xffffff, alpha * 0.16);
        g.fillCircle(point.x, point.y, radius * 0.52);
        g.lineStyle(10 * this.#scaleFactor(), 0xffffff, alpha * 0.15);
        g.strokeCircle(point.x, point.y, radius * 0.72);
        g.lineStyle(5 * this.#scaleFactor(), color, alpha * 0.75);
        g.strokeCircle(point.x, point.y, radius);
        g.lineStyle(2 * this.#scaleFactor(), accent, alpha * 0.9);
        g.strokeCircle(point.x, point.y, radius * 1.28);
      },
      onComplete: () => g.destroy(),
    });
    this.fxTweens.push(tween);
  }

  #spawnEmitter(def, recipe) {
    const point = this.#resolveAnchor(def.anchor);
    const texture = this.#textureKey(def.texture || 'soft');
    const config = this.#emitterConfig(def, recipe);
    let emitter = null;

    try {
      emitter = this.add.particles(point.x, point.y, texture, config);
    } catch (error) {
      console.warn('[FxLab] Phaser particles failed, drawing fallback burst.', error);
      this.#fallbackBurst(point, def, recipe);
      return;
    }

    emitter.setDepth?.(92);
    if (String(def.blend || '').toUpperCase() === 'ADD') {
      emitter.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
    }

    if (def.anchor === 'path') this.#animateAlongPath(emitter, def.durationMs || 520);

    if (def.mode === 'burst') {
      const burstQuantity = Math.max(1, Math.round(Number(def.quantity || 16) * this.#intensity()));
      if (emitter.explode) emitter.explode(burstQuantity, point.x, point.y);
      else if (emitter.emitParticleAt) emitter.emitParticleAt(point.x, point.y, burstQuantity);
      emitter.stop?.();
    }

    const destroyAfter = Math.max(config.duration || 0, config.lifespan?.max || 900, 320) + 260;
    const timer = this.time.delayedCall(destroyAfter, () => emitter.destroy?.());
    this.fxTimers.push(timer);
    this.fxObjects.push(emitter);
  }

  #emitterConfig(def, recipe) {
    const isBurst = def.mode === 'burst';
    const intensity = this.#intensity();
    const speed = this.#speedFactor();
    const quantity = Math.max(1, Math.round(Number(def.quantity || 1) * intensity));
    const frequency = isBurst ? -1 : Math.max(8, Math.round(Number(def.frequency || 70) / Math.max(0.35, intensity * speed)));

    return {
      lifespan: this.#rangeOp(def.lifespan, 520, 900, 1 / speed),
      speed: this.#rangeOp(def.speed, 60, 180, speed),
      angle: this.#rangeOp(def.angle, 0, 360),
      scale: this.#startEnd(def.scale, 0.36, 0.04, this.#scaleFactor() * 1.18),
      alpha: this.#alphaStartEnd(def.alpha),
      tint: this.#tints(def.tint || recipe.palette),
      gravityX: Number(def.gravity?.x || 0) * speed,
      gravityY: Number(def.gravity?.y || 0) * Math.max(0.7, speed),
      quantity,
      frequency,
      duration: Math.max(90, Math.round(this.#scaledDuration(def.durationMs || recipe.durationMs || 900))),
      rotate: { min: -220, max: 220 },
      emitting: !isBurst,
    };
  }

  #drawGraphic(def) {
    const point = this.#resolveAnchor(def.anchor);
    const g = this.add.graphics().setDepth(86);
    const color = this.#colorInt(def.color || '#ffffff');
    const stroke = Math.max(2, Number(def.stroke || 3) * (1.2 + (this.#scaleFactor() - 1) * 0.35));
    const duration = Math.max(120, this.#scaledDuration(def.durationMs || 420));
    const startAlpha = Math.min(1, Number(def.alpha?.start ?? 0.85) * (1 + (this.#intensity() - 1) * 0.12));
    const endAlpha = clamp01(Number(def.alpha?.end ?? 0));
    const startRadius = Number(def.radius?.start ?? 20) * this.#scaleFactor();
    const endRadius = Number(def.radius?.end ?? 90) * this.#scaleFactor();

    if (def.type === 'beam') {
      this.#drawBeam(g, color, stroke, startAlpha);
    } else if (def.type === 'slash') {
      this.#drawSlash(g, point, color, stroke, startAlpha, startRadius);
    } else if (def.type === 'glyph') {
      this.#drawGlyph(g, point, color, stroke, startAlpha, startRadius);
    } else if (def.type === 'shockwave') {
      this.#drawShockwave(g, point, color, stroke, startAlpha, startRadius);
    } else {
      this.#drawRing(g, point, color, stroke, startAlpha, startRadius, def.type === 'pulse');
    }

    this.fxObjects.push(g);
    const tween = this.tweens.addCounter({
      from: 0,
      to: 1,
      duration,
      ease: 'Cubic.easeOut',
      onUpdate: counter => {
        const t = counter.getValue();
        g.clear();
        const radius = startRadius + (endRadius - startRadius) * t;
        const alpha = startAlpha + (endAlpha - startAlpha) * t;
        if (def.type === 'beam') this.#drawBeam(g, color, stroke * (1 - t * 0.35), alpha);
        else if (def.type === 'slash') this.#drawSlash(g, point, color, stroke * (1 - t * 0.26), alpha, radius);
        else if (def.type === 'glyph') this.#drawGlyph(g, point, color, stroke, alpha, radius, t);
        else if (def.type === 'shockwave') this.#drawShockwave(g, point, color, stroke, alpha, radius);
        else this.#drawRing(g, point, color, stroke, alpha, radius, def.type === 'pulse');
      },
      onComplete: () => g.destroy(),
    });
    this.fxTweens.push(tween);
  }

  #drawRing(g, point, color, stroke, alpha, radius, fill = false) {
    if (fill) {
      g.fillStyle(color, alpha * 0.3);
      g.fillEllipse(point.x, point.y + 8, radius * 1.64, radius * 0.68);
    }
    g.lineStyle(stroke + 4, 0xffffff, alpha * 0.16);
    g.strokeEllipse(point.x, point.y + 8, radius * 1.7, radius * 0.7);
    g.lineStyle(stroke, color, alpha);
    g.strokeEllipse(point.x, point.y + 8, radius * 1.55, radius * 0.64);
  }

  #drawShockwave(g, point, color, stroke, alpha, radius) {
    g.fillStyle(color, alpha * 0.08);
    g.fillCircle(point.x, point.y, radius * 0.86);
    g.lineStyle(stroke + 7, 0xffffff, alpha * 0.18);
    g.strokeCircle(point.x, point.y, radius);
    g.lineStyle(stroke, color, alpha);
    g.strokeCircle(point.x, point.y, radius * 0.9);
  }

  #drawSlash(g, point, color, stroke, alpha, radius) {
    g.lineStyle(stroke + 9, 0xffffff, alpha * 0.24);
    g.beginPath();
    g.arc(point.x, point.y, radius, -2.45, -0.35, false);
    g.strokePath();
    g.lineStyle(stroke, color, alpha);
    g.beginPath();
    g.arc(point.x, point.y, radius, -2.42, -0.38, false);
    g.strokePath();
    g.lineStyle(Math.max(2, stroke * 0.36), 0xffffff, alpha * 0.82);
    g.beginPath();
    g.arc(point.x, point.y, radius * 0.86, -2.26, -0.52, false);
    g.strokePath();
  }

  #drawGlyph(g, point, color, stroke, alpha, radius, t = 0) {
    g.fillStyle(color, alpha * 0.06);
    g.fillCircle(point.x, point.y, radius);
    g.lineStyle(stroke + 3, 0xffffff, alpha * 0.12);
    g.strokeCircle(point.x, point.y, radius * 1.04);
    g.lineStyle(stroke, color, alpha);
    g.strokeCircle(point.x, point.y, radius);
    for (let i = 0; i < 6; i += 1) {
      const angle = (Math.PI * 2 * i) / 6 + t * Math.PI;
      const x1 = point.x + Math.cos(angle) * (radius * 0.42);
      const y1 = point.y + Math.sin(angle) * (radius * 0.42);
      const x2 = point.x + Math.cos(angle) * radius;
      const y2 = point.y + Math.sin(angle) * radius;
      g.lineBetween(x1, y1, x2, y2);
    }
  }

  #drawBeam(g, color, stroke, alpha) {
    const from = ANCHORS.caster;
    const to = ANCHORS.target;
    const midX = (from.x + to.x) / 2;
    const midY = (from.y + to.y) / 2 - 58;
    g.lineStyle(stroke + 13, 0xffffff, alpha * 0.16);
    g.beginPath();
    g.moveTo(from.x + 18, from.y - 36);
    g.lineTo(midX, midY);
    g.lineTo(to.x - 18, to.y - 30);
    g.strokePath();
    g.lineStyle(stroke + 5, color, alpha * 0.34);
    g.beginPath();
    g.moveTo(from.x + 18, from.y - 36);
    g.lineTo(midX, midY);
    g.lineTo(to.x - 18, to.y - 30);
    g.strokePath();
    g.lineStyle(stroke, color, alpha);
    g.beginPath();
    g.moveTo(from.x + 18, from.y - 36);
    g.lineTo(midX, midY);
    g.lineTo(to.x - 18, to.y - 30);
    g.strokePath();
  }

  #fallbackBurst(point, def, recipe) {
    const total = Math.max(8, Math.round(Number(def.quantity || 16) * this.#intensity()));
    const colors = def.tint || recipe.palette || ['#ffffff'];
    for (let i = 0; i < total; i += 1) {
      const angle = (Math.PI * 2 * i) / total;
      const distance = (32 + Math.random() * 92) * this.#scaleFactor();
      const dot = this.add.circle(
        point.x,
        point.y,
        (4 + Math.random() * 6) * this.#scaleFactor(),
        this.#colorInt(colors[i % colors.length]),
        0.96,
      ).setDepth(94);
      this.fxObjects.push(dot);
      const tween = this.tweens.add({
        targets: dot,
        x: point.x + Math.cos(angle) * distance,
        y: point.y + Math.sin(angle) * distance,
        alpha: 0,
        scale: 0.2,
        duration: Math.max(180, this.#scaledDuration(def.lifespan?.max || 700)),
        ease: 'Cubic.easeOut',
        onComplete: () => dot.destroy(),
      });
      this.fxTweens.push(tween);
    }
  }

  #animateAlongPath(object, duration) {
    object.setPosition?.(ANCHORS.caster.x, ANCHORS.caster.y - 38);
    const tween = this.tweens.add({
      targets: object,
      x: ANCHORS.target.x - 12,
      y: ANCHORS.target.y - 28,
      duration: Math.max(160, this.#scaledDuration(duration)),
      ease: 'Cubic.easeOut',
    });
    this.fxTweens.push(tween);
  }

  #primaryAnchor(recipe) {
    const graphicAnchor = recipe.graphics?.find(def => def.anchor)?.anchor;
    const emitterAnchor = recipe.emitters?.find(def => def.anchor)?.anchor;
    return graphicAnchor || emitterAnchor || 'target';
  }

  #resolveAnchor(anchor) {
    if (anchor === 'caster') return { ...ANCHORS.caster, y: ANCHORS.caster.y - 42 };
    if (anchor === 'midpoint') return { ...ANCHORS.midpoint, y: ANCHORS.midpoint.y - 36 };
    if (anchor === 'path') return { ...ANCHORS.caster, y: ANCHORS.caster.y - 38 };
    return { ...ANCHORS.target, y: ANCHORS.target.y - 36 };
  }

  #rangeOp(value, fallbackMin, fallbackMax, multiplier = 1) {
    const min = Math.max(0, Number(value?.min ?? fallbackMin) * multiplier);
    const max = Math.max(0, Number(value?.max ?? fallbackMax) * multiplier);
    return {
      min: Math.round(Math.min(min, max)),
      max: Math.round(Math.max(min, max)),
    };
  }

  #startEnd(value, fallbackStart, fallbackEnd, multiplier = 1) {
    return {
      start: Math.max(0, Number(value?.start ?? fallbackStart) * multiplier),
      end: Math.max(0, Number(value?.end ?? fallbackEnd) * multiplier),
      ease: 'Cubic.easeOut',
    };
  }

  #alphaStartEnd(value) {
    const alphaBoost = 1 + (this.#intensity() - 1) * 0.12;
    return {
      start: clamp01(Number(value?.start ?? 0.95) * alphaBoost),
      end: clamp01(Number(value?.end ?? 0)),
      ease: 'Cubic.easeOut',
    };
  }

  #scaledDuration(ms) {
    return Math.max(0, Number(ms || 0) / this.#speedFactor());
  }

  #normalizeControls(controls) {
    return {
      intensity: clampNumber(controls.intensity, 0.25, 3, DEFAULT_CONTROLS.intensity),
      scale: clampNumber(controls.scale, 0.45, 2.6, DEFAULT_CONTROLS.scale),
      speed: clampNumber(controls.speed, 0.35, 2.2, DEFAULT_CONTROLS.speed),
      background: ['dark', 'arena', 'alpha'].includes(controls.background)
        ? controls.background
        : DEFAULT_CONTROLS.background,
      mode: controls.mode === 'oneshot' ? 'oneshot' : 'loop',
    };
  }

  #intensity() {
    return this.controls?.intensity ?? DEFAULT_CONTROLS.intensity;
  }

  #scaleFactor() {
    return this.controls?.scale ?? DEFAULT_CONTROLS.scale;
  }

  #speedFactor() {
    return this.controls?.speed ?? DEFAULT_CONTROLS.speed;
  }

  #tints(colors) {
    const list = Array.isArray(colors) && colors.length ? colors : ['#ffffff'];
    return list.map(color => this.#colorInt(color));
  }

  #paletteColor(recipe, index) {
    const palette = Array.isArray(recipe.palette) && recipe.palette.length ? recipe.palette : ['#ffffff'];
    return this.#colorInt(palette[index % palette.length]);
  }

  #colorInt(color) {
    if (typeof color === 'number') return color;
    return Number.parseInt(String(color || '#ffffff').replace('#', ''), 16);
  }

  #textureKey(name) {
    const key = `fx-${name}`;
    return this.textures.exists(key) ? key : 'fx-soft';
  }

  #createTextures() {
    const textureDefs = {
      soft: drawSoft,
      glow: drawGlow,
      spark: drawSpark,
      ring: drawRingTexture,
      shard: drawShard,
      leaf: drawLeaf,
      slash: drawSlashTexture,
      mote: drawMote,
    };
    for (const [name, draw] of Object.entries(textureDefs)) {
      const key = `fx-${name}`;
      if (this.textures.exists(key)) continue;
      this.textures.addCanvas(key, makeTexture(draw));
    }
  }
}

function makeTexture(draw) {
  const canvas = document.createElement('canvas');
  canvas.width = TEXTURE_SIZE;
  canvas.height = TEXTURE_SIZE;
  const ctx = canvas.getContext('2d');
  draw(ctx, TEXTURE_SIZE);
  return canvas;
}

function drawSoft(ctx, size) {
  const gradient = ctx.createRadialGradient(size / 2, size / 2, 2, size / 2, size / 2, size * 0.46);
  gradient.addColorStop(0, 'rgba(255,255,255,1)');
  gradient.addColorStop(0.34, 'rgba(255,255,255,.68)');
  gradient.addColorStop(0.76, 'rgba(255,255,255,.16)');
  gradient.addColorStop(1, 'rgba(255,255,255,0)');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, size, size);
}

function drawGlow(ctx, size) {
  const gradient = ctx.createRadialGradient(size / 2, size / 2, 0, size / 2, size / 2, size * 0.48);
  gradient.addColorStop(0, 'rgba(255,255,255,1)');
  gradient.addColorStop(0.2, 'rgba(255,255,255,.78)');
  gradient.addColorStop(0.72, 'rgba(255,255,255,.22)');
  gradient.addColorStop(1, 'rgba(255,255,255,0)');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, size, size);
}

function drawSpark(ctx, size) {
  ctx.translate(size / 2, size / 2);
  ctx.fillStyle = '#fff';
  ctx.beginPath();
  for (let i = 0; i < 8; i += 1) {
    const radius = i % 2 === 0 ? size * 0.43 : size * 0.09;
    const angle = -Math.PI / 2 + (Math.PI * 2 * i) / 8;
    ctx.lineTo(Math.cos(angle) * radius, Math.sin(angle) * radius);
  }
  ctx.closePath();
  ctx.fill();
}

function drawRingTexture(ctx, size) {
  ctx.strokeStyle = '#fff';
  ctx.lineWidth = size * 0.12;
  ctx.beginPath();
  ctx.arc(size / 2, size / 2, size * 0.32, 0, Math.PI * 2);
  ctx.stroke();
}

function drawShard(ctx, size) {
  ctx.translate(size / 2, size / 2);
  ctx.fillStyle = '#fff';
  ctx.beginPath();
  ctx.moveTo(0, -size * 0.42);
  ctx.lineTo(size * 0.18, size * 0.08);
  ctx.lineTo(0, size * 0.4);
  ctx.lineTo(-size * 0.18, size * 0.08);
  ctx.closePath();
  ctx.fill();
}

function drawLeaf(ctx, size) {
  ctx.translate(size / 2, size / 2);
  ctx.fillStyle = '#fff';
  ctx.beginPath();
  ctx.ellipse(0, 0, size * 0.18, size * 0.42, Math.PI / 5, 0, Math.PI * 2);
  ctx.fill();
}

function drawSlashTexture(ctx, size) {
  ctx.strokeStyle = '#fff';
  ctx.lineWidth = size * 0.12;
  ctx.lineCap = 'round';
  ctx.beginPath();
  ctx.arc(size * 0.52, size * 0.56, size * 0.34, Math.PI * 1.08, Math.PI * 1.72);
  ctx.stroke();
}

function drawMote(ctx, size) {
  ctx.fillStyle = '#fff';
  ctx.beginPath();
  ctx.arc(size / 2, size / 2, size * 0.16, 0, Math.PI * 2);
  ctx.fill();
}

function clampNumber(value, min, max, fallback) {
  const number = Number(value);
  if (!Number.isFinite(number)) return fallback;
  return Math.max(min, Math.min(max, number));
}

function clamp01(value) {
  const number = Number(value);
  if (!Number.isFinite(number)) return 0;
  return Math.max(0, Math.min(1, number));
}
