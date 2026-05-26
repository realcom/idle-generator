// spine-scene.js — Spine WebGL renderer for idle-game-generator
// Replaces the Phaser-based scene.js with actual Spine skeleton animations.
// Expects the global `spine` object from spine-webgl CDN (4.2.x).

const PLAYER_ATTACK_PER_SEC = 80;

// Asset manifest — paths relative to where the HTML is served
const SPINE_ASSETS = {
  Ninster: {
    skel: 'assets/Ninster.skel.bytes',
    atlas: 'assets/Ninster.atlas.txt',
    png: 'assets/Ninster.png',
    scale: 0.45
  },
  melee_slime3_pirate: {
    skel: 'assets/melee_slime3_pirate.skel.bytes',
    atlas: 'assets/melee_slime3_pirate.atlas.txt',
    png: 'assets/melee_slime3_pirate.png',
    scale: 0.16
  },
  Slimequeen: {
    skel: 'assets/Slimequeen.skel.bytes',
    atlas: 'assets/Slimequeen.atlas.txt',
    png: 'assets/Slimequeen.png',
    scale: 0.22
  }
};

// Map unit type/rank to spine asset key
function resolveSpineKey(unit) {
  if (unit.type === 'Boss') return 'Slimequeen';
  return 'melee_slime3_pirate';
}

export class SpineScene {
  constructor(canvasId) {
    this.canvas = document.getElementById(canvasId);
    if (!this.canvas) throw new Error(`Canvas element #${canvasId} not found`);

    this.gl = this.canvas.getContext('webgl', { alpha: true, premultipliedAlpha: false });
    if (!this.gl) throw new Error('WebGL not supported');

    // Spine WebGL rendering objects
    this.shader = spine.Shader.newTwoColoredTextured(this.gl);
    this.batcher = new spine.PolygonBatcher(this.gl);
    this.mvp = new spine.Matrix4();
    this.skeletonRenderer = new spine.SkeletonRenderer(this.gl);
    this.skeletonRenderer.premultipliedAlpha = false;

    // Asset cache: key → SkeletonData
    this.skeletonDataCache = {};

    // Game state
    this.board = null;
    this.engine = null;
    this.playerInst = null; // { skeleton, state }
    this.enemyInstances = new Map(); // unit → { skeleton, state, x, y, fadeStart }
    this.spawnSlot = 0;
    this.statusListeners = [];

    // Timing
    this._lastTime = 0;
    this._lastAttackMs = 0;
    this._running = false;
    this._hidden = false;

    // Handle page visibility for large dt skip
    this._onVisibilityChange = () => {
      this._hidden = document.hidden;
      if (!document.hidden) {
        // Reset timing to prevent massive dt after returning from background
        this._lastTime = performance.now();
        this._lastAttackMs = performance.now();
      }
    };
    document.addEventListener('visibilitychange', this._onVisibilityChange);

    // Initial canvas size
    this._resizeCanvas();
    this._onResize = () => this._resizeCanvas();
    window.addEventListener('resize', this._onResize);
  }

  // ─────── Asset Loading ───────

  async loadAssets() {
    const gl = this.gl;
    const keys = Object.keys(SPINE_ASSETS);

    for (const key of keys) {
      const cfg = SPINE_ASSETS[key];

      // 1. Load atlas text (UTF-8 explicit decode for Korean region names)
      const atlasBuf = await fetch(cfg.atlas).then(r => r.arrayBuffer());
      const atlasText = new TextDecoder('utf-8').decode(atlasBuf);

      // 2. Load PNG texture
      const img = await new Promise((resolve, reject) => {
        const image = new Image();
        image.crossOrigin = 'anonymous';
        image.onload = () => resolve(image);
        image.onerror = reject;
        image.src = cfg.png;
      });

      // 3. Create atlas + bind texture
      const texture = new spine.GLTexture(gl, img);
      const atlas = new spine.TextureAtlas(atlasText);
      atlas.pages.forEach(page => {
        page.texture = texture;
        page.width = img.width;
        page.height = img.height;
        if (typeof page.setTexture === 'function') page.setTexture(texture);
      });
      atlas.regions.forEach(region => {
        region.texture = texture;
        region.page.texture = texture;
      });

      // 4. Load skeleton binary
      const skelBuf = await fetch(cfg.skel).then(r => r.arrayBuffer());
      const attachLoader = new spine.AtlasAttachmentLoader(atlas);
      const skelBinary = new spine.SkeletonBinary(attachLoader);
      skelBinary.scale = cfg.scale;
      const skeletonData = skelBinary.readSkeletonData(new Uint8Array(skelBuf));

      this.skeletonDataCache[key] = skeletonData;
      console.log(`[SpineScene] Loaded: ${key} (${skeletonData.animations.length} animations)`);
    }

    // Create player instance (Ninster)
    this.playerInst = this._makeInstance(this.skeletonDataCache.Ninster);
    // Flip to face right (enemy side)
    this.playerInst.skeleton.scaleX = -Math.abs(this.playerInst.skeleton.scaleX || 1);
    this._tryPlay(this.playerInst.state, ['idle', 'wait', 'stand'], true);
  }

