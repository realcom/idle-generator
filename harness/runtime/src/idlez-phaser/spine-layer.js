import { TEAM } from './constants.js';

const WORLD_WIDTH = 920;
const WORLD_HEIGHT = 840;

const SPINE_ASSETS = {
  Ninster: {
    skel: 'assets/Ninster.skel.bytes',
    atlas: 'assets/Ninster.atlas.txt',
    png: 'assets/Ninster.png',
    scale: 0.225,
  },
  melee_slime3_pirate: {
    skel: 'assets/melee_slime3_pirate.skel.bytes',
    atlas: 'assets/melee_slime3_pirate.atlas.txt',
    png: 'assets/melee_slime3_pirate.png',
    scale: 0.18,
  },
  DegulRock: {
    skel: 'assets/monsters/DegulRock.skel.bytes',
    atlas: 'assets/monsters/DegulRock.atlas.txt',
    png: 'assets/monsters/DegulRock.png',
    scale: 0.16,
  },
  large_melee_slime: {
    skel: 'assets/monsters/large_melee_slime.skel.bytes',
    atlas: 'assets/monsters/large_melee_slime.atlas.txt',
    png: 'assets/monsters/large_melee_slime.png',
    scale: 0.18,
  },
  large_melee_wood_golem: {
    skel: 'assets/monsters/large_melee_wood_golem.skel.bytes',
    atlas: 'assets/monsters/large_melee_wood_golem.atlas.txt',
    png: 'assets/monsters/large_melee_wood_golem.png',
    scale: 0.18,
  },
  large_melee_bear: {
    skel: 'assets/monsters/large_melee_bear.skel.bytes',
    atlas: 'assets/monsters/large_melee_bear.atlas.txt',
    png: 'assets/monsters/large_melee_bear.png',
    scale: 0.18,
  },
  large_melee_oni_shield: {
    skel: 'assets/monsters/large_melee_oni_shield.skel.bytes',
    atlas: 'assets/monsters/large_melee_oni_shield.atlas.txt',
    png: 'assets/monsters/large_melee_oni_shield.png',
    scale: 0.18,
  },
  elite_midboss_melee_ghost_female: {
    skel: 'assets/monsters/elite_midboss_melee_ghost_female.skel.bytes',
    atlas: 'assets/monsters/elite_midboss_melee_ghost_female.atlas.txt',
    png: 'assets/monsters/elite_midboss_melee_ghost_female.png',
    scale: 0.18,
  },
  ranged_ghost_bow: {
    skel: 'assets/monsters/ranged_ghost_bow.skel.bytes',
    atlas: 'assets/monsters/ranged_ghost_bow.atlas.txt',
    png: 'assets/monsters/ranged_ghost_bow.png',
    scale: 0.18,
  },
  melle_slime3: {
    skel: 'assets/monsters/melle_slime3.skel.bytes',
    atlas: 'assets/monsters/melle_slime3.atlas.txt',
    png: 'assets/monsters/melle_slime3.png',
    scale: 0.18,
  },
  melee_jellyfish: {
    skel: 'assets/monsters/melee_jellyfish.skel.bytes',
    atlas: 'assets/monsters/melee_jellyfish.atlas.txt',
    png: 'assets/monsters/melee_jellyfish.png',
    scale: 0.18,
  },
  ranged_pine_cone: {
    skel: 'assets/monsters/ranged_pine_cone.skel.bytes',
    atlas: 'assets/monsters/ranged_pine_cone.atlas.txt',
    png: 'assets/monsters/ranged_pine_cone.png',
    scale: 0.18,
  },
  ranged_oni_cowboy: {
    skel: 'assets/monsters/ranged_oni_cowboy.skel.bytes',
    atlas: 'assets/monsters/ranged_oni_cowboy.atlas.txt',
    png: 'assets/monsters/ranged_oni_cowboy.png',
    scale: 0.17,
  },
  finalboss_melee_oni_pirate_boss: {
    skel: 'assets/monsters/finalboss_melee_oni_pirate_boss.skel.bytes',
    atlas: 'assets/monsters/finalboss_melee_oni_pirate_boss.atlas.txt',
    png: 'assets/monsters/finalboss_melee_oni_pirate_boss.png',
    scale: 0.16,
  },
  Slimequeen: {
    skel: 'assets/Slimequeen.skel.bytes',
    atlas: 'assets/Slimequeen.atlas.txt',
    png: 'assets/Slimequeen.png',
    scale: 0.22,
  },
};