  // ─────── Board Connection ───────

  setBoard(board, engine) {
    this.board = board;
    this.engine = engine;

    // Wire up board events
    board.on('unitSpawned', unit => this.onUnitSpawned(unit));
    board.on('unitDied', unit => this.onUnitDied(unit));

    // Expose ourselves to the board as the scene
    board.scene = this;
  }

  // ─────── Lifecycle ───────

  start() {
    if (this._running) return;
    this._running = true;
    this._lastTime = performance.now();
    this._lastAttackMs = performance.now();
    this.spawnSlot = 0;

    // Bootstrap map triggers via engine
    if (this.engine && this.board && this.board.currentMap) {
      this.board.boardState = 1;
      this.engine.bootstrapMap(this.board.currentMap);
    }

    requestAnimationFrame(now => this._loop(now));
  }

  stop() {
    this._running = false;
    document.removeEventListener('visibilitychange', this._onVisibilityChange);
    window.removeEventListener('resize', this._onResize);
  }

  // ─────── Board Event Handlers ───────

  onUnitSpawned(unit) {
    const spineKey = resolveSpineKey(unit);
    const skeletonData = this.skeletonDataCache[spineKey];
    if (!skeletonData) {
      console.warn(`[SpineScene] No skeleton data for key: ${spineKey}`);
      return;
    }

    const inst = this._makeInstance(skeletonData);
    const isBoss = unit.type === 'Boss';

    // Position: right side of canvas, spread out per spawn slot
    const canvasW = this.canvas.width;
    const canvasH = this.canvas.height;
    const x = isBoss
      ? canvasW * 0.7
      : canvasW * 0.55 + (this.spawnSlot % 4) * 90;
    const y = canvasH * 0.18;
    this.spawnSlot++;

    inst.skeleton.x = x;
    inst.skeleton.y = y;

    // Enemies face left (toward the player)
    inst.skeleton.scaleX = Math.abs(inst.skeleton.scaleX || 1);

    // Boss: scale up
    if (isBoss) {
      const factor = 1.5;
      inst.skeleton.scaleX *= factor;
      inst.skeleton.scaleY *= factor;
    }

    // Play idle animation
    this._tryPlay(inst.state, ['idle', 'wait', 'stand'], true);

    this.enemyInstances.set(unit, { inst, x, y, fadeStart: null });
  }

  onUnitDied(unit) {
    const entry = this.enemyInstances.get(unit);
    if (!entry) return;

    // Trigger death animation if available
    const anims = entry.inst.state.data.skeletonData.animations.map(a => a.name);
    const deadAnim = anims.find(a => /dead|die|death/i.test(a));
    if (deadAnim) {
      entry.inst.state.setAnimation(0, deadAnim, false);
    }
    entry.fadeStart = performance.now();
  }

  // Reset spawn slots between waves (called externally or on wave events)
  resetSpawnSlots() {
    this.spawnSlot = 0;
  }

  // ─────── Game Tick (auto-combat) ───────

  tick(nowMs) {
    if (!this.board || this.board.gameEnded) return;

    // Trigger engine tick
    if (this.engine) {
      this.engine.tick(nowMs);
    }

    // Player auto-attack: target first alive enemy
    const aliveEnemies = this.board.units.filter(u => u.alive && u.team === 1);
    if (aliveEnemies.length > 0) {
      const target = aliveEnemies[0];
      const dt = (nowMs - this._lastAttackMs) / 1000;
      this._lastAttackMs = nowMs;
      const dmg = PLAYER_ATTACK_PER_SEC * dt;
      target.hp = Math.max(0, target.hp - dmg);

      // Trigger player attack animation occasionally (every ~0.5s to avoid spam)
      if (Math.random() < dt * 2) {
        this._triggerAttack(this.playerInst);
      }

      // Show damage float
      const entry = this.enemyInstances.get(target);
      if (entry && dmg > 1) {
        this._showFloat(entry.x, entry.y - 80, Math.round(dmg).toString(), '#f87171');
      }

      // Kill check
      if (target.hp <= 0) {
        this.board.removeUnit(target);
      }
    } else {
      this._lastAttackMs = nowMs;
    }

    // Update HP bars
    this._updateHpBars();
  }

  // ─────── Internal: Render Loop ───────

  _loop(now) {
    if (!this._running) return;

    // Compute delta, cap at 100ms to prevent huge jumps
    let delta = (now - this._lastTime) / 1000;
    if (delta > 0.1) delta = 0.016; // Skip large gaps (e.g., after background tab)
    this._lastTime = now;

    // Skip rendering if page hidden
    if (!this._hidden) {
      this.tick(now);
      this._render(delta);
    }

    requestAnimationFrame(t => this._loop(t));
  }

  _render(delta) {
    const gl = this.gl;
    const canvas = this.canvas;

    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    this.mvp.ortho2d(0, 0, canvas.width - 1, canvas.height - 1);
    this.shader.bind();
    this.shader.setUniformi(spine.Shader.SAMPLER, 0);
    this.shader.setUniform4x4f(spine.Shader.MVP_MATRIX, this.mvp.values);

    this.batcher.begin(this.shader);

    // Draw player
    if (this.playerInst) {
      const playerSkel = this.playerInst.skeleton;
      const playerState = this.playerInst.state;

      playerSkel.x = canvas.width * 0.22;
      playerSkel.y = canvas.height * 0.15;

      playerState.update(delta);
      playerState.apply(playerSkel);
      playerSkel.updateWorldTransform(spine.Physics.update);
      this.skeletonRenderer.draw(this.batcher, playerSkel);
    }

    // Draw enemies
    const now = performance.now();
    for (const [unit, entry] of this.enemyInstances) {
      if (!entry.inst) continue;

      const { inst, fadeStart } = entry;

      // Fade-out for dead units
      if (fadeStart !== null) {
        const elapsed = (now - fadeStart) / 600;
        if (elapsed >= 1) {
          // Fully faded, remove from map
          this.enemyInstances.delete(unit);
          continue;
        }
        inst.skeleton.color.a = 1 - elapsed;
      }

      inst.state.update(delta);
      inst.state.apply(inst.skeleton);
      inst.skeleton.updateWorldTransform(spine.Physics.update);
      this.skeletonRenderer.draw(this.batcher, inst.skeleton);
    }

    this.batcher.end();
    this.shader.unbind();
  }

  // ─────── Internal: HP Bars (DOM overlay) ───────

  _updateHpBars() {
    for (const [unit, entry] of this.enemyInstances) {
      if (!unit.alive) continue;

      // Create HP bar element if not present
      if (!entry.hpBarEl) {
        const bar = document.createElement('div');
        bar.style.cssText = `
          position: absolute;
          width: 50px;
          height: 5px;
          background: #333;
          border-radius: 3px;
          overflow: hidden;
          pointer-events: none;
        `;
        const fill = document.createElement('div');
        fill.style.cssText = `
          width: 100%;
          height: 100%;
          background: #f87171;
          transition: width 0.1s;
        `;
        bar.appendChild(fill);

        const stageWrap = document.getElementById('stageWrap');
        if (stageWrap) {
          stageWrap.appendChild(bar);
        }
        entry.hpBarEl = bar;
        entry.hpFillEl = fill;
      }

      // Position the HP bar above the enemy
      const pct = Math.max(0, unit.hp / unit.maxHp);
      entry.hpFillEl.style.width = (pct * 100) + '%';

      // Convert skeleton position to CSS position
      // Canvas coordinate system: Y=0 at bottom, increases upward in ortho2d
      // DOM coordinate system: Y=0 at top
      const canvasRect = this.canvas.getBoundingClientRect();
      const scaleX = canvasRect.width / this.canvas.width;
      const scaleY = canvasRect.height / this.canvas.height;

      const domX = entry.x * scaleX - 25; // center the 50px bar
      const domY = (this.canvas.height - entry.y) * scaleY - 60; // above the unit

      entry.hpBarEl.style.left = domX + 'px';
      entry.hpBarEl.style.top = domY + 'px';
    }
  }