export class IdlezSpineLayer {
  constructor(canvasId, board) {
    if (!globalThis.spine) throw new Error('spine-webgl runtime is not loaded');

    this.canvas = document.getElementById(canvasId);
    if (!this.canvas) throw new Error(`Canvas #${canvasId} not found`);

    this.board = board;
    this.gl = this.canvas.getContext('webgl', { alpha: true, premultipliedAlpha: false });
    if (!this.gl) throw new Error('WebGL not supported');

    this.shader = spine.Shader.newTwoColoredTextured(this.gl);
    this.batcher = new spine.PolygonBatcher(this.gl);
    this.mvp = new spine.Matrix4();
    this.skeletonRenderer = new spine.SkeletonRenderer(this.gl);
    this.skeletonRenderer.premultipliedAlpha = false;

    this.cache = {};
    this.instances = new Map();
    this.lastTimeMs = performance.now();

    this.resize = this.resize.bind(this);
    this.render = this.render.bind(this);
    window.addEventListener('resize', this.resize);
    this.resize();
    this.#bindBoard();
  }

  async loadAssets() {
    for (const [key, cfg] of Object.entries(SPINE_ASSETS)) {
      this.cache[key] = await this.#loadSkeletonData(cfg);
      console.log(`[IdlezSpineLayer] ${key}: ${this.cache[key].animations.length} animations`);
    }
  }

  start() {
    this.lastTimeMs = performance.now();
    requestAnimationFrame(this.render);
  }

  resize() {
    const parent = this.canvas.parentElement;
    const rect = parent.getBoundingClientRect();
    const dpr = Math.max(1, Math.min(2, window.devicePixelRatio || 1));
    this.canvas.width = Math.max(1, Math.floor(rect.width * dpr));
    this.canvas.height = Math.max(1, Math.floor(rect.height * dpr));
    this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
  }

  render(nowMs = performance.now()) {
    const delta = Math.min(0.08, (nowMs - this.lastTimeMs) / 1000);
    this.lastTimeMs = nowMs;
    this.#syncLiveUnits();
    this.#draw(delta);
    requestAnimationFrame(this.render);
  }

  getUnitWorldBounds(unit) {
    const inst = this.#ensureUnit(unit);
    if (!inst || !this.canvas.width || !this.canvas.height) return null;

    const pos = this.#toSpineCanvasPosition(unit.x, unit.y);
    inst.skeleton.x = pos.x;
    inst.skeleton.y = pos.y;
    inst.state.apply(inst.skeleton);
    inst.skeleton.updateWorldTransform(spine.Physics?.update);

    const offset = new spine.Vector2();
    const size = new spine.Vector2();
    inst.skeleton.getBounds(offset, size);
    if (!Number.isFinite(size.x) || !Number.isFinite(size.y) || size.x <= 0 || size.y <= 0) return null;

    const left = (offset.x / this.canvas.width) * WORLD_WIDTH;
    const right = ((offset.x + size.x) / this.canvas.width) * WORLD_WIDTH;
    const top = WORLD_HEIGHT - ((offset.y + size.y) / this.canvas.height) * WORLD_HEIGHT;
    const bottom = WORLD_HEIGHT - (offset.y / this.canvas.height) * WORLD_HEIGHT;
    return {
      left,
      right,
      top,
      bottom,
      width: right - left,
      height: bottom - top,
    };
  }