  // ─────── Internal: Floating Damage Text ───────

  _showFloat(x, y, text, color) {
    const layer = document.getElementById('floatsLayer');
    if (!layer) return;

    const div = document.createElement('div');
    div.className = 'float-text';
    div.textContent = text;
    div.style.color = color;
    div.style.fontWeight = 'bold';
    div.style.fontSize = '14px';
    div.style.textShadow = '0 1px 2px rgba(0,0,0,0.8)';
    div.style.position = 'absolute';
    div.style.pointerEvents = 'none';
    div.style.whiteSpace = 'nowrap';

    // Convert canvas coords to DOM coords
    const canvasRect = this.canvas.getBoundingClientRect();
    const scaleX = canvasRect.width / this.canvas.width;
    const scaleY = canvasRect.height / this.canvas.height;

    div.style.left = (x * scaleX) + 'px';
    div.style.top = ((this.canvas.height - y) * scaleY) + 'px';
    div.style.transform = 'translateX(-50%)';
    div.style.animation = 'floatUp 0.9s ease-out forwards';

    layer.appendChild(div);
    setTimeout(() => div.remove(), 900);
  }

  // ─────── Internal: Spine Helpers ───────

  _makeInstance(skeletonData) {
    const skeleton = new spine.Skeleton(skeletonData);

    // Set skin + setup pose (required for attachments to display)
    if (skeletonData.defaultSkin) {
      skeleton.setSkin(skeletonData.defaultSkin);
    } else if (skeletonData.skins && skeletonData.skins.length > 0) {
      skeleton.setSkin(skeletonData.skins[0]);
    }
    skeleton.setSlotsToSetupPose();

    const stateData = new spine.AnimationStateData(skeletonData);
    stateData.defaultMix = 0.15;
    const state = new spine.AnimationState(stateData);

    return { skeleton, state };
  }

  _tryPlay(state, candidates, loop = true) {
    if (!state || !state.data || !state.data.skeletonData) return null;
    const anims = state.data.skeletonData.animations.map(a => a.name);
    for (const cand of candidates) {
      const found = anims.find(a => a.toLowerCase().includes(cand.toLowerCase()));
      if (found) {
        state.setAnimation(0, found, loop);
        return found;
      }
    }
    // Fallback: first animation
    if (anims.length) {
      state.setAnimation(0, anims[0], loop);
      return anims[0];
    }
    return null;
  }

  _triggerAttack(inst) {
    if (!inst || !inst.state) return;
    const anims = inst.state.data.skeletonData.animations.map(a => a.name);
    const attackAnim = anims.find(a => /attack|atk|hit/i.test(a));
    if (attackAnim) {
      inst.state.setAnimation(0, attackAnim, false);
      // Queue return to idle after attack completes
      const idleAnim = anims.find(a => /idle|wait|stand/i.test(a)) || anims[0];
      inst.state.addAnimation(0, idleAnim, true, 0);
    }
  }

  // ─────── Internal: Canvas Sizing ───────

  _resizeCanvas() {
    const stageWrap = document.getElementById('stageWrap');
    if (!stageWrap) return;
    const rect = stageWrap.getBoundingClientRect();
    this.canvas.width = rect.width;
    this.canvas.height = rect.height;
    this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
  }

  // ─────── Status Listeners (compatibility with main.js pattern) ───────

  onStatus(fn) { this.statusListeners.push(fn); }

  _notifyStatus() {
    this.statusListeners.forEach(fn => fn({ type: 'status' }));
  }
}