  #bindBoard() {
    this.board.on('boardStarted', () => this.instances.clear());
    this.board.on('unitSpawned', unit => this.#ensureUnit(unit));
    this.board.on('unitDied', ({ unit }) => this.#playDeath(unit));
    this.board.on('unitRevived', unit => {
      const inst = this.#ensureUnit(unit);
      inst.skeleton.color.a = 1;
      this.#play(inst, ['idle', 'wait', 'stand'], true);
    });
    this.board.on('unitAttack', ({ unit }) => {
      const inst = this.#ensureUnit(unit);
      this.#triggerAttack(inst);
    });
    this.board.on('skillFx', ({ skill }) => {
      const inst = this.#ensureUnit(skill.owner);
      this.#triggerAttack(inst);
    });
  }

  #syncLiveUnits() {
    for (const unit of this.board.units.values()) {
      if (!unit.alive && unit.team !== TEAM.PLAYER) continue;
      this.#ensureUnit(unit);
    }
  }

  #ensureUnit(unit) {
    if (this.instances.has(unit.id)) return this.instances.get(unit.id);

    const key = this.#resolveSpineKey(unit);
    const data = this.cache[key];
    if (!data) return null;

    const inst = this.#makeInstance(data);
    inst.unit = unit;
    inst.fadeStartedAt = null;
    inst.dead = false;
    this.instances.set(unit.id, inst);

    if (unit.team === TEAM.PLAYER) {
      inst.skeleton.scaleX = -Math.abs(inst.skeleton.scaleX || 1) * 1.45;
      inst.skeleton.scaleY = Math.abs(inst.skeleton.scaleY || 1) * 1.45;
    } else if (unit.type === 'Boss') {
      inst.skeleton.scaleX = Math.abs(inst.skeleton.scaleX || 1) * 1.25;
      inst.skeleton.scaleY = Math.abs(inst.skeleton.scaleY || 1) * 1.25;
    } else {
      inst.skeleton.scaleX = Math.abs(inst.skeleton.scaleX || 1) * 1.12;
      inst.skeleton.scaleY = Math.abs(inst.skeleton.scaleY || 1) * 1.12;
    }

    this.#play(inst, unit.state === 'approaching' ? ['walk', 'run', 'move', 'idle'] : ['idle', 'wait', 'stand'], true);
    return inst;
  }

  #draw(delta) {
    const gl = this.gl;
    const c = this.canvas;
    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    this.mvp.ortho2d(0, 0, c.width - 1, c.height - 1);
    this.shader.bind();
    this.shader.setUniformi(spine.Shader.SAMPLER, 0);
    this.shader.setUniform4x4f(spine.Shader.MVP_MATRIX, this.mvp.values);
    this.batcher.begin(this.shader);

    const entries = [...this.instances.values()].sort((a, b) => a.unit.y - b.unit.y);
    const now = performance.now();
    for (const inst of entries) {
      const unit = inst.unit;
      if (!unit) continue;

      const pos = this.#toSpineCanvasPosition(unit.x, unit.y);
      inst.skeleton.x = pos.x;
      inst.skeleton.y = pos.y;

      if (unit.alive && unit.state === 'approaching' && !inst.dead) {
        this.#playIfNot(inst, ['walk', 'run', 'move', 'idle'], true);
      } else if (unit.alive && !inst.dead) {
        this.#playIfNot(inst, ['idle', 'wait', 'stand'], true);
      }

      if (!unit.alive && unit.team !== TEAM.PLAYER && inst.fadeStartedAt != null) {
        const t = (now - inst.fadeStartedAt) / 650;
        if (t >= 1) {
          this.instances.delete(unit.id);
          continue;
        }
        inst.skeleton.color.a = 1 - t;
      } else if (!unit.alive && unit.team === TEAM.PLAYER) {
        inst.skeleton.color.a = 0.42;
      } else {
        inst.skeleton.color.a = 1;
      }

      inst.state.update(delta);
      inst.state.apply(inst.skeleton);
      inst.skeleton.updateWorldTransform(spine.Physics?.update);
      this.skeletonRenderer.draw(this.batcher, inst.skeleton);
    }

    this.batcher.end();
    this.shader.unbind();
  }

  #toSpineCanvasPosition(x, y) {
    return {
      x: (x / WORLD_WIDTH) * this.canvas.width,
      y: this.canvas.height - (y / WORLD_HEIGHT) * this.canvas.height,
    };
  }

  #resolveSpineKey(unit) {
    if (unit.team === TEAM.PLAYER) return 'Ninster';
    const spriteName = basenameWithoutExtension(unit.def?.sprite);
    if (spriteName && SPINE_ASSETS[spriteName]) return spriteName;
    if (unit.type === 'Boss') return 'Slimequeen';
    return 'melee_slime3_pirate';
  }

  async #loadSkeletonData(cfg) {
    const gl = this.gl;
    const [atlasText, image, skelBytes] = await Promise.all([
      fetch(cfg.atlas).then(r => r.text()),
      loadImage(cfg.png),
      fetch(cfg.skel).then(r => r.arrayBuffer()),
    ]);

    const texture = new spine.GLTexture(gl, image);
    const atlas = new spine.TextureAtlas(atlasText);
    atlas.pages.forEach(page => {
      page.texture = texture;
      page.width = image.width;
      page.height = image.height;
    });
    atlas.regions.forEach(region => {
      region.texture = texture;
      region.page.texture = texture;
    });

    const loader = new spine.AtlasAttachmentLoader(atlas);
    const binary = new spine.SkeletonBinary(loader);
    binary.scale = cfg.scale;
    return binary.readSkeletonData(new Uint8Array(skelBytes));
  }

  #makeInstance(data) {
    const skeleton = new spine.Skeleton(data);
    if (data.defaultSkin) skeleton.setSkin(data.defaultSkin);
    else if (data.skins?.length) skeleton.setSkin(data.skins[0]);
    skeleton.setSlotsToSetupPose();

    const stateData = new spine.AnimationStateData(data);
    stateData.defaultMix = 0.15;
    return { skeleton, state: new spine.AnimationState(stateData), currentBase: null };
  }

  #playIfNot(inst, candidates, loop) {
    const next = this.#findAnimation(inst, candidates);
    if (!next || inst.currentBase === next) return next;
    inst.state.setAnimation(0, next, loop);
    inst.currentBase = next;
    return next;
  }

  #play(inst, candidates, loop) {
    const next = this.#findAnimation(inst, candidates);
    if (!next) return null;
    inst.state.setAnimation(0, next, loop);
    inst.currentBase = loop ? next : null;
    return next;
  }

  #triggerAttack(inst) {
    if (!inst) return;
    const attack = this.#findAnimation(inst, ['attack', 'atk', 'hit']);
    const idle = this.#findAnimation(inst, ['idle', 'wait', 'stand']);
    if (!attack) return;
    inst.state.setAnimation(0, attack, false);
    if (idle) inst.state.addAnimation(0, idle, true, 0);
    inst.currentBase = idle;
  }

  #playDeath(unit) {
    const inst = this.instances.get(unit.id);
    if (!inst) return;
    inst.dead = true;
    const death = this.#findAnimation(inst, ['dead', 'die', 'death']);
    if (death) inst.state.setAnimation(0, death, false);
    if (unit.team !== TEAM.PLAYER) inst.fadeStartedAt = performance.now();
  }

  #findAnimation(inst, candidates) {
    const names = inst.state.data.skeletonData.animations.map(animation => animation.name);
    for (const candidate of candidates) {
      const found = names.find(name => name.toLowerCase().includes(candidate.toLowerCase()));
      if (found) return found;
    }
    return names[0] || null;
  }
}

function basenameWithoutExtension(path) {
  const filename = String(path || '').split('/').pop() || '';
  return filename.replace(/\.[^.]+$/, '');
}

function loadImage(src) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.crossOrigin = 'anonymous';
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = src;
  });
}
